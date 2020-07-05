section .bss
num: resb 2
char: resb 1
count: resb 2
temp: resb 2
strings: resb 1000
n: resb 2
pointers: resd 20

section .data
str1: db 'Enter the strings:', 10
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
    mov ecx, str2
    mov edx, len2
    int 80h
    call read_num
    mov ax, word[num]
    mov word[n], ax

    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    mov ecx, strings
    mov edx, pointers
    mov word[count], 0
    acceptstring:
        mov ax, word[count]
        cmp ax, word[num]
        je exitaccept

        mov ebx, ecx
        mov dword[edx], ecx
        call read_string
        
        add ecx, 50
        add edx, 4
        inc word[count]
        jmp acceptstring
    exitaccept:
        mov ecx, 0
    ;Sort the strings
    sort1:
        cmp cx, word[n]
        je exit1
        mov edx, 0
        mov ebx, pointers
    sort2:
        mov ax, word[n]
        sub ax, cx
        dec ax
        cmp dx, ax
        je exit2
        call strcmp
        add ebx, 4
        inc edx
        jmp sort2
    exit2:
        inc ecx
        jmp sort1
    exit1:
    ;Print sorted strings
    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    mov word[count], 0
    mov edx, pointers
    mov eax, 0
    printstrings:
        mov ax, word[n]
        cmp ax, word[count]
        je exit

        mov ebx, dword[edx]
        call print_string
        call newline

        add edx, 4
        inc word[count]
        jmp printstrings
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
        mov eax, dword[ebx]
        mov ecx, dword[ebx+4]
    compare:
        cmp byte[eax], 0
        je noswap
        cmp byte[ecx], 0
        je swap

        mov dl, byte[eax]
        cmp dl, byte[ecx]
        ja swap
        jb noswap
        inc eax
        inc ecx
        jmp compare
    swap:
        mov eax, dword[ebx]
        mov ecx, dword[ebx+4]
        mov dword[ebx], ecx
        mov dword[ebx+4], eax
        jmp exit_func
    noswap:
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