include Irvine32.inc

learn proto
query proto

.data

prevx sdword ?
prevy sdword ?
;prevprevy dword ?;c1
cnt dword 0

.code

;args - eax: 10 * x, ebx: 10 * y
;return - eax: resulting temp
manual proc
	
	range = 2		;������ ���̴� �н����� ����, ���� input���� �� 30~40% �ɷ���

	push ecx
	push edx

	mov ecx, cnt

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;always
	;jmp _use_value
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;c1
	;cmp ecx, 2
	;jb _use_value				; �� ��° input���ʹ� ������ �Ÿ�
	;
	;mov edx, ebx
	;sub edx, prevy
	;add edx, range
	;cmp edx, range * 2
	;jbe _dont_use	; y �Է°��� �� �� �� �Է°����� +-1 ���� ���� ���
	;;0 <= y - prevprevy + range <= 2range
	;
	;mov edx, ebx
	;sub edx, prevy
	;add edx, range
	;cmp edx, range * 2
	;jbe _dont_use		; y �Է°��� �� �� �Է°����� +-1 ���� ���� ���
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;c2
	cmp ecx, 10
	jb _use_value		;ù 10���� �ϴ� ������ (k = 0.5���� �Ÿ�)
	
	mov edx, eax		;push eax
	call query			;eax = f(x)
	sub eax, ebx
	add eax, range
	cmp eax, range * 2
	mov eax, edx		;pop eax
	jbe _dont_use		;���̰� range������ ��� �� input�� ����
	;0 <= f(x) - y + range <= 2range
	;equivalent to |f(x) - y| <= range
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_use_value:
	inc ecx
	mov cnt, ecx
	test ecx, 1
	jnz _dont_learn		;ecx�� Ȧ���� ��� ¦�� ���� �����Ƿ�

_do_learn:
	push prevx
	push prevy
	push eax
	push ebx
	call learn			;����� ���� ���� ���� ����� �н���
	jmp _dont_use;c2	;�н��� ���� ���� (�������� ����)

_dont_learn:			;���� ���� ������ ����ϵ��� ���常 ��
	;mov edx, prevy;c1
	;mov prevprevy, edx		; �� �� y���� ������;c1
	mov prevx, eax
	mov prevy, ebx
	
_dont_use:

	mov eax, ebx
	;add eax, 5;y is integer round = floor
	cdq
	mov ecx, 10
	div ecx				;���(�Էµ� ��ǥ�µ�)�� �ݿø�, ��ǥ�µ��� �׻� �����̹Ƿ� ������ ���� ������
	
	pop edx
	pop ecx

	ret
manual endp

end
