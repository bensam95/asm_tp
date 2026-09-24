global _start

section .text
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 64
    syscall

    cmp rax, 0
    jle erreur

    mov r12, rax
    mov r15, 0
    mov rbx, 0
    mov r14, 0

    cmp byte [buffer], '-'
    jne loop
    mov r14, 1
    inc r15
    cmp r15, r12
    jge erreur

loop:
    mov al, byte [buffer + r15]
    cmp al, 10
    je test_nombre

    cmp al, '0'
    jl erreur
    cmp al, '9'
    jg erreur

    sub al, '0'
    imul rbx, 10

    mov r8, 0
    mov r8b, al
    add rbx, r8

    inc r15
    cmp r15, r12
    jl loop

test_nombre:
    cmp r15, 0
    je erreur

    cmp r14, 1
    je impair

    cmp rbx, 2
    jl impair

    mov rcx, 2

div_loop:
    mov rax, rcx
    imul rax, rcx
    cmp rax, rbx
    jg pair

    mov rax, rbx
    mov rdx, 0
    div rcx
    cmp rdx, 0
    je impair

    inc rcx
    jmp div_loop

pair:
    mov rax, 60
    mov rdi, 0
    syscall

impair:
    mov rax, 60
    mov rdi, 1
    syscall

erreur:
    mov rax, 60
    mov rdi, 2
    syscall

section .bss
    buffer resb 64