HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
;
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;
	ORG	8000H
;
	LD	SP,00H
	CALL	WDTINI
	CALL	PIOINI
;--------------------------------------
; Main routine
;--------------------------------------
LOOP:	CALL	LEFT
	CALL	WAIT
	CALL	WAIT
	CALL	STOP
;
	CALL	SLEEP
;
	CALL	RIGHT
	CALL	WAIT
	CALL	WAIT
	CALL	STOP
;
	CALL	SLEEP
;
	CALL	ARMUP
	CALL	SLEEP
	CALL	ARMSTP
;
	CALL	SLEEP
;
	JP	LOOP
;--------------------------------------
; Sub routines
;--------------------------------------
;
;----------------------------
; Curve
;----------------------------
LEFT:	LD	A,0A5H
	OUT	(PAD),A
	CALL	WAIT
	RET
;
RIGHT:	LD	A,5AH
	OUT	(PAD),A
	CALL	WAIT
	RET
;----------------------------
; Motor
;----------------------------
STOP:	LD	A,0CCH
	OUT	(PAD),A
	CALL	WAIT
	RET
;----------------------------
; Arm
;----------------------------
ARMUP:	LD	A,0FAH
	OUT	(PBD),A
	CALL	WAIT
	RET
;
ARMSTP:	LD	A,0FCH
	OUT	(PBD),A
	CALL	WAIT
	RET
;----------------------------
; Initialize
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
;
WDTINI:	DI
	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	EI
	RET
;----------------------------
; Wait
;----------------------------
WAIT:	LD	D,06H
W0:	LD	B,0FFH
W1:	LD	C,0FFH
W2:	DEC	C
	JP	NZ,W2
	DEC	B
	JP	NZ,W1
	DEC	D
	JP	NZ,W0
	RET
;----------------------------
SLEEP:	LD	E,0BH
SLEEP0:	CALL	WAIT
	DEC	E
	JP	NZ,SLEEP0
	RET
;
	END
;[EOF]
