OPTION DOTNAME
	
option casemap:none
include \masm64\include\temphls.inc
include \masm64\include\win64.inc
include \masm64\include\kernel32.inc
includelib \masm64\lib\kernel32.lib
include \masm64\include\user32.inc
includelib \masm64\lib\user32.lib
OPTION PROLOGUE:rbpFramePrologue
OPTION EPILOGUE:none

.data
messageBoxTitle         db 'Персональні дані студента',0

messageBoxContent       db "ПІБ: Куц Іван Васильович",13,10
                        db "Дата народження: 29.03.2005",13,10
                        db "Номер залікової книжки: 9017",0

.code
WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &messageBoxContent, &messageBoxTitle, MB_OK
      invoke ExitProcess,NULL
WinMain endp
end
