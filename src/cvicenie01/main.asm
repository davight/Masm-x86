TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc

.data
    sizeString equ 255

    inputString DB sizeString + 1 DUP(?)

.code

main PROC
    call Cast1

    exit
main ENDP

Cast1 PROC
    mov EDX, OFFSET inputString
    mov ECX, sizeString

    call ReadString

    call WriteString

    mov AL, 10 ; newline ASCII hodnota
    call WriteChar
Cast1 ENDP

END main