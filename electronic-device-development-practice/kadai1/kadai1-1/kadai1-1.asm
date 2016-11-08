HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
;
CTC0	EQU	10H
CTC1	EQU	11H
CTC2	EQU	12H
CTC3	EQU	13H
;
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;----------------------------
; ����
;----------------------------
TYO01	EQU	9000H	; �� 1����
TYO10	EQU	9001H	; �� 2����
;----------------------------
; ���ʎ���
;----------------------------
MIN01	EQU	9002H	; �� 1����
MIN10	EQU	9003H	; �� 2����
SEC01	EQU	9004H	; �b 1����
SEC10	EQU	9005H	; �b 2����
;----------------------------
; �����h��	: ���� - 9����
;----------------------------
LND01	EQU	9006H	; �� 1����
LND10	EQU	9007H	; �� 2����
;----------------------------
; �����g���I�[��: ���� - 14����
;----------------------------
MTR01	EQU	9008H	; �� 1����
MTR10	EQU	9009H	; �� 2����
;----------------------------
; ���T���[���X	: ���� - 17����
;----------------------------
LSS01	EQU	900AH	; �� 1����
LSS10	EQU	900BH	; �� 2����
;--------------------------------------
	ORG	8000H
;------------------------------------------------
; ������
;------------------------------------------------
	LD	SP,00H
	DI
	CALL	WDTINI
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	IVSET
;----------------------------
	CALL	INSINI
	CALL	CLEAR
	CALL	INSINI
	CALL	R010
;----------------------------
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
;----------------------------
; �g�E�L���E�̕\��
;----------------------------
	LD	A,0C4H	;�g
	CALL	WRITE
	LD	A,0B3H	;�E
	CALL	WRITE
	LD	A,0B7H	;�L
	CALL	WRITE
	LD	A,0AEH	;��
	CALL	WRITE
	LD	A,0B3H	;�E
	CALL	WRITE
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
; �����h���̕\��
;----------------------------
	LD	A,0DBH	; ��
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
;----------------------------
	CALL	R000
	LD	A,094H
	CALL	INSSET
	CALL	R010
;----------------------------
; �����g���I�[���̕\��
;----------------------------
	LD	A,0D3H	; ��
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0C4H	; �g
	CALL	WRITE
	LD	A,0D8H	; ��
	CALL	WRITE
	LD	A,0B5H	; �I
	CALL	WRITE
	LD	A,0B0H	; �[
	CALL	WRITE
	LD	A,0D9H	; ��
	CALL	WRITE
;----------------------------
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;----------------------------
; ���T���[���X�̕\��
;----------------------------
	LD	A,0DBH	; ��
	CALL	WRITE
	LD	A,0BBH	; �T
	CALL	WRITE
	LD	A,0DDH	; ��
	CALL	WRITE
	LD	A,0BEH	; �Z
	CALL	WRITE
	LD	A,0DEH	; (���_)
	CALL	WRITE
	LD	A,0D9H	; ��
	CALL	WRITE
	LD	A,0BDH	; �X
	CALL	WRITE
;----------------------------
; ���ʎ��Ԑݒ�
;----------------------------
	LD	A,00H;;;09H
	LD	(MIN01),A
	LD	A,00H;;;05H
	LD	(MIN10),A
;----------------------------
	LD	A,00H
	LD	(SEC01),A
	LD	A,00H;;;05H
	LD	(SEC10),A
;----------------------------
; �����̎��Ԑݒ�
;----------------------------
	LD	A,00H
	LD	(TYO01),A
	LD	A,00H
	LD	(TYO10),A
;----------------------------
; �����h���̎��Ԑݒ�
;----------------------------
	LD	A,05H
	LD	(LND01),A
	LD	A,01H
	LD	(LND10),A
;----------------------------
; �����g���I�[���̎��Ԑݒ�
;----------------------------
	LD	A,00H
	LD	(MTR01),A
	LD	A,01H
	LD	(MTR10),A
;----------------------------
; ���T���[���X�̎��Ԑݒ�
;----------------------------
	LD	A,07H
	LD	(LSS01),A
	LD	A,00H
	LD	(LSS10),A
;------------------------------------------------
; ���C�����[�`��
;------------------------------------------------
	EI
	JR	$
;------------------------------------------------
; ���荞�� / �^�C�}�[
;------------------------------------------------
;
;----------------------------
; �����𕶎��ɕϊ�
;---------------------------- �b : 1����
INT1:	LD	A,(SEC01)
	INC	A
	CP	0AH
	JP	NZ,INT10
	LD	A,00H
	LD	(SEC01),A
	JP	SEC010
INT10:	LD	(SEC01),A
	JP	TIMER
;---------------------------- �b : 2����
SEC010:	LD	A,(SEC10)
	INC	A
	CP	06H
	JP	NZ,INT11
	LD	A,00H
	LD	(SEC10),A
	JP	MIN001
INT11:	LD	(SEC10),A
	JP	TIMER
;---------------------------- �� : 1����
MIN001:	LD	A,(MIN01)
	INC	A
	CP	0AH
	JP	NZ,INT12
	LD	A,00H
	LD	(MIN01),A
	JP	MIN010
INT12:	LD	(MIN01),A
	JP	TIMER
;---------------------------- �� : 2����
MIN010:	LD	A,(MIN10)
	INC	A
	CP	06H
	JP	NZ,INT13
	LD	A,00H
	LD	(MIN10),A
	JP	TYO001
INT13:	LD	(MIN10),A
	JP	TIMER
;---------------------------- ���� : 1����
TYO001:	LD	A,(TYO10)
	CP	02H
	JP	Z,INT15
;----------------------------
	LD	A,(TYO01)
	INC	A
	CP	0AH
	JP	NZ,INT14
	LD	A,00H
	LD	(TYO01),A
	JP	TYO010
INT14:	LD	(TYO01),A
	JP	LND001
;----------------------------
INT15:	LD	A,(TYO01)
	INC	A
	CP	04H
	JP	INT16
	LD	(TYO01),A
	JP	LND001
INT16:	LD	A,00H
	LD	(TYO10),A
	LD	(TYO01),A
	JP	LND001
;---------------------------- ���� : 2����
TYO010:	LD	A,(TYO10)
	INC	A
	LD	(TYO10),A
;---------------------------- �����h��
LND001:	LD	A,(LND10)
	CP	02H
	JP	Z,INT18
;----------------------------
	LD	A,(LND01)
	INC	A
	CP	0AH
	JP	NZ,INT17
	LD	A,00H
	LD	(LND01),A
	JP	LND010
INT17:	LD	(LND01),A
	JP	MTR001
;----------------------------
INT18:	LD	A,(LND01)
	INC	A
	CP	04H
	JP	INT16
	LD	(LND01),A
	JP	LND001
INT19:	LD	A,00H
	LD	(LND10),A
	LD	(LND01),A
	JP	MTR001
;---------------------------- �����h�� : 2����
LND010:	LD	A,(LND10)
	INC	A
	LD	(LND10),A
;---------------------------- �����g���I�[��
MTR001:	LD	A,(MTR10)
	CP	02H
	JP	Z,INT1B
;----------------------------
	LD	A,(MTR01)
	INC	A
	CP	0AH
	JP	NZ,INT1A
	LD	A,00H
	LD	(MTR01),A
	JP	MTR010
INT1A:	LD	(MTR01),A
	JP	LSS001
;----------------------------
INT1B:	LD	A,(MTR01)
	INC	A
	CP	04H
	JP	INT1C
	LD	(MTR01),A
	JP	LSS001
INT1C:	LD	A,00H
	LD	(MTR10),A
	LD	(MTR01),A
	JP	LSS001
;---------------------------- �����g���I�[�� : 2����
MTR010:	LD	A,(MTR10)
	INC	A
	LD	(MTR10),A
;---------------------------- ���T���[���X
LSS001:	LD	A,(LSS10)
	CP	02H
	JP	Z,INT1E
;----------------------------
	LD	A,(LSS01)
	INC	A
	CP	0AH
	JP	NZ,INT1D
	LD	A,00H
	LD	(LSS01),A
	JP	LSS010
INT1D:	LD	(LSS01),A
	JP	TIMER
;----------------------------
INT1E:	LD	A,(LSS01)
	INC	A
	CP	04H
	JP	INT1F
	LD	(LSS01),A
	JP	TIMER
INT1F:	LD	A,00H
	LD	(LSS10),A
	LD	(LSS01),A
	JP	TIMER
;---------------------------- ���T���[���X : 2����
LSS010:	LD	A,(LSS10)
	INC	A
	LD	(LSS10),A
;--------------------------------------
; �����̕\�� : ����
;--------------------------------------
; �L�����b�g�̈ړ�
;----------------------------
TIMER:	CALL	R000
	LD	A,89H
	CALL	INSSET
	CALL	R010
;---------------------------- �� : 2����
	LD	A,(TYO10)
	CALL	HOUR
;---------------------------- �� : 1����
	LD	A,(TYO01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;--------------------------------------
; �����̕\�� : �����h��
;--------------------------------------
; �L�����b�g�̈ړ�
;----------------------------
	CALL	R000
	LD	A,0C9H
	CALL	INSSET
	CALL	R010
;---------------------------- �� : 2����
	LD	A,(LND10)
	CALL	HOUR
;---------------------------- �� : 1����
	LD	A,(LND01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;--------------------------------------
; �����̕\�� : �����g���I�[��
;--------------------------------------
; �L�����b�g�̈ړ�
;----------------------------
	CALL	R000
	LD	A,09DH
	CALL	INSSET
	CALL	R010
;---------------------------- �� : 2����
	LD	A,(MTR10)
	CALL	HOUR
;---------------------------- �� : 1����
	LD	A,(MTR01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;--------------------------------------
; �����̕\�� : ���T���[���X
;--------------------------------------
; �L�����b�g�̈ړ�
;----------------------------
	CALL	R000
	LD	A,0DDH
	CALL	INSSET
	CALL	R010
;---------------------------- �� : 2����
	LD	A,(LSS10)
	CALL	HOUR
;---------------------------- �� : 1����
	LD	A,(LSS01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;----------------------------
	EI
	RETI
;------------------------------------------------
; �T�u���[�`��
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
; �ȒP�C���X�g���N�V�����ݒ�
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
;----------------------------
; �ȒP���ԏ�������
;----------------------------
HOUR:	ADD	A,30H
	CALL	WRITE
	RET
;----------------------------
; �R������\��
;----------------------------
CORON:	LD	A,3AH
	CALL	WRITE
	RET
;----------------------------
; �R���� + �� + �R���� + �b
;----------------------------
TIME:	CALL	CORON
;----------------------------
	LD	A,(MIN10)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	LD	A,(MIN01)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	CALL	CORON
;----------------------------
	LD	A,(SEC10)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	LD	A,(SEC01)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	RET
;--------------------------------------
;
;----------------------------
; WDTINI�̐ݒ�
;----------------------------
WDTINI:	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	RET
;----------------------------
; CPUINI�̐ݒ�
;----------------------------
CPUINI:	IM	2
	LD	A,8FH
	LD	I,A
	RET
;----------------------------
; CTCINI�̐ݒ�
;----------------------------
CTCINI:	LD	A,0
	OUT	(CTC0),A
	LD	A,0D5H
	OUT	(CTC2),A
	LD	A,150
	OUT	(CTC2),A
	LD	A,35H
	OUT	(CTC3),A
	LD	A,0
	OUT	(CTC3),A
	RET
;----------------------------
; PIOINI�̐ݒ�
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
; IVSET�̐ݒ�
;----------------------------
IVSET:	LD	BC,INT1
	LD	(8F04H),BC
	RET
;--------------------------------------
;
;----------------------------
; ���ԑ҂�
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
; ���ԑ҂�(����)
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
; �C���X�g���N�V�����̐ݒ�[�J�n/�I��]
;----------------------------
R000:	PUSH	AF
	LD	A,00H
	OUT	(PBD),A
	POP	AF
	RET
;----------------------------
; �C���X�g���N�V�����̐ݒ�
;----------------------------
R001:	PUSH	AF
	LD	A,04H
	OUT	(PBD),A
	POP	AF
	RET
;----------------------------
; �����f�[�^��������[�J�n/�I��]
;----------------------------
R010:	PUSH	AF
	LD	A,01H
	OUT	(PBD),A
	POP	AF
	RET
;----------------------------
; �����f�[�^��������
;----------------------------
R011:	PUSH	AF
	LD	A,05H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
	END
;[EOF]