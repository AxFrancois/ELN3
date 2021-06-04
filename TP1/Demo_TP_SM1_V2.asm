;-----------------------------------------------------------------------------
;  FILE NAME   :  Demo_tp_SM1_V2
;  TARGET MCU  :  C8051F020 
;  DESCRIPTION :  Ce programme d'initiation ne fait que des accès mémoire
;  Ver: 30-03-2020
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
$include (c8051f020.inc)               ; Include register definition file.
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; RESET VECTOR
;-----------------------------------------------------------------------------
               ; Reset Vector
               cseg AT 0
               ljmp Code_Demo          ; Locate a jump to the start of code at 
                                       ; the reset vector.
;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
Demo          segment  CODE
               rseg    Demo          ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.
Msg:   DB 'TP_ELN3!__'                 ; Stockage en CODE d'une chaine de caractères  
Msg2:  DB 'x'	
	
; ****************************************************************************
; Code de configuration bas-niveau du 8051F020
; La compréhension de ces 2 lignes de code n'est pas utile au TP
 Code_Demo:    mov   0FFH, #0DEh ; Dévalidation Watchdog
               mov   0FFH, #0ADh 
                  
;************************************************
			   mov  R1,#33H	  
;************************************************
DEB:           nop     
; BOUCLE ECRITURE dans les registres R0-R7 
               mov  R0,#2    
BCL_WR_Reg:	   mov  @R0,AR1
			   inc  R0
			   inc  R1
			   cjne R0,#8H,BCL_WR_Reg
; BOUCLE ECRITURE d'une chaine de caractères dans l'espace XDATA
; Visualiser les espaces CODE et XDATA à partir des adresses 0
; Commande: "View" "Memory Windows" - Forcer l'affichage en mode ASCII	
			   mov   dptr,#Msg
			   mov   R0,#0AH
BCL_RD_WR:	   clr   A
               movc A,@A+DPTR
			   movx @dptr,A
			   inc  dptr
			   djnz R0,BCL_RD_WR
			   
; BOUCLE Effacement de la  chaine de caractères dans l'espace XDATA
; Commande: "View" "Memory Windows" - Forcer l'affichage en mode ASCII				   
			   mov   dptr,#Msg2
			   mov   R0,#0AH
			   clr   A
			   movc A,@A+DPTR
			   mov   dptr,#Msg 
BCL_RAZ_X:	   movx @dptr,A
			   inc  dptr
			   djnz R0,BCL_RAZ_X
; ****************************************************************************
; BOUCLE INFINIE - Indispensable en mode "exécution sur la carte" 	   
               jmp   DEB

; End of file.
END



