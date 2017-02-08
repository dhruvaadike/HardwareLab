section .data
	msg1: db "Enter First string : ", 0Ah
	msg1_len: equ $-msg1
	msg2: db "Enter Second string : ", 0Ah
	msg2_len: equ $-msg2
	msg3: db "Processed : ", 0Ah
	msg3_len: equ $-msg3

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1

	string1: resb 200
	string2: resb 200
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
	reading1Loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfReading1
		mov ah, byte[char]
		mov edx, dword[index]
		mov byte[string1+edx], ah
		inc dword[index]
		jmp reading1Loop
	
	endOfReading1:
	
	mov edx, dword[index]
	mov byte[string1+edx], 0
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov dword[index], 0
	reading2Loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfReading2
		mov ah, byte[char]
		mov edx, dword[index]
		mov byte[string2+edx], ah
		inc dword[index]
		jmp reading2Loop
	
	endOfReading2:
	
	mov edx, dword[index]
	mov byte[string2+edx], 0
	
	mov ebx, 0
	charLoop:
		;mov eax, ebx
		;call print_num
		;movzx eax, byte[string1+ebx]
		;call print_num
		cmp byte[string1+ebx], 0
		je endCharLoop
		mov edx, 0
		mov ecx, 0
		removeLoop:
			mov ah, byte[string2+ecx]
			cmp ah, byte[string1+ebx]
			je skip
				mov byte[string2+edx], ah
				inc edx
			skip:
			cmp ah, 0
			je endOfRemoving
			inc ecx
			jmp removeLoop
		endOfRemoving:
		inc ebx
		jmp charLoop
	endCharLoop:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, msg3_len
	int 80h
	
	mov dword[index], 0
	printingLoop:
		mov edx, dword[index]
		mov ah, byte[string2+edx]
		mov byte[char], ah
		
		cmp byte[char], 0
		je endOfPrinting
		
		mov eax, 4
		mov ebx, 1
		mov ecx, char
		mov edx, 1
		int 80h
		
		inc dword[index]
		jmp printingLoop
	
	endOfPrinting:
	
	mov byte[char], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, char
	mov edx, 1
	int 80h
	
	mov eax, 1
	mov ebx, 0
	int 80h

	
print_num:
	mov word[pnum], ax
	pusha
	cmp ax, 0
	je printZero
	mov byte[nod], 0
	extract_no:
		cmp word[pnum], 0
		je print_no
		inc byte[nod]
		mov dx, 0
		mov ax, word[pnum]
		mov bx, 10
		div bx
		
		push dx
		mov word[pnum], ax
		jmp extract_no
	
	print_no:
		cmp byte[nod], 0
		je end_print
		dec byte[nod]
		pop dx
		mov byte[temp], dl
		add byte[temp], 30h
		
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		
		jmp print_no
	printZero:
		mov byte[temp], '0'
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
	end_print:
		call print_newline
		popa
		ret
print_newline:
	pusha
	mov byte[temp], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	popa
	ret

