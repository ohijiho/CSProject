include Irvine32.inc

test1 proto
main2 proto

.code
main proc

	call main2
	invoke ExitProcess, 0

main endp

end main
