PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;
	ORG	8000H
;
	LD	SP,0
	CALL	PIOINI
;-- Main ------------------------------
ALOOPI:	LD	A,00H
	OUT	(PBD),A
	LD	A,01H
ALOOP:	OUT	(PAD),A
	SLA	A
	CALL	WAIT
	JP	C,BLOOPI
	JP	ALOOP
;
BLOOPI:	LD	A,00H
	OUT	(PAD),A
	LD	A,01H
BLOOP:	OUT	(PBD),A
	SLA	A
	CALL	WAIT
	JP	C,ALOOPI
	JP	BLOOP
;--------------------------------------
PIOINI:	LD	A,0CFH
	OUT	(PAC),A
	LD	A,0
	OUT	(PAC),A
	LD	A,0CFH
	OUT	(PBC),A
	LD	A,0
	OUT	(PBC),A
;
WAIT:	PUSH	BC
	LD	B,0FFH
W1:	LD	C,0FFH
W2:	DEC	C
	JP	NZ,W2
	DEC	B
	JP	NZ,W1
	POP	BC
	RET
;
	END
;