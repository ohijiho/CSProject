;테스트용 모듈

include Irvine32.inc

learn PROTO
query PROTO

manual PROTO
auto PROTO

printm proto
printa proto

.data

.code

test1 proc

	push 297
	push 250
	call printm

	push 274
	push 220
	call printm

	push 280
	push 230
	call printm

	push 261
	call printa

	push 293
	call printa

	push 262
	push 210
	call printm

	push 274
	call printa

	invoke WaitMsg

	ret
test1 endp

printm proc
	push eax
	push ebx
	mov eax, [esp + 16]
	mov ebx, [esp + 12]

	call manual
	call WriteDec
	call CrLf

	pop ebx
	pop eax
	ret 8
printm endp

printa proc
	push eax
	mov eax, [esp + 8]

	call auto
	call WriteDec
	call CrLf
	
	pop eax
	ret 4
printa endp

end
