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
messageBoxTitle         db '���������� ��� ��������',0

messageBoxContent       db "ϲ�: ��� ���� ����������",13,10
                        db "���� ����������: 29.03.2005",13,10
                        db "����� ������� ������: 9017",0

.code
WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &messageBoxContent, &messageBoxTitle, MB_OK
      invoke ExitProcess,NULL
WinMain endp
end
