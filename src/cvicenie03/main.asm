TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc

.data
    sizeString equ 255
    inputString DB sizeString + 1 DUP(?)

    R DB sizeString + 1 DUP(?)
    S DB sizeString * 3 DUP(0)

    nespravnaVetaString DB "Tato veta nie je spravna!", 0
    spravnaVetaString   DB "Tato veta je spravna!", 0

.code

main PROC
    ;call Cast1
    call Cast2
    exit
main ENDP

Cast1 PROC
    mov EDX, OFFSET R
    mov ECX, sizeString

    call ReadString

    mov EDI, 0 ; Loop index pre R
    mov ESI, 0 ; Loop index pre S
    LoopHladanie:
        mov AL, R[EDI]

        cmp AL, 0
        je KoniecVypisu

        cmp AL, '0'
        jl PokracujLoop
        cmp AL, '9'
        jg PokracujLoop

        mov S[ESI], '('
        inc ESI
        mov S[ESI], AL
        inc ESI
        mov S[ESI], ')'
        inc ESI
        inc EDI
        jmp LoopHladanie

        PokracujLoop:
        mov S[ESI], AL
        inc ESI
        inc EDI
        jmp LoopHladanie

    KoniecVypisu:
    mov EDX, OFFSET S
    call WriteString
    ret
Cast1 ENDP

Cast2 PROC
    mov EDX, OFFSET inputString
    mov ECX, sizeString

    call ReadString

    mov EAX, 0 ; Loop index
    mov EDI, 0 ; 'A' Counter
    mov ESI, 0 ; 'O' Counter
    LoopPocitanie:
        mov AL, inputString[EAX]

        cmp AL, 0
        je KoniecPocitania

        cmp AL, 'A'
        jne Preskoc
        inc EDI
        jmp HladajDalej

        Preskoc:
        cmp AL, 'O'
        jne HladajDalej
        inc ESI

        HladajDalej:
        inc EAX
        jmp LoopPocitanie

    KoniecPocitania:
    cmp ESI, EDI
    jge SpravnaVeta
    jmp NespravnaVeta

    SpravnaVeta:
        mov EDX, OFFSET spravnaVetaString
        call WriteString
        jmp Koniec

    NespravnaVeta:
        mov EDX, OFFSET nespravnaVetaString
        call WriteString
        jmp Koniec

    Koniec:
    ret
Cast2 ENDP

END main
