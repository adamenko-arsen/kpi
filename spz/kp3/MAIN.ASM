S_Stack segment para stack "STACK"
    db 128 dup("S")
S_Stack ends

S_Data segment para public "DATA"

    ; ------------------------------------------------

    ; greeting
    D_Greeting db           "   ____    _            ____     _________ "
               db 0Dh, 0Ah, "  /       / \   |      /                _/ "
               db 0Dh, 0Ah, " |       |   |  |     |               _/   "
               db 0Dh, 0Ah, " |       /---\  |     |      ---    _/     "
               db 0Dh, 0Ah, " |      |     | |     |           _/       "
               db 0Dh, 0Ah, "  \____ |     | '____  \____     /________ "
               db 0Dh, 0Ah, "                                           "
               db 0Dh, 0Ah, "+-----------------------------------------+"
               db 0Dh, 0Ah, "| I P - 3 5   A d a m e n k o   A r s e n |"
               db 0Dh, 0Ah, "+-----------------------------------------+"
               db 0Dh, 0Ah, "               --                          "
               db 0Dh, 0Ah, "              { x = -5, y < 0: 8x^2/y      "
               db 0Dh, 0Ah, "         Z = {  x >  3  y > 0: 6x          "
               db 0Dh, 0Ah, "              { otherwise:     0           "
               db 0Dh, 0Ah, "               --                          "
               db 0Dh, 0Ah, "                                           "
               db 0Dh, 0Ah, "  WARNING: follow the calculator's tips    "
               db 0Dh, 0Ah, "  otherwise you will be punished severely! "
               db 0Dh, 0Ah, "                                           "
               db 0Dh, 0Ah, '$'

    ; a new line
    D_NewLine db 0Dh, 0Ah, '$'

    ; number prompts
    ; D_PromptX db "X (-   64 .. +10922): ", '$'
    ; D_PromptY db "Y (-32768 .. +65535): ", '$'
    D_PromptX db "X: ", '$'
    D_PromptY db "Y: ", '$'

    ; numbers
    D_X dd "Ix"
    D_Y dd "Iy"

    ; P_Input
    P_Input_I_Prompt  dw "Pr"
    P_Input_IW_Ptr    dw "Pt"
    ; P_Input_I_LoBound dd "Lo"
    ; P_Input_I_HiBound dd "Hi"

    P_Input_M_Buffer db 12, ?, 12 dup("-")

    ; P_Parse
    P_Parse_I_Ptr dw "Pt"
    P_Parse_I_Len dw "Le"
    P_Parse_O_Num dd "Nu"
    P_Parse_O_Err db "E"

    P_Parse_M_IsNeg   db "N"

    ; P_Calc
    P_Calc_I_X     dd "Xx"
    P_Calc_I_Y     dd "Yy"
    P_Calc_O_ZInt  dd "Zz"
    P_Calc_O_ZMod  dw "Mm"
    P_Calc_O_ZDiv  dw "Dd"
    P_Calc_O_ZSign db "Si"
    P_Calc_O_Err   db "E"

    ; P_OutZ
    P_OutZ_I_NumInt dd "In"
    P_OutZ_I_NumRem dw "Re"
    P_OutZ_I_NumDiv dw "Di"

    ; P_PrintInt
    P_PrintInt_I_Num dd "Dd"

    P_PrintInt_M_AbsX    dw "P1"
    P_PrintInt_M_Diver   dw "P2"
    P_PrintInt_M_AbsXTmp dw "P3"
    P_PrintInt_M_Putc    db 'C', '$'

    ; P_Cont
    P_Cont_O_Yes db "?"

    P_Cont_M_Buffer db 5, ?, 5 dup("-")

    ; P_FracSimple
    P_FracSimple_I_X dw "F1"
    P_FracSimple_I_Y dw "F2"

    P_FracSimple_O_X dw "F3"
    P_FracSimple_O_Y dw "F4"

    P_FracSimple_M_Big   dw "F5"
    P_FracSimple_M_Small dw "F6"

    ; input number error messages
    D_InputErrFmt   db "The input line is misformatted", 0Dh, 0Ah, 0Dh, 0Ah, '$'
    D_InputErrOF    db "An overflow error has been occured", 0Dh, 0Ah, 0Dh, 0Ah, '$'
    D_InputErrRange db "The range of the number is invalid", 0Dh, 0Ah, 0Dh, 0Ah, '$'

    ; calculation error messages
    D_CalcProgress db "Calulcating the result...", 0Dh, 0Ah, '$'
    D_CalcErrOF    db "An overflow error has been occured", 0Dh, 0Ah, 0Dh, 0Ah, '$'
    D_CalcErrDiv0  db "A division by zero has been occured", 0Dh, 0Ah, 0Dh, 0Ah, '$'

    ; output number prompt part a
    D_OutputZPartA db "Z: ", '$'
    D_OutputZPartB db "[", '$'
    D_OutputZPartC db "/", '$'
    D_OutputZPartD db "]", '$'

    ; continue
    D_PromptCont db "To continue (y/N)? ", '$'
    D_Exiting    db "Exiting...", '$'
    D_Restarting db "Restarting...", 0Dh, 0Ah, 0Dh, 0Ah, '$'

    ; ------------------------------------------------

S_Data ends

S_Code segment para public "CODE"

    ; ------------------------------------------------

    Main proc far
        ; segments init
        assume cs: S_Code, ds: S_Data, ss: S_Stack

        ; data segment init
        mov ax, S_Data
        mov ds, ax

        ; greeting
        mov dx, offset D_Greeting
        mov ah, 9
        int 21h

        Main_Restart:
        Main_CalcErrRetype:

            ; input X
            mov ds:[P_Input_I_Prompt], offset D_PromptX
            mov ds:[P_Input_IW_Ptr], offset D_X
            ; mov word ptr ds:[P_Input_I_LoBound + 0], -64
            ; mov word ptr ds:[P_Input_I_LoBound + 2], 0ffffh
            ; mov word ptr ds:[P_Input_I_HiBound + 0], 10922
            ; mov word ptr ds:[P_Input_I_HiBound + 2], 0000h
            call P_Input

            ; input Y
            mov ds:[P_Input_I_Prompt], offset D_PromptY
            mov ds:[P_Input_IW_Ptr], offset D_Y
            ; mov word ptr ds:[P_Input_I_LoBound + 0], -32768
            ; mov word ptr ds:[P_Input_I_LoBound + 2], 0ffffh
            ; mov word ptr ds:[P_Input_I_HiBound + 0], 65535
            ; mov word ptr ds:[P_Input_I_HiBound + 2], 0000h
            call P_Input

            ; calc in progress
            mov dx, offset D_CalcProgress
            mov ah, 9
            int 21h

            ; --------( calc )--------
            ; X
            mov ax, word ptr ds:[D_X + 0]
            mov bx, word ptr ds:[D_X + 2]
            mov word ptr ds:[P_Calc_I_X + 0], ax
            mov word ptr ds:[P_Calc_I_X + 2], bx
            ; Y
            mov ax, word ptr ds:[D_Y + 0]
            mov bx, word ptr ds:[D_Y + 2]
            mov word ptr ds:[P_Calc_I_Y + 0], ax
            mov word ptr ds:[P_Calc_I_Y + 2], bx
            ; call
            call P_Calc

            ; --------( calc error )--------
            cmp byte ptr ds:[P_Calc_O_Err], 'O'
            je Main_L_CalcErrOF

            cmp byte ptr ds:[P_Calc_O_Err], 'D'
            je Main_L_CalcErrDiv0

            jmp Main_L_NoCalcError

        ; --------------------------------

        Main_L_CalcErrOF:

            mov dx, offset D_CalcErrOF
            mov ah, 9
            int 21h

            jmp Main_CalcErrRetype

        Main_L_CalcErrDiv0:

            mov dx, offset D_CalcErrDiv0
            mov ah, 9
            int 21h

            jmp Main_CalcErrRetype

        ; --------------------------------

        Main_L_NoCalcError:

        ; --------( simplifying fraction )--------
        ; in X
        mov ax, word ptr ds:[P_Calc_O_ZMod]
        mov word ptr ds:[P_FracSimple_I_X], ax
        ; in Y
        mov ax, word ptr ds:[P_Calc_O_ZDiv]
        mov word ptr ds:[P_FracSimple_I_Y], ax
        ; call
        call P_FracSimple
        ; out X
        mov ax, word ptr ds:[P_FracSimple_O_X]
        mov word ptr ds:[P_Calc_O_ZMod], ax
        ; out Y
        mov ax, word ptr ds:[P_FracSimple_O_Y]
        mov word ptr ds:[P_Calc_O_ZDiv], ax

        ; --------( output )--------
        ; int
        mov ax, word ptr ds:[P_Calc_O_ZInt + 0]
        mov bx, word ptr ds:[P_Calc_O_ZInt + 2]
        mov word ptr ds:[P_OutZ_I_NumInt + 0], ax
        mov word ptr ds:[P_OutZ_I_NumInt + 2], bx
        ; rem
        mov ax, word ptr ds:[P_Calc_O_ZMod]
        mov word ptr ds:[P_OutZ_I_NumRem], ax
        ; div
        mov ax, word ptr ds:[P_Calc_O_ZDiv]
        mov word ptr ds:[P_OutZ_I_NumDiv], ax
        ; call
        call P_OutZ

        ; --------( continue )--------
        call P_Cont

        cmp byte ptr ds:[P_Cont_O_Yes], '1'
        jne Main_L_fyhrujeejehgt
            ; restarting
            mov dx, offset D_Restarting
            mov ah, 9
            int 21h

            jmp Main_Restart
        Main_L_fyhrujeejehgt:

        ; exiting
        mov dx, offset D_Exiting
        mov ah, 9
        int 21h

        ; exit(0)
        mov ah, 4Ch
        mov al, 0 
        int 21h
    Main endp

    ; ------------------------------------------------

    P_Cont proc far
        ; preserve
        push ax
        push dx

        ; prompt
        mov dx, offset D_PromptCont
        mov ah, 9
        int 21h

        ; input
        mov dx, offset P_Cont_M_Buffer
        mov ah, 10
        int 21h

        call P_NewLine

        ; if first char is not y or Y then tell to exit
        mov byte ptr ds:[P_Cont_O_Yes], '0'

        mov ax, 0
        mov al, ds:[P_Cont_M_Buffer + 2 + 0]
        cmp al, 'y'
        je P_Cont_L_htfrjdueehn
        cmp al, 'Y'
        je P_Cont_L_hyfrdeujehyv

            jmp P_Cont_L_hnvfjmshcngbtr

            P_Cont_L_htfrjdueehn:
            P_Cont_L_hyfrdeujehyv:

            mov byte ptr ds:[P_Cont_O_Yes], '1'

            P_Cont_L_hnvfjmshcngbtr:

        ; ret
        pop dx
        pop ax

        ret
    P_Cont endp

    ; ------------------------------------------------

    P_Parse proc far
        ; preserve
        push ax
        push bx
        push cx
        push dx

        ; ptr
        mov bx, ds:[P_Parse_I_Ptr]

        ; iter end
        mov di, bx
        add di, ds:[P_Parse_I_Len]

        ; is negative
        mov ds:[P_Parse_M_IsNeg], '0'

        cmp byte ptr ds:[bx], '-'
        jne P_Parse_L_PrePos

            mov ds:[P_Parse_M_IsNeg], '1'
            inc bx

            ; check length
            mov cx, ds:[P_Parse_I_Len]
            cmp cx, 2
            jl P_Parse_L_ErrFmt

            jmp P_Parse_L_PreNeg

        P_Parse_L_PrePos:

            ; check length
            mov cx, ds:[P_Parse_I_Len]
            cmp cx, 1
            jl P_Parse_L_ErrFmt

        P_Parse_L_PreNeg:

        ; zero result number
        mov ax, 0

        ; digit loop
        P_Parse_L_LoopC:

            cmp bx, di
            jge P_Parse_L_LoopE

            ; ================

            ; get char digit
            mov cx, 0
            mov cl, ds:[bx]

            ; check char digit
            cmp cl, '0'
            jl P_Parse_L_ErrFmt
            cmp cl, '9'
            jg P_Parse_L_ErrFmt

            ; char to digit
            sub cl, '0'

            ; mul by 10
            mov dx, 10
            mul dx
            jc P_Parse_L_ErrOF

            ; add digit
            add ax, cx
            jc P_Parse_L_ErrOF

            ; ================

            inc bx

            jmp P_Parse_L_LoopC

        P_Parse_L_LoopE:

        ; write to highest 16 bits
        mov cx, 0000h
        mov word ptr ds:[P_Parse_O_Num + 2], cx

        ; if negative
        cmp ds:[P_Parse_M_IsNeg], '1'
        jne P_Parse_L_PostNotNeg

            cmp ax, 32768
            ja P_Parse_L_ErrOF

            neg ax

            ; if negative then highest 16 bit
            mov cx, 0ffffh
            mov word ptr ds:[P_Parse_O_Num + 2], cx

        P_Parse_L_PostNotNeg:

        ; lowest 16 bit
        mov word ptr ds:[P_Parse_O_Num], ax
        mov byte ptr ds:[P_Parse_O_Err], '+'

        jmp P_Parse_L_Exit

        P_Parse_L_ErrFmt:
            mov byte ptr ds:[P_Parse_O_Err], 'F'
            jmp P_Parse_L_Exit

        P_Parse_L_ErrOF:
            mov byte ptr ds:[P_Parse_O_Err], 'O'
            jmp P_Parse_L_Exit

        P_Parse_L_Exit:

        ; ret
        pop dx
        pop cx
        pop bx
        pop ax

        ret
    P_Parse endp

    ; ------------------------------------------------

    P_Input proc far
        ; preserve
        push ax
        push bx
        push cx
        push dx

        P_Input_L_Retype:
            ; prompt
            mov dx, ds:[P_Input_I_Prompt]
            mov ah, 9
            int 21h

            ; input
            mov dx, offset P_Input_M_Buffer
            mov ah, 10
            int 21h

            call P_NewLine

            ; ----( parse )----
            ; len
            mov ax, 0
            mov al, ds:[P_Input_M_Buffer + 1]
            mov ds:[P_Parse_I_Len], ax
            ; ptr
            mov ax, offset P_Input_M_Buffer + 2
            mov ds:[P_Parse_I_Ptr], ax
            ; call
            call P_Parse

            ; format error
            cmp ds:[P_Parse_O_Err], 'F'
            je P_Input_L_ErrFmt

            ; overflow
            cmp ds:[P_Parse_O_Err], 'O'
            je P_Input_L_ErrOF

            ; ; ----( check range )----
            ; mov ax, word ptr ds:[P_Parse_O_Num + 0]
            ; mov bx, word ptr ds:[P_Parse_O_Num + 2]

            ; ; ========

            ; mov cx, word ptr ds:[P_Input_I_LoBound + 0]
            ; mov dx, word ptr ds:[P_Input_I_LoBound + 2]

            ; cmp bx, dx
            ; jb P_Input_L_SkipLoBound

            ; cmp ax, cx
            ; jl P_Input_L_ErrRange

            ; P_Input_L_SkipLoBound:

            ; mov cx, word ptr ds:[P_Input_I_HiBound + 0]
            ; mov dx, word ptr ds:[P_Input_I_HiBound + 2]

            ; cmp dx, bx
            ; jb P_Input_L_Exit

            ; cmp cx, ax
            ; jb P_Input_L_ErrRange

            ; ; ----------------

            jmp P_Input_L_Exit
        
        P_Input_L_ErrFmt:
            mov dx, offset D_InputErrFmt
            mov ah, 9
            int 21h

            jmp P_Input_L_Retype

        P_Input_L_ErrOF:
            mov dx, offset D_InputErrOF
            mov ah, 9
            int 21h

            jmp P_Input_L_Retype
        
        P_Input_L_ErrRange:
            mov dx, offset D_InputErrRange
            mov ah, 9
            int 21h

            jmp P_Input_L_Retype
        
        P_Input_L_Exit:

        ; return value
        mov bx, ds:[P_Input_IW_Ptr]
        ; low
        mov cx, word ptr ds:[P_Parse_O_num]
        mov ds:[bx], cx
        ; high
        mov cx, word ptr ds:[P_Parse_O_num + 2]
        mov ds:[bx + 2], cx

        ; ret
        pop dx
        pop cx
        pop bx
        pop ax

        ret
    P_Input endp

    ; ------------------------------------------------

    P_Calc proc far
        ; preserve
        push ax
        push bx
        push cx
        push dx

        ; branch picking
        
        R_XL_C equ ax
        R_YL_C equ bx
        R_XH_C equ cx
        R_YH_C equ dx

        mov R_XL_C, word ptr ds:[P_Calc_I_X + 0]
        mov R_XH_C, word ptr ds:[P_Calc_I_X + 2]
        mov R_YL_C, word ptr ds:[P_Calc_I_Y + 0]
        mov R_YH_C, word ptr ds:[P_Calc_I_Y + 2]

        ; ================================

        ; x is neg
        cmp R_XH_C, 0ffffh
        jne P_Calc_L_Br2
        ; x = -5
        cmp R_XL_C, -5
        jne P_Calc_L_Br2
        ; y is neg
        cmp R_YH_C, 0ffffh
        jne P_Calc_L_Br2
        ; y < 0
        cmp R_YL_C, 0
        jge P_Calc_L_Br2

            ; ----------------( x = -5, y < 0: 8x^2/y )----------------

            mov ax, word ptr ds:[P_Calc_I_X + 0]
            mov cx, word ptr ds:[P_Calc_I_X + 2]

            ; ----( X overflow detection and x = |x| )----
            cmp cx, 0000h
            jne P_Calc_L_Br1_PrepXPosWall

                cmp ax, 90

                jbe P_Calc_L_tmp_hfrhejihsd
                    jmp P_Calc_L_ErrOF
                P_Calc_L_tmp_hfrhejihsd:

                jmp P_Calc_L_Br1_PrepXNegWall

            P_Calc_L_Br1_PrepXPosWall:

                cmp ax, -64

                jge P_Calc_L_hfrjwiswfrtt
                    jmp P_Calc_L_ErrOF
                P_Calc_L_hfrjwiswfrtt:

                neg ax

            P_Calc_L_Br1_PrepXNegWall:
            ; ----------------

            mov bx, word ptr ds:[P_Calc_I_Y + 0]
            mov cx, word ptr ds:[P_Calc_I_Y + 2]

            ; x^2: x *= x (unsigned)
            mul ax
            ; 8x^2: x *= 8 (unsigned)
            mov dx, 8
            mul dx

            ; ----( division )----
            ; x is pos, so highest 16 bit is 0000h
            mov dx, 0000h

            cmp cx, 0000h
            jne P_Calc_L_Br1_PrepYPosWall

                div bx

                mov cx, 0000h
                mov word ptr ds:[P_Calc_O_ZInt + 2], cx

                jmp P_Calc_L_Br1_PrepYNegWall

            P_Calc_L_Br1_PrepYPosWall:

                idiv bx

                mov cx, 0ffffh
                mov word ptr ds:[P_Calc_O_ZInt + 2], cx

            P_Calc_L_Br1_PrepYNegWall:

            mov word ptr ds:[P_Calc_O_ZInt + 0], ax
            ; ----------------

            ; rem
            mov ax, dx
            mov ds:[P_Calc_O_ZMod], ax

            ; div
            mov ax, bx
            mov bx, word ptr ds:[P_Calc_I_Y + 2]

            cmp bx, 0ffffh
            jne P_Calc_L_Br1_PostYNegWall

                neg ax

            P_Calc_L_Br1_PostYNegWall:

            mov ds:[P_Calc_O_ZDiv], ax

            mov ds:[P_Calc_O_ZSign], '-'

            ; --------------------------------

            jmp P_Calc_L_Ok

        P_Calc_L_Br2:

        ; x is pos
        cmp R_XH_C, 0000h
        jne P_Calc_L_Br3
        ; x > 3
        cmp R_XL_C, 3
        jbe P_Calc_L_Br3
        ; y is pos
        cmp R_YH_C, 0000h
        jne P_Calc_L_Br3
        ; y > 0
        cmp R_YL_C, 0
        jbe P_Calc_L_Br3

            ; ----------------( x > 3, y > 0: 6x )----------------

            mov ax, word ptr ds:[P_Calc_I_X + 0]
            mov cx, word ptr ds:[P_Calc_I_X + 2]

            mov bx, 6

            cmp cx, 0000h
            jne P_Calc_L_Br2_PosWall

                mul bx
                jo P_Calc_L_ErrOF

                mov bx, ax
                mov word ptr ds:[P_Calc_O_ZInt + 0], bx

                mov bx, 0000h
                mov word ptr ds:[P_Calc_O_ZInt + 2], bx

                mov ds:[P_Calc_O_ZSign], '+'

                jmp P_Calc_L_Br2_NegWall

            P_Calc_L_Br2_PosWall:

                imul bx
                jo P_Calc_L_ErrOF

                mov bx, ax
                mov word ptr ds:[P_Calc_O_ZInt + 0], bx

                mov bx, 0ffffh
                mov word ptr ds:[P_Calc_O_ZInt + 2], bx

                mov ds:[P_Calc_O_ZSign], '-'

            P_Calc_L_Br2_NegWall:

            mov ax, 0
            mov ds:[P_Calc_O_ZMod], ax

            mov ax, 0
            mov ds:[P_Calc_O_ZDiv], ax

            ; --------------------------------

            jmp P_Calc_L_Ok

        P_Calc_L_Br3:

            ; ----------------( otherwise: 1 )----------------

            mov ax, 1
            mov word ptr ds:[P_Calc_O_ZInt + 0], ax

            mov ax, 0000h
            mov word ptr ds:[P_Calc_O_ZInt + 2], ax

            mov ax, 0
            mov word ptr ds:[P_Calc_O_ZMod], ax

            mov ax, 0
            mov word ptr ds:[P_Calc_O_ZDiv], ax

            mov ds:[P_Calc_O_ZSign], '+'

            ; --------------------------------

            jmp P_Calc_L_Ok

        ; ================================

        P_Calc_L_Ok:
            mov byte ptr ds:[P_Calc_O_Err], '+'
            jmp P_Calc_L_Exit

        P_Calc_L_ErrOF:
            mov byte ptr ds:[P_Calc_O_Err], 'O'
            jmp P_Calc_L_Exit

        P_Calc_L_ErrDiv0:
            mov byte ptr ds:[P_Calc_O_Err], 'D'
            jmp P_Calc_L_Exit

        P_Calc_L_Exit:

        ; ret
        pop dx
        pop cx
        pop bx
        pop ax

        ret
    P_Calc endp
    
    ; ------------------------------------------------

    P_PrintInt proc far
        ; preserve
        push ax
        push bx
        push cx
        push dx

        ; --------------------------------

        mov ax, word ptr ds:[P_PrintInt_I_Num + 0]

        mov bx, word ptr ds:[P_PrintInt_I_Num + 2]
        cmp bx, 0ffffh
        jne P_PrintInt_L_PreNegWall

            ; x = |x|
            neg ax

            ; [x] = x
            mov ds:[P_PrintInt_M_AbsX], ax

            ; putc('-')
            mov ds:[P_PrintInt_M_Putc], '-'
            mov dx, offset P_PrintInt_M_Putc
            mov ah, 9
            int 21h

            jmp P_PrintInt_L_PrePosWall

        P_PrintInt_L_PreNegWall:

            ; [x] = x
            mov ds:[P_PrintInt_M_AbsX], ax

        P_PrintInt_L_PrePosWall:

        ; --------------------------------

        ; diver
        mov ds:[P_PrintInt_M_Diver], 1
        ; abs x tmp
        mov ax, word ptr ds:[P_PrintInt_M_AbsX]
        mov ds:[P_PrintInt_M_AbsXTmp], ax

        P_PrintInt_L_GetDiv_LC:

            mov ax, ds:[P_PrintInt_M_AbsXTmp]
            cmp ax, 10
            jb P_PrintInt_L_GetDiv_E

            ; ----------------

            mov ax, ds:[P_PrintInt_M_Diver]
            mov bx, 10
            mul bx
            mov ds:[P_PrintInt_M_Diver], ax

            mov ax, ds:[P_PrintInt_M_AbsXTmp]
            mov dx, 0
            mov bx, 10
            div bx
            mov ds:[P_PrintInt_M_AbsXTmp], ax

            ; ----------------

            jmp P_PrintInt_L_GetDiv_LC

        P_PrintInt_L_GetDiv_E:

        ; --------------------------------

        P_PrintInt_L_Loop_C:

            ; ----------------

            ; i = [x]
            mov ax, ds:[P_PrintInt_M_AbsX]
            mov dx, 0
            ; d = [d]
            mov bx, ds:[P_PrintInt_M_Diver]
            ; i /= d
            mov dx, 0
            div bx
            ; bx = 10
            mov bx, 10
            ; _, r = div(i, 10)
            mov dx, 0
            div bx
            ; c = tochar(r)
            add dx, '0'
            ; putc(c)
            mov ds:[P_PrintInt_M_Putc], dl
            mov dx, offset P_PrintInt_M_Putc
            mov ah, 9
            int 21h

            mov ax, ds:[P_PrintInt_M_Diver]
            mov dx, 0
            mov bx, 10
            div bx
            mov ds:[P_PrintInt_M_Diver], ax

            ; ----------------

            mov ax, ds:[P_PrintInt_M_Diver]
            cmp ax, 1
            jae P_PrintInt_L_Loop_C
        
        ; --------------------------------

        ; ret
        pop dx
        pop cx
        pop bx
        pop ax

        ret
    P_PrintInt endp

    ; ------------------------------------------------

    P_FracSimple proc far
        ; preserve
        push ax
        push bx
        push cx
        push dx

        mov ax, word ptr ds:[P_FracSimple_I_X]
        mov bx, word ptr ds:[P_FracSimple_I_Y]
        cmp ax, bx
        jae P_FracSimple_L_thfrjeksjhr
            mov word ptr ds:[P_FracSimple_M_Small], ax
            mov word ptr ds:[P_FracSimple_M_Big],   bx
            mov cx, ax
            jmp P_FracSimple_L_hntjrkedhtbhd
        P_FracSimple_L_thfrjeksjhr:
            mov word ptr ds:[P_FracSimple_M_Small], bx
            mov word ptr ds:[P_FracSimple_M_Big],   ax
            mov cx, bx
        P_FracSimple_L_hntjrkedhtbhd:

        cmp cx, 0
        jne P_FracSimple_L_thrjkiedhgthre
            mov ax, word ptr ds:[P_FracSimple_I_X]
            mov word ptr ds:[P_FracSimple_O_X], ax

            mov ax, word ptr ds:[P_FracSimple_I_Y]
            mov word ptr ds:[P_FracSimple_O_Y], ax

            jmp P_FracSimple_L_Exit
        P_FracSimple_L_thrjkiedhgthre:

        ; cx is divider
        P_FracSimple_L_Loop_C:

            ; ----------------

            ; big
            mov ax, word ptr ds:[P_FracSimple_M_Big]
            mov dx, 0
            ; small
            mov bx, word ptr ds:[P_FracSimple_M_Small]
            ; div
            div bx
            ; if rem
            cmp dx, 0
            jne P_FracSimple_L_jrenhbhjkyhjtrmedk
                ; = 0
                jmp P_FracSimple_L_DivSuccess

            P_FracSimple_L_jrenhbhjkyhjtrmedk:
                ; != 0
                sub ax, bx

                ; l, s = s, l % s
                mov word ptr ds:[P_FracSimple_M_Small], dx
                mov word ptr ds:[P_FracSimple_M_Big],   bx

            ; ----------------

            jmp P_FracSimple_L_Loop_C

        P_FracSimple_L_DivSuccess:
        
            mov ax, word ptr ds:[P_FracSimple_I_X]
            mov dx, 0
            div bx
            mov word ptr ds:[P_FracSimple_O_X], ax

            mov ax, word ptr ds:[P_FracSimple_I_Y]
            mov dx, 0
            div bx
            mov word ptr ds:[P_FracSimple_O_Y], ax

        P_FracSimple_L_Exit:

        ; ret
        pop dx
        pop cx
        pop bx
        pop ax

        ret
    P_FracSimple endp

    ; ------------------------------------------------

    P_OutZ proc far
        ; preserve
        push ax ; push bx
        push dx

        ; prompt
        mov dx, offset D_OutputZPartA
        mov ah, 9
        int 21h

        ; --------------------------------

        cmp word ptr ds:[P_OutZ_I_NumInt + 0], 0
        jne P_OutZ_L_hrjmehnnrjhtnnrj
        cmp word ptr ds:[P_OutZ_I_NumRem], 0
        je P_OutZ_L_fyhrudeynrvtgvyrhu

        jmp P_OutZ_L_gyhgumeeuiwdedhn

        P_OutZ_L_hrjmehnnrjhtnnrj:
        P_OutZ_L_fyhrudeynrvtgvyrhu:

            ; --------( print int )--------
            ; num
            mov ax, word ptr ds:[P_OutZ_I_NumInt + 0]
            mov bx, word ptr ds:[P_OutZ_I_NumInt + 2]
            mov word ptr ds:[P_PrintInt_I_Num + 0], ax
            mov word ptr ds:[P_PrintInt_I_Num + 2], bx
            ; call
            call P_PrintInt

            jmp P_OutZ_L_tthnvcrjejhgbvhrjde
        
        P_OutZ_L_gyhgumeeuiwdedhn:

            cmp byte ptr ds:[P_Calc_O_ZSign], '-'
            jne P_OutZ_L_tthnvcrjejhgbvhrjde

            ; putc('-')
            mov ds:[P_PrintInt_M_Putc], '-'
            mov dx, offset P_PrintInt_M_Putc
            mov ah, 9
            int 21h

        P_OutZ_L_tthnvcrjejhgbvhrjde:

        ; --------------------------------

        ; if mod is not zero
        cmp ds:[P_OutZ_I_NumRem], 0
        je P_OutZ_L_RemZero

            ; if zero
            cmp word ptr ds:[P_OutZ_I_NumInt + 0], 0
            je P_OutZ_L_hferbdsmdmfhjv
                ; prompt
                mov dx, offset D_OutputZPartB
                mov ah, 9
                int 21h
            P_OutZ_L_hferbdsmdmfhjv:

            ; --------------------------------

            ; --------( print int )--------
            ; num
            mov ax, ds:[P_OutZ_I_NumRem]
            mov word ptr ds:[P_PrintInt_I_Num + 0], ax
            mov word ptr ds:[P_PrintInt_I_Num + 2], 0000h
            ; call
            call P_PrintInt

            ; --------------------------------

            ; prompt
            mov dx, offset D_OutputZPartC
            mov ah, 9
            int 21h

            ; --------------------------------

            ; --------( print int )-------
            ; num
            mov ax, ds:[P_OutZ_I_NumDiv]
            mov word ptr ds:[P_PrintInt_I_Num + 0], ax
            mov word ptr ds:[P_PrintInt_I_Num + 2], 0000h
            ; call
            call P_PrintInt
            
            ; --------------------------------

            ; if zero
            cmp word ptr ds:[P_OutZ_I_NumInt + 0], 0
            je P_OutZ_L_hfrjdhbcndjedf
                ; prompt
                mov dx, offset D_OutputZPartD
                mov ah, 9
                int 21h
            P_OutZ_L_hfrjdhbcndjedf:

        P_OutZ_L_RemZero:

        ; --------------------------------

        call P_NewLine

        ; ret
        pop dx ; pop bx
        pop ax

        ret
    P_OutZ endp

    ; ------------------------------------------------

    P_NewLine proc far
        ; preserve
        push ax
        push dx

        ; print an error
        mov dx, offset D_NewLine
        mov ah, 9
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    P_NewLine endp

    ; ------------------------------------------------

S_Code ends
end Main
