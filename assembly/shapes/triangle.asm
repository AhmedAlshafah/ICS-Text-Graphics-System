section .data
    triangle_msg db "Triangle selected", 10
    triangle_len equ $ - triangle_msg

section .text

triangle:
    mov rax, 1
    mov rdi, 1
    mov rsi, triangle_msg
    mov rdx, triangle_len
    syscall

    jmp main_menu
