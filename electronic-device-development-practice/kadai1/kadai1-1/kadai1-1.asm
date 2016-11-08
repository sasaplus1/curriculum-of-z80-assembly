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
;----------------------------
; 東京
;----------------------------
TYO01	EQU	9000H	; 時 1桁目
TYO10	EQU	9001H	; 時 2桁目
;----------------------------
; 共通時間
;----------------------------
MIN01	EQU	9002H	; 分 1桁目
MIN10	EQU	9003H	; 分 2桁目
SEC01	EQU	9004H	; 秒 1桁目
SEC10	EQU	9005H	; 秒 2桁目
;----------------------------
; ロンドン	: 東京 - 9時間
;----------------------------
LND01	EQU	9006H	; 時 1桁目
LND10	EQU	9007H	; 時 2桁目
;----------------------------
; モントリオール: 東京 - 14時間
;----------------------------
MTR01	EQU	9008H	; 時 1桁目
MTR10	EQU	9009H	; 時 2桁目
;----------------------------
; ロサンゼルス	: 東京 - 17時間
;----------------------------
LSS01	EQU	900AH	; 時 1桁目
LSS10	EQU	900BH	; 時 2桁目
;--------------------------------------
	ORG	8000H
;------------------------------------------------
; 初期化
;------------------------------------------------
	LD	SP,00H
	DI
	CALL	WDTINI
	CALL	CPUINI
	CALL	CTCINI
	CALL	PIOINI
	CALL	IVSET
;----------------------------
	CALL	INSINI
	CALL	CLEAR
	CALL	INSINI
	CALL	R010
;----------------------------
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
;----------------------------
; トウキョウの表示
;----------------------------
	LD	A,0C4H	;ト
	CALL	WRITE
	LD	A,0B3H	;ウ
	CALL	WRITE
	LD	A,0B7H	;キ
	CALL	WRITE
	LD	A,0AEH	;ョ
	CALL	WRITE
	LD	A,0B3H	;ウ
	CALL	WRITE
;----------------------------
	CALL	R000
	LD	A,0C0H
	CALL	INSSET
	CALL	R010
;----------------------------
; ロンドンの表示
;----------------------------
	LD	A,0DBH	; ロ
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
;----------------------------
	CALL	R000
	LD	A,094H
	CALL	INSSET
	CALL	R010
;----------------------------
; モントリオールの表示
;----------------------------
	LD	A,0D3H	; モ
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0C4H	; ト
	CALL	WRITE
	LD	A,0D8H	; リ
	CALL	WRITE
	LD	A,0B5H	; オ
	CALL	WRITE
	LD	A,0B0H	; ー
	CALL	WRITE
	LD	A,0D9H	; ル
	CALL	WRITE
;----------------------------
	CALL	R000
	LD	A,0D4H
	CALL	INSSET
	CALL	R010
;----------------------------
; ロサンゼルスの表示
;----------------------------
	LD	A,0DBH	; ロ
	CALL	WRITE
	LD	A,0BBH	; サ
	CALL	WRITE
	LD	A,0DDH	; ン
	CALL	WRITE
	LD	A,0BEH	; セ
	CALL	WRITE
	LD	A,0DEH	; (濁点)
	CALL	WRITE
	LD	A,0D9H	; ル
	CALL	WRITE
	LD	A,0BDH	; ス
	CALL	WRITE
;----------------------------
; 共通時間設定
;----------------------------
	LD	A,00H;;;09H
	LD	(MIN01),A
	LD	A,00H;;;05H
	LD	(MIN10),A
;----------------------------
	LD	A,00H
	LD	(SEC01),A
	LD	A,00H;;;05H
	LD	(SEC10),A
;----------------------------
; 東京の時間設定
;----------------------------
	LD	A,00H
	LD	(TYO01),A
	LD	A,00H
	LD	(TYO10),A
;----------------------------
; ロンドンの時間設定
;----------------------------
	LD	A,05H
	LD	(LND01),A
	LD	A,01H
	LD	(LND10),A
;----------------------------
; モントリオールの時間設定
;----------------------------
	LD	A,00H
	LD	(MTR01),A
	LD	A,01H
	LD	(MTR10),A
;----------------------------
; ロサンゼルスの時間設定
;----------------------------
	LD	A,07H
	LD	(LSS01),A
	LD	A,00H
	LD	(LSS10),A
;------------------------------------------------
; メインルーチン
;------------------------------------------------
	EI
	JR	$
;------------------------------------------------
; 割り込み / タイマー
;------------------------------------------------
;
;----------------------------
; 時刻を文字に変換
;---------------------------- 秒 : 1桁目
INT1:	LD	A,(SEC01)
	INC	A
	CP	0AH
	JP	NZ,INT10
	LD	A,00H
	LD	(SEC01),A
	JP	SEC010
INT10:	LD	(SEC01),A
	JP	TIMER
;---------------------------- 秒 : 2桁目
SEC010:	LD	A,(SEC10)
	INC	A
	CP	06H
	JP	NZ,INT11
	LD	A,00H
	LD	(SEC10),A
	JP	MIN001
INT11:	LD	(SEC10),A
	JP	TIMER
;---------------------------- 分 : 1桁目
MIN001:	LD	A,(MIN01)
	INC	A
	CP	0AH
	JP	NZ,INT12
	LD	A,00H
	LD	(MIN01),A
	JP	MIN010
INT12:	LD	(MIN01),A
	JP	TIMER
;---------------------------- 分 : 2桁目
MIN010:	LD	A,(MIN10)
	INC	A
	CP	06H
	JP	NZ,INT13
	LD	A,00H
	LD	(MIN10),A
	JP	TYO001
INT13:	LD	(MIN10),A
	JP	TIMER
;---------------------------- 東京 : 1桁目
TYO001:	LD	A,(TYO10)
	CP	02H
	JP	Z,INT15
;----------------------------
	LD	A,(TYO01)
	INC	A
	CP	0AH
	JP	NZ,INT14
	LD	A,00H
	LD	(TYO01),A
	JP	TYO010
INT14:	LD	(TYO01),A
	JP	LND001
;----------------------------
INT15:	LD	A,(TYO01)
	INC	A
	CP	04H
	JP	INT16
	LD	(TYO01),A
	JP	LND001
INT16:	LD	A,00H
	LD	(TYO10),A
	LD	(TYO01),A
	JP	LND001
;---------------------------- 東京 : 2桁目
TYO010:	LD	A,(TYO10)
	INC	A
	LD	(TYO10),A
;---------------------------- ロンドン
LND001:	LD	A,(LND10)
	CP	02H
	JP	Z,INT18
;----------------------------
	LD	A,(LND01)
	INC	A
	CP	0AH
	JP	NZ,INT17
	LD	A,00H
	LD	(LND01),A
	JP	LND010
INT17:	LD	(LND01),A
	JP	MTR001
;----------------------------
INT18:	LD	A,(LND01)
	INC	A
	CP	04H
	JP	INT16
	LD	(LND01),A
	JP	LND001
INT19:	LD	A,00H
	LD	(LND10),A
	LD	(LND01),A
	JP	MTR001
;---------------------------- ロンドン : 2桁目
LND010:	LD	A,(LND10)
	INC	A
	LD	(LND10),A
;---------------------------- モントリオール
MTR001:	LD	A,(MTR10)
	CP	02H
	JP	Z,INT1B
;----------------------------
	LD	A,(MTR01)
	INC	A
	CP	0AH
	JP	NZ,INT1A
	LD	A,00H
	LD	(MTR01),A
	JP	MTR010
INT1A:	LD	(MTR01),A
	JP	LSS001
;----------------------------
INT1B:	LD	A,(MTR01)
	INC	A
	CP	04H
	JP	INT1C
	LD	(MTR01),A
	JP	LSS001
INT1C:	LD	A,00H
	LD	(MTR10),A
	LD	(MTR01),A
	JP	LSS001
;---------------------------- モントリオール : 2桁目
MTR010:	LD	A,(MTR10)
	INC	A
	LD	(MTR10),A
;---------------------------- ロサンゼルス
LSS001:	LD	A,(LSS10)
	CP	02H
	JP	Z,INT1E
;----------------------------
	LD	A,(LSS01)
	INC	A
	CP	0AH
	JP	NZ,INT1D
	LD	A,00H
	LD	(LSS01),A
	JP	LSS010
INT1D:	LD	(LSS01),A
	JP	TIMER
;----------------------------
INT1E:	LD	A,(LSS01)
	INC	A
	CP	04H
	JP	INT1F
	LD	(LSS01),A
	JP	TIMER
INT1F:	LD	A,00H
	LD	(LSS10),A
	LD	(LSS01),A
	JP	TIMER
;---------------------------- ロサンゼルス : 2桁目
LSS010:	LD	A,(LSS10)
	INC	A
	LD	(LSS10),A
;--------------------------------------
; 時刻の表示 : 東京
;--------------------------------------
; キャレットの移動
;----------------------------
TIMER:	CALL	R000
	LD	A,89H
	CALL	INSSET
	CALL	R010
;---------------------------- 時 : 2桁目
	LD	A,(TYO10)
	CALL	HOUR
;---------------------------- 時 : 1桁目
	LD	A,(TYO01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;--------------------------------------
; 時刻の表示 : ロンドン
;--------------------------------------
; キャレットの移動
;----------------------------
	CALL	R000
	LD	A,0C9H
	CALL	INSSET
	CALL	R010
;---------------------------- 時 : 2桁目
	LD	A,(LND10)
	CALL	HOUR
;---------------------------- 時 : 1桁目
	LD	A,(LND01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;--------------------------------------
; 時刻の表示 : モントリオール
;--------------------------------------
; キャレットの移動
;----------------------------
	CALL	R000
	LD	A,09DH
	CALL	INSSET
	CALL	R010
;---------------------------- 時 : 2桁目
	LD	A,(MTR10)
	CALL	HOUR
;---------------------------- 時 : 1桁目
	LD	A,(MTR01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;--------------------------------------
; 時刻の表示 : ロサンゼルス
;--------------------------------------
; キャレットの移動
;----------------------------
	CALL	R000
	LD	A,0DDH
	CALL	INSSET
	CALL	R010
;---------------------------- 時 : 2桁目
	LD	A,(LSS10)
	CALL	HOUR
;---------------------------- 時 : 1桁目
	LD	A,(LSS01)
	CALL	HOUR
;----------------------------
	CALL	TIME
;----------------------------
	EI
	RETI
;------------------------------------------------
; サブルーチン
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
; 簡単インストラクション設定
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
;----------------------------
; 簡単時間書き込み
;----------------------------
HOUR:	ADD	A,30H
	CALL	WRITE
	RET
;----------------------------
; コロンを表示
;----------------------------
CORON:	LD	A,3AH
	CALL	WRITE
	RET
;----------------------------
; コロン + 分 + コロン + 秒
;----------------------------
TIME:	CALL	CORON
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
;--------------------------------------
;
;----------------------------
; WDTINIの設定
;----------------------------
WDTINI:	LD	A,0DBH
	OUT	(HALTMCR),A
	LD	A,7BH
	OUT	(HALTMR),A
	LD	A,0B1H
	OUT	(HALTMCR),A
	RET
;----------------------------
; CPUINIの設定
;----------------------------
CPUINI:	IM	2
	LD	A,8FH
	LD	I,A
	RET
;----------------------------
; CTCINIの設定
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
; PIOINIの設定
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
; IVSETの設定
;----------------------------
IVSET:	LD	BC,INT1
	LD	(8F04H),BC
	RET
;--------------------------------------
;
;----------------------------
; 時間待ち
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
; 時間待ち(長い)
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
; インストラクションの設定[開始/終了]
;----------------------------
R000:	PUSH	AF
	LD	A,00H
	OUT	(PBD),A
	POP	AF
	RET
;----------------------------
; インストラクションの設定
;----------------------------
R001:	PUSH	AF
	LD	A,04H
	OUT	(PBD),A
	POP	AF
	RET
;----------------------------
; 文字データ書き込み[開始/終了]
;----------------------------
R010:	PUSH	AF
	LD	A,01H
	OUT	(PBD),A
	POP	AF
	RET
;----------------------------
; 文字データ書き込み
;----------------------------
R011:	PUSH	AF
	LD	A,05H
	OUT	(PBD),A
	POP	AF
	RET
;--------------------------------------
	END
;[EOF]