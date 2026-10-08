; ==========================================
; Shape: Diamond
; Developer: Arko
; Parameter: size
; ==========================================

section .data
    arko_prompt db "Enter diamond size (1-9): ", 0
    arko_prompt_len equ $ - arko_prompt
    arko_star db "* "
    arko_space db "  "
    arko_newline db 10

section .bss
    arko_param resb 2

section .text
global diamond

diamond:
    ; --- Prompt for size ---
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_prompt
    mov rdx, arko_prompt_len
    syscall

arko_read_input:
    ; --- Read size input ---
    mov rax, 0
    mov rdi, 0
    mov rsi, arko_param
    mov rdx, 2
    syscall

    ; --- Ignore leftover Enter key (Buffer Fix) ---
    movzx r10, byte [arko_param]
    cmp r10, 10                 ; 10 is the ASCII code for Enter (\n)
    je arko_read_input          ; If it is just Enter, loop back and wait for a real number

    ; --- Convert ASCII to Integer ---
    sub r10, '0'                ; Convert character to integer

    ; --- Top Half ---
    mov r8, 1               
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
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_star
    mov rdx, 2
    syscall
    ret

arko_print_space:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_space
    mov rdx, 2
    syscall
    ret

arko_print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_newline
    mov rdx, 1
    syscall
    ret
