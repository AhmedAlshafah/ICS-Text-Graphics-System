section .data
    diamond_msg db "Diamond selected", 10
    diamond_len equ $ - diamond_msg

section .text

diamond:
    mov rax, 1
    mov rdi, 1
    mov rsi, diamond_msg
    mov rdx, diamond_len
    syscall

    jmp main_menu
