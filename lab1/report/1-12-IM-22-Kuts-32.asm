.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    messageBoxContent db "ϲ�: ��� ���� ����������",13,10
                      db "���� ����������: 29.03.2005",13,10
                      db "����� ������� ������: 9017",0
                
    messageBoxTitle db "������� ��� ��������",0
            
.code
start:
    invoke MessageBox, NULL, addr messageBoxContent, addr messageBoxTitle, MB_OK
    invoke ExitProcess, 0
end start