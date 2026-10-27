section .data

xshape_size_prompt db "Enter X size (1-9): "
xshape_size_prompt_len equ $ - xshape_size_prompt

xshape_invalid_size db "Invalid size! Use 1-9.", 10
xshape_invalid_size_len equ $ - xshape_invalid_size

xshape_star db "*"
xshape_space db " "
xshape_newline db 10


section .bss

xshape_size_input resb 64
xshape_size       resb 1


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

    ; exactly one digit + Enter
    cmp rax, 2
    jne xshape_size_error

    cmp byte [xshape_size_input + 1], 10
    jne xshape_size_error

    mov al, [xshape_size_input]

    cmp al, '1'
    jb xshape_size_error

    cmp al, '9'
    ja xshape_size_error

    sub al, '0'
    mov [xshape_size], al

    jmp xshape_start


xshape_size_error:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_invalid_size
    mov rdx, xshape_invalid_size_len
    syscall

    jmp xshape_ask_size


; ============================================================
; 2. GENERATE X
;
; Haneen's original idea:
;
; a character is printed when:
;
; column = row
;
; OR
;
; column = (size - 1) - row
; ============================================================

xshape_start:

    ; R8B = row
    mov r8b, 0

xshape_row_loop:

    ; R9B = column
    mov r9b, 0

    ; R10B = opposite diagonal position
    ; opposite = (size - 1) - row
    mov r10b, [xshape_size]
    dec r10b
    sub r10b, r8b

xshape_column_loop:

    ; main diagonal: column == row
    cmp r9b, r8b
    je xshape_print_star

    ; anti-diagonal: column == (size - 1) - row
    cmp r9b, r10b
    je xshape_print_star

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_space
    mov rdx, 1
    syscall

    jmp xshape_print_sep


xshape_print_star:

    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_star
    mov rdx, 1
    syscall


xshape_print_sep:

    ; one extra space after every cell, same spacing as the other shapes
    mov rax, 1
    mov rdi, 1
    mov rsi, xshape_space
    mov rdx, 1
    syscall

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
; 3. FINISH
; ============================================================

xshape_finish:

    ; return to shared main menu
    jmp main_menu