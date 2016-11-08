HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
PPA0	EQU	30H
PPB0	EQU	31H
PPC0	EQU	32H
PPR0	EQU	33H
PPA1	EQU	34H
PPB1	EQU	35H
PPC1	EQU	36H
PPR1	EQU	37H
;
	ORG	8000H
;
;--------------------------------------
; ������
;--------------------------------------
	LD	SP,00H
	CALL	WDTINI
	CALL	PPIINI
	CALL	PIOINI
;----------------------------
	CALL	WAIT
;----------------------------
	CALL	INSINI	; ������
	CALL	CLEAR	; �\�����N���A
	CALL	INSINI	; �ď�����
;----------------------------
	CALL	WAIT
	CALL	WAIT
;------------------------------------------------
; ���C�����[�`��
;------------------------------------------------
	CALL	CLEAR	; �\�����N���A
	CALL	INSINI	; �Đݒ�
	CALL	R010	; ���܂��Ȃ�
;----------------------------
	LD	HL,3F00H
;----------------------------
	LD	(DATA),HL
MUSIC:	LD	HL,MDATA
	LD	E,00H
	CALL	TITLE
MUS:	LD	A,(HL)
	AND	A
	JP	Z,MUSIC
;----------------------------
	LD	A,(HL)
	CP	0FEH
	JP	NZ,MUC
	CALL	MSG
	INC	E
	INC	HL
	LD	A,(HL)
;----------------------------
MUC:	INC	HL
	LD	C,(HL)
	LD	B,A
	INC	A
	JP	Z,MUS2
	PUSH	HL
	CALL	MSUB1
	POP	HL
;
MMM:	INC	HL
	JP	MUS
;--------------------------------------
; ����
;--------------------------------------
MSUB1:	LD	HL,(DATA)
J2:	LD	D,B
	LD	A,80H
	OUT	(PPC1),A
J3:	DEC	HL
	LD	A,H
	AND	A
	JP	NZ,J4
	LD	HL,(DATA)
	DEC	C
	RET	Z
J4:	DEC	D
	JP	NZ,J3
	LD	D,B
	LD	A,00H
	OUT	(PPC1),A
J5:	DEC	HL
	LD	A,H
	AND	A
	JP	NZ,J6
	LD	HL,(DATA)
	DEC	C
	RET	Z
J6:	DEC	D
	JP	NZ,J5
	JP	J2
;--------------------------------------
; �x��
;--------------------------------------
MUS2:	PUSH	HL
	LD	HL,(DATA)
J11:	LD	D,B
	NOP
	NOP
J12:	DEC	HL
	LD	A,H
	AND	A
	JP	NZ,J13
	LD	HL,(DATA)
	DEC	C
	JP	Z,J14
J13:	DEC	D
	JP	NZ,J12
	JP	J11
J14:	POP	HL
	JP	MMM
;--------------------------------------
; �e�[�u��
;--------------------------------------
DATA:	DB	00H,00H
;--------------------------------------
MDATA:	DB	0FEH
;----------------------------
	DB	44H,08H	; �\
	DB	66H,08H	; �h
	DB	66H,08H	; �h
	DB	5DH,08H	; ��
	DB	53H,08H	; �~
	DB	44H,08H	; �\
	DB	44H,11H	; �\
;----------------------------
	DB	0FEH
;----------------------------
	DB	3CH,08H	; ��
	DB	4DH,08H	; �t�@
	DB	33H,08H	; �h
	DB	3CH,08H	; ��
	DB	44H,08H	; �\
	DB	3CH,08H	; ��
	DB	44H,11H	; �\
;----------------------------
	DB	0FEH
;----------------------------
	DB	53H,08H	; �~
	DB	53H,08H	; �~
	DB	5DH,08H	; ��
	DB	66H,08H	; �h
	DB	5DH,08H	; ��
	DB	44H,08H	; �\
	DB	44H,11H	; �\
;----------------------------
	DB	0FEH
;----------------------------
	DB	3CH,08H	; ��
	DB	3CH,08H	; ��
	DB	44H,08H	; �\
	DB	66H,08H	; �h
	DB	53H,08H	; �~
	DB	5DH,08H	; ��
	DB	66H,11H	; �h
;----------------------------
	DB	0FEH
;----------------------------
	DB	33H,08H	; �h
	DB	33H,08H	; �h
	DB	33H,08H	; �h
	DB	33H,08H	; �h
	DB	33H,08H	; �h
	DB	3CH,08H	; ��
	DB	44H,11H	; �\
;----------------------------
	DB	0FEH
;----------------------------
	DB	66H,08H	; �h
	DB	66H,08H	; �h
	DB	5DH,08H	; ��
	DB	53H,08H	; �~
	DB	44H,08H	; �\
	DB	53H,08H	; �~
	DB	5DH,08H	; ��
	DB	66H,11H	; �h
;----------------------------
	DB	00H
;------------------------------------------------
; �T�u���[�`��
;------------------------------------------------
;
;--------------------------------------
; �^�C�g���̕\�� + ���ԑ҂�
;--------------------------------------
TITLE:	PUSH	AF
	PUSH	BC
;----------------------------
	CALL	CLEAR
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0ACH	; ��
	CALL	WRITE
	LD	A,0CEH	; �z
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
;----------------------------
	LD	A,05H
	LD	B,0FFH
SLEEP:	CALL	WAIT
	DJNZ	SLEEP
	DEC	A
	LD	B,0FFH
	JP	NZ,SLEEP
	POP	BC
	POP	AF
	RET
;--------------------------------------
; �̎��̕\��
;--------------------------------------
MSG:	PUSH	AF
	LD	A,E
	CP	00H
	JP	NZ,MSG1
	CALL	MES0
	JP	ENDMSG
MSG1:	CP	01H
	JP	NZ,MSG2
	CALL	MES1
	JP	ENDMSG
MSG2:	CP	02H
	JP	NZ,MSG3
	CALL	MES2
	JP	ENDMSG
MSG3:	CP	03H
	JP	NZ,MSG4
	CALL	MES3
	JP	ENDMSG
MSG4:	CP	04H
	JP	NZ,MSG5
	CALL	MES4
	JP	ENDMSG
MSG5:	CP	05H
	JP	NZ,ENDMSG
	CALL	MES5
ENDMSG:	POP	AF
	RET
;--------------------------------------
MES0:	PUSH	AF
	CALL	CLEAR
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0ACH	; ��
	CALL	WRITE
	LD	A,0CEH	; �z
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES1:	PUSH	AF
	CALL	CLEAR
	LD	A,0D4H	; ��
	CALL	WRITE
	LD	A,0C8H	; �l
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0C3H	; �e
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES2:	PUSH	AF
	CALL	CLEAR
	LD	A,0D4H	; ��
	CALL	WRITE
	LD	A,0C8H	; �l
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0C3H	; �e
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C3H	; �e
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES3:	PUSH	AF
	CALL	CLEAR
	LD	A,0BAH	; �R
	CALL	WRITE
	LD	A,0DCH	; ��
	CALL	WRITE
	LD	A,0DAH	; ��
	CALL	WRITE
	LD	A,0C3H	; �e
	CALL	WRITE
	LD	A,0B7H	; �L
	CALL	WRITE
	LD	A,0B4H	; �G
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES4:	PUSH	AF
	CALL	CLEAR
	LD	A,0B6H	; �J
	CALL	WRITE
	LD	A,0BEH	; �Z
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0B6H	; �J
	CALL	WRITE
	LD	A,0BEH	; �Z
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0CCH	; �t
	CALL	WRITE
	LD	A,0B8H	; �N
	CALL	WRITE
	LD	A,0C5H	; �i
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES5:	PUSH	AF
	CALL	CLEAR
	CALL	CLEAR
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0ACH	; ��
	CALL	WRITE
	LD	A,0CEH	; �z
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0CAH	; �n
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0BFH	; �\
	CALL	WRITE
	POP	AF
	RET
;------------------------------------------------
; �T�u���[�`�� : Z80
;------------------------------------------------
;
;--------------------------------------
; ���̐ݒ�
;--------------------------------------
WDTINI:	DI
	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	EI
	RET
;--------------------------------------
; PIO�̐ݒ�
;--------------------------------------
PIOINI:	LD	A,0CFH
	OUT	(PAC),A
	LD	A,00H
	OUT	(PAC),A
;----------------------------
	LD	A,0CFH
	OUT	(PBC),A
	LD	A,00H
	OUT	(PBC),A
	RET
;--------------------------------------
; PPI�̐ݒ�
;--------------------------------------
PPIINI:	LD	A,99H
	OUT	(PPR0),A
	LD	A,81H
	OUT	(PPR1),A
	RET
;--------------------------------------
; ���ԑ҂�
;--------------------------------------
WAIT:	PUSH	BC
	LD	C,0AH
WW1:	LD	B,00H
WW2:	DEC	B
	JP	NZ,WW2
	DEC	C
	JP	NZ,WW1
	POP	BC
	RET
;------------------------------------------------
; �T�u���[�`�� : LCD���W���[��
;------------------------------------------------
;
;----------------------------
; �C���X�g���N�V�����̐ݒ�
;----------------------------
INSINI:	CALL	R000
	CALL	WAIT
;
; �t�@���N�V�����Z�b�g�F
;   �C���^�[�t�F�C�X�f�[�^��8bit
;   �f���[�e�B16����1
;   5x7�h�b�g�}�g���N�X
;
	LD	A,38H
	CALL	INSSET
;
; �\���I���I�t�F
;   �\��ON
;   �J�[�\��/�u�����NOFF
;
	LD	A,0CH
	CALL	INSSET
;
; �G���g���[���[�h
;   �J�[�\���̓C���N�������g
;   �\���̓V�t�g���Ȃ�
;
	LD	A,06H
	CALL	INSSET
;
	RET
;----------------------------
; �C���X�g���N�V�����ݒ�̍�
;----------------------------
INSSET:	CALL	R001
	OUT	(PAD),A
	CALL	WAIT
	CALL	R000
	RET
;----------------------------
; CGRAM/DDRAM�ɏ�������
;----------------------------
WRITE:	CALL	R011
	OUT	(PAD),A
	CALL	WAIT
	CALL	R010
	RET
;----------------------------
; �\�����N���A
;----------------------------
CLEAR:	PUSH	AF
	LD	A,01H
	CALL	INSSET
	POP	AF
	RET
;--------------------------------------
; �C���g���N�V�����̐ݒ�[�J�n/�I��]
;--------------------------------------
R000:	PUSH	AF
	LD	A,00H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
; �C���g���N�V�����̐ݒ蒆
;--------------------------------------
R001:	PUSH	AF
	LD	A,04H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
; �����f�[�^��������[�J�n/�I��]
;--------------------------------------
R010:	PUSH	AF
	LD	A,01H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
; �����f�[�^�������ݒ�
;--------------------------------------
R011:	PUSH	AF
	LD	A,05H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
	END
;[EOF]