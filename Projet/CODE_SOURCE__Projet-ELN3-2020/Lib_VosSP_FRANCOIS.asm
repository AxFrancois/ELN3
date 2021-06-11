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
PUBLIC _Read_Park_IN
PUBLIC _Read_Park_OUT
PUBLIC _Decod_BIN_to_BCD
public _Test_Code_Acces
public _Read_IR_Detect
public _RTC_to_ASCII
public _Send_STR_To_Terminal
public _Conv_ItoA
public _Conv_Tab
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

;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
; SP2 -- _Read_Park_IN
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique d’entrée GDD
; Valeur retournée: Bit Carry  0: pas de détection / 1: véhicule détecté 
; Registres modifiés: aucun
;******************************************************************************    

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
	
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP3 -- _Read_Park_OUT
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique d’entrée GDD
; Valeur retournée: Bit Carry  0: pas de détection / 1: véhicule détecté 
; Registres modifiés: aucun
;******************************************************************************    

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
	
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP4 -- _Decod_BIN_to_BCD 
;
; Description: 
;
; Paramètres d'entrée:  R7  – Valeur binaire 8 bits à convertir 
; Valeur retournée: R7 - Code BCD 2 X 4  
;                   si valeur d’entrée <= 63H sinon valeur retournée : FFH. 
; Registres modifiés: aucun
;******************************************************************************   

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
	
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP7 -- _Test_Code_Acces  
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse de Tab_code (Mémoire CODE)
; Paramètre d’entrée :  R5 – Code 6 bits à vérifier (code sur 6 bit de pds faible, 
;                        les 2 bits de pds fort doivent être rendus inopérants,
;                        et donc mis à zéro)
; Valeur retournée: R7 : non nul, il retourne la position du code trouvé dans la table,
;                        nul, il indique que le code n’a pas été trouvé dans la table.
; Registres modifiés: aucun
;******************************************************************************  

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

;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP13 --  _Read_IR_Detect   
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique de d'entrée 
;                                            (Registre GDD en XDATA)
;                      
; Valeur retournée: R7 : contient la valeur des capteurs 
;                        (sur les 4 bits de poids faible).. 
;                       
; Registres modifiés: aucun
;******************************************************************************    
_Read_IR_Detect:
	PUSH DPH
	PUSH DPL
	PUSH ACC
	
	mov DPH,R6
	mov DPL,R7
	MOVX A,@DPTR
	RR A
	ANL A,#0FH
	MOV R7,A	
	
	POP ACC
	POP DPL
	POP DPH
	
	ret

;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP16 -- _RTC_to_ASCII  
;
; Description: 
;
; Paramètres d'entrée:  R7 -  Adresse en IDATA de la variable RTC_Secondes 
;                       R4 (MSB)- R5 (LSB) - – Adresse de la chaine produite en XDATA
;                      
; Valeur retournée: aucune
;                       
;                       
; Registres modifiés: aucun
;******************************************************************************    

_RTC_to_ASCII:
	PUSH DPH
	PUSH DPL
	PUSH ACC
	PUSH AR0
	
	MOV A,R7
	MOV R0,A
	MOV A,@R0
	mov DPH,R4
	mov DPL,R5
	MOV R4,#0h
	MOV R5,#0h
		
	;Comptage nombre de dizaine et d'unité secondes

	CLR C
	DizaineRTCSec:
	SUBB A,#0ah
	INC R4
	JNC DizaineRTCSec
	ADD A,#0ah
	DEC R4
	
	CLR C
	UniteRTCSec:
	SUBB A,#01h
	INC R5
	JNC UniteRTCSec
	DEC R5
	
	;convertion dizaine en ascii
	MOV A,R4
	ADD A,#30h
	MOV R4,A
	
	;convertion unite en ascii
	MOV A,R5
	ADD A,#30h
	MOV R5,A
	
	;Stackage dans la pile pour refaire avec les unités
	
	PUSH AR4
	PUSH AR5
	
	INC R0
	MOV A,@R0
	
	;Comptage nombre de dizaine et d'unité minutes
	MOV R4,#0h
	MOV R5,#0h
	
	CLR C
	DizaineRTCMin:
	SUBB A,#0ah
	INC R4
	JNC DizaineRTCMin
	ADD A,#0ah
	DEC R4
	
	CLR C
	UniteRTCMin:
	SUBB A,#01h
	INC R5
	JNC UniteRTCMin
	DEC R5
	
	;convertion dizaine en ascii
	MOV A,R4
	ADD A,#30h
	MOV R4,A
	
	;convertion unite en ascii
	MOV A,R5
	ADD A,#30h
	MOV R5,A
	
	;ecriture dans xdata
	;dizaine minutes
	MOV A,R4
	MOVX @DPTR,A
	
	;unité minutes
	INC DPTR
	MOV A,R5
	MOVX @DPTR,A
	
	;deux points
	INC DPTR
	MOV A,#3Ah
	MOVX @DPTR,A
	
	POP AR5
	POP AR4
	
	;dizaine secondes
	INC DPTR
	MOV A,R4
	MOVX @DPTR,A
	
	;unité secondes
	INC DPTR
	MOV A,R5
	MOVX @DPTR,A
	
	;0 final
	INC DPTR
	MOV A,#0h
	MOVX @DPTR,A
	
	POP AR0
	POP ACC
	POP DPL
	POP DPH
	
	ret

;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP18 -- _Send_STR_To_Terminal  
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) - Adresse de la chaine à transmettre
;                                              (stockée en XDATA)                                    
;                      
; Valeur retournée: aucune
;                       
;                       
; Registres modifiés: aucun
;******************************************************************************    

_Send_STR_To_Terminal:
	PUSH DPH
	PUSH DPL
	PUSH ACC
	
	mov DPH,R6
	mov DPL,R7
	
	Transmission:
	MOVX A,@DPTR
	MOV R7,A
	call Send_Char
	INC DPTR
	CJNE A,#0h,Transmission
	
	POP ACC
	POP DPL
	POP DPH
	
	ret

;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP19 -- _Conv_ItoA   
;
; Description: 
;
; Paramètres d'entrée:  R7 - – Valeur à convertir
;                                            
;                      
; Valeur retournée: R7 code ASCII des unités
;                   R6 code ASCII des dizaines    
;                       
; Registres modifiés: aucun
;******************************************************************************   

_Conv_ItoA:
	PUSH ACC
	MOV A,R7
	MOV R7,#0h
	MOV R6,#0h
			
	;Comptage nombre de dizaine et d'unité secondes

	CLR C
	DizaineConvItoA:
	SUBB A,#0ah
	INC R6
	JNC DizaineConvItoA
	ADD A,#0ah
	DEC R6
	
	CLR C
	UniteConvItoA:
	SUBB A,#01h
	INC R7
	JNC UniteConvItoA
	DEC R7
	
	;convertion dizaine en ascii
	MOV A,R6
	ADD A,#30h
	MOV R6,A
	
	;convertion unite en ascii
	MOV A,R7
	ADD A,#30h
	MOV R7,A
	
	POP ACC
	
	ret

;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP20 -- _Conv_Tab   
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) Adresse de la table de valeur à convertir
;                       R5 : Indique l’espace mémoire sur lequel pointe l’adresse
;                            passée en R6-R7 R5 = 0 --> XDATA,  R5 !=0  --> CODE
;                       R2 (MSB)- R3 (LSB) - – Adresse de la chaine produite en XDATA                     
;                      
; Valeur retournée: aucune
;                       
;                       
; Registres modifiés: aucun
;******************************************************************************  

_Conv_Tab:
	PUSH DPH
	PUSH DPL
	PUSH ACC
	PUSH AR4
	PUSH AR1
	PUSH AR0
	
	mov DPH,R6
	mov DPL,R7
	
	;lecture du nombre d'éléments dans le tableau
	CJNE R5,#0h,DansCode1
	;DansXdata1
	MOVX A,@DPTR
	JMP NbElement
	DansCode1:
	MOV A,#0h
	MOVC A,@A+DPTR
	
	NbElement:
	;on stock le nombre d'élément dans R4
	MOV R4,A
	
	;lecture des valeurs
	LectureConvEcriture:
	mov DPH,R6
	mov DPL,R7
	INC DPTR
	mov R6,DPH
	mov R7,DPL
	
	CJNE R5,#0h,DansCode2
	;DansXdata1
	MOVX A,@DPTR
	JMP Conversion
	DansCode2:
	MOV A,#0h
	MOVC A,@A+DPTR
	
	
	;conversion binaire to bcd
	Conversion:
	
	CLR C
	DizaineConvTab:
	SUBB A,#0ah
	INC R0
	JNC DizaineConvTab
	ADD A,#0ah
	DEC R0
	
	CLR C
	UniteConvTab:
	SUBB A,#01h
	INC R1
	JNC UniteConvTab
	DEC R1
	
	;dizaines dans R1, unités dans R0
	
	;convertion en ascii et ecriture dans xdata
	mov DPH,R2
	mov DPL,R3
	
	;dizaine
	MOV A,R1
	ADD A,#30h ;ascii
	MOVX @DPTR,A
	INC DPTR
	
	;unité
	MOV A,R0
	ADD A,#30h 
	MOVX @DPTR,A
	INC DPTR
	
	;virgule
	MOV A,#2Ch
	MOVX @DPTR,A
	INC DPTR
	
	mov R2,DPH
	mov R3,DPL
	
	DJNZ R4, LectureConvEcriture
	
	POP AR0
	POP AR1
	POP AR4
	POP ACC
	POP DPL
	POP DPH
	
	ret

	
END
	