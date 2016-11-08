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
;------------------------------------------------
	LD	A,6EH	; n
	CALL	WRITE
	LD	A,75H	; u
	CALL	WRITE
	LD	A,6CH	; l
	CALL	WRITE
	CALL	WRITE
;--------------------------------------
; �������[�v
;--------------------------------------
	EI
	JR	$
;------------------------------------------------
; ���荞�݃��[�`��
;------------------------------------------------
;
;--------------------------------------
; Switch : 0
;--------------------------------------
INT0:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,30H	; 0
	CALL	WRITE
	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 1
;--------------------------------------
INT1:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,31H	; 1
	CALL	WRITE
	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 2
;--------------------------------------
INT2:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,32H	; 2
	CALL	WRITE
	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 3
;--------------------------------------
INT3:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,33H	; 3
	CALL	WRITE
	POP	AF
	EI
	RETI
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
	LD	A,01111011B
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
	LD	B,0
WA2:	LD	C,0
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