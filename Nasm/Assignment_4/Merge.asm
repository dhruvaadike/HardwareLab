section .data
	msg1: db "Enter the first String", 0Ah
	msg1_len: equ $-msg1
	msg2: db "Enter the second String", 0Ah
	msg2_len: equ $-msg2
	Col:	equ	16
	Row:	equ 100

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	
	sentence1: 	resb 1600		;100 words of 15 letters Max
	sentence2: 	resb 1600		;100 words of 15 letters Max
	sentence3: 	resb 3200		;100 words of 15 letters Max
	char: 		resb 1
	i:			resd 1
	j:			resd 1
	k:			resd 1
	words1:			resd 1
	words2:			resd 1
	addrr:		resd 1

	
section .text
global _start

_start:
	;Ask for the Sentence1
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
		add eax, sentence1
		call getWord
		
		inc dword[i]
		
		cmp byte[char], 0Ah
		je endReadSent1Loop
		
		jmp readSent1Loop
		
	endReadSent1Loop:
	
	mov ecx, dword[i]
	mov dword[words1], ecx
	
	;Ask for the Sentence2
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	;Reading the Sentence2
	mov dword[i], 0
	readSent2Loop:
		mov eax, dword[i]
		shl eax, 4
		add eax, sentence2
		call getWord
		
		inc dword[i]
		
		cmp byte[char], 0Ah
		je endReadSent2Loop
		
		jmp readSent2Loop
		
	endReadSent2Loop:
	
	mov ecx, dword[i]
	mov dword[words2], ecx
	
	mov dword[i], 0
	mov dword[j], 0
	mov dword[k], 0
	mergingLoop:
		mov eax, dword[words1]
		add eax, dword[words2]
		cmp dword[k], eax
		je endMerging
		mov eax, dword[i]
		cmp eax, dword[words1]
		jnb moveSecond
		mov eax, dword[j]
		cmp eax, dword[words2]
		jnb moveFirst
;		mov eax, dword[i];
;		shl eax, 4
;		add eax, sentence1
;		call printWord
;		call printNewline
;		mov eax, dword[j]
;		shl eax, 4
;		add eax, sentence2
;		call printWord
;		call printNewline
		mov ecx, dword[i]
		shl ecx, 4
		add ecx, sentence1
		mov edx, dword[j]
		shl edx, 4
		add edx, sentence2
		call strcmp
		cmp byte[char], 1
		je moveFirst
		cmp byte[char], 2
		je moveSecond
		jmp moveFirst
		
		moveFirst:
;			mov eax,  1
;			call print_num
			mov ecx, dword[i]
			shl ecx, 4
			add ecx, sentence1
			mov edx, dword[k]
			shl edx, 4
			add edx, sentence3
			call strcpy
			inc dword[i]
			inc dword[k]
			jmp mergingLoop
			
		moveSecond:;
;			mov eax,  2
;			call print_num
			mov ecx, dword[j]
			shl ecx, 4
			add ecx, sentence2
			mov edx, dword[k]
			shl edx, 4
			add edx, sentence3
			call strcpy
			inc dword[j]
			inc dword[k]
			jmp mergingLoop
			
	endMerging:
	
	;Print the Sentence1
	; mov dword[i], 0
	; writeSent1Loop:
		; mov ecx, dword[words1]
		; cmp dword[i], ecx
		; je endWriteSent1Loop
		
		; mov eax, dword[i]
		; shl eax, 4
		; add eax, sentence1
		; call printWord
		
		; inc dword[i]
		; jmp writeSent1Loop
		
	; endWriteSent1Loop:
	
	; call printNewline
	
	;Print the Sentence2
	; mov dword[i], 0
	; writeSent2Loop:
		; mov ecx, dword[words2]
		; cmp dword[i], ecx
		; je endWriteSent2Loop
		
		; mov eax, dword[i]
		; shl eax, 4
		; add eax, sentence2
		; call printWord
		
		; inc dword[i]
		; jmp writeSent2Loop
		
	; endWriteSent2Loop:
	
	; call printNewline
	
	; mov eax, dword[words1]
	; call print_num
	
	; mov eax, dword[words2]
	; call print_num
	
	;Print the Sentence3
	mov dword[k], 0
	writeSent3Loop:
		mov ecx, dword[words1]
		add ecx, dword[words2]
		cmp dword[k], ecx
		je endWriteSent3Loop
		
		mov eax, dword[k]
		shl eax, 4
		add eax, sentence3
		call printWord
		
		inc dword[k]
		jmp writeSent3Loop
		
	endWriteSent3Loop:
	
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
		mov al, byte[ecx]
		mov ah, byte[edx]
		
		cmp al, ah
		ja above
		cmp al, ah
		jb below
		jmp skip
		above:
			mov byte[char], 2
			jmp endOfStrCmpLoop
		below:
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
	
	mov byte[temp], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
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
