include Irvine32.inc

;eax�� �ִ� ���� fileHandle�� ���� ����
;input-eax:�츮�� ������ ��
;     -ebx:filehandle�� ��
;output:�����
;�߿�:���� �ٵ𿡼� �̸� createfile�� ȣ���� �ű��ִ� filehandle�� ebx�� �־����
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