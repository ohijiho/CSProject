include Irvine32.inc

learn proto

.data

prevx dword ?
prevy dword ?
cnt dword 0

.code

;args - eax: 10 * x, ebx: 10 * y
;return - eax: resulting temp
manual proc
	
	push ecx
	push edx

	mov ecx, cnt

	;;;(c)를 여기에 구현
	;test ecx, ecx
	test ecx, 1
	jz _dont_learn

	push prevx
	push prevy
	push eax
	push ebx
	call learn
_dont_learn:
	inc ecx
	mov cnt, ecx
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
