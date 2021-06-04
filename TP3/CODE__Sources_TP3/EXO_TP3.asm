;-----------------------------------------------------------------------------
;  FILE NAME   :  EXO_TP3.asm
;  TARGET MCU  :  C8051F020 
;  DESCRIPTION :  
;                 
;******************************************************************************
;******************************************************************************
; NE PAS MODIFIER LES DIRECTIVES et INSTRUCTIONS SUIVANTES:
;******************************************************************************
$include (c8051f020.inc)               ; Include register definition file.
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
GREEN_LED      equ   P1.6              ; Port I/O pin connected to Green LED.
;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------

               ; Reset Vector
               cseg AT 0
               ljmp Main               ; Locate a jump to the start of code at 
                                       ; the reset vector.

;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
Blink          segment  CODE

               rseg     Blink        ; Switch to this code segment.
               using    0            ; Specify register bank for the following
                                     ; program code.

Table_ex:          db  'VOILA UN EXEMPLE DE CHAINE A COPIER!!!'


;Initialisations de périphériques - Fonctionnalités Microcontroleur

Main:          ; Disable the WDT. (IRQs not enabled at this point.)
               ; If interrupts were enabled, we would need to explicitly disable
               ; them so that the 2nd move to WDTCN occurs no more than four clock 
               ; cycles after the first move to WDTCN.
               mov   WDTCN, #0DEh
               mov   WDTCN, #0ADh
               ; Enable the Port I/O Crossbar
               mov   XBR2, #40h
               ; Set P1.6 (LED) as digital output in push-pull mode.  
               orl   P1MDIN, #40h	 
               orl   P1MDOUT,#40h 
; Programme Principal
;******************************************************************************
;******************************************************************************
; VOUS POUVEZ FAIRE des MODIFICATIONS A PARTIR D'ICI
;******************************************************************************

; ESPACE POUR INSERER DU CODE

;******************************************************************************
;******************************************************************************
; NE PAS MODIFIER LES DIRECTIVES et INSTRUCTIONS SUIVANTES:
;******************************************************************************
  
bcl:   jmp bcl
;-----------------------------------------------------------------------------
; End of file.

END



