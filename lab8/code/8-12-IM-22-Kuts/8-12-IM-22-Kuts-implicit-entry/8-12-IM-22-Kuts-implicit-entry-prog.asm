.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc ; LoadLibrary, GetProcAddress, FreeLibrary, ExitProcess

.data?
lib dd ?
libAddr dd ?

.data
    implicitLib db "8-12-IM-22-Kuts-implicit-entry-proc.dll", 0
    procName db "ivanKutsCalculate", 0

    ; arrays
    AArray dq 4.1, -13.9, 0.5, 1.3, 1.3, 1.3
    BArray dq 5.2, 1.2, 0.5, -12.3, 10.3, 10.3
    CArray dq 3.3, 4.3, -40.5, 2.1, 2.1, -2.1
    DArray dq 0.5, 100.2, 19.2, 1.4, 7.45, 7.45

.code
lab8:
    mov edi, 0 ; counter for indexes
    mov esi, 1 ; counter for example numbers

iterateThroughArrays:
    invoke LoadLibrary, addr implicitLib
    mov lib, eax 
    invoke GetProcAddress, lib, addr procName
    mov libAddr, eax

    lea edx, DArray[edi * 8]
    push edx
    lea ecx, CArray[edi * 8]
    push ecx
    lea ebx, BArray[edi * 8]
    push ebx
    lea eax, AArray[edi * 8]
    push eax

    call [libAddr]

    cmp edi, 5
    je exitLoop

    inc edi
    inc esi
	
	invoke FreeLibrary, lib
	
    jmp iterateThroughArrays

exitLoop:
    invoke ExitProcess, 0

end lab8
