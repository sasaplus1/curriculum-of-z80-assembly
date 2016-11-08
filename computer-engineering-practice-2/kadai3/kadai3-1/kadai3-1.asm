HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
CTC	EQU	10H
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;
	ORG	8000H
;--------------------------------------
; ������
;--------------------------------------
	LD	SP,0
	CALL	WDTINI
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	IVSET
;--------------------------------------
; ���W�X�^�̏�����
;--------------------------------------
	LD	D,0
	LD	E,0
	EI
;--------------------------------------
; A�|�[�g���v���
;--------------------------------------
PACW:	LD	A,00H
	OUT	(PBD),A
	LD	A,01H
PLP1:	OUT	(PAD),A
	CALL	WAIT
	RLCA
	JP	NC,PLP1
	LD	A,D
	CP	0
	JP	NZ,NBCW
	LD	A,E
	CP	0
	JP	NZ,PACCW
	JP	PBCW
;--------------------------------------
; B�|�[�g���v���
;--------------------------------------
PBCW:	LD	A,00H
	OUT	(PAD),A
	LD	A,01H
PLP2:	OUT	(PBD),A
	CALL	WAIT
	RLCA
	JP	NC,PLP2
	LD	A,D
	CP	0
	JP	NZ,NACW
	LD	A,E
	CP	0
	JP	NZ,PBCCW
	JP	PACW
;--------------------------------------
; A�|�[�g�����v���
;--------------------------------------
PACCW:	LD	A,00H
	OUT	(PBD),A
	LD	A,80H
PLP3:	OUT	(PAD),A
	CALL	WAIT
	RRCA
	JP	NC,PLP3
	LD	A,D
	CP	0
	JP	NZ,NBCCW
	LD	A,E
	CP	0FFH
	JP	NZ,PACW
	JP	PBCCW
;--------------------------------------
; B�|�[�g�����v���
;--------------------------------------
PBCCW:	LD	A,00H
	OUT	(PAD),A
	LD	A,80H
PLP4:	OUT	(PBD),A
	CALL	WAIT
	RRCA
	JP	NC,PLP4
	LD	A,D
	CP	0
	JP	NZ,NACCW
	LD	A,E
	CP	0FFH
	JP	NZ,PBCW
	JP	PACCW
;--------------------------------------
; A�|�[�g�r�b�g���]���v���
;--------------------------------------
NACW:	LD	A,0FFH
	OUT	(PBD),A
	LD	A,0FEH
NLP1:	OUT	(PAD),A
	CALL	WAIT
	RLCA
	JP	C,NLP1
	LD	A,D
	CP	0FFH
	JP	NZ,PBCW
	LD	A,E
	CP	0
	JP	NZ,NACCW
	JP	NBCW
;--------------------------------------
; B�|�[�g�r�b�g���]���v���
;--------------------------------------
NBCW:	LD	A,0FFH
	OUT	(PAD),A
	LD	A,0FEH
NLP2:	OUT	(PBD),A
	CALL	WAIT
	RLCA
	JP	C,NLP2
	LD	A,D
	CP	0FFH
	JP	NZ,PACW
	LD	A,E
	CP	0
	JP	NZ,NBCCW
	JP	NACW
;--------------------------------------
; A�|�[�g�r�b�g���]�����v���
;--------------------------------------
NACCW:	LD	A,0FFH
	OUT	(PBD),A
	LD	A,7FH
NLP3:	OUT	(PAD),A
	CALL	WAIT
	RRCA
	JP	C,NLP3
	LD	A,D
	CP	0FFH
	JP	NZ,PBCCW
	LD	A,E
	CP	0FFH
	JP	NZ,NACW
	JP	NBCCW
;--------------------------------------
; A�|�[�g�r�b�g���]�����v���
;--------------------------------------
NBCCW:	LD	A,0FFH
	OUT	(PAD),A
	LD	A,7FH
NLP4:	OUT	(PBD),A
	CALL	WAIT
	RRCA
	JP	C,NLP4
	LD	A,D
	CP	0FFH
	JP	NZ,PACCW
	LD	A,E
	CP	0FFH
	JP	NZ,NBCW
	JP	NACCW
;--------------------------------------
; SW0 ���荞�� : ��]�𐔕b�Ԓ�~
;--------------------------------------
INT0:	PUSH	AF
	LD	A,30
INT01:	CALL	WAIT
	DEC	A
	JP	NZ,INT01
	POP	AF
	EI
	RETI
;--------------------------------------
; SW1 ���荞�� : ��]��~ + 5��_��
;--------------------------------------
INT1:	PUSH	AF
	LD	B,10
	LD	A,0
INT11:	OUT	(PAD),A
	OUT	(PBD),A
	CALL	WAIT
	CPL
	DJNZ	INT11
	LD	A,0
	OUT	(PBD),A
	POP	AF
	EI
	RETI
;--------------------------------------
; SW2 ���荞�� : �t��]
;--------------------------------------
INT2:	PUSH	AF
	LD	A,E
	CPL
	LD	E,A
	POP	AF
	EI
	RETI
;--------------------------------------
; SW3 ���荞�� : �_���E�����̓���ւ�
;--------------------------------------
INT3:	PUSH	AF
	LD	A,D
	CPL
	LD	D,A
	POP	AF
	EI
	RETI
;--------------------------------------
; �T�u���[�`��
;--------------------------------------
;
;----------------------------
; ���̐ݒ�
;----------------------------
WDTINI:	DI
	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	RET
;----------------------------
; CPU�̐ݒ�
;----------------------------
CPUINI:	IM	2
	LD	A,90H
	LD	I,A
	RET
;----------------------------
; CTC�̐ݒ�
;----------------------------
CTCINI:	LD	A,0
	OUT	(CTC),A
	LD	BC,410H
	LD	DE,0D501H
CI1:	OUT	(C),D
	OUT	(C),E
	INC	C
	DJNZ	CI1
	RET
;----------------------------
; PIO�̐ݒ�
;----------------------------
PIOINI:	LD	A,0CFH
	OUT	(PAC),A
	LD	A,0
	OUT	(PAC),A
	LD	A,0CFH
	OUT	(PBC),A
	LD	A,0
	OUT	(PBC),A
	RET
;----------------------------
; ���荞�݂̐ݒ�
;----------------------------
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
; ���ԑ҂�
;----------------------------
WAIT:	PUSH	BC
	LD	B,0
WA2:	LD	C,0
WA1:	DEC	C
	JP	NZ,WA1
	DEC	B
	JP	NZ,WA2
	POP	BC
	RET
;----------------------------
	END
;[EOF]