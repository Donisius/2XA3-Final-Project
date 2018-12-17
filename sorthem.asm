%include "asm_io.inc"

SECTION .data

error_msg_1: db "Must have only 1 command line argument",10,0
error_msg_2: db "Argument must be between 2 and 9",10,0
X: db "XXXXXXXXXXXXXXXXXXXXXXX",10,0
msg1: db "initial configuration",10,0
msg2: db "final configuration",10,0
msg: db "Array to be sorted:",10,0
msgfin: db "Sorted Array:",10,0

SECTION .bss

Size: resd 1
Counter_showp resd 1
Array: resd 10
spaces: resd 1
discs: resd 1
Counter_showp_2 resd 1

SECTION .text

	global asm_main

asm_main:

	enter 0,0
	pusha

	mov eax, dword [ebp+8]
	cmp eax, dword 2
	jne ERROR_1
	mov ebx, dword [ebp+12]
	mov eax, dword [ebx+4]
	mov bl, byte [eax+1]
	cmp bl, byte 0
	jne ERROR_2
	mov bl, byte [eax]
	sub bl, '0'
	cmp bl, 2
	jb ERROR_2
	cmp bl, 9
	ja ERROR_2
		
	START:
		mov [Size], bl
		mov eax, [Size]
		push eax
		push Array
		call rconf
		add esp, 12
		
		mov ebx, 0
		mov ecx, 0
		mov eax, msg
		call print_string
		call print_nl
		mov eax, '['
		call print_char
		PRINTING_LOOP:
			cmp ebx, 9
			je END_PRINTING_LOOP
			mov eax, [Array+ecx]
			call print_int
			mov eax, ' '
			call print_char
			add ebx, 1
			add ecx, 4
			jmp PRINTING_LOOP
			
		END_PRINTING_LOOP:
			mov eax, ']'
			call print_char
			call print_nl
			call print_nl
	mov eax, msg1
	call print_string
	push Array
	call showp
	add esp, 4
	mov eax, Size
	push eax
	mov eax, Array
	push eax
	call sorthem
	add esp, 8
	mov eax, msg2
	call print_string
	push Array
	call showp
	add esp, 4
	mov ebx, 0
       	mov ecx, 0
        mov eax, msgfin
        call print_string
	call print_nl
	mov eax, '['
	call print_char
        PRINTING_LOOP_2:
		cmp ebx, 9
                je END_PRINTING_LOOP_2
              	mov eax, [Array+ecx]
               	call print_int
               	mov eax, ' '
             	call print_char
              	add ebx, 1
              	add ecx, 4
             	jmp PRINTING_LOOP_2
	END_PRINTING_LOOP_2:
		mov eax, ']'
		call print_char
		call print_nl
		call print_nl
	jmp asm_main_end
	ERROR_1:
		mov eax, error_msg_1
		call print_string
		jmp asm_main_end
		
	ERROR_2:
		mov eax, error_msg_2
		call print_string
		jmp asm_main_end

asm_main_end:

	popa
	leave
	ret

sorthem:
	enter 0,0
	pusha	
	mov edi, [ebp+12]
	mov edx, [ebp+8]
	cmp [edi], dword 1
	je base_case
	dec dword [edi]
	add edx, 4	
	push edi
	push edx
	call sorthem
	add esp, 8
			
	mov ecx, 0
	mov eax, [edi]
	add eax, eax
	add eax, eax
	add eax, eax
	add eax, eax
	add eax, eax	
	sub edx, 4	
	LOOP:
		cmp ecx, eax
		je LOOP_END
		mov esi, [edx+ecx]
		mov ebx, [edx+ecx+4]
		cmp esi, ebx
		ja LOOP_END
		jmp SWAP
		SWAP:
			mov esi, [edx+ecx]
			mov ebx, [edx+ecx+4]
			mov [edx+ecx], ebx
			mov [edx+ecx+4], esi
			add ecx, 4
			jmp LOOP
				
	LOOP_END:
	
	jmp end_sorthem
	
	base_case:
		popa
		leave
		ret
		
	end_sorthem:	
		push Array
		call showp
		add esp, 4
		popa 
		leave
		ret
	
showp:
	enter 0,0 
	pusha
	call read_char	
	mov ebx, [ebp+8]
	mov [Counter_showp], dword 0
	mov esi, 0
	COUNT_PEG_LOOP:	
		cmp [ebx+esi], dword 0
		je END_COUNT_PEG_LOOP
		add esi, 4
		jmp COUNT_PEG_LOOP	
	
	END_COUNT_PEG_LOOP:
		sub esi, 4
		
	PRINT_PEG_LOOP:
		cmp esi, 0
		je END_PRINT_PEG_LOOP
		mov edx, 10
		sub edx, [ebx+esi]
		push edx
		call print_space
		add esp, 4
		mov edx, [ebx+esi]
		push edx
		call print_o
		mov eax, '|'
		call print_char
		push edx
		call print_o
		add esp, 8	
		sub esi, 4
		call print_nl
		jmp PRINT_PEG_LOOP
	
	END_PRINT_PEG_LOOP:
	mov edx, 10
	sub edx, [ebx]
	push edx
	call print_space
	add esp, 4
	mov edx, [ebx]
	push edx
	call print_o
	mov eax, '|'
	call print_char
	push edx
	call print_o
	add esp, 8
	call print_nl	
	mov eax, X
	call print_string	
	popa
	leave
	ret

print_space:
	enter 0,0
	pusha
	mov edx, [ebp+8]
        mov [spaces], edx	
	mov edx, 0

	PRINT_SPACE_LOOP:
		cmp edx, [spaces]
		je END_PRINT_SPACE_LOOP
		mov eax, ' '
		call print_char
		add edx, 1
		jmp PRINT_SPACE_LOOP		 	
	
	END_PRINT_SPACE_LOOP:	
	
	popa
	leave
	ret

print_o:
	enter 0,0
	pusha
	
	mov edx, [ebp+8]
	mov [discs], edx
	mov edx, 0

	PRINT_O_LOOP:
		cmp edx, [discs]
		je END_PRINT_O_LOOP
		mov eax, 'o'
		call print_char
		add edx, 1
		jmp PRINT_O_LOOP
	END_PRINT_O_LOOP:
	
	popa
	leave
	ret
	
