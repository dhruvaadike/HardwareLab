section .data
	msg1:	db	"Enter Number of Elements ",
	msg1_len: equ	$-msg1
	msg2:	db	" is the Mode",0Ah
	msg2_len: equ	$-msg2

section .bss
	rnum:	resw 1
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1

	num:	resw 1
	array: 	resw 100
	count: 	resw 100
	n:		resw 1
	max:	resw 1
	maxcount:	resw 1

section .text
	global _start

_start:
	
	mov ecx, 0
	initLoop:
		cmp ecx, 100
		je endOfinitLoop
		
		mov word[count+2*ecx], 0
		
		inc ecx
		jmp initLoop
	endOfinitLoop:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	call read_num
	mov word[n], ax
	
	
	mov ecx, 0
	readingLoop:
		cmp word[n], cx
		je endOfReadingLoop
		
		call read_num
		mov word[array+2*ecx], ax
		cmp ax, 99
		ja skip
		inc word[count+2*eax]
		skip:
		inc ecx
		jmp readingLoop
	endOfReadingLoop:
	
	mov word[max], 0
	mov ecx, 0
	mov ax, word[count+2*ecx]
	mov word[maxcount], ax
	inc ecx
	checkingLoop:
		cmp ecx, 100
		je endcheckingLoop
		
		mov ax, word[count+2*ecx]
		cmp ax, word[maxcount]
		ja foundMax
		jmp next
		foundMax:
			mov word[max], cx
			mov word[maxcount], ax
			jmp next
		next:

		inc ecx
		jmp checkingLoop
	endcheckingLoop:
	
	mov ax, word[max]
	call print_num
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
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
		cmp byte[temp], ' '
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

