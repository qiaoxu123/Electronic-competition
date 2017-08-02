	;======================================================================
	;
	; Author        : ADI CAST, china.support@analog.com
	;
	; Date          : June 2003
	;
	; File          : ad9854P.asm
	;
	; Description   : parallel control mode. Internal update clock .
	;		  The program can implement the basic four modes of ad9854:
	;		  single tone, unramped FSK, ramped FSK, chirp, BPSK. 
	;		  we assume that master clock is 50 MHz and multiplied by 4
	;		  ADUC832 is used to control ad9854. The core clock is 2.097152MHz.
	;======================================================================

	$MOD832					; Use ADuC832 predefined Symbols

	;======================================================================
	;DEFINE CONTROL PINS OF ADUC832 FOR THE PURPOSE OF AD9854 CONTROL.
	;Customers should define the pins according to their design.
	;If P0 is used as the control port, pull-up resistors should be added to each pin of P0.
	;======================================================================

	;======================================================================
	;P0 is used as the eight bits data port.
	;p2.0~p2.5 is used to give the register address 
	;======================================================================

	RESET   EQU	P3.4			; master reset of AD9854
	SPSEL	EQU	P3.5			; serial/parrelel select pin
	FDATA	EQU	P2.7			; multi-function pin for different modes
	ORAMP	EQU	P2.6			; output shape pin 
	WRITE	EQU	P3.6			; write signal
	READ	EQU	P3.7			; read signal

	;======================================================================

	CSEG					; Defines the following as a segment of code

	ORG     0000H				; Load Code at address'0'

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
			CLR	RESET		;disable reset
			

	;======================================================================	
	; write to update clock register as 40KHz.
	; It can be changed by customers according to their requirement
	;======================================================================	

			MOV	P2,#16H		; the register address
			MOV	P0,#00H		; the higher 8 bits, MSB firsts
			CLR	WRITE		; write enabled
			SETB	WRITE

			MOV	P2,#17H		; the register address
			MOV	P0,#00H		; 8 bits data
			CLR	WRITE		; write enabled
			SETB	WRITE

			MOV	P2,#18H		; the register address
			MOV	P0,#09H		; 8 bits data
			CLR	WRITE		; write enabled
			SETB	WRITE	

			MOV	P2,#19H		; the register address
			MOV	P0,#0c3H	; 8 bits data
			CLR	WRITE		; write enabled
			SETB	WRITE		

	;=====================================================================
	; Single tone mode
	; First program the control register to configure single tone mode
	; Then write to 48 bits FTW1 register to set output as 4MHz. Phase is the default 0 degree.
	;======================================================================
	SINGLETONE: 
	;write to control register to set single tone mode
			MOV	P2,#1DH		; register address
			MOV	P0,#10H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1EH		; register address
			MOV	P0,#44H		; 8 bits data, master clock multiplied by 4
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1FH		; register address
			MOV	P0,#01H		; 8 bits data, single tone mode
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#20H		; register address
			MOV	P0,#00H		; 8 bits data, SDO enabled
			CLR	WRITE		; write enable
			SETB	WRITE	

	;write to FTW1 register as 4MHz

			MOV	P2,#04H		; register address
			MOV	P0,#05H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#05H		; register address
			MOV	P0,#1EH		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#06H		; register address
			MOV	P0,#0B8H	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

			MOV	P2,#07H		; register address
			MOV	P0,#51H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

			MOV	P2,#08H		; register address
			MOV	P0,#0EBH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#09H		; register address
			MOV	P0,#85H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE			

			SETB	IT0		; INT0 edge triggered
			SETB	EA		; enable inturrupts
			SETB	EX0		; enable INT0
			SETB    C
			JC      $               ; INT0 leads to unramped FSK mode		

	;=====================================================================
	; unramped FSK mode
	; First program the control register to configure FSK mode
	; Then write to 48 bits FTW2 register to set output as 60MHz. FTW1 is still configured as 
	; 4MHz.Phase is the default 0 degree.
	;======================================================================

	FSK:	
	;write to control register to configure unramped FSK mode
			MOV	P2,#1DH		; register address
			MOV	P0,#10H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1EH		; register address
			MOV	P0,#44H		; 8 bits data, master clock is multiplied by 4
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1FH		; register address
			MOV	P0,#03H		; 8 bits data, unramped FSK mode
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#20H		; register address
			MOV	P0,#00H		; 8 bits data, SDO enabled
			CLR	WRITE		; write enable
			SETB	WRITE

	;write to FTW2 of 60MHz
			MOV	P2,#0AH		; register address
			MOV	P0,#4CH		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#0BH		; register address
			MOV	P0,#0CCH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#0CH		; register address
			MOV	P0,#0CCH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

			MOV	P2,#0DH		; register address
			MOV	P0,#0CCH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

			MOV	P2,#0EH		; register address
			MOV	P0,#0CCH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#0FH		; register address
			MOV	P0,#0CCH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	
		

			SETB	C
			MOV	A,#14H		; set delay period of 2s

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
	;======================================================================

	RAMPFSK:	
	; write to control register to configure ramped FSK mode

			MOV	P2,#1DH		; register address  关闭比较器
			MOV	P0,#10H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1EH		; register address   PLL倍频
			MOV	P0,#44H		; 8 bits data, master clock is multiplied by 4
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1FH		; register address  //内部更新时钟
			MOV	P0,#25H		; 8 bits data, ramped FSK mode, triangle bit is set 
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#20H		; register address
			MOV	P0,#00H		; 8 bits data, SDO enabled
			CLR	WRITE		; write enable
			SETB	WRITE

	; write to delta FTW register

			MOV	P2,#10H		; register address
			MOV	P0,#00H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#11H		; register address
			MOV	P0,#01H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#12H		; register address
			MOV	P0,#04H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

			MOV	P2,#13H		; register address
			MOV	P0,#08BH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

			MOV	P2,#14H		; register address
			MOV	P0,#058H	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	
			
			MOV	P2,#15H		; register address
			MOV	P0,#08EH	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

	; write to ramp rate clock register
			
			MOV	P2,#1AH		; register address
			MOV	P0,#00H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	
			
			MOV	P2,#1BH		; register address
			MOV	P0,#0C3H	; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1CH		; register address	
			MOV	P0,#50H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE
			
			SETB	C
			JC	$		; INT0 leads to CHIRP mode

	;=====================================================================
	; CHIRP mode
	; Clear FDATA in order not to enter hold mode 
	; Write to control register to enter chirp mode
	; FTW1 is still configured as 4MHz. Phase is the default 0 degree. 
	; delta FTW register and the ramp rate clock register are still 4KHz and 0x00C350.
	;======================================================================

	CHIRP:		
			CLR	FDATA

	;write to control register to set chirp mode

			MOV	P2,#1DH		; register address
			MOV	P0,#10H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE	

			MOV	P2,#1EH		; register address
			MOV	P0,#44H		; 8 bits data,master clock is multiplied by 4
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1FH		; register address
			MOV	P0,#07H		; 8 bits data , chirp mode
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#20H		; register address
			MOV	P0,#00H		; 8 bits data, SDO enabled
			CLR	WRITE		; write enable
			SETB	WRITE


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
	;======================================================================

	BPSK:

	;write to control register to set BPSK mode

			MOV	P2,#1DH		; register address
			MOV	P0,#10H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1EH		; register address
			MOV	P0,#44H		; 8 bits data,master clock is multiplied by 4
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#1FH		; register address
			MOV	P0,#09H		; 8 bits data, BPSK mode
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#20H		; register address
			MOV	P0,#00H		; 8 bits data, SDO enabled
			CLR	WRITE		; write enable
			SETB	WRITE

	;write to phase2 register to 90 degree
			
			MOV	P2,#02H		; register address
			MOV	P0,#10H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE

			MOV	P2,#03H		; register address
			MOV	P0,#00H		; 8 bits data
			CLR	WRITE		; write enable
			SETB	WRITE		
		


			SETB	C		
			MOV	A,#14H		;set delay period of 2s

	;BY switching the BPSK pin status to implement the phase shift between 0 and 90 degree

	GOBPSK:		CPL	FDATA
			CALL	DELAY
			JC	GOBPSK		; INT0 leads to another cycle

			JMP SINGLETONE


	; Subroutines

	;------------------------------------------------------------------



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