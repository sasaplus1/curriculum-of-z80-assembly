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
; 初期化
;--------------------------------------
	CALL	INSINI
;--------------------------------------
; ディスプレイのクリア
;--------------------------------------
	LD	A,01H
	CALL	INSSET
;--------------------------------------
; メインルーチン
;--------------------------------------
LOOP:	CALL	INSINI
	CALL	R010
;-- ニ
	LD	A,0C6H
	CALL	WRITE
;-- イ
	LD	A,0B2H
	CALL	WRITE
;-- カ
	LD	A,0B6H
	CALL	WRITE
;-- (濁点)
	LD	A,0DEH
	CALL	WRITE
;-- タ
	LD	A,0C0H
	CALL	WRITE
;-- ケ
	LD	A,0B9H
	CALL	WRITE
;-- ン
	LD	A,0DDH
	CALL	WRITE
;-- 改行(2行目へ)
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;-- ニ
	LD	A,0C6H
	CALL	WRITE
;-- イ
	LD	A,0B2H
	CALL	WRITE
;-- カ
	LD	A,0B6H
	CALL	WRITE
;-- (濁点)
	LD	A,0DEH
	CALL	WRITE
;-- タ
	LD	A,0C0H
	CALL	WRITE
;-- シ
	LD	A,0BCH
	CALL	WRITE
;-- (スペース)
	LD	A,0A0H
	CALL	WRITE
;-- チ
	LD	A,0C1H
	CALL	WRITE
;-- ュ
	LD	A,0ADH
	CALL	WRITE
;-- ウ
	LD	A,0B3H
	CALL	WRITE
;-- オ
	LD	A,0B5H
	CALL	WRITE
;-- ウ
	LD	A,0B3H
	CALL	WRITE
;-- ク
	LD	A,0B8H
	CALL	WRITE
;-- 改行(3行目へ)
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;-- ア
	LD	A,0B1H
	CALL	WRITE
;-- フ
	LD	A,0CCH
	CALL	WRITE
;-- (濁点)
	LD	A,0DEH
	CALL	WRITE
;-- ミ
	LD	A,0D0H
	CALL	WRITE
;-- 2
	LD	A,32H
	CALL	WRITE
;-- チ
	LD	A,0C1H
	CALL	WRITE
;-- ョ
	LD	A,0AEH
	CALL	WRITE
;-- ウ
	LD	A,0B3H
	CALL	WRITE
;-- メ
	LD	A,0D2H
	CALL	WRITE
;-- 2
	LD	A,32H
	CALL	WRITE
;-- ハ
	LD	A,0CAH
	CALL	WRITE
;-- (濁点)
	LD	A,0DEH
	CALL	WRITE
;-- ン
	LD	A,0DDH
	CALL	WRITE
;-- 1
	LD	A,31H
	CALL	WRITE
;-- 3
	LD	A,33H
	CALL	WRITE
;-- コ
	LD	A,0BAH
	CALL	WRITE
;-- (濁点)
	LD	A,0DEH
	CALL	WRITE
;-- ウ
	LD	A,0B3H
	CALL	WRITE
;-- 改行(4行目へ)
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;-- サ
	LD	A,0BBH
	CALL	WRITE
;-- サ
	LD	A,0BBH
	CALL	WRITE
;-- ケ
	LD	A,0B9H
	CALL	WRITE
;-- (濁点)
	LD	A,0DEH
	CALL	WRITE
;-- (スペース)
	LD	A,0A0H
	CALL	WRITE
;-- タ
	LD	A,0C0H
	CALL	WRITE
;-- カ
	LD	A,0B6H
	CALL	WRITE
;-- フ
	LD	A,0CCH
	CALL	WRITE
;-- ミ
	LD	A,0D0H
	CALL	WRITE
;-- カーソルの非表示
	LD	A,0CH
	CALL	INSSET
;-- 待つ
	LD	A,19H
SLEEP:	CALL	WAIT
	DEC	A
	JP	NZ,SLEEP
;-- 表示をクリア
	LD	A,01H
	CALL	INSSET
;-- 戻る
	JP	LOOP
;--------------------------------------
; サブルーチン
;--------------------------------------
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
;   表示/カーソルON
;   ブリンクOFF
;
	LD	A,0EH
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
;
	END
;[EOF]