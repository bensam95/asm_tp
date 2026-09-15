section .bss
    input resb 64

section .text
    global _start

_start:

    mov rax, 0              
    mov rdi, 0              
    mov rsi, input          
    mov rdx, 64            
    syscall

    
    cmp rax, 0
    jle _not_a_number       

    mov rcx, rax            
    dec rcx                 
    cmp byte [input + rcx], 10
    jne .check_empty
    dec rax                 

.check_empty:
    
    cmp rax, 0
    jle _not_a_number


    xor rbx, rbx            

.validation_loop:
    mov dl, [input + rbx]

    cmp dl, '0'
    jl _not_a_number        
    cmp dl, '9'
    jg _not_a_number       

    inc rbx
    cmp rbx, rax         
    jl .validation_loop

    dec rax                 
    mov dl, [input + rax]

    test dl, 1
    jnz _is_odd           

_even:
    mov rax, 60             
    mov rdi, 0              
    syscall

_odd:
    mov rax, 60             
    mov rdi, 1              
    syscall

_not_a_number:
    mov rax, 60             
    mov rdi, 2              
    syscall