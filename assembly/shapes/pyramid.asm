section .data

    pyramid_prompt db "Enter pyramid height (2-9): "
    pyramid_prompt_len equ $ - pyramid_prompt

    invalid_height_msg db "Invalid height. Enter a value from 2 to 9.", 10
    invalid_height_len equ $ - invalid_height_msg

    star db "*"
    space db " "
    newline db 10


section .bss

    pyramid_input resb 2
    pyramid_height resb 1


section .text

pyramid:

    ; Ask user for height
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_prompt
    mov rdx, pyramid_prompt_len
    syscall

    ; Read height
    mov rax, 0
    mov rdi, 0
    mov rsi, pyramid_input
    mov rdx, 2
    syscall

    ; Convert ASCII to number
    mov al, [pyramid_input]
    sub al, '0'

    ; Validate minimum height
    cmp al, 2
    jl invalid_pyramid_height

    ; Validate maximum height
    cmp al, 9
    jg invalid_pyramid_height

    ; Save height
    mov [pyramid_height], al

    ; row = 1
    mov r8b, 1


pyramid_row_loop:

    
    ; spaces = height - row

    mov r9b, [pyramid_height]
    sub r9b, r8b


pyramid_space_loop:

    cmp r9b, 0
    je pyramid_prepare_stars

    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

    dec r9b
    jmp pyramid_space_loop


pyramid_prepare_stars:

    ; stars = 2 * row - 1
   

    mov r10b, r8b
    add r10b, r8b
    dec r10b


pyramid_star_loop:

    cmp r10b, 0
    je pyramid_newline

    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, 1
    syscall

    dec r10b
    jmp pyramid_star_loop


pyramid_newline:

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; row++
    inc r8b

    ; if row <= height, continue
    cmp r8b, [pyramid_height]
    jle pyramid_row_loop

    ; finished
    jmp main_menu


invalid_pyramid_height:

    mov rax, 1
    mov rdi, 1
    mov rsi, invalid_height_msg
    mov rdx, invalid_height_len
    syscall

    jmp pyramid
