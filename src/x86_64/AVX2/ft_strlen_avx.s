section .text
global ft_strlen_avx_asm

%define PAGE_SIZE 4096
%define VEC_SIZE 32

ft_strlen_avx_asm:
    test		rdi, rdi
    je			.return_zero

    mov			rsi, rdi	            ; Save original pointer
    mov			rax, rdi
    and			eax, VEC_SIZE - 1		; Check alignment
    jz			.aligned_loop			; Already aligned

    mov			ecx, VEC_SIZE
    sub			ecx, eax				; Bytes until next alignment
	prefetcht0	[rdi + PAGE_SIZE]		; Prefetch ahead
    vpxor		xmm0, xmm0, xmm0		; Zero vector for comparison
    vmovdqu		xmm1, [rdi]				; Load unaligned
    vpcmpeqb	xmm1, xmm1, xmm0		; Compare with zero
    vpmovmskb	edx, xmm1
    test		edx, edx
    jnz			.found_null				; Early exit if null found

    add			rdi, rcx				; Advance to aligned address
    prefetcht0	[rdi + PAGE_SIZE]		; Prefetch ahead

.aligned_loop:
    vmovdqa		ymm1, [rdi]				; Aligned load
    vpcmpeqb	ymm1, ymm1, ymm0
    vpmovmskb	edx, ymm1
    test		edx, edx
    jnz			.found_null

    add			rdi, VEC_SIZE
    prefetcht0	[rdi + PAGE_SIZE]		; Prefetch next chunk
    jmp			.aligned_loop

.found_null:
    bsf			eax, edx				; Find first set bit (null position)
    sub			rdi, rsi				; Total bytes processed
    add			rax, rdi				; Add offset within final vector
    vzeroupper
    ret

.return_zero:
    xor			eax, eax
    vzeroupper
    ret
