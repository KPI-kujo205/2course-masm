.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc ; LoadLibrary, GetProcAddress, FreeLibrary, ExitProcess

includelib 8-12-IM-22-Kuts-explicit-entry-proc.lib      ; ivanKutsCalculate
ivanKutsCalculate proto :ptr qword, :ptr qword, :ptr qword, :ptr qword
                         
.data

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

    invoke ivanKutsCalculate, addr AArray[edi * 8], addr BArray[edi * 8], addr CArray[edi * 8], addr DArray[edi * 8]

    cmp edi, 5
    je exitLoop

    inc edi
    inc esi
    jmp iterateThroughArrays

exitLoop:
    invoke ExitProcess, 0

end lab8
