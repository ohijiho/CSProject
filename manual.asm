include Irvine32.inc

learn proto

.data

prevx dword ?
prevy dword ?
prevprevy dword ?
cnt dword 0

.code

;args - eax: 10 * x, ebx: 10 * y
;return - eax: resulting temp
manual proc
	
	push ecx
	push edx

	mov ecx, cnt

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp ecx, 2
	jb _dont_learn				; �� ��° input���ʹ� ������ �Ÿ�

	mov edx, ebx
	mov ecx, prevprevy
	not ecx;-ecx - 1
	add edx, ecx
	cmp edx, 2
	jbe _dont_learn	; y �Է°��� �� �� �� �Է°����� +-1 ���� ���� ���
	;0 <= y - prevprevy + 1 <= 2

	mov edx, ebx
	mov ecx, prevy
	not ecx;-ecx - 1
	add edx, ecx
	cmp edx, 2
	jbe _dont_learn		; y �Է°��� �� �� �Է°����� +-1 ���� ���� ���
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	push prevx
	push prevy
	push eax
	push ebx
	call learn
_dont_learn:
	inc ecx
	mov cnt, ecx
	mov edx, prevy
	mov prevprevy, edx		; �� �� y���� ������
	mov prevx, eax
	mov prevy, ebx

	mov eax, ebx
	add eax, 5
	cdq
	mov ecx, 10
	div ecx
	
	pop edx
	pop ecx

	ret
manual endp

end
