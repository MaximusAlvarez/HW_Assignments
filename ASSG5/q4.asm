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

    mov eax, 4
    mov ebx, 1
    mov ecx, str5
    mov edx, len5
    int 80h
    call readFloat
    fistp word[n]

    fldz
    fadd ST1
    fcos

    fld1
    fld1
    fld1
    fldz
    mov ax, word[n]
loop:
    cmp word[iter], ax
    jnb exitloop
    inc word[iter]

    fxch ST1
    fimul word[zero]
    fadd ST3
    fdiv ST2
    fxch ST1

    fadd ST1

    fxch ST3
    fmul ST5
    fmul ST5
    fchs
    fxch ST3

    fxch ST2
    fimul word[iter]
    inc word[iter]
    fimul word[iter]
    fxch ST2

    jmp loop

exitloop: 
    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    call printFloat

    fxch ST4
    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call printFloat

    fxch ST4
    fsub ST4
    mov eax, 4
    mov ebx, 1
    mov ecx, str4
    mov edx, len4
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

str1: db "Enter x:", 0
len1: equ $-str1
str5: db "Enter n:", 0
len5: equ $-str5
str2: db "Cos x (processor instruction)= ", 0
len2: equ $-str2
str3: db "Cos x (formula)= ", 0
len3: equ $-str3
str4: db "Difference= ", 0
len4: equ $-str4
zero: dw 0
iter: dw 0

section .bss

n: resw 1