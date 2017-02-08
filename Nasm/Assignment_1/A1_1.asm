section .text
global _start:

_start:
;Printing the message
mov eax, 4
mov ebx, 1
mov ecx, message
mov edx, message_length
int 80h

;Reading a digit
mov eax, 3
mov ebx, 0
mov ecx, digit1
mov edx, 2
int 80h

;testing
mov cl, byte[digit1]
mov ch, 0
cmp cl, 48
JNB moreEq48

l_special:
mov eax, 4
mov ebx, 1
mov ecx, special
mov edx, special_length
int 80h
jmp exit

number:
mov eax, 4
mov ebx, 1
mov ecx, alphanum
mov edx, alphanum_length
int 80h
jmp exit

alphabet:
mov eax, 4
mov ebx, 1
mov ecx, alpha
mov edx, alpha_length
int 80h
mov eax, 4
mov ebx, 1
mov ecx, alphanum
mov edx, alphanum_length
int 80h
jmp exit


moreEq48:
cmp cl, 57
JNA number

more57:
cmp cl, 65
JNB moreEq65

jmp l_special

moreEq65:
cmp cl, 90
JNA alphabet

cmp cl, 97
JNB moreEq97

jmp l_special

moreEq97:
cmp cl, 122
JNA alphabet

jmp l_special

exit:
;Exit System Call
mov eax, 1
mov ebx, 0
int 80h

section .data
value: db 30h
digit1:	db 1
num: db 1
message: db 'Enter a character : '
message_length: equ $-message
alphanum: db 'You entered a alphanum character', 0Ah
alphanum_length: equ $-alphanum
alpha: db 'You entered a alpha character', 0Ah
alpha_length: equ $-alpha
special: db 'You entered a special symbol', 0Ah
special_length: equ $-special


