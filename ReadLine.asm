include Irvine32.inc

; 파일을 한줄씩 읽는다
;input-eax:filehandle의 값을 가진다
;output- eax-현재온도
;        ebx-목표온도(자동모드일 경우 -1)
;중요:미리 매인에서 createFile을 호출해 filehandle값을 가지고 있어야한다
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