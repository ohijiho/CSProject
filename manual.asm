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
	jb _dont_learn				; 세 번째 input부터는 적당히 거름

	mov edx, ebx
	mov ecx, prevprevy
	not ecx;-ecx - 1
	add edx, ecx
	cmp edx, 2
	jbe _dont_learn	; y 입력값이 그 전 전 입력값에서 +-1 범위 내일 경우
	;0 <= y - prevprevy + 1 <= 2

	mov edx, ebx
	mov ecx, prevy
	not ecx;-ecx - 1
	add edx, ecx
	cmp edx, 2
	jbe _dont_learn		; y 입력값이 그 전 입력값에서 +-1 범위 내일 경우
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
	mov prevprevy, edx		; 전 전 y값을 저장함
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
