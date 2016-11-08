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
;------------------------------------------------
	LD	A,6EH	; n
	CALL	WRITE
	LD	A,75H	; u
	CALL	WRITE
	LD	A,6CH	; l
	CALL	WRITE
	CALL	WRITE
;--------------------------------------
; 無限ループ
;--------------------------------------
	EI
	JR	$
;------------------------------------------------
; 割り込みルーチン
;------------------------------------------------
;
;--------------------------------------
; Switch : 0
;--------------------------------------
INT0:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,30H	; 0
	CALL	WRITE
	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 1
;--------------------------------------
INT1:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,31H	; 1
	CALL	WRITE
	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 2
;--------------------------------------
INT2:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,32H	; 2
	CALL	WRITE
	POP	AF
	EI
	RETI
;--------------------------------------
; Switch : 3
;--------------------------------------
INT3:	PUSH	AF
	CALL	CLEAR
	LD	A,53H	; S
	CALL	WRITE
	LD	A,57H	; W
	CALL	WRITE
	LD	A,33H	; 3
	CALL	WRITE
	POP	AF
	EI
	RETI
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
	LD	A,01111011B
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
	LD	B,0
WA2:	LD	C,0
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