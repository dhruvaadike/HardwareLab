section .data
	msg1: db "Enter a string : "
	msg1_len: equ $-msg1
	msg2: db "Duplicates Removed : "
	msg2_len: equ $-msg2

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	
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
	mov byte[string+edx], 0
	mov edx, dword[index]
	mov dword[string_len], edx
	
	mov edx, 0
	compareLoop:
		mov bh, byte[string+edx]
		cmp bh, 0
		je endCompareLoop
		mov ecx, edx
		inc ecx
		mov eax, ecx
		removeLoop:
			mov bl, byte[string+ecx]
			cmp bl, bh
			je skip
				mov byte[string+eax], bl
				inc eax
				jmp next
			skip:
				dec dword[string_len]
				jmp next
			
			next:
			inc ecx
			cmp bl, 0
			je endOfRemoving
			jmp removeLoop
		endOfRemoving:
		
		inc edx
		jmp compareLoop
	endCompareLoop:
	
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

