section .data
    xshape_msg db "Xshape selected", 10
    xshape_len equ $ - xshape_msg

section .text

xshape:
    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_msg
    mov rdx, xshape_len
    syscall

    jmp main_menu
