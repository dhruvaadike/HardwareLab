section .data
	msgAE:	db	"Enter Number of Rows and Columns of Matrix A", 0Ah
	msgAE_len: equ	$-msgAE
	msgAM:	db	"Enter Elements of the Matrix A (row by row)", 0Ah
	msgAM_len: equ	$-msgAM
	msgBE:	db	"Enter Number of Rows and Columns of Matrix B", 0Ah
	msgBE_len: equ	$-msgBE
	msgBM:	db	"Enter Elements of the Matrix B (row by row)", 0Ah
	msgBM_len: equ	$-msgBM
	msgT:	db	"The Product AB is", 0Ah
	msgT_len: equ	$-msgT
	err:	db	"Matrix A and B cannot be Multiplied", 0Ah
	err_len: equ	$-err
section .bss
	;required for the functions
	rnum:	resw 1
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1

	;Variable used in general
	sum:	resw 1
	MatrixA: resw 100
	MatrixB: resw 100
	MatrixC: resw 100
	rA:		resw 1
	cA:		resw 1
	rB:		resw 1
	cB:		resw 1
	first:	resw 1
	second:	resw 1
	index:	resw 1
section .text
	global _start

_start:

	;Ask to Enter R and C for A
	mov eax, 4
	mov ebx, 1
	mov ecx, msgAE
	mov edx, msgAE_len
	int 80h
	
	;Reding R A
	call read_num
	mov word[rA], ax
	
	;Reding C A
	call read_num
	mov word[cA], ax
	
	;Ask to The Elements of A
	mov eax, 4
	mov ebx, 1
	mov ecx, msgAM
	mov edx, msgAM_len
	int 80h
	
	;Reading Elements in Matrix A
	mov ebx, 0
	mov ecx, 0
	reading_A_Elements_Row_Loop:
		cmp cx, word[rA]
		je end_Of_Reading_A_Elements_Row_Loop
		mov edx, 0
		reading_A_Elements_Col_Loop:
			cmp dx, word[cA]
			je end_Of_Reading_A_Elements_Col_Loop
			
			mov ebx, 0
			mov ax, cx
			mov bx, word[cA]
			push edx
			mul bx
			mov bx, ax
			pop edx
			add bx, dx
			call read_num
			mov word[MatrixA+2*ebx], ax
			
			inc edx
			jmp reading_A_Elements_Col_Loop
		end_Of_Reading_A_Elements_Col_Loop:
		
		inc ecx
		jmp reading_A_Elements_Row_Loop
	end_Of_Reading_A_Elements_Row_Loop:
	
	;Ask to Enter R and C for B
	mov eax, 4
	mov ebx, 1
	mov ecx, msgBE
	mov edx, msgBE_len
	int 80h
	
	;Reding R B
	call read_num
	mov word[rB], ax
	
	;Reding C B
	call read_num
	mov word[cB], ax
	
	
	;Reading Elements in Matrix B
	mov ebx, 0
	mov ecx, 0
	reading_B_Elements_Row_Loop:
		cmp cx, word[rB]
		je end_Of_Reading_B_Elements_Row_Loop
		mov edx, 0
		reading_B_Elements_Col_Loop:
			cmp dx, word[cB]
			je end_Of_Reading_B_Elements_Col_Loop
			
			mov ebx, 0
			mov ax, cx
			mov bx, word[cB]
			push edx
			mul bx
			mov bx, ax
			pop edx
			add bx, dx
			call read_num
			mov word[MatrixB+2*ebx], ax
			
			inc edx
			jmp reading_B_Elements_Col_Loop
		end_Of_Reading_B_Elements_Col_Loop:
		
		inc ecx
		jmp reading_B_Elements_Row_Loop
	end_Of_Reading_B_Elements_Row_Loop:
	
	mov ax, word[cA]
	mov bx, word[rB]
	cmp ax, bx
	jne NotPossible
	
	;Setting Elements in Matrix C
	mov ebx, 0
	setting_C_Elements_Row_Loop:
		cmp bx, word[rA]
		je end_Of_Setting_C_Elements_Row_Loop
		mov ecx, 0
		setting_C_Elements_Col_Loop:
			cmp cx, word[cB]
			je end_Of_Setting_C_Elements_Col_Loop
			mov word[sum], 0
			mov word[index], 0
;			mov ax, bx;
;			call print_num
;			call print_comma
;			mov ax, cx
;			call print_num
;			call print_newline
			summation_Loop:
				mov dx, word[index]
;				mov ax, word[index]
;				call print_num
;				call print_comma
				cmp dx, word[cA]
				je end_Of_SummationLoop
				
				mov ax, bx
				mov dx, word[cA]
				mul dx
				add ax, word[index]
;				call print_num
;				call print_comma
				movzx edx, ax
				mov ax, word[MatrixA+2*edx]
				mov word[first], ax
				
				mov ax, word[index]
				mov dx, word[cB]
				mul dx
				add ax, cx
;				call print_num
;				call print_comma
				movzx edx, ax
				mov ax, word[MatrixB+2*edx]
				mov word[second], ax
				
				mov ax, word[first]
				mov dx, word[second]
				mul dx
;				call print_num
;				call print_comma
				add word[sum], ax
				inc word[index]
				jmp summation_Loop
			end_Of_SummationLoop:
;			call print_newline
			mov ax, bx
			mov dx, word[cB]
			mul dx
			add ax, cx
;			call print_num
;			call print_comma
			movzx edx, ax
			mov ax, word[sum]
;			call print_num
;			call print_newline
			mov word[MatrixC+2*edx], ax			
					
			inc ecx
			jmp setting_C_Elements_Col_Loop
		end_Of_Setting_C_Elements_Col_Loop:
		
		inc ebx
		jmp setting_C_Elements_Row_Loop
	end_Of_Setting_C_Elements_Row_Loop:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msgT
	mov edx, msgT_len
	int 80h
	
	;Printing Elements in Matrix C
	mov ebx, 0
	printing_C_Elements_Row_Loop:
		cmp bx, word[rA]
		je end_Of_Printing_C_Elements_Row_Loop
		mov ecx, 0
		printing_C_Elements_Col_Loop:
			cmp cx, word[cB]
			je end_Of_Printing_C_Elements_Col_Loop
			
			mov ax, bx
			mov dx, word[cB]
			mul dx
			add ax, cx
;			call print_num
;			call print_comma
			movzx edx, ax
			mov ax, word[MatrixC+2*edx]
			call print_num
			call print_tab
			inc ecx
			jmp printing_C_Elements_Col_Loop
		end_Of_Printing_C_Elements_Col_Loop:
		
		call print_newline
		
		inc ebx
		jmp printing_C_Elements_Row_Loop
	end_Of_Printing_C_Elements_Row_Loop:
	
	
	Exit:
	mov eax, 1
	mov ebx, 0
	int 80h
	
	NotPossible:
	mov eax, 4
	mov ebx, 1
	mov ecx, err
	mov edx, err_len
	int 80h
	jmp Exit

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
