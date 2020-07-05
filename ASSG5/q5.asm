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
    fldz
    ; Read x,y
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, len1
    int 80h
    call readFloat
    call readFloat

    fcomi ST2 
    fxch ST1
    je xaxis
    ja positiveY

negativeY:
    fcomi ST2
    je yaxis
    ja fourth
third:
    mov eax, 4
    mov ebx, 1
    mov ecx, str4
    mov edx, len4
    int 80h
    jmp exit
fourth:
    mov eax, 4
    mov ebx, 1
    mov ecx, str5
    mov edx, len5
    int 80h
    jmp exit
positiveY:
    fcomi ST2
    je yaxis
    ja first
second:
    mov eax, 4
    mov ebx, 1
    mov ecx, str3
    mov edx, len3
    int 80h
    jmp exit
first:
    mov eax, 4
    mov ebx, 1
    mov ecx, str2
    mov edx, len2
    int 80h
    jmp exit
yaxis:
    mov eax, 4
    mov ebx, 1
    mov ecx, str7
    mov edx, len7
    int 80h
    jmp exit
xaxis:
    fcomi ST2
    je origin

    mov eax, 4
    mov ebx, 1
    mov ecx, str6
    mov edx, len6
    int 80h
    jmp exit
origin:
    mov eax, 4
    mov ebx, 1
    mov ecx, str8
    mov edx, len8
    int 80h

    ffree ST0
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h

section .data

formatPrint: db "%lf", 10, 0
formatScan: db "%lf", 0

str1: db "Enter x, y:", 0
len1: equ $-str1
str2: db "First Quadrant.", 0
len2: equ $-str2
str3: db "Second Quadrant.", 0
len3: equ $-str3
str4: db "Third Quadrant.", 0
len4: equ $-str4
str5: db "Fourth Quadrant.", 0
len5: equ $-str5
str6: db "Lies on X-Axis.", 0
len6: equ $-str6
str7: db "Lies on Y-Axis.", 0
len7: equ $-str7
str8: db "Origin.", 0
len8: equ $-str8