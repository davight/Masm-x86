TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc
.data
	velkost equ 256
	iStr DB velkost + 1 DUP(?)

	S DB velkost DUP(?)
	R DB velkost DUP(?)
	P DB velkost DUP(?)

	nasielString DB "Naslo sa cislo",0
	nenasielString DB "Nenaslo sa cislo",0

    upravenaSprava DB velkost DUP(?)
	nejakaSprava DB "retazec",0
	key DB -2,4,1,0,-3,5,2,-4,-4,6

	cisla DW 5,-2,3

	rozloha DD 281.64, 760.62, 491.87, 173.68, 1341.08, 735.65, 690.46, 646.83, 392.84, 478.92

	A DW 1, 2, 5, 7, 8
	B DW 3, 4, 9, 2, 1
	EPS DW 2

	sprava BYTE "Ahoj",0

	zoznam SWORD 1,2,-4,5,8,0

	maxCislo DB "Max cislo je: ",0
    minCislo DB " Min cislo je: ",0


	;A DB 'a'
	mnozina DD 0
	mnozina2 DD 0

.code

;SkusimNeco PROTO pSprava:PTR BYTE, n:DWORD


SkusimNeco PROC USES eax pSprava, n:DWORD
    mov edx, pSprava
    call WriteString
    
    mov eax,n
    call WriteInt
    ret
SkusimNeco ENDP

main PROC

    invoke SkusimNeco, OFFSET sprava, EPS

	exit

main ENDP

SkuskaTest PROC
    mov eax,0
    mov ax, zoznam[0] ; max
    mov bx, zoznam[0] ; min
    mov edi, LENGTHOF zoznam
    dec edi
    LoopCisla:
        mov cx, zoznam[edi * 2]
        cmp cx,ax
        jl Dalej

        mov ax,cx

        Dalej:
        cmp cx,bx
        jg Dalej2

        mov bx,cx

        Dalej2:
        cmp edi,0
        je Koniec

        dec edi
        jmp LoopCisla

    Koniec:
    mov edx,OFFSET maxCislo
    call WriteString

    call WriteInt
    mov edx,OFFSET minCislo

    call WriteString
    mov ax,bx

    movsx eax, ax
    call WriteInt
    ret
SkuskaTest ENDP

SkuskaMilion PROC
    mov edi, LENGTHOF A ; index
    mov ecx, 0 ; counter
    LoopCisla:
        mov ax,A[edi]
        mov bx,B[edi]

        sub ax,bx

        cmp ax,EPS
        jle IncCounter
        jmp NotIncCounter

        IncCounter:
        inc ecx

        NotIncCounter:
        cmp edi,0
        je Koniec
        dec edi

    Koniec:
    mov al,'A'
    call WriteChar
    mov eax, ecx
    call WriteInt
    ret

SkuskaMilion ENDP

SkuskaTisic PROC
    mov edx,OFFSET iStr
    mov ecx,SIZEOF iStr

    call ReadString

    mov edi, 0 ; index
    LoopString:
        mov al,iStr[edi]
        cmp al,0
        je Koniec

        mov ah,iStr[edi + 1]
        cmp ah,0

        je Koniec

        mov iStr[edi],ah
        mov iStr[edi + 1],al

        inc edi
        inc edi
        jmp LoopString

    Koniec:
    mov eax, OFFSET iStr
    call WriteString

    ret
SkuskaTisic ENDP


TestPrint PROC

    mov edx, OFFSET sprava
    mov ecx, LENGTHOF sprava
    mov edi, 0

    Print1:
        mov al,[edx + edi]
        call WriteChar
        inc edi
        loop Print1

    mov edi, 0

    Print2:
        mov al,sprava[edi]
        cmp al,0
        je Koniec

        call WriteChar
        inc edi

        jmp Print2

    Koniec:
    ret

TestPrint ENDP

SkuskaPat PROC
    ; INPUT START
    mov edx, OFFSET R
    mov ecx, velkost

    call ReadString ; R

    mov edx, OFFSET S
    mov ecx, velkost

    call ReadString ; S
    mov ebx, eax ; ulozime velkost S do EBX

    mov edx, OFFSET P
    mov ecx, velkost

    call ReadInt ; P
    ; INPUT END

    cmp eax,ebx
    jge InsertAtEnd

    mov al,'X'
    jmp Print


    InsertAtEnd:
        mov edi, 0 ; Loop

        LoopInsertAtEnd:
            mov al,R[edi]
            mov S[ebx],al
            cmp al,0
            je Print

            inc edi
            inc ebx
            jmp LoopInsertAtEnd

    InsertAtIndex:
        mov edi, 0 ; Loop pre R
        mov esi, 0 ; Loop pre S
        mov ecx, OFFSET S ; copy S

        LoopInsertAtIndex:



    Print:
    mov edi,0

    PrintLoop:
        mov al,S[edi]
        cmp al,0
        je Koniec

        call WriteChar
        inc edi
        jmp PrintLoop

    Koniec:
    ret

SkuskaPat ENDP



















SkuskaStyri PROC
    ; START LOAD
    mov edx, OFFSET iStr
    mov ecx, velkost

    call ReadString ; String mame v EAX
    mov ebx, eax

    mov al,10
    call WriteChar

    call ReadInt ; Int mame v EAX tiez lol

    mov edi, 0 ; index
    ; END LOAD



    Koniec:

    ret

SkuskaStyri ENDP










SkuskaTri PROC
    push edi
    push eax

    mov ecx,2 ; N
    ; Rozdelim na dva loops, jeden od 0 po N a druhy od N po koniec slova

    mov ebx,ecx ; Loop index origo
    mov edx, 0 ; Loop index new
    PrvyLoop:
        mov al,nejakaSprava[ebx]
        cmp al,0
        je PrvyLoopEnde

        mov upravenaSprava[edx],al

        inc ebx
        inc edx

        jmp PrvyLoop

    PrvyLoopEnde:
        mov ebx,0 ; Loop index origo

    DruhyLoop:
        cmp ebx,ecx
        je DruhyLoopEnde

        mov al,nejakaSprava[ebx]
        mov upravenaSprava[edx],al

        inc ebx
        inc edx
        jmp DruhyLoop

    DruhyLoopEnde:
        mov edi, 0

    VypisNovyString:
        mov al,upravenaSprava[edi]
        cmp al,0
        je Koniec

        call WriteChar
        inc edi
        jmp VypisNovyString

   Koniec:
   pop eax
   pop edi
   ret

SkuskaTri ENDP












SkuskaDva PROC
    push edi

    mov edi, 0 ; index pre loop
    ; A = 65
    ; Z = 90

    LoopString:
        mov al,nejakaSprava[edi]
        cmp al,0
        je EndString

        sub al,65
        mov ah,90
        sub ah,al

        mov upravenaSprava[edi],ah

        inc edi
        jmp LoopString

    EndString:
        mov upravenaSprava[edi],0

    mov edi, 0 ; reset index pre loop

    WriteNewString:
        mov al,upravenaSprava[edi]
        cmp al,0
        je Koniec

        call WriteChar
        inc edi
        jmp WriteNewString

    Koniec:

    pop edi
    ret

SkuskaDva ENDP





















SkuskaJeden PROC
    mov edi, 0 ; index pre loop

    LoopString:
        mov al,nejakaSprava[edi]
        cmp al,0
        je Koniec

        add al,key[edi]

        cmp al,90
        jg JeVacsie

        cmp al,65
        jl JeMensie

        jmp Continue

    JeVacsie:
        sub al,25
        jmp Continue
    JeMensie:
        add al,26
        jmp Continue

    Continue:
        inc edi
        call WriteChar
        jmp LoopString

    Koniec:
    ret
SkuskaJeden ENDP

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
        ;mov novaSprava[edi],dl
        inc edi

        cmp ax,0
        jne PrekladNaString
    VypisStringu:
        dec edi
        cmp edi,0
        jl Koniec
        ;mov al,novaSprava[edi]
        jmp VypisStringu
    Koniec:
    ;mov edx,OFFSET novaSprava
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
        ;movzx ebx, nacitanaSprava[esi]
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

; Dosadi nahdne cislo od 0 po EAX do mnoziny 'mnozina2'
; @Example:
; - Vyberie cislo 5
; - V mnozine na 5. bite nastavi 1
; - Opakuje 10krat
;
DosadDoMnoziny2 PROC
    push EBX
    push ECX

    call RandomRange
    ;call WriteInt
    mov EBX,1
    mov CL,AL

    shl EBX,CL
    ;mov EAX,EBX
    or mnozina2,EBX

    POP EBX
    POP ECX
    ret

DosadDoMnoziny2 ENDP

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

;
; Vypise vsetky cisla z mnoziny 'mnozina'
; @Example
; - Mame mnozina 10001
; - Vypise vsetky indexy bitov, na ktorych je jednotka
; - T.j 1 a 5
;
PrecitajZMnoziny2 PROC
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
        test EBX, mnozina2
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

PrecitajZMnoziny2 ENDP

PriemernaRozloha PROC
    push EAX
    push EBX
    push ECX
    push EDX
    push EDI

    finit
    mov ECX, LENGTHOF rozloha
    xor edi, edi
    fldz

    mov al,'!'
    call WriteChar
    ;mov EBX, LENGTHOF rozloha ; SIZE

    Cyklus:
        fld rozloha[4*edi]
        fadd
        inc edi
        loop Cyklus
        ;call WriteFloat

    Koniec:
    ;fmul
    call WriteFloat

    pop EDI
    pop EDX
    pop ECX
    pop EBX
    pop EAX
    ret

PriemernaRozloha ENDP

END main