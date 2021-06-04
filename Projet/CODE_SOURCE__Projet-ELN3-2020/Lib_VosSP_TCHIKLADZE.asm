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

PUBLIC   _Stockage_Code
PUBLIC   _Read_DP_1TO16
	
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

;******************************************************************************                
;  SP8 -- _Stockage_Code 
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse de Tab_histo (en XDATA)
; Paramètre d’entrée :  R5 – Information 8 bits à enregistrer
;                      (code sur les 6 bits de poids faible, les 2 bits de pds fort 
;                        sont mis à zéro)
; Valeur retournée: R7 : non nul, il retourne le nombre d’enregistrements,
;                        nul, il indique que la table est pleine (100 enregistrements). 
; Registres modifiés: aucun
;******************************************************************************    

_Stockage_Code:
              PUSH PSW
			  PUSH ACC
			  PUSH DPL
			  PUSH DPH
			  
			  MOV DPH, R6
			  MOV DPL, R7
			  
			  MOVX A,@DPTR
			  SUBB A,#96H ;On soustrait 96h (150) à l'accumulateur
			  JZ Table_full ; si A est nul on veut retourner 0
			  MOVX A,@DPTR
			  INC A ; On va toujours stocker a une valeur au dessu
			  MOVX @DPTR, A ; on stock la nouvelle valeur d'index
			  MOV R7,A ; R7 est notre varibale de sorti
			  
Incr_dptr:    INC DPTR
			  DEC A
			  JNZ Incr_dptr
			  
Stock:        MOV A, R5 ; On stock le code dans ACC 
			  MOVX @DPTR, A ; et on le deplace danas la valeur correspondate
			  
			  POP DPL
			  POP DPH
			  POP ACC
			  POP PSW
			  
			  RET	   
			  
			 
Table_full:   MOV R7,#00H
			  POP DPL
			  POP DPH
			  POP ACC
			  POP PSW
			  
			  
              RET
;****************************************************************************** 
;******************************************************************************                
;  SP14 --_Read_DP_1TO16    
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique de sortie
;                                            (Registre G en XDATA)
;                      
; Valeur retournée: R7 : contient la valeur des capteurs 
;                        (sur les 4 bits de poids faible).. 
;                       
; Registres modifiés: aucun
;******************************************************************************    

_Read_DP_1TO16:
              PUSH PSW
			  PUSH ACC
			  PUSH DPL
			  PUSH DPH
			  PUSH AR3
			  PUSH AR2
			  PUSH AR1
			  
			  mov DPL, R7 ;Adresse du Registre GCP
			  MOV DPH, R6
			  MOVX A,@DPTR 
			  CLR ACC.0 ; on place CLK a 0
			  CLR ACC.1 ; on place /LD a 0
			  MOVX @DPTR, A ; on envoie nos infos
			  SETB ACC.1
			  MOVX @DPTR, A ;
			  MOV R3, #00H
			  MOV R2, #00H
			  MOV R1,#00H ; R1 permettera de savoir a quel capteur nous en sommes
Inc_CLK:      
			  mov DPL, R5 ;Adresse du Registre GDD
			  MOV DPH, R4
			  MOVX A,@DPTR ; registre GDD dans A
			  CLR C
			  MOV C,ACC.6
			  
			
			  MOV A, R2
			  RRC A ; je fais une rotation vers la droite, en mettant ma carry comme premier element et e dernier dans ma carry
			  MOV R2, A
			  MOV A,R3
			  RRC A ; je fais une rotation vers la droite, en mettant ma carry comme premier element et e dernier dans ma carry
			  MOV R3,A
			  
			  mov DPL, R7 ;Adresse du Registre GCP
			  MOV DPH, R6
			  MOVX A,@DPTR
			  SETB ACC.0
			  MOVX @DPTR, A ; on envoie nos infos
			  CLR ACC.0
			  MOVX @DPTR, A ; on envoie le GCP
			  INC R1
			  CJNE R1, #10H, Inc_CLK ; On souhaite arreter quand R1 = 16
			  
			 
			  
			  POP AR1
			  POP AR2
			  POP AR3
			  POP DPH
			  POP DPL
			  POP ACC
			  POP PSW
              RET
;****************************************************************************** 

; INSERER les codes des spous-programmes ici en allant récupérer les squelettes
; de sous-programme dans le fichier Base_SP.asm
; Ne pas oublier d'importer la déclaration Public qui va avec....


END



