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

main proc

	push 297
	push 250
	call printm

	push 274
	push 220
	call printm

	push 280
	push 230
	call printm

	mov eax, 261
	call printa

	mov eax, 293
	call printa

	push 262
	push 210
	call printm

	mov eax, 274
	call printa

	invoke WaitMsg

	invoke ExitProcess, 0
main endp

printm proc
	
	push eax
	push ebx
	mov ebx, [esp + 8]
	mov eax, [esp + 12]
	mov [esp + 8], eax
	mov eax, [esp + 16]
	mov [esp + 12], eax
	mov [esp + 16], ebx
	pop ebx
	pop eax

	call manual
	call WriteDec
	call CrLf
	ret
printm endp

printa proc
	call auto
	call WriteDec
	call CrLf
	ret
printa endp

end main
