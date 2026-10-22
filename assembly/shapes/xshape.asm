section .data

; ============================================================
; X SHAPE PROMPTS
; ============================================================

xshape_size_prompt db "Enter X size (3-9): "
xshape_size_prompt_len equ $ - xshape_size_prompt

xshape_invalid_size db "Invalid size. Enter a value from 3 to 9.", 10
xshape_invalid_size_len equ $ - xshape_invalid_size


xshape_thickness_prompt db "Select X thickness:", 10
                        db "1. Normal", 10
                        db "2. Thick", 10
                        db "Enter choice: "
xshape_thickness_prompt_len equ $ - xshape_thickness_prompt

xshape_invalid_thickness db "Invalid choice. Enter 1 or 2.", 10
xshape_invalid_thickness_len equ $ - xshape_invalid_thickness


xshape_char_prompt db "Select drawing character:", 10
                   db "1. *", 10
                   db "2. #", 10
                   db "Enter choice: "
xshape_char_prompt_len equ $ - xshape_char_prompt

xshape_invalid_char db "Invalid choice. Enter 1 or 2.", 10
xshape_invalid_char_len equ $ - xshape_invalid_char


xshape_color_prompt db "Select color:", 10
                    db "1. Red", 10
                    db "2. Green", 10
                    db "3. Yellow", 10
                    db "4. Blue", 10
                    db "5. Magenta", 10
                    db "6. Cyan", 10
                    db "7. White", 10
                    db "Enter choice: "
xshape_color_prompt_len equ $ - xshape_color_prompt

xshape_invalid_color db "Invalid color. Enter a value from 1 to 7.", 10
xshape_invalid_color_len equ $ - xshape_invalid_color


; ============================================================
; OUTPUT CHARACTERS
; ============================================================

xshape_space db " "
xshape_newline db 10


; ============================================================
; ANSI COLORS
; ============================================================

xshape_red db 27, "[31m"
xshape_red_len equ $ - xshape_red

xshape_green db 27, "[32m"
xshape_green_len equ $ - xshape_green

xshape_yellow db 27, "[33m"
xshape_yellow_len equ $ - xshape_yellow

xshape_blue db 27, "[34m"
xshape_blue_len equ $ - xshape_blue

xshape_magenta db 27, "[35m"
xshape_magenta_len equ $ - xshape_magenta

xshape_cyan db 27, "[36m"
xshape_cyan_len equ $ - xshape_cyan

xshape_white db 27, "[37m"
xshape_white_len equ $ - xshape_white

xshape_reset db 27, "[0m"
xshape_reset_len equ $ - xshape_reset


section .bss

xshape_size_input      resb 64
xshape_thickness_input resb 64
xshape_char_input      resb 64
xshape_color_input     resb 64

xshape_size       resb 1
xshape_thickness  resb 1
xshape_char       resb 1
xshape_color      resb 1


section .text

; ============================================================
; X SHAPE ENTRY POINT
; ============================================================

xshape:


; ============================================================
; 1. READ SIZE
; ============================================================

xshape_ask_size:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_size_prompt
    mov rdx, xshape_size_prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, xshape_size_input
    mov rdx, 64
    syscall

    ; exactly one character + Enter
    cmp rax, 2
    jne xshape_size_error

    cmp byte [xshape_size_input + 1], 10
    jne xshape_size_error

    mov al, [xshape_size_input]

    cmp al, '3'
    jb xshape_size_error

    cmp al, '9'
    ja xshape_size_error

    sub al, '0'
    mov [xshape_size], al

    jmp xshape_ask_thickness


xshape_size_error:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_invalid_size
    mov rdx, xshape_invalid_size_len
    syscall

    jmp xshape_ask_size


; ============================================================
; 2. READ THICKNESS
; ============================================================

xshape_ask_thickness:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_thickness_prompt
    mov rdx, xshape_thickness_prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, xshape_thickness_input
    mov rdx, 64
    syscall

    cmp rax, 2
    jne xshape_thickness_error

    cmp byte [xshape_thickness_input + 1], 10
    jne xshape_thickness_error

    mov al, [xshape_thickness_input]

    cmp al, '1'
    je xshape_thickness_valid

    cmp al, '2'
    je xshape_thickness_valid

    jmp xshape_thickness_error


xshape_thickness_valid:

    sub al, '0'
    mov [xshape_thickness], al

    jmp xshape_ask_char


xshape_thickness_error:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_invalid_thickness
    mov rdx, xshape_invalid_thickness_len
    syscall

    jmp xshape_ask_thickness


; ============================================================
; 3. SELECT DRAWING CHARACTER
; ============================================================

xshape_ask_char:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_char_prompt
    mov rdx, xshape_char_prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, xshape_char_input
    mov rdx, 64
    syscall

    cmp rax, 2
    jne xshape_char_error

    cmp byte [xshape_char_input + 1], 10
    jne xshape_char_error

    mov al, [xshape_char_input]

    cmp al, '1'
    je xshape_use_star

    cmp al, '2'
    je xshape_use_hash

    jmp xshape_char_error


xshape_use_star:

    mov byte [xshape_char], '*'
    jmp xshape_ask_color


xshape_use_hash:

    mov byte [xshape_char], '#'
    jmp xshape_ask_color


xshape_char_error:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_invalid_char
    mov rdx, xshape_invalid_char_len
    syscall

    jmp xshape_ask_char


; ============================================================
; 4. SELECT COLOR
; ============================================================

xshape_ask_color:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_color_prompt
    mov rdx, xshape_color_prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, xshape_color_input
    mov rdx, 64
    syscall

    cmp rax, 2
    jne xshape_color_error

    cmp byte [xshape_color_input + 1], 10
    jne xshape_color_error

    mov al, [xshape_color_input]

    cmp al, '1'
    jb xshape_color_error

    cmp al, '7'
    ja xshape_color_error

    sub al, '0'
    mov [xshape_color], al

    jmp xshape_apply_color


xshape_color_error:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_invalid_color
    mov rdx, xshape_invalid_color_len
    syscall

    jmp xshape_ask_color


; ============================================================
; 5. APPLY COLOR
; ============================================================

xshape_apply_color:

    mov al, [xshape_color]

    cmp al, 1
    je xshape_set_red

    cmp al, 2
    je xshape_set_green

    cmp al, 3
    je xshape_set_yellow

    cmp al, 4
    je xshape_set_blue

    cmp al, 5
    je xshape_set_magenta

    cmp al, 6
    je xshape_set_cyan

    cmp al, 7
    je xshape_set_white


xshape_set_red:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_red
    mov rdx, xshape_red_len
    syscall
    jmp xshape_start


xshape_set_green:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_green
    mov rdx, xshape_green_len
    syscall
    jmp xshape_start


xshape_set_yellow:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_yellow
    mov rdx, xshape_yellow_len
    syscall
    jmp xshape_start


xshape_set_blue:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_blue
    mov rdx, xshape_blue_len
    syscall
    jmp xshape_start


xshape_set_magenta:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_magenta
    mov rdx, xshape_magenta_len
    syscall
    jmp xshape_start


xshape_set_cyan:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_cyan
    mov rdx, xshape_cyan_len
    syscall
    jmp xshape_start


xshape_set_white:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_white
    mov rdx, xshape_white_len
    syscall
    jmp xshape_start


; ============================================================
; 6. GENERATE X
;
; Haneen's original idea:
;
; character is printed when:
;
; column = row
;
; OR
;
; column = (size - 1) - row
;
; ============================================================

xshape_start:

    ; R8B = row
    mov r8b, 0


xshape_row_loop:

    ; R9B = column
    mov r9b, 0

    ; R10B = opposite diagonal position
    ;
    ; opposite = (size - 1) - row
    mov r10b, [xshape_size]
    dec r10b
    sub r10b, r8b


xshape_column_loop:

    ; --------------------------------------------------------
    ; Main diagonal:
    ; column == row
    ; --------------------------------------------------------

    cmp r9b, r8b
    je xshape_print_char

    ; --------------------------------------------------------
    ; Opposite diagonal:
    ; column == (size - 1) - row
    ; --------------------------------------------------------

    cmp r9b, r10b
    je xshape_print_char


    ; --------------------------------------------------------
    ; If normal thickness was selected, everything else
    ; is a space.
    ; --------------------------------------------------------

    cmp byte [xshape_thickness], 1
    je xshape_print_space


    ; ========================================================
    ; THICK MODE
    ;
    ; Print beside either diagonal as well.
    ; ========================================================

    ; column + 1 == row
    mov al, r9b
    inc al
    cmp al, r8b
    je xshape_print_char

    ; column == row + 1
    mov al, r8b
    inc al
    cmp r9b, al
    je xshape_print_char

    ; column + 1 == opposite diagonal
    mov al, r9b
    inc al
    cmp al, r10b
    je xshape_print_char

    ; column == opposite diagonal + 1
    mov al, r10b
    inc al
    cmp r9b, al
    je xshape_print_char


; ============================================================
; PRINT SPACE
; ============================================================

xshape_print_space:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_space
    mov rdx, 1
    syscall

    jmp xshape_next_column


; ============================================================
; PRINT SELECTED CHARACTER
; ============================================================

xshape_print_char:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_char
    mov rdx, 1
    syscall


; ============================================================
; NEXT COLUMN
; ============================================================

xshape_next_column:

    inc r9b

    mov al, [xshape_size]

    cmp r9b, al
    jl xshape_column_loop


; ============================================================
; END OF ROW
; ============================================================

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_newline
    mov rdx, 1
    syscall

    inc r8b

    mov al, [xshape_size]

    cmp r8b, al
    jl xshape_row_loop


; ============================================================
; 7. FINISH
; ============================================================

xshape_finish:

    ; Reset terminal color
    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_reset
    mov rdx, xshape_reset_len
    syscall

    ; Return to shared main menu
    jmp main_menu
