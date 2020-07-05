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
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    call readFloat

    fild word[nine]
    fidiv word[five]
    fmul ST1
    fiadd word[thirtytwo]

    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call printFloat

    ffree ST0
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10, 0
formatScan: db "%lf", 0

str1: db "Enter temparature in Celsius:", 0
len1: equ $-str1
str2: db "Temperature in farenheit is ", 0
len2: equ $-str2
nine: dw 9
five: dw 5
thirtytwo: dw 32