
section .bss

temp: resb 2
num: resb 2
count: resb 1
section .data

str1: db "Enter the value of n:"
len1: equ $-str1
str2: db "Sum:"
len2: equ $-str2


section .text
global _start

_start:

mov eax, 4
mov ebx, 1
mov ecx, str1
mov edx, len1
int 80h
call read_num
movzx ax, byte[num]
mov bl, 2
div bl
cmp ah, 0
je even
inc al
mov bl, byte[num]
mul bl
jmp sum

even:
mov bl, byte[num]
inc bl
mul bl

sum:
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
