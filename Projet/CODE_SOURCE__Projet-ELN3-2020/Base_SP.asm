;-----------------------------------------------------------------------------
;
;  FILE NAME   :  BASE_SP.ASM 
;  TARGET MCU  :  C8051F020 
;  
;-----------------------------------------------------------------------------
$include (c8051f020.inc)               ; Include register definition file. 
$INCLUDE(Proj_ELN3.INC)	
;-----------------------------------------------------------------------------
;******************************************************************************
;Declaration des variables et fonctions publiques
;******************************************************************************
;;PUBLIC   _Read_code
;PUBLIC   _Read_Park_IN
;PUBLIC   _Read_Park_OUT
;PUBLIC   _Decod_BIN_to_BCD
;;PUBLIC   _Decod_BCD_to_7Seg
;;PUBLIC   _CDE_Display
;PUBLIC   _Test_Code_Acces
;;PUBLIC   _Stockage_Code
;;PUBLIC	 _CDE_Barr
;;PUBLIC   _CDE_FeuRouge
;;PUBLIC   _CDE_FeuVert
;;PUBLIC   _Read_BP_Alarm
;PUBLIC   _Read_IR_Detect
;;PUBLIC   _Read_DP_1TO16
;;PUBLIC   _Gestion_RTC
;PUBLIC   _RTC_to_ASCII
;;PUBLIC   _Concat_String
;PUBLIC	 _Send_STR_To_Terminal
;PUBLIC	 _Conv_ItoA
;PUBLIC   _Conv_Tab
PUBLIC   _Tri_Tab_histo
PUBLIC   _Extract_Tab_histo
PUBLIC   _String_code_nbre

;******************************************************************************
;Declaration des variables et fonctions Externes
;******************************************************************************
EXTRN code (__tempo,Config_Timer3_BT_10ms,Init_pgm,Config_UART0) 
EXTRN code (Putchar_UART0,Getchar_UART0,Send_Char)	; Source Lib_Proj_ELN3
Extrn code (Display_7S,Tab_code)
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
; SP1 -- _Read_code
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique d’entrée GCA
; Valeur retournée: R7 : contient la valeur du code lu (sur les 6 bits de poids faible). 
; Registres modifiés: aucun
;******************************************************************************    

_Read_code:
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** ;******************************************************************************                
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
;******************************************************************************    

_CDE_Display:
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 

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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 

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
;******************************************************************************    

_CDE_Barr:
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
;******************************************************************************                
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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 

;****************************************************************************** 
;******************************************************************************                
;  SP11 -- _CDE_FeuVert 
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

_CDE_FeuVert:
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP12 -- _Read_BP_Alarm  
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse du périphérique de d'entrée 
;                                            (Registre GDD en XDATA)
;                      
; Valeur retournée: Bit C (Bit Carry) du registre PSW: 0 si bouton non activé, 
;                                                      1 si bouton pressé
;                       
; Registres modifiés: aucun
;******************************************************************************    

_Read_BP_Alarm:
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
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
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
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

_Concat_String :
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
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
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP21 -- _Tri_Tab_histo 
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse de Tab_histo (en XDATA)
;                                        
;                      
; Valeur retournée: aucune
;                       
;                       
; Registres modifiés: aucun
;******************************************************************************    

_Tri_Tab_histo :
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP22 -- _Extract_Tab_histo 
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse de Tab_histo (en XDATA)
;                       R4 (MSB)- R5 (LSB) – Adresse de Tab_histo_code (en XDATA)
;                       R2 (MSB)- R3 (LSB) – Adresse de Tab_histo_nbre (en XDATA)
;                                    
; Valeur retournée: aucune
;                                           
; Registres modifiés: aucun
;******************************************************************************    

_Extract_Tab_histo:
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP23 -- _String_code_nbre
;
; Description: 
;
; Paramètres d'entrée:  R6 (MSB)- R7 (LSB) – Adresse de String_dest (en XDATA) (adresse de la chaine destination)
;                       R4 (MSB)- R5 (LSB) – Adresse de Tab_histo_code (en XDATA)
;                       R2 (MSB)- R3 (LSB) – Adresse de Tab_histo_nbre (en XDATA)
;                    
; Valeur retournée: aucune
;                          
; Registres modifiés: aucun
;******************************************************************************    

_String_code_nbre:
              ; insérez le code du sous-programme ici
              RET
;****************************************************************************** 
END



