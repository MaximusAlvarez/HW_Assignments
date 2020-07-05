
section .bss

temp: resb 2
num: resb 2
count: resb 1
num2: resb 2

section .data

str1: db "Enter the number:"
len1: equ $-str1
str2: db "The factors are:"
len2: equ $-str2
spa: db " "

section .text
global _start

_start:

mov eax, 4
mov ebx, 1
mov ecx, str1
mov edx, len1
int 80h
call read_num 

mov bl, 1
check:
	cmp bl, byte[num2]
	je exitcheck
	movzx ax, byte[num2]
	div bl
	cmp ah, 0
	jne continue
	mov byte[num], bl
	call print_num
	call space
continue:
	inc bl
	jmp check

exitcheck:
mov byte[num], bl
call print_num 

exit:
mov eax, 1
mov ebx, 0
int 80h

space:
pusha
mov eax, 4
mov ebx, 1
mov ecx, spa  
mov edx, 1
int 80h
popa
ret

print_num:
pusha 
movzx ax, byte[num]
mov bl, 10
div bl
add al, 30h
add ah, 30h
mov byte[temp], al
mov byte[num], ah
mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h
mov eax, 4
mov ebx, 1
mov ecx, num
mov edx, 1
int 80h
popa
ret

read_num:
pusha
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h
mov al, byte[temp]
sub al, 30h
mov bl, 10
mul bl
mov byte[num2], al
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 2
int 80h
mov al, byte[temp]
sub al, 30h
add byte[num2], al
popa
ret
