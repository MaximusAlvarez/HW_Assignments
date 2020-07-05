section .bss
num: resb 2
char: resb 1
count: resb 1
temp: resb 2
matrixSum: resb 100
matrixB: resb 100
matrixA: resb 100
n: resb 1
m: resb 1
mn: resb 1
i: resb 1
j: resb 1

section .data
str1: db 'Enter m:'
len1: equ $-str1
str2: db 'Enter n:'
str3: db 'Enter the matrix:', 10
len3: equ $-str3
str4: db 'The Transpose matrix:', 10
len4: equ $-str4

section .text
global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, str1
	mov edx, len1
	int 80h
	call read_num
	mov al, byte[num]
	mov byte[m], al

	mov eax, 4
	mov ebx, 1
	mov ecx, str2
	mov edx, len1
	int 80h
	call read_num
	mov al, byte[num]
	mov byte[n], al
	
	mov bl, byte[m]
	mul bl
	mov byte[mn], al

	mov eax, 4
	mov ebx, 1
	mov ecx, str3
	mov edx, len3
	int 80h
	accept_matrixiA:
		mov byte[j], 0
		mov cl, byte[m]
		mov ch, byte[n]
	acc_rowA:
		mov byte[i], 0
		cmp byte[j], ch
		je exit_rowA
	acc_colA:
		cmp byte[i], cl
		je exit_colA
		
		mov dx, 0
		mov eax, 0
		movzx ax, byte[j]
		movzx bx, cl
		mul bx
		movzx bx, byte[i]
		add ax, bx
		call read_num
		mov bl, byte[num]
		mov byte[matrixA + eax], bl

		movzx ax, byte[i]
		movzx bx, ch
		mul bx
		movzx bx, byte[j]
		add ax, bx
		mov bl, byte[num]
		mov byte[matrixB + eax], bl

		inc byte[i]
		jmp acc_colA
	exit_colA:
		inc byte[j]
		jmp acc_rowA
	exit_rowA:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, str4
	mov edx, len4
	int 80h
	print_matrix:
		mov byte[j], 0
		mov cl, byte[n]
		mov ch, byte[m]
	print_row:
		mov byte[i], 0
		cmp byte[j], ch
		je exit_row
	print_col:
		cmp byte[i], cl
		je exit_col
		
		mov dx, 0
		mov eax, 0
		movzx ax, byte[j]
		movzx bx, cl
		mul bx
		movzx bx, byte[i]
		add ax, bx
		movzx bx, byte[matrixB +eax]
		mov word[num], bx
		call print_num
		call space

		inc byte[i]
		jmp print_col
	exit_col:
		call newline
		inc byte[j]
		jmp print_row
	exit_row:

	exit:
		mov eax, 1
		mov ebx, 0
		int 80h
	
	newline:
		pusha
		mov byte[temp], 10
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		jmp exit_func

	space:
		pusha
		mov byte[temp], 20h
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		jmp exit_func
 
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

