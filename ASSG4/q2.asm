section .text
global main
extern scanf
extern printf

printFloat:
    push ebp
    mov ebp, esp
    sub esp, 8
    fst qword[esp]
    push formatPrint
    call printf
    mov esp, ebp
    pop ebp
    ret

readFloat: 
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
    ret

readInt:
    push ebp
    mov ebp, esp
    sub esp, 2
    lea eax, [esp]
    push eax
    push formatInt
    call scanf
    mov ax, word[ebp - 2]
    mov word[radius], ax
    mov esp, ebp
    pop ebp
    ret

main:
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    call readFloat

    fldpi
    fmul ST1
    fmul ST1

    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call printFloat

    ffree ST0
    ffree ST1
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10
formatInt: db "%d", 0
formatScan: db "%lf", 0
str1: db "Enter the raduis ", 0
len1: equ $-str1
str2: db "The Area is ", 0
len2: equ $-str2

section .bss

t: resq 1
radius: resw 1
area: resw 1