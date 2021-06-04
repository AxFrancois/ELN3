;-----------------------------------------------------------------------------
;  FILE NAME   :  Demo_tp_SM1
;  TARGET MCU  :  C8051F020 
;  DESCRIPTION :  Ce programme fait clignoter une LED placée sur P1.6 et
;                 réalise des lectures-Ecritures dans les mémoires
;  Ver: 30-04-2018
;-----------------------------------------------------------------------------
$include (c8051f020.inc)               ; Include register definition file.
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
GREEN_LED      equ   P1.6              ; Port I/O pin connected to Green LED.
Counter        equ	 40H
;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------
               ; Reset Vector
               cseg AT 0
               ljmp Code_Test          ; Locate a jump to the start of code at 
                                       ; the reset vector.
;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
Blink          segment  CODE

               rseg     Blink          ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.
Msg:   DB 'TP_ELN3!__'                 ; Stockage en CODE d'une chaine de caractères  
	
; ****************************************************************************
; Code de configuration bas-niveau du 8051F020
; La compréhension de ces 5 lignes de code n'est pas utile au TP
 Code_Test:    mov   WDTCN, #0DEh ; Dévalidation Watchdog
               mov   WDTCN, #0ADh 
               mov   XBR2, #40h   ; Activation des GPIO
               orl   P1MDOUT,#40h ; P1.6  en PushPull
               clr   GREEN_LED
			   mov   Counter,#0
			   
			   
; ****************************************************************************
; BOUCLE LECTURE - ECRITURE en MEMOIRE
; Pour comprendre: visualiser les espaces CODE et XDATA à partir des adresses 0
; Commande: "View" "Memory Windows" - Forcer l'affichage en mode ASCII
DEB:		   clr   A
               inc   counter
			   mov   dptr,#Msg
			   mov   R0,#0AH
BCL_RD_WR:	   clr   A
               movc A,@A+DPTR
			   movx @dptr,A
			   inc  dptr
			   djnz R0,BCL_RD_WR
			   
; QUESTIONS:  Que fait l'instruction DJNZ?
;             Que fait l'instruction MOVX?
;             Que fait l'instruction MOVC?
;             Espace mémoire source? Espace Mémoire Destination? 
;             Adresses source? Adresses Destination? 
;             Combien d'octets copiés?
; ****************************************************************************
; TEMPORATION
               mov   DPTR,#0      
BCL_Tempo:	   inc   DPTR
               nop
			   nop
			   MOV   A,DPH
			   cjne A,#080H,BCL_Tempo
			   
; QUESTIONS: Que fait l'instruction CJNE?
;            Que fait l'instruction NOP? 
;            Quel est la durée de la temporisation en nombre de cycles d'horloge?
; ****************************************************************************
; CHANGEMENT D'ETAT LED VERTE	
; La compréhension de cette lignes de code n'est pas utile au TP
               cpl   GREEN_LED         ; Toggle LED
			                      		   
; ****************************************************************************
; RE-INITIALISATION ZONE MEMOIRE			   
			   mov   dptr,#Msg
			   mov   R0,#0AH
BCL_RAZ_X:	   clr A
               movx @dptr,A
			   inc  dptr
			   djnz R0,BCL_RAZ_X
; ****************************************************************************
; BOUCLE INFINIE	   
               jmp   DEB
; QUESTIONS: Que fait l'instrucion JMP?
;-----------------------------------------------------------------------------
; End of file.
END



