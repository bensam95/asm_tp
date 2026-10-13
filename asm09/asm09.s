section .bss
    buffer resb 70

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    je .mode_hex
    cmp rax, 3
    je .mode_flag
    jmp exit_2

.mode_hex:
    mov r12, 16
    mov rsi, [rsp + 16]
    jmp .parse

.mode_flag:
    mov rbx, [rsp + 16]
    cmp byte [rbx], '-'
    jne exit_2
    cmp byte [rbx + 1], 'b'
    jne exit_2
    cmp byte [rbx + 2], 0
    jne exit_2

    mov r12, 2
    mov rsi, [rsp + 24]

.parse:
    cmp byte [rsi], 0
    je exit_1

    xor r8, r8

    cmp byte [rsi], '-'
    jne .check_plus
    mov r8, 1
    inc rsi
    jmp .check_after_sign

.check_plus:
    cmp byte [rsi], '+'
    jne .check_after_sign
    inc rsi

.check_after_sign:
    cmp byte [rsi], 0
    je exit_1

    xor rax, rax
.parse_loop:
    movzx rdx, byte [rsi]
    test rdx, rdx
    jz .conversion_done

    cmp rdx, '0'
    jb exit_1
    cmp rdx, '9'
    ja exit_1
    sub rdx, '0'

    mov rcx, 10
    mul rcx
    test rdx, rdx
    jnz exit_1

    add rax, rdx
    jc exit_1

    inc rsi
    jmp .parse_loop

.conversion_done:
    mov rdi, buffer + 68
    mov byte [rdi], 10
    dec rdi

    test rax, rax
    jnz .div_loop
    mov byte [rdi], '0'
    dec rdi
    jmp .print

.div_loop:
    test rax, rax
    jz .add_sign

    xor rdx, rdx
    div r12

    cmp rdx, 9
    jbe .digit
    add dl, 'A' - 10
    jmp .store
.digit:
    add dl, '0'
.store:
    mov [rdi], dl
    dec rdi
    jmp .div_loop

.add_sign:
    test r8, r8
    jz .print
    mov byte [rdi], '-'
    dec rdi

.print:
    inc rdi
    mov rsi, rdi
    mov rdx, buffer + 69
    sub rdx, rdi
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_1:
    mov rax, 60
    mov rdi, 1
    syscall

exit_2:
    mov rax, 60
    mov rdi, 2
    syscall