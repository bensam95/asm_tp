section .bss
    entete resb 20

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne erreur_usage

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, 0
    mov rdx, 0
    syscall
    cmp rax, 0
    jl erreur_usage

    mov r12, rax
    mov r13, 0

lire:
    mov rax, 0
    mov rdi, r12
    mov rsi, entete
    add rsi, r13
    mov rdx, 20
    sub rdx, r13
    syscall

    cmp rax, -4
    je lire
    cmp rax, 0
    jl erreur_usage
    je verifier

    add r13, rax
    cmp r13, 20
    jl lire

verifier:
    cmp r13, 20
    jl pas_elf

    cmp byte [entete], 0x7f
    jne pas_elf
    cmp byte [entete + 1], 'E'
    jne pas_elf
    cmp byte [entete + 2], 'L'
    jne pas_elf
    cmp byte [entete + 3], 'F'
    jne pas_elf
    cmp byte [entete + 4], 2
    jne pas_elf
    cmp byte [entete + 5], 1
    jne pas_elf
    cmp word [entete + 18], 0x3e
    jne pas_elf

    mov rax, 60
    mov rdi, 0
    syscall

pas_elf:
    mov rax, 60
    mov rdi, 1
    syscall

erreur_usage:
    mov rax, 60
    mov rdi, 2
    syscall