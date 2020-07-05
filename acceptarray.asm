section .bss
num: resb 2
char: resb 1
count: resb 1
temp: resb 2
array: resb 100
n: resb 1

section .data

section .text
global _start

_start:
	call read_num
	mov al, byte[num]
	mov byte[n], al
	call accept_array
	call print_array

	exit:
		mov eax, 1
		mov ebx, 0
		int 80h
	
	print_array:
		pusha
		mov eax, 0
		mov cl, 0
	start_print:
		cmp cl, byte[n]
		je exit_func
		mov bx, word[array + eax]
		mov word[num], bx
		call print_num
		call space
		add eax, 2
		inc cl
		jmp start_print

	space: 
		pusha
		mov byte[temp], 20h
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		jmp exit_func

	accept_array:
		pusha
		mov eax, 0
		mov cl, 0
	start_accept:
		cmp cl, byte[n]
		je exit_func
		call read_num
		mov bx, word[num]
		mov word[array + eax], bx
		add eax, 2
		inc cl
		jmp start_accept

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
		je exit_func
		cmp byte[char], 10
		je exit_func
		sub byte[char], 30h
		mov ax, word[num]
		mov bx, 10
		mul bx
		movzx bx, byte[char]
		add ax, bx
		mov word[num], ax
		jmp read_digit

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
		jmp exit_func
	print_digits:
		cmp byte[count], 0
		je exit_func
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
	
	exit_func:
		popa
		ret

