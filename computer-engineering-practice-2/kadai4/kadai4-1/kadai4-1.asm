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
	JP	Z,L1
;----------------------------
; チャンネル切り替え
;----------------------------
LOOP:	CALL	SWCNL2
;----------------------------
	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,L2
;----------------------------
	JP	MAIN
;----------------------------
; 入力端子1
;----------------------------
L1:	LD	HL,TABLE
	LD	A,E
	RRA
	RRA
	RRA
	RRA
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 1桁目の場所へ移動
;----------------------------
	CALL	R000
	LD	A,8EH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
;----------------------------
R1:	LD	HL,TABLE
	LD	A,E
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 2桁目の場所へ移動
;----------------------------
	CALL	R000
	LD	A,8FH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
;----------------------------
	JP	LOOP
;----------------------------
; 入力端子2
;----------------------------
L2:	LD	HL,TABLE
	LD	A,E
	RRA
	RRA
	RRA
	RRA
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 1桁目の場所へ移動
;----------------------------
	CALL	R000
	LD	A,0CEH
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HL)
	CALL	WRITE
;----------------------------
R2:	LD	HL,TABLE
	LD	A,E
	AND	0FH
	LD	B,00H
	LD	C,A
	ADD	HL,BC
;----------------------------
; 2桁目の場所へ移動
;----------------------------
	CALL	R000
	LD	A,0CFH
	CALL	INSSET
	CALL	R010
;----------------------------
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
TABLE:	DB	30H,31H,32H,33H	; 0,1,2,3
	DB	34H,35H,36H,37H	; 4,5,6,7
	DB	38H,39H,41H,42H	; 8,9,A,B
	DB	43H,44H,45H,46H	; C,D,E,F
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
	LD	A,0A0H	; (スペース) x 2
	CALL	WRITE
	CALL	WRITE
	LD	A,48H	; H
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
;----------------------------
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
;----------------------------
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
;----------------------------
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
;----------------------------
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