global _start

section .bss
    buffer resb 32

section .text
_start:
    cmp qword [rsp], 3
    jne arg_error

    mov rdi, [rsp + 16]
    call parse_int
    mov r12, rax

    mov rdi, [rsp + 24]
    call parse_int
    mov r13, rax

    add r12, r13
    jo calc_err

    mov rdi, r12
    call print_int

    mov rax, 60
    xor rdi, rdi
    syscall

parse_int:
    xor rax, rax
    xor r8, r8
    xor rcx, rcx

    movzx rdx, byte [rdi]
    cmp dl, '-'
    je .negatif
    cmp dl, '+'
    je .positif
    jmp .loop

.negatif:
    mov r8, 1
    inc rdi
    jmp .loop

.positif:
    inc rdi

.loop:
    movzx rdx, byte [rdi]
    test dl, dl
    jz .fait

    cmp dl, '0'
    jb calc_err
    cmp dl, '9'
    ja calc_err

    sub dl, '0'
    inc rcx

    mov r9, 10
    mul r9
    jo calc_err

    add rax, rdx
    jc calc_err

    inc rdi
    jmp .loop

.fait:
    test rcx, rcx
    jz calc_err

    test r8, r8
    jz .position

    mov rdx, 0x8000000000000000
    cmp rax, rdx
    ja calc_err
    je .min_int

    neg rax
    ret

.min_int:
    mov rax, rdx
    ret

.position:
    mov rdx, 0x7FFFFFFFFFFFFFFF
    cmp rax, rdx
    ja calc_err
    ret

print_int:
    lea rsi, [buffer + 31]
    mov byte [rsi], 10
    mov r8, rsi

    test rdi, rdi
    jnz .non_zero

    dec rsi
    mov byte [rsi], '0'
    jmp .output

.non_zero:
    xor r9, r9
    mov rax, rdi
    test rax, rax
    jns .convert

    mov r9, 1
    neg rax

.convert:
    mov rcx, 10
.conv_loop:
    test rax, rax
    jz .add_sign

    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    jmp .conv_loop

.add_sign:
    test r9, r9
    jz .output
    dec rsi
    mov byte [rsi], '-'

.output:
    mov rdx, r8
    sub rdx, rsi
    inc rdx

    mov rax, 1
    mov rdi, 1
    syscall
    ret

calc_err:
    mov rax, 60
    mov rdi, 1
    syscall

arg_error:
    mov rax, 60
    mov rdi, 2
    syscall