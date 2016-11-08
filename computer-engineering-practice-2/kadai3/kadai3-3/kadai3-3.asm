HALTMR	EQU	0F0H
HALTMCR	EQU	0F1H
CTC	EQU	10H
PAD	EQU	1CH
PAC	EQU	1DH
PBD	EQU	1EH
PBC	EQU	1FH
;--------------------------------------
; キー順番比較用定数
;--------------------------------------
KEY0	EQU	0FH	; No.4
KEY1	EQU	02H	; No.1
KEY2	EQU	06H	; No.2
KEY3	EQU	0EH	; No.3
;
	ORG	8000H
;--------------------------------------
; 初期化 : Z80
;--------------------------------------
	LD	SP,0
	CALL	WDTINI
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	IVSET
;--------------------------------------
; 初期化 : LCDモジュール
;--------------------------------------
	CALL	INSINI	; 初期化
	LD	A,01H	; ディスプレイのクリア
	CALL	INSSET	; ディスプレイのクリア
	CALL	INSINI	; 再初期化
;------------------------------------------------
; メインルーチン
;--------------------------------------
; B : 7 : OK/NG = 0/1
;   : 6 : END?  = 0/1
;   : 5 : null  =   0
;   : 4 : null  =   0
;   : 3 : SW3?  = 0/1
;   : 2 : SW2?  = 0/1
;   : 1 : SW1?  = 0/1
;   : 0 : SW0?  = 0/1
;--------------------------------------
; KEY : SW1 -> SW2 -> SW3 -> SW0
;------------------------------------------------
MAIN:	DI
	LD	B,00H	; 初期化
;----------------------------
	CALL	CLEAR	; 表示をクリア
	CALL	INSINI	; 再設定
	CALL	R010	; おまじない
;----------------------------
	LD	A,0BAH	; コ
	CALL	WRITE
	LD	A,0C9H	; ノ
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0B2H	; イ
	CALL	WRITE
	LD	A,0BAH	; コ
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0BDH	; ス
	CALL	WRITE
	LD	A,0C3H	; テ
	CALL	WRITE
	LD	A,0D1H	; ム
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0CAH	; ハ
	CALL	WRITE
;----------------------------
; 2行目へ移動
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0DBH	; ロ
	CALL	WRITE
	LD	A,0AFH	; ッ
	CALL	WRITE
	LD	A,0B8H	; ク
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0BBH	; サ
	CALL	WRITE
	LD	A,0DAH	; レ
	CALL	WRITE
	LD	A,0C3H	; テ
	CALL	WRITE
	LD	A,0B2H	; イ
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0BDH	; ス
	CALL	WRITE
;----------------------------
; 3行目へ移動
;----------------------------
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0CAH	; ハ
	CALL	WRITE
	LD	A,0DFH	; (半濁点)
	CALL	WRITE
	LD	A,0BDH	; ス
	CALL	WRITE
	LD	A,0DCH	; ワ
	CALL	WRITE
	LD	A,0B0H	; ー
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0A6H	; ヲ
	CALL	WRITE
;----------------------------
; 4行目へ移動
;----------------------------
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;----------------------------
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
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0C3H	; テ
	CALL	WRITE
	LD	A,0B8H	; ク
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	LD	A,0DEH	;  (濁点)
	CALL	WRITE
	LD	A,0BBH	; サ
	CALL	WRITE
	LD	A,0B2H	; イ
	CALL	WRITE
;----------------------------
; 割り込み許可
;----------------------------
	EI
;--------------------------------------
; 無限ループ
;--------------------------------------
LOOP:	BIT	6,B	; フラグは立ってる？
	JP	Z,LOOP	; 立ってなかったらワンモア
	JP	MAIN	; 最初に戻る
;------------------------------------------------
; 割り込みルーチン
;------------------------------------------------
;
;--------------------------------------
; Switch : 0
;--------------------------------------
INT0:	PUSH	AF
;----------------------------
	CALL	ERASE	; 初めての入力だったら消去
	LD	A,30H	; 0
	CALL	WRITE	; LCDに表示
;----------------------------
	SET	0,B	; SW0のフラグを立てる
	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	KEY0	; 順番どおりか調べる
	JP	Z,INT01	; 順番どおりならINT01へ飛ぶ
	SET	7,B	; 失敗フラグを立てる
INT01:	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	0FH	; すべて押されたか調べる
	JP	NZ,INT02; 押されていなかったら続ける
	CALL	FINISH	; 押されていたら終了処理
INT02:	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 1
;--------------------------------------
INT1:	PUSH	AF
;----------------------------
	CALL	ERASE	; 初めての入力だったら消去
	LD	A,31H	; 1
	CALL	WRITE	; LCDに表示
;----------------------------
	SET	1,B	; SW1のフラグを立てる
	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	KEY1	; 順番どおりか調べる
	JP	Z,INT11	; 順番どおりならINT11へ飛ぶ
	SET	7,B	; 失敗フラグを立てる
INT11:	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	0FH	; すべて押されたか調べる
	JP	NZ,INT12; 押されていなかったら続ける
	CALL	FINISH	; 押されていたら終了処理
INT12:	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 2
;--------------------------------------
INT2:	PUSH	AF
;----------------------------
	CALL	ERASE	; 初めての入力だったら消去
	LD	A,32H	; 2
	CALL	WRITE	; LCDに表示
;----------------------------
	SET	2,B	; SW2のフラグを立てる
	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	KEY2	; 順番どおりか調べる
	JP	Z,INT21	; 順番どおりならINT21へ飛ぶ
	SET	7,B	; 失敗フラグを立てる
INT21:	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	0FH	; すべて押されたか調べる
	JP	NZ,INT22; 押されていなかったら続ける
	CALL	FINISH	; 押されていたら終了処理
INT22:	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 3
;--------------------------------------
INT3:	PUSH	AF
;----------------------------
	CALL	ERASE	; 初めての入力だったら消去
	LD	A,33H	; 3
	CALL	WRITE	; LCDに表示
;----------------------------
	SET	3,B	; SW3のフラグを立てる
	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	KEY3	; 順番どおりか調べる
	JP	Z,INT31	; 順番どおりならINT31へ飛ぶ
	SET	7,B	; 失敗フラグを立てる
INT31:	LD	A,B	; 
	AND	0FH	; 下位4ビットを取り出す
	CP	0FH	; すべて押されたか調べる
	JP	NZ,INT32; 押されていなかったら続ける
	CALL	FINISH	; 押されていたら終了処理
INT32:	POP	AF
	EI
	RETI
;------------------------------------------------
; サブルーチン
;------------------------------------------------
;
;--------------------------------------
; 初めての入力だったら消去する
;--------------------------------------
ERASE:	PUSH	AF
	LD	A,B
	AND	0FH
	CP	00H
	JP	NZ,CANCEL
;----------------------------
	CALL	CLEAR	; 表示をクリア
	CALL	INSINI	; 再設定
	CALL	R010	; おまじない
;----------------------------
CANCEL:	POP	AF
	RET
;--------------------------------------
; すべてのスイッチを押した
;--------------------------------------
FINISH:	PUSH	AF
;----------------------------
; 数秒待つ
;----------------------------
	LD	A,0FH
FNSSLP:	CALL	WAIT
	DEC	A
	JP	NZ,FNSSLP
;----------------------------
	BIT	7,B
	JP	Z,OK
	JP	NG
OK:	CALL	SUCCS
	JP	RETURN
NG:	CALL	ERROR
;----------------------------
RETURN:	SET	6,B	; 終了フラグ
;----------------------------
	POP	AF
	RET
;--------------------------------------
; 入力おｋ
;--------------------------------------
SUCCS:	PUSH	AF
	CALL	CLEAR	; 表示をクリア
	CALL	INSINI	; 再設定
	CALL	R010	; おまじない
;----------------------------
	LD	A,0DBH	; ロ
	CALL	WRITE
	LD	A,0AFH	; ッ
	CALL	WRITE
	LD	A,0B8H	; ク
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0CAH	; ハ
	CALL	WRITE
;----------------------------
; 2行目へ移動
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,0B6H	; カ
	CALL	WRITE
	LD	A,0B2H	; イ
	CALL	WRITE
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0AEH	; ョ
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0BBH	; サ
	CALL	WRITE
	LD	A,0DAH	; レ
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
;----------------------------
; 10秒ほど待つ
;----------------------------
	LD	A,90H
SCCSLP:	CALL	WAIT
	DEC	A
	JP	NZ,SCCSLP
;----------------------------
	POP	AF
	RET
;--------------------------------------
; 入力だめぽ
;--------------------------------------
ERROR:	PUSH	AF
	CALL	CLEAR	; 表示をクリア
	CALL	INSINI	; 再設定
	CALL	R010	; おまじない
;----------------------------
	LD	A,0B1H	; ア
	CALL	WRITE
	LD	A,0D4H	; ヤ
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0AFH	; ッ
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0CAH	; ハ
	CALL	WRITE
	LD	A,0DFH	; (半濁点)
	CALL	WRITE
	LD	A,0BDH	; ス
	CALL	WRITE
	LD	A,0DCH	; ワ
	CALL	WRITE
	LD	A,0B0H	; ー
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0B6H	; カ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
;----------------------------
; 2行目へ移動
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
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
	LD	A,0A0H	; (スペース)
	CALL	WRITE
	LD	A,0BBH	; サ
	CALL	WRITE
	LD	A,0DAH	; レ
	CALL	WRITE
	LD	A,0CFH	; マ
	CALL	WRITE
	LD	A,0BCH	; シ
	CALL	WRITE
	LD	A,0C0H	; タ
	CALL	WRITE
;----------------------------
; 10秒ほど待つ
;----------------------------
	LD	A,90H
ERRSLP:	CALL	WAIT
	DEC	A
	JP	NZ,ERRSLP
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
	RET
;--------------------------------------
; CPUの設定
;--------------------------------------
CPUINI:	IM	2
	LD	A,90H
	LD	I,A
	RET
;--------------------------------------
; CTCの設定
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
; PIOの設定
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
; 割り込み設定
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
; 時間待ち
;--------------------------------------
WAIT:	PUSH	BC
	LD	B,0FFH
WA2:	LD	C,0FFH
WA1:	DEC	C
	JP	NZ,WA1
	DEC	B
	JP	NZ,WA2
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