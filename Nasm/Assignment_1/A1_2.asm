section .text
global _start

setflag:
inc byte[flag]
jmp back

_start:
;Printing the message
mov eax, 4
mov ebx, 1
mov ecx, message
mov edx, message_length
int 80h


;Reading a number

mov word[num], 0
loop_read:
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h
cmp byte[temp], 10; ASCII key for newline
je end_read
cmp byte[temp], 48
jb Error
cmp byte[temp], 58
ja Error
cmp byte[temp], 48
jne setflag
back:
mov al, byte[temp]
mov byte[num], al
jmp loop_read
end_read:




mov al,byte[num]
cmp al, 30h
je isZero
mov ah, 0
mov bh, 2
div bh
cmp ah,0
je isEven

isOdd:
mov ecx, message2
mov edx, message2_length
jmp L1

isEven:
mov ecx, message1
mov edx, message1_length
jmp L1

isZero:
cmp byte[flag], 1
je isEven
mov ecx, message3
mov edx, message3_length
jmp L1
L1:
mov eax, 4
mov ebx, 1
int 80h


;Exit System Call
Exit:
mov eax, 1
mov ebx, 0
int 80h

Error:
mov eax, 4
mov ebx, 1
mov ecx, error1
mov edx, error1_length
int 80h
jmp Exit

section .data
value: db 30h
digit:	db 1
temp: db 0
nod: db 0
num: db 0
flag: db 0
message: db 'Enter a number : '
message_length: equ $-message
message1: db 'Number is Even', 0Ah
message1_length: equ $-message1
message2: db 'Number is Odd', 0Ah
message2_length: equ $-message2
message3: db 'Number is neither Odd nor Even', 0Ah
message3_length: equ $-message3
error1: db 'Invalid Input', 0Ah
error1_length: equ $-error1


