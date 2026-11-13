; asm13 - palindrome depuis stdin. Exit 0 si oui, 1 si non.
; nasm -f elf64 asm13.s -o asm13.o && ld asm13.o -o asm13

section .bss
    buf resb 4096

section .text
    global _start

_start:
    xor     rax, rax            ; sys_read
    xor     rdi, rdi            ; stdin
    lea     rsi, [rel buf]
    mov     rdx, 4096
    syscall
    test    rax, rax
    jle     .yes                ; vide / erreur -> palindrome

    lea     rsi, [rel buf]
    mov     rcx, rax            ; longueur

    ; retire les \n / \r de fin
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
    xor     rdi, rdi            ; i = 0
    lea     rdx, [rcx - 1]      ; j = len - 1
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
    mov     rax, 60             ; sys_exit
    syscall