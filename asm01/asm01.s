global_start

section .data
msg db "1337" , 10


section .text

    mov rax, 1
    mov rdi, 1 


    mov rax, 60
    mov rdi, 0 
    syscall