section .data
	triangle_msg db "Triangle selected", 10
	triangle_len equ $ - triangle_msg
	rows equ 5

section .bss
	line resb 32

section .text
	global _start

_start:
	jmp triangle

triangle:
	mov eax, 4
	mov ebx, 1
	mov ecx, triangle_msg
	mov edx, triangle_len
	int 0x80

	mov esi, 1

row_loop:
	cmp esi, rows
	jg finish_triangle

	mov edi, line

	mov ecx, rows
	sub ecx, esi

fill_spaces:
	jecxz setup_stars
	mov byte [edi], ' '
	inc edi
	loop fill_spaces

setup_stars:
	mov ecx, esi
	shl ecx, 1
	dec ecx

fill_stars:
	mov byte [edi], '*'
	inc edi
	loop fill_stars

	mov byte [edi], 0x0A
	inc edi

	mov edx, edi
	sub edx, line

	mov eax, 4
	mov ebx, 1
	mov ecx, line
	int 0x80

	inc esi
	jmp row_loop

finish_triangle:
	jmp main_menu

main_menu:
	; Placeholder for mainmenu
	mov eax, 1
	mov ebx, 0
	int 0x80
