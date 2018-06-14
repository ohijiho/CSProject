include Irvine32.inc

learn proto
query proto

.data

prevx sdword ?
prevy sdword ?
cnt dword 0

.code

manual proc
	
	range = 2			;������ ���̴� �н����� ����, ���� input���� �� 30~40% �ɷ���

	push ecx
	push edx

	mov ecx, cnt

	cmp ecx, 10
	jb _use_value		;ù 10���� �ϴ� ������ (k = 0.5���� �Ÿ�)
	
	mov edx, eax		;push eax
	call query			;eax = f(x)
	sub eax, ebx
	add eax, range
	cmp eax, range * 2
	mov eax, edx		;pop eax
	jbe _dont_use		;���̰� range������ ��� �� input�� ����

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
	mov prevx, eax
	mov prevy, ebx
	
_dont_use:
	mov eax, ebx
	cdq
	mov ecx, 10
	div ecx				;���(�Էµ� ��ǥ�µ�)�� �ݿø�, ��ǥ�µ��� �׻� �����̹Ƿ� ������ ���� ������
	
	pop edx
	pop ecx

	ret
	
manual endp

end