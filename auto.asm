include Irvine32.inc

query proto

.data

.code

;args - eax: 10 * x
;return - eax: resulting temp
auto proc
	
	push ebx
	push edx

	call query		;f(x)�� ����ϰ�
	add eax, 5
	cdq
	mov ebx, 10
	div ebx			;�ݿø���

	pop edx
	pop ebx

	ret
auto endp

end
