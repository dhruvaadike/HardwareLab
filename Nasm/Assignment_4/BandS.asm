section .data
	msg1: db "Enter the Sentence", 0Ah
	msg1_len: equ $-msg1
	msg2: db "Largest word : "
	msg2_len: equ $-msg2
	msg3: db "Smallest word : "
	msg3_len: equ $-msg3
	Col:	equ	16
	Row:	equ 100

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	
	sentence: 	resb 1600		;100 words of 15 letters Max
	replace:	resb 16
	find:		resb 16
	char: 		resb 1
	i:			resd 1
	j:			resd 1
	larg:		resd 1
	larglen:	resd 1
	smal:		resd 1
	smallen:	resd 1
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
	
	;Reading the Sentence
	mov dword[i], 0
	readSentLoop:
		cmp dword[i], Row
		je endReadSentLoop
		mov dword[j], 0
		readWordLoop:
			cmp dword[j], Col
			je endReadWordLoop
			
			mov eax, 3
			mov ebx, 0
			mov ecx, char
			mov edx, 1
			int 80h
			
			cmp byte[char], 0Ah
			je endReadSentLoop
			
			mov al, byte[char]
			mov ecx, dword[i]
			shl ecx, 4
			add ecx, dword[j]
			mov byte[sentence+ecx], al
			inc dword[j]
			cmp byte[char], ' '
			je endReadWordLoop
			jmp readWordLoop
		endReadWordLoop:
		
		inc dword[i]
		jmp readSentLoop
		
	endReadSentLoop:
	
	mov al, ' '
	mov ecx, dword[i]
	shl ecx, 4
	add ecx, dword[j]
	mov byte[sentence+ecx], al
	
	mov ecx, dword[i]
	inc ecx
	mov dword[words], ecx
	
	mov dword[larg], 0
	mov dword[smal], 0
	mov eax, sentence
	call strlen
	mov eax, dword[addrr]
	mov dword[larglen], eax
	mov dword[smallen], eax
	
	;Replace the words
	mov dword[i], 1
	replaceLoop:
		mov ecx, dword[words]
		cmp dword[i], ecx
		je endReplaceLoop
		
		mov eax, dword[i]
		shl eax, 4
		add eax, sentence
		call strlen
		mov edx, dword[addrr]
		cmp dword[smallen], edx
		ja gotSmall
		cmp dword[larglen], edx
		jb gotBig
		jmp next
		
		gotSmall:
			mov dword[smallen], edx
			mov edx, dword[i]
			mov dword[smal], edx
			jmp next
		
		gotBig:
			mov dword[larglen], edx
			mov edx, dword[i]
			mov dword[larg], edx
			jmp next
		
		next:
		inc dword[i]
		jmp replaceLoop
		
	endReplaceLoop:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, msg3_len
	int 80h
	
	mov eax, dword[smal]
	shl eax, 4
	add eax, sentence
	call printWord
	call printNewline
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov eax, dword[larg]
	shl eax, 4
	add eax, sentence
	call printWord
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
		
		inc dword[addrr]
		jmp putWordLoop
	
	endOfPutWord:
	
	popa 
	ret
	
strlen:
	mov dword[addrr], eax
	pusha
	countWordLoop:
		mov edx, dword[addrr]
		mov ah, byte[edx]
		cmp ah, ' '
		je endOfCountWord
		
		inc dword[addrr]
		jmp countWordLoop
	
	endOfCountWord:
	
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
