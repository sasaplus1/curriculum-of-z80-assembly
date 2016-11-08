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
;
;--------------------------------------
; 初期化
;--------------------------------------
	LD	SP,00H
	CALL	WDTINI
	CALL	PPIINI
	CALL	PIOINI
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
	LD	HL,3F00H
;----------------------------
	LD	(DATA),HL
MUSIC:	LD	HL,MDATA
	LD	E,00H
	CALL	TITLE
MUS:	LD	A,(HL)
	AND	A
	JP	Z,MUSIC
;----------------------------
	LD	A,(HL)
	CP	0FEH
	JP	NZ,MUC
	CALL	MSG
	INC	E
	INC	HL
	LD	A,(HL)
;----------------------------
MUC:	INC	HL
	LD	C,(HL)
	LD	B,A
	INC	A
	JP	Z,MUS2
	PUSH	HL
	CALL	MSUB1
	POP	HL
;
MMM:	INC	HL
	JP	MUS
;--------------------------------------
; 音符
;--------------------------------------
MSUB1:	LD	HL,(DATA)
J2:	LD	D,B
	LD	A,80H
	OUT	(PPC1),A
J3:	DEC	HL
	LD	A,H
	AND	A
	JP	NZ,J4
	LD	HL,(DATA)
	DEC	C
	RET	Z
J4:	DEC	D
	JP	NZ,J3
	LD	D,B
	LD	A,00H
	OUT	(PPC1),A
J5:	DEC	HL
	LD	A,H
	AND	A
	JP	NZ,J6
	LD	HL,(DATA)
	DEC	C
	RET	Z
J6:	DEC	D
	JP	NZ,J5
	JP	J2
;--------------------------------------
; 休符
;--------------------------------------
MUS2:	PUSH	HL
	LD	HL,(DATA)
J11:	LD	D,B
	NOP
	NOP
J12:	DEC	HL
	LD	A,H
	AND	A
	JP	NZ,J13
	LD	HL,(DATA)
	DEC	C
	JP	Z,J14
J13:	DEC	D
	JP	NZ,J12
	JP	J11
J14:	POP	HL
	JP	MMM
;--------------------------------------
; テーブル
;--------------------------------------
DATA:	DB	00H,00H
;--------------------------------------
MDATA:	DB	0FEH
;----------------------------
	DB	44H,08H	; ソ
	DB	66H,08H	; ド
	DB	66H,08H	; ド
	DB	5DH,08H	; レ
	DB	53H,08H	; ミ
	DB	44H,08H	; ソ
	DB	44H,11H	; ソ
;----------------------------
	DB	0FEH
;----------------------------
	DB	3CH,08H	; ラ
	DB	4DH,08H	; ファ
	DB	33H,08H	; ド
	DB	3CH,08H	; ラ
	DB	44H,08H	; ソ
	DB	3CH,08H	; ラ
	DB	44H,11H	; ソ
;----------------------------
	DB	0FEH
;----------------------------
	DB	53H,08H	; ミ
	DB	53H,08H	; ミ
	DB	5DH,08H	; レ
	DB	66H,08H	; ド
	DB	5DH,08H	; レ
	DB	44H,08H	; ソ
	DB	44H,11H	; ソ
;----------------------------
	DB	0FEH
;----------------------------
	DB	3CH,08H	; ラ
	DB	3CH,08H	; ラ
	DB	44H,08H	; ソ
	DB	66H,08H	; ド
	DB	53H,08H	; ミ
	DB	5DH,08H	; レ
	DB	66H,11H	; ド
;----------------------------
	DB	0FEH
;----------------------------
	DB	33H,08H	; ド
	DB	33H,08H	; ド
	DB	33H,08H	; ド
	DB	33H,08H	; ド
	DB	33H,08H	; ド
	DB	3CH,08H	; ラ
	DB	44H,11H	; ソ
;----------------------------
	DB	0FEH
;----------------------------
	DB	66H,08H	; ド
	DB	66H,08H	; ド
	DB	5DH,08H	; レ
	DB	53H,08H	; ミ
	DB	44H,08H	; ソ
	DB	53H,08H	; ミ
	DB	5DH,08H	; レ
	DB	66H,11H	; ド
;----------------------------
	DB	00H
;------------------------------------------------
; サブルーチン
;------------------------------------------------
;
;--------------------------------------
; タイトルの表示 + 時間待ち
;--------------------------------------
TITLE:	PUSH	AF
	PUSH	BC
;----------------------------
	CALL	CLEAR
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0ACH	; ャ
	CALL	WRITE
	LD	A,0CEH	; ホ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
;----------------------------
	LD	A,05H
	LD	B,0FFH
SLEEP:	CALL	WAIT
	DJNZ	SLEEP
	DEC	A
	LD	B,0FFH
	JP	NZ,SLEEP
	POP	BC
	POP	AF
	RET
;--------------------------------------
; 歌詞の表示
;--------------------------------------
MSG:	PUSH	AF
	LD	A,E
	CP	00H
	JP	NZ,MSG1
	CALL	MES0
	JP	ENDMSG
MSG1:	CP	01H
	JP	NZ,MSG2
	CALL	MES1
	JP	ENDMSG
MSG2:	CP	02H
	JP	NZ,MSG3
	CALL	MES2
	JP	ENDMSG
MSG3:	CP	03H
	JP	NZ,MSG4
	CALL	MES3
	JP	ENDMSG
MSG4:	CP	04H
	JP	NZ,MSG5
	CALL	MES4
	JP	ENDMSG
MSG5:	CP	05H
	JP	NZ,ENDMSG
	CALL	MES5
ENDMSG:	POP	AF
	RET
;--------------------------------------
MES0:	PUSH	AF
	CALL	CLEAR
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0ACH	; ャ
	CALL	WRITE
	LD	A,0CEH	; ホ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES1:	PUSH	AF
	CALL	CLEAR
	LD	A,0D4H	; ヤ
	CALL	WRITE
	LD	A,0C8H	; ネ
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0C3H	; テ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES2:	PUSH	AF
	CALL	CLEAR
	LD	A,0D4H	; ヤ
	CALL	WRITE
	LD	A,0C8H	; ネ
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0C3H	; テ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C3H	; テ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES3:	PUSH	AF
	CALL	CLEAR
	LD	A,0BAH	; コ
	CALL	WRITE
	LD	A,0DCH	; ワ
	CALL	WRITE
	LD	A,0DAH	; レ
	CALL	WRITE
	LD	A,0C3H	; テ
	CALL	WRITE
	LD	A,0B7H	; キ
	CALL	WRITE
	LD	A,0B4H	; エ
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES4:	PUSH	AF
	CALL	CLEAR
	LD	A,0B6H	; カ
	CALL	WRITE
	LD	A,0BEH	; セ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0B6H	; カ
	CALL	WRITE
	LD	A,0BEH	; セ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0CCH	; フ
	CALL	WRITE
	LD	A,0B8H	; ク
	CALL	WRITE
	LD	A,0C5H	; ナ
	CALL	WRITE
	POP	AF
	RET
;--------------------------------------
MES5:	PUSH	AF
	CALL	CLEAR
	CALL	CLEAR
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0ACH	; ャ
	CALL	WRITE
	LD	A,0CEH	; ホ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0CAH	; ハ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0BFH	; ソ
	CALL	WRITE
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
PPIINI:	LD	A,99H
	OUT	(PPR0),A
	LD	A,81H
	OUT	(PPR1),A
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