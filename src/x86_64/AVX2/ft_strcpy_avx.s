section .text
global ft_strcpy_avx

ft_strcpy_avx:
    test			rdi, rdi
    jz				.null_return
    test			rsi, rsi
    jz				.null_return

    mov				rax, rdi              ; Save return value (dst)
    mov				rcx, rdi              ; Current dst
    mov				rdx, rsi              ; Current src

    cmp				byte [rdx], 0
    je				.copy_null
    cmp				byte [rdx + 1], 0
    je				.copy_1byte
    cmp				byte [rdx + 2], 0
    je				.copy_2bytes
    cmp				byte [rdx + 3], 0
    je				.copy_3bytes
		
    test			rcx, 31
    jz				.vector_loop

.align_loop:
	prefetcht0		[rdx]
    movzx			r8d, byte [rdx]
    mov				byte [rcx], r8b
    test			r8b, r8b
    je				.return
    inc				rcx
    inc				rdx
    test			rcx, 31
    jnz				.align_loop

.vector_loop:
    vpxor			ymm0, ymm0, ymm0      ; ymm0 = zero

.loop:
	prefetcht0		[rdx + 64]
    vmovdqu			ymm1, [rdx]
    vpcmpeqb		ymm2, ymm1, ymm0
    vpmovmskb		r8d, ymm2
    vmovdqu			[rcx], ymm1
    add				rcx, 32
    add				rdx, 32
    test			r8d, r8d
    jz				.loop

.found_null:
    sub				rcx, 32
    sub				rdx, 32
    bsf				r8d, r8d

.tail_copy:
    movzx			r9, byte [rdx + r8]
    mov				byte [rcx + r8], r9b
    inc				r8
    test			r9b, r9b
    jne				.tail_copy

.return:
    vzeroupper
    ret

.copy_null:
    mov				byte [rdi], 0
    mov				rax, rdi
    ret

.copy_1byte:
    movzx			r8d, byte [rdx]
    mov				byte [rdi], r8b
    mov				byte [rdi + 1], 0
    mov				rax, rdi
    ret

.copy_2bytes:
    movzx			r8w, [rdx]
    mov				word [rdi], r8w
    mov				byte [rdi + 2], 0
    mov				rax, rdi
    ret

.copy_3bytes:
    movzx			r8w, [rdx]
    mov				word [rdi], r8w
    movzx			r8, byte [rdx + 2]
    mov				byte [rdi + 2], r8b
    mov				byte [rdi + 3], 0
    mov				rax, rdi
    ret

.null_return:
    xor				eax, eax
    ret
