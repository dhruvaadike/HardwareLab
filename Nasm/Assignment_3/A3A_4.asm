section .data
	msg1: db "Enter First string : "
	msg1_len: equ $-msg1
	msg2: db "Enter Second string : "
	msg2_len: equ $-msg2
	msg3: db "First is Smaller.", 0Ah
	msg3_len: equ $-msg3
	msg4: db "Second is Smaller.", 0Ah
	msg4_len: equ $-msg4
	msg5: db "Both are same.", 0Ah
	msg5_len: equ $-msg5
	
section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	
	string1: resb 200
	string2: resb 200
	string1_len: resd 1
	string2_len: resd 1
	char: resb 1
	index:	resd 1
	count:	resd 1

section .text
global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	mov dword[index], 0
	reading1Loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfReading1
		mov ah, byte[char]
		mov edx, dword[index]
		mov byte[string1+edx], ah
		inc dword[index]
		jmp reading1Loop
	
	endOfReading1:
	
	mov edx, dword[index]
	mov byte[string1+edx], 0
	inc edx
	mov edx, dword[index]
	mov dword[string1_len], edx
	; mov eax, edx
	; call print_num
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov dword[index], 0
	reading2Loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfReading2
		mov ah, byte[char]
		mov edx, dword[index]
		mov byte[string2+edx], ah
		inc dword[index]
		jmp reading2Loop
	
	endOfReading2:
	
	mov edx, dword[index]
	mov byte[string2+edx], 0
	inc edx
	mov edx, dword[index]
	mov dword[string2_len], edx
	; mov eax, edx
	; call print_num
	
	; mov eax, 4
	; mov ebx, 1
	; mov ecx, string1
	; mov edx, dword[string1_len]
	; int 80h
	
	; call print_newline
	
	; mov eax, 4
	; mov ebx, 1
	; mov ecx, string2
	; mov edx, dword[string2_len]
	; int 80h
	
	; call print_newline
	
	mov edx, 0
	compareLoop:
		mov bh, byte[string1+edx]
		mov bl, byte[string2+edx]
		;movzx eax, bh
		;call print_num
		;movzx eax, bl
		;call print_num
		cmp bh, bl
		jne endCompareLoop
		cmp bh, 0
		je endCompareLoop
		inc edx
		jmp compareLoop
	endCompareLoop:
	
	; mov eax, edx
	; call print_num
	
	cmp bh, bl
	je Equal
	jb Below
	jmp Above
	
	Equal:
		mov ecx, msg5
		mov edx, msg5_len
		jmp print
		
	Below:
		mov ecx, msg4
		mov edx, msg4_len
		jmp print
		
	Above:
		mov ecx, msg3
		mov edx, msg3_len
	
	print:
	mov eax, 4
	mov ebx, 1
	int 80h
	
	Exit:
	mov eax, 1
	mov ebx, 0
	int 80h

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
		call print_newline
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
