section .data
Error1:	db	"ERROR: Number of elements has to be more than 1",0Ah
Error1_len: equ	$-Error1
msg3:	db	"Enter Number of Elements ",
msg3_len: equ	$-msg3
msg2:	db	"The Second Largest Number is "
msg2_len: equ	$-msg2
msg4:	db	"The Largest Number is "
msg4_len: equ	$-msg4


section .bss
rnum:	resw 1
pnum:	resw 1
num:	resw 1
max:	resw 1
max2:	resw 1
temp:	resb 1
nod:	resb 1
n:		resw 1

section .text

global _start

Err:
	mov eax, 4
	mov ebx, 1
	mov ecx, Error1
	mov edx, Error1_len
	int 80h
	
	jmp Exit

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, msg3_len
	int 80h
	
	
	call read_num
	cmp ax, 2
	jb Err
	mov word[n], ax
	sub word[n], 2
	
	call read_num
	mov word[max], ax
	
	call read_num
	cmp ax, word[max]
	ja axIsMax
	
	mov word[max2], ax
	jmp loopReadingArray
	
	axIsMax:
		mov bx, word[max]
		mov word[max2], bx
		mov word[max], ax
	
	loopReadingArray:
	cmp word[n], 0
	je endOfLoop
	call read_num
	cmp ax, word[max]
	ja gotNewMax
	cmp ax, word[max2]
	ja gotNewMax2
	jmp next
	gotNewMax:
		mov bx, word[max]
		mov word[max2], bx
		mov word[max], ax
		jmp next
	
	gotNewMax2:
		mov word[max2], ax
		jmp next
		
	next:
	dec word[n]
	jmp loopReadingArray
	
	endOfLoop:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov ax, word[max2]
	call print_num
	
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

