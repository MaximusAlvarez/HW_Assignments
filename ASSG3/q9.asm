section .bss
num: resb 2
char: resb 1
count: resb 2
temp: resb 2

matrixMul: resb 100
matrixB: resb 100
matrixA: resb 100
m: resb 1
n: resb 1
p: resb 1
q: resb 1
i: resb 1
j: resb 1
k: resb 1
a: resb 2
b: resb 2
sum: resb 2

section .data
str1: db 'Enter m:'
len1: equ $-str1
str2: db 'Enter n:'
str6: db 'Enter p:'
str7: db 'Enter q:'
str3: db 'Enter the first matrix:', 10
len3: equ $-str3
str4: db 'Enter the second matrix:', 10
len4: equ $-str4
str5: db 'The Resultant matrix:', 10
len5: equ $-str5
str8: db 'Matrices cannot be multiplied.'
len8: equ $-str8

section .text
global _start

_start:	
;Accept m
	mov eax, 4
	mov ebx, 1
	mov ecx, str1
	mov edx, len1
	int 80h
	call read_num
	mov al, byte[num]
	mov byte[m], al
;Accept n
	mov eax, 4
	mov ebx, 1
	mov ecx, str2
	mov edx, len1
	int 80h
	call read_num
	mov al, byte[num]
	mov byte[n], al
;Accept p
	mov eax, 4
	mov ebx, 1
	mov ecx, str6
	mov edx, len1
	int 80h
	call read_num
	mov al, byte[num]
	mov byte[p], al
;Accept q
	mov eax, 4
	mov ebx, 1
	mov ecx, str7
	mov edx, len1
	int 80h
	call read_num
	mov al, byte[num]
	mov byte[q], al
;Check if p equal n
	mov al, byte[p]
	cmp al, byte[n]
	je continue
	mov eax, 4
	mov ebx, 1
	mov ecx, str8
	mov edx, len8
	int 80h
	jmp exit
continue:
;Accept matrix A
	mov eax, 4
	mov ebx, 1
	mov ecx, str3
	mov edx, len3
	int 80h

	mov al, byte[m]
	mov bl, byte[n]
	mul bl
	mov word[count], ax
	mov eax, 0
acceptA:	
	cmp ax, word[count]
	je stop_A
	call read_num
	mov bx, word[num]
	mov word[matrixA + 2*eax], bx
	inc eax
	jmp acceptA
stop_A:	
;Accept matrix B
	mov eax, 4
	mov ebx, 1
	mov ecx, str4
	mov edx, len4
	int 80h
	
	mov al, byte[p]
	mov bl, byte[q]
	mul bl
	mov word[count], ax
	mov eax, 0
acceptB:	
	cmp ax, word[count]
	je stop_B
	call read_num
	mov bx, word[num]
	mov word[matrixB + 2*eax], bx
	inc eax
	jmp acceptB
stop_B:
;Multiply and Print
	mov eax, 4
	mov ebx, 1
	mov ecx, str5
	mov edx, len5
	int 80h
	Mul:
		mov byte[i], 0
		mov cl, byte[m]
		mov ch, byte[q]
		mov byte[count], 0
	row:
		mov byte[j], 0
		cmp byte[i], cl
		je exit_row
	col:
		cmp byte[j], ch
		je exit_col
		mov byte[k], 0
		mov word[sum], 0
	inner_loop:
		mov bl, byte[n]
		cmp byte[k], bl
		je exit_innerloop
		
		mov eax, 0
		mov al, byte[i]
		mul bl
		movzx bx, byte[k]
		add ax, bx
		mov bx, word[matrixA+2*eax]
		mov word[a], bx
	
		mov al, byte[k]
		mov bl, byte[q]
		mul bl
		movzx bx, byte[j]
		add ax, bx
		mov bx, word[matrixB+2*eax]
	
		mov ax, word[a]
		mul bx
		add word[sum], ax
	
		inc byte[k]
		jmp inner_loop
	exit_innerloop:	
		movzx eax, byte[count]
		mov bx, word[sum]
		mov word[matrixMul+2*eax], bx
		mov word[num], bx
		call print_num
		call space

		inc byte[count]
		inc byte[j]
		jmp col
	exit_col:
		call newline
		inc byte[i]
		jmp row
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
