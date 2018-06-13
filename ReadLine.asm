include Irvine32.inc

; 파일을 한줄씩 읽는다
;input-eax:filehandle의 값을 가진다
;output- eax-현재온도(파일끝: -1)
;        ebx-목표온도(자동모드일 경우 -1)
;중요:미리 매인에서 createFile을 호출해 filehandle값을 가지고 있어야한다
;

file_read_char proto
file_read_int_ignore_point proto

.data

.code
ReadLine proc

	push ecx
	push edx

	mov ebx, eax

_start:

	;첫 글자
	call file_read_char

	cmp eax, 'm'
	je _manual
	cmp eax, 'a'
	je _automatic

	mov eax, -1;EOF or error
	jmp _END

_manual:

	;현재 온도
	call file_read_int_ignore_point
	mov ecx, eax

	;목표온도
	call file_read_int_ignore_point
	mov edx, 10
	mul edx

	mov ebx, eax
	mov eax, ecx
	jmp _END

_automatic:

	;현재 온도
	call file_read_int_ignore_point

	;나중 온도
	mov ebx, -1

_END:

	pop edx
	pop ecx
    ret
ReadLine endp

end
