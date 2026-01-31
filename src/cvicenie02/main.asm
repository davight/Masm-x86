TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc

.data
    sizeString equ 255
    inputString DB sizeString + 1 DUP(?)

    nespravnaVetaString DB "Tato veta nie je spravna!", 0
    spravnaVetaString   DB "Tato veta je spravna!", 0

.code

main PROC
    ;call Cast1
    ;call Cast2
    ;call Cast3
    exit
main ENDP

Cast1 PROC
    mov EDX, OFFSET inputString
    mov ECX, sizeString

    call ReadString

    mov EDI, 0 ; Loop index
    LoopVypis:
        mov AL, inputString[EDI]

        cmp AL, 0
        je KoniecVypisu

        call WriteChar
        mov AL, 10
        call WriteChar

        inc EDI
        jmp LoopVypis

    KoniecVypisu:
    ret
Cast1 ENDP

Cast2 PROC
    mov EDX, OFFSET inputString
    mov ECX, sizeString

    call ReadString

    mov EDI, 0 ; Loop index
    LoopVypis:
        mov AL, inputString[EDI]

        cmp AL, 0
        je KoniecVypisu

        call WriteChar
        inc AL
        call WriteChar

        inc EDI
        jmp LoopVypis

    KoniecVypisu:
    ret
Cast2 ENDP

Cast3 PROC
    mov EDX, OFFSET inputString
    mov ECX, sizeString

    call ReadString

    call ReadChar
    mov AL, AH ; Ulozime si ho inam

    mov ESI, 0 ; Counter charakteru
    mov EDI, 0 ; Loop index
    LoopHladanie:
        mov AL, inputString[EDI]

        cmp AL, 0
        je KoniecVypisu

        cmp AL, AH
        jne NerovnajuSa

        inc ESI

        NerovnajuSa:
        inc EDI
        jmp LoopHladanie

    KoniecVypisu:
    mov AL, 10
    call WriteChar

    mov ESI, EAX
    call WriteInt

    ret
Cast3 ENDP


END main
