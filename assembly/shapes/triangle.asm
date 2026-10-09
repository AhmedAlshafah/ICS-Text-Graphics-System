; ==========================================
; Shape: Triangle
; Original Developer: Zaya
; Integration: Ahmed
; Parameter: Height (1-9)
; ==========================================

section .data

    zaya_prompt db "Enter triangle height (1-9): "
    zaya_prompt_len equ $ - zaya_prompt

    zaya_invalid_msg db "Invalid height. Enter a number from 1 to 9.", 10
    zaya_invalid_len equ $ - zaya_invalid_msg


section .bss

    zaya_input resb 1
    zaya_line resb 20


section .text

triangle:

    ; ======================================
    ; Ask user for triangle height
    ; ======================================

zaya_prompt_size:

    mov rax, 1
    mov rdi, 1
    mov rsi, zaya_prompt
    mov rdx, zaya_prompt_len
    syscall

    xor r8, r8
    xor r10, r10


    ; ======================================
    ; Read input one character at a time
    ; ======================================

zaya_read_char:

    mov rax, 0
    mov rdi, 0
    mov rsi, zaya_input
    mov rdx, 1
    syscall

    cmp rax, 1
    jne exit_program

    mov al, [zaya_input]

    ; Check whether Enter was pressed
    cmp al, 10
    je zaya_validate

    ; Count characters entered
    inc r8

    ; Save only the first character
    cmp r8, 1
    jne zaya_read_char

    mov r10b, al
    jmp zaya_read_char


    ; ======================================
    ; Validate height (1-9)
    ; ======================================

zaya_validate:

    ; Input must contain exactly one character
    cmp r8, 1
    jne zaya_invalid

    ; Reject characters below '1'
    cmp r10b, '1'
    jb zaya_invalid

    ; Reject characters above '9'
    cmp r10b, '9'
    ja zaya_invalid

    ; Convert ASCII character into integer
    movzx r12, r10b
    sub r12, '0'

    ; Start from row 1
    mov r13, 1

    jmp zaya_row_loop


    ; ======================================
    ; Handle invalid input
    ; ======================================

zaya_invalid:

    mov rax, 1
    mov rdi, 1
    mov rsi, zaya_invalid_msg
    mov rdx, zaya_invalid_len
    syscall

    jmp zaya_prompt_size


    ; ======================================
    ; Generate triangle rows
    ; ======================================

zaya_row_loop:

    ; Check if all rows are completed
    cmp r13, r12
    jg zaya_done

    ; Point to the beginning of line buffer
    lea rdi, [rel zaya_line]

    ; Calculate spaces = height - current row
    mov rcx, r12
    sub rcx, r13

    ; Skip spaces if count is zero
    jz zaya_prepare_stars


    ; ======================================
    ; Fill spaces
    ; ======================================

zaya_fill_spaces:

    mov byte [rdi], ' '
    inc rdi

    dec rcx
    jnz zaya_fill_spaces


    ; ======================================
    ; Calculate stars = 2 * row - 1
    ; ======================================

zaya_prepare_stars:

    mov rcx, r13
    shl rcx, 1
    dec rcx


    ; ======================================
    ; Fill stars
    ; ======================================

zaya_fill_stars:

    mov byte [rdi], '*'
    inc rdi

    dec rcx
    jnz zaya_fill_stars


    ; ======================================
    ; Add newline
    ; ======================================

    mov byte [rdi], 10
    inc rdi


    ; ======================================
    ; Calculate line length and print
    ; ======================================

    mov rdx, rdi
    lea rsi, [rel zaya_line]
    sub rdx, rsi

    mov rax, 1
    mov rdi, 1
    syscall

    ; Move to next row
    inc r13

    jmp zaya_row_loop


    ; ======================================
    ; Return to main menu
    ; ======================================

zaya_done:

    jmp main_menu
