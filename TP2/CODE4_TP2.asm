;-----------------------------------------------------------------------------
;  FILE NAME   : CODE4_TP2.asm
;  TARGET MCU  :  C8051F020
;  A FAIRE:
;
; IMPORTANT: � chaque fois qu'apparait "Concluez" vous devez ajouter dans ce fichier
; des explications sous forme de commentaire.
; - Tester le programme - V�rifier le calcul correct de la factorielle
; - Concluez : Pour chaque essai (1,2 et 3) indiquez les �l�ments suivants:
;          + taille maximale occup�e par la pile en octet
;          + zone m�moire occup�e par la pile (de la m�moire d'adresse XX
;            � la m�moire d'adresse YY)
;          + d�tailler le contenu de la pile (il ne s'agit pas de recopier
;            le contenu de la pile, mais d'expliquer � quoi ils correspondent)
;          + expliquer � quelle moment la pile a une tailole maximale

; - Concluez ou plut�t expliquez la consigne de segmentation relative � la pile
;   lignes 45 � 50 (voir Poly "Doc TP" chapitre "Macra assembleur 8051")
; - Concluez: quels commentaires pouvez-vous faire sur la consigne de segmentation
;   de la pile donn�e et sur l'utilisation effective de la file dans cet exercice
;   Proposez une solution corrective.
;  
;   Concluez - bilan de cet exercice - quels sont les r�gles � d�duire de ct exercice
;   au sujet de la gestion de la pile? 
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
		mov SP,#seg_stack-1 ; la pile pointe sur le segment stack_seg (20 octets)
	
Main_BCL:	
; Essai 1 de SP_Factorial 
		mov  R7,#2
        call SP_Factorial 
        MOV  A,R7

; Essai 2 de SP_Factorial 
		mov  R7,#5
        call SP_Factorial 
        MOV  A,R7
		
; Essai 3 de SP_Factorial 
		mov  R7,#12
        call SP_Factorial 
        MOV  A,R7		

Main_no_carry:		
         jmp   Main_BCL



;******************************************************************************
; Zone r�serv�e aux Sous programmes
;******************************************************************************

;******************************************************************************
; SOUS-PROGRAMME SP_Factorial
;
; Description: Sous-programme de calcul de Factorielle
;
; Param�tres d'entr�e:  R7: valeur de factorielle � calculer
;						
;     
; Param�tres de sortie: R7 R�sultat du calcul de factorielle
; Registres modifi�s:  ?
; Pile: ? octets 
;******************************************************************************

;******************************************************************************	  
SP_Factorial:
       PUSH PSW
	   PUSH B
	   PUSH ACC
	   MOV A,R7
	   ACALL Fact
	   MOV R7,A
	   POP ACC
	   POP B
	   POP PSW
	   RET
;FIN SP SP_Factorial   
;******************************************************************************
Fact:  DEC R7
       CJNE R7,#01,Suit_Fact  ;value of R0 is compared with 1
       SJMP End_Fact          ;if R0=1, Fin SP Fact
Suit_Fact:
	   MOV B,R7
       MUL AB
       ACALL FACT ;calling back the same function
	   NOP
End_Fact:
       RET
;FIN SP Fact
;******************************************************************************	   
END
