.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc


.data
    windowCaption db "System programming, laboratory 8, Ivan Kuts, variant 12", 0

    testTemplate db "This is the test #%d", 0
    formula db "Formula: (sqrt(25/c) - d + 2) / (b + a - 1)", 0
    currentValuesTemplate db "a = %s, b = %s, c = %s, d = %s", 0
    numDenomTemplate db "num = %s, denom = %s", 0
    expressionTemplate db "The expression is: (sqrt(25/%s) - %s + 2) / (%s + %s - 1)", 0
    finalResultsTemplate db "Final result: %s", 0
    
    DenominatorZeroErrorMessage db "Error: the denominator is equal to zero!", 0
    NegativeSqrtErrorMessage db "Error: the value under square root is negative!", 0

    finalFormTemplate db "%s", 10 ,13, "%s", 10, 13, "%s", 10, 13, "%s", 10, 13, "%s", 0
    errorFormTemplate db "%s", 10, 13, "%s", 10, 13, "%s", 10, 13, "%s", 0
    errorMessageTemplate db "%s", 0

    zero dq 0.0
    one dq 1.0
    two dq 2.0
    twentyFive dq 25.0

.data?
    numDenomBuffer db 64 dup (?)
    testBuffer db 64 dup (?)
    currentValuesBuffer db 64 dup (?)
    expressionBuffer db 128 dup (?)
    finalResultBuffer db 64 dup (?)
    finalBuffer db 256 dup (?)

    sqrtResult dt ?
    numerator dt ?
    denominator dt ?
    finalResult dq ?
    finalResultString db 16 dup (?)

    currentAString db 16 dup (?)
    currentBString db 16 dup (?)
    currentCString db 16 dup (?)
    currentDString db 16 dup (?)

.code

ivanKutsEntryPoint proc hInstDLL:DWORD, reason:DWORD
    mov eax, 1
    ret
ivanKutsEntryPoint endp

ivanKutsCalculate proc currentA: ptr qword, currentB: ptr qword, currentC: ptr qword, currentD: ptr qword
    finit
    ; calculating denominator: b + a - 1
    mov ebx, currentB
    fld qword ptr [ebx]
    mov edx, currentA
    fld qword ptr [edx]
    fadd
    fld one
    fsub

    ; checking denominator for zero: 
    fcom zero
    fstsw ax
    sahf
    je denominatorZero
        
    ; saving denominator to 10-bytes buffer
    fstp denominator

    ; calculating sqrt(25/c)
    fld twentyFive
    mov ecx, currentC
    fld qword ptr [ecx]
    fdiv
    fsqrt
    
    ftst
    fnstsw ax
    sahf

    test ah, 01000000b
    jnz negativeSqrtValue    

    ; saving sqrt calculation result to 10-bytes buffer
    fstp sqrtResult

    ; calculating numerator: (sqrt(25/c) - d + 2)
    fld sqrtResult
    mov edx, currentD
    fld qword ptr [edx]
    fsub
    fld two
    fadd
    
    ; saving numerator to 10-bytes buffer
    fstp numerator

    ; dividing numerator by denominator
    fld numerator
    fld denominator
    fdiv

    ; saving the final result to 8-bytes variable
    fstp finalResult

resultWindow:
    mov ebx, currentA            
    invoke FloatToStr, qword ptr [ebx], offset currentAString
    mov ebx, currentB
    invoke FloatToStr, qword ptr [ebx], offset currentBString
    mov ebx, currentC
    invoke FloatToStr, qword ptr [ebx], offset currentCString
    mov ebx, currentD
    invoke FloatToStr, qword ptr [ebx], offset currentDString
    invoke FloatToStr, finalResult, offset finalResultString
    
    ; making the window text
    invoke wsprintf, offset testBuffer, offset testTemplate, esi
    invoke wsprintf, offset currentValuesBuffer, offset currentValuesTemplate, offset currentAString, offset currentBString, offset currentCString, offset currentDString
    invoke wsprintf, offset expressionBuffer, offset expressionTemplate, offset currentCString, offset currentDString, offset currentBString, offset currentAString
    invoke wsprintf, offset finalResultBuffer, offset finalResultsTemplate, offset finalResultString
    invoke wsprintf, offset finalBuffer, offset finalFormTemplate, offset testBuffer, offset formula, offset currentValuesBuffer, offset expressionBuffer, offset finalResultBuffer

    invoke MessageBox, 0, offset finalBuffer, offset windowCaption, 0

    jmp returnToMainProgram

negativeSqrtValue:
    mov ebx, currentA            
    invoke FloatToStr, qword ptr [ebx], offset currentAString
    mov ebx, currentB
    invoke FloatToStr, qword ptr [ebx], offset currentBString
    mov ebx, currentC
    invoke FloatToStr, qword ptr [ebx], offset currentCString
    mov ebx, currentD
    invoke FloatToStr, qword ptr [ebx], offset currentDString
    
    invoke wsprintf, offset testBuffer, offset testTemplate, esi
    invoke wsprintf, offset currentValuesBuffer, offset currentValuesTemplate, offset currentAString, offset currentBString, offset currentCString, offset currentDString
    invoke wsprintf, offset expressionBuffer, offset expressionTemplate, offset currentCString, offset currentDString, offset currentBString, offset currentAString
    invoke wsprintf, offset finalResultBuffer, offset errorMessageTemplate, offset NegativeSqrtErrorMessage
    invoke wsprintf, offset finalBuffer, offset errorFormTemplate, offset testBuffer, offset currentValuesBuffer, offset expressionBuffer, offset finalResultBuffer

    invoke MessageBox, 0, offset finalBuffer, offset windowCaption, 0
    jmp returnToMainProgram

denominatorZero:
    mov ebx, currentA            
    invoke FloatToStr, qword ptr [ebx], offset currentAString
    mov ebx, currentB
    invoke FloatToStr, qword ptr [ebx], offset currentBString
    mov ebx, currentC
    invoke FloatToStr, qword ptr [ebx], offset currentCString
    mov ebx, currentD
    invoke FloatToStr, qword ptr [ebx], offset currentDString
    
    invoke wsprintf, offset testBuffer, offset testTemplate, esi
    invoke wsprintf, offset currentValuesBuffer, offset currentValuesTemplate, offset currentAString, offset currentBString, offset currentCString, offset currentDString
    invoke wsprintf, offset expressionBuffer, offset expressionTemplate, offset currentCString, offset currentDString, offset currentBString, offset currentAString
    invoke wsprintf, offset finalResultBuffer, offset errorMessageTemplate, offset DenominatorZeroErrorMessage
    invoke wsprintf, offset finalBuffer, offset errorFormTemplate, offset testBuffer, offset currentValuesBuffer, offset expressionBuffer, offset finalResultBuffer

    invoke MessageBox, 0, offset finalBuffer, offset windowCaption, 0
    jmp returnToMainProgram

returnToMainProgram:
    ret 20

ivanKutsCalculate endp

end ivanKutsEntryPoint