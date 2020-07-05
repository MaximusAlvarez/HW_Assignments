section .text
global main
extern scanf
extern printf

printFloat:
    pusha
    push ebp
    mov ebp, esp
    sub esp, 8
    fst qword[esp]
    push formatPrint
    call printf
    mov esp, ebp
    pop ebp
    popa
    ret

readFloat: 
    pusha
    push ebp
    mov ebp, esp
    sub esp, 8
    lea eax, [esp]
    push eax
    push formatScan
    call scanf
    fld qword[ebp-8]
    mov esp, ebp
    pop ebp
    popa
    ret

main:
    ; Read first number
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    call readFloat
    ; Read second number
    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call readFloat

    fmul ST1 
    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    call printFloat

    ffree ST0
    ffree ST1
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10, 0
formatScan: db "%lf", 0

str1: db "Enter the first number:", 0
len1: equ $-str1
str2: db "Enter the second number:", 0
len2: equ $-str2
str3: db "Multiplied value:", 0
len3: equ $-str3