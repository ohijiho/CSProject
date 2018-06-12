include Irvine32.inc

ReadLine proto
WriteLine proto

.data
     infilename BYTE "input.txt", 0
     outfilename BYTE "output.txt",0
     infileHandle DWORD ?
     outfileHandle DWORD ?
     errMsg BYTE "Cannot open file", 0dh, 0ah, 0

.code
main proc
     INVOKE CreateFile, ADDR infilename, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
     mov infileHandle, eax
     .IF eax == INVALID_HANDLE_VALUE
          mov edx, OFFSET errMsg; display error message
          call WriteString
          jmp QuitNow
     .ENDIF

     INVOKE createFile, ADDR outfilename, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
     mov outfileHandle, eax

     mov eax, infileHandle
     call ReadLine
     mov eax, infileHandle
     call ReadLine

     mov eax,25
     mov ebx,outfileHandle
     call WriteLine

     mov eax, infileHandle
     INVOKE CloseHandle, eax
     mov eax, outfileHandle
     INVOKE CloseHandle, eax



QuitNow:
invoke ExitProcess, 0
main endp
end main
