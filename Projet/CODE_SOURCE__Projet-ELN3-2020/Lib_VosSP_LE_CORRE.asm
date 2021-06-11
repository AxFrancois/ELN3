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
PUBLIC   _CDE_Display
PUBLIC	 _CDE_Barr
PUBLIC   _Read_BP_Alarm
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

;  SP6 -- _CDE_Display  
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique de sortie Registre AFF
; Paramètre d’entrée :  R5 – Code 7 segments (Bit 0-Segment a __ Bit6-Segment g)
; Paramètre d’entrée :  R3 – Commande de sélection du digit : 
;                       si R3= 0, Sélection du Digit Dizaines, 
;                       si R3 non nul : Sélection    du digit Unités
; Valeur retournée: R7 : contient une recopie de la valeur envoyée au registre AFF 
; Registres modifiés: aucun

_CDE_Display:

		PUSH ACC ; Sauvegarde de ACC dans pile
		PUSH PSW
		PUSH DPL
		PUSH DPH
		
		CLR A
		MOV DPL,R7
		MOV DPH,R6
		MOV A,R5
		CJNE R3,#00h,non_nul; Compare la valeur de R3 avec 0, jump si ce n'est pas egal
		CLR ACC.7
		MOVX @DPTR, A
		MOV R7, A
		
		JMP fin_display
	
		
		non_nul: 
		SETB ACC.7
		MOVX @DPTR, A
		MOV R7, A
		
		fin_display:
		POP DPH
		POP DPL
		POP PSW
		POP ACC
		
		RET;
		
		
		

;******************************************************************************                
;  SP9 -- _CDE_Barr
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique de sortie 
;                                            (Registre MISC en XDATA)
; Paramètre d’entrée :  R5 – 0 : barrière fermée, != Barrière ouverte
;                      
; Valeur retournée: R7 : contient une recopie de la valeur envoyée au registre MISC
;                       
; Registres modifiés: aucun	

_CDE_Barr:
		
		PUSH ACC ; Sauvegarde de ACC dans pile
		PUSH PSW
		PUSH DPL
		PUSH DPH
		
		CLR A
		
		MOV DPL,R7; On met les poids faibles dans R7
		MOV DPH,R6; On met les poids forts dans R6
		MOV A,R5
		CJNE A,#00h,non_nul_barr; Compare la valeur de A avec 0, jump si ce n'est pas egal
		
		CLR ACC.2;	Clear bit 2 de ACC
		MOVX @DPTR, A
		MOV R7, A
		JMP fin_CDE_Barr
		
		non_nul_barr: 
		SETB ACC.2;	Passe à 1 le bit 2 de ACC
		MOVX @DPTR, A
		MOV R7, A
		
		fin_CDE_Barr:
		
		POP DPH
		POP DPL
		POP PSW
		POP ACC
		RET

;******************************************************************************                
;  SP12 -- _Read_BP_Alarm  
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique d'entrée 
;                                            (Registre GDD en XDATA)
;                      
; Valeur retournée: Bit C (Bit Carry) du registre PSW: 0 si bouton non activé, 
;                                                      1 si bouton pressé
;                       
; Registres modifiés: aucun	


_Read_BP_Alarm:

		PUSH ACC ; Sauvegarde de ACC dans pile
		PUSH PSW
		PUSH DPL
		PUSH DPH
		
		CLR A
		MOV DPL,R7; On met les poids faibles dans R7
		MOV DPH,R6; On met les poids forts dans R6
		
		MOVX A,@dptr 
		ANL A,#20h
		JZ BP_Alarm_0 ;Jump si accumulateur est à 0
		SETB C; Passe le bit de carry a 1
		
		JMP fin_BP_Alarm
		
		BP_Alarm_0:
		CLR C
		fin_BP_Alarm:
		
		RET
;		
END



