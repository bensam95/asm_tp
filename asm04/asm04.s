section .data

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 256
    syscall
     
    cmp qword [rsp], 2
    jne _error

    mov rsi, [rsp + 16]

    cmp byte [rsi], '4'       
    jne _error
    cmp byte [rsi + 1], '2'   
    jne _error
    cmp byte [rsi + 2], 0     
    jne _error

_end:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 5
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rax, 60
    mov rdi, 1
    syscall

_err
    mov rax, 60
    mov rdi, 2
    syscall