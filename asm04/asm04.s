global _start
section .text
_start:
    mov bl, 'a'
    mov dword [count], 0

    readchar:
        mov rax, 0
        mov rdi, 0
        mov rsi, char
        mov rdx, 1
        syscall

    cmp rax, 0
    je check

    cmp byte [char], 10
    je check

    cmp dword [count], 512
    jge usage_error
    inc dword [count]

    cmp byte [char], '9'
    ja not_digit
    cmp byte [char], '0'
    jb not_digit

    mov al, byte [char]
    cmp al, 10
    je check

    mov bl, al
    jmp readchar

    not_digit:
        cmp dword [count], 1
        jne usage_error
        cmp byte [char], '-'
        jne usage_error
        jmp readchar

    check:
        cmp bl, 'a'
        je usage_error

        test bl, 1
        jz success
        jmp error

    error:
        mov rax, 60
        mov rdi, 1
        syscall

    success:
        mov rax, 60
        xor rdi, rdi
        syscall

    usage_error:
        mov rax, 60
        mov rdi, 2
        syscall



section .bss
    char resb 1
    count resd 1