TITLE MASM Template
; Directives included by depenednecies in Irvine32.inc
;.386
;.model flat, stdcall
;.stack 4096

INCLUDE Irvine32.inc
.data
    message db "Hello World!",0

.code
main PROC
    mov edx, OFFSET message
    call WriteString
    exit

main ENDP

END main


