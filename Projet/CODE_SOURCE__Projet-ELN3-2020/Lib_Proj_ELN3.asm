;******************************************************************************
;Lib_TP_SM.asm

;   Ce fichier contient des définitions et des routines utiles au TP SM4
;   Aucune modification n'est nécessaire.
;   Il suffit d'ajouter ce fichier à votre Projet
;   TARGET MCU  :  C8051F020 
;******************************************************************************
$INCLUDE(C8051F020.INC)	; Register definition file.
$INCLUDE(Proj_ELN3.INC)	
;******************************************************************************
;Declaration des variables et fonctions publiques
;******************************************************************************
PUBLIC   Config_Timer3_BT_10ms
PUBLIC   __tempo
PUBLIC   Init_pgm
PUBLIC   Config_UART0
PUBLIC   Putchar_UART0
PUBLIC  Getchar_UART0
PUBLIC  Send_Char
;******************************************************************************
;Consignes de segmentation
;******************************************************************************
zone_data     segment  DATA
              rseg     zone_data
exemple:       DS       1

Lib_Proj_ELN3     segment  CODE
			  rseg     Lib_Proj_ELN3     ; Switch to this code segment.
              using    0             ; Specify register bank for the following
                                     ; program code.

;******************************************************************************
;Initialisations de la mémoire code - Stockage de constante
;******************************************************************************

;******************************************************************************
;Init_pgm
;
; Description: Initialisations de périphériques
;              Fonctionnalités Microcontroleur
;              Configuration accès mémoire sur P4,5,6 et 7
;              Acces en mode multiplexé.
;              Sorties en Push-Pull sauf pour P4 en Drain ouvert
;              

; Paramètres d'entrée: Aucun
; Paramètres de sortie: Aucun
; Registres modifiés: Beaucoup!!!  En fait les registres de config du
;                                  circuit 
;                                 
; Pile: 0 octet (sauf pour l'appel de la sous -routine)
;******************************************************************************
Init_pgm:
         mov WDTCN, #0DEh    ; Disable WDT
         mov WDTCN, #0ADh
; Configure the XBRn Registers
    ; P0.0  -  TX0 (UART0), Push-Pull,  Digital
    ; P0.1  -  RX0 (UART0), Open-Drain, Digital
    ; P0.2  -  TX1 (UART1), Push-Pull,  Digital
    ; P0.3  -  RX1 (UART1), Open-Drain, Digital
    ; P0.4  -  INT0 (Tmr0), Open-Drain, Digital
    ; P0.5  -  INT1 (Tmr1), Open-Drain, Digital
    ; P0.6  -  SYSCLK,      Push-Pull,  Digital
    ; P0.7  -  Unassigned,  Open-Drain, Digital
		    
         mov  XBR0, #004h
         mov  XBR1, #094h
         mov  XBR2, #044h

; Port configuration (1 = Push Pull Output)
         mov P0MDOUT,#045h   ; Output configuration for P0 
         mov P1MDOUT,#0FFh   ; Output configuration for P1 - Tout en Push-Pull
         mov P2MDOUT,#000h   ; Output configuration for P2 
         mov P3MDOUT,#000h   ; Output configuration for P3 
		 orl P3,#80H         ; P3.7 en entrée pour gstion INT7
         mov P74OUT,#0FFh    ; P4, P5, P6 et P7 configurés en Push Pull
         mov P1MDIN,#0FFh    ; Pas d'entrée analogique sur P1
         mov P4,#0DFh        ; ALE à 0 en dehors des cycles mémoires

; Configure External Memory Configuration
         mov EMI0CF, #026h   ; External Memory Configuration Register
         mov EMI0TC, #0BAh   ; External Memory Configuration Register

; Oscillator Configuration
         mov OSCXCN, #067h   ; External Oscillator Control Register	
         clr A               ;osc
         djnz ACC, $         ;wait for
         djnz ACC, $         ;at least 1ms
OX_WAIT:
         mov A, OSCXCN
         jnb ACC.7, OX_WAIT  ;poll XTLVLD
         mov OSCICN, #008h   ; Internal Oscillator Control Register
                             ; On bascule sur l'oscillateur externe 
                             ; à 22118400            
         mov RSTSRC, #000h   ; Reset Source Register
         ret

;******************************************************************************
; Gestion du Timer 3
; Routines permettant de mettre en oeuvre le timer 3
;
;******************************************************************************

;******************************************************************************                
; Config_Timer3_BT
;
; Description: Sous-programme configurant le Timer3 pour fonctionner en
;              Re-chargement automatique. Le timer va générer un overflow 
;              toutes les ((65535-N) * 0.542) micro-secondes 
;              (Avec SYSCLK = 22,1184 MHz)
;              ;Interruption Timer3 autorisée - Priorié basse
;
; Paramètres d'entrée:  N dans R6(MSB) et R7(LSB)
; Paramètres de sortie: aucun
; Registres modifiés: TMR3RLL,TMR3RLH,TMR3H,TMR3L,TMR3CN
; Pile: 0 octet (sauf pour l'appel de la sous -routine)
;******************************************************************************
; ATTENTION!!!   Il est impératif de remettre à zéro, par programme, le 
;*************   Timer3 Overflow Flag.  
;******************************************************************************

Config_Timer3_BT:


         mov TMR3RLL, R7   ; Timer 3 Reload Register Low Byte
         mov TMR3RLH, R6   ; Timer 3 Reload Register High Byte
         mov TMR3H, R6     ; Timer 3 High Byte
         mov TMR3L, R7     ; Timer 3 Low Byte
         mov TMR3CN, #004h ; Timer 3 Control Register
		 orl EIE2,#00000001B ; Int Timer 3 validée
		 anl EIP2,#11111110B  ; Priorité basse sut INT Timer3
        ret
;******************************************************************************                
; Config_Timer3_BT_10ms
;
; Description: Sous-programme configurant le Timer3 pour fonctionner en
;              Re-chargement automatique avec une récurrence de 10ms
;              Interruption Timer3 autorisée- Priorié basse
;              Valable pour SYSCLK: 22,1184 MHz
;          
; Paramètres d'entrée:  aucun
; Paramètres de sortie: aucun
; Registres modifiés: TMR3RLL,TMR3RLH,TMR3H,TMR3L,TMR3CN
; Pile: 0 octet (sauf pour l'appel de la sous -routine)
;******************************************************************************
; ATTENTION!!!   Il est impératif de remettre à zéro, par programme, le 
;*************   Timer3 Overflow Flag.  
;******************************************************************************

Config_Timer3_BT_10ms:

         mov TMR3RLL, #0H   ; Timer 3 Reload Register Low Byte
         mov TMR3RLH,#0B8H   ; Timer 3 Reload Register High Byte
         mov TMR3H, #0B8H    ; Timer 3 High Byte
         mov TMR3L, #00H     ; Timer 3 Low Byte
         mov TMR3CN, #004h ; Timer 3 Control Register
		 orl EIE2,#00000001B ; Int Timer 3 validée
		 anl EIP2,#11111110B  ; Priorité basse sut INT Timer3
         ret

;******************************************************************************                
; Config_UART0
;
; Description: Configuration de UART0
;              Fonctionnement en asynchrone à 115200 baud
;              Utilisation du Timer 1 comme source horloge
; Paramètres d'entrée:  aucun
; Paramètres de sortie: aucun
; Registres modifiés: 
; Pile: 0 octet (sauf pour l'appel de la sous -routine)
;******************************************************************************
; ATTENTION!!!   Il est impératif de remettre à zéro, par programme, le 
;*************   Timer3 Overflow Flag.  
;******************************************************************************
Config_UART0:
    mov  CKCON,     #010h ;Disable Baud rate/2 
    mov  TCON,      #040h ; Config Timer1
    mov  TMOD,      #020h
    mov  TH1,       #0F4h ; Baud rate = 115200 Bd avec CLK = 22118400
UART_Init:
    mov  PCON,      #080h
    mov  SCON0,     #072h
    ret

;******************************************************************************                
; Putchar_UART0
;
; Description: Envoi d'un caractère sur la liaison UART0
;            
;              
; Paramètres d'entrée:  R7 - caractère à emettre 
; Paramètres de sortie: aucun
; Registres modifiés: 
; Pile: 0 octet (sauf pour l'appel de la sous -routine)
;******************************************************************************
Putchar_UART0:
Send_Char:
        JNB   TI,Putchar_UART0
		CLR   TI 
		MOV   SBUF0,R7
        ret
;******************************************************************************                
; Getchar_UART0
;
; Description: Lecture du caractère reçu sur l'UART0
;            
;              
; Paramètres d'entrée:  aucun 
; Paramètres de sortie: R7 contient le caractère reçu. 
; si pas de caractère reçu alors valeur retournée = FFH
; Registres modifiés: 
; Pile: 0 octet (sauf pour l'appel de la sous -routine)
;******************************************************************************
Getchar_UART0:
        JNB    RI,Getchar_UART0_no_char_received
		CLR    RI
		MOV   R7,SBUF0
        JMP   END_Getchar_UART0
Getchar_UART0_no_char_received:
        MOV   R7,#0FFH
END_Getchar_UART0:
        RET		
;******************************************************************************
;******************************************************************************
; __tempo
;
; Description: Sous -programme produisant une temporisation logicielle
;              paramétrable par la variable csg_tempo.
;              La temporisation générée est égale à csg_tempo micro-secondes.
;              ATTENTION: csg_tempo ne doit pas être inférieure à 2
;
; Paramètres d'entrée:  csg_tempo dans R6(MSB) et R7(LSB)
; Paramètres de sortie: aucun
; Registres modifiés: R6 et R7
; Pile: 2 octets 
;******************************************************************************
__tempo:
        PUSH  ACC
        MOV   A,R5
        PUSH  ACC
        MOV  A,R7
        DEC  R7
        JNZ   ?C0006
        DEC   R6
?C0006:
?C0001:
         MOV  A,R7
         ORL  A,R6
         JZ   ?C0005

         MOV  A,R7
         DEC  R7
         JNZ  ?C0007
         DEC  R6
?C0007:
         MOV  R5,#01H
?C0003:
         MOV  A,R5
         JZ   ?C0001
         DEC  R5
         SJMP ?C0003
?C0005:
         POP ACC
         MOV R5,ACC
         POP ACC
         RET  	
      
end