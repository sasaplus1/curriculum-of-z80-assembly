HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
;
CTC	EQU	10H
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
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	IVSET
;--------------------------------------
; Main routine
;--------------------------------------
	EI
	JR	$
;--------------------------------------
; Interrupt routines
;--------------------------------------
INT0:	CALL	LEFT
	CALL	WAIT
	CALL	WAIT
	CALL	STOP
	EI
	RETI
;
INT1:	CALL	RIGHT
	CALL	WAIT
	CALL	WAIT
	CALL	STOP
	EI
	RETI
;
INT2:	CALL	LEFT
	CALL	WAIT
	CALL	WAIT
	CALL	STOP
	CALL	RIGHT
	LD	E,05H
SLEEP2:	CALL	WAIT
	DEC	E
	JP	NZ,SLEEP2
	CALL	STOP
	CALL	LEFT
	CALL	WAIT
	CALL	WAIT
	CALL	STOP
	EI
	RETI
;
INT3:	CALL	ARMUP
	LD	E,0BH
SLEEP3:	CALL	WAIT
	DEC	E
	JP	NZ,SLEEP3
	CALL	ARMSTP
	EI
	RETI
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
WDTINI:	DI
	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	RET
;
CPUINI:	IM	2
	LD	A,90H
	LD	I,A
	RET
;
CTCINI:	LD	A,0
	OUT	(CTC),A
	LD	BC,410H
	LD	DE,0D501H
CI1:	OUT	(C),D
	OUT	(C),E
	INC	C
	DJNZ	CI1
	RET
;
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
IVSET:	LD	BC,INT0
	LD	(9000H),BC
	LD	BC,INT1
	LD	(9002H),BC
	LD	BC,INT2
	LD	(9004H),BC
	LD	BC,INT3
	LD	(9006H),BC
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
;
	END
;[EOF]
