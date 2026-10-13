default rel

section .data
    	; Prompts
    	prompt_height db "Enter triangle height (1-9): "
    	prompt_height_len equ $ - prompt_height

    	prompt_style db "Select style - [F]illed or [H]ollow: "
    	prompt_style_len equ $ - prompt_style

	prompt_char db "Enter character to draw (e.g., *, #, @): "
    	prompt_char_len equ $ - prompt_char

    	prompt_color db "Select color [1-Red, 2-Green, 3-Yellow, 4-Blue, 5-Magenta, 6-Cyan]: "
    	prompt_color_len equ $ - prompt_color

    	; Error Messages
    	err_height db "Invalid height. Enter a number from 1 to 9.", 10
    	err_height_len equ $ - err_height

    	err_style db "Invalid style. Enter 'F' or 'H'.", 10
    	err_style_len equ $ - err_style

    	err_color db "Invalid color option. Enter 1 to 6.", 10
    	err_color_len equ $ - err_color

    	newline db 10, 0

    	; ANSI Color Escape Sequences
    	color_reset  db 27, "[0m", 0
    	color_reset_len equ 4
    
    	col_red      db 27, "[31m", 0
    	col_green    db 27, "[32m", 0
    	col_yellow   db 27, "[33m", 0
    	col_blue     db 27, "[34m", 0
    	col_magenta  db 27, "[35m", 0
    	col_cyan     db 27, "[36m", 0

section .bss
    	input_buf   resb 10
    	height      resq 1      ; Integer height (1-9)
    	is_hollow   resb 1      ; 0 for filled, 1 for hollow
    	draw_char   resb 1      ; Character used for drawing
    	color_ptr   resq 1      ; Pointer to selected ANSI color string
    	color_len   resq 1      ; Length of selected color string
    	line_buffer resb 100    ; Line construction buffer

section .text
    	global _start

_start:
    	call get_height
    	call get_style
    	call get_char
    	call get_color
    	call render_triangle

    	; Exit program
    	mov rax, 60
    	xor rdi, rdi
    	syscall

get_height:
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, prompt_height
    	mov rdx, prompt_height_len
    	syscall

    	call read_input
    
    	; Validate: must be single digit '1'-'9'
    	cmp r8, 1
    	jne invalid_height_err
    	mov al, [input_buf]
    	cmp al, '1'
    	jb invalid_height_err
    	cmp al, '9'
    	ja invalid_height_err

    	sub al, '0'
    	movzx rax, al
    	mov [height], rax
    	ret

invalid_height_err:
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, err_height
    	mov rdx, err_height_len
    	syscall
    	jmp get_height

get_style:
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, prompt_style
    	mov rdx, prompt_style_len
    	syscall

    	call read_input
    	cmp r8, 1
    	jne invalid_style_err

    	mov al, [input_buf]
    	; Convert lowercase to uppercase if needed
    	cmp al, 'f'
    	je .set_filled
    	cmp al, 'F'
    	je .set_filled
    	cmp al, 'h'
    	je .set_hollow
    	cmp al, 'H'
    	je .set_hollow
    	jmp invalid_style_err

.set_filled:
    	mov byte [is_hollow], 0
    	ret

.set_hollow:
    	mov byte [is_hollow], 1
    	ret

invalid_style_err:
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, err_style
    	mov rdx, err_style_len
    	syscall
    	jmp get_style

get_char:
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, prompt_char
    	mov rdx, prompt_char_len
    	syscall

    	call read_input
    	cmp r8, 1
    	jl get_char

    	mov al, [input_buf]
    	mov [draw_char], al
    	ret

get_color:
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, prompt_color
    	mov rdx, prompt_color_len
    	syscall

    	call read_input
    	cmp r8, 1
    	jne invalid_color_err

    	mov al, [input_buf]
    	sub al, '0'
    
    	cmp al, 1
    	je .c_red
    	cmp al, 2
    	je .c_green
    	cmp al, 3
    	je .c_yellow
    	cmp al, 4
    	je .c_blue
    	cmp al, 5
    	je .c_magenta
    	cmp al, 6
    	je .c_cyan
    	jmp invalid_color_err

.c_red:
    	mov qword [color_ptr], col_red
    	mov qword [color_len], 5
    	ret
.c_green:
    	mov qword [color_ptr], col_green
    	mov qword [color_len], 5
    	ret
.c_yellow:
    	mov qword [color_ptr], col_yellow
    	mov qword [color_len], 5
    	ret
.c_blue:
    	mov qword [color_ptr], col_blue
    	mov qword [color_len], 5
    	ret
.c_magenta:
    	mov qword [color_ptr], col_magenta
    	mov qword [color_len], 5
    	ret
.c_cyan:
    	mov qword [color_ptr], col_cyan
    	mov qword [color_len], 5
    	ret

invalid_color_err:
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, err_color
    	mov rdx, err_color_len
    	syscall
    	jmp get_color

read_input:
    	mov rax, 0
    	mov rdi, 0
    	mov rsi, input_buf
    	mov rdx, 10
    	syscall
    
    	; Find actual length (strip trailing newline)
    	xor r8, r8
.count_loop:
    	mov al, [input_buf + r8]
    	cmp al, 10
    	je .done
    	cmp al, 0
    	je .done
    	inc r8
    	cmp r8, 9
    	jl .count_loop
.done:
    	ret

render_triangle:
    mov r13, 1              ; r13 = current row (1 to height)
    mov r12, [height]       ; r12 = total height

.row_loop:
    cmp r13, r12
    jg .done_rendering

    lea rdi, [rel line_buffer]

    ; 1. Calculate and fill leading spaces (height - current row)
    mov rcx, r12
    sub rcx, r13
    jz .prepare_chars

.fill_spaces:
    mov byte [rdi], ' '
    inc rdi
    dec rcx
    jnz .fill_spaces

.prepare_chars:
    ; Check if Hollow or Filled
    cmp byte [is_hollow], 1
    je .render_hollow_row

    ; Characters count = 2 * row - 1
    mov rcx, r13
    shl rcx, 1
    dec rcx
    mov al, [draw_char]
.fill_solid:
    mov [rdi], al
    inc rdi
    dec rcx
    jnz .fill_solid
    jmp .print_row

.render_hollow_row:
    ; Row 1 or Last Row are always fully printed
    cmp r13, 1
    je .hollow_top_or_bottom
    cmp r13, r12
    je .hollow_top_or_bottom

    ; Middle rows: 1 char, inner spaces, 1 char
    mov al, [draw_char]
    mov [rdi], al          ; Left boundary character
    inc rdi

    ; Inner spaces count = 2 * row - 3
    mov rcx, r13
    shl rcx, 1
    sub rcx, 3
.fill_inner_spaces:
    mov byte [rdi], ' '
    inc rdi
    dec rcx
    jnz .fill_inner_spaces

    mov al, [draw_char]
    mov [rdi], al          ; Right boundary character
    inc rdi
    jmp .print_row

.hollow_top_or_bottom:
    mov rcx, r13
    shl rcx, 1
    dec rcx
    mov al, [draw_char]
.fill_hollow_solid:
    mov [rdi], al
    inc rdi
    dec rcx
    jnz .fill_hollow_solid

.print_row:
    ; Add newline character
    mov byte [rdi], 10
    inc rdi

    ; Print row with ANSI color formatting applied
    ; Step A: Print Color Code
    push rdi
    push r12
    push r13
    
    mov rax, 1
    mov rdi, 1
    mov rsi, [color_ptr]
    mov rdx, [color_len]
    syscall

    ; Step B: Print Line Buffer Content
    pop r13
    pop r12
    pop rdi

    mov rdx, rdi
    lea rsi, [rel line_buffer]
    sub rdx, rsi

    push rdi
    push r12
    push r13
    mov rax, 1
    mov rdi, 1
    syscall

    ; Step C: Reset Color
    mov rax, 1
    mov rdi, 1
    mov rsi, color_reset
    mov rdx, color_reset_len
    syscall

    pop r13
    pop r12
    pop rdi

    inc r13
    jmp .row_loop

.done_rendering:
	ret
