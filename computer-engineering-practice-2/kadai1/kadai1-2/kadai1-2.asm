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
	JP	STRTLP
REVRSB:	CALL	STOP
STRTLP:	LD	B,07H
;
RLOPBI:	LD	A,00H
	OUT	(PAD),A
	DEC	B
	JP	Z,REVRSA
	LD	A,80H
RLOOPB:	OUT	(PBD),A
	SRL	A
	CALL	WAIT
	JP	C,RLOPAI
	JP	RLOOPB
;
RLOPAI:	LD	A,00H
	OUT	(PBD),A
	LD	A,80H
RLOOPA:	OUT	(PAD),A
	SRL	A
	CALL	WAIT
	JP	C,RLOPBI
	JP	RLOOPA
;
REVRSA:	CALL	STOP
	LD	B,07H
LLOPAI:	LD	A,00H
	DEC	B
	JP	Z,REVRSB
	OUT	(PBD),A
	LD	A,01H
LLOOPA:	OUT	(PAD),A
	SLA	A
	CALL	WAIT
	JP	C,LLOPBI
	JP	LLOOPA
;
LLOPBI:	LD	A,00H
	OUT	(PAD),A
	LD	A,01H
LLOOPB:	OUT	(PBD),A
	SLA	A
	CALL	WAIT
	JP	C,LLOPAI
	JP	LLOOPB
;-- SubRoutine ------------------------
STOP:	LD	A,80H
	OUT	(PBD),A
	CALL	SLEEP
	RET
;
SLEEP:	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
	RET
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