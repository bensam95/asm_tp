section .data
    msg db "Hello Universe!"
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne mauvais_arguments

    mov rdi, [rsp + 16]
    mov rax, 2
    mov rsi, 0x241
    mov rdx, 0o644
    syscall
    test rax, rax
    js erreur_fichier

    mov r12, rax

    mov rax, 1
    mov rdi, r12
    mov rsi, msg
    mov rdx, len
    syscall
    cmp rax, len
    jne erreur_apres_ouverture

    mov rax, 3
    mov rdi, r12
    syscall
    test rax, rax
    js erreur_fichier

    mov rax, 60
    xor rdi, rdi
    syscall

erreur_apres_ouverture:
    mov rax, 3
    mov rdi, r12
    syscall

erreur_fichier:
    mov rax, 60
    mov rdi, 1
    syscall

mauvais_arguments:
    mov rax, 60
    mov rdi, 2
    syscall