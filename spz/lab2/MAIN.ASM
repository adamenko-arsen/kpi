SStack segment para stack "STACK"
    db 64 dup("S")
SStack ends

SData segment para public "DATA"

    ; ------------------------------------------------

    ; a new line
    DNewLine db 0Dh, 0Ah, '$'

    ; a main prompt
    DNumberPrompt db "Enter a number: ", '$'

    ; a result prompt
    DResultPrompt db 0Dh, 0Ah, "The result: ", '$'

    ; an error message
    DErrorMsg db 0Dh, 0Ah, "Have been inputed an invalid message", 0Dh, 0Ah, '$'

    ; ------------------------------------------------

    ; a number got from the console:
    ; TL, UL, buffer
    DInputNumber db 16, 'L', 16 dup("I")

    ; a raw binary value of the input number
    DNumber dw 1 dup("N")

    ; is a number valid
    DIsValid db 1 dup("V")

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
        cmp byte ptr [DIsValid], 'T'
        je MainAfterParse

        ; raise an error and reinput
        call PError
        jmp MainReinput

    MainAfterParse:
        ; modify a number
        call PCalc

        ; stringify a number
        call PStringify

        ; output a result
        call POutputNumber

        ; ask a continuation
        call PIsCont

        ; continue if yes
        cmp byte ptr ds:[DIsCont], 'T'
        je MainRestart

        ; exit
        mov ah, 4Ch ; syscall type
        mov al, 0   ; syscall argument
        int 21h     ; syscall trigger

    Main endp

    ; ------------------------------------------------

    PCalc proc far
        ; preserve
        push ax

        ; load a number
        mov ax, ds:[DNumber]

        ; make calcs
        add ax, 67

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
        LExtraX       equ dx

        ; result number init
        mov LNumber, 0

        ; reader init
        mov LBuffer, offset DInputNumber + 2
        mov LIndex, 0

        ; get length
        mov LLength, ds:[DInputNumber + 1]

        ; error: zero length
        cmp LLength, 0
        je PParseError

        ; default plus sign
        mov LSign, '+'

        ; get sign
        mov LChar, ds:[LBuffer + LIndex]

        ; compare minus sign
        cmp LChar, '-'
        jne PParseNotSign
        ; if negative
        mov LSign, '-'
        inc LIndex
        ; then if error
        cmp LLength, 1 + 5
        jg PParseError
        jmp PParsePos

    PParseNotSign:
        ; if positive
        cmp LLength, 5
        jg PParseError

    PParsePos:

        PParseLoop:
            ; get char
            mov LChar, ds:[LBuffer + LIndex]

            ; error if char is not digit
            cmp LChar, '0'
            jl PParseError
            cmp LChar, '9'
            jg PParseError

            ; char to digit
            sub LChar, '0'

            ; modify result number
            ; mul by 10
            mov LMul10, 10
            imul LMul10

            ; check overflow
            jo PParseError

            ; add next digit
            mov LExtraX, 0
            mov LExtraL, LChar
            add LNumber, LExtraX

            ; check overflow
            jo PParseError

            ; loop
            ; inc indexer
            inc LIndex
            ; compare
            mov LExtraX, 0
            mov LExtraL, LLength
            cmp LIndex, LExtraX
            ; try loop
            jl PParseLoop

        ; compare minus sign
        cmp LSign, '-'
        jne PParseNotModNumMinus

        ; if minus
        neg LNumber
        ; check overflow
        jo PParseError

    PParseNotModNumMinus:
        mov ds:[DNumber], LNumber
        mov DIsValid, 'T'
        jmp PParseExit

    PParseError:
        mov DIsValid, 'F'

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
        LRevA        equ al
        ; cx
        LExtra       equ cx
        LRevB        equ cl
        ; dx
        LRem         equ dx

        ; pointers
        mov LBuffer, offset DOutputNumber
        mov LNumberStart, 0
        mov LNumberEnd, 0

        ; load a number
        mov LNumber, ds:[DNumber]

        ; compare with zero
        cmp LNumber, 0
        ; if zero
        je PStringifyZero
        ; if positive
        jg PStringifyNotNeg
        ; if negative
        neg LNumber
        mov LNumberStart, 1
        mov byte ptr ds:[LBuffer + 0], '-'
        mov LNumberEnd, 1

        jmp PStringifyNotNeg

    PStringifyZero:
        mov byte ptr ds:[LBuffer + 0], '0'
        mov byte ptr ds:[LBuffer + 1], '$'

        jmp PStringifyExit

    PStringifyNotNeg:

        ; divisor
        mov LExtra, 10

        PStringifyLoopDump:
            ; div by 10
            ; idk why
            xor LRem, LRem
            ; div
            div LExtra

            ; digit to char
            add dx, '0'

            ; char to buffer
            mov ds:[LBuffer + LNumberEnd], dl

            ; loop
            inc LNumberEnd
            cmp LNumber, 0
            jne PStringifyLoopDump

        ; add print terminator
        ; LNumberEnd is place for new char
        mov byte ptr ds:[LBuffer + LNumberEnd], '$'

        dec LNumberEnd

        PStringifyLoopRev:
            ; swap digits
            ; load
            mov LRevA, ds:[LBuffer + LNumberStart]
            mov LRevB, ds:[LBuffer + LNumberEnd]
            ; store
            mov ds:[LBuffer + LNumberStart], LRevB 
            mov ds:[LBuffer + LNumberEnd],   LRevA

            ; loop
            inc LNumberStart
            dec LNumberEnd
            cmp LNumberStart, LNumberEnd
            jl PStringifyLoopRev

        jmp PStringifyExit

    PStringifyExit:
        ; ret
        pop di
        pop si
        pop bp
        pop dx
        pop cx
        pop ax

        ret
    PStringify endp

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

    PError proc far
        ; preserve
        push ax
        push dx

        ; print an error
        mov dx, offset DErrorMsg
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    PError endp

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
