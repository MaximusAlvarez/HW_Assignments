section .bss
num: resb 1
num1: resb 1
num2: resb 1
num3: resb 1
temp: resb 2

section .data
string: db 'Enter the 3 numbers'
strex: db 'None'

section .text
global _start

_start: 

call read_num
mov al, byte[num]
mov byte[num1], al
call read_num
mov al, byte[num]
mov byte[num2], al
call read_num
mov al, byte[num]
mov byte[num3], al
add al, byte[num2]
cmp al, byte[num1]
je if1
mov al, byte[num1]
add al, byte[num2]
cmp al, byte[num3]
je if2
mov al, byte[num1]
add al, byte[num3]
cmp al, byte[num2]
je if3
mov eax, 4
mov ebx, 1
mov ecx, strex
mov edx, 4
int 80h
jmp exit
if3:
mov byte[num],al
jmp end
if2:
mov byte[num],al
jmp end
if1:
mov byte[num],al
jmp end

end: 
call print_num
exit:
mov eax, 1
mov ebx, 0
int 80h

print_num:
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
