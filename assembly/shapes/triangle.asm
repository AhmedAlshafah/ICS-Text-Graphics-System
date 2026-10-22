default rel

section .data
	triangle_prompt_height db "Enter triangle height (1-9): "
	triangle_prompt_height_len equ $ - triangle_prompt_height

	triangle_prompt_style db "Select style - [F]illed or [H]ollow: "
	triangle_prompt_style_len equ $ - triangle_prompt_style

	triangle_prompt_char db "Enter character to draw (e.g., *, #, @): "
	triangle_prompt_char_len equ $ - triangle_prompt_char

	triangle_prompt_color db "Select color [1-Red, 2-Green, 3-Yellow, 4-Blue, 5-Magenta, 6-Cyan]: "
	triangle_prompt_color_len equ $ - triangle_prompt_color

	triangle_err_height db "Invalid height. Enter a number from 1 to 9.", 10
	triangle_err_height_len equ $ - triangle_err_height

	triangle_err_style db "Invalid style. Enter 'F' or 'H'.", 10
	triangle_err_style_len equ $ - triangle_err_style

	triangle_err_color db "Invalid color option. Enter 1 to 6.", 10
	triangle_err_color_len equ $ - triangle_err_color

	triangle_newline db 10, 0

	triangle_color_reset  db 27, "[0m", 0
	triangle_color_reset_len equ 4

	triangle_col_red      db 27, "[31m", 0
	triangle_col_green    db 27, "[32m", 0
	triangle_col_yellow   db 27, "[33m", 0
	triangle_col_blue     db 27, "[34m", 0
	triangle_col_magenta  db 27, "[35m", 0
	triangle_col_cyan     db 27, "[36m", 0

section .bss
	triangle_input_buf    resb 10
	triangle_height        resq 1
	triangle_is_hollow   resb 1
	triangle_draw_char   resb 1
	triangle_color_ptr   resq 1
	triangle_color_len   resq 1
	triangle_line_buffer resb 100
section .text

triangle:
_triangle:
	call triangle_get_height
	call triangle_get_style
	call triangle_get_char
	call triangle_get_color
	call triangle_render

	jmp main_menu

triangle_get_height:
	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_prompt_height
	mov rdx, triangle_prompt_height_len
	syscall

	call triangle_read_input

	cmp r8, 1
	jne triangle_invalid_height_err
	mov al, [triangle_input_buf]
	cmp al, '1'
	jb triangle_invalid_height_err
	cmp al, '9'
	ja triangle_invalid_height_err

	sub al, '0'
	movzx rax, al
	mov [triangle_height], rax
	ret

triangle_invalid_height_err:
	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_err_height
	mov rdx, triangle_err_height_len
	syscall
	jmp triangle_get_height

triangle_get_style:
	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_prompt_style
	mov rdx, triangle_prompt_style_len
	syscall

	call triangle_read_input
	cmp r8, 1
	jne triangle_invalid_style_err

	mov al, [triangle_input_buf]
	cmp al, 'f'
	je .set_filled
	cmp al, 'F'
	je .set_filled
	cmp al, 'h'
	je .set_hollow
	cmp al, 'H'
	je .set_hollow
	jmp triangle_invalid_style_err

.set_filled:
	mov byte [triangle_is_hollow], 0
	ret

.set_hollow:
	mov byte [triangle_is_hollow], 1
	ret

triangle_invalid_style_err:
	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_err_style
	mov rdx, triangle_err_style_len
	syscall
	jmp triangle_get_style

triangle_get_char:
	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_prompt_char
	mov rdx, triangle_prompt_char_len
	syscall

	call triangle_read_input
	cmp r8, 1
	jl triangle_get_char

	mov al, [triangle_input_buf]
	mov [triangle_draw_char], al
	ret

triangle_get_color:
	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_prompt_color
	mov rdx, triangle_prompt_color_len
	syscall

	call triangle_read_input
	cmp r8, 1
	jne triangle_invalid_color_err

	mov al, [triangle_input_buf]
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
	jmp triangle_invalid_color_err

.c_red:
	mov qword [triangle_color_ptr], triangle_col_red
	mov qword [triangle_color_len], 5
	ret

.c_green:
	mov qword [triangle_color_ptr], triangle_col_green
	mov qword [triangle_color_len], 5
	ret

.c_yellow:
	mov qword [triangle_color_ptr], triangle_col_yellow
	mov qword [triangle_color_len], 5
	ret

.c_blue:
	mov qword [triangle_color_ptr], triangle_col_blue
	mov qword [triangle_color_len], 5
	ret

.c_magenta:
	mov qword [triangle_color_ptr], triangle_col_magenta
	mov qword [triangle_color_len], 5
	ret

.c_cyan:
	mov qword [triangle_color_ptr], triangle_col_cyan
	mov qword [triangle_color_len], 5
	ret

triangle_invalid_color_err:
	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_err_color
	mov rdx, triangle_err_color_len
	syscall
	jmp triangle_get_color

triangle_read_input:
	mov rax, 0
	mov rdi, 0
	mov rsi, triangle_input_buf
	mov rdx, 10
	syscall

	xor r8, r8
.count_loop:
	mov al, [triangle_input_buf + r8]
	cmp al, 10
	je .done
	cmp al, 0
	je .done
	inc r8
	cmp r8, 9
	jl .count_loop

.done:
	ret

triangle_render:
	mov r13, 1
	mov r12, [triangle_height]

.row_loop:
	cmp r13, r12
	jg .done_rendering

	lea rdi, [rel triangle_line_buffer]

	mov rcx, r12
	sub rcx, r13
	jz .prepare_chars

.fill_spaces:
	mov byte [rdi], ' '
	inc rdi
	dec rcx
	jnz .fill_spaces

.prepare_chars:
	cmp byte [triangle_is_hollow], 1
	je .render_hollow_row

	mov rcx, r13
	shl rcx, 1
	dec rcx
	mov al, [triangle_draw_char]

.fill_solid:
	mov [rdi], al
	inc rdi
	dec rcx
	jnz .fill_solid
	jmp .print_row

.render_hollow_row:
	cmp r13, 1
	je .hollow_top_or_bottom
	cmp r13, r12
	je .hollow_top_or_bottom

	mov al, [triangle_draw_char]
	mov [rdi], al
	inc rdi

	mov rcx, r13
	shl rcx, 1
	sub rcx, 3

.fill_inner_spaces:
	mov byte [rdi], ' '
	inc rdi
	dec rcx
	jnz .fill_inner_spaces

	mov al, [triangle_draw_char]
	mov [rdi], al
	inc rdi
	jmp .print_row

.hollow_top_or_bottom:
	mov rcx, r13
	shl rcx, 1
	dec rcx
	mov al, [triangle_draw_char]

.fill_hollow_solid:
	mov [rdi], al
	inc rdi
	dec rcx
	jnz .fill_hollow_solid

.print_row:
	mov byte [rdi], 10
	inc rdi

	push rdi
	push r12
	push r13

	mov rax, 1
	mov rdi, 1
	mov rsi, [triangle_color_ptr]
	mov rdx, [triangle_color_len]
	syscall

	pop r13
	pop r12
	pop rdi

	mov rdx, rdi
	lea rsi, [rel triangle_line_buffer]
	sub rdx, rsi

	push rdi
	push r12
	push r13
	mov rax, 1
	mov rdi, 1
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, triangle_color_reset
	mov rdx, triangle_color_reset_len
	syscall

	pop r13
	pop r12
	pop rdi

	inc r13
	jmp .row_loop

.done_rendering:
	ret
