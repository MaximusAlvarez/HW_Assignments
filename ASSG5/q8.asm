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

    fld1
    fld1
    fld1
    fldz
loop:
    cmp word[iter], 100
    je exit
    inc word[iter]

    fxch ST1
    fimul word[zero]
    fadd ST3
    fdiv ST2
    fxch ST1

    fadd ST1

    fxch ST3
    fmul ST4
    fxch ST3

    fxch ST2
    fimul word[iter]
    fxch ST2

    jmp loop

    ffree ST0
exit:
    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call printFloat
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10, 0
formatScan: db "%lf", 0

str1: db "Enter x:", 0
len1: equ $-str1
str2: db "Value is ", 0
len2: equ $-str2
zero: dw 0
iter: dw 0