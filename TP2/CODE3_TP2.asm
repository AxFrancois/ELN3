;-----------------------------------------------------------------------------
;  FILE NAME   :  CODE3_TP2.asm
;  TARGET MCU  :  C8051F020  
;  A FAIRE:

; IMPORTANT: à chaque fois qu'apparait "Concluez" vous devez ajouter dans ce fichier
; des explications sous forme de commentaire.

; - Tester le programme sans rien modifier.  Vérifier que le tri effectué
;   par le sous-programme est correctement exécuté.
;   (la compréhension de l'algo et du codage en assembleur de ce sosu-programme
;    n'est pas indispensable dans ce TP)
;   Vérifier que le sous-programme fonctionne bien, revient à s'assurer que les points 
;   suivants sont corrects:
;     - 1: les informations placées dans la zone mémoire à trier sont toujours
;          présentes dans cette zone mémoire et sont en plus triées dans un ordre
;          croissant (arihmétique non signée
;		OUI tout roule
;     -2: le retour de sous-programme est correct, c'est à dire qu'après l'instruction
;         RET du sous-programme, on éxécuter bien l'insruction du programme principal
;         placer juste  après le CALL
;		Ca aussi ça fonctionne bien

; - Décommenter le second call Tri_Tab (ligne 65). 100?
; - Tester l'exécution du second Tri_tab 
; - Sur ce second Tri_Tab, vous devriez constater pas mal de problèmes, perte
;   de l'adresse de retour, données du tableau mal triées, voire modifiées...
; - Concluez: quels sont les problèmes rencontrés? 
; La pile écrase les données : impossible de trier

; - Analyser le problème et sans toucher au contenu du sous-programme, ajouter 
;   une ligne de code dans le programme principal pour résoudre le problème
; - Une piste de réflexion: la pile occupe une partie de la mémoire IDATA, mais 
;   quelle zone occupe-t-elle? ELLE OCCUPE DATA !
;-  Expliquez la nature de votre modification e tpourquoi vous la faites.
;
; - Concluez:  bilan global de cet exercice - Quelles sont les règles impératives
;              à respecter quand vous mettez en oeuvre des sous-programmes? Pas écraser les données avec la pile


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
		;Initialisation du pointeur de pile dans un endroit où il ne pose pas problème (entre 10H et 4FH
		MOV SP,#80H
		;--------------
	
		
BCL:    mov 50H,#22H  ; Remplissage de la mémoire de 50H à 57H
		mov 51H,#11H  ; pour tester Tri_tab
		mov 52H,#34H
		mov 53H,#07H
		mov 54H,#01H
		mov 55H,#10H
		mov 56H,#02H
		mov 57H,#09H

		mov R7,#50h	  ; Paramètres passés au sous-programme Tri_tab
		mov R5,#08h	  ; Adresse de la table: 50H - Taille: 8 octets
		call Tri_tab  ; APPEL SP1

		mov 08H,#22H	; Remplissage de la mémoire de 08H à 0FH
		mov 09H,#11H	; pour tester Tri_tab
		mov 0AH,#34H
		mov 0BH,#07H
		mov 0CH,#01H
		mov 0DH,#10H
		mov 0EH,#02H
		mov 0FH,#09H

     	mov R7,#08h		; Paramètres passés au sous-programme Tri_tab
		mov R5,#08h	   ; Adresse de la table: 08H - Taille: 8 octets
		call Tri_tab   ; APPEL SP2
  
        jmp   BCL



;******************************************************************************
; Zone réservée aux Sous programmes
;******************************************************************************

;******************************************************************************
; Tri_tab
;
; Description: Sous-programme permettant le tri d'un tableau de données stocké 
;              dans la mémoire DATA. A l'issue du tri, les données sont classées
;              dans l'ordre croissant
;
; Paramètres d'entrée:  R7: adresse du tableau
;						R5: taille du tableau
;     Attention: il faut que R7+R5<= 07FH   
; Paramètres de sortie: aucun
; Registres modifiés:  4
; Pile: 15 octets 
;******************************************************************************
Tri_tab:                 
         push PSW
		 push ACC
		 push AR0
		 push AR1
		 push AR4
		 push AR5
		 mov A,R7	  ; Récupérateur de l'adresse de début de tableau
		 mov R0,A	  ; R0 pointeur case de référence
		 mov R1,A	  
		 inc R1 	   ; R1 pointeur de parcours de table = R0+1
		 add A,R5
		 mov R4,A     ; R4 "pointe" sur la premiere case hors table
BCL1:    mov A,@R0
         clr C
		 subb A,@R1	   ; Comparaison valeur pointée par R0 avec valeur pointée par R1
		 jc  No_exchange ; si [R0] < [R1] alors pas d'échange
		 mov A,@R0		 ; si [R0] >= [R1]  alors échange
		 xch A,@R1		 ; échange effectué
		 mov @R0,A	     ; suite échange
No_exchange:
         inc R1			 ; incrément du pointeur parcours de table
		 mov A,R4	
		 cjne A,AR1,BCL1 ; test pointeur parcours de table hors table?
						 ; si non: retour à BCL1
         inc R0			 ; incrément du pointeur case de référence
		 mov A,R0
		 mov R1,A
		 inc R1			 ; R1 pointeur de parcours de table = R0+1
	 	 mov A,R4	
		 cjne A,AR1,BCL1 ; test pointeur parcours de table hors table?
						 ; si non: retour à BCL1	
		 pop AR5
         pop AR4
         pop AR1
         pop AR0		 
		 pop acc
         pop psw		 
		 ret
;******************************************************************************
END
