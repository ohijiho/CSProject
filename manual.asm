include Irvine32.inc

learn proto

.data

prevx dword ?
prevy dword ?
cnt dword 0

.code

;args - SDWORD 10 * x, 10 * y
;return - eax: resulting temp
manual proc
	
	push ebp
	mov ebp, esp

	push ebx
	push ecx
	push edx

	mov ebx, [ebp + 12]
	mov eax, [ebp + 8]

	mov ecx, cnt

	;;;(c)를 여기에 구현
	;test ecx, ecx
	test ecx, 1
	jz _dont_learn

	push prevx
	push prevy
	push ebx
	push eax
	call learn
_dont_learn:
	inc ecx
	mov cnt, ecx
	mov prevx, ebx
	mov prevy, eax

	add eax, 5
	cdq
	mov ebx, 10
	div ebx
	
	mov ebx, [ebp + 4]
	mov [ebp + 12], ebx

	pop edx
	pop ecx
	pop ebx

	pop ebp
	add esp, 8

	ret
manual endp

end
