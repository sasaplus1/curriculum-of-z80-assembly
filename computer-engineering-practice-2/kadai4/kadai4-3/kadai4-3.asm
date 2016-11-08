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
	LD	C,00H
	LD	D,00H
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
SW1:	LD	HL,TABLE
;----------------------------
	LD	B,00H
	CP	B
	JP	Z,SW11
;----------------------------
	LD	B,A
SW10:	INC	HL
	DJNZ	SW10
;----------------------------
	LD	A,(HL)
	CP	C
	JP	Z,SW11
	CALL	CLRLN1
;----------------------------
SW11:	CALL	R000
	LD	A,(HL)
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	C,(HL)
;----------------------------
	LD	A,2AH
	CALL	WRITE
;----------------------------
	JP	LOOP
;----------------------------
; 入力端子2
;----------------------------
SW2:	PUSH	BC
	LD	BC,0100H
	LD	HL,TABLE
	ADD	HL,BC
	POP	BC
;----------------------------
	LD	B,00H
	CP	B
	JP	Z,SW21
;----------------------------
	LD	B,A
SW20:	INC	HL
	DJNZ	SW20
;----------------------------
	LD	A,(HL)
	CP	D
	JP	Z,SW21
	CALL	CLRLN2
;----------------------------
SW21:	CALL	R000
	LD	A,(HL)
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	D,(HL)
;----------------------------
	LD	A,2AH
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
TABLE:	DB	80H,80H,80H,80H,80H,80H,80H,80H,80H,80H,80H,80H,80H
	DB	81H,81H,81H,81H,81H,81H,81H,81H,81H,81H,81H,81H,81H
	DB	82H,82H,82H,82H,82H,82H,82H,82H,82H,82H,82H,82H,82H
	DB	83H,83H,83H,83H,83H,83H,83H,83H,83H,83H,83H,83H,83H
	DB	84H,84H,84H,84H,84H,84H,84H,84H,84H,84H,84H,84H
	DB	85H,85H,85H,85H,85H,85H,85H,85H,85H,85H,85H,85H,85H
	DB	86H,86H,86H,86H,86H,86H,86H,86H,86H,86H,86H,86H,86H
	DB	87H,87H,87H,87H,87H,87H,87H,87H,87H,87H,87H,87H,87H
	DB	88H,88H,88H,88H,88H,88H,88H,88H,88H,88H,88H,88H,88H
	DB	89H,89H,89H,89H,89H,89H,89H,89H,89H,89H,89H,89H
	DB	8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH,8AH
	DB	8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH,8BH
	DB	8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH,8CH
	DB	8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH,8DH
	DB	8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH,8EH
	DB	8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH,8FH
	DB	90H,90H,90H,90H,90H,90H,90H,90H,90H,90H,90H,90H,90H
	DB	91H,91H,91H,91H,91H,91H,91H,91H,91H,91H,91H,91H,91H
	DB	92H,92H,92H,92H,92H,92H,92H,92H,92H,92H,92H,92H,82H
	DB	93H,93H,93H,93H,93H,93H,93H,93H,93H,93H,93H,93H
;------------------------------------------------
	DB	0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H,0C0H
	DB	0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H,0C1H
	DB	0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H,0C2H
	DB	0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H,0C3H
	DB	0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H
	DB	0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H,0C5H
	DB	0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H,0C6H
	DB	0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H,0C7H
	DB	0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H,0C8H
	DB	0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H,0C9H
	DB	0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH,0CAH
	DB	0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH,0CBH
	DB	0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,0CCH
	DB	0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB	0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH,0CEH
	DB	0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH,0CFH
	DB	0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H,0D0H
	DB	0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H,0D1H
	DB	0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H,0D2H
	DB	0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H,0D3H
;------------------------------------------------
; サブルーチン
;------------------------------------------------
;
;--------------------------------------
; 1行目を消去
;--------------------------------------
CLRLN1:	PUSH	AF
	PUSH	BC
;----------------------------
	CALL	R000
	LD	A,80H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0A0H
	LD	B,14H
CLR01:	CALL	WRITE
	DJNZ	CLR01
;----------------------------
	POP	BC
	POP	AF
	RET
;--------------------------------------
; 2行目を消去
;--------------------------------------
CLRLN2:	PUSH	AF
	PUSH	BC
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0A0H
	LD	B,14H
CLR02:	CALL	WRITE
	DJNZ	CLR02
;----------------------------
	POP	BC
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