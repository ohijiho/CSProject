include Irvine32.inc

.data

.code

weight proc;eax, ebx edx : ecx -> eax:edx
	;eax:edx = (eax * edx + ebx * ecx) / (edx + ecx)
	
	push edx

	;a * d
	imul edx

	xchg eax, ebx
	xchg edx, ecx
	push edx

	;b * c
	imul edx

	;a * d + b * c
	add eax, ebx
	adc edx, ecx

	;d + c
	pop ebx
	pop ecx
	add ebx, ecx

	;ans, flags
	idiv ebx
	
	ret
weight endp

end
