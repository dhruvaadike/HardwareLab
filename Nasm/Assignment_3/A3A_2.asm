section .data
	msg1: db "Enter a string : "
	msg1_len: equ $-msg1
	msg2: db "Spaces Removed : "
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
	mov ecx, 0
	removeLoop:
		cmp ecx, dword[string_len]
		je endOfRemoving
		mov ah, byte[string+ecx]
		cmp ah, 020h
		je skip
			mov byte[string+edx], ah
			inc edx
		skip:
		inc ecx
		jmp removeLoop
	endOfRemoving:
	
	mov dword[string_len], edx
	
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

