;-----------------------------------------------------------------------------
;  FILE NAME   : CODE5_TP2.asm
;  TARGET MCU  :  C8051F020
;  A FAIRE:
; - Coder les sous-programmes memchr_xdata, toint et small_atoi
;   les sp�cifications de ses sous-programme sont donn�es dans l'ent�te commentaire 
;   de chaque sosu-programme ci-dessous
; - Pour chaque sous-programme, coder dans le programme principal des s�quences
;   de test des sous-programmes (passage de param�tres et r�cup�ration des 
;   r�sultats selon plusieurs sc�narios 
;-----------------------------------------------------------------------------
$include (c8051f020.inc)               ; Include register definition file.
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
GREEN_LED      equ   P1.6              ; Port I/O pin connected to Green LED.
;-----------------------------------------------------------------------------
; Declarations Externes
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------

               ; Reset Vector
               cseg AT 0          ; SEGMENT Absolu
               ljmp Main     ; Locate a jump to the start of code at 
                             ; the reset vector.
;-----------------------------------------------------------------------------
; DATA SEGMENT
;-----------------------------------------------------------------------------
 
Tab_zone       SEGMENT DATA     
               RSEG    Tab_zone  
Table_2:       DS 	20
;-----------------------------------------------------------------------------
; IDATA SEGMENT
;--------------------------------------------------------------------------
seg_stack       SEGMENT IDATA           ; seg_stack goes into IDATA RAM.
                RSEG    seg_stack          ; switch to seg_stack segment.
                DS      12              ; reserve 12 bytes in this example.
					
;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
Prog_base      segment  CODE

               rseg     Prog_base      ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code
CPE: db'CPE LYON',0
ELN3: db'Bienvenue en TP ELN3',0
 	
;******************************************************************************
; Programme Principal
;******************************************************************************
Main:

      
		mov WDTCN, #0DEh    
        mov WDTCN, #0ADh
		
;******************************************************************************	
Main_BCL:	
;******************************************************************************		
; Essai 1 de memchr_xdata
		
; INSERER CODE DE TEST

; Essai 2 de memchr_xdata
		
; INSERER CODE DE TEST
	

;******************************************************************************		
; Essai 1 de UINT16_ADD_CHK
		
; INSERER CODE DE TEST

; Essai 2 de UINT16_ADD_CHK
		
; INSERER CODE DE TEST

;******************************************************************************	
; Essai 1 de toint 
		
; INSERER CODE DE TEST

; Essai 2 de toint 
		
; INSERER CODE DE TEST

;******************************************************************************		
; Essai 1 de small_atoi
		
; INSERER CODE DE TEST

; Essai 2 de small_atoi
		
; INSERER CODE DE TEST		
		

;******************************************************************************
       jmp   Main_BCL

		  
;******************************************************************************
; Zone r�serv�e aux Sous programmes
;******************************************************************************


;******************************************************************************
; SOUS-PROGRAMME memchr_xdata     
; 
; Niveau de difficult�: Facile
;
; Description: le SP memchr_xdata recherche la premi�re occurence d'une valeur "VAL"
;              dans un tableau "TAB" en m�moire XDATA et ce, 
;              dans les premiers N �l�ments de ce tableau
;
; Param�tres d'entr�e:  R6(High)-R7(low): adresse de "TAB" en XDATA (adresse du premier
;                       �l�ment de ce tableau)
;                       R5: valeur � rechercher
;                       R3: Taille du tableau
;                       
;						
;     
; Param�tres de sortie: R6(High)-R7(low):  adresse de la premi�re case m�moire
;                       qui contient "VAL" dans "TAB"           
; Registres modifi�s:  Aucun autre que R7,R6,R5,R3
;  
;******************************************************************************

;******************************************************************************	  
memchr_xdata:
     
;FIN memchr_xdata
;******************************************************************************	

;******************************************************************************
; UINT16_ADD_CHK - SOUS-PROGRAMME Addition de 2 nombres 16 bits
;
;  Niveau de difficult�: Facile

; Description: Sous-programme charg� d'additionner 2 nombres de 16 bits non sign�s
;              argument1 + argument2 = R�sultat
;              Avant d'additionner, le sous-programme doit v�rifier les conditions
;              suivantes :
;              argument1 < 8000H et  argument2 < 8000H
;              Si une des conditions n'est pas respect�e alors R�sultat = FFFFH 
;
; Param�tres d'entr�e:  R6-R7: argument1  (R6 poids fort, R7 poids faible)
;                       R4-R5: argument2  (R4 poids fort, R5 poids faible)
;						
;     
; Param�tres de sortie: R�sultat sur R6-R7 (R6 poids fort, R7 poids faible)
; Registres modifi�s:  ?
; Pile: ? octets 
;******************************************************************************
UINT16_ADD_CHK:





; FIN UINT16_ADD_CHK

; FIN UINT16_ADD
;******************************************************************************
******************************************************************************
; SOUS-PROGRAMME toint
; 
; Niveau de difficult�: Moyen
;
; Description: ce SP convertit une valeur hexad�cimale "val" contenant une valeur
;              de 0 � F en un code ASCII correspondant � ce chiffre
;              Ex: un octet contenant 0x0A est transform� en un code ASCII 0x41 ('A')
;              Si val est en dehors de la gamme 0-F alors la valeur retourn�e sera 0xFF 
; Param�tres d'entr�e:  R7 - valeur � convertir "Val"
;                       
;						
; Param�tres de sortie: R7: Code ASCII ou valeur 0XFF si val hors plage
;                       
; Registres modifi�s:  Aucun autre que R7
;  
;******************************************************************************
;******************************************************************************	  
toint:
     
	 
	 
	 
;FIN toint
;******************************************************************************	

;
;******************************************************************************
; SOUS-PROGRAMME small_atoi
; 
; Niveau de difficult�: Difficile
;;
; Description: small_atoi convertit une chaine "STRING" de 4 caract�res ascii contenant
;              des chiffres de 0 � 9 en un nombre entier de 16 bits
;              Le premier �l�ment de la chaine correspond au chiffre de poids
;              le plus �lev�. Ce nombre de 4 chiffres sera consid�r� comme un nombre en base10
;
;              Ex: si la chaine contient "1234" alors l'entier produit sera 0x04D2
;               (1234 = 4D2H)
;              Si un ou plusieurs caract�res de la chaine string n'est pas un code
;              ASCII compris entre '0' (0x30) et '9' (0x39' alors la valeur retourn�e
;              sera 0xFFFF
; Param�tres d'entr�e:  R6(High)-R7(low): - adresse de STRING
;                       R5 Espace m�moire contenant STRING
;                            Si 0: IDATA
;                            Si 1: XDATA
;						     Si >1: CODE

; Param�tres de sortie: R6(High)-R7(low): Valeur enti�re convertie de 0X0000 
;                                         � 0x270F (9999 en base 10) ou 0xFFFF
;                                         si STRING hors sp�cification
;                       
; Registres modifi�s:  Aucun autre que R7,R6,R5
;  
;******************************************************************************
;******************************************************************************	  
small_atoi:
     
	 
	 
	 
;FIN small_atoi
;******************************************************************************	
END
