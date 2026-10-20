section .data
    rect_width_prompt   db "Enter rectangle width (1-9): "
    rect_width_len      equ $ - rect_width_prompt

    rect_height_prompt  db "Enter rectangle height (1-9): "
    rect_height_len     equ $ - rect_height_prompt

    rect_fill_prompt    db "Choose fill type (1=Solid, 2=Hollow): "
    rect_fill_len       equ $ - rect_fill_prompt

    rect_style_prompt   db "Choose style (1=Star '*', 2=Hash '#'): "
    rect_style_len      equ $ - rect_style_prompt

    rect_invalid_msg    db "Invalid input! Please enter a valid number.", 10
    rect_invalid_len    equ $ - rect_invalid_msg

    rect_star           db "* "
    rect_star_len       equ $ - rect_star

    rect_hash           db "# "
    rect_hash_len       equ $ - rect_hash

    rect_space          db "  "
    rect_space_len      equ $ - rect_space

    rect_newline        db 10

section .bss
    rect_input          resb 10
    rect_width          resq 1
    rect_height         resq 1
    rect_fill           resq 1
    rect_style          resq 1

section .text
    global draw_rectangle
    extern main_menu

draw_rectangle:
    ; --- Prompt Width ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_width_prompt
    mov rdx, rect_width_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, rect_input
    mov rdx, 10
    syscall

    ; Validate Single Digit (1-9)
    cmp rax, 2
    jne rect_invalid_input
    movzx rbx, byte [rect_input]
    cmp rbx, '1'
    jl rect_invalid_input
    cmp rbx, '9'
    jg rect_invalid_input
    sub rbx, '0'
    mov [rect_width], rbx

    ; --- Prompt Height ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_height_prompt
    mov rdx, rect_height_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, rect_input
    mov rdx, 10
    syscall

    ; Validate Single Digit (1-9)
    cmp rax, 2
    jne rect_invalid_input
    movzx rbx, byte [rect_input]
    cmp rbx, '1'
    jl rect_invalid_input
    cmp rbx, '9'
    jg rect_invalid_input
    sub rbx, '0'
    mov [rect_height], rbx

    ; --- Prompt Fill Type ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_fill_prompt
    mov rdx, rect_fill_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, rect_input
    mov rdx, 10
    syscall

    ; Validate Fill Type (1 or 2)
    cmp rax, 2
    jne rect_invalid_input
    movzx rbx, byte [rect_input]
    cmp rbx, '1'
    je rect_valid_fill
    cmp rbx, '2'
    je rect_valid_fill
    jmp rect_invalid_input

rect_valid_fill:
    sub rbx, '0'
    mov [rect_fill], rbx

    ; --- Prompt Style ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_style_prompt
    mov rdx, rect_style_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, rect_input
    mov rdx, 10
    syscall

    ; Validate Style (1 or 2)
    cmp rax, 2
    jne rect_invalid_input
    movzx rbx, byte [rect_input]
    cmp rbx, '1'
    je rect_valid_style
    cmp rbx, '2'
    je rect_valid_style
    jmp rect_invalid_input

rect_valid_style:
    sub rbx, '0'
    mov [rect_style], rbx

    ; --- Draw Rectangle Loops ---
    mov r8, 0               ; Row index = 0

rect_row_loop:
    cmp r8, [rect_height]
    jge rect_draw_done

    mov r9, 0               ; Column index = 0

rect_col_loop:
    cmp r9, [rect_width]
    jge rect_next_row

    ; Check if Solid (1) or Hollow (2)
    cmp qword [rect_fill], 1
    je rect_print_char

    ; If Hollow: Check if boundary pixel
    cmp r8, 0
    je rect_print_char
    
    mov rax, [rect_height]
    dec rax
    cmp r8, rax
    je rect_print_char

    cmp r9, 0
    je rect_print_char

    mov rax, [rect_width]
    dec rax
    cmp r9, rax
    je rect_print_char

    ; Print Space inside hollow area
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_space
    mov rdx, rect_space_len
    syscall
    jmp rect_inc_col

rect_print_char:
    cmp qword [rect_style], 1
    je rect_print_star

    ; Print Hash
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_hash
    mov rdx, rect_hash_len
    syscall
    jmp rect_inc_col

rect_print_star:
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_star
    mov rdx, rect_star_len
    syscall

rect_inc_col:
    inc r9
    jmp rect_col_loop

rect_next_row:
    ; Print Newline at end of row
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_newline
    mov rdx, 1
    syscall

    inc r8
    jmp rect_row_loop

rect_draw_done:
    jmp main_menu

rect_invalid_input:
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_invalid_msg
    mov rdx, rect_invalid_len
    syscall
    jmp main_menu

rect_exit_program:
    jmp main_menu
