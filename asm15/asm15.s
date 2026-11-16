section .bss
    tampon resb 4096

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne erreur_usage

    mov rsi, [rsp + 16]
    mov r12, 0
    mov r13, 0

    cmp byte [rsi], '-'
    jne test_plus
    mov r13, 1
    inc rsi
    jmp test_vide

test_plus:
    cmp byte [rsi], '+'
    jne test_vide
    inc rsi

test_vide:
    cmp byte [rsi], 0
    je erreur_nombre

lire_chiffre:
    movzx eax, byte [rsi]
    cmp eax, 0
    je fin_nombre
    cmp eax, '0'
    jl erreur_nombre
    cmp eax, '9'
    jg erreur_nombre
    sub eax, '0'

    imul r12, r12, 10
    add r12, rax
    mov rax, r12
    mov rdx, 0
    mov rcx, 26
    div rcx
    mov r12, rdx

    inc rsi
    jmp lire_chiffre

fin_nombre:
    cmp r13, 1
    jne lire_entree
    cmp r12, 0
    je lire_entree
    mov rax, 26
    sub rax, r12
    mov r12, rax

lire_entree:
    mov rax, 0
    mov rdi, 0
    mov rsi, tampon
    mov rdx, 4096
    syscall

    cmp rax, -4
    je lire_entree
    cmp rax, 0
    jl erreur_nombre
    je fin_ok

    mov r14, rax
    mov rbx, 0

boucle_lettres:
    cmp rbx, r14
    je ecrire_sortie

    movzx eax, byte [tampon + rbx]

    cmp eax, 'a'
    jl test_majuscule
    cmp eax, 'z'
    jg test_majuscule
    sub eax, 'a'
    add eax, r12d
    cmp eax, 26
    jl fin_minuscule
    sub eax, 26
fin_minuscule:
    add eax, 'a'
    mov [tampon + rbx], al
    jmp lettre_suivante

test_majuscule:
    cmp eax, 'A'
    jl lettre_suivante
    cmp eax, 'Z'
    jg lettre_suivante
    sub eax, 'A'
    add eax, r12d
    cmp eax, 26
    jl fin_majuscule
    sub eax, 26
fin_majuscule:
    add eax, 'A'
    mov [tampon + rbx], al

lettre_suivante:
    inc rbx
    jmp boucle_lettres

ecrire_sortie:
    mov rsi, tampon
    mov rdx, r14

boucle_ecriture:
    mov rax, 1
    mov rdi, 1
    syscall

    cmp rax, -4
    je boucle_ecriture
    cmp rax, 0
    jle erreur_nombre

    add rsi, rax
    sub rdx, rax
    cmp rdx, 0
    jne boucle_ecriture
    jmp lire_entree

fin_ok:
    mov rax, 60
    mov rdi, 0
    syscall

erreur_nombre:
    mov rax, 60
    mov rdi, 1
    syscall

erreur_usage:
    mov rax, 60
    mov rdi, 2
    syscall