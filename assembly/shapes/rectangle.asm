section .data
    rect_width_prompt   db "Enter rectangle width (1-9): "
    rect_width_len      equ $ - rect_width_prompt
    
    rect_height_prompt  db "Enter rectangle height (1-9): "
    rect_height_len     equ $ - rect_height_prompt
    
    rect_invalid_msg    db "Invalid input! Please enter a number between 1 and 9.", 10
    rect_invalid_len    equ $ - rect_invalid_msg
    
    rect_star           db "* "            
    rect_star_len       equ $ - rect_star
    
    rect_newline        db 10
    rect_nl_len         equ $ - rect_newline

section .bss
    rect_input     resb 256          
    rect_width     resq 1            
    rect_height    resq 1            

section .text
    global rectangle
    extern main_menu

rectangle:
    ; --- Prompt and get Width ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_width_prompt
    mov rdx, rect_width_len
    syscall
    call rect_get_valid_input
    mov [rect_width], rax

    ; --- Prompt and get Height ---
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_height_prompt
    mov rdx, rect_height_len
    syscall
    call rect_get_valid_input
    mov [rect_height], rax

    ; --- Outer Loop (Rows / Height) ---
    mov rcx, [rect_height]

rect_row_loop:
    push rcx                

    ; --- Inner Loop (Columns / Width) ---
    mov rcx, [rect_width]

rect_col_loop:
    push rcx                

    ; Print "* "
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_star
    mov rdx, 2              
    syscall

    pop rcx
    loop rect_col_loop

    ; Print Newline after each row
    mov rax, 1
    mov rdi, 1
    mov rsi, rect_newline
    mov rdx, 1
    syscall

    pop rcx
    loop rect_row_loop

rect_return_to_main:        
    jmp main_menu           

; Function to read and validate a number between 1 and 9
rect_get_valid_input:
    mov rax, 0              
    mov rdi, 0              
    mov rsi, rect_input
    mov rdx, 256            
    syscall

    cmp rax, 2
    jne rect_input_error

    movzx rbx, byte [rect_input]
    cmp rbx, '1'
    jl rect_input_error
    cmp rbx, '9'
    jg rect_input_error

    sub rbx, '0'
    mov rax, rbx
    ret

rect_input_error:
    mov rax, 1              
    mov rdi, 1              
    mov rsi, rect_invalid_msg
    mov rdx, rect_invalid_len
    syscall
    jmp rect_get_valid_input

