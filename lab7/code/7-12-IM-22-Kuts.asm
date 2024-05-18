.386
.model flat, stdcall
option casemap :none

public AArray, BArray, one
extern calcDenominator:PROTO

include \masm32\include\masm32rt.inc

.data
    ; arrays
    AArray dq 4.1, -13.9, 0.5, 1.3, 1.3, 1.3
    BArray dq 5.2, 1.2, 0.5, -12.3, 10.3, 10.3
    CArray dq 3.3, 4.3, -40.5, 2.1, 2.1, -2.1
    DArray dq 0.5, 100.2, 19.2, 1.4, 7.45, 7.45

    ; window caption
    windowCaption db "System programming, laboratory 7, Ivan Kuts, variant 12", 0

    ; window text template
    testTemplate db "This is the test #%d", 0
    formula db "Formula: (sqrt(25/c) - d + 2) / (b + a - 1)", 0
    currentValuesTemplate db "a = %s, b = %s, c = %s, d = %s", 0
	numDenomTemplate db "num = %s, denom = %s", 0
    expressionTemplate db "The expression is: (sqrt(25/%s) - %s + 2) / (%s + %s - 1)", 0
	finalResultsTemplate db "Final result: %s", 0
    
	DenomanitorZeroErrorMessage db "Error: the denominator is equal to zero!", 0
	NegativeSqrtErrorMessage db "Error: the value under square root is negative!", 0

    finalFormTemplate db "%s", 10 ,13,
                        "%s", 10, 13,
                        "%s", 10, 13,
						"%s", 10, 13,
                        "%s", 0

    errorFormTemplate db "%s", 10, 13,
                        "%s", 10, 13,
                        "%s", 10, 13,
                        "%s", 0

    errorMessageTemplate db "%s", 0

    zero dq 0.0
    one dq 1.0
    two dq 2.0
    twentyFive dq 25.0

.data?
    ; buffers
	numDenomBuffer db 64 dup (?)
    testBuffer db 64 dup (?)
    currentValuesBuffer db 64 dup (?)
    expressionBuffer db 128 dup (?)
    finalResultBuffer db 64 dup (?)
    finalBuffer db 256 dup (?)

	firstTerm dt ?
	secondTerm dt ?
	numerator dt ?
    denominator dt ?
    finalResult dq ?
	finalResultString db 16 dup (?)
	
    currentAString db 16 dup (?)
    currentBString db 16 dup (?)
    currentCString db 16 dup (?)
    currentDString db 16 dup (?)
	
.code


calculateFirstTerm proc
	fld qword ptr [ebx]
	fdiv qword ptr [eax + edi * 8]
	fsqrt
		
	ftst
	fnstsw ax
	sahf

	test ah, 01000000b
	jnz negativeSqrtValue
	ret
calculateFirstTerm endp

; d + 2
calculateSecondTerm proc
	push ebp ; stack state 7
	mov ebp, esp
    
	mov eax, [ebp + 12] ; loading DArray
	mov ebx, [ebp + 8]
	fld qword ptr [eax + edi * 8] ;load current DArray item onto stack
	;fstp finalResult
	fld qword ptr [ebx]
	fadd 

    pop ebp ; stack state 8
    ret 8 ; stack state 9
calculateSecondTerm endp




lab6:

    mov edi, 0 ; counter for indexes
    mov esi, 1 ; counter for example numbers
	mov ebx, offset twentyFive
	
    iterateThroughArrays:
        cmp edi, 6
        je exitLoop
        finit

		call calcDenominator
		

        ; checking denominator for zero: 
        fcom zero
        fstsw ax
        sahf
        je denominatorZero
	
		;save correct denom
		fstp denominator


		mov eax, offset CArray
		call calculateFirstTerm
        fstp firstTerm
		



		push offset DArray
		push offset two
		call calculateSecondTerm
		fstp secondTerm
		
        ; calculating numerator: (sqrt(25/c) - d + 2)
        ;fld firstTerm
        ;fld DArray[edi * 8]
        ;fsub
        ;fld two
        ;fadd
		fld firstTerm
        fld secondTerm
		fsub
        ; saving numerator to 10-bytes buffer
        fstp numerator

		
        ; dividing numerator by denominator
        fld numerator
        fld denominator
		;fld AArray[edi * 8]
        fdiv

        ; saving the final result to 8-bytes variable
        fstp finalResult

    resultWindow:        	
		
        invoke FloatToStr, AArray[edi * 8], offset currentAString
        invoke FloatToStr, BArray[edi * 8], offset currentBString
        invoke FloatToStr, CArray[edi * 8], offset currentCString
        invoke FloatToStr, DArray[edi * 8], offset currentDString
        invoke FloatToStr, finalResult, offset finalResultString
        
        ; making the window text
        invoke wsprintf, offset testBuffer, 
            offset testTemplate, esi
        invoke wsprintf, offset currentValuesBuffer, 
            offset currentValuesTemplate, 
            offset currentAString, offset currentBString, 
            offset currentCString, offset currentDString
        invoke wsprintf, offset expressionBuffer, 
            offset expressionTemplate, 
            offset currentCString, offset currentDString, 
            offset currentBString, offset currentAString
        invoke wsprintf, offset finalResultBuffer, 
            offset finalResultsTemplate, offset finalResultString
        
        invoke wsprintf, offset finalBuffer, offset finalFormTemplate, 
            offset testBuffer, offset formula, 
            offset currentValuesBuffer, offset expressionBuffer,
			offset finalResultBuffer 

        invoke MessageBox, 0, offset finalBuffer, offset windowCaption, 0

        inc edi
        inc esi
        jmp iterateThroughArrays
			
	negativeSqrtValue:
	
        invoke FloatToStr, AArray[edi * 8], offset currentAString
        invoke FloatToStr, BArray[edi * 8], offset currentBString
        invoke FloatToStr, CArray[edi * 8], offset currentCString
        invoke FloatToStr, DArray[edi * 8], offset currentDString
        
        invoke wsprintf, offset testBuffer, 
            offset testTemplate, esi
			
        invoke wsprintf, offset currentValuesBuffer, 
            offset currentValuesTemplate, 
            offset currentAString, offset currentBString, 
            offset currentCString, offset currentDString
			
        invoke wsprintf, offset expressionBuffer, 
            offset expressionTemplate, 
            offset currentCString, offset currentDString, 
            offset currentBString, offset currentAString
			
        invoke wsprintf, offset finalResultBuffer, 
            offset errorMessageTemplate, offset NegativeSqrtErrorMessage

        invoke wsprintf, offset finalBuffer, offset errorFormTemplate,
            offset testBuffer,
            offset currentValuesBuffer,
            offset expressionBuffer,
            offset finalResultBuffer

        invoke MessageBox, 0, offset finalBuffer, offset windowCaption, 0
		
        inc edi
        inc esi
        jmp iterateThroughArrays


    denominatorZero:
        ; converting float numbers to strings for them to be shown correctly
        invoke FloatToStr, AArray[edi * 8], offset currentAString
        invoke FloatToStr, BArray[edi * 8], offset currentBString
        invoke FloatToStr, CArray[edi * 8], offset currentCString
        invoke FloatToStr, DArray[edi * 8], offset currentDString
        
        invoke wsprintf, offset testBuffer, 
            offset testTemplate, esi
        invoke wsprintf, offset currentValuesBuffer, 
            offset currentValuesTemplate, 
            offset currentAString, offset currentBString, 
            offset currentCString, offset currentDString
        invoke wsprintf, offset expressionBuffer, 
            offset expressionTemplate, 
            offset currentCString, offset currentDString, 
            offset currentBString, offset currentAString
        invoke wsprintf, offset finalResultBuffer, 
            offset errorMessageTemplate, offset DenomanitorZeroErrorMessage

        invoke wsprintf, offset finalBuffer, offset errorFormTemplate,
            offset testBuffer,
            offset currentValuesBuffer,
            offset expressionBuffer,
            offset finalResultBuffer

        invoke MessageBox, 0, offset finalBuffer, offset windowCaption, 0
        inc edi
        inc esi
        jmp iterateThroughArrays


    exitLoop:
        invoke ExitProcess, 0

end lab6
