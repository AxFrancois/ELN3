;-----------------------------------------------------------------------------
;  FILE NAME   : CODE2_TP2.asm
;  TARGET MCU  :  C8051F020
;  A FAIRE:

; IMPORTANT: � chaque fois qu'apparait "Concluez" vous devez ajouter dans ce fichier
; des explications sous forme de commentaire.

; - Tester le programme en laissant en commentaire les 2 appels
;   de sous-programme (les 2 CALL en commentaire)
;   Visualiser l'�volution de XDATA en faisant une ex�cution avec points d'arr�t 
;   (Placer le point d'arr�t sur le MOVX du programme principal
;   et faites des "run" successifs pour observer le remplissage progressif de la XDATA 
;   � partir de l'adresse 0
;   Concluez: Le programme principal rempli la m�moire XDATA de 0 � FF.

; - D�commenter les 2 lignes qui appellent les sous-programmes et tester de 
;   nouveau le code. S'assurer que le Sous-Programme strlen_CODE fonctionne correctement
;   Mais, le fonctionnement du programme principal devrait �tre affect�, la m�moire
;   XDATA ne se remplissant plus comme pr�vu
;   Concluez: que se passe t'il d�sormais dans la XDATA?

; - Analyser le probl�me et intervenir sur le contenu du sous-programme pour 
;   r�soudre le probl�me
;   Concluez: expliquez le probl�me et la m�thode de r�solution adopt�e 

; - Une piste de r�flexion: Vu du programme appelant, le sous-programme ne doit
;   pas modifier le contenu de registres. Il faut donc que le SP les sauvegarde 
;   au d�but de son ex�cution et les restore � la fin. Comme lieu de stockage,
;   pensez "pile"...
;
; - Apr�s les modifications, testez le bon fonctionnement du programme principal
;   et du sous-programme.
; 
; - Concluez: quelles sont les r�gles � mettre en place quand on code un sous-programme
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
		; de microvision � la Rubrique:
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
; Zone r�serv�e aux Sous programmes
;******************************************************************************

;******************************************************************************
; SOUS-PROGRAMME strlen_CODE
;
; Description: Sous-programme de determination de la longueur d'une chaine de 
;              caract�re stock�e dans l'espace CODE. La taille calcul�e ne tient 
;              pas compte du caract�re NULL (0)
;
; Param�tres d'entr�e:  R6-R7: Adresse de la chaine (R6 poids fort, R7 poids faible)
;						
;     
; Param�tres de sortie: R7 Taille de la chaine
; Registres modifi�s:  3 (4 avec PSW)
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
	  mov R7,AR5           ; m�me chose que mov R7,05H
	  
	  POP PSW
	  POP DPL
	  POP DPH
	  POP ACC
	  POP AR5

	  ret
; FIN SP strlen_CODE
;******************************************************************************	  

END
