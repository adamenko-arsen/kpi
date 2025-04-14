; declare a stack segment
STSEG segment para stack "STACK"

    ; a space for a stack
    db 64 dup("STACK")

STSEG ends

; declare a data segment
DSEG segment para public "DATA"

    ; A data buffer to be cloned from
    Source db 10, 20, 30, 40

    ; A data buffer to be cloned to
    Destination db 4 dup("?")

DSEG ends

; declare a code segment
CSEG segment para public "CODE"

    ; an entry point
    MAIN proc far

        ; core initialization
        ; initialize segment registers
        assume cs: CSEG, ds: DSEG, ss: STSEG

        ; as it is a procedure, push all registers which will be overwritten
        push ds
        mov ax, 0
        push ax

        ; DS initialization
        mov ax, DSEG
        mov ds, ax

        ; zeroing of a destination
        mov Destination + 0, 0   ; store a byte 0 by an address Destination + 1
        mov Destination + 1, 0
        mov Destination + 2, 0
        mov Destination + 3, 0

        ; cloning from a source to a destination (reversed)
        mov al, Source + 0       ; take a byte by an address Source + 0 to a register AL
        mov Destination + 3, al  ; take a register AL and store a byte by an address Destination + 3

        mov al, Source + 1
        mov Destination + 2, al

        mov al, Source + 2
        mov Destination + 1, al

        mov al, Source + 3
        mov Destination + 0, al

        ; exit
        ret

    MAIN endp
    CSEG ends

end MAIN
; end of proc "main" and a code segment in order which idk why it is
