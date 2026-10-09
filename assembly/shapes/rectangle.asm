section .data
    rect_prompt_w db "Enter rectangle width: ", 0
    rect_prompt_w_len equ $ - rect_prompt_w
    
    rect_prompt_h db "Enter rectangle height: ", 0
    rect_prompt_h_len equ $ - rect_prompt_h
    
    star db "* "
    newline db 10

section .bss
    buffer resb 16
    width  resq 1
    height resq 1

section .text
    global rectangle

rectangle:
    ; --- Prompt for Width ---
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; stdout
    mov rsi, rect_prompt_w
    mov rdx, rect_prompt_w_len
    syscall

    ; Read Width
    mov rax, 0                  ; sys_read
    mov rdi, 0                  ; stdin
    mov rsi, buffer
    mov rdx, 16
    syscall

    ; Convert ASCII input in buffer to integer -> store in [width]
    mov rsi, buffer
    call ascii_to_int
    mov [width], rax

    ; --- Prompt for Height ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_prompt_h
    mov rdx, rect_prompt_h_len
    syscall

    ; Read Height
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 16
    syscall

    ; Convert ASCII input in buffer to integer -> store in [height]
    mov rsi, buffer
    call ascii_to_int
    mov [height], rax

    ; --- Draw Rectangle Loops ---
    mov r12, [height]           ; Outer loop counter (rows)

row_loop:
    cmp r12, 0
    jle end_rectangle

    mov r13, [width]            ; Inner loop counter (columns)

col_loop:
    cmp r13, 0
    jle end_col

    ; Print "* "
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, 2
    syscall

    dec r13
    jmp col_loop

end_col:
    ; Print newline at end of row
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    dec r12
    jmp row_loop

end_rectangle:
    jmp main_menu               ; Return to main menu when finished

; --- Helper: Convert ASCII string to integer ---
ascii_to_int:
    xor rax, rax                ; Result = 0
.next_digit:
    movzx rbx, byte [rsi]
    cmp rbx, 10                 ; Stop at newline
    je .done
    cmp rbx, '0'
    jl .done
    cmp rbx, '9'
    jg .done
    sub rbx, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .next_digit
.done:
    ret
