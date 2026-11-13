section .bss
    buf resb 4096

section .text
    global _start

_start:
    xor     rax, rax
    xor     rdi, rdi
    lea     rsi, [rel buf]
    mov     rdx, 4096
    syscall
    test    rax, rax
    jle     .yes

    lea     rsi, [rel buf]
    mov     rcx, rax

.trim:
    test    rcx, rcx
    jz      .yes
    mov     al, [rsi + rcx - 1]
    cmp     al, 10
    je      .dec
    cmp     al, 13
    jne     .check
.dec:
    dec     rcx
    jmp     .trim

.check:
    xor     rdi, rdi
    lea     rdx, [rcx - 1]
.loop:
    cmp     rdi, rdx
    jge     .yes
    mov     al, [rsi + rdi]
    cmp     al, [rsi + rdx]
    jne     .no
    inc     rdi
    dec     rdx
    jmp     .loop

.yes:
    xor     rdi, rdi
    jmp     .exit
.no:
    mov     rdi, 1
.exit:
    mov     rax, 60
    syscall