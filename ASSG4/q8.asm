section .bss
num: resb 2
char: resb 1
count: resb 2
temp: resb 2
string: resb 100
n: resb 2

section .data
str1: db 'Enter the string:', 10
len1: equ $-str1
str2: db 'Enter n:'
len2: equ $-str2
str3: db 'Lexicographically sorted:', 10
len3: equ $-str3
len: dd 0

section .text
global _start

_start:
    mov eax, 4	
	mov ebx, 1
	mov ecx, str1
	mov edx, len1
	int 80h
	mov ebx, string
	mov byte[ebx], 32
	inc ebx
	call read_string

    mov eax, string
    format:
        cmp byte[eax], 0
        je exitformat

		cmp byte[eax], 32
		jne continue
		mov ecx, eax
		inc ecx
		loop:
			cmp byte[ecx], 32
			je something
			cmp byte[ecx], 0
			je continue
		something:
			call strcmp
			inc ecx
			jmp loop

	continue:
        inc eax
        jmp format
    exitformat:
	mov ebx, string
	inc ebx
	call print_string
	exit:
		mov eax, 1
		mov ebx, 0
		int 80h

	read_string:
		pusha
	read_char:
		push ebx
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		pop ebx
		cmp byte[char], 10
		je exit_read
		mov al, byte[char]
		mov byte[ebx], al
        inc byte[len]
		inc ebx
		jmp read_char
	exit_read:
		mov byte[ebx], 0
		jmp exit_func

	print_string:
		pusha
	print_char:
		cmp byte[ebx], 0
		je exit_func
		cmp byte[ebx], 1
		je skip
		mov dl, byte[ebx]
		mov byte[temp], dl
		push ebx
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		pop ebx
	skip:
		inc ebx
		jmp print_char
	
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

    strcmp:
        pusha
		push ecx
		inc eax
		inc ecx
    compare:
        mov dl, byte[eax]
        cmp dl, byte[ecx]
        jne check
		cmp dl, 32
		je same

        inc eax
        inc ecx
        jmp compare
    same:
		pop ecx
		push ecx
		inc ecx
	sameloop:
		cmp byte[ecx], 32
		je exit_sameloop
		cmp byte[ecx], 0
		je exit_strcmp
		mov byte[ecx], 1
		inc ecx
		jmp sameloop
	exit_sameloop:
		mov byte[ecx], 1
		jmp exit_strcmp
	check:
		cmp byte[eax], 32
		je same
	exit_strcmp:
		pop ecx
		jmp exit_func
    newline:
        pusha
        mov byte[temp], 10
        mov eax, 4
        mov ebx, 1
        mov ecx, temp
        mov edx, 1
        int 80h
        jmp exit_func

	exit_func:
		popa
		ret