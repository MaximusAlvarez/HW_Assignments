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

readArray:
    pusha
    mov eax, 0
readLoop:
    cmp eax, dword[n]
    je exitFunc

    call readFloat
    fstp qword[array + 8*eax]

    inc eax
    jmp readLoop

printArray:
    pusha
    mov eax, 0
printLoop:
    cmp eax, dword[n]
    je exitFunc

    fld qword[array + 8*eax]
    call printFloat
    ffree ST0

    inc eax
    jmp printLoop

exitFunc:
    popa
    ret

main:
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    call readFloat

    fistp qword[n]

    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    call readArray

    mov eax, dword[n]
    sub eax, 1
loop1:
    cmp eax, 0
    je exitloop1

    mov ebx, 0
loop2:
    cmp ebx, eax
    je exitloop2

    fld qword[array + 8*ebx]
    fld qword[array + 8*ebx + 8]

    fcomi ST1
    ja checked
    fxch ST1
checked:
    fstp qword[array + 8*ebx +8]
    fstp qword[array + 8*ebx]

    inc ebx
    jmp loop2
exitloop2:

    sub eax, 1
    jmp loop1
exitloop1:

    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    call printArray

    ffree ST0
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10, 0
formatScan: db "%lf", 0

str1: db "Enter number of elements: ", 0
len1: equ $-str1
str2: db "Enter the array: ", 0
len2: equ $-str2
str3: db "Sorted array is: ", 10, 0
len3: equ $-str3

section .bss

array: resq 1000
n: resq 1
