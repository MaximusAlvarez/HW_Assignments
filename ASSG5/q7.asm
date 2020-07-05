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

    fldz
    fiadd word[nine]

    fldz
    fiadd word[five]
    fmul ST2

    fld1
    fmul ST3
    fmul ST3

    fldz
    fadd ST1
    fmul ST4

    fadd ST1
    fsub ST2
    fadd ST3

    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call printFloat

    ffree ST0
    ffree ST1
    ffree ST2
    ffree ST3
    ffree ST4
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10, 0
formatScan: db "%lf", 0

str1: db "Enter x:", 0
len1: equ $-str1
str2: db "x^3 +x^2 -5x + 9 = ", 0
len2: equ $-str2
nine: dw 9
five: dw 5