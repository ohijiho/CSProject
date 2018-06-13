include Irvine32.inc

test1 proto
test2 proto

.code
main proc

	call test2
	invoke ExitProcess, 0

main endp

end main
