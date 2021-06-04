;-----------------------------------------------------------------------------
;  FILE NAME   :  CODE3_TP2.asm
;  TARGET MCU  :  C8051F020  
;  A FAIRE:

; IMPORTANT: � chaque fois qu'apparait "Concluez" vous devez ajouter dans ce fichier
; des explications sous forme de commentaire.

; - Tester le programme sans rien modifier.  V�rifier que le tri effectu�
;   par le sous-programme est correctement ex�cut�.
;   (la compr�hension de l'algo et du codage en assembleur de ce sosu-programme
;    n'est pas indispensable dans ce TP)
;   V�rifier que le sous-programme fonctionne bien, revient � s'assurer que les points 
;   suivants sont corrects:
;     - 1: les informations plac�es dans la zone m�moire � trier sont toujours
;          pr�sentes dans cette zone m�moire et sont en plus tri�es dans un ordre
;          croissant (arihm�tique non sign�e
;		OUI tout roule
;     -2: le retour de sous-programme est correct, c'est � dire qu'apr�s l'instruction
;         RET du sous-programme, on �x�cuter bien l'insruction du programme principal
;         placer juste  apr�s le CALL
;		Ca aussi �a fonctionne bien

; - D�commenter le second call Tri_Tab (ligne 65). 100?
; - Tester l'ex�cution du second Tri_tab 
; - Sur ce second Tri_Tab, vous devriez constater pas mal de probl�mes, perte
;   de l'adresse de retour, donn�es du tableau mal tri�es, voire modifi�es...
; - Concluez: quels sont les probl�mes rencontr�s? 
; La pile �crase les donn�es : impossible de trier

; - Analyser le probl�me et sans toucher au contenu du sous-programme, ajouter 
;   une ligne de code dans le programme principal pour r�soudre le probl�me
; - Une piste de r�flexion: la pile occupe une partie de la m�moire IDATA, mais 
;   quelle zone occupe-t-elle? ELLE OCCUPE DATA !
;-  Expliquez la nature de votre modification e tpourquoi vous la faites.
;
; - Concluez:  bilan global de cet exercice - Quelles sont les r�gles imp�ratives
;              � respecter quand vous mettez en oeuvre des sous-programmes? Pas �craser les donn�es avec la pile


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
;******************************************************************************
; Programme Principal
;******************************************************************************
Main:    
		mov WDTCN, #0DEh    
        mov WDTCN, #0ADh
		mov A,#0FFH
		
		;--------------
		;Initialisation du pointeur de pile dans un endroit o� il ne pose pas probl�me (entre 10H et 4FH
		MOV SP,#80H
		;--------------
	
		
BCL:    mov 50H,#22H  ; Remplissage de la m�moire de 50H � 57H
		mov 51H,#11H  ; pour tester Tri_tab
		mov 52H,#34H
		mov 53H,#07H
		mov 54H,#01H
		mov 55H,#10H
		mov 56H,#02H
		mov 57H,#09H

		mov R7,#50h	  ; Param�tres pass�s au sous-programme Tri_tab
		mov R5,#08h	  ; Adresse de la table: 50H - Taille: 8 octets
		call Tri_tab  ; APPEL SP1

		mov 08H,#22H	; Remplissage de la m�moire de 08H � 0FH
		mov 09H,#11H	; pour tester Tri_tab
		mov 0AH,#34H
		mov 0BH,#07H
		mov 0CH,#01H
		mov 0DH,#10H
		mov 0EH,#02H
		mov 0FH,#09H

     	mov R7,#08h		; Param�tres pass�s au sous-programme Tri_tab
		mov R5,#08h	   ; Adresse de la table: 08H - Taille: 8 octets
		call Tri_tab   ; APPEL SP2
  
        jmp   BCL



;******************************************************************************
; Zone r�serv�e aux Sous programmes
;******************************************************************************

;******************************************************************************
; Tri_tab
;
; Description: Sous-programme permettant le tri d'un tableau de donn�es stock� 
;              dans la m�moire DATA. A l'issue du tri, les donn�es sont class�es
;              dans l'ordre croissant
;
; Param�tres d'entr�e:  R7: adresse du tableau
;						R5: taille du tableau
;     Attention: il faut que R7+R5<= 07FH   
; Param�tres de sortie: aucun
; Registres modifi�s:  4
; Pile: 15 octets 
;******************************************************************************
Tri_tab:                 
         push PSW
		 push ACC
		 push AR0
		 push AR1
		 push AR4
		 push AR5
		 mov A,R7	  ; R�cup�rateur de l'adresse de d�but de tableau
		 mov R0,A	  ; R0 pointeur case de r�f�rence
		 mov R1,A	  
		 inc R1 	   ; R1 pointeur de parcours de table = R0+1
		 add A,R5
		 mov R4,A     ; R4 "pointe" sur la premiere case hors table
BCL1:    mov A,@R0
         clr C
		 subb A,@R1	   ; Comparaison valeur point�e par R0 avec valeur point�e par R1
		 jc  No_exchange ; si [R0] < [R1] alors pas d'�change
		 mov A,@R0		 ; si [R0] >= [R1]  alors �change
		 xch A,@R1		 ; �change effectu�
		 mov @R0,A	     ; suite �change
No_exchange:
         inc R1			 ; incr�ment du pointeur parcours de table
		 mov A,R4	
		 cjne A,AR1,BCL1 ; test pointeur parcours de table hors table?
						 ; si non: retour � BCL1
         inc R0			 ; incr�ment du pointeur case de r�f�rence
		 mov A,R0
		 mov R1,A
		 inc R1			 ; R1 pointeur de parcours de table = R0+1
	 	 mov A,R4	
		 cjne A,AR1,BCL1 ; test pointeur parcours de table hors table?
						 ; si non: retour � BCL1	
		 pop AR5
         pop AR4
         pop AR1
         pop AR0		 
		 pop acc
         pop psw		 
		 ret
;******************************************************************************
END
