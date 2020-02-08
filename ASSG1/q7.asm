
section .bss

temp: resb 2
num: resb 2
count: resb 1
gcd: resb 2
a: resb 1
b: resb 1

section .data

str1: db "Enter the numbers:"
len1: equ $-str1
str2: db "The LCM is "
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
mov al, byte[num]
call read_num
mov bl, byte[num]
cmp al, bl
ja ga
mov byte[a], bl
mov byte[b], al
jmp exitga
ga:
mov byte[a], al
mov byte[b], bl
exitga:

mov bl, 1
check:
	movzx ax, byte[b]
	div bl
	cmp ah, 0
	jne continue
	movzx ax, byte[a]
	div bl
	cmp ah, 0
	jne continue
	mov byte[gcd], bl

continue:
	inc bl
	cmp bl, byte[b]
	jle check

exitcheck:

movzx ax, byte[a]
mov bl, byte[gcd]
div bl
mov bl, byte[b]
mul bl
mov word[num], ax
mov eax, 4
mov ebx, 1
mov ecx, str2
mov edx, len2
int 80h
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
mov byte[count], 0
pusha

extract_num:
cmp word[num], 0
je print_digits
inc byte[count]
mov ax, word[num]
mov bx, 10
mov dx, 0
div bx
push dx
mov word[num], ax
jmp extract_num

print_digits:
cmp byte[count],0
je end
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

end:
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
mov byte[num], al
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 2
int 80h
mov al, byte[temp]
sub al, 30h
add byte[num], al
popa
ret
