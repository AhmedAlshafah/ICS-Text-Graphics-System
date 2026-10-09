section .data
    rect_star db "* ", 0
    rect_newline db 10, 0

section .text
    global rectangle
    extern main_menu

rectangle:
    ; Convert ASCII input in r10 to integer (Height/Size)
    sub r10, '0'

    ; If height <= 0, return immediately
    cmp r10, 0
    jle return_to_main

    mov r8, r10         ; r8 = row counter (height)
    mov r9, r10         ; r9 = column counter (width)

rect_row_loop:
    cmp r8, 0
    jle return_to_main

    mov r11, 0          ; r11 = current column

rect_col_loop:
    cmp r11, r9
    jge rect_next_row

    call rect_print_star
    inc r11
    jmp rect_col_loop

rect_next_row:
    call rect_print_newline
    dec r8
    jmp rect_row_loop

return_to_main:
    jmp main_menu

; ===================================================
; Local Helper Subroutines
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
