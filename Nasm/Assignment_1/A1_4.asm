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

sub byte[digit], 30h
mov al, byte[digit]
mov byte[num], al

loop_start:
;print the digits

mov al, byte[num]
mov ah, 0
mov bl, 10
div bl
mov byte[digit2], ah
cmp al, 0
JE skip_tens
mov byte[digit1], al
add byte[digit1], 30h  
mov eax, 4
mov ebx, 1
mov ecx, digit1
mov edx, 1
int 80h

skip_tens:
add byte[digit2], 30h
mov eax, 4
mov ebx, 1
mov ecx, digit2
mov edx, 1
int 80h

;print a newline
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

mov al, byte[digit]
add byte[num], al
sub byte[looped], 1
mov ax, 0
cmp al, byte[looped]
JNE loop_start


;Exit System Call
mov eax, 1
mov ebx, 0
int 80h

section .data
digit:	db 1
digit1:	db 1
digit2:	db 1
num: db 0
ten: db 10
looped: db 10
message: db 'Enter a single digit number : '
message_length: equ $-message
newline: db 0Ah

