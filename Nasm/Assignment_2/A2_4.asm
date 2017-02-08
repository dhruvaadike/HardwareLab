section .data
	msg1:	db	"Enter Number of Elements ",
	msg1_len: equ	$-msg1
	msgA:	db	"Enter Elements of A", 0Ah
	msgA_len: equ	$-msgA
	msgB:	db	"Enter Elements of B", 0Ah
	msgB_len: equ	$-msgB
	msgC:	db	"Elements of C are", 0Ah
	msgC_len: equ	$-msgC
	esize:	equ 2

section .bss
	rnum:	resw 1
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1

	num:	resw 1
	arrayA: resw 50
	arrayB: resw 50
	arrayC: resw 50
	n:		resw 1

section .text
	global _start

_start:

	;Ask to Enter N
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	;Reding N
	call read_num
	mov word[n], ax
	
	;Ask to Enter A
	mov eax, 4
	mov ebx, 1
	mov ecx, msgA
	mov edx, msgA_len
	int 80h
	
	;Reading Elements in A
	mov edx, 0
	readingALoop:
		cmp dx, word[n]
		je endOfReadingALoop
		
		call read_num
		mov word[arrayA+2*edx], ax
		
		inc edx
		jmp readingALoop
	endOfReadingALoop:
	
	;Ask to Enter B
	mov eax, 4
	mov ebx, 1
	mov ecx, msgB
	mov edx, msgB_len
	int 80h
	
	;Reading Elements in B
	mov edx, 0
	readingBLoop:
		cmp dx, word[n]
		je endOfReadingBLoop
		call read_num
		mov word[arrayB+2*edx], ax
		inc edx
		jmp readingBLoop
	endOfReadingBLoop:
	
	;Setting Elements in C
	mov edx, 0
	settingCLoop:
		cmp dx, word[n]
		je endOfSettingCLoop
		mov ax, word[arrayA+2*edx]
		cmp ax, word[arrayB+2*edx]
		jb cisB
		jmp next
		cisB:
			mov ax, word[arrayB+2*edx]
		next:
		mov word[arrayC+2*edx], ax
		inc edx
		jmp settingCLoop
	endOfSettingCLoop:
	
	;Printing Elements of C
	mov eax, 4
	mov ebx, 1
	mov ecx, msgC
	mov edx, msgC_len
	int 80h
	
	mov edx, 0
	printingCLoop:
		cmp dx, word[n]
		je endOfPrintingCLoop
		mov ax, word[arrayC+2*edx]
		call print_num
		call print_comma
		inc edx
		jmp printingCLoop
	endOfPrintingCLoop:
	
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
	cmp ax, 0
	je print_Zero
	mov word[pnum], ax
	pusha
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
	
	
print_comma:
	pusha
	mov byte[temp], 2Ch
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	mov byte[temp], 20h
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	popa
	ret
