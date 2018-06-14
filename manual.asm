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
	
	range = 2

	push ecx
	push edx

	mov ecx, cnt

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;always
	;jmp _use_value
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;c1
	;cmp ecx, 2
	;jb _use_value				; 세 번째 input부터는 적당히 거름
	;
	;mov edx, ebx
	;sub edx, prevy
	;add edx, range
	;cmp edx, range * 2
	;jbe _dont_use	; y 입력값이 그 전 전 입력값에서 +-1 범위 내일 경우
	;;0 <= y - prevprevy + range <= 2range
	;
	;mov edx, ebx
	;sub edx, prevy
	;add edx, range
	;cmp edx, range * 2
	;jbe _dont_use		; y 입력값이 그 전 입력값에서 +-1 범위 내일 경우
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;c2
	cmp ecx, 10
	jb _use_value
	
	mov edx, eax
	call query
	sub eax, ebx
	add eax, range
	cmp eax, range * 2
	mov eax, edx
	jbe _dont_use
	;0 <= f(x) - y + range <= 2range
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_use_value:
	inc ecx
	mov cnt, ecx
	test ecx, 1
	jnz _dont_learn

_do_learn:
	push prevx
	push prevy
	push eax
	push ebx
	call learn
	jmp _dont_use;c2

_dont_learn:
	;mov edx, prevy;c1
	;mov prevprevy, edx		; 전 전 y값을 저장함;c1
	mov prevx, eax
	mov prevy, ebx
	
_dont_use:

	mov eax, ebx
	;add eax, 5;y is integer round = floor
	cdq
	mov ecx, 10
	div ecx
	
	pop edx
	pop ecx

	ret
manual endp

end
