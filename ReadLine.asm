include Irvine32.inc

; ������ ���پ� �д´�
;input-eax:filehandle�� ���� ������
;output- eax-����µ�
;        ebx-��ǥ�µ�(�ڵ������ ��� -1)
;�߿�:�̸� ���ο��� createFile�� ȣ���� filehandle���� ������ �־���Ѵ�
;


.data
     buffer BYTE 7 DUP(0)

     fileHandle DWORD ?
     byteCount DWORD ?
     curTemp DWORD ?

.code
ReadLine proc USES edx esi eax

     mov fileHandle,eax
     mov edx, offset buffer
     mov ecx,0

start:
     INVOKE ReadFile,
          fileHandle,
          edx,
          1,
          addr byteCount,
          0

     mov ebx, byteCount
     mov edx, OFFSET buffer
     mov buffer[ebx], 0
     .IF buffer=='m'
          jmp manual
     .ELSEIF buffer=='a'
          jmp automatic
     .ELSEIF buffer==13||buffer==10||buffer==' '
          jmp start
     .ELSE
          jmp close
     .ENDIF     

manual:

     INVOKE ReadFile,
          fileHandle,
          edx,
          5,
          addr byteCount,
          0


     mov esi, offset buffer
     mov edx, OFFSET buffer
     call atoi
     mov curTemp,eax



     INVOKE ReadFile,
          fileHandle,
          edx,
          3,
          addr byteCount,
          0

     mov ebx, byteCount
     mov buffer[ebx], 0
     mov edx, OFFSET buffer
     mov esi, offset buffer
     call atoi
     mov ecx, 10
     mul ecx
     mov ecx,eax
     jmp close


automatic:

     INVOKE ReadFile,
          fileHandle,
          edx,
          5,
          addr byteCount,
          0

     mov edx, OFFSET buffer

     mov esi, offset buffer
     call atoi

     mov curTemp,eax
     mov ecx,-1

close:
     mov ebx,curTemp

 QuitNow:
     ret
ReadLine endp


atoi proc
     push ebx
     push ecx
     push esi

     mov eax,0
nxchr:
     mov ebx,0
     mov bl, [esi]
     inc esi

     cmp bl,' '
     je nxchr
     cmp bl,'.'
     je nxchr
     cmp bl,'0'
     jb inval
     cmp bl,'9'
     ja inval

     sub bl,'0'
     mov cl,10
     mul cl
     add eax,ebx
     jmp nxchr

inval:
     pop esi
     pop ecx
     pop ebx
     ret
atoi endp
end