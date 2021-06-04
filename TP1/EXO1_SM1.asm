;-----------------------------------------------------------------------------
;  FILE NAME   :  EXO_SM1.asm
;  TARGET MCU  :  C8051F020 
;  DESCRIPTION :  Cette suite d'exercices de base est destinée à faire
;                 découvrir le jeu d'instruction de la famille 8051.
;                 Insérez votre code sous chaque exercice.
;                 A la fin de la séance, vous rendrez ce fichier via E-campus
;                 ou par Email à l'adresse que l'on vous communiquera
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


;EXO 1 : INSTRUCTIONS DE TRANSFERT DE DONNEES

;1.	Initialiser l'accumulateur à 0 (coder les 3 solutions possibles), le registre R0 à FFh et la case d'adresse mémoire 40h de la mémoire RAM interne à 55h.

CLR A
MOV A,#0
MOV 0E0H,#0

MOV R0,#0FFH

MOV 40H,#55H
;2.	Copier le contenu de l'accumulateur dans le registre R1.

MOV R1,A

;3.	Copier le contenu de la mémoire 40h de la RAM interne dans la case 42h de la RAM Interne.

MOV 42H,40H

;4.	Copier le contenu de la mémoire 40h de la RAM interne dans la case D0h de la RAM Interne à accès indirect. Que se passe-t-il si on utilise par erreur l'adressage direct sur D0h?

MOV R1,#0D0H
MOV @R1,40H

;EXO 2 : MANIPULATION DES ESPACES MEMOIRES

;1.	Copier le contenu de 20h (DATA) dans la case mémoire 2FFh en mémoire RAM externe (XDATA).

MOV 20H,#88H
MOV A,20H
MOV DPTR,#2FFH
MOVX @DPTR,A

;2.	Copier le contenu de 0000h (CODE) dans la case mémoire 82h en mémoire RAM interne.

CLR A
MOV DPTR,#0
MOVC A,@A+DPTR
MOV 82H,A

;3.	Copier le contenu de la mémoire 0100h de la XDATA dans la case 43h de la RAM Interne.

MOV DPTR,#0100H
MOVX A,@DPTR
MOV 43H,A

;4.	Copier le contenu de la mémoire 1234h de la mémoire CODE dans la case 0102h de la mémoire XDATA.

MOV A,#34H
MOV DPTR,#1200H
MOVC A,@A+DPTR
MOV DPTR,#0102H
MOVX @DPTR,A

;EXO 3 : INSTRUCTIONS ARITHMETIQUES - ARITHMETIQUE NON SIGNEE

;1.	Incrémenter l'accumulateur de 1.

INC A

;2.	Décrémenter de 1 l'octet d'adresse 33h de la RAM Interne.

DEC 33H

;3.	Echanger le contenu de B avec le contenu de la mémoire 07FFh en mémoire externe (XDATA).

MOV R3,B
MOV DPTR,#07FFH
MOVX A,@DPTR

MOV B,A
MOV A,R3
MOVX @DPTR,A

;4.	En une ligne de code, échanger le contenu de A avec le contenu de la mémoire 60h.

XCH A,60H

;EXO 4 : INSTRUCTIONS LOGIQUES - MANIPULATION de BITS

;1.	Complémenter le bit d'adresse 10h. Ou se trouve-t-il ? (c'est le bit X de l'octet d'adresse YY dans la mémoire DATA).

MOV A,10H
CPL A
MOV 10H,A

;2.	Mettre à 1, les bits 0 et 7  de l'octet d'adresse 22h de la RAM interne (sans changer les autres bits).

SETB 10H
SETB 17H

;3.	Mettre à 1, les bits 0 et 7 du registre R0 (sans changer les autres bits).

MOV R0,#7EH
MOV 22H,R0
SETB 10H
SETB 17H
MOV R0,22H

;4.	Mettre à 1, les bits 0 et 7 de l'octet d'adresse 07ffh de la XDATA (sans changer les autres bits)

MOV DPTR,#07FFH
MOVX A,@DPTR
MOV 22H,A
SETB 10H
SETB 17H
MOV A,22H
MOVX @DPTR,A

;EXO 5 : INSTRUCTIONS DE SAUT CONDITIONNEL ET INCONDITIONNE

;1.	Placez une valeur quelconque dans R3, incrémentez la jusqu'à ce qu'elle atteigne la valeur B6h (pensez à initialiser R3).

MOV R3,#28H
Increment: INC R3
CJNE R3,#0B6H,Increment

;2.	Remplir la mémoire RAM interne de l'adresse 20h à 40h avec des codes ASCII égrainant l'alphabet.

MOV R0,#20H
MOV A,#41H
Adressage: MOV @R0,A
INC R0
INC A
CJNE R0,#41H,Adressage


;3.	Lire le contenu de l'adresse 0000h à 0002h dans l'espace code et le copier à l'adresse 0000h à 0002h de l'espace XDATA.

MOV DPTR,#0000H
MOV R0,#00H
Copie: CLR A
MOVC A,@A+DPTR
MOVX @DPTR,A
INC DPTR
INC R0
CJNE R0,#003H,Copie

;EXO 6 : MANIPULATION DES BANCS de REGISTRES R0-R7

;1.	Commuter le banc de registres R0-R7 sur le banc 2 et copier le contenu de A dans le registre R4 sans utiliser "R4" dans l'instruction.

SETB RS0
CLR	RS1
MOV A,#15H
MOV 0CH,A

;2.	Mettre à zéro la case d'adresse 08h de la ram interne en utilisant un adressage par registre (utiliser un registre R0...R7).



;EXO 7 : INSTRUCTIONS LOGIQUES - MANIPULATION de BITS - 2 

;1.	Décaler le registre B d'une case vers la gauche, le bit6 devient bit7, le bit5 devient bit6, etc. le bit7 devient bit0.

;2.	Exécuter une rotation logique gauche sur le DPTR, le bit 15 devient le bit 0. (Initialiser auparavant le DPTR avec la valeur 0F0Fh).


;EXO 8 : INSTRUCTIONS ARITHMETIQUES - Arithmétique non signée - 2 

;1.	Incrémenter de 2 la case mémoire RAM externe d'adresse 100h.

;2.	Multiplier les données en RAM interne d'adresse 22h et 23h. Placer le résultat en 24h(LSB) et 25h(MSB).



;EXO 9 : INSTRUCTIONS DE SAUT CONDITIONNEL ET INCONDITIONNEL - 2 

;1.	Remplir la mémoire RAM externe (XDATA) de l'adresse 120h à 140h avec des codes ASCII égrainant l'alphabet.

;2.	Incrémentez le DPTR initialisé avec une valeur quelconque jusqu'à la valeur de A B C D h.



;EXO 10 : Exercices d'approfondissement - FACULTATIF

;1.	Additionner les registres R6 et R7, stocker le résultat dans R5. Quelles sont les limitations ? Pour s'affranchir des limitations précédentes, refaire la même opération mais stocker le résultat dans R4 (LSB) et R5(MSB).

;2.	Faire l'opération R0 moins R1 et placer le résultat dans R7. Que se passe t'il si R1>R0 ?

;3.	Complémenter le demi-octet de pds faible de l'adresse 2Ah de la RAM interne.

;4.	Placez une valeur quelconque dans R3, décrémentez la, jusqu'à ce qu'elle atteigne une valeur contenue dans R6 (pensez à initialiser R3 et R6).

;5.	Initialiser les registres R4 et R5 respectivement avec les valeurs 0Fh et F5h. Faites un OU Exclusif entre ces deux registres et placez le résultat dans l'accumulateur.

;6.	Stocker le demi-octet de poids faible de la case mémoire d'adresse 44h de la RAM interne dans les deux demi-octets du registre R4 (si la case 44h contient 17h, alors R4 devra contenir 77h).

;7.	Elever au carré le contenu de l'octet 12h, placer le résultat dans R0 (pds fort) et R1 (pds faible).

;8.	Soit 2 nombres BCD de 16 bits (valeur 0 à 9999) stockés respectivement dans R0(MSB)-R1(LSB) et R2(MSB)-R3(LSB). Faire l'addition BCD de ces deux nombres, et stocker le résultat dans R4(MSB)-R5(LSB). La retenue sera dans le bit Carry du registre PSW.

;9.	Compter le nombre de bits à 1 dans le registre B et stocker le résultat dans R5.

;10. Diviser le contenu du registre R7 par le nombre 10, placer le quotient dans R5 et le reste dans R6.




;******************************************************************************
;******************************************************************************
; NE PAS MODIFIER LES DIRECTIVES et INSTRUCTIONS SUIVANTES:
;******************************************************************************
  
bcl:   jmp bcl
;-----------------------------------------------------------------------------
; End of file.

END



