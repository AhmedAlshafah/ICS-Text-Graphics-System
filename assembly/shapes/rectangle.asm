section .data
    rect_prompt db "Enter rectangle size (1-9): ", 0
    rect_prompt_len equ $ - rect_prompt
    rect_star db "* ", 0
    rect_newline db 10, 0

section .bss
    rect_input resb 2

section .text
    global rectangle
    extern main_menu

rectangle:
    ; --- 1. Prompt User for Size ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_prompt
    mov rdx, rect_prompt_len
    syscall

    ; --- 2. Read User Input ---
    mov rax, 0
    mov rdi, 0
    mov rsi, rect_input
    mov rdx, 2
    syscall

    ; --- 3. Convert ASCII to Integer ---
    movzx r10, byte [rect_input]
    sub r10, '0'

    cmp r10, 0
    jle return_to_main

    mov r12, r10        ; r12 = row counter (safe from syscall)

rect_row_loop:
    cmp r12, 0
    jle return_to_main

    mov r13, 0          ; r13 = column counter (safe from syscall)

rect_col_loop:
    cmp r13, r10        ; print r10 columns per row
    jge rect_next_row

    call rect_print_star
    inc r13
    jmp rect_col_loop

rect_next_row:
    call rect_print_newline
    dec r12
    jmp rect_row_loop

return_to_main:
    jmp main_menu

; ===================================================
; Helper Subroutines
; ===================================================

rect_print_star:
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_star
    mov rdx, 2
    syscall
    ret

rect_print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_newline
    mov rdx, 1
    syscall
    ret
