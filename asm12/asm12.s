global _start

section .bss
	input  resb 1048576
	output resb 1048577

section .text
_start:
	xor r12, r12

.read:
	mov rax, 0
	mov rdi, 0
	lea rsi, [input + r12]
	mov rdx, 1048576
	sub rdx, r12
	jz .reverse
	syscall
	test rax, rax
	js _error1
	jz .reverse
	add r12, rax
	jmp .read

.reverse:
	test r12, r12
	jz .print
	cmp byte [input + r12 - 1], 10
	jne .start_rev
	dec r12

.start_rev:
	mov rcx, r12
	mov rsi, input
	lea rdi, [output + r12 - 1]
.loop:
	test rcx, rcx
	jz .print
	mov al, [rsi]
	mov [rdi], al
	inc rsi
	dec rdi
	dec rcx
	jmp .loop

.print:
	mov byte [output + r12], 10
	mov rax, 1
	mov rdi, 1
	mov rsi, output
	lea rdx, [r12 + 1]
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

_error1:
	mov rax, 60
	mov rdi, 1
	syscall
