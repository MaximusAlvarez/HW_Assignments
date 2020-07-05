section .text
global main
extern scanf
extern printf

printFloat:
    pusha
    push ebp
    mov ebp, esp
    sub esp, 8
    fstp qword[esp]
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
    fldz
    ; Read a, b and c
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    call readFloat
    call readFloat
    call readFloat

    ; make -4ac
    fimul word[four]
    fmul ST2
    fchs
    ; find b^2
    fld1
    fmul ST2
    fmul ST2
    ; find root of b^2 - 4ac
    fadd ST1

    mov eax, 0
    fcomi ST4
    jb noroots

    fsqrt

    fxch ST2
    fchs
    fxch ST1
    ffree ST0
    fxch ST3
    fimul word[two]


    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    
    fldz
    fadd ST2
    fadd ST3
    fdiv ST1
    call printFloat

    fldz
    fadd ST2
    fsub ST3
    fdiv ST1
    call printFloat

    ffree ST0
    ffree ST1
    ffree ST2
    jmp exit

noroots: 
    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10, 0
formatScan: db "%lf", 0

str1: db "Let the quadratic equation be ax^2 + bx + c", 10, "Enter a, b and c:", 0
len1: equ $-str1
str2: db "The roots are ", 10, 0
len2: equ $-str2
str3: db "The roots are complex.", 0
len3: equ $-str3
four: dw 4
two: dw 2
