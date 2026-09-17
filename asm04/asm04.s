global _start

section .text
_start:
    xor r8d, r8d
    xor r9b, r9b
    xor r10d, r10d

readchar:
    mov rax, 0
    mov rdi, 0
    mov rsi, char
    mov rdx, 1
    syscall

    test rax, rax
    jle finish

    movzx eax, byte [char]

    cmp al, 10
    je finish
    cmp al, 13
    je finish

    inc r10d

    cmp al, '-'
    je handle_sign
    cmp al, '+'
    je handle_sign

    cmp al, '0'
    jb usage_error
    cmp al, '9'
    ja usage_error

    inc r8d
    mov r9b, al
    jmp readchar

handle_sign:
    cmp r10d, 1
    jne usage_error
    jmp readchar

finish:
    test r8d, r8d
    jz usage_error

    test r9b, 1
    jnz is_odd

    mov rax, 60
    xor rdi, rdi
    syscall

is_odd:
    mov rax, 60
    mov rdi, 1
    syscall

usage_error:
    mov rax, 60
    mov rdi, 2
    syscall

section .bss
    char resb 1