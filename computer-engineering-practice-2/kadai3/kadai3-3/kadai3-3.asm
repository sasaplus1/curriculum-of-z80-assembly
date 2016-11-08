HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
CTC	EQU	10H
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;--------------------------------------
; �L�[���Ԕ�r�p�萔
;--------------------------------------
KEY0	EQU	0FH	; No.4
KEY1	EQU	02H	; No.1
KEY2	EQU	06H	; No.2
KEY3	EQU	0EH	; No.3
;
	ORG	8000H
;--------------------------------------
; ������ : Z80
;--------------------------------------
	LD	SP,0
	CALL	WDTINI
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	IVSET
;--------------------------------------
; ������ : LCD���W���[��
;--------------------------------------
	CALL	INSINI	; ������
	LD	A,01H	; �f�B�X�v���C�̃N���A
	CALL	INSSET	; �f�B�X�v���C�̃N���A
	CALL	INSINI	; �ď�����
;------------------------------------------------
; ���C�����[�`��
;--------------------------------------
; B : 7 : OK/NG = 0/1
;   : 6 : END?  = 0/1
;   : 5 : null  =   0
;   : 4 : null  =   0
;   : 3 : SW3?  = 0/1
;   : 2 : SW2?  = 0/1
;   : 1 : SW1?  = 0/1
;   : 0 : SW0?  = 0/1
;--------------------------------------
; KEY : SW1 -> SW2 -> SW3 -> SW0
;------------------------------------------------
MAIN:	DI
	LD	B,00H	; ������
;----------------------------
	CALL	CLEAR	; �\�����N���A
	CALL	INSINI	; �Đݒ�
	CALL	R010	; ���܂��Ȃ�
;----------------------------
	LD	A,0BAH	; �R
	CALL	WRITE
	LD	A,0C9H	; �m
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0B2H	; �C
	CALL	WRITE
	LD	A,0BAH	; �R
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0BDH	; �X
	CALL	WRITE
	LD	A,0C3H	; �e
	CALL	WRITE
	LD	A,0D1H	; ��
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0CAH	; �n
	CALL	WRITE
;----------------------------
; 2�s�ڂֈړ�
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0DBH	; ��
	CALL	WRITE
	LD	A,0AFH	; �b
	CALL	WRITE
	LD	A,0B8H	; �N
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0BBH	; �T
	CALL	WRITE
	LD	A,0DAH	; ��
	CALL	WRITE
	LD	A,0C3H	; �e
	CALL	WRITE
	LD	A,0B2H	; �C
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0BDH	; �X
	CALL	WRITE
;----------------------------
; 3�s�ڂֈړ�
;----------------------------
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0CAH	; �n
	CALL	WRITE
	LD	A,0DFH	; (�����_)
	CALL	WRITE
	LD	A,0BDH	; �X
	CALL	WRITE
	LD	A,0DCH	; ��
	CALL	WRITE
	LD	A,0B0H	; �[
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0A6H	; ��
	CALL	WRITE
;----------------------------
; 4�s�ڂֈړ�
;----------------------------
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;----------------------------
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
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0C3H	; �e
	CALL	WRITE
	LD	A,0B8H	; �N
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	LD	A,0DEH	;  (���_)
	CALL	WRITE
	LD	A,0BBH	; �T
	CALL	WRITE
	LD	A,0B2H	; �C
	CALL	WRITE
;----------------------------
; ���荞�݋���
;----------------------------
	EI
;--------------------------------------
; �������[�v
;--------------------------------------
LOOP:	BIT	6,B	; �t���O�͗����Ă�H
	JP	Z,LOOP	; �����ĂȂ������烏�����A
	JP	MAIN	; �ŏ��ɖ߂�
;------------------------------------------------
; ���荞�݃��[�`��
;------------------------------------------------
;
;--------------------------------------
; Switch : 0
;--------------------------------------
INT0:	PUSH	AF
;----------------------------
	CALL	ERASE	; ���߂Ă̓��͂����������
	LD	A,30H	; 0
	CALL	WRITE	; LCD�ɕ\��
;----------------------------
	SET	0,B	; SW0�̃t���O�𗧂Ă�
	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	KEY0	; ���Ԃǂ��肩���ׂ�
	JP	Z,INT01	; ���Ԃǂ���Ȃ�INT01�֔��
	SET	7,B	; ���s�t���O�𗧂Ă�
INT01:	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	0FH	; ���ׂĉ����ꂽ�����ׂ�
	JP	NZ,INT02; ������Ă��Ȃ������瑱����
	CALL	FINISH	; ������Ă�����I������
INT02:	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 1
;--------------------------------------
INT1:	PUSH	AF
;----------------------------
	CALL	ERASE	; ���߂Ă̓��͂����������
	LD	A,31H	; 1
	CALL	WRITE	; LCD�ɕ\��
;----------------------------
	SET	1,B	; SW1�̃t���O�𗧂Ă�
	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	KEY1	; ���Ԃǂ��肩���ׂ�
	JP	Z,INT11	; ���Ԃǂ���Ȃ�INT11�֔��
	SET	7,B	; ���s�t���O�𗧂Ă�
INT11:	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	0FH	; ���ׂĉ����ꂽ�����ׂ�
	JP	NZ,INT12; ������Ă��Ȃ������瑱����
	CALL	FINISH	; ������Ă�����I������
INT12:	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 2
;--------------------------------------
INT2:	PUSH	AF
;----------------------------
	CALL	ERASE	; ���߂Ă̓��͂����������
	LD	A,32H	; 2
	CALL	WRITE	; LCD�ɕ\��
;----------------------------
	SET	2,B	; SW2�̃t���O�𗧂Ă�
	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	KEY2	; ���Ԃǂ��肩���ׂ�
	JP	Z,INT21	; ���Ԃǂ���Ȃ�INT21�֔��
	SET	7,B	; ���s�t���O�𗧂Ă�
INT21:	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	0FH	; ���ׂĉ����ꂽ�����ׂ�
	JP	NZ,INT22; ������Ă��Ȃ������瑱����
	CALL	FINISH	; ������Ă�����I������
INT22:	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 3
;--------------------------------------
INT3:	PUSH	AF
;----------------------------
	CALL	ERASE	; ���߂Ă̓��͂����������
	LD	A,33H	; 3
	CALL	WRITE	; LCD�ɕ\��
;----------------------------
	SET	3,B	; SW3�̃t���O�𗧂Ă�
	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	KEY3	; ���Ԃǂ��肩���ׂ�
	JP	Z,INT31	; ���Ԃǂ���Ȃ�INT31�֔��
	SET	7,B	; ���s�t���O�𗧂Ă�
INT31:	LD	A,B	; 
	AND	0FH	; ����4�r�b�g�����o��
	CP	0FH	; ���ׂĉ����ꂽ�����ׂ�
	JP	NZ,INT32; ������Ă��Ȃ������瑱����
	CALL	FINISH	; ������Ă�����I������
INT32:	POP	AF
	EI
	RETI
;------------------------------------------------
; �T�u���[�`��
;------------------------------------------------
;
;--------------------------------------
; ���߂Ă̓��͂��������������
;--------------------------------------
ERASE:	PUSH	AF
	LD	A,B
	AND	0FH
	CP	00H
	JP	NZ,CANCEL
;----------------------------
	CALL	CLEAR	; �\�����N���A
	CALL	INSINI	; �Đݒ�
	CALL	R010	; ���܂��Ȃ�
;----------------------------
CANCEL:	POP	AF
	RET
;--------------------------------------
; ���ׂẴX�C�b�`��������
;--------------------------------------
FINISH:	PUSH	AF
;----------------------------
; ���b�҂�
;----------------------------
	LD	A,0FH
FNSSLP:	CALL	WAIT
	DEC	A
	JP	NZ,FNSSLP
;----------------------------
	BIT	7,B
	JP	Z,OK
	JP	NG
OK:	CALL	SUCCS
	JP	RETURN
NG:	CALL	ERROR
;----------------------------
RETURN:	SET	6,B	; �I���t���O
;----------------------------
	POP	AF
	RET
;--------------------------------------
; ���͂���
;--------------------------------------
SUCCS:	PUSH	AF
	CALL	CLEAR	; �\�����N���A
	CALL	INSINI	; �Đݒ�
	CALL	R010	; ���܂��Ȃ�
;----------------------------
	LD	A,0DBH	; ��
	CALL	WRITE
	LD	A,0AFH	; �b
	CALL	WRITE
	LD	A,0B8H	; �N
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0CAH	; �n
	CALL	WRITE
;----------------------------
; 2�s�ڂֈړ�
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0B6H	; �J
	CALL	WRITE
	LD	A,0B2H	; �C
	CALL	WRITE
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0AEH	; ��
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0BBH	; �T
	CALL	WRITE
	LD	A,0DAH	; ��
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
;----------------------------
; 10�b�قǑ҂�
;----------------------------
	LD	A,90H
SCCSLP:	CALL	WAIT
	DEC	A
	JP	NZ,SCCSLP
;----------------------------
	POP	AF
	RET
;--------------------------------------
; ���͂��߂�
;--------------------------------------
ERROR:	PUSH	AF
	CALL	CLEAR	; �\�����N���A
	CALL	INSINI	; �Đݒ�
	CALL	R010	; ���܂��Ȃ�
;----------------------------
	LD	A,0B1H	; �A
	CALL	WRITE
	LD	A,0D4H	; ��
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0AFH	; �b
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0CAH	; �n
	CALL	WRITE
	LD	A,0DFH	; (�����_)
	CALL	WRITE
	LD	A,0BDH	; �X
	CALL	WRITE
	LD	A,0DCH	; ��
	CALL	WRITE
	LD	A,0B0H	; �[
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0B6H	; �J
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
;----------------------------
; 2�s�ڂֈړ�
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
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
	LD	A,0A0H	; (�X�y�[�X)
	CALL	WRITE
	LD	A,0BBH	; �T
	CALL	WRITE
	LD	A,0DAH	; ��
	CALL	WRITE
	LD	A,0CFH	; �}
	CALL	WRITE
	LD	A,0BCH	; �V
	CALL	WRITE
	LD	A,0C0H	; �^
	CALL	WRITE
;----------------------------
; 10�b�قǑ҂�
;----------------------------
	LD	A,90H
ERRSLP:	CALL	WAIT
	DEC	A
	JP	NZ,ERRSLP
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
	RET
;--------------------------------------
; CPU�̐ݒ�
;--------------------------------------
CPUINI:	IM	2
	LD	A,90H
	LD	I,A
	RET
;--------------------------------------
; CTC�̐ݒ�
;--------------------------------------
CTCINI:	LD	A,0
	OUT	(CTC),A
	LD	BC,410H
	LD	DE,0D501H
CI1:	OUT	(C),D
	OUT	(C),E
	INC	C
	DJNZ	CI1
	RET
;--------------------------------------
; PIO�̐ݒ�
;--------------------------------------
PIOINI:	LD	A,0CFH
	OUT	(PAC),A
	LD	A,0
	OUT	(PAC),A
	LD	A,0CFH
	OUT	(PBC),A
	LD	A,0
	OUT	(PBC),A
	RET
;--------------------------------------
; ���荞�ݐݒ�
;--------------------------------------
IVSET:	LD	BC,INT0
	LD	(9000H),BC
	LD	BC,INT1
	LD	(9002H),BC
	LD	BC,INT2
	LD	(9004H),BC
	LD	BC,INT3
	LD	(9006H),BC
	RET
;--------------------------------------
; ���ԑ҂�
;--------------------------------------
WAIT:	PUSH	BC
	LD	B,0FFH
WA2:	LD	C,0FFH
WA1:	DEC	C
	JP	NZ,WA1
	DEC	B
	JP	NZ,WA2
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