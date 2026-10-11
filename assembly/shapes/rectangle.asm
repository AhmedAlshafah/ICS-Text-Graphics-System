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
   ; --- Get rectangle width ---
    lea r14, [rel rect_width_prompt]
    mov r15, rect_width_len
    call rect_get_valid_input
    mov [rect_width], rax

    ; --- Get rectangle height ---
    lea r14, [rel rect_height_prompt]
    mov r15, rect_height_len
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
; ==========================================
; Read and validate rectangle input (1-9)
; ==========================================

rect_get_valid_input:

    ; Display the current prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, r14
    mov rdx, r15
    syscall

    ; Reset character counter
    xor r8, r8


; --- Read one character at a time ---

rect_read_char:

    mov rax, 0
    mov rdi, 0
    mov rsi, rect_input
    mov rdx, 1
    syscall

    ; Exit if input cannot be read
    cmp rax, 1
    jne exit_program

    mov al, [rect_input]

    ; Check for Enter
    cmp al, 10
    je rect_validate

    ; Keep count at 2 once input is too long
    cmp r8, 2
    jae rect_read_char

    inc r8

    ; Save the first character
    cmp r8, 1
    jne rect_read_char

    mov r9b, al
    jmp rect_read_char


; --- Validate input ---

rect_validate:

    ; Must contain exactly one character
    cmp r8, 1
    jne rect_input_error

    ; Must be between '1' and '9'
    cmp r9b, '1'
    jb rect_input_error

    cmp r9b, '9'
    ja rect_input_error

    ; Convert ASCII digit to integer
    movzx eax, r9b
    sub eax, '0'

    ret


; --- Handle invalid input ---

rect_input_error:

    mov rax, 1
    mov rdi, 1
    mov rsi, rect_invalid_msg
    mov rdx, rect_invalid_len
    syscall

    ; Repeat the correct prompt
    jmp rect_get_valid_input

