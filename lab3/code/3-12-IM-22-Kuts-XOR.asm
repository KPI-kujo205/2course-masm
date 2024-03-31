.386
.model flat, stdcall
option casemap :none

include C:\masm32\include\windows.inc
include C:\masm32\include\dialogs.inc
include C:\masm32\macros\macros.asm

include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\masm32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\masm32.lib

.data?
    passwordInputBuffer db 64 dup (?)

.data
    passwordSeed db "1234qw", 0 
    passwordHash db "pa`yBE", 0
    successPasswordTitle db "Succesfully entered the password", 0
    successPasswordMsg db "Information:", 13, 10, 
        "Full name of a student: Ivan Kuts", 13, 10, 
        "Birthday date: 29.03.2005", 13, 10, 
        "Score book number: 9017", 0

    errorPasswordTitle db "Ooops...", 0
    errorPasswordMsg db "The password is incorrect!", 10, 13, 0
	
   
.code

dialogWindow proc hWindow: dword, message: dword, wParam: dword, lParam: dword	
    .if message == WM_COMMAND
      .if wParam == IDOK
	   	invoke GetDlgItemText, hWindow, 1000, addr passwordInputBuffer, 512
		call passwordCheck
      .endif	   
      .if wParam == IDCANCEL
		invoke ExitProcess, NULL
      .endif
    .elseif message == WM_CLOSE
       invoke ExitProcess, NULL
    .endif
    return 0 
dialogWindow endp

displaySuccessMessage proc
    invoke MessageBox, 0, addr successPasswordMsg, addr successPasswordTitle, 0
    invoke ExitProcess, NULL
    ret
displaySuccessMessage endp

displayErrorMessage proc
    invoke MessageBox, 0, addr errorPasswordMsg, addr errorPasswordTitle, 0
    invoke ExitProcess, NULL
    ret
displayErrorMessage endp


passwordCheck proc
    lea esi, [passwordInputBuffer] ; Load the address of passwordInputBuffer into esi
    lea edi, [passwordSeed]         ; Load the address of passwordSeed into edi
    lea ebx, [passwordHash]         ; Load the address of passwordHash into ebx

    xor_loop:
        mov al, [esi]                ; Load a character from passwordInputBuffer into al
        mov bl, [edi]                ; Load a character from passwordSeed into bl
        xor al, bl                   ; Perform XOR operation on al and bl
        mov [esi], al                ; Store the result back into passwordInputBuffer
        inc esi                      ; Move to the next character in passwordInputBuffer
        inc edi                      ; Move to the next character in passwordSeed
        cmp al, 0                    ; Check if we've reached the end of the string
        je compare_hash              ; If al is null, we've reached the end of both strings
    jmp xor_loop                    ; Repeat the XOR operation

    compare_hash:
        lea esi, [passwordInputBuffer] ; Reset esi to the start of passwordInputBuffer
        lea edi, [passwordHash]         ; Reset edi to the start of passwordHash

        compare_loop:
            mov al, [esi]                ; Load a character from passwordInputBuffer into al
            mov bl, [edi]                ; Load a character from passwordHash into bl
            cmp al, bl                   ; Compare the characters
            jne displayErrorMessage       ; Jump if they are not equal
            cmp al, 0                    ; Check if we've reached the end of the string
            je displaySuccessMessage     ; If al is null, we've reached the end of both strings
            inc esi                      ; Move to the next character in passwordInputBuffer
            inc edi                      ; Move to the next character in passwordHash
        jmp compare_loop                ; Repeat the comparison

passwordCheck endp



thirdLab:
	Dialog "Ivan Kuts, IM-22, system programming", "MS Arial", 14, \            							    
        DS_CENTER, 4, 7, 7, 200, 120, 1024                 							      
		DlgStatic "Enter a password to get my secrets:", SS_LEFT, 20, 20, 60, 10, 100	
		DlgEdit WS_BORDER, 20, 35, 120, 10, 1000		
            DlgButton "Cancel", WS_TABSTOP, 20, 55, 45, 15, IDCANCEL
            DlgButton "Enter", WS_TABSTOP, 135, 55, 45, 15, IDOK  				 	

	CallModalDialog 0, 0, dialogWindow, NULL
end thirdLab


