section .data
	msg1:	db	"Enter The First Number  ", 
	msg1_len: equ	$-msg1
	msg2:	db	"Enter The Second Number ", 
	msg2_len: equ	$-msg2
	msg3:	db	"Result = ",
	msg3_len: equ	$-msg3
	
section .bss
	temp:	resd 1
	dig:	resb 1
	nod:	resb 1

	num1:	resd 1
	num2:	resd 1
	shift:	resd 1
	index:	resb 1

section .text
	global _start

_start:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	call read_int
	mov dword[num1], eax
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	call read_int
	mov dword[num2], eax
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, msg3_len
	int 80h
	
	mov eax, dword[num1]
	sub eax, dword[num2]
	call print_int
	call print_newline
	
	mov eax, 1
	mov ebx, 0
	int 80h
		

print_bits:
	pusha
	mov dword[temp], eax
	mov dword[shift], 2147483648
	mov byte[index], 0
	startBitLoop:
		cmp byte[index], 32
		je endBitLoop
		mov ebx, dword[shift]
		TEST dword[temp],ebx
		jz zero
		mov byte[dig], '1'
		jmp next
		zero:
		mov byte[dig], '0'
		next:
		mov eax, 4
		mov ebx, 1
		mov ecx, dig
		mov edx, 1
		int 80h
		shr dword[shift], 1
		inc byte[index]
		jmp startBitLoop
	endBitLoop:
	popa
	ret
	
	
	
print_newline:
	pusha
	mov byte[dig], 0Ah		;newline
	mov eax, 4
	mov ebx, 1
	mov ecx, dig
	mov edx, 1
	int 80h
	popa
	ret
		
print_comma:
	pusha
	mov byte[dig], ','
	mov eax, 4
	mov ebx, 1
	mov ecx, dig
	mov edx, 1
	int 80h
	mov byte[dig], ' '
	mov eax, 4
	mov ebx, 1
	mov ecx, dig
	mov edx, 1
	int 80h
	popa
	ret
	
print_int:
	pusha
	cmp eax, 0
	je print_Zero
	mov dword[temp], eax
	mov byte[nod], 0
	test eax, 2147483648
	jnz negative
	jmp extract_no
	negative:
		mov byte[dig], '-'
		mov eax, 4
		mov ebx, 1
		mov ecx, dig
		mov edx, 1
		int 80h
		neg dword[temp]
	extract_no:
		cmp dword[temp], 0
		je print_no
		inc byte[nod]
		mov dx, 0
		mov eax, dword[temp]
		mov bx, 10
		div bx
	
		push dx
		mov word[temp], ax
		jmp extract_no
	
	print_no:
		cmp byte[nod], 0
		je end_print
		dec byte[nod]
		pop dx
		mov byte[dig], dl
		add byte[dig], '0'
		mov eax, 4
		mov ebx, 1
		mov ecx, dig
		mov edx, 1
		int 80h
		jmp print_no
		
	print_Zero:
		mov byte[dig], '0'
		mov eax, 4
		mov ebx, 1
		mov ecx, dig
		mov edx, 1
		int 80h
		
	end_print:
		popa
		ret
		
read_int:
	pusha
	mov dword[temp], 0
	mov byte[nod], 0
	
	mov eax, 3
	mov ebx, 0
	mov ecx, dig
	mov edx, 1
	int 80h
	
	cmp byte[dig], 0Ah
	je end_read
	cmp byte[dig], ' '
	je end_read
	cmp byte[dig], '-'
	je gotSign
	sub byte[dig], '0'
	movzx eax, byte[dig]
	add dword[temp], eax
	loop_read:
		mov eax, 3
		mov ebx, 0
		mov ecx, dig
		mov edx, 1
		int 80h
	
		cmp byte[dig], 0Ah
		je end_read
		cmp byte[dig], ' '
		je end_read
	
		mov eax, dword[temp]
		shl eax, 2
		add eax, dword[temp]
		shl eax, 1
		movzx ebx, byte[dig]
		sub ebx, '0'
		add eax, ebx
		mov dword[temp], eax
		jmp loop_read
	
	end_read:
		cmp byte[nod], 0
		je skip
		neg dword[temp]
		skip:
		popa
		mov eax,dword[temp]
		ret
	gotSign:
		mov byte[nod], 1
		jmp loop_read
