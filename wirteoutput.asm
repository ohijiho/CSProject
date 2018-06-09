include Irvine32.inc

;eax에 있는 값을 fileHandle에 쓰는 파일
;input-eax:우리가 쓰려는 값
;     -ebx:filehandle의 값
;output:없어요
;중요:메인 바디에서 미리 createfile을 호출해 거기있는 filehandle을 ebx에 넣어야함
;
.data
darray dword 10,1,0
buffer byte 4 dup(?)
fileHandle DWORD ?
byteWriten DWORD ?
temp DWORD ?
.code
WriteLine proc USES eax ebx esi
     mov fileHandle, ebx
     mov esi, offset buffer
     mov ebx, offset darray

next:
     cdq
     div DWORD PTR[ebx]
     add eax,'0'
     call writeint
     mov byte PTR [esi],al
     mov eax,edx
     add ebx,4
     add esi,1
     cmp DWORD PTR[ebx],0
     jne next

     mov byte PTR[esi],0dh
     inc esi
     mov byte PTR[esi],0ah
     
     mov esi, offset buffer
     INVOKE WriteFile,
          fileHandle,
          esi,
          4,
          ADDR byteWriten,
          0
ret
WriteLine endp
end