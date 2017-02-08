section .data
	msg1: db "Enter the Sentence", 0Ah
	msg1_len: equ $-msg1
	msg2: db "Words Ending with S : ", 0Ah
	msg2_len: equ $-msg2

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	
	sentence: 	resb 1600		;100 words of 15 letters Max
	find:		resb 16
	char: 		resb 1
	i:			resd 1
	j:			resd 1
	words:		resd 1
	addrr:		resd 1

	
section .text
global _start

_start:
	;Ask for the Sentence
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	;Reading the Sentence1
	mov dword[i], 0
	readSent1Loop:		
		mov eax, dword[i]
		shl eax, 4
		add eax, sentence
		call getWord
		
		inc dword[i]
		
		cmp byte[char], 0Ah
		je endReadSent1Loop
		
		jmp readSent1Loop
		
	endReadSent1Loop:
	
	mov ecx, dword[i]
	mov dword[words], ecx

	;Print the Words
	mov dword[i], 0
	writeSentLoop:
		mov ecx, dword[words]
		cmp dword[i], ecx
		je endWriteSentLoop
		
		mov eax, dword[i]
		shl eax, 4
		add eax, sentence
		call strlen
		mov edx, dword[addrr]
		dec edx
		cmp byte[eax+edx], 's'
		je printIt
		cmp byte[eax+edx], 'S'
		je printIt
		jmp next
		printIt:
			call printWord
			call printNewline
		next:
		inc dword[i]
		jmp writeSentLoop
		
	endWriteSentLoop:
	
	call printNewline
	
	Exit:
	mov eax, 1
	mov ebx, 0
	int 80h
	
getWord:
	mov dword[addrr], eax
	pusha
	getWordLoop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		cmp byte[char], 0Ah
		je endOfGetWord
		cmp byte[char], ' '
		je endOfGetWord
		mov ah, byte[char]
		mov edx, dword[addrr]
		mov byte[edx], ah
		inc dword[addrr]
		jmp getWordLoop
	
	endOfGetWord:
	
	mov ah, ' '
	mov edx, dword[addrr]
	mov byte[edx], ah
	popa 
	ret
	
	
printWord:
	mov dword[addrr], eax
	pusha
	putWordLoop:
		mov edx, dword[addrr]
		mov ah, byte[edx]
		mov byte[char], ah
		
		mov eax, 4
		mov ebx, 1
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], ' '
		je endOfPutWord
		cmp byte[char], 0
		je endOfPutWord
		
		inc dword[addrr]
		jmp putWordLoop
	
	endOfPutWord:
	
	popa 
	ret

strcmp:
	pusha
	mov byte[char], 0
	mov ebx, 0
	strCmpLoop:
		mov al, byte[edx]
		mov ah, byte[ecx]
		
		cmp al, ah
		je skip
			mov byte[char], 1
			jmp endOfStrCmpLoop
		skip:
		cmp ah, ' '
		je endOfStrCmpLoop
		
		inc edx
		inc ecx
		inc ebx
		jmp strCmpLoop
	
	endOfStrCmpLoop:
	popa 
	ret

strlen:
	mov dword[addrr], eax
	pusha
	mov ebx, 0
	countWordLoop:
		mov edx, dword[addrr]
		mov ah, byte[edx]
		cmp ah, ' '
		je endOfCountWord
		
		inc ebx
		inc dword[addrr]
		jmp countWordLoop
	
	endOfCountWord:
	mov dword[addrr], ebx
	popa 
	ret


strcpy:
	pusha
	strCpyLoop:
		mov al, byte[ecx]
		mov byte[edx], al

		cmp al, ' '
		je endOfStrCpyLoop
		
		inc edx
		inc ecx
		jmp strCpyLoop
	
	endOfStrCpyLoop:
	popa 
	ret
	
printNewline:
	pusha
	
	mov byte[char], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, char
	mov edx, 1
	int 80h
	
	popa 
	ret
	
	
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
		call printNewline
		popa
		ret
