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
;
PPA0	EQU	30H
PPB0	EQU	31H
PPC0	EQU	32H
PPR0	EQU	33H
;
PPA1	EQU	34H
PPB1	EQU	35H
PPC1	EQU	36H
PPR1	EQU	37H
;----------------------------
; 時間記憶用RAM領域の番地定数
;----------------------------
HOR01	EQU	9100H	; 時 1桁目
HOR10	EQU	9101H	; 時 2桁目
MIN01	EQU	9102H	; 分 1桁目
MIN10	EQU	9103H	; 分 2桁目
SEC01	EQU	9104H	; 秒 1桁目
SEC10	EQU	9105H	; 秒 2桁目
;----------------------------
FLAG1	EQU	9106H	; ±フラグ(分)
FLAG2	EQU	9107H	; ±フラグ(時)
;--------------------------------------
	ORG	8000H
;------------------------------------------------
; 初期化
;------------------------------------------------
	LD	SP,00H
	DI
	CALL	WDTINI
	CALL	CPUINI
	CALL	PIOINI
	CALL	CTCINI
	CALL	PPIINI
	CALL	IVSET
;----------------------------
	CALL	LWAIT
	CALL	LWAIT
	CALL	LWAIT
;----------------------------
	CALL	INSINI
	CALL	CLEAR
	CALL	INSINI
	CALL	R010
;----------------------------
	CALL	WAIT
	CALL	WAIT
	CALL	WAIT
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
; 時間設定
;----------------------------
	LD	A,00H
;----------------------------
	LD	(HOR01),A
	LD	(HOR10),A
;----------------------------
	LD	(MIN01),A
	LD	(MIN10),A
;----------------------------
	LD	(SEC01),A
	LD	(SEC10),A
;------------------------------------------------
; メインルーチン
;------------------------------------------------
	CALL	CHANEL
;----------------------------
	IN	A,(PPA0)
	LD	B,A
;----------------------------
	CALL	SWCNL2
;----------------------------
	IN	A,(PPA0)
	LD	C,A
;----------------------------
	CALL	SWCNL1
;----------------------------
	CALL	TIME
;----------------------------
	EI
	JR	$
;------------------------------------------------
; 割り込み / タイマー
;------------------------------------------------
; FLAG1 : 0000 00xx / 下位2ビット : 大,小
;------------------------------------------------
; FLAG2 : 0000 00xx / 下位2ビット : 大,小
;------------------------------------------------
INT1:	LD	A,00H
	LD	(FLAG1),A	;フラグの初期化
	LD	(FLAG2),A	;フラグの初期化
;----------------------------
	CALL	SWCNL1
;----------------------------
	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,CP1
	JP	INT2
;----------------------------
CP1:	CP	B		;前回の値と比較
	LD	B,A		;LDでフラグは変わらんのでここで保存
	JP	Z,INT2		;変化がなかった
	JP	C,MINS		;小さかった
	LD	A,02		;大きかった
	LD	(FLAG1),A	;大きかったフラグ
	JP	INT2
MINS:	LD	A,01H		;小さかったフラグ
	LD	(FLAG1),A
;----------------------------
INT2:	CALL	SWCNL2
;----------------------------
	IN	A,(PPA0)
	LD	E,A
	IN	A,(PPA0)
	CP	E
	JP	Z,CP2
	JP	INT3
;----------------------------
CP2:	CP	C		;前回の値と比較
	LD	C,A		;LDでフラグは変わらんのでここで保存
	JP	Z,INT3		;変化がなかった
	JP	C,HORS		;小さかった
	LD	A,02H		;大きかった
	LD	(FLAG2),A	;大きかったフラグ
	JP	INT3
HORS:	LD	A,01H		;小さかったフラグ
	LD	(FLAG2),A
;----------------------------
; 分の確認/増減
;----------------------------
INT3:	LD	A,(FLAG1)
	CP	02H
	JP	Z,MIN01L	;インクリメント
	CP	01H
	JP	Z,MIN01S	;デクリメント
	JP	INT4		;そのまま
;---------------------------
MIN01L:	LD	A,(MIN01)	;;;以下こぴぺ
	INC	A
	CP	0AH		;1桁目が10だった
	JP	Z,ML01
	LD	(MIN01),A	;10ではなかった
	JP	INT4
ML01:	LD	A,(MIN10)	;10だったので2桁目を調べる
	CP	05H		;2桁目は5か？
	JP	Z,ML10
	LD	A,00H		;1桁目に0を代入
	LD	(MIN01),A	;
	LD	A,(MIN10)
	INC	A		;5ではないので+1
	LD	(MIN10),A
	JP	INT4
ML10:	LD	A,00H		;5なので0を代入
	LD	(MIN01),A
	LD	(MIN10),A
	JP	INT4
;----------------------------
MIN01S:	LD	A,(MIN01)	;;;以下こぴぺ
	CP	00H		;1桁目が0だったら
	JP	Z,MS01		;2桁目を調べに
	DEC	A		;デクリメント
	LD	(MIN01),A	;戻す
	JP	INT4
MS01:	LD	A,(MIN10)	;2桁目調べ
	CP	00H		;0か？
	JP	Z,MS10
	DEC	A		;0ではないので-1
	LD	(MIN10),A	;
	LD	A,09H		;1桁目を9に
	LD	(MIN01),A	;
	JP	INT4
MS10:	LD	A,05H		;両方0なので59
	LD	(MIN10),A	;
	LD	A,09H		;
	LD	(MIN01),A	;
;----------------------------
; 時の確認/増減
;----------------------------
INT4:	LD	A,(FLAG2)
	CP	02H
	JP	Z,HOR01L	;インクリメント
	CP	01H
	JP	Z,HOR01S	;デクリメント
	JP	INT5		;そのまま
;----------------------------
HOR01L:	LD	A,(HOR10)	;;;以下こぴぺ
	CP	02H		;2桁目が2だったら
	JP	Z,HL02
	LD	A,(HOR01)
	CP	09H		;2桁目が2ではなく1桁目が9だったら
	JP	Z,HL01
	INC	A		;2桁目が2ではなく1桁目が9ではなかった
	LD	(HOR01),A
	JP	INT5
HL01:	LD	A,00H		;---2桁目が2ではなく1桁目が9だったら
	LD	(HOR01),A	;1桁目を0に
	LD	A,(HOR10)
	INC	A		;2桁目を+1
	LD	(HOR10),A
	JP	INT5
HL02:	LD	A,(HOR01)	;---2桁目が2だったら
	CP	03H		;1桁目が3だったら
	JP	Z,HL03
	INC	A
	LD	(HOR01),A
	JP	INT5
HL03:	LD	A,00H
	LD	(HOR01),A
	LD	(HOR10),A
	JP	INT5
;----------------------------
HOR01S:	LD	A,(HOR01)	;;;以下こぴぺ
	CP	00H		;1桁目が0だったら
	JP	Z,HS01
	DEC	A		;0ではなかった
	LD	(HOR01),A
	JP	INT5
HS01:	LD	A,(HOR10)	;1桁目が0なので2桁目を調べる
	CP	00H		;0か？
	JP	Z,HS10
	DEC	A		;0ではないので-1
	LD	(HOR10),A
	LD	A,09H		;1桁目を9に
	LD	(HOR01),A
	JP	INT5
HS10:	LD	A,02H		;両方0なので23
	LD	(HOR10),A
	LD	A,03H
	LD	(HOR01),A
;----------------------------
; 時刻書き込み
;----------------------------
INT5:	LD	A,(SEC01)	;;;以下こぴぺ
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
MIN001:	LD	A,(MIN01)	;今の値をもらって
	INC	A		;+1
	CP	0AH		;10になったか？
	JP	NZ,INT12	;10になっていなかったら値を戻して書き込みに行く
	LD	A,00H		;10になっているので0を入れる
	LD	(MIN01),A	;戻す
	JP	MIN010		;2桁目へ
INT12:	LD	(MIN01),A
	JP	TIMER
;---------------------------- 分 : 2桁目
MIN010:	LD	A,(MIN10)	;今の値をもらって
	INC	A		;+1
	CP	06H		;6になったか？
	JP	NZ,INT13	;6になっていなかったら値を戻して書き込みに行く
	LD	A,00H		;6になっているので0を入れる
	LD	(MIN10),A	;戻す
	JP	HOR001		;時間の1桁目へ
INT13:	LD	(MIN10),A
	JP	TIMER
;---------------------------- 時 : 1桁目
HOR001:	LD	A,(HOR10)
	CP	02H
	JP	Z,INT15
;----------------------------
	LD	A,(HOR01)
	INC	A
	CP	0AH
	JP	NZ,INT14
	LD	A,00H
	LD	(HOR01),A
	JP	HOR010
INT14:	LD	(HOR01),A
	JP	TIMER
;----------------------------
INT15:	LD	A,(HOR01)
	INC	A
	CP	04H
	JP	Z,INT16
	LD	(HOR01),A
	JP	TIMER
INT16:	LD	A,00H
	LD	(HOR10),A
	LD	(HOR01),A
	JP	TIMER
;---------------------------- 時 : 2桁目
HOR010:	LD	A,(HOR10)
	INC	A
	LD	(HOR10),A
;----------------------------
TIMER:	CALL	TIME
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
; チャンネル1に切り替え
;----------------------------
SWCNL1:	PUSH	AF
	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
;----------------------------
	CALL	LWAIT
;----------------------------
	POP	AF
	RET
;----------------------------
; チャンネル2に切り替え
;----------------------------
SWCNL2:	PUSH	AF
	LD	A,0F7H
	OUT	(PPB0),A
	LD	A,0FFH
	OUT	(PPB0),A
;----------------------------
	CALL	LWAIT
;----------------------------
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
TIME:	CALL	R000
	LD	A,89H
	CALL	INSSET
	CALL	R010
;----------------------------
	LD	A,(HOR10)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	LD	A,(HOR01)
	ADD	A,30H
	CALL	WRITE
;----------------------------
	CALL	CORON
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
;----------------------------
; WDTの設定
;----------------------------
WDTINI:	LD	A,0DBH
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
	LD	A,8FH
	LD	I,A
	RET
;----------------------------
; CTCの設定
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
; PPIの設定
;----------------------------
PPIINI:	LD	A,90H
	OUT	(PPR0),A
	LD	A,80H
	OUT	(PPR1),A
	RET
;----------------------------
; IVSETの設定
;----------------------------
IVSET:	LD	BC,INT1
	LD	(8F04H),BC
	RET
;----------------------------
; チャンネルの設定
;----------------------------
CHANEL:	LD	A,0F0H
	OUT	(PPB0),A
	LD	A,0F8H
	OUT	(PPB0),A
	RET
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