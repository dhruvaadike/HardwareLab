section .data
	msg1: db "Enter the First Word : "
	msg1_len: equ $-msg1
	msg2: db "Enter the Second Word : "
	msg2_len: equ $-msg2
	msg3: db "Is A Circular Permutation", 0Ah
	msg3_len: equ $-msg3	
	msg4: db "Is Not A Circular Permutation", 0Ah
	msg4_len: equ $-msg4

section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	
	word1:		resb 100
	wordtemp:	resb 100
	word1_len:	resd 1
	word2:		resb 100
	word2_len:	resd 1
	char: 		resb 1
	addrr:		resd 1

	
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
	
	mov eax, word1
	call strlen
	
;	mov eax, dword[addrr]
;	call print_num
	mov eax, dword[addrr]
	mov dword[word1_len], eax
	
	mov eax, word2
	call strlen
	
;	mov eax, dword[addrr]
;	call print_num
	mov eax, dword[addrr]
	cmp dword[word1_len], eax
	jne Not_Circ_Perm
	
	mov edx, wordtemp
	mov ecx, word1
	call strcpy
	
;	mov eax, wordtemp
;	call printWord
	
	mov ecx, word1
	mov edx, wordtemp
	call strcat
	
;	mov eax, word1
;	call printWord
	
	mov ecx, word1
	mov edx, word2
	call strstr
	
	cmp byte[char], 0
	je Is_Circ_Perm
	jmp Not_Circ_Perm
	
	jmp Exit
	
	Not_Circ_Perm:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg4
		mov edx, msg4_len
		int 80h
		jmp Exit
	
	Is_Circ_Perm:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, msg3_len
		int 80h
		jmp Exit
	
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
