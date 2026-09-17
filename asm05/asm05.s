global _start
section section .data
        newline db 10.text
        
_start:
        mov rdi, [rsp]
        cmp rdi, 2
        jne error
        mov rsi, [rsp + 16]
        xor rdx, rdx

count:
        cmp byte [rsi + rdx], 0
        je print

        inc rdx
        jmp count

print:
        mov rax, 1
        mov rdi, 1
        syscall

        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall

        jmp end

end:
        mov rax, 60
        mov rdi, 0
        syscall

error:
        mov rax, 60
        mov rdi, 1
        syscall

