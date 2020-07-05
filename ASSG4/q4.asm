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
    mov word[n], ax
    mov esp, ebp
    pop ebp
    ret

main:
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    call readInt

    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    mov ax, word[n]
    mov word[count], ax
    fldz
loop:
    cmp word[count], 0
    je exitloop
    dec word[count]
    call readFloat
    fadd ST1
    ffree ST7
    jmp loop
exitloop:
    fidiv word[n]
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

formatPrint: db "%lf", 10
formatInt: db "%d", 0
formatScan: db "%lf", 0
str1: db "Enter n:", 0
len1: equ $-str1
str2: db "Enter the numbers:", 0
len2: equ $-str2
str3: db "The average is:", 0
len3: equ $-str3

section .bss

t: resq 1
n: resw 1
count: resw 1