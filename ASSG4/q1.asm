section .bss
num: resb 2
char: resb 1
count: resb 1
temp: resb 2
string: resb 100
n: resb 1
decrement: resd 1

section .data
str1: db 'Enter the string:'
len1: equ $-str1
str2: db 'Words:'
len2: equ $-str2
str3: db 'Special Characters:'
len3: equ $-str3
str4: db 'Digits:'
len4: equ $-str4
str5: db 'Alphabets:'
len5: equ $-str5
len: dd 0
words: dw 1
alpha: dw 0
special: dw 0
digits: dw 0

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
    mov ebx, string
    loop:
        cmp byte[ebx],0
        je exitloop

        cmp byte[ebx], 32
        jne AlphaNoCaps
        inc word[words]
        jmp continue
    AlphaNoCaps: 
        cmp byte[ebx], 97
        jb AlphaCaps
        cmp byte[ebx], 122
        ja Special
        inc word[alpha]
        jmp continue
    AlphaCaps:
        cmp byte[ebx], 65
        jb Digits
        cmp byte[ebx], 90
        ja Special
        inc word[alpha]
        jmp continue
    Digits:
        cmp byte[ebx], 48
        jb Special
        cmp byte[ebx], 57
        ja Special
        inc word[digits]
        jmp continue
    Special:
        inc word[special]

    continue:
        inc ebx
        jmp loop
    exitloop: 
    ;Words
    mov eax, 4	
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    mov ax, word[words]
    mov word[num], ax
    call print_num
    ;Alphabets
    mov eax, 4	
    mov ebx, 1
    mov ecx, str5
    mov edx, len5
    int 80h
    mov ax, word[alpha]
    mov word[num], ax
    call print_num
    ;Digits
    mov eax, 4	
    mov ebx, 1
    mov ecx, str4
    mov edx, len4
    int 80h
    mov ax, word[digits]
    mov word[num], ax
    call print_num
    ;Special
    mov eax, 4	
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    mov ax, word[special]
    mov word[num], ax
    call print_num
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
        mov dword[decrement], ebx
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
		jmp newline
	print_digits:
		cmp byte[count], 0
		je newline
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
    newline:
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
