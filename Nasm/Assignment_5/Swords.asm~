section .data
	msg1: db "Enter the Sentence", 0Ah
	msg1_len: equ $-msg1
	msg3: db "Longest Repeating SubSequence : ", 0Ah
	msg3_len: equ $-msg3

section .bss
	pnum:	resd 1
	temp:	resb 1
	nod:	resb 1
	
	
	sentence: 	resb 1600		;100 words of 15 letters Max
	find:		resb 16
	char: 		resb 1
	i:			resd 1
	j:			resd 1
	n:			resd 1
	count:		resd 1
	maxCount:	resd 1
	maxStart	resd 1
	maxEnd		resd 1
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
	mov eax, sentence
	call getWord
	
	mov dword[maxCount], 0
	mov dword[maxStart], 0
	mov dword[maxEnd], 0
	
	;Find it
	mov dword[i], 0
	iLoop:
		mov eax, dword[i]
		cmp byte[sentence+eax], 0
		;cmp eax, 1
		je endILoop
		mov dword[j], eax
		jLoop:
			mov eax, dword[j]
			cmp byte[sentence+eax], 0
			;cmp eax, 4
			je endJLoop
			
			;mov eax, dword[i]
			;call print_num
			;call printComma
			
			;mov eax, dword[j]
			;call print_num
			;call printComma
			
			;mov ecx, sentence
			;add ecx, dword[i]
			;mov edx, sentence
			;add edx, dword[j]
			;call printPartWord
			;call printComma
			
			mov dword[n], eax
			mov eax, dword[i]
			sub dword[n], eax
			inc dword[n]
			
			mov ecx, sentence
			add ecx, dword[i]
			mov edx, sentence
			add edx, dword[i]
			call strstrn
			
			;mov eax, dword[count]
			;call print_num
			;call printComma
			
			;mov eax, dword[maxCount]
			;call print_num
			;call printNewline
			
			mov ebx, dword[maxCount]
			
			cmp dword[count], ebx
			jnb gotNew
			jmp next
			
			gotNew:
				mov eax, dword[i]
				mov ebx, dword[j]
				sub ebx, eax
				inc ebx
				mov eax, dword[maxStart]
				mov ecx, dword[maxEnd]
				sub ecx, eax
				inc ecx
				cmp ebx, ecx
				jna next 
				mov eax, dword[i]
				mov ebx, dword[j]
				mov ecx, dword[count]
				mov dword[maxStart], eax		
				mov dword[maxEnd], ebx
				mov dword[maxCount], ecx
						
			next:
			inc dword[j]
			jmp jLoop
		endJLoop:
		inc dword[i]
		jmp iLoop
	endILoop:

	;call printNewline
	;Print the Sentence
	mov eax, dword[maxStart]
	call print_num
	call printComma
	
	mov eax, dword[maxEnd]
	call print_num
	call printNewline
	
	mov ecx, sentence
	add ecx, dword[maxStart]
	mov edx, sentence
	add edx, dword[maxEnd]
	call printPartWord
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
	
	mov ah, 0
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
	
printPartWord:
	pusha
	mov eax, 0
	putPartWordLoop:
		mov bh, byte[eax+ecx]
		mov byte[char], bh
		
		pusha
		mov eax, 4
		mov ebx, 1
		mov ecx, char
		mov edx, 1
		int 80h
		popa
		
		mov ebx, ecx
		add ebx, eax
		cmp ebx, edx
		je endOfPartPutWord
		
		inc eax
		jmp putPartWordLoop
	
	endOfPartPutWord:
	
	popa 
	ret

strstrn:
	mov dword[count], 0
	pusha
	strStrOutLoop:
		mov eax, dword[n]
;		call print_num;
;		call printComma
		mov eax, dword[n]
		dec eax
		cmp byte[ecx+eax], 0
		je endOfStrStrOutLoop
		mov eax, dword[n]
		movzx eax, byte[ecx+eax]
;		call print_num;
;		call printComma
;		call printNewline
		mov byte[char], 0
		mov ebx, 0
		strStrInLoop:
			mov eax, dword[n]
;			dec eax
			cmp ebx, eax
			je endOfStrStrInLoop			
			
			mov al, byte[ecx+ebx]
			mov ah, byte[edx+ebx]
			
			cmp al, ah
			je skip1
				mov byte[char], 1
				jmp endOfStrStrInLoop
			skip1:
			; movzx eax, byte[ecx+ebx]
			; call print_num
			; call printComma
			; movzx eax, byte[edx+ebx]
			; call print_num
			; call printComma
			; movzx eax, byte[char]
			; call print_num
			; call printComma
			; mov eax, ecx
			; call print_num
			; call printComma
			; mov eax, edx
			; call print_num
			; call printComma
			; mov eax, ebx
			; call print_num
			; call printComma
;			call printNewline
			inc ebx
			jmp strStrInLoop
		endOfStrStrInLoop:
		inc ecx
		cmp byte[char], 0
		je foundOne
		jmp strStrOutLoop
		foundOne:
			inc dword[count]
			jmp strStrOutLoop
	endOfStrStrOutLoop:
	;mov eax, 987
	;call print_num
	;call printComma	
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
	
	mov byte[temp], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	
	popa 
	ret
	
printComma:
	pusha
	
	mov byte[temp], ','
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	
	popa 
	ret
	
printTab:
	pusha
	
	mov byte[temp], 9
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
;		call printNewline
		popa
		ret
