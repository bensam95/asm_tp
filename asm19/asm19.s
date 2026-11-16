section .data
    nom_fichier db "messages", 0
    texte db "Listening on port 1337", 10
    taille_texte equ $ - texte

    adresse:
        dw 2
        db 0x05, 0x39
        dd 0
        dq 0

section .bss
    message resb 65536

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

    mov rax, 49
    mov rdi, r12
    mov rsi, adresse
    mov rdx, 16
    syscall
    cmp rax, 0
    jl erreur

    mov rax, 2
    mov rdi, nom_fichier
    mov rsi, 0x241
    mov rdx, 420
    syscall
    cmp rax, 0
    jl erreur

    mov rdi, rax
    mov rax, 3
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, texte
    mov rdx, taille_texte
    syscall

attendre:
    mov rax, 45
    mov rdi, r12
    mov rsi, message
    mov rdx, 65536
    mov r10, 0
    mov r8, 0
    mov r9, 0
    syscall
    cmp rax, -4
    je attendre
    cmp rax, 0
    jl erreur
    je attendre

    mov r13, rax

    mov rax, 2
    mov rdi, nom_fichier
    mov rsi, 0x441
    mov rdx, 420
    syscall
    cmp rax, 0
    jl attendre
    mov r14, rax

    mov rsi, message
    mov rdx, r13

ecrire:
    mov rax, 1
    mov rdi, r14
    syscall
    cmp rax, -4
    je ecrire
    cmp rax, 0
    jle fermer
    add rsi, rax
    sub rdx, rax
    jnz ecrire

fermer:
    mov rax, 3
    mov rdi, r14
    syscall
    jmp attendre

erreur:
    mov rax, 60
    mov rdi, 1
    syscall