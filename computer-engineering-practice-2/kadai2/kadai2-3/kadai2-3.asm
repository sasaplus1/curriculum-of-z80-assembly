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
; 再度初期化
;--------------------------------------
	CALL	INSINI
;--------------------------------------
; メインルーチン
;--------------------------------------
LOOP:	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- 右シフト
	LD	B,13H
RSHIFT:	CALL	R000
	LD	A,1CH
	CALL	INSSET
	CALL	SLEEP
	DEC	B
	JP	NZ,RSHIFT
;-- 戻って消す
	CALL	R000
	LD	A,80H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- 下へ
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- 戻って消す
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- 下へ
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- 戻って消す
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- 下へ
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- 左シフト
	LD	B,13H
LSHIFT:	CALL	R000
	LD	A,18H
	CALL	INSSET
	CALL	SLEEP
	DEC	B
	JP	NZ,LSHIFT
;-- 戻って消す
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- 上へ
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- 戻って消す
	CALL	R000
	LD	A,94H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- 上へ
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;-- *
	LD	A,2AH
	CALL	WRITE
	CALL	SLEEP
;-- 戻って消す
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;
	LD	A,0A0H
	CALL	WRITE
;-- 上へ
	CALL	R000
	LD	A,80H
	CALL	INSSET
	CALL	R010
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
; ちょっと待つ
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