;======================================================================
;
; Author        : ADI CAST, china.support@analog.com
;
; Date          : June 2003
;
; File          : ad9854s.asm
;
; Description   : serial control mode. external update clock is used.
;		  The program can implement the basic four modes of ad9854:
;		  single tone, unramped FSK, ramped FSK, chirp, BPSK. 
;		  we assume that master clock is 50 MHz and multiplied by 4
;		  ADUC832 is used to control ad9854. The core clock is 2.097152MHz.
;======================================================================
       
$MOD832					; Use ADuC832 predefined Symbols

;define instruction byte for each register.

PHASE1	EQU	00H			; phase adjust register #1
PHASE2  EQU     01H			; phase adjust register #2
FREQ1   EQU     02H			; frequency tuning word 1
FREQ2   EQU     03H			; frequency tuning word 2
DELFQ   EQU     04H			; delta frequency word
UPDCK   EQU     05H			; update clock
RAMPF   EQU     06H			; ramp rate clock
CONTR   EQU     07H			; control register
SHAPEI  EQU     08H			; output shape key I mult
SHAPEQ  EQU     09H			; output shape key Q mult 
RAMPO   EQU     0AH			; output shape key ramp rate
CDAC    EQU     0BH			; QDAC

;======================================================================
;DEFINE CONTROL PINS OF ADUC832 FOR THE PURPOSE OF AD9854 CONTROL.
;Customers should define the pins according to their design.
;If P0 is used as the control port, pull-up resistors should be added to each pin of P0.
;======================================================================

SCLOCK  EQU	P0.4		;clock pin for SPI interface
SDI	EQU	P0.2		; data input pin for SPI interface
CSB	EQU	P0.5		; chip select pin
IORST	EQU	P0.0		; IO reset pin
RESET	EQU	P2.7		; chip master reset
ORAMP	EQU	P0.7		; output shape pin 
SPSEL	EQU	P0.6		; serial/parallel select pin
UPDCLK	EQU	P0.3		; update clock
SDO	EQU	P0.1		; data output pin for SPI interface

FDATA	EQU	P2.0		; multi-function pin for different modes
;======================================================================

CSEG					; Defines the following as a segment of code

ORG     0000H				; Load Code at address '0'	

		JMP     MAIN		; Jump to MAIN

;======================================================================

ORG 0003h				; (INT0 ISR)
	       
		CLR C
		RETI			; Return from Interrupt

;======================================================================

ORG 0070h

MAIN:					; (main program)

;======================================================================
;initialization
;after reset of aduc832, the default status of IO ports are 0xFFH
;======================================================================		
		CLR	SPSEL		; serial control mode
		CLR	SCLOCK     
		CLR	UPDCLK
		CLR	RESET		; reset disabled
           	CLR	IORST		; io reset disabled
                CLR	CSB		; prepare to write to ad9854


;======================================================================
;When operating in the serial I/O mode ,it is best to use the external I/O udate clock.
;To exit the default internal update mode, after a master reset of ad9854, but before 
;starting REFCLK signal,program the device for external update operation. Then starting 
;REFCLK will cause this information to transfer to the register bank,putting the device in
;exteranl update mode.
;======================================================================	

; write to control register to enable EXTERNAL UPDATE CLOCK          
                MOV     A,#CONTR        ;  first write CONTROL REGISTER instruction byte
                CALL    WRITEBYTE       
		MOV     A,#10H          ;  MSB first 
                CALL    WRITEBYTE 
		MOV     A,#44H		; master clock multiplied by 4
                CALL    WRITEBYTE 
		MOV     A,#00H          ; ENABLE EXTERL UPDATE CLOCK
                CALL    WRITEBYTE
		MOV     A,#01H          ; ENABLE SDO
                CALL    WRITEBYTE       

		SETB	IT0		; INT0 edge triggered
		SETB	EA		; enable inturrupts
		SETB	EX0		; enable INT0

		SETB    C
                JC      $               ; here please start the REFCLK and then a INT0 will 										; lead the program going on

;=====================================================================
; Single tone mode
; First program the control register to configure single tone mode
; Then write to 48 bits FTW1 register to set output as 4MHz. Phase is the default 0 degree.
; Finally,give an external update clock to start output.
;======================================================================
		
SINGLETONE:   

; write to control register to configure single tone mode
		MOV     A,#CONTR        ; Instruction byte
                CALL    WRITEBYTE       
		MOV     A,#10H          ; MSB first 
                CALL    WRITEBYTE 
		MOV     A,#44H		; master clock multiplied by 4
                CALL    WRITEBYTE 
		MOV     A,#00H          ; SINGLE TONE MODE and external UPDATE CLOCK mode
                CALL    WRITEBYTE
		MOV     A,#01H          ; SDO enabled
                CALL    WRITEBYTE       

; write to 48 bits FTW1 register to set output as 4MHz		
		MOV	A,#FREQ1	; instruction byte
		CALL	WRITEBYTE	
		MOV	A,#05H		; MSB first
		CALL	WRITEBYTE	
		MOV	A,#1EH
		CALL	WRITEBYTE
		MOV	A,#0B8H
		CALL	WRITEBYTE
		MOV	A,#051H
		CALL	WRITEBYTE
		MOV	A,#0EBH
		CALL	WRITEBYTE
		MOV	A,#085H
		CALL	WRITEBYTE	
		
; give an update clock		

		SETB	UPDCLK		; update clock
		CLR	UPDCLK

		SETB	C
		JC	$		; INT0 leads to FSK mode

;=====================================================================
; unramped FSK mode
; First program the control register to configure FSK mode
; Then write to 48 bits FTW2 register to set output as 60MHz. FTW1 is still configured as 
; 4MHz.Phase is the default 0 degree.
; Finally,give an external update clock to start.
;======================================================================

FSK:

; write to control register to configure FSK mode
		MOV     A,#CONTR        ; instruction  byte
                CALL    WRITEBYTE       
		MOV     A,#10H          ; MSB first 
                CALL    WRITEBYTE 
		MOV     A,#44H		; master clock is multiplied by 4
                CALL    WRITEBYTE 
		MOV     A,#02H          ; FSK mode and external update clock mode
                CALL    WRITEBYTE
		MOV     A,#01H          ; SDO enabled
                CALL    WRITEBYTE       

; write to FTW2 as 60MHz		 
		MOV	A,#FREQ2	; instruction byte
		CALL	WRITEBYTE
		MOV	A,#4CH		; MSB first
		CALL	WRITEBYTE
		MOV	A,#0CCH
		CALL	WRITEBYTE
		MOV	A,#0CCH
		CALL	WRITEBYTE
		MOV	A,#0CCH
		CALL	WRITEBYTE
		MOV	A,#0CCH
		CALL	WRITEBYTE
		MOV	A,#0CCH
		CALL	WRITEBYTE

; give an update clock		
		SETB	UPDCLK		; update clock
		CLR	UPDCLK

		SETB	C
		MOV	A,#14H		; set the delay period of 2s

;BY switching the FSK pin status to implement the frequency shift between 4MHz and 60MHz

GOFSK:		CPL	FDATA		; switch the FSK control pin status
		CALL	DELAY
		JC	GOFSK		; INT0 will lead to ramped FSK mode

;=====================================================================
; ramped FSK mode
; First program the control register to configure ramped FSK mode. Here we set the triangle 
; bit in the control register. 
; FTW1 and FTW2 are still configured as 4MHz and 60MHz. Phase is the default 0 degree.
; Then program the delta FTW register and the ramp rate clock register as 4KHz and 0x00C350.
; Finally,give an external update clock to start.
;======================================================================

RAMPFSK:	

; write to control register to configure ramped FSK mode
		MOV     A,#CONTR        ; instruction byte
                CALL    WRITEBYTE       
		MOV     A,#10H          ; MSB first 
                CALL    WRITEBYTE 
		MOV     A,#44H		; master clock is multiplied by 4
                CALL    WRITEBYTE 
		MOV     A,#24H          ; ramped FSK mode and external update clock mode
					; set the triangle bit.
                CALL    WRITEBYTE
		MOV     A,#01H          ; SDO enabled
                CALL    WRITEBYTE       

; write to the delta FTW register		
		MOV	A,#DELFQ
		CALL	WRITEBYTE
		MOV	A,#00H
		CALL	WRITEBYTE
		MOV	A,#01H
		CALL	WRITEBYTE
		MOV	A,#4FH
		CALL	WRITEBYTE
		MOV	A,#8BH
		CALL	WRITEBYTE
		MOV	A,#58H
		CALL	WRITEBYTE
		MOV	A,#8EH
		CALL	WRITEBYTE

;write to the ramp rate clock register
		MOV	A,#RAMPF
		CALL	WRITEBYTE
		MOV	A,#00H
		CALL	WRITEBYTE
		MOV	A,#0C3H
		CALL	WRITEBYTE
		MOV	A,#50H
		CALL	WRITEBYTE

; give update clock	
		SETB	UPDCLK		; update clock
		CLR	UPDCLK
		
		SETB	C
		JC	$		; INT0 leads to chirp mode

;=====================================================================
; CHIRP mode
; Clear FDATA in order not to enter hold mode 
; Write to control register to enter chirp mode
; FTW1 is still configured as 4MHz. Phase is the default 0 degree. 
; delta FTW register and the ramp rate clock register are still 4KHz and 0x00C350.
; Give an external update clock to start.
;======================================================================
CHIRP:		CLR	FDATA
		
;write to control register to set chirp mode
		MOV     A,#CONTR        ; instruction byte
                CALL    WRITEBYTE         
		MOV     A,#10H          ; MSB first
                CALL    WRITEBYTE 
		MOV     A,#44H		; master clock is multiplied by 4
                CALL    WRITEBYTE 
		MOV     A,#06H          ; chirp mode and external update clock mode
                CALL    WRITEBYTE
		MOV     A,#01H          ; SDO enabled
                CALL    WRITEBYTE

;give update clock
		SETB	UPDCLK		; update clock
		CLR	UPDCLK
		
		MOV	A,#64H		; set delay period of 10s
		CALL	DELAY
		SETB	FDATA		; enter hold mode
		
      		SETB 	C
		JC	$		; INT0 leads to BPSK mode

;=====================================================================
; BPSK mode
; Write to control register to enter BPSK mode
; FTW1 is still configured as 4MHz. 
; Phase1 is the default 0 degree. Phase2 is configured as 90 degree.
; Give an external update clock to start.
;======================================================================
BPSK:		

;write to control register to set BPSK mode
		MOV     A,#CONTR        ; instruction mode
                CALL    WRITEBYTE      
		MOV     A,#10H         	; MSB first  
                CALL    WRITEBYTE 
		MOV     A,#44H		; master clock is multiplied by 4
                CALL    WRITEBYTE 
		MOV     A,#08H          ; BPSK mode and external update clock mode
                CALL    WRITEBYTE
		MOV     A,#01H          ; SDO enabled 
                CALL    WRITEBYTE

;write to phase2 register to 90 degree			
	
		MOV	A,#PHASE2	; instruction byte
		CALL	WRITEBYTE
		MOV	A,#10H		; MSB first
		CALL	WRITEBYTE
		MOV	A,#00H
		CALL	WRITEBYTE

;give update clock
				
		SETB	UPDCLK		;update clock
		CLR	UPDCLK

		SETB	C
		MOV	A,#14H		;set delay period of 2s


;BY switching the BPSK pin status to implement the phase shift between 0 and 90 degree
GOBPSK:		CPL	FDATA
		CALL	DELAY
		JC	GOBPSK		; INT0 leads to another cycle

		JMP	SINGLETONE


; Subroutines


;======================================================================
; write 8 bits to ad9834
; MSB first
; implemented by left-shifting the A register
;======================================================================

WRITEBYTE:
		CLR    C
                MOV    R0,#08H
LOOP:           RLC    A
                MOV    SDI,C		;prepare data on SDI
                SETB   SCLOCK		;give a pulse on sclk
                CLR    SCLOCK
                DJNZ   R0,LOOP
                RET
	
DELAY:					; Delays by 100ms * A
					; 100mSec based on 2.097152MHZ 
					; Core Clock 
					; i.e. default ADuC832 Clock

		MOV	R1,A		; Acc holds delay variable
 DLY0:		MOV	R2,#022h	; Set up delay loop0
 DLY1:		MOV	R3,#0FFh	; Set up delay loop1
		DJNZ	R3,$		; Dec R3 & Jump here until R3 is 0
		DJNZ	R2,DLY1         ; Dec R2 & Jump DLY1 until R2 is 0
		DJNZ	R1,DLY0		; Dec R1 & Jump DLY0 until R1 is 0
		RET			; Return from subroutine


END