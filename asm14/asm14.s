global _start
section .text
_start:
    cmp byte [rsp], 2
    jne usage_error

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, 577
    mov rdx, 0644o
    syscall

    cmp rax, 0
    jl error

    mov rdi, rax
    mov rax, 1
    mov rsi, string
    mov rdx, stringLen
    syscall

    success:
        mov rax, 60
        xor rdi, rdi
        syscall

    error:
        mov rax, 60
        mov rdi, 1
        syscall

    usage_error:
        mov rax, 60
        mov rdi, 2
        syscall

section .data
    string: db "Hello Universe!", 10