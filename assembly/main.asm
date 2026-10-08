section .data

    menu db "==============================", 10
         db "     TEXT GRAPHICS SYSTEM", 10
         db "==============================", 10
         db "1. Pyramid", 10
         db "2. Rectangle", 10
         db "3. Triangle", 10
         db "4. Diamond", 10
         db "5. X Shape", 10
         db "6. Exit", 10
         db "Enter choice: "
    menu_len equ $ - menu

    invalid_msg db "Invalid choice", 10
    invalid_len equ $ - invalid_msg


section .bss

    choice resb 2


section .text

    global _start


_start:

main_menu:

    ; -----------------------------
    ; Print the main menu
    ; -----------------------------

    mov rax, 1
    mov rdi, 1
    mov rsi, menu
    mov rdx, menu_len
    syscall


    ; -----------------------------
    ; Read the user's menu choice
    ; -----------------------------

    mov rax, 0
    mov rdi, 0
    mov rsi, choice
    mov rdx, 2
    syscall


    ; -----------------------------
    ; Get first character entered
    ; -----------------------------

    mov al, [choice]


    ; -----------------------------
    ; Decide which shape to run
    ; -----------------------------

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


; ==================================================
; Shape modules
; ==================================================

%include "assembly/shapes/pyramid.asm"
%include "assembly/shapes/rectangle.asm"
%include "assembly/shapes/triangle.asm"
%include "assembly/shapes/diamond.asm"
%include "assembly/shapes/xshape.asm"
