TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc
.data
	dlzkaSpravy equ 256
	nacitanaSprava DB dlzkaSpravy DUP(?)
	novaSprava DB dlzkaSpravy*3 DUP(?)

	nasielString DB "Naslo sa cislo",0
	nenasielString DB "Nenaslo sa cislo",0

	cisla DW 5,-2,3
	A DB 'a'

.code
main PROC
	call Clrscr

    call NajdiNajmensie

	exit

main ENDP

;
; PROC CisloNaString
; Konvertuje cislo z AX na retazec a vypise ho
; Vysledok ulozi do EAX
;
CisloNaString PROC
    push edi
    push edx
    push ecx
    push ebx
    ;push eax

    mov edi,0 ; index pre vypis spravy

    PrekladNaString:
        mov dx,0 ; zvysok
        mov cx,10 ; delitel
        div cx ; ax = vysledok, dx = zvysok

        add dl, '0'
        mov novaSprava[edi],dl
        inc edi

        cmp ax,0
        jne PrekladNaString
    VypisStringu:
        dec edi
        cmp edi,0
        jl Koniec
        mov al,novaSprava[edi]
        jmp VypisStringu
    Koniec:
    mov edx,OFFSET novaSprava
    ;pop eax
    pop ebx
    pop ecx
    pop edx
    pop edi
    ret

CisloNaString ENDP

;
; PROC StringNaCislo
; String z EDX premeni na cislo a ulozi ho do EAX
;
StringNaCislo PROC
    push ESI
    push EBX
    push EDX

    mov esi, 0 ; i
    mov eax, 0 ; a

    Opakuj:
        movzx ebx, nacitanaSprava[esi]
        cmp ebx, 0
        je Koniec

        sub ebx, '0'
        imul eax,10
        add eax, ebx

        inc esi
        jmp Opakuj

    Koniec:
    pop EDX
    pop EBX
    pop ESI
    ret

StringNaCislo ENDP

;
; Najde v postupnosti 'cisla' cislo z EAX
;
NajdiVPostupnosti PROC
    push EAX
    push ESI
    push EDX
    push ECX

    mov esi,0 ; i
    mov ecx, LENGTHOF cisla ; velkost cisel
    mov edx,0 ; to compare

    Iteruj:
        cmp ecx, 0 ; ci sme uz na konci loopu
        je Nenasiel

        movzx edx,cisla[esi] ; kedze su rozne velkosti

        cmp eax,edx ; ak sa rovnaju
        je Nasiel

        inc esi
        inc esi ; kedze word je 2 bytes
        dec ecx

        jmp Iteruj
    Nasiel:
        mov edx, OFFSET nasielString
        jmp Koniec
    Nenasiel:
        mov edx, OFFSET nenasielString
        jmp Koniec
    Koniec:
    call WriteString

    pop ECX
    pop EDX
    pop ESI
    pop EAX
    ret

NajdiVPostupnosti ENDP

NajdiNajmensie PROC
    push EAX
    push EBX
    push ECX
    push EDX
    push ESI

    mov edx, LENGTHOF cisla ; velkost cisel

    mov ax,cisla[0] ; najmensie cislo zatial
    mov ebx,0  ; najmensi index zatial

    mov esi,0 ; i

    Opakuj:
        inc esi
        cmp esi,edx
        je Koniec
        mov cx,cisla[esi * 2] ; bikoz je to word (2 bytes)
        cmp ax,cx
        jg NajmensieCislo
        jmp Opakuj
    NajmensieCislo:
        mov ax,cx
        ;mov ebx,esi
        jmp Opakuj
    Koniec:
    movsx eax, ax
    call WriteInt
    pop ESI
    pop EDX
    pop ECX
    pop EBX
    pop EAX
    ret

NajdiNajmensie ENDP

END main