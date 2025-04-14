SStack segment para stack "STACK"
    db 64 dup("S")
SStack ends

SData segment para public "DATA"

    ; ------------------------------------------------

    ; a new line
    DNewLine db 0Dh, 0Ah, '$'

    ; a main prompt
    DNumberPrompt db "Enter an integer <x> (-32768..65468): ", '$'

    ; a result prompt
    DResultPrompt db 0Dh, 0Ah, "The result (<x> + 67): ", '$'

    ; error messages
    DErrorFormatMsg   db 0Dh, 0Ah, "Cannot parse an input as an integer", 0Dh, 0Ah, '$'
    DErrorLengthMsg   db 0Dh, 0Ah, "The input is too long", 0Dh, 0Ah, '$'
    DErrorOverflowMsg db 0Dh, 0Ah, "Occured an overflow error during parsing", 0Dh, 0Ah, '$'
    DErrorRangeMsg    db 0Dh, 0Ah, "The number is not in the pre-defined range", 0Dh, 0Ah, '$'

    ; ------------------------------------------------

    ; a number got from the console:
    ;
    ; -32768 = 6 + newline + 9 bytes angry user correction = 16
    ; 65535  = 5 + newline + 9 bytes angry user correction = 15
    ;
    DInputNumber db 16, 'L', 16 dup("I")

    ; ------------------------------------------------

    ; the input number's signness
    DNumberSignness db 1 dup("U")

    ; a raw binary value of the input number
    DNumber dw 1 dup("NN")

    ; the error of parsing
    DParseErrorType db 1 dup("_")

    ; is a number valid
    DIsValid db 1 dup("V")

    ; ------------------------------------------------

    ; is a number valid
    DIsInRange db 1 dup("R")

    ; ------------------------------------------------

    ; a number prepared to be printed to the console
    DOutputNumber db 16 dup("O")

    ; ------------------------------------------------

    ; a continue prompt
    DContPrompt db 0Dh, 0Ah, "To continue (y/N): ", '$'

    ; a continue input
    DContInput db 4, 'L', 4 dup("#")

    ; is continue
    DIsCont db 1 dup("F")

    ; ------------------------------------------------

SData ends

Code_Seg segment para public "CODE"

    ; ------------------------------------------------

    Main proc far
        ; segments init
        assume cs: Code_Seg, ds: SData, ss: SStack

        ; data segment init
        mov ax, SData
        mov ds, ax

        ; an entry point to a main loop
        jmp MainStart

    MainRestart:

        ; print a new line to walkaround a feature
        call PNewLine

    MainStart:

    MainReinput:
        ; get a number
        call PGetInput

        ; parse the inputed number
        call PParse

        ; check if valid
        cmp byte ptr ds:[DIsValid], 'T'
        jne MainInputParseError

        ; check allowed range
        call PIsInputInRange
        cmp byte ptr ds:[DIsInRange], 'T'
        jne MainInputRangeError

        ; it is success
        jmp MainAfterParse

        MainInputParseError:
            cmp byte ptr ds:[DParseErrorType], 'F'
            je MainInputParseErrorFormat

            cmp byte ptr ds:[DParseErrorType], 'L'
            je MainInputParseErrorLength

            cmp byte ptr ds:[DParseErrorType], 'O'
            je MainInputParseErrorOverflow

            MainInputParseErrorFormat:
                call PErrorFormat
                jmp MainReinput
            
            MainInputParseErrorLength:
                call PErrorLength
                jmp MainReinput
            
            MainInputParseErrorOverflow:
                call PErrorOverflow
                jmp MainReinput

        MainInputRangeError:
            call PErrorRange
            jmp MainReinput

    MainAfterParse:
        ; modify a number
        call PCalc

        ; stringify a number
        call PStringify

        ; output a result
        call POutputNumber

        ; ask about a continuation
        call PIsCont

        ; continue if yes
        cmp byte ptr ds:[DIsCont], 'T'
        je MainRestart

        ; exit
        ; syscall exit(0)
        mov ah, 4Ch
        mov al, 0 
        int 21h

    Main endp

    ; ------------------------------------------------

    PCalc proc far
        ; preserve
        push ax

        ; load a number
        mov ax, ds:[DNumber]

        ; unsigned
        cmp byte ptr ds:[DNumberSignness], 'U'
        je PCalcUnsigned

        ; signed
        cmp byte ptr ds:[DNumberSignness], 'S'
        je PCalcSigned

        ; signed
        PCalcSigned:
            ; if the signed negative number is...
            cmp ax, -67
            ; ... low enough
            jl  PCalcSignedPreserve
            ; ... great enough
            jge PCalcSignedSwapSignness

            PCalcSignedPreserve:
                add ax, 67
                jmp PCalcExit

            PCalcSignedSwapSignness:
                add ax, 67
                mov ds:[DNumberSignness], 'U'
                jmp PCalcExit

        ; unsigned
        PCalcUnsigned:
            add ax, 67
            jmp PCalcExit

        ; exit
        PCalcExit:

        ; store a number
        mov ds:[DNumber], ax

        ; ret
        pop ax

        ret
    PCalc endp

    ; ------------------------------------------------

    PGetInput proc far
        ; preserve
        push ax
        push dx

        ; print a prompt
        mov dx, offset DNumberPrompt
        mov ah, 9
        int 21h

        ; get a number
        mov dx, offset DInputNumber
        mov ah, 10
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    PGetInput endp

    ; ------------------------------------------------

    PParse proc far
        ; preserve
        push ax
        push bx
        push cx
        push dx
        push bp
        push si

        ; registers aliases
        ; spec
        LBuffer       equ bp
        LIndex        equ si
        ; ax
        LNumber       equ ax
        ; bx
        LChar         equ bl
        LLength       equ bh
        ; cx
        LSign         equ cl
        ; dx
        LMul10        equ dx
        LExtraL       equ dl
        LExtra        equ dx

        ; initialization
        mov LNumber, 0
        mov LBuffer, offset ds:DInputNumber + 2
        mov LLength, byte ptr ds:[DInputNumber + 1]
        mov LIndex, 0

        ; if first char is...
        cmp byte ptr ds:[LBuffer], '-'
        ; ... minus
        je PParseNeg

        jmp PParsePos

            ; negative
            PParseNeg:
                ; check length...
                cmp byte ptr ds:[DInputNumber + 1], 6
                ; ... if too long

                jle PParseNeg_WA
                jmp PParseErrorLength
                PParseNeg_WA:

                ; check length...
                cmp byte ptr ds:[DInputNumber + 1], 2
                ; ... if too short (no digits)
                jl PParseErrorFormat

                mov LSign, '-'
                inc LBuffer
                dec LLength

                jmp PParseAfterSign

            ; positive
            PParsePos:
                ; check length...
                cmp byte ptr ds:[DInputNumber + 1], 5
                ; ... if too long
                jg PParseErrorLength

                ; check length...
                cmp byte ptr ds:[DInputNumber + 1], 1
                ; ... if too short (no digits)
                jl PParseErrorFormat

                mov LSign, '+'

                jmp PParseAfterSign

            ; SWITCH CASE EXIT
            PParseAfterSign:

        ; WHILE LOOP
            PParseDigitLoop_Cond:
                ; COND

                ; if...
                mov LExtra, 0
                mov LExtraL, LLength
                cmp LIndex, LExtra
                ; ... index < length
                jl PParseDigitLoop_Body

                ; EXIT LOOP
                jmp PParseDigitLoop_Exit

            ; LOOP BODY
            PParseDigitLoop_Body:

                ; read character
                mov LChar, ds:[LBuffer + LIndex]

                ; error if the char is not a digit
                cmp LChar, '0'
                jl PParseErrorFormat
                cmp LChar, '9'
                jg PParseErrorFormat

                ; char to digit
                sub LChar, '0'

                ; multiply by 10 the result
                mov LMul10, 10
                mul LMul10

                jc PParseErrorOverflow

                ; add the digit to the result
                mov LExtra, 0
                mov LExtraL, LChar
                add LNumber, LExtra

                jc PParseErrorOverflow

                ; AFTER ITERATION LOGIC
                inc LIndex

                ; TRY
                jmp PParseDigitLoop_Cond

            ; END WHILE
            PParseDigitLoop_Exit:

        ; check the sign ...
        cmp LSign, '-'
        ; ... if negative
        je PParseNegateNumber_Body

        jmp PParseNegateNumber_Exit

            ; BODY
            PParseNegateNumber_Body:

                ; idk how should i describe this
                cmp LNumber, 32768
                jbe PParseNegateNumber_Body_L

                jmp PParseErrorOverflow

                PParseNegateNumber_Body_L:
                    neg LNumber

                jmp PParseNegateNumber_Exit

            ; IF EXIT
            PParseNegateNumber_Exit:

        ; if the sign is ...
        ; ... plus
        cmp LSign, '-'
        je PParseFinalSigned

        ; if the sign is ...
        cmp LSign, '+'
        ; ... minus
        je PParseFinalUnsigned

            ; signed
            PParseFinalSigned:
                mov ds:[DNumberSignness], 'S'
                jmp PParseBeforeFinalSigness

            ; unsigned:
            PParseFinalUnsigned:
                mov ds:[DNumberSignness], 'U'
                jmp PParseBeforeFinalSigness

            ; SWITCH CASE EXIT
            PParseBeforeFinalSigness:
                jmp PParseSuccess

        ; ---- raise statuses ----
        
        PParseErrorFormat:
            mov byte ptr ds:[DIsValid], 'F'
            mov byte ptr ds:[DParseErrorType], 'F'
            jmp PParseExit
        
        PParseErrorLength:
            mov byte ptr ds:[DIsValid], 'F'
            mov byte ptr ds:[DParseErrorType], 'L'
            jmp PParseExit

        PParseErrorOverflow:
            mov byte ptr ds:[DIsValid], 'F'
            mov byte ptr ds:[DParseErrorType], 'O'
            jmp PParseExit

        PParseSuccess:
            mov ds:[DNumber], LNumber
            mov byte ptr ds:[DIsValid], 'T'
            jmp PParseExit

        ; ---- exit ----

        PParseExit:
            ; ret
            pop si
            pop bp
            pop dx
            pop cx
            pop bx
            pop ax

            ret
    PParse endp

    ; ------------------------------------------------

    PStringify proc far
        ; preserve
        push ax
        push bx
        push cx
        push dx
        push bp
        push si
        push di

        ; spec
        LBuffer      equ bp
        LNumberStart equ si
        LNumberEnd   equ di
        ; ax
        LNumber      equ ax
        ; bx
        LRevA        equ al
        LRevB        equ ah
        ; cx
        LExtraL      equ cl
        LExtra       equ cx
        LDiv10       equ cx
        ; dx
        LRem         equ dx
        LDivFix      equ dx

        ; pointers
        mov LBuffer, offset DOutputNumber
        mov LNumberStart, 0
        mov LNumberEnd, 0

        ; load the number
        mov LNumber, ds:[DNumber]

        ; if the number is...
        cmp LNumber, 0
        ; ... zero
        je PStringify_ZN_Zero

        jmp PStringify_ZN_NotZero

        PStringify_ZN_Zero:
            mov byte ptr ds:[LBuffer + 0], '0'
            mov byte ptr ds:[LBuffer + 1], '$'

            jmp PStringify_ZN_Exit

        PStringify_ZN_NotZero:
            ; check if the signness is signed...
            ; check if the number is negative...
                cmp ds:[DNumberSignness], 'S'

                je PStringify_N_Signed
                jmp PStringify_N_Exit
                PStringify_N_Signed:

                cmp LNumber, 0

                jl PStringify_S_Neg
                jmp PStringify_N_Exit
                ; yes
                PStringify_S_Neg:
                    neg LNumber
                    mov byte ptr ds:[LBuffer + 0], '-'
                    mov LNumberStart, 1

                    jmp PStringify_N_Exit

            ; no
            PStringify_N_Exit:
                mov LNumberEnd, LNumberStart

                ; STRINGIFY IN REVERSE NOTATION

                PStringify_Str_Cond:

                        ; because number is already threated as unsigned and signed comparison can break this code

                        ; if number > 0
                        cmp LNumber, 0
                        ja PStringify_Str_Body

                        jmp PStringify_Str_Exit

                    PStringify_Str_Body:

                        ; divide the number by 10
                        mov LDivFix, 0
                        mov LDiv10, 10
                        div LDiv10

                        ; acquire digit
                        mov LExtra, LRem

                        ; digit to char
                        add LExtraL, '0'

                        ; output
                        mov ds:[LBuffer + LNumberEnd], LExtraL

                        ; increment string indexer
                        inc LNumberEnd

                        jmp PStringify_Str_Cond

                    PStringify_Str_Exit:

                ; add end terminator (works because here LNumberEnd is the index of a new char can be added to the string)
                mov byte ptr ds:[LBuffer + LNumberEnd], '$'

                ; head on end of string
                dec LNumberEnd

                ; REVERSE STRING

                PStringify_Rev_Cond:

                        ; if start < end
                        cmp LNumberStart, LNumberEnd
                        jl PStringify_Rev_Body

                        jmp PStringify_Rev_Exit

                    PStringify_Rev_Body:

                        ; acquire two chars
                        mov LRevA, ds:[LBuffer + LNumberStart]
                        mov LRevB, ds:[LBuffer + LNumberEnd  ]

                        ; store reversedly
                        mov byte ptr ds:[LBuffer + LNumberStart], LRevB
                        mov byte ptr ds:[LBuffer + LNumberEnd  ], LRevA

                        ; make indexers closer
                        inc LNumberStart
                        dec LNumberEnd

                        jmp PStringify_Rev_Cond

                    PStringify_Rev_Exit:

                jmp PStringify_ZN_Exit

        PStringify_ZN_Exit:
            ; jmp PStringifyExit

    PStringifyExit:
        ; ret
        pop di
        pop si
        pop bp
        pop dx
        pop cx
        pop bx
        pop ax

        ret
    PStringify endp

    ; ------------------------------------------------

    PIsInputInRange proc far
        ; preserve
        push ax
        push bx

        ; ax
        LNumber equ ax
        ; bx
        LSN     equ bl

        ; load the integer's value
        mov LNumber, ds:[DNumber]

        ; load the integer's signess
        mov LSN, ds:[DNumberSignness]

        ; default status
        mov byte ptr ds:[DIsInRange], 'F'

        ; SWITCH CASE
        cmp LSN, 'S'
        je PIsInputInRange_S_Signed

        cmp LSN, 'U'
        je PIsInputInRange_S_Unsigned

        jmp PIsInputInRange_S_Exit

            PIsInputInRange_S_Signed:
                cmp LNumber, -32768
                jge PIsInputInRange_S_Signed_If

                jmp PIsInputInRange_S_Signed_Exit

                    PIsInputInRange_S_Signed_If:
                        mov byte ptr ds:[DIsInRange], 'T'

                        jmp PIsInputInRange_S_Signed_Exit

                    PIsInputInRange_S_Signed_Exit:

                jmp PIsInputInRange_S_Exit

            PIsInputInRange_S_Unsigned:
                cmp LNumber, 65468
                jbe PIsInputInRange_S_Unsigned_If

                jmp PIsInputInRange_S_Unsigned_Exit

                    PIsInputInRange_S_Unsigned_If:
                        mov byte ptr ds:[DIsInRange], 'T'

                        jmp PIsInputInRange_S_Unsigned_Exit

                    PIsInputInRange_S_Unsigned_Exit:

                jmp PIsInputInRange_S_Exit

            PIsInputInRange_S_Exit:

        ; ret
        pop bx
        pop ax

        ret
    PIsInputInRange endp

    ; ------------------------------------------------

    POutputNumber proc far
        ; preserve
        push ax
        push dx

        ; print a result prompt
        mov dx, offset DResultPrompt
        mov ah, 9
        int 21h

        ; print a result number
        mov dx, offset DOutputNumber
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    POutputNumber endp

    ; ------------------------------------------------

    PErrorRange proc far
        ; preserve
        push ax
        push dx

        ; print an error
        mov dx, offset DErrorRangeMsg
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    PErrorRange endp

    ; ------------------------------------------------

    PErrorFormat proc far
        ; preserve
        push ax
        push dx

        ; print an error
        mov dx, offset DErrorFormatMsg
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    PErrorFormat endp

    ; ------------------------------------------------

    PErrorLength proc far
        ; preserve
        push ax
        push dx

        ; print an error
        mov dx, offset DErrorLengthMsg
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    PErrorLength endp

    ; ------------------------------------------------

    PErrorOverflow proc far
        ; preserve
        push ax
        push dx

        ; print an error
        mov dx, offset DErrorOverflowMsg
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    PErrorOverflow endp

    ; ------------------------------------------------

    PNewLine proc far
        ; preserve
        push ax
        push dx

        ; print an error
        mov dx, offset DNewLine
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    PNewLine endp

    ; ------------------------------------------------

    PIsCont proc far
        ; preserve
        push ax
        push dx

        ; print a prompt
        mov dx, offset DContPrompt
        mov ah, 9
        int 21h

        ; get an input
        mov dx, offset DContInput
        mov ah, 10
        int 21h

        ; default value
        mov byte ptr ds:[DIsCont], 'F'

        ; compare length
        cmp byte ptr ds:[DContInput + 1], 0
        ; if char
        jne PIsContNotZeroLength
        ; if no char
        jmp PIsContExit

    PIsContNotZeroLength:
        ; get char
        mov al, byte ptr ds:[DContInput + 2]
        ; if small y
        cmp al, 'y'
        je PIsContYes
        ; if big y
        cmp al, 'Y'
        je PIsContYes
        ; otherwise false
        jmp PIsContExit

    PIsContYes:
        mov byte ptr ds:[DIsCont], 'T'

    PIsContExit:
        ; ret
        pop dx
        pop ax

        ret
    PIsCont endp

    ; ------------------------------------------------

Code_Seg ends
end Main
