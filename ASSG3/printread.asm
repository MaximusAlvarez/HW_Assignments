section .bss
num: resb 2
char: resb 1
count: resb 1
temp: resb 2

section .data

section .text
global _start

_start:
	call read_num
	call print_num

	exit:
		mov eax, 1
		mov ebx, 0
		int 80h
	
	read_num:
		pusha
		mov word[num], 0
	read_digit:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		cmp byte[char], 20h
		je exit_read
		cmp byte[char], 10
		je exit_read
		sub byte[char], 30h
		mov ax, word[num]
		mov bx, 10
		mul bx
		movzx bx, byte[char]
		add ax, bx
		mov word[num], ax
		jmp read_digit
	exit_read:
		popa
		ret

	print_num:
		pusha
		mov byte[count], 0
		mov ax, word[num]
	extract_digits:
		cmp ax, 0
		je zero
		inc byte[count]
		mov dx, 0
		mov bx, 10
		div bx
		push dx
		jmp extract_digits
	zero:
		cmp byte[count], 0
		jne print_digits
		add byte[count], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, count
		mov edx, 1
		int 80h 
		jmp exit_print
	print_digits:
		cmp byte[count], 0
		je exit_print
		dec byte[count]
		pop dx
		mov byte[temp], dl
		add byte[temp], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		jmp print_digits
	exit_print:
		popa
		ret

