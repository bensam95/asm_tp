global _start

section .bss
    char resb 1

section .text
_start:
    mov rdi, [rsp]
    cmp rdi, 2
    jne exit_2

    mov rsi, [rsp + 16]

    cmp byte [rsi], 0
    je exit_1

    cmp byte [rsi], '-'
    jne check_positif

    inc rsi
    cmp byte [rsi], 0
    je exit_1

verif_chiffres_neg:
    mov al, [rsi]
    cmp al, 0
    je somme_nulle
    cmp al, '0'
    jb exit_1
    cmp al, '9'
    ja exit_1
    inc rsi
    jmp verif_chiffres_neg

check_positif:
    cmp byte [rsi], '+'
    jne debut_lecture
    inc rsi
    cmp byte [rsi], 0
    je exit_1

debut_lecture:
    mov rax, 0

lecture:
    mov bl, [rsi]
    cmp bl, 0
    je fin_lecture

    cmp bl, '0'
    jb exit_1
    cmp bl, '9'
    ja exit_1

    sub bl, '0'

    mov r10, 10
    mul r10
    jc exit_1

    movzx rdx, bl
    add rax, rdx
    jc exit_1

    test rax, rax
    js exit_1

    inc rsi
    jmp lecture

fin_lecture:
    cmp rax, 1
    jle somme_nulle

    mov rcx, 1
    mov rbx, 0

boucle_somme:
    cmp rcx, rax
    je _resultat

    add rbx, rcx
    inc rcx
    jmp boucle_somme

somme_nulle:
    mov rbx, 0

_resultat:
    mov rax, rbx
    mov r12, 0

    cmp rax, 0
    jne decoupe_chiffres

    push 0
    mov r12, 1
    jmp print_pile

decoupe_chiffres:
    cmp rax, 0
    je print_pile

    mov rdx, 0
    mov rcx, 10
    div rcx

    push rdx
    inc r12
    jmp decoupe_chiffres

print_pile:
    cmp r12, 0
    je print_newline

    pop rax
    add al, '0'
    mov [char], al

    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall

    dec r12
    jmp print_pile

print_newline:
    mov byte [char], 10
    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

exit_1:
    mov rax, 60
    mov rdi, 1
    syscall

exit_2:
    mov rax, 60
    mov rdi, 2
    syscall