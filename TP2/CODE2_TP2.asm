;-----------------------------------------------------------------------------
;  FILE NAME   : CODE2_TP2.asm
;  TARGET MCU  :  C8051F020
;  A FAIRE:

; IMPORTANT: à chaque fois qu'apparait "Concluez" vous devez ajouter dans ce fichier
; des explications sous forme de commentaire.

; - Tester le programme en laissant en commentaire les 2 appels
;   de sous-programme (les 2 CALL en commentaire)
;   Visualiser l'évolution de XDATA en faisant une exécution avec points d'arrêt 
;   (Placer le point d'arrêt sur le MOVX du programme principal
;   et faites des "run" successifs pour observer le remplissage progressif de la XDATA 
;   à partir de l'adresse 0
;   Concluez: Le programme principal rempli la mémoire XDATA de 0 à FF.

; - Décommenter les 2 lignes qui appellent les sous-programmes et tester de 
;   nouveau le code. S'assurer que le Sous-Programme strlen_CODE fonctionne correctement
;   Mais, le fonctionnement du programme principal devrait être affecté, la mémoire
;   XDATA ne se remplissant plus comme prévu
;   Concluez: que se passe t'il désormais dans la XDATA?

; - Analyser le problème et intervenir sur le contenu du sous-programme pour 
;   résoudre le problème
;   Concluez: expliquez le problème et la méthode de résolution adoptée 

; - Une piste de réflexion: Vu du programme appelant, le sous-programme ne doit
;   pas modifier le contenu de registres. Il faut donc que le SP les sauvegarde 
;   au début de son exécution et les restore à la fin. Comme lieu de stockage,
;   pensez "pile"...
;
; - Après les modifications, testez le bon fonctionnement du programme principal
;   et du sous-programme.
; 
; - Concluez: quelles sont les règles à mettre en place quand on code un sous-programme
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
; CODE SEGMENT
;-----------------------------------------------------------------------------


Prog_base      segment  CODE

               rseg     Prog_base      ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.

CPE: db'CPE LYON',0
ELN3: db'Bienvenue en TP ELN3',0
 	
;******************************************************************************
; Programme Principal
;******************************************************************************
Main:
		mov WDTCN, #0DEh    
        mov WDTCN, #0ADh
		MOV DPTR,  #0
		mov A,#0	
		mov R4,#0
		mov R5,#1
Main_BCL:	
; Essai 1 de strlen_CODE
        mov  R6,#High(CPE)  ; Partie haute de l'adresse CPE
		; Pour la signification des expressions HIGH et LOW, regarder dans l'aide en ligne
		; de microvision à la Rubrique:
		; "Ax51 Assembly User's Guide/Writing Assembly Programs/Expressions and Operators/Operators"
		mov  R7,#Low(CPE)   ; Partie basse de l'adresse CPE
        call strlen_CODE
        MOV  A,R7
		ADD  A,R4
		mov  R4,A
; Essai 2 de strlen_CODE	
        mov  R6,#High(ELN3)  ; Partie haute de l'adresse CPE
		mov  R7,#Low(ELN3)   ; Partie basse de l'adresse CPE
        call strlen_CODE
        MOV  A,R7
		ADD  A,R4
		mov  R4,A
; Ecriture dans XDATA		
        MOV  A,R5  
        MOVX @DPTR,A
        INC DPTR
		INC R5
Main_no_carry:		
         jmp   Main_BCL

;******************************************************************************
; Zone réservée aux Sous programmes
;******************************************************************************

;******************************************************************************
; SOUS-PROGRAMME strlen_CODE
;
; Description: Sous-programme de determination de la longueur d'une chaine de 
;              caractère stockée dans l'espace CODE. La taille calculée ne tient 
;              pas compte du caractère NULL (0)
;
; Paramètres d'entrée:  R6-R7: Adresse de la chaine (R6 poids fort, R7 poids faible)
;						
;     
; Paramètres de sortie: R7 Taille de la chaine
; Registres modifiés:  3 (4 avec PSW)
; Pile: 14 octets 
;******************************************************************************
strlen_CODE:

	  PUSH AR5
	  PUSH ACC 
	  PUSH DPH
	  PUSH DPL
	  PUSH PSW

      mov DPH,R6
      mov DPL,R7
      mov R5,#0FFH
BCL1_strlen_CODE:
      inc R5
      mov A,R5
      movc A,@A+DPTR  
      jnz BCL1_strlen_CODE
	  mov R7,AR5           ; même chose que mov R7,05H
	  
	  POP PSW
	  POP DPL
	  POP DPH
	  POP ACC
	  POP AR5

	  ret
; FIN SP strlen_CODE
;******************************************************************************	  

END
