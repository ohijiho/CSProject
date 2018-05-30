include Irvine32.inc

learn PROTO
query PROTO

.data

.code

main proc

	;push 297
	;push 250
	;push 274
	;push 220
	;call learn

	;push 274
	;push 220
	;push 280
	;push 230
	;call learn

	mov ebx, 10

	mov eax, 261
	call query
	add eax, 5
	cdq
	div ebx
	call WriteInt
	call CrLf

	mov eax, 293
	call query
	add eax, 5
	cdq
	div ebx
	call WriteInt
	call CrLf

	mov eax, 274
	call query
	add eax, 5
	cdq
	div ebx
	call WriteInt
	call CrLf

	invoke WaitMsg

	invoke ExitProcess, 0
main endp


end main
