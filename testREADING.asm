include Irvine32.inc

ReadLine proto
WriteLine proto
file_writeln_int proto
manual proto
auto proto

.data
    infilename BYTE "input.txt", 0
    outfilename BYTE "output.txt",0
    errMsg BYTE "Cannot open file", 0dh, 0ah, 0

.code
test2 proc

	push ebp
	mov ebp, esp
	;add esp, -8
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
    INVOKE CreateFile, ADDR infilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov esi, eax
	cmp eax, -1
	je ERROR1

    INVOKE createFile, ADDR outfilename, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov edi, eax
	cmp eax, -1
	je ERROR2

_READ:
    mov eax, esi
    call ReadLine

	cmp eax, -1
	je _ENDREAD
	cmp ebx, -1
	je _AUTO

	call manual
	jmp _WRITE
_AUTO:
	call auto

_WRITE:
    mov ebx,edi
    call file_writeln_int
	jmp _READ

_ENDREAD:
    INVOKE CloseHandle, esi
    INVOKE CloseHandle, edi

QuitNow:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	;mov esp, ebp
	pop ebp
	ret

ERROR2:
    INVOKE CloseHandle, esi
	;jmp ERROR1
	
ERROR1:
    mov edx, OFFSET errMsg; display error message
    call WriteString
    jmp QuitNow
test2 endp

end
