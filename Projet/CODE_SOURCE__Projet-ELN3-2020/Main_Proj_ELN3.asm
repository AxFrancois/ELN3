;-----------------------------------------------------------------------------
;
;  FILE NAME   :  MAIN_SM4.ASM 
;  TARGET MCU  :  C8051F020 
;  

;-----------------------------------------------------------------------------
$include (c8051f020.inc)               ; Include register definition file. 
$include (Proj_ELN3.inc)          ; Include specificregister definition file. 	
;-----------------------------------------------------------------------------
;Declarations Externes
EXTRN code (__tempo,Config_Timer3_BT_10ms,Init_pgm,Config_UART0) 
EXTRN code (Putchar_UART0,Getchar_UART0)	; Source Lib_Proj_ELN3
EXTRN code (DEMO_UART0)  ; Source Lib_Proj_ELN3_Hidden
; SOUS-PROGRAMMES A CODER	
EXTRN code ( _Read_code,_Read_Park_IN,_Read_Park_OUT,_Decod_BIN_to_BCD)
EXTRN code (_Decod_BCD_to_7Seg,_CDE_Display,_Test_Code_Acces,_Stockage_Code)
EXTRN code (_CDE_Barr,_CDE_FeuRouge,_CDE_FeuVert,_Read_BP_Alarm,_Read_IR_Detect)
EXTRN code (_Read_DP_1TO16,_Gestion_RTC,_RTC_to_ASCII,_Concat_String)
EXTRN code (_Send_STR_To_Terminal,_Conv_ItoA,_Conv_Tab,_Tri_Tab_histo)
EXTRN code (_Extract_Tab_histo,_String_code_nbre)	
; Declarations Publiques	
PUBLIC  Display_7S,Tab_code
PUBLIC	MSG_Park_IN,MSG_Park_NOK,MSG_Park_OUT,MSG_Park_Open,MSG_Park_UC
PUBLIC  MSG_Park_Fire,MSG_Start_System,MSG_Tab_Code,MSG_Tab_histo
PUBLIC	MSG_CODE_Nombre,MSG_Free_Places,MSG_Space,MSG_Free,MSG_Occupied
PUBLIC  Tab_histo
PUBLIC  RTC_Centiemes,RTC_Secondes,RTC_Minutes
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
         
; Put the STACK segment in the main module.
;------------------------------------------------------------------------------
?STACK          SEGMENT IDATA           ; ?STACK goes into IDATA RAM.
                RSEG    ?STACK          ; switch to ?STACK segment.
                DS      40              ; reserve your stack space
                                        ; 40 bytes in this example.
;-----------------------------------------------------------------------------
; XDATA SEGMENT
;-----------------------------------------------------------------------------
Ram_externe    SEGMENT XDATA     ; Reservation de x octets en XDATA
	                             ; Taille maximale 4095 octets 
               RSEG    Ram_externe  
Tab_histo:     DS      160
; vous pouvez déclarer les variables supplémentaires ici....

;-----------------------------------------------------------------------------
; IDATA SEGMENT
;-----------------------------------------------------------------------------
Data_Values    SEGMENT IDATA     ; Reservation de x octets en IDATA
               RSEG    Data_Values  
RTC_Centiemes:  DS      1
RTC_Secondes:   DS      1
RTC_Minutes:    DS      1
; vous pouvez déclarer les variables supplémentaires ici....
;-----------------------------------------------------------------------------
; DATA SEGMENT
;-----------------------------------------------------------------------------
zone_data     segment  DATA
              rseg     zone_data
Exemple1:      DS       1
; vous pouvez déclarer les variables supplémentaires ici....
;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------
               ; Reset Vector
               cseg AT 0          ; SEGMENT Absolu
               ljmp Start_pgm     ; Locate a jump to the start of code at 
                                  ; the reset vector.
								  
								  ; Timer3 Interrupt Vector
               cseg AT 073H         ; SEGMENT Absolu
               ljmp ISR_Timer3     ; Locate a jump to the start of code at 
                                  ; the reset vector.
;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
Prog_base      segment  CODE

               rseg     Prog_base      ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.
									   
Tab_code:   DB 0Fh,01h,02h,04h,08h,10h,20h,03h,06h,0CH,18H,30H,07h,0Eh,1CH,38H									   
Display_7S: DB 0BFh,86h,0DBh,0CFh,0E6h,0EDh,0FDh,087h,0FFh,0EFh
	        DB 000h,000h,000h,000h,000h,000h
MSG_Park_IN:      DB " Park IN ",0AH,0DH,0
MSG_Park_NOK:     DB " Park NOK ",0AH,0DH,0
MSG_Park_OUT:     DB " Park OUT ",0AH,0DH,0
MSG_Park_Open:    DB " Park OPEN ",0AH,0DH,0
MSG_Park_UC:      DB " Park Under-Control ",0AH,0DH,0
MSG_Park_Fire:    DB " Fire! Fire! ",0AH,0DH,0
MSG_Start_System: DB " Start_System_Ver1.0",0AH,0DH,0
MSG_Tab_Code:     DB " TAB_CODE: ",0AH,0DH,0
MSG_Tab_histo:    DB " TAB_HISTO: ",0AH,0DH,0
MSG_CODE_Nombre:  DB " CODE-Nombre: ",0AH,0DH,0
MSG_Free_Places:  DB " Free Places ",0AH,0DH,0
MSG_Space:        DB " Space ",0AH,0DH,0
MSG_Free:         DB " Free ",0AH,0DH,0
MSG_Occupied:     DB " Occupied ",0AH,0DH,0
;******************************************************************************
;Initialisations de périphériques - Fonctionnalités Microcontroleur
;******************************************************************************
Start_pgm:
        mov   sp,#?STACK-1   ; Initialisation de la pile
        call Init_pgm        ; Appel SP de configuration du processeur
		clr   GREEN_LED       ; Initialize LED to OFF
		CALL Config_Timer3_BT_10ms ; Configuration du timer 3 - Base de Temps 10ms
		CALL Config_UART0 ; Configuration de l'Uart
		CALL DEMO_UART0   ; Affiche un message sur le terminal
		
		setb EA               ; Validation globale des interruptions
		
;******************************************************************************
; Programme Principal
;******************************************************************************
Main:
	;MOV R6,#80H
	;MOV R7,#00H
	;call _Read_Park_IN
	
	;MOV R6,#80H
	;MOV R7,#00H
	;call _Read_Park_OUT
	
	;MOV R7,#38H
	;call _Decod_BIN_to_BCD
	;MOV R7,#0aH
	;call _Decod_BIN_to_BCD
	;MOV R7,#02H
	;call _Decod_BIN_to_BCD
	;MOV R7,#0CCH
	;call _Decod_BIN_to_BCD
	
	MOV R6,#High Tab_code
	MOV R7,#Low Tab_code
	MOV R5,#38H
	call _Test_Code_Acces
	
	MOV R6,#High Tab_code
	MOV R7,#Low Tab_code
	MOV R5,#0FH 	;bug ici : ne trouve pas le bon index (21, expected 01)
	call _Test_Code_Acces
	
	MOV R6,#High Tab_code
	MOV R7,#Low Tab_code
	MOV R5,#0FFH	;ne s'arrète pas, à verif
	call _Test_Code_Acces

    ; Démo - Echo de caractère reçu sur l'UART
	 call Getchar_UART0
     cjne R7,#0FFH,Main_send_char_echo
     jmp   	Main
Main_send_char_echo:	 
	 call Putchar_UART0
	 jmp  Main

;******************************************************************************
; Programme d'interruption Timer3
;******************************************************************************
ISR_Timer3:
       SETB GREEN_LED ; Pour visualiser le programme d'interruption
	   PUSH PSW
       ANL TMR3CN,#7Fh ; OBLIGATOIRE - Mise à zéro TF3 Flag INT Timer3
	  
	   
	   ; Vous pouvez insérer ici du code de l'application 
		
	   POP PSW
	   CLR GREEN_LED ; Pour visualiser le programme d'interruption
	   reti
;-----------------------------------------------------------------------------
; End of file.

END



