section .bss
    chiffres resb 70

section .text
    global _start

_start:
    mov rax, [rsp]
    mov rbx, 16

    cmp rax, 2
    je .un_argument
    cmp rax, 3
    jne erreur_usage

    mov rsi, [rsp + 16]
    cmp word [rsi], '-b'
    jne erreur_usage
    cmp byte [rsi + 2], 0
    jne erreur_usage
    mov rbx, 2
    mov rsi, [rsp + 24]
    jmp .parser

.un_argument:
    mov rsi, [rsp + 16]

.parser:
    xor r12, r12
    xor r13d, r13d
    xor r15d, r15d

    cmp byte [rsi], '-'
    jne .chiffres_boucle
    mov r13d, 1
    inc rsi

.chiffres_boucle:
    movzx eax, byte [rsi]
    test al, al
    jz .parsing_fini

    cmp al, '0'
    jb erreur_nombre
    cmp al, '9'
    ja erreur_nombre

    sub eax, '0'
    inc r15d
    imul r12, r12, 10
    add r12, rax

    inc rsi
    jmp .chiffres_boucle

.parsing_fini:
    test r15d, r15d
    jz erreur_nombre

    lea r14, [chiffres + 69]
    mov byte [r14], 10

.convertir:
    test r12, r12
    jz .conversion_finie

    xor rdx, rdx
    mov rax, r12
    div rbx

    cmp dl, 10
    jb .chiffre_decimal
    add dl, 'A' - 10
    jmp .stocker
.chiffre_decimal:
    add dl, '0'
.stocker:
    dec r14
    mov [r14], dl

    mov r12, rax
    jmp .convertir

.conversion_finie:
    test r13d, r13d
    jz .ecrire

    dec r14
    mov byte [r14], '-'

.ecrire:
    lea rax, [chiffres + 70]
    sub rax, r14
    mov rdx, rax
    mov rsi, r14

.boucle_ecriture:
    mov rax, 1
    mov rdi, 1
    syscall
    cmp rax, -4
    je .boucle_ecriture
    test rax, rax
    jle erreur_nombre
    add rsi, rax
    sub rdx, rax
    jnz .boucle_ecriture

    xor edi, edi
    jmp sortie

erreur_nombre:
    mov edi, 1
    jmp sortie

erreur_usage:
    mov edi, 2

sortie:
    mov eax, 60
    syscall