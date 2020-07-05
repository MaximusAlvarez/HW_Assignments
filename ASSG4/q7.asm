section .bss
num: resb 2
char: resb 1
count: resb 1
temp: resb 2
string: resb 100
newstring: resb 100
n: resb 1

section .data
str1: db 'Enter the string:'
len1: equ $-str1
str2: db 'Enter the character:'
len2: equ $-str2
str3: db 'New string is '
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
	call read_string
    mov eax, 4	
	mov ebx, 1
	mov ecx, str2
	mov edx, len2
	int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, char
    mov edx, 1
    int 80h
    mov ebx, newstring
	mov eax, string
	loop:
		cmp byte[eax], 0
		je exitloop

        mov cl, byte[eax]
        cmp cl, byte[char]
        je continue
        mov byte[ebx], cl
        inc ebx
    continue:
		inc eax
		jmp loop
    exitloop:
        mov byte[ebx], 0
        mov eax, 4	
        mov ebx, 1
        mov ecx, str3
        mov edx, len3
        int 80h
        mov ebx, newstring
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
		mov dl, byte[ebx]
		mov byte[temp], dl
		push ebx
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		pop ebx
		inc ebx
		jmp print_char
	
	exit_func:
		popa
		ret
