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
LOOP:	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- �E�V�t�g
	LD	B,13H
RSHIFT:	CALL	R000
	LD	A,1CH
	CALL	INSSET
	CALL	SLEEP
	DEC	B
	JP	NZ,RSHIFT
;-- �߂��ď���
	CALL	R000
	LD	A,80H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- ����
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- �߂��ď���
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- ����
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- �߂��ď���
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- ����
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- ���V�t�g
	LD	B,13H
LSHIFT:	CALL	R000
	LD	A,18H
	CALL	INSSET
	CALL	SLEEP
	DEC	B
	JP	NZ,LSHIFT
;-- �߂��ď���
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- ���
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- �߂��ď���
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- ���
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- �߂��ď���
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- ���
	CALL	R000
	LD	A,80H
	CALL	INSSET
	CALL	R010
;-- �߂�
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
;----------------------------
; ������Ƒ҂�
;----------------------------
SLEEP:	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
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
WAIT:	PUSH	BC
	PUSH	DE
	LD	B,01H
W1:	LD	C,0FFH
W2:	LD	D,0FFH
W3:	DEC	D
	JP	NZ,W3
	DEC	C
	JP	NZ,W2
	DEC	B
	JP	NZ,W1
	POP	DE
	POP	BC
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