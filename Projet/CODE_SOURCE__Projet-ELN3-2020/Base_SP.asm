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
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique d�entr�e GCA
; Valeur retourn�e: R7 : contient la valeur du code lu (sur les 6 bits de poids faible). 
; Registres modifi�s: aucun
;******************************************************************************    

_Read_code:
              ; ins�rez le code du sous-programme ici
              RET
;******************************************************************************    			  
			  
;******************************************************************************                
; SP2 -- _Read_Park_IN
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique d�entr�e GDD
; Valeur retourn�e: Bit Carry  0: pas de d�tection / 1: v�hicule d�tect� 
; Registres modifi�s: aucun
;******************************************************************************    

_Read_Park_IN:
              ; ins�rez le code du sous-programme ici
              RET
;******************************************************************************    						  
			  
;******************************************************************************                
;  SP3 -- _Read_Park_OUT
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique d�entr�e GDD
; Valeur retourn�e: Bit Carry  0: pas de d�tection / 1: v�hicule d�tect� 
; Registres modifi�s: aucun
;******************************************************************************    

_Read_Park_OUT:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 

;******************************************************************************                
;  SP4 -- _Decod_BIN_to_BCD 
;
; Description: 
;
; Param�tres d'entr�e:  R7  � Valeur binaire 8 bits � convertir 
; Valeur retourn�e: R7 - Code BCD 2 X 4  
;                   si valeur d�entr�e <= 63H sinon valeur retourn�e : FFH. 
; Registres modifi�s: aucun
;******************************************************************************    

_Decod_BIN_to_BCD:
              ; ins�rez le code du sous-programme ici
              RET
			  
;****************************************************************************** 
;******************************************************************************                
; SP5 --  _Decod_BCD_to_7Seg
;
; Description: 
;
; Param�tres d'entr�e:  R7  � Valeur BCD  2X4 bits � convertir
;                       R5  - Choix du digit � convertir 
;                              � 0 : digit Unit�s - != 0 : digit Dizaines
;                       R2 (MSB)- R3 (LSB) � Adresse de la table Display_7S 
;                                            en m�moire CODE
; Valeur retourn�e: R7 - Code 7 segments (Bit 0-Segment a __ Bit6-Segment g). 
;                   
; Registres modifi�s: aucun
;******************************************************************************    

_Decod_BCD_to_7Seg:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** ;******************************************************************************                
;  SP6 -- _CDE_Display  
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique de sortie Registre AFF
; Param�tre d�entr�e :  R5 � Code 7 segments (Bit 0-Segment a __ Bit6-Segment g)
; Param�tre d�entr�e :  R3 � Commande de s�lection du digit : 
;                       si R3= 0, S�lection du Digit Dizaines, 
;                       si R3 non nul : S�lection    du digit Unit�s
; Valeur retourn�e: R7 : contient une recopie de la valeur envoy�e au registre AFF 
; Registres modifi�s: aucun
;******************************************************************************    

_CDE_Display:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 

;******************************************************************************                
;  SP7 -- _Test_Code_Acces  
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse de Tab_code (M�moire CODE)
; Param�tre d�entr�e :  R5 � Code 6 bits � v�rifier (code sur 6 bit de pds faible, 
;                        les 2 bits de pds fort doivent �tre rendus inop�rants,
;                        et donc mis � z�ro)
; Valeur retourn�e: R7 : non nul, il retourne la position du code trouv� dans la table,
;                        nul, il indique que le code n�a pas �t� trouv� dans la table.
; Registres modifi�s: aucun
;******************************************************************************    

_Test_Code_Acces:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 

;******************************************************************************                
;  SP8 -- _Stockage_Code 
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse de Tab_histo (en XDATA)
; Param�tre d�entr�e :  R5 � Information 8 bits � enregistrer
;                      (code sur les 6 bits de poids faible, les 2 bits de pds fort 
;                        sont mis � z�ro)
; Valeur retourn�e: R7 : non nul, il retourne le nombre d�enregistrements,
;                        nul, il indique que la table est pleine (100 enregistrements). 
; Registres modifi�s: aucun
;******************************************************************************    

_Stockage_Code:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 

;******************************************************************************                
;  SP9 -- _CDE_Barr
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique de sortie 
;                                            (Registre MISC en XDATA)
; Param�tre d�entr�e :  R5 � 0 : barri�re ferm�e, != Barri�re ouverte
;                      
; Valeur retourn�e: R7 : contient une recopie de la valeur envoy�e au registre MISC
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_CDE_Barr:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;******************************************************************************                
;  SP10 -- _CDE_FeuRouge 
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique de sortie 
;                                            (Registre MISC en XDATA)
; Param�tre d�entr�e :  : R5 � =0 --> feu �teint, !=0 --> feu allum�
;                      
; Valeur retourn�e: R7 : contient une recopie de la valeur envoy�e au registre MISC
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_CDE_FeuRouge:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 

;****************************************************************************** 
;******************************************************************************                
;  SP11 -- _CDE_FeuVert 
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique de sortie 
;                                            (Registre MISC en XDATA)
; Param�tre d�entr�e :  : R5 � =0 --> feu �teint, !=0 --> feu allum�
;                      
; Valeur retourn�e: R7 : contient une recopie de la valeur envoy�e au registre MISC
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_CDE_FeuVert:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP12 -- _Read_BP_Alarm  
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique de d'entr�e 
;                                            (Registre GDD en XDATA)
;                      
; Valeur retourn�e: Bit C (Bit Carry) du registre PSW: 0 si bouton non activ�, 
;                                                      1 si bouton press�
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Read_BP_Alarm:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP13 --  _Read_IR_Detect   
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique de d'entr�e 
;                                            (Registre GDD en XDATA)
;                      
; Valeur retourn�e: R7 : contient la valeur des capteurs 
;                        (sur les 4 bits de poids faible).. 
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Read_IR_Detect:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP14 --_Read_DP_1TO16    
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse du p�riph�rique de sortie
;                                            (Registre G en XDATA)
;                      
; Valeur retourn�e: R7 : contient la valeur des capteurs 
;                        (sur les 4 bits de poids faible).. 
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Read_DP_1TO16:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP15 --_Gestion_RTC     
;
; Description: 
;
; Param�tres d'entr�e:  R7  � Adresse en IDATA de la variable RTC_Centiemes
;                                            
;                      
; Valeur retourn�e: aucune
;                       
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Gestion_RTC:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP16 -- _RTC_to_ASCII  
;
; Description: 
;
; Param�tres d'entr�e:  R7 -  Adresse en IDATA de la variable RTC_Secondes 
;                       R4 (MSB)- R5 (LSB) - � Adresse de la chaine produite en XDATA
;                      
; Valeur retourn�e: aucune
;                       
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_RTC_to_ASCII:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP17 -- _Concat_String   
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) - � Adresse de la chaine 1 en XDATA
;                       R4 (MSB)- R5 (LSB) - � Adresse de la chaine 2 en XDATA
;                       R2 (MSB)- R3 (LSB) - � Adresse de la chaine produite (1+2) en XDATA
;                      
; Valeur retourn�e: aucune
;                       
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Concat_String :
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP18 -- _Send_STR_To_Terminal  
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) - Adresse de la chaine � transmettre
;                                              (stock�e en XDATA)                                    
;                      
; Valeur retourn�e: aucune
;                       
;                       
; Registres modifi�s: aucun
;******************************************************************************    
_Send_STR_To_Terminal:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP19 -- _Conv_ItoA   
;
; Description: 
;
; Param�tres d'entr�e:  R7 - � Valeur � convertir
;                                            
;                      
; Valeur retourn�e: R7 code ASCII des unit�s
;                   R6 code ASCII des dizaines    
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Conv_ItoA:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP20 -- _Conv_Tab   
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) Adresse de la table de valeur � convertir
;                       R5 : Indique l�espace m�moire sur lequel pointe l�adresse
;                            pass�e en R6-R7 R5 = 0 --> XDATA,  R5 !=0  --> CODE
;                       R2 (MSB)- R3 (LSB) - � Adresse de la chaine produite en XDATA                     
;                      
; Valeur retourn�e: aucune
;                       
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Conv_Tab:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP21 -- _Tri_Tab_histo 
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse de Tab_histo (en XDATA)
;                                        
;                      
; Valeur retourn�e: aucune
;                       
;                       
; Registres modifi�s: aucun
;******************************************************************************    

_Tri_Tab_histo :
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP22 -- _Extract_Tab_histo 
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse de Tab_histo (en XDATA)
;                       R4 (MSB)- R5 (LSB) � Adresse de Tab_histo_code (en XDATA)
;                       R2 (MSB)- R3 (LSB) � Adresse de Tab_histo_nbre (en XDATA)
;                                    
; Valeur retourn�e: aucune
;                                           
; Registres modifi�s: aucun
;******************************************************************************    

_Extract_Tab_histo:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
;****************************************************************************** 
;******************************************************************************                
;  SP23 -- _String_code_nbre
;
; Description: 
;
; Param�tres d'entr�e:  R6 (MSB)- R7 (LSB) � Adresse de String_dest (en XDATA) (adresse de la chaine destination)
;                       R4 (MSB)- R5 (LSB) � Adresse de Tab_histo_code (en XDATA)
;                       R2 (MSB)- R3 (LSB) � Adresse de Tab_histo_nbre (en XDATA)
;                    
; Valeur retourn�e: aucune
;                          
; Registres modifi�s: aucun
;******************************************************************************    

_String_code_nbre:
              ; ins�rez le code du sous-programme ici
              RET
;****************************************************************************** 
END



