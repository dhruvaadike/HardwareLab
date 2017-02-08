section .data
	msg1: db "Enter the First Word : "
	msg1_len: equ $-msg1
	msg2: db "Enter the Second Word : "
	msg2_len: equ $-msg2
	msg3: db "Is An Annagram", 0Ah
	msg3_len: equ $-msg3	
	msg4: db "Is Not An Annagram", 0Ah
	msg4_len: equ $-msg4

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	word1:	resb 100
	word2:	resb 100
	word1_len:	resd 1
	word2_len:	resd 1
	count1:	resd 30
	count2:	resd 30
	char: 	resb 1
	addrr:	resd 1

	
section .text
global _start

_start:
	;Ask for the Word1
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	mov eax, word1
	call getWord
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov eax, word2
	call getWord
	
	mov edx, 0
	countFor1:
		movzx eax, byte[word1+edx]
		cmp al, ' '
		je endCountFor1
		call toUpper
		sub al, 'a'
		inc dword[count1+eax]
		inc edx
		jmp countFor1
	endCountFor1:
	
	mov edx, 0
	countFor2:
		movzx eax, byte[word2+edx]
		cmp al, ' '
		je endCountFor2
		call toUpper
		sub al, 'a'
		inc dword[count2+eax]
		inc edx
		jmp countFor2
	endCountFor2:
	
	mov edx, 0
	test1:
		cmp edx, 26
		je endTest1
		mov eax, dword[count1+edx]
		cmp eax, dword[count2+edx]
		jne endTest1
		inc edx
		jmp test1
	endTest1:
	cmp edx, 26
	je IsAnnagram
	jmp IsNot
	IsAnnagram:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, msg3_len
		int 80h
		jmp Exit
	
	IsNot:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg4
		mov edx, msg4_len
		int 80h
		jmp Exit
	
	Exit:
	mov eax, 1
	mov ebx, 0
	int 80h

toUpper:
	cmp al, 'a'
	jb toUpperReturn
	cmp al, 'z'
	ja toUpperReturn
	sub al, 32
	toUpperReturn:
	ret


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

strcmp:
	pusha
	mov byte[char], 0
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
		jmp strCmpLoop
	
	endOfStrCmpLoop:
	popa 
	ret
	
strstr:
	pusha
	strStrOutLoop:
		mov eax, dword[word2_len]
		cmp byte[ecx+eax], ' '
		je endOfStrStrOutLoop
		mov byte[char], 0
		movzx eax, byte[char]
;		call print_num;
;		call printNewline
;		call printNewline
		mov ebx, 0
		strStrInLoop:
			mov al, byte[ecx+ebx]
			mov ah, byte[edx+ebx]
			
			cmp ah, ' '
			je endOfStrStrOutLoop			
			cmp al, ah
			je skip1
				mov byte[char], 1
				jmp endOfStrStrInLoop
			skip1:
;			movzx eax, byte[ecx+ebx]
;			call print_num
;			movzx eax, byte[edx+ebx]
;			call print_num
;			movzx eax, byte[char]
;			call print_num
;			mov eax, ecx
;			call print_num
;			mov eax, edx
;			call print_num
;			mov eax, ebx
;			call print_num
;			call printNewline
			inc ebx
			jmp strStrInLoop
		endOfStrStrInLoop:
		inc ecx
		jmp strStrOutLoop
	endOfStrStrOutLoop:
;	mov eax, 987
;	call print_num
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
	
strcat:
	pusha
;	mov eax, 0
	strCatFindLoop:
		mov bl, byte[ecx]
		cmp bl, ' '
		je endOfStrCatFindLoop
		inc ecx
;		call print_num
;		inc eax
		jmp strCatFindLoop
	endOfStrCatFindLoop:
;	call print_num
	strCatLoop:
		mov bl, byte[edx]
		mov byte[ecx], bl
		cmp bl, ' '
		je endOfStrCatLoop
;		call print_num
		inc edx
;		inc eax
		inc ecx
		jmp strCatLoop
	endOfStrCatLoop:
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
		mov byte[temp], ','
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		popa
		ret
