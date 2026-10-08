section .data
    menu db "==============================", 10
         db "   TEXT GRAPHICS SYSTEM", 10
         db "==============================", 10
         db "1. Pyramid", 10
         db "2. Rectangle", 10
         db "3. Triangle", 10
         db "4. Diamond", 10
         db "5. X Shape", 10
         db "6. Exit", 10
         db "Enter choice: "
    menu_len equ $ - menu

    pyramid_msg db "Pyramid selected", 10
    pyramid_len equ $ - pyramid_msg

    rectangle_msg db "Rectangle selected", 10
    rectangle_len equ $ - rectangle_msg

    triangle_msg db "Triangle selected", 10
    triangle_len equ $ - triangle_msg

    diamond_msg db "Diamond selected", 10
    diamond_len equ $ - diamond_msg

    xshape_msg db "X Shape selected", 10
    xshape_len equ $ - xshape_msg

    invalid_msg db "Invalid choice", 10
    invalid_len equ $ - invalid_msg

section .bss
    choice resb 2

section .text
    global _start

_start:

main_menu:
    ; print menu
    mov rax, 1
    mov rdi, 1
    mov rsi, menu
    mov rdx, menu_len
    syscall

    ; read choice
    mov rax, 0
    mov rdi, 0
    mov rsi, choice
    mov rdx, 2
    syscall

    ; compare first character
    mov al, [choice]

    cmp al, '1'
    je pyramid

    cmp al, '2'
    je rectangle

    cmp al, '3'
    je triangle

    cmp al, '4'
    je diamond

    cmp al, '5'
    je xshape

    cmp al, '6'
    je exit_program

    jmp invalid_choice

pyramid:
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_msg
    mov rdx, pyramid_len
    syscall
    jmp main_menu

rectangle:
    mov rax, 1
    mov rdi, 1
    mov rsi, rectangle_msg
    mov rdx, rectangle_len
    syscall
    jmp main_menu

triangle:
    mov rax, 1
    mov rdi, 1
    mov rsi, triangle_msg
    mov rdx, triangle_len
    syscall
    jmp main_menu

diamond:
    mov rax, 1
    mov rdi, 1
    mov rsi, diamond_msg
    mov rdx, diamond_len
    syscall
    jmp main_menu

xshape:
    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_msg
    mov rdx, xshape_len
    syscall
    jmp main_menu

invalid_choice:
    mov rax, 1
    mov rdi, 1
    mov rsi, invalid_msg
    mov rdx, invalid_len
    syscall
    jmp main_menu

exit_program:
    mov rax, 60
    mov rdi, 0
    syscall
