include Irvine32.inc

; 파일을 한줄씩 읽는다
;input-ebx:filehandle의 값을 가진다
;output- eax-현재온도(파일끝: -1)
;        ebx-목표온도(자동모드일 경우 -1)
;중요:미리 매인에서 createFile을 호출해 filehandle값을 가지고 있어야한다
;

;공백을 제외하고 글자 하나를 입력받음
;ebx in: file handle
;eax out: 입력받은 글자의 zero extension, 실패(또는 파일끝)시 -1
file_read_char proto

;소숫점을 무시하고 양수를 입력받음, 앞쪽 공백 무시
;ebx in: file handle
;eax out: 입력받은 수, 실패시 0
file_read_int_ignore_point proto

.data

.code
ReadLine proc

	push ecx
	push edx

_start:

	;첫 글자 파일로부터 읽기 ->eax
	call file_read_char

	cmp eax, 'm'
	je _manual ;m은 manual
	cmp eax, 'a'
	je _automatic ;a는 auto

	mov eax, -1 ;파일 끝이거나 오류, eax = -1로 이를 표시함
	jmp _END

_manual:

	;현재 온도
	call file_read_int_ignore_point
	mov ecx, eax ; ecx: 현재온도 * 10

	;목표온도
	call file_read_int_ignore_point
	mov edx, 10
	mul edx ; eax: 목표온도 * 10

	mov ebx, eax ; ebx: 목표온도 * 10
	mov eax, ecx ; eax: 현재온도 * 10
	jmp _END

_automatic:

	;현재 온도
	call file_read_int_ignore_point
	;eax = 현재온도 * 10

	;나중 온도
	mov ebx, -1
	;ebx = auto

_END:

	pop edx
	pop ecx
    ret
ReadLine endp

end
