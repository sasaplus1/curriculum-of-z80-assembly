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
; 初期化
;--------------------------------------
	LD	SP,00H
	CALL	WDTINI
	CALL	PPIINI
	CALL	PIOINI
	CALL	CHANEL
;----------------------------
	CALL	WAIT
;----------------------------
	CALL	INSINI	; 初期化
	CALL	CLEAR	; 表示をクリア
	CALL	INSINI	; 再初期化
;----------------------------
	CALL	WAIT
	CALL	WAIT
;------------------------------------------------
; メインルーチン
;------------------------------------------------
	CALL	CLEAR	; 表示をクリア
	CALL	INSINI	; 再設定
	CALL	R010	; おまじない
;----------------------------
	CALL	STR1	; 文字列書き込み
;----------------------------
	LD	A,30H	; 0
	CALL	WRITE	; 文字書き込み
;----------------------------
	CALL	STR2	; 文字列書き込み
;----------------------------
; 2行目へ移動
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	CALL	STR1	; 文字列書き込み
;----------------------------
	LD	A,37H	; 7
	CALL	WRITE	; 文字書き込み
;----------------------------
	CALL	STR2	; 文字列書き込み
;----------------------------
MAIN:	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,SW1
;----------------------------
; チャンネル切り替え
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
; 入力端子1
;----------------------------
SW1:	LD	BC,0004H
	LD	HL,TABLE
;----------------------------
	LD	A,E
	CP	00H
	JP	Z,SW11
SW10:	DEC	A
	ADD	HL,BC
	JP	NZ,SW10
;----------------------------
; 場所へ移動
;----------------------------
SW11:	CALL	R000
	LD	A,8EH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
	INC	HL
	LD	A,(HL)
	CALL	WRITE
	INC	HL
	LD	A,(HL)
	CALL	WRITE
	INC	HL
	LD	A,(HL)
	CALL	WRITE
;----------------------------
	JP	LOOP
;----------------------------
; 入力端子2
;----------------------------
SW2:	LD	BC,0004H
	LD	HL,TABLE
;----------------------------
	LD	A,E
	CP	00H
	JP	Z,SW21
SW20:	DEC	A
	ADD	HL,BC
	JP	NZ,SW20
;----------------------------
; 場所へ移動
;----------------------------
SW21:	CALL	R000
	LD	A,0CEH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
	INC	HL
	LD	A,(HL)
	CALL	WRITE
	INC	HL
	LD	A,(HL)
	CALL	WRITE
	INC	HL
	LD	A,(HL)
	CALL	WRITE
;----------------------------
; チャンネル切り替え
;----------------------------
	CALL	SWCNL1
;----------------------------
	JP	MAIN
;--------------------------------------
; テーブル
;--------------------------------------
TABLE:	DB	30H,2EH,30H,30H	; 0.00
	DB	30H,2EH,30H,32H	; 0.02
	DB	30H,2EH,30H,34H	; 0.04
	DB	30H,2EH,30H,36H	; 0.06
	DB	30H,2EH,30H,38H	; 0.08
	DB	30H,2EH,31H,30H	; 0.10
	DB	30H,2EH,31H,32H	; 0.12
	DB	30H,2EH,31H,34H	; 0.14
	DB	30H,2EH,31H,36H	; 0.16
	DB	30H,2EH,31H,38H	; 0.18
	DB	30H,2EH,32H,30H	; 0.20
	DB	30H,2EH,32H,32H	; 0.22
	DB	30H,2EH,32H,34H	; 0.24
	DB	30H,2EH,32H,36H	; 0.26
	DB	30H,2EH,32H,38H	; 0.28
	DB	30H,2EH,33H,30H	; 0.30
	DB	30H,2EH,33H,32H	; 0.32
	DB	30H,2EH,33H,34H	; 0.34
	DB	30H,2EH,33H,36H	; 0.36
	DB	30H,2EH,33H,38H	; 0.38
	DB	30H,2EH,34H,30H	; 0.40
	DB	30H,2EH,34H,32H	; 0.42
	DB	30H,2EH,34H,34H	; 0.44
	DB	30H,2EH,34H,36H	; 0.46
	DB	30H,2EH,34H,38H	; 0.48
	DB	30H,2EH,35H,30H	; 0.50
	DB	30H,2EH,35H,32H	; 0.52
	DB	30H,2EH,35H,34H	; 0.54
	DB	30H,2EH,35H,36H	; 0.56
	DB	30H,2EH,35H,38H	; 0.58
	DB	30H,2EH,36H,30H	; 0.60
	DB	30H,2EH,36H,32H	; 0.62
	DB	30H,2EH,36H,34H	; 0.64
	DB	30H,2EH,36H,36H	; 0.66
	DB	30H,2EH,36H,38H	; 0.68
	DB	30H,2EH,37H,30H	; 0.70
	DB	30H,2EH,37H,32H	; 0.72
	DB	30H,2EH,37H,34H	; 0.74
	DB	30H,2EH,37H,36H	; 0.76
	DB	30H,2EH,37H,38H	; 0.78
	DB	30H,2EH,38H,30H	; 0.80
	DB	30H,2EH,38H,32H	; 0.82
	DB	30H,2EH,38H,34H	; 0.84
	DB	30H,2EH,38H,36H	; 0.86
	DB	30H,2EH,38H,38H	; 0.88
	DB	30H,2EH,39H,30H	; 0.90
	DB	30H,2EH,39H,32H	; 0.92
	DB	30H,2EH,39H,34H	; 0.94
	DB	30H,2EH,39H,36H	; 0.96
	DB	30H,2EH,39H,38H	; 0.98
	DB	31H,2EH,30H,30H	; 1.00
	DB	31H,2EH,30H,32H	; 1.02
	DB	31H,2EH,30H,34H	; 1.04
	DB	31H,2EH,30H,36H	; 1.06
	DB	31H,2EH,30H,38H	; 1.08
	DB	31H,2EH,31H,30H	; 1.10
	DB	31H,2EH,31H,32H	; 1.12
	DB	31H,2EH,31H,34H	; 1.14
	DB	31H,2EH,31H,36H	; 1.16
	DB	31H,2EH,31H,38H	; 1.18
	DB	31H,2EH,32H,30H	; 1.20
	DB	31H,2EH,32H,32H	; 1.22
	DB	31H,2EH,32H,34H	; 1.24
	DB	31H,2EH,32H,36H	; 1.26
	DB	31H,2EH,32H,38H	; 1.28
	DB	31H,2EH,33H,30H	; 1.30
	DB	31H,2EH,33H,32H	; 1.32
	DB	31H,2EH,33H,34H	; 1.34
	DB	31H,2EH,33H,36H	; 1.36
	DB	31H,2EH,33H,38H	; 1.38
	DB	31H,2EH,34H,30H	; 1.40
	DB	31H,2EH,34H,32H	; 1.42
	DB	31H,2EH,34H,34H	; 1.44
	DB	31H,2EH,34H,36H	; 1.46
	DB	31H,2EH,34H,38H	; 1.48
	DB	31H,2EH,35H,30H	; 1.50
	DB	31H,2EH,35H,32H	; 1.52
	DB	31H,2EH,35H,34H	; 1.54
	DB	31H,2EH,35H,36H	; 1.56
	DB	31H,2EH,35H,38H	; 1.58
	DB	31H,2EH,36H,30H	; 1.60
	DB	31H,2EH,36H,32H	; 1.62
	DB	31H,2EH,36H,34H	; 1.64
	DB	31H,2EH,36H,36H	; 1.66
	DB	31H,2EH,36H,38H	; 1.68
	DB	31H,2EH,37H,30H	; 1.70
	DB	31H,2EH,37H,32H	; 1.72
	DB	31H,2EH,37H,34H	; 1.74
	DB	31H,2EH,37H,36H	; 1.76
	DB	31H,2EH,37H,38H	; 1.78
	DB	31H,2EH,38H,30H	; 1.80
	DB	31H,2EH,38H,32H	; 1.82
	DB	31H,2EH,38H,34H	; 1.84
	DB	31H,2EH,38H,36H	; 1.86
	DB	31H,2EH,38H,38H	; 1.88
	DB	31H,2EH,39H,30H	; 1.90
	DB	31H,2EH,39H,32H	; 1.92
	DB	31H,2EH,39H,34H	; 1.94
	DB	31H,2EH,39H,36H	; 1.96
	DB	31H,2EH,39H,38H	; 1.98
	DB	32H,2EH,30H,30H	; 2.00
	DB	32H,2EH,30H,32H	; 2.02
	DB	32H,2EH,30H,34H	; 2.04
	DB	32H,2EH,30H,36H	; 2.06
	DB	32H,2EH,30H,38H	; 2.08
	DB	32H,2EH,31H,30H	; 2.10
	DB	32H,2EH,31H,32H	; 2.12
	DB	32H,2EH,31H,34H	; 2.14
	DB	32H,2EH,31H,36H	; 2.16
	DB	32H,2EH,31H,38H	; 2.18
	DB	32H,2EH,32H,30H	; 2.20
	DB	32H,2EH,32H,32H	; 2.22
	DB	32H,2EH,32H,34H	; 2.24
	DB	32H,2EH,32H,36H	; 2.26
	DB	32H,2EH,32H,38H	; 2.28
	DB	32H,2EH,33H,30H	; 2.30
	DB	32H,2EH,33H,32H	; 2.32
	DB	32H,2EH,33H,34H	; 2.34
	DB	32H,2EH,33H,36H	; 2.36
	DB	32H,2EH,33H,38H	; 2.38
	DB	32H,2EH,34H,30H	; 2.40
	DB	32H,2EH,34H,32H	; 2.42
	DB	32H,2EH,34H,34H	; 2.44
	DB	32H,2EH,34H,36H	; 2.46
	DB	32H,2EH,34H,38H	; 2.48
	DB	32H,2EH,35H,30H	; 2.50
	DB	32H,2EH,35H,32H	; 2.52
	DB	32H,2EH,35H,34H	; 2.54
	DB	32H,2EH,35H,36H	; 2.56
	DB	32H,2EH,35H,38H	; 2.58
	DB	32H,2EH,36H,30H	; 2.60
	DB	32H,2EH,36H,32H	; 2.62
	DB	32H,2EH,36H,34H	; 2.64
	DB	32H,2EH,36H,36H	; 2.66
	DB	32H,2EH,36H,38H	; 2.68
	DB	32H,2EH,37H,30H	; 2.70
	DB	32H,2EH,37H,32H	; 2.72
	DB	32H,2EH,37H,34H	; 2.74
	DB	32H,2EH,37H,36H	; 2.76
	DB	32H,2EH,37H,38H	; 2.78
	DB	32H,2EH,38H,30H	; 2.80
	DB	32H,2EH,38H,32H	; 2.82
	DB	32H,2EH,38H,34H	; 2.84
	DB	32H,2EH,38H,36H	; 2.86
	DB	32H,2EH,38H,38H	; 2.88
	DB	32H,2EH,39H,30H	; 2.90
	DB	32H,2EH,39H,32H	; 2.92
	DB	32H,2EH,39H,34H	; 2.94
	DB	32H,2EH,39H,36H	; 2.96
	DB	32H,2EH,39H,38H	; 2.98
	DB	33H,2EH,30H,30H	; 3.00
	DB	33H,2EH,30H,32H	; 3.02
	DB	33H,2EH,30H,34H	; 3.04
	DB	33H,2EH,30H,36H	; 3.06
	DB	33H,2EH,30H,38H	; 3.08
	DB	33H,2EH,31H,30H	; 3.10
	DB	33H,2EH,31H,32H	; 3.12
	DB	33H,2EH,31H,34H	; 3.14
	DB	33H,2EH,31H,36H	; 3.16
	DB	33H,2EH,31H,38H	; 3.18
	DB	33H,2EH,32H,30H	; 3.20
	DB	33H,2EH,32H,32H	; 3.22
	DB	33H,2EH,32H,34H	; 3.24
	DB	33H,2EH,32H,36H	; 3.26
	DB	33H,2EH,32H,38H	; 3.28
	DB	33H,2EH,33H,30H	; 3.30
	DB	33H,2EH,33H,32H	; 3.32
	DB	33H,2EH,33H,34H	; 3.34
	DB	33H,2EH,33H,36H	; 3.36
	DB	33H,2EH,33H,38H	; 3.38
	DB	33H,2EH,34H,30H	; 3.40
	DB	33H,2EH,34H,32H	; 3.42
	DB	33H,2EH,34H,34H	; 3.44
	DB	33H,2EH,34H,36H	; 3.46
	DB	33H,2EH,34H,38H	; 3.48
	DB	33H,2EH,35H,30H	; 3.50
	DB	33H,2EH,35H,32H	; 3.52
	DB	33H,2EH,35H,34H	; 3.54
	DB	33H,2EH,35H,36H	; 3.56
	DB	33H,2EH,35H,38H	; 3.58
	DB	33H,2EH,36H,30H	; 3.60
	DB	33H,2EH,36H,32H	; 3.62
	DB	33H,2EH,36H,34H	; 3.64
	DB	33H,2EH,36H,36H	; 3.66
	DB	33H,2EH,36H,38H	; 3.68
	DB	33H,2EH,37H,30H	; 3.70
	DB	33H,2EH,37H,32H	; 3.72
	DB	33H,2EH,37H,34H	; 3.74
	DB	33H,2EH,37H,36H	; 3.76
	DB	33H,2EH,37H,38H	; 3.78
	DB	33H,2EH,38H,30H	; 3.80
	DB	33H,2EH,38H,32H	; 3.82
	DB	33H,2EH,38H,34H	; 3.84
	DB	33H,2EH,38H,36H	; 3.86
	DB	33H,2EH,38H,38H	; 3.88
	DB	33H,2EH,39H,30H	; 3.90
	DB	33H,2EH,39H,32H	; 3.92
	DB	33H,2EH,39H,34H	; 3.94
	DB	33H,2EH,39H,36H	; 3.96
	DB	33H,2EH,39H,38H	; 3.98
	DB	34H,2EH,30H,30H	; 4.00
	DB	34H,2EH,30H,32H	; 4.02
	DB	34H,2EH,30H,34H	; 4.04
	DB	34H,2EH,30H,36H	; 4.06
	DB	34H,2EH,30H,38H	; 4.08
	DB	34H,2EH,31H,30H	; 4.10
	DB	34H,2EH,31H,32H	; 4.12
	DB	34H,2EH,31H,34H	; 4.14
	DB	34H,2EH,31H,36H	; 4.16
	DB	34H,2EH,31H,38H	; 4.18
	DB	34H,2EH,32H,30H	; 4.20
	DB	34H,2EH,32H,32H	; 4.22
	DB	34H,2EH,32H,34H	; 4.24
	DB	34H,2EH,32H,36H	; 4.26
	DB	34H,2EH,32H,38H	; 4.28
	DB	34H,2EH,33H,30H	; 4.30
	DB	34H,2EH,33H,32H	; 4.32
	DB	34H,2EH,33H,34H	; 4.34
	DB	34H,2EH,33H,36H	; 4.36
	DB	34H,2EH,33H,38H	; 4.38
	DB	34H,2EH,34H,30H	; 4.40
	DB	34H,2EH,34H,32H	; 4.42
	DB	34H,2EH,34H,34H	; 4.44
	DB	34H,2EH,34H,36H	; 4.46
	DB	34H,2EH,34H,38H	; 4.48
	DB	34H,2EH,35H,30H	; 4.50
	DB	34H,2EH,35H,32H	; 4.52
	DB	34H,2EH,35H,34H	; 4.54
	DB	34H,2EH,35H,36H	; 4.56
	DB	34H,2EH,35H,38H	; 4.58
	DB	34H,2EH,36H,30H	; 4.60
	DB	34H,2EH,36H,32H	; 4.62
	DB	34H,2EH,36H,34H	; 4.64
	DB	34H,2EH,36H,36H	; 4.66
	DB	34H,2EH,36H,38H	; 4.68
	DB	34H,2EH,37H,30H	; 4.70
	DB	34H,2EH,37H,32H	; 4.72
	DB	34H,2EH,37H,34H	; 4.74
	DB	34H,2EH,37H,36H	; 4.76
	DB	34H,2EH,37H,38H	; 4.78
	DB	34H,2EH,38H,30H	; 4.80
	DB	34H,2EH,38H,32H	; 4.82
	DB	34H,2EH,38H,34H	; 4.84
	DB	34H,2EH,38H,36H	; 4.86
	DB	34H,2EH,38H,38H	; 4.88
	DB	34H,2EH,39H,30H	; 4.90
	DB	34H,2EH,39H,32H	; 4.92
	DB	34H,2EH,39H,34H	; 4.94
	DB	34H,2EH,39H,36H	; 4.96
	DB	34H,2EH,39H,38H	; 4.98
	DB	35H,2EH,30H,30H	; 5.00
	DB	35H,2EH,30H,30H	; 5.00
	DB	35H,2EH,30H,30H	; 5.00
	DB	35H,2EH,30H,30H	; 5.00
	DB	35H,2EH,30H,30H	; 5.00
	DB	35H,2EH,30H,30H	; 5.00
;------------------------------------------------
; サブルーチン
;------------------------------------------------
;
;--------------------------------------
; 文字列の書き込み
;--------------------------------------
STR1:	PUSH	AF
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0B1H	; ア
	CALL	WRITE
	LD	A,0C5H	; ナ
	CALL	WRITE
	LD	A,0DBH	; ロ
	CALL	WRITE
	LD	A,0B8H	; ク
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0C6H	; ニ
	CALL	WRITE
	LD	A,0ADH	; ュ
	CALL	WRITE
	LD	A,0B3H	; ウ
	CALL	WRITE
	LD	A,0D8H	; リ
	CALL	WRITE
	LD	A,0AEH	; ョ
	CALL	WRITE
	LD	A,0B8H	; ク
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
STR2:	PUSH	AF
	LD	A,3DH	; =
	CALL	WRITE
	LD	A,0A0H	; (スペース) x 4
	CALL	WRITE
	CALL	WRITE
	CALL	WRITE
	CALL	WRITE
	LD	A,56H	; V
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
; 入出力のチャンネルを切り替え
;--------------------------------------
SWCNL1:	PUSH	AF
	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
	CALL	WAIT
	POP	AF
	RET
;--------------------------------------
; 入出力のチャンネルを切り替え
;--------------------------------------
SWCNL2:	PUSH	AF
	LD	A,0F7H
	OUT	(PPB0),A
	LD	A,0FFH
	OUT	(PPB0),A
	CALL	WAIT
	POP	AF
	RET
;------------------------------------------------
; サブルーチン : Z80
;------------------------------------------------
;
;--------------------------------------
; 犬の設定
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
; PIOの設定
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
; PPIの設定
;--------------------------------------
PPIINI:	LD	A,90H
	OUT	(PPR0),A
	LD	A,80H
	OUT	(PPR1),A
	RET
;--------------------------------------
; チャンネルの設定
;--------------------------------------
CHANEL:	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
	RET
;--------------------------------------
; 時間待ち
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
; サブルーチン : LCDモジュール
;------------------------------------------------
;
;----------------------------
; インストラクションの設定
;----------------------------
INSINI:	CALL	R000
	CALL	WAIT
;
; ファンクションセット：
;   インターフェイスデータ長8bit
;   デューティ16分の1
;   5x7ドットマトリクス
;
	LD	A,38H
	CALL	INSSET
;
; 表示オンオフ：
;   表示ON
;   カーソル/ブリンクOFF
;
	LD	A,0CH
	CALL	INSSET
;
; エントリーモード
;   カーソルはインクリメント
;   表示はシフトしない
;
	LD	A,06H
	CALL	INSSET
;
	RET
;----------------------------
; インストラクション設定の際
;----------------------------
INSSET:	CALL	R001
	OUT	(PAD),A
	CALL	WAIT
	CALL	R000
	RET
;----------------------------
; CGRAM/DDRAMに書き込み
;----------------------------
WRITE:	CALL	R011
	OUT	(PAD),A
	CALL	WAIT
	CALL	R010
	RET
;----------------------------
; 表示をクリア
;----------------------------
CLEAR:	PUSH	AF
	LD	A,01H
	CALL	INSSET
	POP	AF
	RET
;--------------------------------------
; イントラクションの設定[開始/終了]
;--------------------------------------
R000:	PUSH	AF
	LD	A,00H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
; イントラクションの設定中
;--------------------------------------
R001:	PUSH	AF
	LD	A,04H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
; 文字データ書き込み[開始/終了]
;--------------------------------------
R010:	PUSH	AF
	LD	A,01H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
; 文字データ書き込み中
;--------------------------------------
R011:	PUSH	AF
	LD	A,05H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
	END
;[EOF]