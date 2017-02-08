section .text
global _start:

_start:
;Printing the message
mov eax, 4
mov ebx, 1
mov ecx, message
mov edx, message_length
int 80h

;Reading the digit
mov eax, 3
mov ebx, 0
mov ecx, digit
mov edx, 2
int 80h

mov byte[num], 31h

loop_start:
;print the digit
mov eax, 4
mov ebx, 1
mov ecx, num
mov edx, 1
int 80h

;print a newline
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

add byte[num], 2
mov al, byte[num]
mov ah, 0
cmp al, byte[digit]
JNA loop_start


;Exit System Call
mov eax, 1
mov ebx, 0
int 80h

section .data
digit:	db 1
num: db 0
message: db 'Enter a single digit number : '
message_length: equ $-message
newline: db 0Ah

