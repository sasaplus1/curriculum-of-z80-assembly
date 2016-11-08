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
	LD	C,00H
	LD	D,00H
;----------------------------
MAIN:	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,SW1
;----------------------------
; �`�����l���؂�ւ�
;----------------------------
LOOP:	CALL	SWCNL2
;----------------------------
	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,SW2
;----------------------------
	JP	MAIN
;----------------------------
; ���͒[�q1
;----------------------------
SW1:	LD	HL,TABLE
;----------------------------
	LD	B,00H
	CP	B
	JP	Z,SW11
;----------------------------
	LD	B,A
SW10:	INC	HL
	DJNZ	SW10
;----------------------------
	LD	A,(HL)
	CP	C
	JP	Z,SW11
	CALL	CLRLN1
;----------------------------
SW11:	CALL	R000
	LD	A,(HL)
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	C,(HL)
;----------------------------
	LD	A,2AH
	CALL	WRITE
;----------------------------
	JP	LOOP
;----------------------------
; ���͒[�q2
;----------------------------
SW2:	PUSH	BC
	LD	BC,0100H
	LD	HL,TABLE
	ADD	HL,BC
	POP	BC
;----------------------------
	LD	B,00H
	CP	B
	JP	Z,SW21
;----------------------------
	LD	B,A
SW20:	INC	HL
	DJNZ	SW20
;----------------------------
	LD	A,(HL)
	CP	D
	JP	Z,SW21
	CALL	CLRLN2
;----------------------------
SW21:	CALL	R000
	LD	A,(HL)
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	D,(HL)
;----------------------------
	LD	A,2AH
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
TABLE:	DB	80H,80H,80H,80H,80H,80H,80H,80H,80H,80H,80H,80H,80H
	DB	81H,81H,81H,81H,81H,81H,81H,81H,81H,81H,81H,81H,81H
	DB	82H,82H,82H,82H,82H,82H,82H,82H,82H,82H,82H,82H,82H
	DB	83H,83H,83H,83H,83H,83H,83H,83H,83H,83H,83H,83H,83H
	DB	84H,84H,84H,84H,84H,84H,84H,84H,84H,84H,84H,84H
	DB	85H,85H,85H,85H,85H,85H,85H,85H,85H,85H,85H,85H,85H
	DB	86H,86H,86H,86H,86H,86H,86H,86H,86H,86H,86H,86H,86H
	DB	87H,87H,87H,87H,87H,87H,87H,87H,87H,87H,87H,87H,87H
	DB	88H,88H,88H,88H,88H,88H,88H,88H,88H,88H,88H,88H,88H
	DB	89H,89H,89H,89H,89H,89H,89H,89H,89H,89H,89H,89H
	DB	8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH
	DB	8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH
	DB	8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH
	DB	8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH
	DB	8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH
	DB	8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH
	DB	90H,90H,90H,90H,90H,90H,90H,90H,90H,90H,90H,90H,90H
	DB	91H,91H,91H,91H,91H,91H,91H,91H,91H,91H,91H,91H,91H
	DB	92H,92H,92H,92H,92H,92H,92H,92H,92H,92H,92H,92H,82H
	DB	93H,93H,93H,93H,93H,93H,93H,93H,93H,93H,93H,93H
;------------------------------------------------
	DB	0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H
	DB	0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H
	DB	0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H
	DB	0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H
	DB	0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H
	DB	0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H
	DB	0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H
	DB	0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H
	DB	0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H
	DB	0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H
	DB	0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH
	DB	0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH
	DB	0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH
	DB	0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB	0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH
	DB	0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH
	DB	0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H
	DB	0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H
	DB	0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H
	DB	0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H
;------------------------------------------------
; �T�u���[�`��
;------------------------------------------------
;
;--------------------------------------
; 1�s�ڂ�����
;--------------------------------------
CLRLN1:	PUSH	AF
	PUSH	BC
;----------------------------
	CALL	R000
	LD	A,80H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0A0H
	LD	B,14H
CLR01:	CALL	WRITE
	DJNZ	CLR01
;----------------------------
	POP	BC
	POP	AF
	RET
;--------------------------------------
; 2�s�ڂ�����
;--------------------------------------
CLRLN2:	PUSH	AF
	PUSH	BC
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0A0H
	LD	B,14H
CLR02:	CALL	WRITE
	DJNZ	CLR02
;----------------------------
	POP	BC
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