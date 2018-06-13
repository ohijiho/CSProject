include Irvine32.inc

; ������ ���پ� �д´�
;input-eax:filehandle�� ���� ������
;output- eax-����µ�(���ϳ�: -1)
;        ebx-��ǥ�µ�(�ڵ������ ��� -1)
;�߿�:�̸� ���ο��� createFile�� ȣ���� filehandle���� ������ �־���Ѵ�
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

	;ù ����
	call file_read_char

	cmp eax, 'm'
	je _manual
	cmp eax, 'a'
	je _automatic

	mov eax, -1;EOF or error
	jmp _END

_manual:

	;���� �µ�
	call file_read_int_ignore_point
	mov ecx, eax

	;��ǥ�µ�
	call file_read_int_ignore_point
	mov edx, 10
	mul edx

	mov ebx, eax
	mov eax, ecx
	jmp _END

_automatic:

	;���� �µ�
	call file_read_int_ignore_point

	;���� �µ�
	mov ebx, -1

_END:

	pop edx
	pop ecx
    ret
ReadLine endp

end
