section .data
    requete db "Hello", 10
    taille_requete equ $ - requete

    adresse:
        dw 2
        db 0x05, 0x39
        db 127, 0, 0, 1
        dq 0

    delai:
        dq 1
        dq 0

section .bss
    reponse resb 65536

section .text
    global _start

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 2
    mov rdx, 0
    syscall
    cmp rax, 0
    jl erreur
    mov r12, rax

    mov rax, 54
    mov rdi, r12
    mov rsi, 1
    mov rdx, 20
    mov r10, delai
    mov r8, 16
    syscall
    cmp rax, 0
    jl erreur

envoyer:
    mov rax, 44
    mov rdi, r12
    mov rsi, requete
    mov rdx, taille_requete
    mov r10, 0
    mov r8, adresse
    mov r9, 16
    syscall
    cmp rax, -4
    je envoyer
    cmp rax, taille_requete
    jne erreur

recevoir:
    mov rax, 45
    mov rdi, r12
    mov rsi, reponse
    mov rdx, 65536
    mov r10, 0
    mov r8, 0
    mov r9, 0
    syscall
    cmp rax, -4
    je recevoir
    cmp rax, 0
    jl erreur

    mov rdx, rax
    mov rsi, reponse
    cmp rdx, 0
    je fin_ok

ecrire:
    mov rax, 1
    mov rdi, 1
    syscall
    cmp rax, -4
    je ecrire
    cmp rax, 0
    jle erreur
    add rsi, rax
    sub rdx, rax
    jnz ecrire

fin_ok:
    mov rax, 60
    mov rdi, 0
    syscall

erreur:
    mov rax, 60
    mov rdi, 1
    syscall