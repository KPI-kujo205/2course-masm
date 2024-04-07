callDialogWindow macro dialogMsg, dialogTitle
    ;; This is a hidden comment
    ; This is not a hidden comment  

    invoke MessageBox, 0, addr dialogTitle, addr dialogMsg, 0
endm

encryptPassword macro
    ;; This is a hidden comment
    ; This is not a hidden comment  
    
    lea esi, [passwordInputBuffer] ; Load the address of passwordInputBuffer into esi
    lea edi, [passwordSeed]         ; Load the address of passwordSeed into edi
    lea ebx, [passwordHash]         ; Load the address of passwordHash into ebx

    xor_loop:
        mov al, [esi]                ; Load a character from passwordInputBuffer into al
        cmp al, 0                    ; Check if we've reached the end of the string
        je xor_loop_end              ; If al is null, end the loop

        mov bl, [edi]                ; Load a character from passwordSeed into bl
        cmp bl, 0                    ; Check if we've reached the end of the seed string
        je xor_loop_end              ; If bl is null, end the loop

        xor al, bl                   ; Perform XOR operation on al and bl
        mov [esi], al                ; Store the result back into passwordInputBuffer
        inc esi                      ; Move to the next character in passwordInputBuffer
        inc edi                      ; Move to the next character in passwordSeed
    jmp xor_loop                    ; Repeat the XOR operation

xor_loop_end:
endm

comparePassword macro
    ;; This is a hidden comment
    ; This is not a hidden comment

    local compare_loop
    lea esi, [passwordInputBuffer] ; Reset esi to the start of passwordInputBuffer
    lea edi, [passwordHash]         ; Reset edi to the start of passwordHash

    compare_loop:
        mov al, [esi]                ; Load a character from passwordInputBuffer into al
        mov bl, [edi]                ; Load a character from passwordHash into bl
        cmp al, bl                   ; Compare the characters
        jne displayErrorMessage      ; Jump if they are not equal
        cmp al, 0                    ; Check if we've reached the end of the string
        je displaySuccessMessage     ; If al is null, we've reached the end of both strings
        inc esi                      ; Move to the next character in passwordInputBuffer
        inc edi                      ; Move to the next character in passwordHash
    jmp compare_loop                ; Repeat the comparison 
endm
