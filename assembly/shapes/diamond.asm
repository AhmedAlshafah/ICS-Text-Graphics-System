; ==========================================
; Shape: Diamond
; Developer: Arko
; Parameter: size
; ==========================================

section .data
    arko_prompt db "Enter diamond size (1-9): "
    arko_prompt_len equ $ - arko_prompt
    arko_star db "* "
    arko_space db "  "
    arko_newline db 10
    arko_invalid_msg db "Invalid size. Enter a number from 1 to 9.", 10
    arko_invalid_len equ $ - arko_invalid_msg

section .bss
    arko_param resb 2

section .text
global diamond

diamond:
    ; --- Prompt for size ---
arko_prompt_size:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_prompt
    mov rdx, arko_prompt_len
    syscall

    ; --- Prepare to read input ---
arko_read_input:
    xor r8, r8
    xor r10, r10

    ; --- Read one character at a time ---
arko_read_char:
    mov rax, 0
    mov rdi, 0
    mov rsi, arko_param
    mov rdx, 1
    syscall

    cmp rax, 1
    jne exit_program

    mov al, [arko_param]

    ; Check for Enter
    cmp al, 10
    je arko_validate

    ; Count characters
    inc r8

    ; Save only the first character
    cmp r8, 1
    jne arko_read_char

    mov r10b, al
    jmp arko_read_char

    ; --- Validate input ---
arko_validate:
    cmp r8, 1
    jne arko_invalid

    cmp r10b, '1'
    jb arko_invalid

    cmp r10b, '9'
    ja arko_invalid

    ; Convert ASCII to integer
    sub r10, '0'
    jmp arko_start_drawing

    ; --- Invalid input ---
arko_invalid:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_invalid_msg
    mov rdx, arko_invalid_len
    syscall

    jmp arko_prompt_size

    ; --- Start drawing diamond ---
arko_start_drawing:
    mov r8, 1

    ; --- Top Half ---              
dia_top_row:
    cmp r8, r10             
    jg dia_bot_init         
    
    mov r9, r10
    sub r9, r8              
    mov r11, 0              
dia_top_space:
    cmp r11, r9
    jge dia_top_stars
    call arko_print_space
    inc r11
    jmp dia_top_space

dia_top_stars:
    mov r9, r8
    add r9, r8
    dec r9                  
    mov r11, 0              
dia_top_star_loop:
    cmp r11, r9
    jge dia_top_next_row
    call arko_print_star
    inc r11
    jmp dia_top_star_loop

dia_top_next_row:
    call arko_print_newline
    inc r8                  
    jmp dia_top_row

    ; --- Bottom Half ---
dia_bot_init:
    mov r8, r10
    dec r8                  
dia_bot_row:
    cmp r8, 0
    jle return_to_main      
    
    mov r9, r10
    sub r9, r8 
    mov r11, 0 
dia_bot_space:
    cmp r11, r9
    jge dia_bot_stars
    call arko_print_space
    inc r11
    jmp dia_bot_space

dia_bot_stars:
    mov r9, r8
    add r9, r8
    dec r9
    mov r11, 0
dia_bot_star_loop:
    cmp r11, r9
    jge dia_bot_next_row
    call arko_print_star
    inc r11
    jmp dia_bot_star_loop

dia_bot_next_row:
    call arko_print_newline
    dec r8                  
    jmp dia_bot_row

return_to_main:
    jmp main_menu           ; Return control to Ahmed's main menu without closing

; ==========================================
; Local Helper Subroutines
; ==========================================
arko_print_star:
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_star
    mov rdx, 1
    syscall
    pop r11
    ret

arko_print_space:
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_space
    mov rdx, 1
    syscall
    pop r11
    ret

arko_print_newline:
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_newline
    mov rdx, 1
    syscall
    pop r11
    ret
