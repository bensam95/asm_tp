section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne erreur_usage

    mov r12, [rsp + 16]
    mov r13, 0

compter:
    cmp byte [r12 + r13], 0
    je taille_connue
    inc r13
    jmp compter

taille_connue:
    mov rax, 9
    mov rdi, 0
    mov rsi, r13
    mov rdx, 7
    mov r10, 0x22
    mov r8, -1
    mov r9, 0
    syscall
    cmp rax, 0
    jl erreur_fichier

    mov r14, rax

    mov rsi, r12
    mov rdi, r14
    mov rcx, r13
    cld
    rep movsb

    jmp r14

erreur_fichier:
    mov rax, 60
    mov rdi, 1
    syscall

erreur_usage:
    mov rax, 60
    mov rdi, 2
    syscall