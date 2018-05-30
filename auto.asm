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

	pop ebx
	pop edx

	ret
auto endp

end
