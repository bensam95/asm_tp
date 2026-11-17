section .bss
    buffer resb 4096

section .text
global _start

_start:
    xor r12, r12
    xor r13, r13

lire_entree:
    cmp r12, 4095
    jae preparer_inversion

    mov rax, 0
    mov rdi, 0
    lea rsi, [buffer + r12]
    mov rdx, 1
    syscall

    cmp rax, 0
    jle preparer_inversion

    mov r13, 1

    cmp byte [buffer + r12], 10
    je preparer_inversion

    inc r12
    jmp lire_entree

preparer_inversion:
    cmp r12, 0
    jne inverser_debut

    cmp r13, 0
    je ecrire_resultat

    jmp ajouter_fin_ligne

inverser_debut:
    xor r14, r14
    mov r15, r12
    dec r15

inverser_chaine:
    cmp r14, r15
    jae ajouter_fin_ligne

    mov al, [buffer + r14]
    mov bl, [buffer + r15]

    mov [buffer + r14], bl
    mov [buffer + r15], al

    inc r14
    dec r15
    jmp inverser_chaine

ajouter_fin_ligne:
    mov byte [buffer + r12], 10
    inc r12

ecrire_resultat:
    mov rax, 1
    mov rdi, 1
    lea rsi, [buffer]
    mov rdx, r12
    syscall

sortie_succes:
    mov rax, 60
    mov rdi, 0
    syscall