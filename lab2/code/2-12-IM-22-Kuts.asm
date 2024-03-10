.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc

.data?
    uninitWindowContent     db 1024 dup(?)
    uninitDWordD            db 128 dup(?)
    uninitNegativeDWordD    db 128 dup(?)
    uninitQWordE            db 128 dup(?)
    uninitNegativeQWordE    db 128 dup(?)
    uninitQWordExtF         db 128 dup(?)
    uninitNegativeQWordExtF   db 128 dup(?)

 
.data
    windowContent db "Date of my birthday: %s", 10,
                     "4 last digits of my document: 9017", 10,
                     "Input values:",10,
                     "A = %d, -A = %d", 10,
                     "B = %d, -B = %d", 10,
                     "C = %d, -C = %d", 10,
                     "D = %s, -D = %s", 10,
                     "E = %s, -E = %s", 10,
                     "F = %s, -F = %s", 0

    windowTitle db "Laboratory 2, systen programming", 0
  

    birthday db "29.03.2005",0

    
    ;All of the variants of A 
    
    byteA db 29
    negativebyteA db -29

    wordA dw 29
    negativeWordA dw -29

    dWordA dd 29
    negativeDWordA dd -29

    qWordA dq 29
    negativeQWordA dq -29



    ;All of the variants of B 
    
    wordB dw 2903
    negativeWordB dw -2903

    dWordB dd 2903
    negativeDWordB dd -2903

    qWordB dq 2903
    negativeQWordB dq -2903



    ;All of the variants of C

    dWordC dd 29032005
    negativeDWordC dd -29032005

    qWordC dq 29032005
    negativeQWordC dq -29032005



    ;All of the variants of D

    dWordD dd 0.003
    negativeDWordD dd -0.003

    qWordD dq 0.003
    negativeQWordD dq -0.003




    ;All of the variants of E

    qWordE dq 0.322
    negativeQWordE dq -0.322



    ;All of the variants of F
    
    qWordExtF dt 3219.697
    negativeQWordExtF dt -3219.697

    qWordF dq 3219.697
    negativeQWordF dq -3219.697


.code
myLab:
    invoke FloatToStr2, qWordD, addr uninitDWordD
    invoke FloatToStr2, negativeQWordD, addr uninitNegativeDWordD
    invoke FloatToStr2, qWordE, addr uninitQWordE
    invoke FloatToStr2, negativeQWordE, addr uninitNegativeQWordE
    invoke FloatToStr2, qWordF, addr uninitQWordExtF
    invoke FloatToStr2, negativeQWordF, addr uninitNegativeQWordExtF

    invoke wsprintf, 
    addr uninitWindowContent, 
    addr windowContent, 
    addr birthday,
    dWordA, negativeDWordA,
    dWordB, negativeDWordB,
    dWordC, negativeDWordC,
    addr uninitDWordD, addr uninitNegativeDWordD, 
    addr uninitQWordE, addr uninitNegativeQWordE,
    addr uninitQWordExtF, addr uninitNegativeQWordExtF

	invoke MessageBox, 0, addr uninitWindowContent, addr windowTitle, 0
    invoke ExitProcess, 0
end myLab
