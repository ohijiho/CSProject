include Irvine32.inc

; ������ ���پ� �д´�
;input-ebx:filehandle�� ���� ������
;output- eax-����µ�(���ϳ�: -1)
;        ebx-��ǥ�µ�(�ڵ������ ��� -1)
;�߿�:�̸� ���ο��� createFile�� ȣ���� filehandle���� ������ �־���Ѵ�
;

;������ �����ϰ� ���� �ϳ��� �Է¹���
;ebx in: file handle
;eax out: �Է¹��� ������ zero extension, ����(�Ǵ� ���ϳ�)�� -1
file_read_char proto

;�Ҽ����� �����ϰ� ����� �Է¹���, ���� ���� ����
;ebx in: file handle
;eax out: �Է¹��� ��, ���н� 0
file_read_int_ignore_point proto

.data

.code
ReadLine proc

	push ecx
	push edx

_start:

	;ù ���� ���Ϸκ��� �б� ->eax
	call file_read_char

	cmp eax, 'm'
	je _manual ;m�� manual
	cmp eax, 'a'
	je _automatic ;a�� auto

	mov eax, -1 ;���� ���̰ų� ����, eax = -1�� �̸� ǥ����
	jmp _END

_manual:

	;���� �µ�
	call file_read_int_ignore_point
	mov ecx, eax ; ecx: ����µ� * 10

	;��ǥ�µ�
	call file_read_int_ignore_point
	mov edx, 10
	mul edx ; eax: ��ǥ�µ� * 10

	mov ebx, eax ; ebx: ��ǥ�µ� * 10
	mov eax, ecx ; eax: ����µ� * 10
	jmp _END

_automatic:

	;���� �µ�
	call file_read_int_ignore_point
	;eax = ����µ� * 10

	;���� �µ�
	mov ebx, -1
	;ebx = auto

_END:

	pop edx
	pop ecx
    ret
ReadLine endp

end
