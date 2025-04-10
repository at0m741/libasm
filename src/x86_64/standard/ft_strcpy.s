section .text
global ft_strcpy

ft_strcpy:
    test    rdi, rdi
    je      .null_ptr
    test    rsi, rsi
    je      .null_ptr

    mov     rax, rdi

.loop:
    movzx   edx, byte [rsi]
    mov     byte [rdi], dl
    inc     rsi
    inc     rdi
    test    dl, dl
    jne     .loop

    ret

.null_ptr:
    xor     eax, eax
    ret
