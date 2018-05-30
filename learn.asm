include Irvine32.inc

weight proto

.data

a SDWORD 1000000;/1000000
b SDWORD -50000000;/1000000, (-50)
abd = 1000000
k DWORD 10;/10
kd = 10

msg_a BYTE "a: ", 0
msg_b BYTE ", b: ", 0
msg_k BYTE ", k: ", 0

.code

;input must be less than 1000 (100'C)
learn proc;x1, y1, x2, y2, /10
id = 10
x1 TEXTEQU <SDWORD ptr [ebp + 20]>
y1 TEXTEQU <SDWORD ptr [ebp + 16]>
x2 TEXTEQU <SDWORD ptr [ebp + 12]>
y2 TEXTEQU <SDWORD ptr [ebp + 8]>
	push ebp
	mov ebp, esp

	;sub esp, 16
a1 TEXTEQU <esi>
b1 TEXTEQU <edi>
a_new TEXTEQU <esi>
b_new TEXTEQU <edi>
	
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	;x1 y1 x2 y2
	;y = ax + b
	;a = (y2 - y1)/(x2 - x1)
	;y/x = a + b/x
	;y2/x2 - y1/x1 = b/x2 - b/x1 = (1/x2 - 1/x1)b
	;x1y2 - x2y1 = x1b - x2b = (x1 - x2)b
	;x2y1 - x1y2 = (x2 - x1)b
	;b = (y2/x2 - y1/x1)/(1/x2 - 1/x1) = (x2y1 - x1y2)/(x2 - x1)

	;a = abd(y2 - y1)/(x2 - x1)
	;b = abd(x2y1 - x1y2)/(x2 - x1)

	;ebx = x2 - x1, ebx nonzero
	mov ebx, x2
	sub ebx, x1
	jz _ERR

	;eax = y2 - y1
	mov eax, y2
	sub eax, y1

	;a1 = abd * eax / ebx
	mov edx, abd
	imul edx
	idiv ebx
	mov a1, eax

	;ebx = id * ebx, no of
	;mov eax, id
	;imul ebx
	;jo _ERR
	;mov ebx, eax

	;ecx = x1 * y2
	mov eax, x1
	imul y2
	;jo _ERR
	mov ecx, eax

	;eax = x2 * y1
	mov eax, x2
	imul y1
	;jo _ERR

	;eax = eax - ecx
	sub eax, ecx

	;b1 = abd * eax / ebx
	mov edx, abd
	imul edx
	idiv ebx
	mov b1, eax

	;a_new = ...
	mov eax, esi
	mov ebx, a
	mov edx, k
	mov ecx, 10
	sub ecx, edx
	call weight
	;jo _ERR
	;mov a_new, eax
	mov a, eax

	mov eax, edi
	mov ebx, b
	mov edx, k
	mov ecx, 10
	sub ecx, edx
	call weight
	;jo _ERR
	;mov b_new, eax
	mov b, eax

	;mov a, a_new
	;mov b, b_new

	;k-- if --k
	mov eax, k
	dec eax
	jz _MIN
	mov k, eax
_MIN:

	;debug
	mov edx, offset msg_a 
	call WriteString
	
	mov eax, a
	call WriteInt

	mov edx, offset msg_b
	call WriteString
	
	mov eax, b
	call WriteInt
	
	mov edx, offset msg_k
	call WriteString

	mov eax, k
	call WriteInt

	call CrLf

_END:

	mov eax, [ebp + 4]
	mov [ebp + 20], eax

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax

	;add esp, 16
	
	pop ebp
	add esp, 16
	ret

_ERR:
	;handle any error
	jmp _END

learn endp

query proc;eax: x * id
	push edx
	push ebx

	;eax = ((a * abd) * eax + (b * abd)) / abd
	imul a
	add eax, b
	mov ebx, b
	sar ebx, 31
	adc edx, ebx
	mov ebx, abd
	idiv ebx

	pop ebx
	pop edx

	ret
query endp

end
