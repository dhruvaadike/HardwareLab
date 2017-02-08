section .data
	msg1: db "Enter a string : "
	msg1_len: equ $-msg1
	msg3: db "Enter a Word : "
	msg3_len: equ $-msg1
	msg2: db "Number of Times : "
	msg2_len: equ $-msg2

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	string: resb 200
	subString: resb 200
	string_len: resd 1
	subString_len: resd 1
	char: resb 1
	index:	resd 1
	count:	resd 1

section .text
global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	
	mov dword[index], 0
	stringReadingLoop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfStringReading
		mov ah, byte[char]
		mov edx, dword[index]
		mov byte[string+edx], ah
		inc dword[index]
		jmp stringReadingLoop
	
	endOfStringReading:
	
	mov edx, dword[index]
	mov dword[string_len], edx
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, msg3_len
	int 80h
	
	
	mov dword[index], 0
	wordReadingLoop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfWordReading
		mov ah, byte[char]
		mov edx, dword[index]
		mov byte[subString+edx], ah
		inc dword[index]
		jmp wordReadingLoop
	
	endOfWordReading:
	
	mov edx, dword[index]
	mov dword[subString_len], edx
	
	mov ebx, dword[string_len]
	sub ebx, dword[subString_len]
	inc ebx
	mov ecx, 0
	outerLoop:
		cmp ecx, ebx
		jnb endOuterLoop
		mov edx, 0
		innerLoop:
			cmp edx, dword[subString_len]
			jnb endInnerLoop
			mov al, byte[string+ecx+edx]
			cmp al, byte[subString+edx]
			jne endInnerLoop
			inc edx
			jmp innerLoop
		endInnerLoop:
		cmp edx, dword[subString_len]
		je found
		jb mismatch
		found:
			inc dword[count]
		mismatch:
		inc ecx
		jmp outerLoop
	endOuterLoop:
	
	mov dword[string_len], edx
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	mov eax, dword[count]
	
	call print_num
	
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
		mov byte[temp], 0Ah
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		popa
		ret

