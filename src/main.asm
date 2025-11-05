TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc
.data
	dlzkaSpravy equ 256
	nacitanaSprava DB dlzkaSpravy DUP(?)
	novaSprava DB dlzkaSpravy*3 DUP(?)

	nasielString DB "Naslo sa cislo",0
	nenasielString DB "Nenaslo sa cislo",0

	cisla DW 1,2,3

.code
main PROC
	call Clrscr

	;mov ax,1234
	;call CisloNaString

	;call ReadString
	mov edx,OFFSET nacitanaSprava
	mov ecx, dlzkaSpravy
	call ReadString ; ulozi String do EDX
	call StringNaCislo ; ulozi cislo do EAX
	call NajdiVPostupnosti ; najde cislo EAX v postupnosti 'cisla'
    ;call WriteInt

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

END main