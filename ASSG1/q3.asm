section .bss
num: resb 2
num1: resb 1
num2: resb 1
temp: resb 2
count: resb 1
choice: resb 2

section .data
string: db '1. Addition',0Ah,'2. Subtraction',0Ah,'3. Multiplication',0Ah,'4. Division',0Ah,'Enter choice and two numbers',0Ah
len: equ $-string
strex: db 'Wrong Choice'

section .text
global _start

_start: 

mov eax, 4
mov ebx, 1
mov ecx, string
mov edx, len
int 80h
mov eax, 3
mov ebx, 0
mov ecx, choice
mov edx, 2
int 80h
call read_num
mov al, byte[num]
mov byte[num1], al
call read_num
mov al, byte[num]
mov byte[num2], al
sub byte[choice], 30h
cmp byte[choice], 1
je addi
cmp byte[choice], 2
je subt
cmp byte[choice], 3
je mult
cmp byte[choice], 4
je divi
mov eax, 4
mov ebx, 1
mov ecx, strex
mov edx, 12
int 80h

exit:
mov eax, 1
mov ebx, 0
int 80h

addi:
mov al, byte[num1]
mov bl, 100
mul bl
mov word[num], ax
movzx ax, byte[num2]
add word[num], ax
call print_num
jmp exit

subt:
movzx ax, byte[num1]
mov word[choice], ax
call split
mov al, byte[temp+1]
mov bl, 10
mul bl
movzx bx, byte[temp]
add ax, bx
mov byte[num1], al
movzx ax, byte[num2]
mov word[choice], ax
call split
mov al, byte[temp+1]
mov bl, 10
mul bl
movzx bx, byte[temp]
add ax, bx
mov byte[num2], al
jmp addi

mult:
mov al, byte[num2]
mov bl, 100
mul bl
mov word[num], ax
movzx ax, byte[num1]
add word[num], ax
call print_num
jmp exit

divi:
movzx ax, byte[num1]
mov word[choice], ax
call split
mov al, byte[num2]
mov bl, 100
mul bl
mov word[num], ax
mov al, byte[temp]
mov bl, 10
mul bl
add word[num], ax
mov al, byte[temp+1]
mov bl, 10
mul bl
mov bl, 100
mul bl
add word[num], ax
call print_num
jmp exit

split:
mov ax, word[choice]
mov bl, 10
div bl
mov byte[temp], al
mov byte[temp+1], ah 
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
ret
