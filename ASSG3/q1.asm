section .bss
num: resb 2
char: resb 1
count: resb 1
temp: resb 2
array: resb 100
n: resb 1
first: resb 1
last: resb 1
mid: resb 1

section .data
str1: db "Enter n:"
len1: equ $-str1
str2: db "Enter the sorted array:"
len2: equ $-str2
str3: db "FOUND"
len3: equ $-str3
str4: db "NOT FOUND"
len4: equ $-str4
str5: db 'Enter the element to be searched:'
len5: equ $-str5

section .text
global _start

_start:
	;Accept n
	mov eax, 4
	mov ebx, 1
	mov ecx, str1
	mov edx, len1
	int 80h
	call read_num
	mov al, byte[num]
	mov byte[n], al

	;Accept array
	mov eax, 4
	mov ebx, 1
	mov ecx, str2
	mov edx, len2
	int 80h
	call accept_array

	;Accept element to be searched
	mov eax, 4
	mov ebx, 1
	mov ecx, str5
	mov edx, len5
	int 80h
	call read_num

	;Binary Search
	mov byte[first], 0
	mov al, byte[n]
	mov byte[last], al
	dec byte[last]
	mov ax, word[num]
	bsearch:
		mov bl, byte[first]
		cmp bl, byte[last]
		ja notfound
		call find_mid
		movzx ebx, byte[mid]
		add bl, byte[mid]
		cmp word[array + ebx], ax
		je found
		jb upper
		mov bl, byte[mid]
		dec bl
		mov byte[last], bl
		jmp bsearch
	upper:
		mov bl, byte[mid]
		inc bl
		mov byte[first], bl
		jmp bsearch
	found:
		mov eax, 4
		mov ebx, 1
		mov ecx, str3
		mov edx, len3
		int 80h
		jmp exit
	notfound: 
		mov eax, 4
		mov ebx, 1
		mov ecx, str4
		mov edx, len4
		int 80h
	exit:
		mov eax, 1
		mov ebx, 0
		int 80h
	
	find_mid:
		pusha
		movzx ax, byte[first]
		add al, byte[last]
		mov bl, 2
		div bl
		mov byte[mid], al
		popa 
		ret

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

