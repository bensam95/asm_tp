global _start

section .bss
	input  resb 4096
	buffer resb 32

section .text
_start:
	xor r12, r12			

.read:
	mov rax, 0			
	mov rdi, 0
	mov rsi, input
	mov rdx, 4096
	syscall
	test rax, rax
	js _error1			
	jz .print			

	mov rcx, rax
	mov rsi, input

.loop:
	movzx eax, byte [rsi]
	or al, 0x20			
	cmp al, 'a'
	je .vowel
	cmp al, 'e'
	je .vowel
	cmp al, 'i'
	je .vowel
	cmp al, 'o'
	je .vowel
	cmp al, 'u'
	jne .next
.vowel:
	inc r12
.next:
	inc rsi
	dec rcx
	jnz .loop
	jmp .read			

.print:
	mov rax, r12
	mov rsi, buffer + 31
	mov byte [rsi], 10
	mov r9, 10
.convert:
	dec rsi
	xor rdx, rdx
	div r9
	add dl, '0'
	mov [rsi], dl
	test rax, rax
	jnz .convert

	mov rdx, buffer + 32
	sub rdx, rsi
	mov rax, 1
	mov rdi, 1
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

_error1:
	mov rax, 60
	mov rdi, 1
	syscall
