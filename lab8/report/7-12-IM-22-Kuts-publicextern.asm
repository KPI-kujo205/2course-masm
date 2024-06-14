.386
.model flat, stdcall
option casemap :none

public calcDenominator
extern AArray:qword, BArray:qword, one:qword

; formula (b + a - 1)

.code
    calcDenominator proc
        ; calculating denominator: b - a - 1
        fld BArray[edi * 8]
        fadd AArray[edi * 8]
        fsub one
        ret ; stack state 2
    calcDenominator endp
end