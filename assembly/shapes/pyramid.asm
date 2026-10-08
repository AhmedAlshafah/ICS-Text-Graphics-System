section .data
    pyramid_msg db "Pyramid selected", 10
    pyramid_len equ $ - pyramid_msg

section .text

pyramid:
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_msg
    mov rdx, pyramid_len
    syscall

    jmp main_menu

