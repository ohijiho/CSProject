include Irvine32.inc

ReadLine proto
;WriteLine proto

;eax의 unsigned int 값을 file handle ebx에 출력, 성공시 eax에 1, 실패시 0을 리턴
file_writeln_int proto

manual proto
auto proto

.data
    infilename BYTE "input.txt", 0
    outfilename BYTE "output.txt",0
    errMsg BYTE "Cannot open file", 0dh, 0ah, 0

.code
main proc

	push ebp
	mov ebp, esp
	;add esp, -8
	push eax
	push ebx
	push ecx; CreateFile에서 eax, ecx, edx를 수정함
	push edx; "
	push esi
	push edi
	
    INVOKE CreateFile, ADDR infilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov esi, eax ; esi: input.txt
	cmp eax, INVALID_HANDLE_VALUE
	je ERROR1

    INVOKE createFile, ADDR outfilename, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov edi, eax ; edi: output.txt
	cmp eax, INVALID_HANDLE_VALUE
	je ERROR2 ; esi를 닫고 에러메시지 출력

_READ:
    mov ebx, esi
    call ReadLine

	cmp eax, -1
	je _ENDREAD ; eax = -1 -> 끝

	cmp ebx, -1
	je _AUTO ; ebx = -1 -> auto

	call manual
	jmp _WRITE
_AUTO:
	call auto

_WRITE:

	; eax = auto 또는 manual의 결과, 설정된 또는 계산된 목표온도
    mov ebx,edi
    call file_writeln_int
	;출력오류는 체크하지 않음
	jmp _READ ; 다음 줄 반복

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
	
	invoke ExitProcess, 0

ERROR2:
    INVOKE CloseHandle, esi
	;jmp ERROR1
	
ERROR1:
    mov edx, OFFSET errMsg; display error message
    call WriteString
    jmp QuitNow
main endp

end main
