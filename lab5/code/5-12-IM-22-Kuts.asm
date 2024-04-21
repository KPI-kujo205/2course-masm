.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32rt.inc

.data 
  labTitle db "System programming, lab 5, Ivan Kuts, Variant 12", 0
  
  withResultsMessageTemplate db "Formula: (41 - d / 4 - 1 )/( c / b + a * d )", 10, 10,
                                "Initial result = (41 - %i / 4 - 1 )/( %i / %i + %i * %i ) = %i", 10,
                                "Modified result = %i", 10,
                                "where: a = %i, b = %i, c = %i, d = %i", 10,
                                "denominator = %i, numerator = %i", 10, 10, 0
                      
  errorMessageTemplate db "Formula: (41 - d / 4 - 1 )/( c / b + a * d )", 10, 10,
                          "ICORRECT DENOMINATOR PARAMETERS", 10,
                          "( %i / %i + %i * %i ) == 0", 10,
                          "DIVISION BY 0 IS NOT ALLOWED", 10,  
                          "GO AND LERAN MATH", 10, 10, 0
                
  arrayA dd 2, -2, -2, -2, -2
  arrayB dd 3, 2, 2, 2, 2
  arrayC dd 9, 96, 676, 668, 8
  arrayD dd 8, 32, 168, 168, 2

.data?
  finalValue dd 5 dup(?)
  numerator dd 1 dup(?)
  denominator dd 1 dup(?)
  labMessage db 512 dup(?)

.code
lab5:
  mov esi, 0
  .while esi < 5
  
    ;; denominator
    mov eax, dword ptr [arrayC + esi*4]  ;; Load c into eax
    mov ebx, dword ptr [arrayB + esi*4]  ;; Load b into ebx
    xor edx, edx                         ;; Clear edx for division
    div ebx                              ;; c / b => Result in eax, remainder in edx
    mov ecx, eax                         ;; Store c/b in ecx temporarily

    mov eax, dword ptr [arrayA + esi*4]  ;; Load a into eax
    mov edx, dword ptr [arrayD + esi*4]  ;; Load d into edx
    imul eax, edx                        ;; a * d => Result in eax

    add eax, ecx                         ;; eax = (c/b + a*d)
    mov dword ptr [denominator], eax     ;; Store the result in 'denominator'
    
    .if denominator == 0
      invoke wsprintf, addr labMessage, addr errorMessageTemplate, 
        arrayC[esi * 4], arrayB[esi * 4], arrayA[esi * 4], arrayD[esi * 4]
        invoke MessageBox, 0, offset labMessage, offset labTitle, 0
    .else 


     ;; numerator calculation for 40 - d / 4
      mov ecx, 4
      mov eax, dword ptr [arrayD + esi * 4]  ;; Load d into eax
      cdq                                    ;; Sign extend eax into edx:eax for division
      idiv ecx                               ;; Divide edx:eax by ecx, result in eax
      mov ecx, 40
      sub ecx, eax                           ;; Subtract quotient from 40
      mov dword ptr [numerator], ecx         ;; Store the result in numerator

      mov eax, numerator                     ;; Loading numerator into eax register 
      mov ecx, denominator                   ;; Loading denominator into ecx register 
      
      cdq
      idiv ecx ;;
      mov finalValue, eax                    ;; Storing result in a variable

      
      test eax, 1                            ;; check if result is odd or even
      jnz oddResult
      jz evenResult

      evenResult:
        mov ecx, 2
        cdq
        idiv ecx ;; finalValue / 2
        jmp message

      oddResult:
        imul eax, 5 ;; finalValue * 5
        jmp message

      message: 
        invoke wsprintf, addr labMessage, addr withResultsMessageTemplate, 
          arrayD[esi * 4], arrayC[esi * 4], arrayB[esi * 4], arrayA[esi * 4], arrayD[esi * 4],
          finalValue, eax,
          arrayA[esi * 4], arrayB[esi * 4], arrayC[esi * 4], arrayD[esi * 4],
          denominator, numerator

        invoke MessageBox, 0, offset labMessage, offset labTitle, 0
    .endif

    mov labMessage, 0h
    inc esi
  .endw

end lab5