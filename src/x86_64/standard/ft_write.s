section .text
global write
extern __errno_location

write:
	mov rax, 1          ; syscall number for sys_write
	syscall
	cmp rax, 0
	jc error
	ret

error:
	neg rax
	mov rdi, rax
	call __errno_location
	mov [rax], rdi
	mov rax, -1
	ret
