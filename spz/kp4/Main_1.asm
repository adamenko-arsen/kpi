;
; facts:
;
; bp use ss by default
; bx use ds by default
; bp/bx can use ds, es, ss, ...
;

;
; transition from 16 to 32 bit:
;
; ip -> eip
; sp -> esp
; ax -> eax during call/ret
;

;
; techniques:
;
; pop *dummy: pop space for unused values after call
; push *dummy: push space for return value before call
;

.model tiny
assume cs: S_Code, ds: S_Data, es: S_Data, ss: S_Stack

S_Stack segment para stack 'STACK'
    db 128 dup('STACK')
S_Stack ends

S_Data segment para public 'DATA'
    D_Logo              db 0Dh, 0Ah, '     mm                                    '
                        db 0Dh, 0Ah, '     ##    m mm   m mm   mmm   m   m   mmm '
                        db 0Dh, 0Ah, '    #  #   #"  "  #"  " "   #  "m m"  #   "'
                        db 0Dh, 0Ah, '    #mm#   #      #     m"""#   #m#    """m'
                        db 0Dh, 0Ah, '   #    #  #      #     "mm"#   "#    "mmm"'
                        db 0Dh, 0Ah, '                               ""          '
                        db 0Dh, 0Ah
                        db 0Dh, 0Ah, '   I P - 3 5   A d a m e n k o   A r s e n '
                        db 0Dh, 0Ah
                        db 0Dh, 0Ah
                        db '$'

    D_Array             dd 20 dup('AA')
    D_ArrCapacity       db ?
    D_Sum               dd 'SS'
    D_Max               dd 'MM'

    D_ArrPrompt         db 'Input the capacity of a new array (1..20): ', '$'

    D_Out_Sum           db 'The sum of the array: ', '$'
    D_Out_Max           db 'The max of the array: ', '$'
    D_Out_Sorted        db 'The view of the sorted array:', 0Dh, 0Ah, '$'

    D_GInt_ErrOF        db 'An overflow error is occured while parsing the number', 0Dh, 0Ah, 0Dh, 0Ah, '$'
    D_GInt_ErrRng       db 'The number is not in the range', 0Dh, 0Ah, 0Dh, 0Ah, '$'
    D_GInt_ErrFmt       db 'The input is misformatted', 0Dh, 0Ah, 0Dh, 0Ah, '$'

    D_ArrElem_Prefix    db '#', '$'
    D_ArrElem_Postfix   db ' (-32768..+65535): ', '$'
    D_ArrElem_PostfixB  db ': ', '$'
    D_ArrElem_InBuf     db 32 dup('$')

    D_NewLine           db 0Dh, 0Ah, '$'

    D_ContPrompt        db 'To continue (y/N)? ', '$'

    FmtInt_Result       db 16 dup('$')

    InputInt_Buffer     db 7, ?, 7 dup('I')
    AskCont_Buffer      db 2, ?, 2 dup('C')

    D_PushPopDummyValue dd ?
S_Data ends

S_Code segment para public 'CODE'
    .386
    Main proc far
        ; segment init
        mov ax, S_Data
        mov ds, ax
        mov es, ax

        ; greeting
        mov ah, 9
        lea dx, D_Logo
        int 21h

        Main_Restart:
            ; ask array capacity
            lea ax, D_ArrPrompt
            push ax
            mov eax, 1
            push eax
            mov eax, 20
            push eax
            call InputInt
            pop dword ptr [D_PushPopDummyValue]
            pop word ptr [D_PushPopDummyValue]
            pop eax

            ; init array
            mov [D_ArrCapacity], al

            ; elements loop
            lea ebx, D_Array

            mov esi, 0
            mov di, ax

            Main_FillLoop_L:

                cmp si, di
                jae Main_FillLoop_E

                ; ----------------

                mov eax, 0
                mov ax, si
                inc ax
                push eax
                call FmtInt

                mov byte ptr [D_ArrElem_InBuf + 0], '$'
                
                mov ax, 0
                push ax
                lea ax, D_ArrElem_InBuf
                push ax
                lea ax, D_ArrElem_Prefix
                push ax
                call Strcat
                pop dword ptr [D_PushPopDummyValue]
                pop ax

                push ax
                lea ax, D_ArrElem_InBuf
                push ax
                lea ax, FmtInt_Result
                push ax
                call Strcat
                pop dword ptr [D_PushPopDummyValue]
                pop ax

                push ax
                lea ax, D_ArrElem_InBuf
                push ax
                lea ax, D_ArrElem_Postfix
                push ax
                call Strcat
                pop dword ptr [D_PushPopDummyValue]
                pop ax

                lea bx, D_ArrElem_InBuf
                add bx, ax
                mov byte ptr [bx], '$'

                ; input element
                lea ax, D_ArrElem_InBuf
                push ax
                mov eax, -32768
                push eax
                mov eax, 65535
                push eax
                call InputInt
                pop dword ptr [D_PushPopDummyValue]
                pop word ptr [D_PushPopDummyValue]
                pop eax

                mov D_Array[4*esi], eax

                inc si
                jmp Main_FillLoop_L

            Main_FillLoop_E:

            call NewLine

            ; sum
            mov ah, 9
            lea dx, [D_Out_Sum]
            int 21h

            call TaskSum

            push dword ptr [D_Sum]
            call FmtInt

            mov ah, 9
            lea dx, [FmtInt_Result]
            int 21h

            call NewLine

            ; max
            mov ah, 9
            lea dx, [D_Out_Max]
            int 21h

            call TaskMax

            push dword ptr [D_Max]
            call FmtInt

            mov ah, 9
            lea dx, [FmtInt_Result]
            int 21h

            call NewLine

            ; sort
            mov ah, 9
            lea dx, [D_Out_Sorted]
            int 21h

            call TaskSort

            ; sort loop
            mov esi, 0

            mov ax, 0
            mov al, [D_ArrCapacity]
            mov di, ax

            Main_SortLoop_L:

                cmp si, di
                jae Main_SortLoop_E

                mov ah, 9
                lea dx, [D_ArrElem_Prefix]
                int 21h

                mov eax, 0
                mov ax, si
                inc eax
                push eax
                call FmtInt

                mov ah, 9
                lea dx, [FmtInt_Result]
                int 21h

                mov ah, 9
                lea dx, [D_ArrElem_PostfixB]
                int 21h

                mov eax, D_Array[4*esi]
                push eax
                call FmtInt

                mov ah, 9
                lea dx, [FmtInt_Result]
                int 21h

                call NewLine

                inc si
                jmp Main_SortLoop_L

            Main_SortLoop_E:

            call NewLine

            ; ask continuation
            add sp, -2
            call AskCont
            pop ax

            cmp ax, 1
        je Main_Restart

        ; exit
        mov ah, 4Ch
        mov al, 0
        int 21h
    Main endp

    TaskSum proc far
        ; preserve
        push eax
        push bx
        push ecx
        push si
        push di

        ; init
        mov esi, 0

        mov bx, 0
        mov bl, [D_ArrCapacity]
        mov di, bx

        mov eax, 0

        lea ebx, [D_Array]

        ; loop
        TaskSum_Loop_L:

            cmp si, di
            jae TaskSum_Loop_E

            mov ecx, ebx[4*esi]
            add eax, ecx

            inc si

            jmp TaskSum_Loop_L

        TaskSum_Loop_E:

        mov [D_Sum], eax

        ; ret
        pop di
        pop si
        pop ecx
        pop bx
        pop eax

        ret
    TaskSum endp

    TaskMax proc far
        ; preserve
        push eax
        push ebx
        push ecx
        push si
        push di

        ; init
        mov esi, 0

        mov bx, 0
        mov bl, [D_ArrCapacity]
        mov di, bx

        mov eax, -2147483648

        lea ebx, [D_Array]

        ; loop
        TaskMax_Loop_L:

            cmp si, di
            jae TaskMax_Loop_E

            mov ecx, ebx[4*esi]
            cmp ecx, eax
            jle TaskMax_jfdehuj
                mov eax, ecx
            TaskMax_jfdehuj:

            inc si

            jmp TaskMax_Loop_L

        TaskMax_Loop_E:

        mov [D_Max], eax

        ; ret
        pop di
        pop si
        pop ecx
        pop ebx
        pop eax

        ret
    TaskMax endp

    TaskSort proc far
        ; preserve
        push eax
        push ebx
        push ecx
        push si
        push di

        ; init
        mov esi, 0

        mov bx, 0
        mov bl, [D_ArrCapacity]
        mov di, bx
        dec di

        lea ebx, [D_Array]

        ; loops
        TaskSort_LoopA_L:

            cmp di, 1
            jb TaskSort_LoopA_E

            ; ----------------

            mov si, 0

            TaskSort_LoopB_L:

                cmp si, di
                jae TaskSort_LoopB_E

                ; ----------------

                mov eax, ebx[4*esi + 0*4]
                mov ecx, ebx[4*esi + 1*4]

                cmp eax, ecx
                jle TaskSort_fjrjed
                    mov ebx[4*esi + 0*4], ecx
                    mov ebx[4*esi + 1*4], eax
                TaskSort_fjrjed:

                ; ----------------

                inc si
                jmp TaskSort_LoopB_L

            TaskSort_LoopB_E:

            ; ----------------

            dec di
            jmp TaskSort_LoopA_L

        TaskSort_LoopA_E:

        ; ret
        pop di
        pop si
        pop ecx
        pop ebx
        pop eax

        ret
    TaskSort endp

    InputInt proc far
        ; arg: [prm] [min      ] [max      ]
        ; ret: [value    ]
        ; map: --2-- --2-- --2-- --2-- --2--
        ; extra: 6 = eax + bp
        ; i/o offset: +16

        ; preserve
        push bp
        mov bp, sp

        push eax
        push dx

        ; --------(input)--------

        InputInt_Retype:

            mov ah, 9
            mov dx, [bp + 16 - 2]
            int 21h

            mov ah, 10
            lea dx, InputInt_Buffer
            int 21h

            call NewLine

            ; --------(parse)--------

            lea ax, [InputInt_Buffer + 2]
            push ax
            mov ax, 0
            mov al, [InputInt_Buffer + 1]
            push ax
            push ax
            call Parse
            pop dx
            pop eax

            ; --------(check)--------

            cmp dx, 'O'
            je InputInt_ErrOF
            cmp dx, 'F'
            je InputInt_ErrFmt

            cmp dword ptr [bp + 16 - 6], eax
            jg InputInt_ErrRng

            cmp eax, dword ptr [bp + 16 - 10]
            jg InputInt_ErrRng

            jmp InputInt_Ok

        ; --------(errors)--------

        InputInt_ErrOF:
            mov ah, 9
            lea dx, [D_GInt_ErrOF]
            int 21h

            jmp InputInt_Retype

        InputInt_ErrFmt:
            mov ah, 9
            lea dx, [D_GInt_ErrFmt]
            int 21h

            jmp InputInt_Retype

        InputInt_ErrRng:
            mov ah, 9
            lea dx, [D_GInt_ErrRng]
            int 21h

            jmp InputInt_Retype

        ; ----------------

        InputInt_Ok:

        mov [bp + 16 - 4], eax

        ; ret
        pop dx
        pop eax

        pop bp
        ret
    InputInt endp

    Parse proc far
        ; arg: [buf] [len]
        ; ret: [num      ] [err]
        ; map: --2-- --2-- --2--
        ; extra: 6 = eax + bp
        ; i/o offset: +10
        ;
        ; var: [sgn] [err]
        ; map: --1-- --2--

        ; preserve
        push bp
        mov bp, sp

        push dword ptr [D_PushPopDummyValue]

        push eax
        push bx
        push edx
        push si
        push di

        ; --------(init ptr + len + num)--------

        mov eax, 0
        mov bx, [bp + 12 - 2]
        mov di, [bp + 12 - 4]

        ; --------(sign check)--------

        cmp byte ptr [bx], '-'
        jne Parse_vtgfh
            mov si, 1
            mov byte ptr [bp - 1], '-'

            cmp di, 1 + 1
            jb Parse_ErrFmt

            cmp di, 1 + 5
            ja Parse_ErrOF

            jmp Parse_gntnhd
        Parse_vtgfh:
            mov si, 0
            mov byte ptr [bp - 1], '+'

            cmp di, 1
            jb Parse_ErrFmt

            cmp di, 5
            ja Parse_ErrOF
        Parse_gntnhd:

        ; --------(loop)--------

        Parse_Loop_L:

            cmp si, di
            jae Parse_Loop_E

            ; --------(mul)--------

            mov edx, 10
            mul edx

            ; --------(char)--------

            mov edx, 0
            mov dl, [bx + si]

            cmp dl, '0'
            jb Parse_ErrFmt
            cmp dl, '9'
            ja Parse_ErrFmt

            sub dl, '0'

            ; --------(add)--------

            add eax, edx

            ; --------(inc)--------

            inc si

            jmp Parse_Loop_L

        Parse_Loop_E:

        ; --------(setting sign)--------

        cmp byte ptr [bp - 1], '-'
        jne Parse_dhhedr
            neg eax
        Parse_dhhedr:

        ; --------(pre-exit)--------

        jmp Parse_Ok

        ; --------(exit)--------

        Parse_Ok:
            mov byte ptr [bp - 2], '+'
            jmp Parse_Exit
        
        Parse_ErrOF:
            mov byte ptr [bp - 2], 'O'
            jmp Parse_Exit

        Parse_ErrFmt:
            mov byte ptr [bp - 2], 'F'
            jmp Parse_Exit

        Parse_Exit:

        mov [bp + 12 - 4], eax

        mov ax, 0
        mov al, [bp - 2]
        mov [bp + 12 - 6], ax

        ; ret
        pop di
        pop si
        pop edx
        pop bx
        pop eax

        pop dword ptr [D_PushPopDummyValue]
        
        pop bp
        ret
    Parse endp

    FmtInt proc far
        ; arg: [num      ]
        ; ret:
        ; map: --2-- --2--
        ; extra: 6 = eax + bp
        ; i/o offset: +10
        ;
        ; var: [tmp num  ] [div      ]
        ; map: --2-- --2-- --2-- --2--

        ; preserve
        push bp
        mov bp, sp

        push eax
        push ecx
        push edx
        push di

        mov di, 0
        mov eax, [bp + 10 - 4]
        cmp eax, 0
        jge FmtInt_fjrjed
            neg eax
            mov [FmtInt_Result + 0], '-'

            mov di, 1
        FmtInt_fjrjed:

        mov [bp + 10 - 4], eax

        ; loop diver
        mov dword ptr [bp - 4], eax
        mov dword ptr [bp - 8], 1

        mov ecx, 10

        FmtInt_LoopA_L:

            cmp dword ptr [bp - 4], 10
            jb FmtInt_LoopA_E

            mov eax, [bp - 4]
            mov edx, 0
            div ecx
            mov [bp - 4], eax

            mov eax, [bp - 8]
            mul ecx
            mov [bp - 8], eax

            jmp FmtInt_LoopA_L

        FmtInt_LoopA_E:

        ; loop str
        mov eax, [bp + 10 - 4]
        mov [bp - 4], eax

        FmtInt_LoopB_L:

            cmp dword ptr [bp - 8], 0
            je FmtInt_LoopB_E

            ; div by diver
            mov eax, [bp - 4]
            mov ecx, [bp - 8]
            mov edx, 0
            div ecx
            mov [bp - 4], edx

            ; digit to char
            add al, '0'
            mov [FmtInt_Result + di], al

            ; div divider
            mov eax, [bp - 8]
            mov edx, 0
            mov ecx, 10
            div ecx
            mov [bp - 8], eax

            inc di

            jmp FmtInt_LoopB_L

        FmtInt_LoopB_E:

        ; add $
        mov byte ptr [FmtInt_Result + di], '$'

        ; ret
        pop di
        pop edx
        pop ecx
        pop eax

        pop bp
        ret
    FmtInt endp

    Strcat proc far
        ; arg: [bgn] [dst] [src]
        ; ret: [nps]
        ; map: --2-- --2-- --2--
        ; extra: 6 = eax + bp
        ; i/o offset: +12

        ; preserve
        push bp
        mov bp, sp

        push ax
        push bx
        push si
        push di

        ; init indexers
        mov di, [bp + 12 - 2]
        mov si, 0

        Strcat_AppendDstLoop_L:

            mov bx, [bp + 12 - 6]
            mov al, [bx + si]
            cmp al, '$'

            je Strcat_AppendDstLoop_E

            mov bx, [bp + 12 - 4]
            mov [bx + di], al

            inc si
            inc di

            jmp Strcat_AppendDstLoop_L

        Strcat_AppendDstLoop_E:

        mov [bp + 12 - 2], di

        ; ret
        pop di
        pop si
        pop bx
        pop ax

        pop bp

        ret
    Strcat endp

    NewLine proc far
        ; preserve
        push ax
        push dx

        mov ah, 9
        lea dx, D_NewLine
        int 21h

        ; ret
        pop dx
        pop ax

        ret
    NewLine endp

    AskCont proc far
        ; arg:
        ; ret: [num]
        ; map: --2--
        ; extra: 6 = eax + bp
        ; i/o offset: +8

        ; preserve
        push bp
        mov bp, sp

        push ax
        push dx

        ; prompt
        mov ah, 9
        lea dx, D_ContPrompt
        int 21h

        ; input
        mov ah, 10
        lea dx, AskCont_Buffer
        int 21h

        call NewLine

        ; get response
        mov al, [AskCont_Buffer + 2]
        mov dx, 0

        cmp al, 'y'
        je AskCont_ContStatus

        cmp al, 'Y'
        je AskCont_ContStatus

        jmp AskCont_ExitStatus

        AskCont_ContStatus:
            mov dx, 1
        AskCont_ExitStatus:

        mov [bp + 8 - 2], dx

        ; ret
        pop dx
        pop ax

        pop bp

        ret
    AskCont endp

S_Code ends
end Main
