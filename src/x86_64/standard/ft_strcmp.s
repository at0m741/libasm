section .text
global ft_strcpmp

ft_strcpmp:
	test		rdi, rdi
	sete		cl
	test		rsi, rsi
	sete		dl
	xor			eax, eax
	or			cl, dl
	jne			.end
	movzx		eax, [rdi]
	test		al, al
	je			.null_S1
	inc			rdi

.loop:
	cmp			al, [rsi]
	jne			.diff	
	inc			rsi
	movzx		eax, [rdi]
	inc			rdi
	test		al, al
	je			.loop
	xor			eax, eax

.diff:
	movzx		eax, al
	jmp			.final_cmp

.null_S1:
	xor			eax, eax

.final_cmp:
	movzx		ecx, [rsi]
	sub			eax, ecx

.end:
	ret
