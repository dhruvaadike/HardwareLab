section .data
	msgE:	db	"Enter Number of Rows and Columns", 0Ah
	msgE_len: equ	$-msgE
	msgM:	db	"Enter Elements of the Matrix (row by row)", 0Ah
	msgM_len: equ	$-msgM
	msgT:	db	"The Transpose is", 0Ah
	msgT_len: equ	$-msgT

section .bss
	;required for the functions
	rnum:	resw 1
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1

	;Variable used in general
	Matrix: resw 100
	Trans: 	resw 100
	m:		resw 1
	n:		resw 1

section .text
	global _start

_start:

	;Ask to Enter M and N
	mov eax, 4
	mov ebx, 1
	mov ecx, msgE
	mov edx, msgE_len
	int 80h
	
	;Reding M
	call read_num
	mov word[m], ax
	
	;Reding N
	call read_num
	mov word[n], ax
	
	;Ask to The Elements
	mov eax, 4
	mov ebx, 1
	mov ecx, msgM
	mov edx, msgM_len
	int 80h
	
	;Reading Elements in Matrix
	mov ebx, 0
	mov ecx, 0
	readingElementsRowLoop:
		cmp cx, word[m]
		je endOfReadingElementsRowLoop
		mov edx, 0
		readingElementsColLoop:
			cmp dx, word[n]
			je endOfReadingElementsColLoop
			
			mov ebx, 0
			mov ax, cx
			mov bx, word[n]
			push edx
			mul bx
			mov bx, ax
			pop edx
			add bx, dx
			call read_num
			mov word[Matrix+2*ebx], ax
			
			inc edx
			jmp readingElementsColLoop
		endOfReadingElementsColLoop:
		
		inc ecx
		jmp readingElementsRowLoop
	endOfReadingElementsRowLoop:
	
	
	;Setting Elements in Transpose
	mov ebx, 0
	mov ecx, 0
	settingElementsRowLoop:
		cmp cx, word[m]
		je endOfSettingElementsRowLoop
		mov edx, 0
		settingElementsColLoop:
			cmp dx, word[n]
			je endOfSettingElementsColLoop
			
			mov ebx, 0
			mov ax, cx
			mov bx, word[n]
			push edx
			mul bx
			mov bx, ax
			pop edx
			add bx, dx
			mov ax, word[Matrix+2*ebx]
			
			push eax
			
			mov ebx, 0
			mov ax, dx
			mov bx, word[m]
			push edx
			mul bx
			mov bx, ax
			pop edx
			add bx, cx
			
			pop eax
			mov word[Trans+2*ebx], ax
			
			inc edx
			jmp settingElementsColLoop
		endOfSettingElementsColLoop:
		
		inc ecx
		jmp settingElementsRowLoop
	endOfSettingElementsRowLoop:
	
	
	
	;Printing Elements in Matrix
	mov ebx, 0
	mov edx, 0
	printingElementsRowLoop:
		cmp dx, word[n]
		je endOfPrintingElementsRowLoop
		mov ecx, 0
		printingElementsColLoop:
			cmp cx, word[m]
			je endOfPrintingElementsColLoop
			
			push edx
			mov ebx, 0
			mov ax, dx
			mov bx, word[m]
			mul bx
			mov bx, ax
			pop edx
			add bx, cx
			mov ax, word[Trans+2*ebx]
			call print_num
			call print_tab
			
			inc ecx
			jmp printingElementsColLoop
		endOfPrintingElementsColLoop:
		
		call print_newline
		inc edx
		jmp printingElementsRowLoop
	endOfPrintingElementsRowLoop:
	
	call print_newline
	
	Exit:
	mov eax, 1
	mov ebx, 0
	int 80h
	

read_num:
	pusha
	mov word[rnum], 0
	loop_read:
		mov eax, 3
		mov ebx, 0
		mov ecx, temp
		mov edx, 1
		int 80h
	
		cmp byte[temp], 0Ah
		je end_read
		cmp byte[temp], 20h
		je end_read
	
		mov ax, word[rnum]
		mov bx, 10
		mul bx
		mov bl, byte[temp]
		sub bl, 30h
		mov bh, 0
		add ax, bx
		mov word[rnum], ax
		jmp loop_read
	
	end_read:
		popa
		mov ax,word[rnum]
		ret
		

print_num:
	pusha
	cmp ax, 0
	je print_Zero
	mov word[pnum], ax
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
		
	end_print:
		popa
		ret
	print_Zero:
		mov byte[temp], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
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
	
	
print_tab:
	pusha
	mov byte[temp], 09h
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	popa
	ret
