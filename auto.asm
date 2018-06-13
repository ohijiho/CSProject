include Irvine32.inc

query proto

.data

.code

;args - eax: 10 * x
;return - eax: resulting temp
auto proc
	
	push ebx
	push edx

	call query
	add eax, 5
	cdq
	mov ebx, 10
	div ebx

	pop edx
	pop ebx

	ret
auto endp

end
