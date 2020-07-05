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

    fldz
    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call readFloat
    fild word[minus]
    fld1
    fld1
    fldz
    mov ax, word[n]
loop:
    mov ax, word[n]
    mov bl, 2
    mul bl
    cmp word[count], ax
    ja exitloop

    fxch ST2 
    fimul word[count]
    fxch ST2 
    fxch ST1
    fmul ST4 
    fxch ST1 

cmp byte[sign], 0
jne change
    fxch ST3 
    fimul word[minus]
    fxch ST3 
    fxch ST5
    fimul word[zero]
    fadd ST1
    fmul ST3
    fdiv ST2
    fxch ST5
    fadd ST5
    mov byte[sign], 1
    jmp nochange
change:
    mov byte[sign], 0
nochange:

    inc word[count]
    jmp loop
exitloop:

    mov eax, 4
    mov ebx, 1
    mov ecx, str5
    mov edx, len5
    int 80h
    call printFloat
    fxch ST4
    fsin
    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    call printFloat
    fsub ST4
    mov eax, 4
    mov ebx, 1
    mov ecx, str4
    mov edx, len4
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
str2: db "Enter x:", 0
len2: equ $-str2
str5: db "Sine by Calculation: ", 0
len5: equ $-str5
str3: db "Sine by FSIN: ", 0
len3: equ $-str3
str4: db "Differance: ", 0
len4: equ $-str4
count: dw 1
minus: dw -1
zero: dw 0
sign: dw 0

section .bss

x: resq 1
n: resw 1