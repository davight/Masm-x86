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
	mnozina DD 0

.code
main PROC
	call Clrscr

    mov ECX,5
    Opakuj:
        mov eax, 32

        call DosadDoMnoziny
        loop Opakuj
    mov EAX,mnozina
    call WriteBin

    call PrecitajZMnoziny

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

;
; Najde v postupnosti 'cisla' najmensie cislo
;
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

;
; Dosadi nahdne cislo od 0 po EAX do mnoziny 'mnozina'
; @Example:
; - Vyberie cislo 5
; - V mnozine na 5. bite nastavi 1
; - Opakuje 10krat
;
DosadDoMnoziny PROC
    push EBX
    push ECX

    call RandomRange
    ;call WriteInt
    mov EBX,1
    mov CL,AL

    shl EBX,CL
    ;mov EAX,EBX
    or mnozina,EBX

    POP EBX
    POP ECX
    ret

DosadDoMnoziny ENDP

;
; Vypise vsetky cisla z mnoziny 'mnozina'
; @Example
; - Mame mnozina 10001
; - Vypise vsetky indexy bitov, na ktorych je jednotka
; - T.j 1 a 5
;
PrecitajZMnoziny PROC
    push EAX
    push EBX
    push ECX
    push EDX

    mov EAX, 0 ; dec reprezentacia indexu
    mov EBX, 1 ; binarna reprezentacia cisla
    mov ECX, 33
    Opakuj:
        dec ECX
        cmp ECX,0
        je Koniec
        ; Iba kuk ci to prechadza cez vsetko
        inc EAX
        test EBX, mnozina
        jnz VypisCislo

        shl EBX, 1
        jmp Opakuj
    VypisCislo:
        call WriteInt
        shl EBX, 1
        jmp Opakuj
    Koniec:
    pop EDX
    pop ECX
    pop EBX
    pop EAX
    ret

PrecitajZMnoziny ENDP

END main