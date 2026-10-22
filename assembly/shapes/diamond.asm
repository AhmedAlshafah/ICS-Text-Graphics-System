section .data
    arko_p_size db 10, "Enter diamond size (2-9): ", 0
    arko_l_size equ $ - arko_p_size
    arko_p_qty db "Enter quantity (1-9): ", 0
    arko_l_qty equ $ - arko_p_qty
    arko_p_mode db "Mode (1=Filled, 2=Hollow): ", 0
    arko_l_mode equ $ - arko_p_mode
    arko_p_char db "Character (1=Asterisk *, 2=Hash #): ", 0
    arko_l_char equ $ - arko_p_char
    arko_p_color db "Color (1=Red, 2=Green, 3=Blue, 4=Default): ", 0
    arko_l_color equ $ - arko_p_color
    arko_err_msg db "Invalid input! Please enter a valid digit.", 10, 0
    arko_err_len equ $ - arko_err_msg

    arko_col_red db 27, "[31m"
    arko_col_green db 27, "[32m"
    arko_col_blue db 27, "[34m"
    arko_col_reset db 27, "[0m"

    arko_symbol db "* "         
    arko_space db "  "
    arko_newline db 10

section .bss
    arko_input resb 2          
    arko_temp resb 1           
    arko_size resb 1           
    arko_qty resb 1
    arko_mode resb 1
    arko_color resb 1

section .text

; Entry point called by Ahmed's main.asm
diamond:                         
ask_size:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_p_size
    mov rdx, arko_l_size
    syscall
    call arko_read_and_flush
    cmp al, '2'
    jl .err
    cmp al, '9'
    jg .err
    sub al, '0'
    mov [arko_size], al
    jmp ask_qty
.err:
    call arko_print_error
    jmp ask_size

ask_qty:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_p_qty
    mov rdx, arko_l_qty
    syscall
    call arko_read_and_flush
    cmp al, '1'
    jl .err
    cmp al, '9'
    jg .err
    sub al, '0'
    mov [arko_qty], al
    jmp ask_mode
.err:
    call arko_print_error
    jmp ask_qty

ask_mode:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_p_mode
    mov rdx, arko_l_mode
    syscall
    call arko_read_and_flush
    cmp al, '1'
    jl .err
    cmp al, '2'
    jg .err
    mov [arko_mode], al
    jmp ask_char
.err:
    call arko_print_error
    jmp ask_mode

ask_char:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_p_char
    mov rdx, arko_l_char
    syscall
    call arko_read_and_flush
    cmp al, '1'
    je .set_ast
    cmp al, '2'
    je .set_hash
    call arko_print_error
    jmp ask_char
.set_ast:
    mov byte [arko_symbol], '*'   
    jmp ask_color
.set_hash:
    mov byte [arko_symbol], '#'   
    jmp ask_color

ask_color:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_p_color
    mov rdx, arko_l_color
    syscall
    call arko_read_and_flush
    cmp al, '1'
    jl .err
    cmp al, '4'
    jg .err
    mov [arko_color], al
    call arko_apply_color
    jmp start_drawing
.err:
    call arko_print_error
    jmp ask_color

start_drawing:
    movzx r10, byte [arko_size]   
    movzx r12, byte [arko_qty]    
    mov r8, 1                     

qty_loop:
    cmp r8, r12
    jg return_to_main
    mov r13, 1                    
dia_top_row:
    cmp r13, r10             
    jg dia_bot_init         
    mov r9, r10
    sub r9, r13                  
    mov r14, 0              
.space_loop:
    cmp r14, r9
    jge .stars_init
    call arko_print_space
    inc r14
    jmp .space_loop
.stars_init:
    mov r15, r13
    add r15, r13
    dec r15                       
    cmp byte [arko_mode], '2'     
    je .draw_hollow
.draw_filled:
    mov r14, 0              
.f_loop:
    cmp r14, r15
    jge .row_done
    call arko_print_symbol
    inc r14
    jmp .f_loop
.draw_hollow:
    call arko_print_symbol        
    cmp r15, 1
    je .row_done                  
    mov r14, 0
    mov r9, r15
    sub r9, 2                     
.h_space_loop:
    cmp r14, r9
    jge .h_last_star
    call arko_print_space
    inc r14
    jmp .h_space_loop
.h_last_star:
    call arko_print_symbol        
.row_done:
    call arko_print_newline
    inc r13                  
    jmp dia_top_row

dia_bot_init:
    mov r13, r10
    dec r13                       
dia_bot_row:
    cmp r13, 0
    jle qty_next      
    mov r9, r10
    sub r9, r13 
    mov r14, 0 
.space_loop:
    cmp r14, r9
    jge .stars_init
    call arko_print_space
    inc r14
    jmp .space_loop
.stars_init:
    mov r15, r13
    add r15, r13
    dec r15                       
    cmp byte [arko_mode], '2'
    je .draw_hollow
.draw_filled:
    mov r14, 0
.f_loop:
    cmp r14, r15
    jge .row_done
    call arko_print_symbol
    inc r14
    jmp .f_loop
.draw_hollow:
    call arko_print_symbol          
    cmp r15, 1
    je .row_done                  
    mov r14, 0
    mov r9, r15
    sub r9, 2                     
.h_space_loop:
    cmp r14, r9
    jge .h_last_star
    call arko_print_space
    inc r14
    jmp .h_space_loop
.h_last_star:
    call arko_print_symbol          
.row_done:
    call arko_print_newline
    dec r13                  
    jmp dia_bot_row

qty_next:
    call arko_print_newline       
    inc r8
    jmp qty_loop

return_to_main:
    ; Reset color back to default before exiting your shape
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_col_reset
    mov rdx, 5
    syscall

    ; Safely jump back to Ahmed's main menu
    jmp main_menu           

arko_read_and_flush:
    mov rax, 0
    mov rdi, 0
    mov rsi, arko_input
    mov rdx, 2
    syscall
    mov al, byte [arko_input]       
    mov ah, byte [arko_input + 1]   
    cmp ah, 10                      
    je flush_done
flush_loop:
    mov rax, 0
    mov rdi, 0
    mov rsi, arko_temp
    mov rdx, 1
    syscall
    cmp byte [arko_temp], 10
    jne flush_loop
flush_done:
    ret

arko_apply_color:
    mov al, [arko_color]
    cmp al, '1'
    je .red
    cmp al, '2'
    je .green
    cmp al, '3'
    je .blue
    ret 
.red:
    mov rsi, arko_col_red
    jmp .print_col
.green:
    mov rsi, arko_col_green
    jmp .print_col
.blue:
    mov rsi, arko_col_blue
.print_col:
    mov rax, 1
    mov rdi, 1
    mov rdx, 5
    syscall
    ret

arko_print_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_err_msg
    mov rdx, arko_err_len
    syscall
    ret
arko_print_symbol:
    mov rax, 1
    mov rdi, 1
    mov rsi, arko_symbol
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
