section .data

    ; =========================================================
    ; PROMPTS AND ERROR MESSAGES
    ; =========================================================

    pyramid_height_prompt db "Enter pyramid height (2-9): "
    pyramid_height_prompt_len equ $ - pyramid_height_prompt

    pyramid_invalid_height_msg db "Invalid height. Enter one digit from 2 to 9.", 10
    pyramid_invalid_height_len equ $ - pyramid_invalid_height_msg


    pyramid_style_prompt db "Select pyramid style:", 10
                         db "1. Filled", 10
                         db "2. Hollow", 10
                         db "Enter choice: "
    pyramid_style_prompt_len equ $ - pyramid_style_prompt

    pyramid_invalid_style_msg db "Invalid style. Enter 1 or 2.", 10
    pyramid_invalid_style_len equ $ - pyramid_invalid_style_msg


    pyramid_char_prompt db "Select drawing character:", 10
                    db "1. *", 10
                    db "2. #", 10
                    db "Enter choice: "
    pyramid_char_prompt_len equ $ - pyramid_char_prompt

    pyramid_invalid_char_msg db "Invalid choice. Enter 1 or 2.", 10
    pyramid_invalid_char_len equ $ - pyramid_invalid_char_msg


    pyramid_color_prompt db "Select color:", 10
                         db "1. Red", 10
                         db "2. Green", 10
                         db "3. Yellow", 10
                         db "4. Blue", 10
                         db "5. Magenta", 10
                         db "6. Cyan", 10
                         db "7. White", 10
                         db "Enter choice: "
    pyramid_color_prompt_len equ $ - pyramid_color_prompt

    pyramid_invalid_color_msg db "Invalid color. Enter a value from 1 to 7.", 10
    pyramid_invalid_color_len equ $ - pyramid_invalid_color_msg


    ; =========================================================
    ; CHARACTERS USED WHEN DRAWING
    ; =========================================================

    pyramid_space db " "
    pyramid_newline db 10


    ; =========================================================
    ; ANSI TERMINAL COLOR CODES
    ; =========================================================

    pyramid_red_color db 27, "[31m"
    pyramid_red_len equ $ - pyramid_red_color

    pyramid_green_color db 27, "[32m"
    pyramid_green_len equ $ - pyramid_green_color

    pyramid_yellow_color db 27, "[33m"
    pyramid_yellow_len equ $ - pyramid_yellow_color

    pyramid_blue_color db 27, "[34m"
    pyramid_blue_len equ $ - pyramid_blue_color

    pyramid_magenta_color db 27, "[35m"
    pyramid_magenta_len equ $ - pyramid_magenta_color

    pyramid_cyan_color db 27, "[36m"
    pyramid_cyan_len equ $ - pyramid_cyan_color

    pyramid_white_color db 27, "[37m"
    pyramid_white_len equ $ - pyramid_white_color

    pyramid_reset_color db 27, "[0m"
    pyramid_reset_len equ $ - pyramid_reset_color


section .bss

    ; Larger buffers allow unexpected inputs such as:
    ; -1, gf, 12, abc, etc. to be consumed cleanly.
    pyramid_height_input resb 64
    pyramid_style_input  resb 64
    pyramid_char_input   resb 64
    pyramid_color_input  resb 64

    ; Validated values
    pyramid_height resb 1
    pyramid_style  resb 1
    pyramid_char   resb 1
    pyramid_color  resb 1


section .text


; =============================================================
; PYRAMID START
; =============================================================

pyramid:


; =============================================================
; 1. READ AND VALIDATE HEIGHT
; =============================================================

pyramid_ask_height:

    ; Print height prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_height_prompt
    mov rdx, pyramid_height_prompt_len
    syscall

    ; Read user input
    mov rax, 0
    mov rdi, 0
    mov rsi, pyramid_height_input
    mov rdx, 64
    syscall

    ; We expect exactly:
    ; one character + Enter
    ; Example: '5' + newline = 2 bytes
    cmp rax, 2
    jne pyramid_invalid_height

    ; Make sure second byte is newline
    cmp byte [pyramid_height_input + 1], 10
    jne pyramid_invalid_height

    ; Get first character
    mov al, [pyramid_height_input]

    ; Must be between ASCII '2' and '9'
    cmp al, '2'
    jb pyramid_invalid_height

    cmp al, '9'
    ja pyramid_invalid_height

    ; Convert ASCII character to number
    sub al, '0'

    ; Store validated height
    mov [pyramid_height], al

    jmp pyramid_ask_style


pyramid_invalid_height:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_invalid_height_msg
    mov rdx, pyramid_invalid_height_len
    syscall

    jmp pyramid_ask_height


; =============================================================
; 2. READ AND VALIDATE STYLE
; =============================================================

pyramid_ask_style:

    ; Print style menu
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_style_prompt
    mov rdx, pyramid_style_prompt_len
    syscall

    ; Read style
    mov rax, 0
    mov rdi, 0
    mov rsi, pyramid_style_input
    mov rdx, 64
    syscall

    ; Require one character + Enter
    cmp rax, 2
    jne pyramid_invalid_style

    cmp byte [pyramid_style_input + 1], 10
    jne pyramid_invalid_style

    mov al, [pyramid_style_input]

    cmp al, '1'
    je pyramid_style_valid

    cmp al, '2'
    je pyramid_style_valid

    jmp pyramid_invalid_style


pyramid_style_valid:

    ; Convert ASCII '1' or '2'
    sub al, '0'

    mov [pyramid_style], al

    jmp pyramid_ask_character


pyramid_invalid_style:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_invalid_style_msg
    mov rdx, pyramid_invalid_style_len
    syscall

    jmp pyramid_ask_style


; =============================================================
; 3. READ DRAWING CHARACTER
; =============================================================

pyramid_ask_character:

    ; Print character menu
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_char_prompt
    mov rdx, pyramid_char_prompt_len
    syscall

    ; Read choice
    mov rax, 0
    mov rdi, 0
    mov rsi, pyramid_char_input
    mov rdx, 64
    syscall

    ; Require one character + Enter
    cmp rax, 2
    jne pyramid_invalid_character

    cmp byte [pyramid_char_input + 1], 10
    jne pyramid_invalid_character

    mov al, [pyramid_char_input]

    ; Choice 1 = *
    cmp al, '1'
    je pyramid_use_star

    ; Choice 2 = #
    cmp al, '2'
    je pyramid_use_hash

    jmp pyramid_invalid_character


pyramid_use_star:

    mov byte [pyramid_char], '*'
    jmp pyramid_ask_color


pyramid_use_hash:

    mov byte [pyramid_char], '#'
    jmp pyramid_ask_color


pyramid_invalid_character:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_invalid_char_msg
    mov rdx, pyramid_invalid_char_len
    syscall

    jmp pyramid_ask_character



; =============================================================
; 4. READ AND VALIDATE COLOR
; =============================================================

pyramid_ask_color:

    ; Print color menu
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_color_prompt
    mov rdx, pyramid_color_prompt_len
    syscall

    ; Read color
    mov rax, 0
    mov rdi, 0
    mov rsi, pyramid_color_input
    mov rdx, 64
    syscall

    ; Require one digit + Enter
    cmp rax, 2
    jne pyramid_invalid_color

    cmp byte [pyramid_color_input + 1], 10
    jne pyramid_invalid_color

    mov al, [pyramid_color_input]

    cmp al, '1'
    jb pyramid_invalid_color

    cmp al, '7'
    ja pyramid_invalid_color

    ; Convert ASCII to numeric value
    sub al, '0'

    mov [pyramid_color], al

    jmp pyramid_apply_color


pyramid_invalid_color:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_invalid_color_msg
    mov rdx, pyramid_invalid_color_len
    syscall

    jmp pyramid_ask_color


; =============================================================
; 5. APPLY SELECTED COLOR
; =============================================================

pyramid_apply_color:

    mov al, [pyramid_color]

    cmp al, 1
    je pyramid_set_red

    cmp al, 2
    je pyramid_set_green

    cmp al, 3
    je pyramid_set_yellow

    cmp al, 4
    je pyramid_set_blue

    cmp al, 5
    je pyramid_set_magenta

    cmp al, 6
    je pyramid_set_cyan

    cmp al, 7
    je pyramid_set_white


pyramid_set_red:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_red_color
    mov rdx, pyramid_red_len
    syscall

    jmp pyramid_start_rows


pyramid_set_green:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_green_color
    mov rdx, pyramid_green_len
    syscall

    jmp pyramid_start_rows


pyramid_set_yellow:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_yellow_color
    mov rdx, pyramid_yellow_len
    syscall

    jmp pyramid_start_rows


pyramid_set_blue:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_blue_color
    mov rdx, pyramid_blue_len
    syscall

    jmp pyramid_start_rows


pyramid_set_magenta:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_magenta_color
    mov rdx, pyramid_magenta_len
    syscall

    jmp pyramid_start_rows


pyramid_set_cyan:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_cyan_color
    mov rdx, pyramid_cyan_len
    syscall

    jmp pyramid_start_rows


pyramid_set_white:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_white_color
    mov rdx, pyramid_white_len
    syscall

    jmp pyramid_start_rows


; =============================================================
; 6. START PYRAMID GENERATION
; =============================================================

pyramid_start_rows:

    ; R8B = current row
    mov r8b, 1


; =============================================================
; OUTER ROW LOOP
; =============================================================

pyramid_row_loop:

    ; ---------------------------------------------------------
    ; Calculate leading spaces:
    ;
    ; spaces = height - row
    ;
    ; R9B = number of leading spaces
    ; ---------------------------------------------------------

    mov r9b, [pyramid_height]
    sub r9b, r8b


; =============================================================
; LEADING SPACE LOOP
; =============================================================

pyramid_space_loop:

    cmp r9b, 0
    je pyramid_prepare_width

    ; Print one space
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_space
    mov rdx, 1
    syscall

    dec r9b

    jmp pyramid_space_loop


; =============================================================
; CALCULATE WIDTH OF CURRENT ROW
; =============================================================

pyramid_prepare_width:

    ; stars/width = (2 * row) - 1
    ;
    ; R10B = total width of current pyramid row

    mov r10b, r8b
    add r10b, r8b
    dec r10b

    ; Check selected style
    cmp byte [pyramid_style], 1
    je pyramid_filled_loop

    ; Otherwise style = 2 (Hollow)
    mov r12b, 1

    jmp pyramid_hollow_loop


; =============================================================
; FILLED PYRAMID LOOP
; =============================================================

pyramid_filled_loop:

    cmp r10b, 0
    je pyramid_newline_output

    ; Print selected drawing character
    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_char
    mov rdx, 1
    syscall

    dec r10b

    jmp pyramid_filled_loop


; =============================================================
; HOLLOW PYRAMID LOOP
;
; R12B = current horizontal position
; R10B = width of current row
; =============================================================

pyramid_hollow_loop:

    ; If position > row width, row is complete
    cmp r12b, r10b
    ja pyramid_newline_output


    ; ---------------------------------------------------------
    ; Bottom row must be completely filled
    ; ---------------------------------------------------------

    mov al, [pyramid_height]

    cmp r8b, al
    je pyramid_hollow_print_character


    ; ---------------------------------------------------------
    ; First position of row = border
    ; ---------------------------------------------------------

    cmp r12b, 1
    je pyramid_hollow_print_character


    ; ---------------------------------------------------------
    ; Last position of row = border
    ; ---------------------------------------------------------

    cmp r12b, r10b
    je pyramid_hollow_print_character


    ; ---------------------------------------------------------
    ; Interior position = space
    ; ---------------------------------------------------------

pyramid_hollow_print_space:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_space
    mov rdx, 1
    syscall

    inc r12b

    jmp pyramid_hollow_loop


; =============================================================
; PRINT HOLLOW BORDER CHARACTER
; =============================================================

pyramid_hollow_print_character:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_char
    mov rdx, 1
    syscall

    inc r12b

    jmp pyramid_hollow_loop


; =============================================================
; NEWLINE AFTER EACH ROW
; =============================================================

pyramid_newline_output:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_newline
    mov rdx, 1
    syscall


    ; Move to next row
    inc r8b


    ; Continue while row <= height
    mov al, [pyramid_height]

    cmp r8b, al
    jle pyramid_row_loop


; =============================================================
; 7. RESET TERMINAL COLOR
; =============================================================

pyramid_finish:

    mov rax, 1
    mov rdi, 1
    mov rsi, pyramid_reset_color
    mov rdx, pyramid_reset_len
    syscall


    ; Return to shared program menu
    jmp main_menu
