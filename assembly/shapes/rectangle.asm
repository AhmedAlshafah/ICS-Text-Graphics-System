section .data
    rect_width_prompt     db "Enter rectangle width (1-9): "
    rect_width_len        equ $ - rect_width_prompt
    
    rect_height_prompt    db "Enter rectangle height (1-9): "
    rect_height_len       equ $ - rect_height_prompt
    
    rect_fill_prompt      db "Choose fill type (1=Solid, 2=Hollow): "
    rect_fill_len         equ $ - rect_fill_prompt

    rect_style_prompt     db "Choose style (1=Star '*', 2=Hash '#'): "
    rect_style_len        equ $ - rect_style_prompt
    
    rect_invalid_msg      db "Invalid input! Please enter a valid number.", 10
    rect_invalid_len      equ $ - rect_invalid_msg
    
    rect_star             db "* "          
    rect_star_len         equ $ - rect_star

    rect_hash             db "# "
    rect_hash_len         equ $ - rect_hash

    rect_space            db "  "
    rect_space_len        equ $ - rect_space
    
    rect_newline          db 10
    rect_nl_len           equ $ - rect_newline

section .bss
    rect_input            resb 256          
    rect_width            resq 1            
    rect_height           resq 1            
    rect_fill             resq 1
    rect_style            resq 1

section .text
    global rectangle
    extern main_menu
    extern exit_program

rectangle:
    ; --- Get rectangle width (1-9) ---
    lea r14, [rel rect_width_prompt]
    mov r15, rect_width_len
    mov rbx, 9                      ; Max limit = 9
    call rect_get_valid_input
    mov [rect_width], rax

    ; --- Get rectangle height (1-9) ---
    lea r14, [rel rect_height_prompt]
    mov r15, rect_height_len
    mov rbx, 9                      ; Max limit = 9
    call rect_get_valid_input
    mov [rect_height], rax

    ; --- Get Fill Type (1-2) ---
    lea r14, [rel rect_fill_prompt]
    mov r15, rect_fill_len
    mov rbx, 2                      ; Max limit = 2
    call rect_get_valid_input
    mov [rect_fill], rax

    ; --- Get Style Option (1-2) ---
    lea r14, [rel rect_style_prompt]
    mov r15, rect_style_len
    mov rbx, 2                      ; Max limit = 2
    call rect_get_valid_input
    mov [rect_style], rax

    ; --- Outer Loop (Rows / Height) ---
    mov rcx, [rect_height]          ; rcx = row counter

rect_row_loop:
    push rcx                        ; Preserve row counter from syscalls

    ; Calculate current row (1-based): r12 = rect_height - rcx + 1
    mov rax, [rect_height]
    sub rax, rcx
    inc rax
    mov r12, rax                    ; r12 = current row

    ; --- Inner Loop (Columns / Width) ---
    mov rbx, [rect_width]           ; rbx = col counter

rect_col_loop:
    push rbx                        ; Preserve col counter from syscalls

    ; Calculate current col (1-based): r13 = rect_width - rbx + 1
    mov rax, [rect_width]
    sub rax, rbx
    inc rax
    mov r13, rax                    ; r13 = current col

    ; Solid vs Hollow check
    mov rax, [rect_fill]
    cmp rax, 2                      ; Check if Hollow (2)
    jne rect_print_char             ; If solid (1), print character directly

    ; Hollow boundary check (Top, Bottom, Left, Right)
    cmp r12, 1                      ; Top row?
    je rect_print_char
    mov rax, [rect_height]
    cmp r12, rax                    ; Bottom row?
    je rect_print_char
    cmp r13, 1                      ; Left col?
    je rect_print_char
    mov rax, [rect_width]
    cmp r13, rax                    ; Right col?
    je rect_print_char

    ; Print space for hollow interior
    jmp rect_print_space

rect_print_char:
    ; Style character selection
    mov rax, [rect_style]
    cmp rax, 2
    je rect_use_hash

    mov rsi, rect_star              ; Style 1: Star (* )
    jmp rect_do_syscall

rect_use_hash:
    mov rsi, rect_hash              ; Style 2: Hash (# )
    jmp rect_do_syscall

rect_print_space:
    mov rsi, rect_space

rect_do_syscall:
    ; Print character/space (2 bytes)
    mov rax, 1
    mov rdi, 1
    mov rdx, 2                      
    syscall

    pop rbx                         ; Restore col counter
    dec rbx
    jnz rect_col_loop

    ; Print Newline after each row
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_newline
    mov rdx, 1
    syscall

    pop rcx                         ; Restore row counter
    dec rcx
    jnz rect_row_loop

rect_return_to_main:        
    jmp main_menu            

; ==========================================
; Read and validate input dynamically
; rbx contains the maximum allowed number (e.g. 9 or 2)
; ==========================================

rect_get_valid_input:
    push rbx                        ; Save max limit across syscalls

    ; Display current prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, r14
    mov rdx, r15
    syscall

    pop rbx                         ; Restore max limit
    xor r8, r8                      ; Reset character counter

rect_read_char:
    push rbx
    mov rax, 0
    mov rdi, 0
    mov rsi, rect_input
    mov rdx, 1
    syscall
    pop rbx

    cmp rax, 1
    jne exit_program

    mov al, [rect_input]
    cmp al, 10
    je rect_validate

    cmp r8, 2
    jae rect_read_char

    inc r8
    cmp r8, 1
    jne rect_read_char

    mov r9b, al
    jmp rect_read_char

rect_validate:
    cmp r8, 1
    jne rect_input_error

    cmp r9b, '1'
    jb rect_input_error

    ; Compare against the max limit stored in rbx
    mov r10b, '0'
    add r10b, bl
    cmp r9b, r10b
    ja rect_input_error

    movzx eax, r9b
    sub eax, '0'
    ret

rect_input_error:
    push rbx
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_invalid_msg
    mov rdx, rect_invalid_len
    syscall
    pop rbx

    ; Return all the way back to the main menu on invalid input
    jmp main_menu
