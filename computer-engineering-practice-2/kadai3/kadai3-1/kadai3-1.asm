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
; 初期化
;--------------------------------------
	LD	SP,0
	CALL	WDTINI
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	IVSET
;--------------------------------------
; レジスタの初期化
;--------------------------------------
	LD	D,0
	LD	E,0
	EI
;--------------------------------------
; Aポート時計回り
;--------------------------------------
PACW:	LD	A,00H
	OUT	(PBD),A
	LD	A,01H
PLP1:	OUT	(PAD),A
	CALL	WAIT
	RLCA
	JP	NC,PLP1
	LD	A,D
	CP	0
	JP	NZ,NBCW
	LD	A,E
	CP	0
	JP	NZ,PACCW
	JP	PBCW
;--------------------------------------
; Bポート時計回り
;--------------------------------------
PBCW:	LD	A,00H
	OUT	(PAD),A
	LD	A,01H
PLP2:	OUT	(PBD),A
	CALL	WAIT
	RLCA
	JP	NC,PLP2
	LD	A,D
	CP	0
	JP	NZ,NACW
	LD	A,E
	CP	0
	JP	NZ,PBCCW
	JP	PACW
;--------------------------------------
; Aポート反時計回り
;--------------------------------------
PACCW:	LD	A,00H
	OUT	(PBD),A
	LD	A,80H
PLP3:	OUT	(PAD),A
	CALL	WAIT
	RRCA
	JP	NC,PLP3
	LD	A,D
	CP	0
	JP	NZ,NBCCW
	LD	A,E
	CP	0FFH
	JP	NZ,PACW
	JP	PBCCW
;--------------------------------------
; Bポート反時計回り
;--------------------------------------
PBCCW:	LD	A,00H
	OUT	(PAD),A
	LD	A,80H
PLP4:	OUT	(PBD),A
	CALL	WAIT
	RRCA
	JP	NC,PLP4
	LD	A,D
	CP	0
	JP	NZ,NACCW
	LD	A,E
	CP	0FFH
	JP	NZ,PBCW
	JP	PACCW
;--------------------------------------
; Aポートビット反転時計回り
;--------------------------------------
NACW:	LD	A,0FFH
	OUT	(PBD),A
	LD	A,0FEH
NLP1:	OUT	(PAD),A
	CALL	WAIT
	RLCA
	JP	C,NLP1
	LD	A,D
	CP	0FFH
	JP	NZ,PBCW
	LD	A,E
	CP	0
	JP	NZ,NACCW
	JP	NBCW
;--------------------------------------
; Bポートビット反転時計回り
;--------------------------------------
NBCW:	LD	A,0FFH
	OUT	(PAD),A
	LD	A,0FEH
NLP2:	OUT	(PBD),A
	CALL	WAIT
	RLCA
	JP	C,NLP2
	LD	A,D
	CP	0FFH
	JP	NZ,PACW
	LD	A,E
	CP	0
	JP	NZ,NBCCW
	JP	NACW
;--------------------------------------
; Aポートビット反転反時計回り
;--------------------------------------
NACCW:	LD	A,0FFH
	OUT	(PBD),A
	LD	A,7FH
NLP3:	OUT	(PAD),A
	CALL	WAIT
	RRCA
	JP	C,NLP3
	LD	A,D
	CP	0FFH
	JP	NZ,PBCCW
	LD	A,E
	CP	0FFH
	JP	NZ,NACW
	JP	NBCCW
;--------------------------------------
; Aポートビット反転反時計回り
;--------------------------------------
NBCCW:	LD	A,0FFH
	OUT	(PAD),A
	LD	A,7FH
NLP4:	OUT	(PBD),A
	CALL	WAIT
	RRCA
	JP	C,NLP4
	LD	A,D
	CP	0FFH
	JP	NZ,PACCW
	LD	A,E
	CP	0FFH
	JP	NZ,NBCW
	JP	NACCW
;--------------------------------------
; SW0 割り込み : 回転を数秒間停止
;--------------------------------------
INT0:	PUSH	AF
	LD	A,30
INT01:	CALL	WAIT
	DEC	A
	JP	NZ,INT01
	POP	AF
	EI
	RETI
;--------------------------------------
; SW1 割り込み : 回転停止 + 5回点滅
;--------------------------------------
INT1:	PUSH	AF
	LD	B,10
	LD	A,0
INT11:	OUT	(PAD),A
	OUT	(PBD),A
	CALL	WAIT
	CPL
	DJNZ	INT11
	LD	A,0
	OUT	(PBD),A
	POP	AF
	EI
	RETI
;--------------------------------------
; SW2 割り込み : 逆回転
;--------------------------------------
INT2:	PUSH	AF
	LD	A,E
	CPL
	LD	E,A
	POP	AF
	EI
	RETI
;--------------------------------------
; SW3 割り込み : 点灯・消灯の入れ替え
;--------------------------------------
INT3:	PUSH	AF
	LD	A,D
	CPL
	LD	D,A
	POP	AF
	EI
	RETI
;--------------------------------------
; サブルーチン
;--------------------------------------
;
;----------------------------
; 犬の設定
;----------------------------
WDTINI:	DI
	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	RET
;----------------------------
; CPUの設定
;----------------------------
CPUINI:	IM	2
	LD	A,90H
	LD	I,A
	RET
;----------------------------
; CTCの設定
;----------------------------
CTCINI:	LD	A,0
	OUT	(CTC),A
	LD	BC,410H
	LD	DE,0D501H
CI1:	OUT	(C),D
	OUT	(C),E
	INC	C
	DJNZ	CI1
	RET
;----------------------------
; PIOの設定
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
; 割り込みの設定
;----------------------------
IVSET:	LD	BC,INT0
	LD	(9000H),BC
	LD	BC,INT1
	LD	(9002H),BC
	LD	BC,INT2
	LD	(9004H),BC
	LD	BC,INT3
	LD	(9006H),BC
	RET
;----------------------------
; 時間待ち
;----------------------------
WAIT:	PUSH	BC
	LD	B,0
WA2:	LD	C,0
WA1:	DEC	C
	JP	NZ,WA1
	DEC	B
	JP	NZ,WA2
	POP	BC
	RET
;----------------------------
	END
;[EOF]