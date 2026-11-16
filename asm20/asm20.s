section .data
    texte_ecoute db "Listening on port 4242", 10
    taille_ecoute equ $ - texte_ecoute
    pong db "PONG", 10
    taille_pong equ $ - pong
    au_revoir db "Goodbye!", 10
    taille_au_revoir equ $ - au_revoir
    inconnu db "Unknown command", 10
    taille_inconnu equ $ - inconnu

    adresse:
        dw 2
        db 0x10, 0x92
        dd 0
        dq 0

    un dd 1

    ignorer_fils:
        dq 1
        dq 0
        dq 0
        dq 0

section .bss
    tampon resb 65536
    sortie resb 65536

section .text
    global _start

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall
    cmp rax, 0
    jl erreur
    mov r12, rax

    mov rax, 54
    mov rdi, r12
    mov rsi, 1
    mov rdx, 2
    mov r10, un
    mov r8, 4
    syscall
    cmp rax, 0
    jl erreur

    mov rax, 49
    mov rdi, r12
    mov rsi, adresse
    mov rdx, 16
    syscall
    cmp rax, 0
    jl erreur

    mov rax, 50
    mov rdi, r12
    mov rsi, 128
    syscall
    cmp rax, 0
    jl erreur

    mov rax, 13
    mov rdi, 17
    mov rsi, ignorer_fils
    mov rdx, 0
    mov r10, 8
    syscall

    mov rax, 13
    mov rdi, 13
    mov rsi, ignorer_fils
    mov rdx, 0
    mov r10, 8
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, texte_ecoute
    mov rdx, taille_ecoute
    syscall

accepter:
    mov rax, 43
    mov rdi, r12
    mov rsi, 0
    mov rdx, 0
    syscall
    cmp rax, 0
    jl accepter
    mov r13, rax

    mov rax, 57
    syscall
    cmp rax, 0
    je enfant
    mov rax, 3
    mov rdi, r13
    syscall
    jmp accepter

enfant:
    mov rax, 3
    mov rdi, r12
    syscall
    mov r14, 0

chercher_ligne:
    mov rbx, 0
parcourir:
    cmp rbx, r14
    jge pas_de_ligne
    cmp byte [tampon + rbx], 10
    je ligne_trouvee
    inc rbx
    jmp parcourir

ligne_trouvee:
    mov r15, rbx
    call traiter_ligne
    cmp rax, 1
    je fin_client

    mov rcx, r14
    sub rcx, r15
    dec rcx
    mov r14, rcx
    mov rsi, tampon
    add rsi, r15
    inc rsi
    mov rdi, tampon
    cld
    rep movsb
    jmp chercher_ligne

pas_de_ligne:
    cmp r14, 65536
    jge fin_client

lire:
    mov rax, 0
    mov rdi, r13
    mov rsi, tampon
    add rsi, r14
    mov rdx, 65536
    sub rdx, r14
    syscall
    cmp rax, -4
    je lire
    cmp rax, 0
    jl fin_client
    je fin_connexion
    add r14, rax
    jmp chercher_ligne

fin_connexion:
    cmp r14, 0
    je fin_client
    mov r15, r14
    call traiter_ligne

fin_client:
    mov rax, 3
    mov rdi, r13
    syscall
    mov rax, 60
    mov rdi, 0
    syscall

traiter_ligne:
    mov rcx, r15
    cmp rcx, 0
    je ligne_vide
    cmp byte [tampon + rcx - 1], 13
    jne tester
    dec rcx
tester:
    cmp rcx, 0
    je ligne_vide
    cmp rcx, 4
    jne tester_reverse
    cmp dword [tampon], 'PING'
    je commande_ping
    cmp dword [tampon], 'EXIT'
    je commande_exit
    jmp commande_inconnue

tester_reverse:
    cmp rcx, 8
    jl commande_inconnue
    cmp dword [tampon], 'REVE'
    jne commande_inconnue
    cmp dword [tampon + 4], 'RSE '
    jne commande_inconnue

    mov rdx, rcx
    sub rdx, 8
    mov r8, 0
    mov r9, rcx
inverser:
    cmp r8, rdx
    jge inversion_finie
    mov al, [tampon + r9 - 1]
    mov [sortie + r8], al
    dec r9
    inc r8
    jmp inverser

inversion_finie:
    mov byte [sortie + rdx], 10
    inc rdx
    mov rsi, sortie
    jmp envoyer

commande_ping:
    mov rsi, pong
    mov rdx, taille_pong
    jmp envoyer

commande_exit:
    mov rsi, au_revoir
    mov rdx, taille_au_revoir
    call envoyer
    mov rax, 1
    ret

commande_inconnue:
    mov rsi, inconnu
    mov rdx, taille_inconnu
    jmp envoyer

ligne_vide:
    mov rax, 0
    ret

envoyer:
    mov rax, 44
    mov rdi, r13
    mov r10, 0x4000
    mov r8, 0
    mov r9, 0
    syscall
    cmp rax, -4
    je envoyer
    cmp rax, 0
    jle echec_envoi
    add rsi, rax
    sub rdx, rax
    jnz envoyer
    mov rax, 0
    ret

echec_envoi:
    mov rax, 1
    ret

erreur:
    mov rax, 60
    mov rdi, 1
    syscall