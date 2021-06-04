;-----------------------------------------------------------------------------
;  FILE NAME   : Code1-TP2.asm 
;  TARGET MCU  :  C8051F020
;  A FAIRE: 
;  - Coder le sous-programme UINT16_ADD (voir explication compl�mentaires
;    dans le descriptif de ce Sous-programme ci-dessous)
;    (la gestion des arguments d�passant une valeur limite est optionnelle
;     dans un premier temps)
;  - ins�rer les codes d'appels du SP UINT16_ADD dans TEST 1 et TEST 2
;  - Compl�ter TEST3 et TEST4 en fonction des sources et destination sp�cifi�es
;  - Tester le bon fonctionnement du sous-programme � l'aide du simulateur
;  - A l'aide du simulateur, d�terminer la valeur du pointeur de pile
;    et le contenu de la pile avant et apr�s chaque appel de sous-programme 
;    Placer ces informations en commentaire
;  - A l'aide du simulateur, d�terminer la valeur du pointeur de pile et le contenu
;    de la pile avant et apr�s chaque instruction de retour de Sous-programme
;    Placer ces informations en commentaire

;-----------------------------------------------------------------------------
$include (c8051f020.inc)               ; Include register definition file.
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
GREEN_LED      equ   P1.6              ; Port I/O pin connected to Green LED.
;-----------------------------------------------------------------------------
; RESET and VECTOR
;-----------------------------------------------------------------------------
               ; Reset Vector
               cseg AT 0          ; SEGMENT Absolu
               ljmp Main  ; jump to the start of code at the reset vector.
;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
Prog_base      segment  CODE

               rseg     Prog_base      ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.
;******************************************************************************
; Programme Principal
;******************************************************************************
Main:
		mov WDTCN, #0DEh    
        mov WDTCN, #0ADh
Main_BCL:	
;******************************************************************************
; TEST 1 - test de UINT16_ADD avec l'addition des nombres 1122H et 3344H
        mov  R6,#11H
		mov  R7,#22H
		mov  R4,#33H
		mov  R5,#44H
; Ins�rer ici le code d'appel Sous programme UINT16_ADD
		CALL UINT16_ADD
        MOV DPH,R6 ; Stockage du r�sultat dans DPTR
		MOV DPL,R7

;******************************************************************************
; TEST 2 -test de UINT16_ADD avec l'addition des nombres 8022H et 3344H
; D�passement de capacit� --> r�sultat retourn� = 0
        mov  R6,#80H
		mov  R7,#22H
		mov  R4,#55H 
		mov  R5,#11H
; Ins�rer ici le code d'appel Sous programme UINT16_ADD    
		CALL UINT16_ADD
        MOV DPH,R6 ; Stockage du r�sultat dans DPTR
		MOV DPL,R7		
;******************************************************************************
; TEST 3 - test de UINT16_ADD avec le contenu des cases m�moires
;    D:0x60(L) D:0X61(H)  + D:0x62(L) D:0X63(H)  
; Stocker le r�sultat dans D:0x64(L) D:0X65(H)
; Penser � initialiser avec le d�bogueur les cases m�moires "op�randes" d'entr�e

; ins�rer le code ici
		MOV R7,60H
		MOV R6,61H
		MOV R5,62H
		MOV R4,63H
		CALL UINT16_ADD
		MOV 65H,R6
		MOV 64H,R7
;******************************************************************************
; TEST 4 - test de UINT16_ADD avec le contenu des cases m�moires
;    C:0x0002(L) I:0X0003(H)  + X:0x0010(L) D:0X0011(H)  
; Stocker le r�sultat dans I:0x90(L) I:0X91(H)
; Penser � initialiser avec le d�bogueur les cases m�moires "op�randes" d'entr�e

; ins�rer le code ici
		CLR A
		MOV DPTR,#0002H
		MOVC A,@A+DPTR
		MOV R7,A
		
		MOV R0,#03H	;Oui alors en fait en vrai c'est R3 mais on le fait en indirect quand m�me
		MOV 06H,@R0	;06H = registre 6
		
		CLR A
		MOV R1,#10H
		MOVX A,@R1
		MOV R5,A
		
		MOV R4,11H
		
		CALL UINT16_ADD
		
		MOV R0,#90H
		MOV @R0,07H
		INC R0
		MOV @R0,06H
	
      jmp Main_BCL

;******************************************************************************
; Zone r�serv�e aux Sous programmes
;******************************************************************************

;******************************************************************************
; UINT16_ADD - SOUS-PROGRAMME Addition de 2 nombres 16 bits
;
; Description: Sous-programme charg� d'additionner 2 nombres de 16 bits non sign�s
;              argument1 + argument2 = R�sultat
;              
; Param�tres d'entr�e:  R6-R7: argument1  (R6 poids fort, R7 poids faible)
;                       R4-R5: argument2  (R4 poids fort, R5 poids faible)
;						
;  Algo:   Etape1 - Faire R7 + R5         --> R7
;          Etape2 - Faire R6 + R4 + Carry --> R6 

; Param�tres de sortie: R�sultat sur R6-R7 (R6 poids fort, R7 poids faible)
; Registres modifi�s:  4
; Pile: 6 octets 
;******************************************************************************
UINT16_ADD:
	CLR A
	ADD A,R7
	ADD A,R5
	MOV R7,A
	
	CLR A
	ADD A,R6
	ADDC A,R4
	MOV R6,A
	RET
	
; Ins�rer le code du sous-programme ici



; FIN UINT16_ADD
;******************************************************************************
END
