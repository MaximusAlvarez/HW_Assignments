
section .bss

digit3: resb 2
digit2: resb 1
digit1: resb 1

section .data

str1: db "Enter the number:"
len1: equ $-str1
str2: db "It is a Palindrome."
len2: equ $-str2
str3: db "It is not a Palindrome."
len3: equ $-str3

section .text
global _start

_start:

mov eax, 4
mov ebx, 1
mov ecx, str1 
mov edx, len1 
int 80h 

mov eax, 3
mov ebx, 0
mov ecx, digit1
mov edx, 1
int 80h 
mov eax, 3
mov ebx, 0
mov ecx, digit2 
mov edx, 1
int 80h 
mov eax, 3
mov ebx, 0
mov ecx, digit3 
mov edx, 2
int 80h

mov al, byte[digit3]
cmp al, byte[digit1]
je pal 
mov eax, 4
mov ebx, 1
mov ecx, str3 
mov edx, len3 
int 80h 
jmp exit 
pal:
mov eax, 4
mov ebx, 1
mov ecx, str2  
mov edx, len2 
int 80h 


exit:
mov eax, 1
mov ebx, 0
int 80h
