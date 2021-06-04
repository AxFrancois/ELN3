;-----------------------------------------------------------------------------
;
;  FILE NAME   :  LIB_VOSSP_Nom1.ASM 
;  TARGET MCU  :  C8051F020 
;  

;-----------------------------------------------------------------------------
$include (c8051f020.inc)               ; Include register definition file. 
$include (Proj_ELN3.inc)   	
;-----------------------------------------------------------------------------
;******************************************************************************
;Declaration des variables et fonctions publiques
;******************************************************************************

;******************************************************************************
;Declaration des variables et fonctions Externes
;******************************************************************************
EXTRN code (Putchar_UART0,Getchar_UART0,Send_Char)	; Source Lib_Proj_ELN3
Extrn code  (Display_7S,Tab_code)
Extrn code	(MSG_Park_IN,MSG_Park_NOK,MSG_Park_OUT,MSG_Park_Open,MSG_Park_UC)
Extrn code  (MSG_Park_Fire,MSG_Start_System,MSG_Tab_Code,MSG_Tab_histo)
Extrn code	(MSG_CODE_Nombre,MSG_Free_Places,MSG_Space,MSG_Free,MSG_Occupied)
Extrn xdata (Tab_histo)
Extrn idata (RTC_Centiemes,RTC_Secondes,RTC_Minutes)
PUBLIC _Read_Park_IN
PUBLIC _Read_Park_OUT
PUBLIC _Decod_BIN_to_BCD
public _Test_Code_Acces
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------


;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
ProgSP_base      segment  CODE

               rseg     ProgSP_base      ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.
;------------------------------------------------------------------------------

; INSERER les codes des spous-programmes ici en allant récupérer les squelettes
; de sous-programme dans le fichier Base_SP.asm
; Ne pas oublier d'importer la déclaration Public qui va avec....

_Read_Park_IN:
	PUSH DPH
	PUSH DPL
	PUSH ACC
	
	mov DPH,R6
	mov DPL,R7
	MOVX A,@DPTR
	ANL A,#01H
	
	CJNE A,#01H,PasEgal
	SETB C
	JMP Suite
	PasEgal:
	CLR C
	Suite:
	
	POP ACC
	POP DPL
	POP DPH
	
	ret
	
_Read_Park_OUT:
	PUSH DPH
	PUSH DPL
	PUSH ACC
	
	mov DPH,R6
	mov DPL,R7
	MOVX A,@DPTR
	ANL A,#80H
	
	CJNE A,#80H,PasEgal
	SETB C
	JMP Suite
	PasEgalBis:
	CLR C
	SuiteBis:
	
	POP ACC
	POP DPL
	POP DPH
	
	ret
	
_Decod_BIN_to_BCD:
	PUSH ACC
	PUSH AR5
	PUSH AR6
	
	MOV A,R7
	MOV R5,#0h
	MOV R6,#0h
	
	;verif 63H
	CLR C
	;SETB C
	SUBB A,#64H ;63H + 1 pour le cas du 0
	JC ProcederAuComtage
	MOV R7,#0FFH
	JNC Fin
	ProcederAuComtage:
	
	;Comptage nombre de dizaine et d'unité
	MOV A,R7
	CLR C
	Dizaine:
	SUBB A,#0ah
	INC R6
	JNC Dizaine
	ADD A,#0ah
	DEC R6
	
	CLR C
	Unite:
	SUBB A,#01h
	INC R5
	JNC Unite
	DEC R5
	
	;ajout (conversion en 2x4 bit)
	
	MOV A,#0h
	;JMP VerifDizaine
	AjoutDizaine:
	ADD A,#10h
	;VerifDizaine:
	DJNZ R6,AjoutDizaine
	
	;JMP VerifUnit
	AjoutUnit:
	ADD A,#01h
	;VerifUnit:
	DJNZ R5,AjoutUnit
	
	Fin:
	POP AR6
	POP AR5
	POP ACC

	ret

_Test_Code_Acces:
	PUSH DPH
	PUSH DPL
	PUSH ACC
	
	MOV A,R5
	ANL A,#3fH ;neutralisation bits poids fort
	MOV R5,A
	
	mov DPH,R6
	mov DPL,R7
	CLR A
	MOVC A,@A+DPTR
	MOV R7,A ;on récupère le nombre de codes dans Tab_Code
	MOV R6,A ;même on la stocke 2 fois
	
	LectureTab_Code:
	INC DPTR
	CLR A
	MOVC A,@A+DPTR
	SUBB A,R5
	CJNE A,#0h,ValeurPasTrouve
	JMP ValeurTrouve
	ValeurPasTrouve:
	DJNZ R6,LectureTab_Code
	;après parcours, aucun resultat
	MOV R7,#0h
	JMP FinProg
	
	ValeurTrouve:
	MOV A,R7
	SUBB A,R6	;donc là on a la position
	MOV R7,A
	
	FinProg:
	POP ACC
	POP DPL
	POP DPH
	
	ret
	
_Read_IR_Detec:
	
	
END



