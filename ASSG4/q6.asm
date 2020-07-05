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

    mov ecx, 0
    fldz
loop:
    cmp cx, word[n]
    je exitloop

    call readFloat
    fstp qword[array + 8*ecx]
    fadd qword[array + 8*ecx]

    inc ecx
    jmp loop
exitloop:
    fidiv word[n]
    ;Mean
    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call printFloat
    fstp dword[mean]

    ;Binary Sort
    mov ecx, 0
    fldz
sort1:
    cmp cx, word[n]
    je exit1
    mov edx, 0
    fld qword[array + 8*ecx]
    fsub dword[mean]
    fmul ST0
    fadd ST1
    ffree ST1
sort2: 
    mov ax, word[n]
    sub ax, cx
    dec ax
    cmp dx, ax
    je exit2
    
    fld qword[array + 8*edx]
    fld qword[array + 8*(edx+1)]
    fcomi ST1
    ja noswap
        fxch ST1
noswap:
    fstp qword[array + 8*(edx+1)]
    fstp qword[array + 8*edx]

    inc edx
    jmp sort2
exit2:
    inc ecx
    jmp sort1
exit1:

    mov dx, 0
    movzx eax, word[n]
    mov bx, 2
    div bx
    fld qword[array + 8*eax]
    ;Median
    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    call printFloat
    ;Variance
    fxch ST1
    fidiv word[n]
    mov eax, 4
    mov ebx, 1
    mov ecx, str5
    mov edx, len5
    int 80h
    call printFloat
    fsqrt
    ;SD
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
str2: db "Mean is ", 0
len2: equ $-str2
str3: db "Median is ", 0
len3: equ $-str3
str4: db "Standard Deviation is ", 0
len4: equ $-str4
str5: db "Variance is ", 0
len5: equ $-str5

section .bss

mean: resd 1
n: resw 1
array: resd 100