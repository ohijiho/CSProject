include Irvine32.inc

query proto

.data

.code

;args - eax: 10 * x
;return - eax: resulting temp
auto proc
	
	push ebx
	push edx

	call query		;f(x)를 계산하고
	add eax, 5
	cdq
	mov ebx, 10
	div ebx			;반올림함

	pop edx
	pop ebx

	ret
auto endp

end
