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
; ���C�����[�`��
;--------------------------------------
LOOP:	CALL	INSINI
	CALL	R010
;-- �j
	LD	A,0C6H
	CALL	WRITE
;-- �C
	LD	A,0B2H
	CALL	WRITE
;-- �J
	LD	A,0B6H
	CALL	WRITE
;-- (���_)
	LD	A,0DEH
	CALL	WRITE
;-- �^
	LD	A,0C0H
	CALL	WRITE
;-- �P
	LD	A,0B9H
	CALL	WRITE
;-- ��
	LD	A,0DDH
	CALL	WRITE
;-- ���s(2�s�ڂ�)
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;-- �j
	LD	A,0C6H
	CALL	WRITE
;-- �C
	LD	A,0B2H
	CALL	WRITE
;-- �J
	LD	A,0B6H
	CALL	WRITE
;-- (���_)
	LD	A,0DEH
	CALL	WRITE
;-- �^
	LD	A,0C0H
	CALL	WRITE
;-- �V
	LD	A,0BCH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- �`
	LD	A,0C1H
	CALL	WRITE
;-- ��
	LD	A,0ADH
	CALL	WRITE
;-- �E
	LD	A,0B3H
	CALL	WRITE
;-- �I
	LD	A,0B5H
	CALL	WRITE
;-- �E
	LD	A,0B3H
	CALL	WRITE
;-- �N
	LD	A,0B8H
	CALL	WRITE
;-- ���s(3�s�ڂ�)
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;-- �A
	LD	A,0B1H
	CALL	WRITE
;-- �t
	LD	A,0CCH
	CALL	WRITE
;-- (���_)
	LD	A,0DEH
	CALL	WRITE
;-- �~
	LD	A,0D0H
	CALL	WRITE
;-- 2
	LD	A,32H
	CALL	WRITE
;-- �`
	LD	A,0C1H
	CALL	WRITE
;-- ��
	LD	A,0AEH
	CALL	WRITE
;-- �E
	LD	A,0B3H
	CALL	WRITE
;-- ��
	LD	A,0D2H
	CALL	WRITE
;-- 2
	LD	A,32H
	CALL	WRITE
;-- �n
	LD	A,0CAH
	CALL	WRITE
;-- (���_)
	LD	A,0DEH
	CALL	WRITE
;-- ��
	LD	A,0DDH
	CALL	WRITE
;-- 1
	LD	A,31H
	CALL	WRITE
;-- 3
	LD	A,33H
	CALL	WRITE
;-- �R
	LD	A,0BAH
	CALL	WRITE
;-- (���_)
	LD	A,0DEH
	CALL	WRITE
;-- �E
	LD	A,0B3H
	CALL	WRITE
;-- ���s(4�s�ڂ�)
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;-- �T
	LD	A,0BBH
	CALL	WRITE
;-- �T
	LD	A,0BBH
	CALL	WRITE
;-- �P
	LD	A,0B9H
	CALL	WRITE
;-- (���_)
	LD	A,0DEH
	CALL	WRITE
;-- (�X�y�[�X)
	LD	A,0A0H
	CALL	WRITE
;-- �^
	LD	A,0C0H
	CALL	WRITE
;-- �J
	LD	A,0B6H
	CALL	WRITE
;-- �t
	LD	A,0CCH
	CALL	WRITE
;-- �~
	LD	A,0D0H
	CALL	WRITE
;-- �J�[�\���̔�\��
	LD	A,0CH
	CALL	INSSET
;-- �҂�
	LD	A,19H
SLEEP:	CALL	WAIT
	DEC	A
	JP	NZ,SLEEP
;-- �\�����N���A
	LD	A,01H
	CALL	INSSET
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
;   �\��/�J�[�\��ON
;   �u�����NOFF
;
	LD	A,0EH
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