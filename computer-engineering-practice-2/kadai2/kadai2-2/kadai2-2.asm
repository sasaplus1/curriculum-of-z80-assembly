HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
;
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;
	ORG	8000H
;
	LD	SP,0
	CALL	WDTINI
	CALL	PIOINI
;--------------------------------------
; ������
;--------------------------------------
	CALL	INSINI
;--------------------------------------
; �f�B�X�v���C�̃N���A
;--------------------------------------
	LD	A,01H
	CALL	INSSET
;--------------------------------------
; �ēx������
;--------------------------------------
	CALL	INSINI
;--------------------------------------
; ���C�����[�`��
;--------------------------------------
	CALL	R010
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- ���s(2�s�ڂ�)
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- ���s(3�s�ڂ�)
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- ���s(4�s�ڂ�)
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- _
	LD	A,5FH
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;-- )
	LD	A,29H
	CALL	WRITE
;-- �m
	LD	A,0C9H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- (
	LD	A,28H
	CALL	WRITE
;-- T
	LD	A,54H
	CALL	WRITE
;--------------------------------------
; ���փV�t�g
;--------------------------------------
;
;--------------------------------------
LOOP:	CALL	INSINI
	LD	A,02H
SLEEP:	CALL	WAIT
	DEC	A
	JP	NZ,SLEEP
;-- ���V�t�g ----------------
	CALL	R000
	LD	A,18H
	CALL	INSSET
;-- �߂� --------------------
	JP	LOOP
;--------------------------------------
; �T�u���[�`��
;--------------------------------------
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
WAIT:	LD	B,01H
W1:	LD	C,0FFH
W2:	LD	D,0FFH
W3:	DEC	D
	JP	NZ,W3
	DEC	C
	JP	NZ,W2
	DEC	B
	JP	NZ,W1
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
;
	END
;[EOF]