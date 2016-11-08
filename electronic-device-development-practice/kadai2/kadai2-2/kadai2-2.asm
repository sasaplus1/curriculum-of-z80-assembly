HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
;
CTC0	EQU	10H
CTC1	EQU	11H
;
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;
PPA0	EQU	30H
PPB0	EQU	31H
PPC0	EQU	32H
PPR0	EQU	33H
;
PPA1	EQU	34H
PPB1	EQU	35H
PPC1	EQU	36H
PPR1	EQU	37H
;
LINE1	EQU	9100H
LINE2	EQU	9102H
LINE3	EQU	9104H
;
	ORG	8000H
;--------------------------------------
; Initialize
;--------------------------------------
	LD	SP,00H
	DI
;----------------------------
	CALL	WDTINI
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	PPIINI
;----------------------------
	LD	A,00H
	OUT	(PAD),A
	OUT	(PBD),A
	OUT	(PPB0),A
;----------------------------
	LD	HL,LCD1
	LD	(LINE1),HL
	LD	HL,LCD2
	LD	(LINE2),HL
	LD	HL,LCD3
	LD	(LINE3),HL
;----------------------------
	CALL	IVSET
;----------------------------
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
;----------------------------
	CALL	SETLCD
;----------------------------
	LD	B,5
SLEEP:	CALL	LWAIT
	DJNZ	SLEEP
;--------------------------------------
; Main routine
;--------------------------------------
LOOP:	LD	D,00H
	LD	E,00H
;----------------------------
	LD	A,01H
	OUT	(PPB1),A
;----------------------------
	EI
	JR	NC,$
	DI
;----------------------------
	LD	A,00H
	CP	D
	JP	Z,LOOP
;----------------------------
	LD	A,00H
	OUT	(PPB1),A
;----------------------------
	CALL	SETLCD
;----------------------------
	CALL	CURSOR
;----------------------------
; Compare Counter
;----------------------------
	LD	A,10
	LD	B,11
	LD	E,10
	LD	HL,LCD1
	CALL	HAN
	LD	(LINE1),HL
;----------------------------
	LD	A,4
	LD	B,26
	LD	E,5
	LD	HL,LCD2
	CALL	HAN
	LD	(LINE2),HL
;----------------------------
	LD	A,2
	LD	B,50
	LD	E,2
	LD	HL,LCD3
	CALL	HAN
	LD	(LINE3),HL
;--------------------------------------
; Show Message
;--------------------------------------
	LD	HL,(LINE1)
	CALL	MSG
;----------------------------
	CALL	R000
	CALL	R001
	LD	A,0C0H
	OUT	(PAD),A
	CALL	WAIT
	CALL	R000
;----------------------------
	LD	HL,(LINE2)
	CALL	MSG
;----------------------------
	CALL	R000
	CALL	R001
	LD	A,94H
	OUT	(PAD),A
	CALL	WAIT
	CALL	R000
;----------------------------
	LD	HL,(LINE3)
	CALL	MSG
;----------------------------
	CALL	CURSOR
;----------------------------
	JP	LOOP
;--------------------------------------
; Sub routines
;--------------------------------------
;
;----------------------------
; LCD timing routine
;----------------------------
R000:	LD	A,00H
	OUT	(PBD),A
	RET
;
R001:	LD	A,04H
	OUT	(PBD),A
	RET
;
R010:	LD	A,01H
	OUT	(PBD),A
	RET
;
R011:	LD	A,05H
	OUT	(PBD),A
	RET
;----------------------------
; Wait
;----------------------------
WAIT:	PUSH	BC
	LD	C,08H
W2:	LD	B,0FFH
W3:	DEC	B
	JP	NZ,W3
	DEC	C
	JP	NZ,W2
	POP	BC
	RET
;----------------------------
; Long Wait
;----------------------------
LWAIT:	PUSH	BC
	LD	C,00H
LW2:	LD	B,00H
LW3:	DEC	B
	JP	NZ,LW3
	DEC	C
	JP	NZ,LW2
	POP	BC
	RET
;----------------------------
; Initialize WDT
;----------------------------
WDTINI:	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	RET
;----------------------------
; Initialize CPU
;----------------------------
CPUINI:	IM	2
	LD	A,90H
	LD	I,A
	RET
;----------------------------
; Initialize CTC
;----------------------------
CTCINI:	LD	A,00H
	OUT	(CTC0),A
	LD	A,0C5H
	OUT	(CTC0),A
	LD	A,5
	OUT	(CTC0),A
	LD	A,85H
	OUT	(CTC1),A
	LD	A,0B1H
	OUT	(CTC1),A
	RET
;----------------------------
; Initialize PIO
;----------------------------
PIOINI:	LD	A,0CFH
	OUT	(PAC),A
	LD	A,00H
	OUT	(PAC),A
	LD	A,0CFH
	OUT	(PBC),A
	LD	A,00H
	OUT	(PBC),A
	RET
;----------------------------
; Initialize PPI
;----------------------------
PPIINI:	LD	A,80H
	OUT	(PPR0),A
	OUT	(PPR1),A
	RET
;----------------------------
; Write VectorTable
;----------------------------
IVSET:	LD	BC,INT0
	LD	(9000H),BC
	LD	BC,INT1
	LD	(9002H),BC
	RET
;----------------------------
; Initialize LCD
;----------------------------
SETLCD:	LD	HL,LCDINI
	LD	B,03H
	CALL	R000
	CALL	WAIT
L1:	CALL	R001
	LD	A,(HL)
	OUT	(PAD),A
	CALL	WAIT
	CALL	R000
	INC	HL
	DJNZ	L1
	RET
;----------------------------
; Compare Counter
;----------------------------
HAN:	CP	D
	JP	P,HAN0
	ADD	A,E
	PUSH	BC
	LD	BC,16
	ADD	HL,BC
	POP	BC
	DJNZ	HAN
HAN0:	RET
;----------------------------
; Write Message
;----------------------------
MSG:	LD	B,16
	CALL	R000
	CALL	WAIT
WRITE:	CALL	R011
	LD	A,(HL)
	OUT	(PAD),A
	CALL	WAIT
	CALL	R010
	INC	HL
	DJNZ	WRITE
	RET
;----------------------------
; Move LCD Cursor (to Home)
;----------------------------
CURSOR:	CALL	R000
	CALL	R001
	LD	A,80H
	OUT	(PAD),A
	CALL	WAIT
	CALL	R000
	RET
;--------------------------------------
; Interrupt routines
;--------------------------------------
INT0:	SCF
	DI
	RETI
;
INT1:	INC	D
	SCF
	CCF
	EI
	RETI
;--------------------------------------
; Defined Bytes
;--------------------------------------
;
;----------------------------
; LCD Initialize Commands
;----------------------------
LCDINI:	DB	38H
	DB	0CH
	DB	06H
;----------------------------
; Messages
;----------------------------
LCD1:	DB	'0.0m��ޮ�0.5m���'
	DB	'0.5m��ޮ�1.0m���'
	DB	'1.0m��ޮ�1.5m���'
	DB	'1.5m��ޮ�2.0m���'
	DB	'2.0m��ޮ�2.5m���'
	DB	'2.5m��ޮ�3.0m���'
	DB	'3.0m��ޮ�3.5m���'
	DB	'3.5m��ޮ�4.0m���'
	DB	'4.0m��ޮ�4.5m���'
	DB	'4.5m��ޮ�5.0m���'
	DB	'5.0m��ޮ�       '
;
LCD2:	DB	'0.0m��ޮ�0.2m���'
	DB	'0.2m��ޮ�0.4m���'
	DB	'0.4m��ޮ�0.6m���'
	DB	'0.6m��ޮ�0.8m���'
	DB	'0.8m��ޮ�1.0m���'
	DB	'1.0m��ޮ�1.2m���'
	DB	'1.2m��ޮ�1.4m���'
	DB	'1.4m��ޮ�1.6m���'
	DB	'1.6m��ޮ�1.8m���'
	DB	'1.8m��ޮ�2.0m���'
	DB	'2.0m��ޮ�2.2m���'
	DB	'2.2m��ޮ�2.4m���'
	DB	'2.4m��ޮ�2.6m���'
	DB	'2.6m��ޮ�2.8m���'
	DB	'2.8m��ޮ�3.0m���'
	DB	'3.0m��ޮ�3.2m���'
	DB	'3.2m��ޮ�3.4m���'
	DB	'3.4m��ޮ�3.6m���'
	DB	'3.6m��ޮ�3.8m���'
	DB	'3.8m��ޮ�4.0m���'
	DB	'4.0m��ޮ�4.2m���'
	DB	'4.2m��ޮ�4.4m���'
	DB	'4.4m��ޮ�4.6m���'
	DB	'4.6m��ޮ�4.8m���'
	DB	'4.8m��ޮ�5.0m���'
	DB	'5.0m��ޮ�       '
;
LCD3:	DB	'0.0m��ޮ�0.1m���'
	DB	'0.1m��ޮ�0.2m���'
	DB	'0.2m��ޮ�0.3m���'
	DB	'0.3m��ޮ�0.4m���'
	DB	'0.4m��ޮ�0.5m���'
	DB	'0.5m��ޮ�0.6m���'
	DB	'0.6m��ޮ�0.7m���'
	DB	'0.7m��ޮ�0.8m���'
	DB	'0.8m��ޮ�0.9m���'
	DB	'0.9m��ޮ�1.0m���'
	DB	'1.0m��ޮ�1.1m���'
	DB	'1.1m��ޮ�1.2m���'
	DB	'1.2m��ޮ�1.3m���'
	DB	'1.3m��ޮ�1.4m���'
	DB	'1.4m��ޮ�1.5m���'
	DB	'1.5m��ޮ�1.6m���'
	DB	'1.6m��ޮ�1.7m���'
	DB	'1.7m��ޮ�1.8m���'
	DB	'1.8m��ޮ�1.9m���'
	DB	'1.9m��ޮ�2.0m���'
	DB	'2.0m��ޮ�2.1m���'
	DB	'2.1m��ޮ�2.2m���'
	DB	'2.2m��ޮ�2.3m���'
	DB	'2.3m��ޮ�2.4m���'
	DB	'2.4m��ޮ�2.5m���'
	DB	'2.5m��ޮ�2.6m���'
	DB	'2.6m��ޮ�2.7m���'
	DB	'2.7m��ޮ�2.8m���'
	DB	'2.8m��ޮ�2.9m���'
	DB	'2.9m��ޮ�3.0m���'
	DB	'3.0m��ޮ�3.1m���'
	DB	'3.1m��ޮ�3.2m���'
	DB	'3.2m��ޮ�3.3m���'
	DB	'3.3m��ޮ�3.4m���'
	DB	'3.4m��ޮ�3.5m���'
	DB	'3.5m��ޮ�3.6m���'
	DB	'3.6m��ޮ�3.7m���'
	DB	'3.7m��ޮ�3.8m���'
	DB	'3.8m��ޮ�3.9m���'
	DB	'3.9m��ޮ�4.0m���'
	DB	'4.0m��ޮ�4.1m���'
	DB	'4.1m��ޮ�4.2m���'
	DB	'4.2m��ޮ�4.3m���'
	DB	'4.3m��ޮ�4.4m���'
	DB	'4.4m��ޮ�4.5m���'
	DB	'4.5m��ޮ�4.6m���'
	DB	'4.6m��ޮ�4.7m���'
	DB	'4.7m��ޮ�4.8m���'
	DB	'4.8m��ޮ�4.9m���'
	DB	'4.9m��ޮ�5.0m���'
	DB	'5.0m��ޮ�       '
;
	END
;[EOF]
