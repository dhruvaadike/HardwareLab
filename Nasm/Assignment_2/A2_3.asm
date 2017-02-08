section .data
	msg3:	db	"Enter Number of Elements ",
	msg3_len: equ	$-msg3
	msg4:	db	"The Numbers divisble by 7 are ",0Ah
	msg4_len: equ	$-msg4
	esize:	equ 2

section .bss
	rnum:	resw 1
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1

	num:	resw 1
	array: 	resw 50
	n:		resw 1
	index:	resw 1
	curradd:resd 1

section .text
	global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, msg3_len
	int 80h
	
	
	call read_num
	mov word[n], ax
	
	mov word[index], ax
	mov ecx, array
	mov dword[curradd], ecx
	
	readingLoop:
		cmp word[index], 0
		je endOfReadingLoop
		call read_num
		mov ecx, dword[curradd]
		mov word[ecx], ax
		dec word[index]
		add dword[curradd], esize
		jmp readingLoop
	endOfReadingLoop:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, msg4_len
	int 80h
	
	mov ax, word[n]
	mov word[index], ax
	mov ecx, array
	mov dword[curradd], ecx
	
	printingLoop:
		cmp word[index], 0
		je endOfPrintingLoop
		mov ecx, dword[curradd]
		mov ax, word[ecx]
		mov dx, 0
		mov bx, 7
		div bx
		cmp dx, 0
		jne skip
		
		mov ax, word[ecx]
		call print_num
		mov byte[temp], 2Ch
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		
		
		skip:
		dec word[index]
		add dword[curradd], esize
		jmp printingLoop
	endOfPrintingLoop:
	
	
	mov byte[temp], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	
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

