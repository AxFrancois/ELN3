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

PUBLIC   _Read_code
PUBLIC   _Decod_BCD_to_7Seg
PUBLIC   _Gestion_RTC
PUBLIC   _Concat_String
PUBLIC   _CDE_FeuRouge
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
; SP1 -- _Read_code
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique d’entrée GCA
; Valeur retournée: R7 : contient la valeur du code lu (sur les 6 bits de poids faible). 
; Registres modifiés: aucun
;******************************************************************************    
_Read_code:
              push ACC
			  push psw
			  mov dph, r6
			  mov dpl, r7
			  movx A,@DPTR
			  RR A
			  clr acc.7
			  clr acc.6
			  mov R7,A
			  pop psw
			  pop ACC
			  RET
;******************************************************************************    
;******************************************************************************                
; SP5 --  _Decod_BCD_to_7Seg
;
; Description: 
;
; Paramètres d'entrée:  R7  – Valeur BCD  2X4 bits à convertir
;                       R5  - Choix du digit à convertir 
;                              – 0 : digit Unités - != 0 : digit Dizaines
;                       R2 (MSB)- R3 (LSB) – Adresse de la table Display_7S 
;                                            en mémoire CODE
; Valeur retournée: R7 - Code 7 segments (Bit 0-Segment a __ Bit6-Segment g). 
;                   
; Registres modifiés: aucun
;******************************************************************************    

_Decod_BCD_to_7Seg:
              PUSH PSW; on incremente la pille
			  PUSH ACC
			  
			  MOV DPH, R2; adresse de la table
			  MOV DPL, R3
			  
			  MOV A, R5 ;On stock le choix du digit (0 => unité, 1=> dizaine)
			  JZ unite
			  JNZ dizaine
			  
			  unite: 
			  MOV A, R7
			  ANL A, #0FH ; on suprome les "dizaine"
			  ljmp fin
			  
			  dizaine:
			  MOV A, R7
			  SWAP A   ; inverse dizaines et unités
			  ANL A, #0FH ; on suprome les "dizaine"
			  ljmp fin
			  
			  fin:
			  MOVC A, @A+DPTR; On lit dans la table + la valeur du digit
			  ;CLR ACC.6; on clear le bit de point fort
			  MOV R7, A; on stock dans R7
			  
			  POP ACC
			  POP PSW
              RET


;  SP15 --_Gestion_RTC     
;
; Description: 
;
; Paramètres d'entrée:  R7  – Adresse en IDATA de la variable RTC_Centiemes
;                                            
;                      
; Valeur retournée: aucune
;                       
;                       
; Registres modifiés: aucun
;******************************************************************************    

_Gestion_RTC:
              PUSH AR7
			  PUSH ACC
			  PUSH AR0
			  PUSH AR1
			  
			  MOV AR0, AR7
			  MOV A, @R0
			  INC A
			  MOV AR1, AR0
			  
			  inc_centiemes:
			  MOV AR0, AR1

			  INC @R0
			  MOV A, @R0
			  CJNE A, #64H , inc_centiemes
			  
			  SUBB A, #64H
			  JZ reset_centiemes
			  
			  reset_centiemes:
			  CLR A
			  MOV @R0, A
			  INC R0
			  ljmp inc_secondes
			  
			  inc_secondes:
			  INC @R0
			  MOV A, @R0
			  CJNE A,#3CH , inc_centiemes
			  
			  SUBB A, #3CH
			  JZ reset_secondes
			  
			  reset_secondes:
			  CLR A
			  MOV @R0, A
			  INC R0
			  ljmp inc_minutes
			  
			  
			  inc_minutes:
			  INC @R0
			  MOV A, @R0
			  CJNE A,#3CH , inc_centiemes
			  
			  SUBB A, #3CH
			  JZ reset_minutes
			  
			  reset_minutes:
			  CLR A
			  MOV @R0, A
			  
			  POP AR1
			  POP AR0
			  POP ACC
			  POP AR7
              RET
			  
;  SP17 -- _Concat_String   
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) - – Adresse de la chaine 1 en XDATA
;                       R4 (MSB)- R5 (LSB) - – Adresse de la chaine 2 en XDATA
;                       R2 (MSB)- R3 (LSB) - – Adresse de la chaine produite (1+2) en XDATA
;                      
; Valeur retournée: aucune
;                       
;                       
; Registres modifiés: aucun
;******************************************************************************    

_Concat_String:
              PUSH PSW; on incremente la pille
			  PUSH ACC
			  PUSH DPL
			  PUSH DPH
			  
			chaine_1: 
				MOV DPH, R6; adresse de la chaine 1 
				MOV DPL, R7
				MOVX A, @DPTR
				
				INC DPTR
				MOV R6, DPH
				MOV R7, DPL
				
				JNZ  chaine1_1_2
				JZ  chaine_2
			
			
			chaine1_1_2:
				MOV DPH, R2; adresse de la chaine 1 
				MOV DPL, R3
				MOVX @DPTR, A
				
				INC DPTR
				MOV R2, DPH
				MOV R3, DPL
				
				jmp chaine_1
		
					
			  chaine_2: 
				MOV DPH, R4; adresse de la chaine 1 
				MOV DPL, R5
				MOVX A, @DPTR
				
				INC DPTR
				MOV R4, DPH
				MOV R5, DPL
				JNZ  chaine2_1_2
				JZ  ajout_zeros
				
			chaine2_1_2:
				MOV DPH, R2; adresse de la chaine 1 
				MOV DPL, R3
				MOVX @DPTR, A
				
				INC DPTR
				MOV R2, DPH
				MOV R3, DPL
				
				jmp chaine_2
			
			ajout_zeros:
				CLR A
				MOVX @DPTR, A
				
				
			  POP DPH
			  POP DPL
			  POP ACC
			  POP PSW
              RET

;  SP10 -- _CDE_FeuRouge 
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique de sortie 
;                                            (Registre MISC en XDATA)
; Paramètre d’entrée :  : R5 – =0 --> feu éteint, !=0 --> feu allumé
;                      
; Valeur retournée: R7 : contient une recopie de la valeur envoyée au registre MISC
;                       
; Registres modifiés: aucun
;******************************************************************************    

_CDE_FeuRouge:

			  PUSH ACC
			  PUSH PSW
	
			  
              MOV DPH, R6
			  MOV DPL, R7
			  MOV A, R5
			  
			  JZ feu_eteint
			 	  
			  feu_allume:
			  MOVX A, @DPTR
			  SETB ACC.0
			  MOVX @DPTR, A
			  MOV R7,A
			  jmp retour
			  
			  feu_eteint:
			  MOVX A, @DPTR
			  CLR ACC.0
			  MOVX @DPTR, A
			  MOV R7,A
			  
			  retour:
			  
			  POP PSW
			  POP ACC
              RET
;****************************************************************************** 



END



