section .bss
    tampon resb 4096

section .data
    nouveau db "H4CK"

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne erreur_usage

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, 2
    mov rdx, 0
    syscall
    cmp rax, 0
    jl erreur_fichier

    mov r12, rax
    mov r13, 0
    mov r14, 0

lire_bloc:
    mov rax, 17
    mov rdi, r12
    mov rsi, tampon
    mov rdx, 4096
    mov r10, r13
    syscall

    cmp rax, -4
    je lire_bloc
    cmp rax, 0
    jl erreur_fichier
    cmp rax, 4
    jl fin

    mov r15, rax
    mov rbp, r15
    sub rbp, 3
    mov rbx, 0

chercher:
    cmp rbx, rbp
    jge bloc_suivant
    cmp dword [tampon + rbx], 0x37333331
    jne position_suivante

ecrire:
    mov rax, 18
    mov rdi, r12
    mov rsi, nouveau
    mov rdx, 4
    mov r10, r13
    add r10, rbx
    syscall

    cmp rax, -4
    je ecrire
    cmp rax, 4
    jne erreur_fichier
    inc r14

position_suivante:
    inc rbx
    jmp chercher

bloc_suivant:
    add r13, r15
    sub r13, 3
    jmp lire_bloc

fin:
    cmp r14, 0
    je erreur_fichier

    mov rax, 60
    mov rdi, 0
    syscall

erreur_fichier:
    mov rax, 60
    mov rdi, 1
    syscall

erreur_usage:
    mov rax, 60
    mov rdi, 2
    syscall