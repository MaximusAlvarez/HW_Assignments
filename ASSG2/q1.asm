
section .bss

temp: resb 2
n: resb 1
num: resb 2
array: resb 100
avg: resb 2
countabove: resb 2
count: resb 1

section .data

str1: db "Enter n:"
len1: equ $-str1
str2: db "Enter the numbers:"
len2: equ $-str2
str3: db "Count of numbers above average is "
len3: db $-str3

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

;Accept the numbers
mov eax, 4
mov ebx, 1
mov ecx, str2
mov edx, len2
int 80h

mov eax, 0 
mov word[avg], 0
mov bh, 0
read_array:
cmp al, byte[n]
je exit_read 
call read_num
mov bl, byte[num]
mov byte[array + eax], bl
add word[avg], bx 
inc eax 
jmp read_array
exit_read:

;Find avg
mov bl, byte[n]
mov ax, word[avg]
div bl
mov ah, 0
mov word[avg], ax

;Print numbers
mov eax, 4
mov ebx, 1
mov ecx, str3 
movzx edx, byte[len3] 
int 80h

mov eax, 0 
mov byte[count], 0
traverse_array:
cmp al, byte[n]
je exit_traverse 
movzx bx, byte[array + eax]
cmp bx, word[avg]
jbe skip
inc byte[count]
skip:
inc eax 
jmp traverse_array
exit_traverse:

mov al, byte[count]
mov ah, 0
mov word[num], ax
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
