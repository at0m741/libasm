section .text
global ft_strcmp_avx

ft_strcmp_avx:
    test		rdi, rdi
    jz			.check_rsi_null
    test		rsi, rsi
    jz			.ret_plus1
    vpxor		ymm0, ymm0, ymm0
    jmp			.loop

.check_rsi_null:
    test		rsi, rsi
    jz			.ret_equal
    jmp			.ret_minus1

.ret_equal:
    xor			eax, eax
    vzeroupper
    ret

.loop:
	prefetcht0	[rdi + 64]					;prefetch next 64 bytes of the first string 
	prefetcht0	[rsi + 64]					;prefetch next 64 bytes of the second string
    vmovdqu		ymm1, [rdi]				
    vmovdqu		ymm2, [rsi]

    vpcmpeqb	ymm3, ymm1, ymm0			;compare S1 with 0 
    vpcmpeqb	ymm4, ymm2, ymm0			;compare S2 with 0
    vpor		ymm5, ymm3, ymm4
    vpcmpeqb	ymm6, ymm1, ymm2			;compare S1 with S2
    vpxor		ymm7, ymm6, [rel ones]		;compare S1 with S2 and set the bits to 1 if they are equal
    vpor		ymm7, ymm7, ymm5			;combine the results
    vpmovmskb	eax, ymm7
    test		eax, eax					
    jz			.continue

    bsf			eax, eax					;bsf is used to find the first non-equal byte
    movzx		ecx, byte [rdi + rax]		;get the first non-equal byte in S1
    movzx		edx, byte [rsi + rax]		;get the first non-equal byte in S2
    cmp			ecx, edx
    jl			.ret_minus1
    jg			.ret_plus1

    xor			eax, eax
    vzeroupper								;zero upper registers to handle \
											;change between 128 and 256 bit registers
    ret

.ret_minus1:
    mov			eax, -1
    vzeroupper
    ret

.ret_plus1:
    mov			eax, 1
    vzeroupper
    ret

.continue:
    add			rdi, 32
    add			rsi, 32
    jmp .loop

section .data
align 32
ones:
    times 32 db 0xFF

