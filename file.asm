include Irvine32.inc

.data

spacechars byte 20h, 0dh, 0ah, 09h, 0
crlfbuf byte 0dh, 0ah

.code

;ebx: file handle
;edi: destination
;eax: input value or return value

file_getc proc;ebx, ret eax
	push ebp
	mov ebp, esp
	add esp, -8
	push ecx
	push edx
	push esi
	push edi
	
	lea esi, [ebp - 8]
	lea edi, [ebp - 4]

	invoke ReadFile, ebx, esi, 1, edi, 0
	mov eax, [edi]
	test eax, eax
	jz _IOERROR
	movzx eax, byte ptr [esi]

_END:
	pop edi
	pop esi
	pop edx
	pop ecx
	mov esp, ebp
	pop ebp
	ret
_IOERROR:
	mov eax, -1
	jmp _END
file_getc endp

file_skip_spaces proc;ebx
	push eax
	push ecx
	push edi

	mov edi, offset spacechars

_CHAR:
	call file_getc
	cmp eax, -1
	je _END;maybe EOF
	
	xor ecx, ecx
_SPACELOOP:
	mov ah, [edi + ecx]
	test ah, ah
	jz _NOTSPACE;ah == '\0'
	cmp al, ah
	je _CHAR;al is space
	inc ecx
	jmp _SPACELOOP;not detected
	
_NOTSPACE:
	invoke SetFilePointer, ebx, -1, 0, FILE_CURRENT;unread last nonspace

_END:
	pop edi
	pop ecx
	pop eax
	ret
file_skip_spaces endp

file_read_char proc;ebx, returns zx of char or -1
	push ecx
	push edi

	mov edi, offset spacechars

_CHAR:
	call file_getc
	cmp eax, -1
	je _EOF;maybe EOF
	
	xor ecx, ecx
_SPACELOOP:
	mov ah, [edi + ecx]
	test ah, ah
	jz _NOTSPACE;ah == '\0'
	cmp al, ah
	je _CHAR;al is space
	inc ecx
	jmp _SPACELOOP;not detected

_NOTSPACE:
	movzx eax, al

_EOF:
_END:
	pop edi
	pop ecx
	ret
file_read_char endp

file_read_int_ignore_point proc;returns the unsigned integer of 0
;unsafe (does't check overflow)
	push ecx
	push edx
	push edi

	mov edi, 10

	call file_skip_spaces

	;eax = 0
	xor eax, eax

_CHAR:
	mov edx, eax
	call file_getc
	cmp eax, -1
	mov ecx, eax
	mov eax, edx
	jz _EOF; maybe eof
	cmp ecx, '.'
	je _CHAR; skip '.'
	cmp ecx, '0'
	jb _NI; below '0'
	cmp ecx, '9'
	ja _NI; above '9'

	mul edi
	sub ecx, '0'
	add eax, ecx
	jmp _CHAR

_NI:
	mov edi, eax
	invoke SetFilePointer, ebx, -1, 0, FILE_CURRENT;unread last nondigit
	mov eax, edi

_EOF:
_END:
	pop edi
	pop edx
	pop ecx
	ret
file_read_int_ignore_point endp

file_writefile proc; esi char *, ecx dword, ebx file, return eax (nbytes written)
	push ebp
	mov ebp, esp
	add esp, -4
	push ecx
	push edx
	push edi

	lea edi, [ebp - 4]

	invoke WriteFile, ebx, esi, ecx, edi, 0
	mov eax, [edi]

	pop edi
	pop edx
	pop ecx
	mov esp, ebp
	pop ebp
	ret
file_writefile endp

file_writefile_s proc; eax (1: success, 0: failure)
	call file_writefile
	cmp eax, ecx
	jne _IOERROR
	mov eax, 1
_END:
	ret
_IOERROR:
	xor eax, eax
	jmp _END
file_writefile_s endp

file_write_char proc;al char, ebx file, returns eax (1: success, 0: failure)
	push ebp
	mov ebp, esp
	add esp, -4
	push ecx
	push edx
	push esi

	lea esi, [ebp - 4]

	mov [esi], al
	invoke WriteFile, edx, esi, 1, 0, 0

	pop esi
	pop edx
	pop ecx
	mov esp, ebp
	pop ebp
	ret
file_write_char endp

file_write_int proc
	;eax dword
	;ebx file
	;returns eax (1: success, 0: failure)
	push ecx
	push edx
	push esi
	push edi

	mov edi, 10;10

	;generate data structure stack, asm에서만 되는거
	push ebp
	mov ebp, esp
_DIGIT:
	cdq
	div edi
	add edx, '0'
	dec esp
	mov [esp], dl
	test eax, eax;자연스럽게 0(출력: "0")도 처리됨
	jnz _DIGIT

	mov ecx, ebp
	sub ecx, esp;ecx = ebp - esp
	mov esi, esp
	call file_writefile_s

	mov esp, ebp
	pop ebp
	
	pop edi
	pop esi
	pop edx
	pop ecx
	ret
file_write_int endp

file_writeln proc
	push ecx
	push esi

	mov esi, offset crlfbuf
	mov ecx, 2
	call file_writefile_s

_END:
	pop esi
	pop ecx
	ret
file_writeln endp

file_writeln_int proc
	call file_write_int
	test eax, eax
	jz _IOERROR
	call file_writeln
	;test eax, eax
	;jz _IOERROR

_IOERROR:
	ret
file_writeln_int endp

end
