section .data
	msg1: db "Enter a string : "
	msg1_len: equ $-msg1
	msg2: db "Reverse : "
	msg2_len: equ $-msg2

section .bss
	string: resb 200
	string_len: resd 1
	char: resb 1
	index:	resd 1

section .text
global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	
	mov dword[index], 0
	readingLoop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfReading
		mov ah, byte[char]
		mov edx, dword[index]
		mov byte[string+edx], ah
		inc dword[index]
		jmp readingLoop
	
	endOfReading:
	
	mov edx, dword[index]
	mov dword[string_len], edx
	
	mov edx, 0
	mov ecx, dword[string_len]
	dec ecx
	shr dword[index], 1
	reverseLoop:
		cmp edx, ecx
		je endOfReversing
		mov ah, byte[string+edx]
		mov al, byte[string+ecx]
		mov byte[string+edx], al
		mov byte[string+ecx], ah
		inc edx
		dec ecx
		jmp reverseLoop
	endOfReversing:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, string
	mov edx, dword[string_len]
	int 80h
	
	mov byte[char], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, char
	mov edx, 1
	int 80h
	
	mov eax, 1
	mov ebx, 0
	int 80h

