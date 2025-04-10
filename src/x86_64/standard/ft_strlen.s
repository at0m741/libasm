section .text
global ft_strlen

ft_strlen:
	xor rax, rax

.loop:
	movzx rbx, byte [rdi + rax]
	test rbx, rbx
	jz .end
	inc rax
	jmp .loop

.end:
	ret
