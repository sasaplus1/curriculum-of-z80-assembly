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
;
PPA0	EQU	30H
PPB0	EQU	31H
PPC0	EQU	32H
PPR0	EQU	33H
;
PPA1	EQU	34H
PPB1	EQU	35H
PPC1	EQU	36H
PPR1	EQU	37H
;----------------------------
; ���ԋL���pRAM�̈�̔Ԓn�萔
;----------------------------
HOR01	EQU	9100H	; �� 1����
HOR10	EQU	9101H	; �� 2����
MIN01	EQU	9102H	; �� 1����
MIN10	EQU	9103H	; �� 2����
SEC01	EQU	9104H	; �b 1����
SEC10	EQU	9105H	; �b 2����
;----------------------------
FLAG1	EQU	9106H	; �}�t���O(��)
FLAG2	EQU	9107H	; �}�t���O(��)
;--------------------------------------
	ORG	8000H
;------------------------------------------------
; ������
;------------------------------------------------
	LD	SP,00H
	DI
	CALL	WDTINI
	CALL	CPUINI
	CALL	PIOINI
	CALL	CTCINI
	CALL	PPIINI
	CALL	IVSET
;----------------------------
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
;----------------------------
	CALL	INSINI
	CALL	CLEAR
	CALL	INSINI
	CALL	R010
;----------------------------
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
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
; ���Ԑݒ�
;----------------------------
	LD	A,00H
;----------------------------
	LD	(HOR01),A
	LD	(HOR10),A
;----------------------------
	LD	(MIN01),A
	LD	(MIN10),A
;----------------------------
	LD	(SEC01),A
	LD	(SEC10),A
;------------------------------------------------
; ���C�����[�`��
;------------------------------------------------
	CALL	CHANEL
;----------------------------
	IN	A,(PPA0)
	LD	B,A
;----------------------------
	CALL	SWCNL2
;----------------------------
	IN	A,(PPA0)
	LD	C,A
;----------------------------
	CALL	SWCNL1
;----------------------------
	CALL	TIME
;----------------------------
	EI
	JR	$
;------------------------------------------------
; ���荞�� / �^�C�}�[
;------------------------------------------------
; FLAG1 : 0000 00xx / ����2�r�b�g : ��,��
;------------------------------------------------
; FLAG2 : 0000 00xx / ����2�r�b�g : ��,��
;------------------------------------------------
INT1:	LD	A,00H
	LD	(FLAG1),A	;�t���O�̏�����
	LD	(FLAG2),A	;�t���O�̏�����
;----------------------------
	CALL	SWCNL1
;----------------------------
	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,CP1
	JP	INT2
;----------------------------
CP1:	CP	B		;�O��̒l�Ɣ�r
	LD	B,A		;LD�Ńt���O�͕ς���̂ł����ŕۑ�
	JP	Z,INT2		;�ω����Ȃ�����
	JP	C,MINS		;����������
	LD	A,02		;�傫������
	LD	(FLAG1),A	;�傫�������t���O
	JP	INT2
MINS:	LD	A,01H		;�����������t���O
	LD	(FLAG1),A
;----------------------------
INT2:	CALL	SWCNL2
;----------------------------
	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,CP2
	JP	INT3
;----------------------------
CP2:	CP	C		;�O��̒l�Ɣ�r
	LD	C,A		;LD�Ńt���O�͕ς���̂ł����ŕۑ�
	JP	Z,INT3		;�ω����Ȃ�����
	JP	C,HORS		;����������
	LD	A,02H		;�傫������
	LD	(FLAG2),A	;�傫�������t���O
	JP	INT3
HORS:	LD	A,01H		;�����������t���O
	LD	(FLAG2),A
;----------------------------
; ���̊m�F/����
;----------------------------
INT3:	LD	A,(FLAG1)
	CP	02H
	JP	Z,MIN01L	;�C���N�������g
	CP	01H
	JP	Z,MIN01S	;�f�N�������g
	JP	INT4		;���̂܂�
;---------------------------
MIN01L:	LD	A,(MIN01)	;;;�ȉ����҂�
	INC	A
	CP	0AH		;1���ڂ�10������
	JP	Z,ML01
	LD	(MIN01),A	;10�ł͂Ȃ�����
	JP	INT4
ML01:	LD	A,(MIN10)	;10�������̂�2���ڂ𒲂ׂ�
	CP	05H		;2���ڂ�5���H
	JP	Z,ML10
	LD	A,00H		;1���ڂ�0����
	LD	(MIN01),A	;
	LD	A,(MIN10)
	INC	A		;5�ł͂Ȃ��̂�+1
	LD	(MIN10),A
	JP	INT4
ML10:	LD	A,00H		;5�Ȃ̂�0����
	LD	(MIN01),A
	LD	(MIN10),A
	JP	INT4
;----------------------------
MIN01S:	LD	A,(MIN01)	;;;�ȉ����҂�
	CP	00H		;1���ڂ�0��������
	JP	Z,MS01		;2���ڂ𒲂ׂ�
	DEC	A		;�f�N�������g
	LD	(MIN01),A	;�߂�
	JP	INT4
MS01:	LD	A,(MIN10)	;2���ڒ���
	CP	00H		;0���H
	JP	Z,MS10
	DEC	A		;0�ł͂Ȃ��̂�-1
	LD	(MIN10),A	;
	LD	A,09H		;1���ڂ�9��
	LD	(MIN01),A	;
	JP	INT4
MS10:	LD	A,05H		;����0�Ȃ̂�59
	LD	(MIN10),A	;
	LD	A,09H		;
	LD	(MIN01),A	;
;----------------------------
; ���̊m�F/����
;----------------------------
INT4:	LD	A,(FLAG2)
	CP	02H
	JP	Z,HOR01L	;�C���N�������g
	CP	01H
	JP	Z,HOR01S	;�f�N�������g
	JP	INT5		;���̂܂�
;----------------------------
HOR01L:	LD	A,(HOR10)	;;;�ȉ����҂�
	CP	02H		;2���ڂ�2��������
	JP	Z,HL02
	LD	A,(HOR01)
	CP	09H		;2���ڂ�2�ł͂Ȃ�1���ڂ�9��������
	JP	Z,HL01
	INC	A		;2���ڂ�2�ł͂Ȃ�1���ڂ�9�ł͂Ȃ�����
	LD	(HOR01),A
	JP	INT5
HL01:	LD	A,00H		;---2���ڂ�2�ł͂Ȃ�1���ڂ�9��������
	LD	(HOR01),A	;1���ڂ�0��
	LD	A,(HOR10)
	INC	A		;2���ڂ�+1
	LD	(HOR10),A
	JP	INT5
HL02:	LD	A,(HOR01)	;---2���ڂ�2��������
	CP	03H		;1���ڂ�3��������
	JP	Z,HL03
	INC	A
	LD	(HOR01),A
	JP	INT5
HL03:	LD	A,00H
	LD	(HOR01),A
	LD	(HOR10),A
	JP	INT5
;----------------------------
HOR01S:	LD	A,(HOR01)	;;;�ȉ����҂�
	CP	00H		;1���ڂ�0��������
	JP	Z,HS01
	DEC	A		;0�ł͂Ȃ�����
	LD	(HOR01),A
	JP	INT5
HS01:	LD	A,(HOR10)	;1���ڂ�0�Ȃ̂�2���ڂ𒲂ׂ�
	CP	00H		;0���H
	JP	Z,HS10
	DEC	A		;0�ł͂Ȃ��̂�-1
	LD	(HOR10),A
	LD	A,09H		;1���ڂ�9��
	LD	(HOR01),A
	JP	INT5
HS10:	LD	A,02H		;����0�Ȃ̂�23
	LD	(HOR10),A
	LD	A,03H
	LD	(HOR01),A
;----------------------------
; ������������
;----------------------------
INT5:	LD	A,(SEC01)	;;;�ȉ����҂�
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
MIN001:	LD	A,(MIN01)	;���̒l���������
	INC	A		;+1
	CP	0AH		;10�ɂȂ������H
	JP	NZ,INT12	;10�ɂȂ��Ă��Ȃ�������l��߂��ď������݂ɍs��
	LD	A,00H		;10�ɂȂ��Ă���̂�0������
	LD	(MIN01),A	;�߂�
	JP	MIN010		;2���ڂ�
INT12:	LD	(MIN01),A
	JP	TIMER
;---------------------------- �� : 2����
MIN010:	LD	A,(MIN10)	;���̒l���������
	INC	A		;+1
	CP	06H		;6�ɂȂ������H
	JP	NZ,INT13	;6�ɂȂ��Ă��Ȃ�������l��߂��ď������݂ɍs��
	LD	A,00H		;6�ɂȂ��Ă���̂�0������
	LD	(MIN10),A	;�߂�
	JP	HOR001		;���Ԃ�1���ڂ�
INT13:	LD	(MIN10),A
	JP	TIMER
;---------------------------- �� : 1����
HOR001:	LD	A,(HOR10)
	CP	02H
	JP	Z,INT15
;----------------------------
	LD	A,(HOR01)
	INC	A
	CP	0AH
	JP	NZ,INT14
	LD	A,00H
	LD	(HOR01),A
	JP	HOR010
INT14:	LD	(HOR01),A
	JP	TIMER
;----------------------------
INT15:	LD	A,(HOR01)
	INC	A
	CP	04H
	JP	Z,INT16
	LD	(HOR01),A
	JP	TIMER
INT16:	LD	A,00H
	LD	(HOR10),A
	LD	(HOR01),A
	JP	TIMER
;---------------------------- �� : 2����
HOR010:	LD	A,(HOR10)
	INC	A
	LD	(HOR10),A
;----------------------------
TIMER:	CALL	TIME
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
; �`�����l��1�ɐ؂�ւ�
;----------------------------
SWCNL1:	PUSH	AF
	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
;----------------------------
	CALL	LWAIT
;----------------------------
	POP	AF
	RET
;----------------------------
; �`�����l��2�ɐ؂�ւ�
;----------------------------
SWCNL2:	PUSH	AF
	LD	A,0F7H
	OUT	(PPB0),A
	LD	A,0FFH
	OUT	(PPB0),A
;----------------------------
	CALL	LWAIT
;----------------------------
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
TIME:	CALL	R000
	LD	A,89H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HOR10)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	LD	A,(HOR01)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	CALL	CORON
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
;----------------------------
; WDT�̐ݒ�
;----------------------------
WDTINI:	LD	A,0DBH
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
	LD	A,8FH
	LD	I,A
	RET
;----------------------------
; CTC�̐ݒ�
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
; PPI�̐ݒ�
;----------------------------
PPIINI:	LD	A,90H
	OUT	(PPR0),A
	LD	A,80H
	OUT	(PPR1),A
	RET
;----------------------------
; IVSET�̐ݒ�
;----------------------------
IVSET:	LD	BC,INT1
	LD	(8F04H),BC
	RET
;----------------------------
; �`�����l���̐ݒ�
;----------------------------
CHANEL:	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
	RET
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