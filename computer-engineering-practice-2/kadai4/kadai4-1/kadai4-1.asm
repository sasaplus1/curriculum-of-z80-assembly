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
;--------------------------------------
; ������
;--------------------------------------
	LD	SP,00H
	CALL	WDTINI
	CALL	PPIINI
	CALL	PIOINI
	CALL	CHANEL
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
	CALL	STR1	; �����񏑂�����
;----------------------------
	LD	A,30H	; 0
	CALL	WRITE	; ������������
;----------------------------
	CALL	STR2	; �����񏑂�����
;----------------------------
; 2�s�ڂֈړ�
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	CALL	STR1	; �����񏑂�����
;----------------------------
	LD	A,37H	; 7
	CALL	WRITE	; ������������
;----------------------------
	CALL	STR2	; �����񏑂�����
;----------------------------
MAIN:	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,L1
;----------------------------
; �`�����l���؂�ւ�
;----------------------------
LOOP:	CALL	SWCNL2
;----------------------------
	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,L2
;----------------------------
	JP	MAIN
;----------------------------
; ���͒[�q1
;----------------------------
L1:	LD	HL,TABLE
	LD	A,E
	RRA
	RRA
	RRA
	RRA
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 1���ڂ̏ꏊ�ֈړ�
;----------------------------
	CALL	R000
	LD	A,8EH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
;----------------------------
R1:	LD	HL,TABLE
	LD	A,E
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 2���ڂ̏ꏊ�ֈړ�
;----------------------------
	CALL	R000
	LD	A,8FH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
;----------------------------
	JP	LOOP
;----------------------------
; ���͒[�q2
;----------------------------
L2:	LD	HL,TABLE
	LD	A,E
	RRA
	RRA
	RRA
	RRA
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 1���ڂ̏ꏊ�ֈړ�
;----------------------------
	CALL	R000
	LD	A,0CEH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
;----------------------------
R2:	LD	HL,TABLE
	LD	A,E
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 2���ڂ̏ꏊ�ֈړ�
;----------------------------
	CALL	R000
	LD	A,0CFH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
;----------------------------
; �`�����l���؂�ւ�
;----------------------------
	CALL	SWCNL1
;----------------------------
	JP	MAIN
;--------------------------------------
; �e�[�u��
;--------------------------------------
TABLE:	DB	30H,31H,32H,33H	; 0,1,2,3
	DB	34H,35H,36H,37H	; 4,5,6,7
	DB	38H,39H,41H,42H	; 8,9,A,B
	DB	43H,44H,45H,46H	; C,D,E,F
;------------------------------------------------
; �T�u���[�`��
;------------------------------------------------
;
;--------------------------------------
; ������̏�������
;--------------------------------------
STR1:	PUSH	AF
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0B1H	; �A
	CALL	WRITE
	LD	A,0C5H	; �i
	CALL	WRITE
	LD	A,0DBH	; ��
	CALL	WRITE
	LD	A,0B8H	; �N
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0C6H	; �j
	CALL	WRITE
	LD	A,0ADH	; ��
	CALL	WRITE
	LD	A,0B3H	; �E
	CALL	WRITE
	LD	A,0D8H	; ��
	CALL	WRITE
	LD	A,0AEH	; ��
	CALL	WRITE
	LD	A,0B8H	; �N
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
STR2:	PUSH	AF
	LD	A,3DH	; =
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X) x 2
	CALL	WRITE
	CALL	WRITE
	LD	A,48H	; H
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
; ���o�͂̃`�����l����؂�ւ�
;--------------------------------------
SWCNL1:	PUSH	AF
	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
;----------------------------
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
;----------------------------
	POP	AF
	RET
;--------------------------------------
; ���o�͂̃`�����l����؂�ւ�
;--------------------------------------
SWCNL2:	PUSH	AF
	LD	A,0F7H
	OUT	(PPB0),A
	LD	A,0FFH
	OUT	(PPB0),A
;----------------------------
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
;----------------------------
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
PPIINI:	LD	A,90H
	OUT	(PPR0),A
	LD	A,80H
	OUT	(PPR1),A
	RET
;--------------------------------------
; �`�����l���̐ݒ�
;--------------------------------------
CHANEL:	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
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