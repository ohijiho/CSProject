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
	
	range = 2		;이정도 차이는 학습하지 않음, 현재 input으로 약 30~40% 걸러짐

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
	jb _use_value		;첫 10개는 일단 수용함 (k = 0.5부터 거름)
	
	mov edx, eax		;push eax
	call query			;eax = f(x)
	sub eax, ebx
	add eax, range
	cmp eax, range * 2
	mov eax, edx		;pop eax
	jbe _dont_use		;차이가 range이하인 경우 이 input을 버림
	;0 <= f(x) - y + range <= 2range
	;equivalent to |f(x) - y| <= range
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_use_value:
	inc ecx
	mov cnt, ecx
	test ecx, 1
	jnz _dont_learn		;ecx가 홀수인 경우 짝이 맞지 않으므로

_do_learn:
	push prevx
	push prevy
	push eax
	push ebx
	call learn			;저장된 값과 현재 값을 사용해 학습함
	jmp _dont_use;c2	;학습된 값은 버림 (저장하지 않음)

_dont_learn:			;현재 값을 다음에 사용하도록 저장만 함
	;mov edx, prevy;c1
	;mov prevprevy, edx		; 전 전 y값을 저장함;c1
	mov prevx, eax
	mov prevy, ebx
	
_dont_use:

	mov eax, ebx
	;add eax, 5;y is integer round = floor
	cdq
	mov ecx, 10
	div ecx				;결과(입력된 목표온도)를 반올림, 목표온도는 항상 정수이므로 성능을 위해 내림함
	
	pop edx
	pop ecx

	ret
manual endp

end
