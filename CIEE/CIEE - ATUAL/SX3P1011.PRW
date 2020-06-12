#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMPSX3   ºAutor  ³Microsiga           º Data ³  07/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SX3P1011()

_cArqTrb := "\1TOTVS\SX3\SX3_P10.DBF"
dbUseArea (.T.,"DBFCDX",_cArqTrb,"SX3P10",.T.,.F.)
DbSelectArea("SX3P10")
DbGotop()

_cArqTmp := "\1TOTVS\SX3\SX3_P11.DBF"
dbUseArea (.T.,"DBFCDX",_cArqTmp,"SX3P11",.T.,.F.)
_cIndTMP := CriaTrab(NIL,.F.)
_cChave   := "X3_CAMPO"
IndRegua("SX3P11",_cIndTMP,_cChave,,,"Indice Temporario...")
DbSelectArea("SX3P11")
DbGotop()

IF File("\1TOTVS\SX3\SX3COMP.DBF")
	DbSelectArea("NEW")
	NEW->(DbCloseArea())
	FERASE("\1TOTVS\SX3\SX3COMP"+GetDBExtension())
	Ferase("\1TOTVS\SX3\SX3COMP"+OrdBagExt())
EndIf

_aStrut := {;
{"X3_ARQUIVO"	, "C", 003, 0},;
{"X3_ARQ11"		, "C", 003, 0},;
{"X3_ORDEM"		, "C", 002, 0},;
{"X3_ORD11"		, "C", 002, 0},;
{"X3_CAMPO"		, "C", 010, 0},;
{"X3_CAM11"		, "C", 010, 0},;
{"X3_TIPO"		, "C", 001, 0},;
{"X3_TIP11"		, "C", 001, 0},;
{"X3_TAMANHO"	, "N", 003, 0},;
{"X3_TAM11"		, "N", 003, 0},;
{"X3_DECIMAL"	, "N", 001, 0},;
{"X3_DEC11"		, "N", 001, 0},;
{"X3_TITULO"	, "C", 012, 0},;
{"X3_TIT11"		, "C", 012, 0},;
{"X3_TITSPA"	, "C", 012, 0},;
{"X3_TSP11"		, "C", 012, 0},;
{"X3_TITENG"	, "C", 012, 0},;
{"X3_TEN11"		, "C", 012, 0},;
{"X3_DESCRIC"	, "C", 025, 0},;
{"X3_DES11"		, "C", 025, 0},;
{"X3_DESCSPA"	, "C", 025, 0},;
{"X3_DSP11"		, "C", 025, 0},;
{"X3_DESCENG"	, "C", 025, 0},;
{"X3_DEN11"		, "C", 025, 0},;
{"X3_PICTURE"	, "C", 045, 0},;
{"X3_PIC11"		, "C", 045, 0},;
{"X3_VALID"		, "C", 128, 0},;
{"X3_VAL11"		, "C", 128, 0},;
{"X3_USADO"		, "C", 015, 0},;
{"X3_USA11"		, "C", 015, 0},;
{"X3_RELACAO"	, "C", 128, 0},;
{"X3_REL11"		, "C", 128, 0},;
{"X3_F3"		, "C", 006, 0},;
{"X3_F311"		, "C", 006, 0},;
{"X3_NIVEL"		, "N", 001, 0},;
{"X3_NIV11"		, "N", 001, 0},;
{"X3_RESERV"	, "C", 002, 0},;
{"X3_RES11"		, "C", 002, 0},;
{"X3_CHECK"		, "C", 001, 0},;
{"X3_CHE11"		, "C", 001, 0},;
{"X3_TRIGGER"	, "C", 001, 0},;
{"X3_TRI11"		, "C", 001, 0},;
{"X3_PROPRI"	, "C", 001, 0},;
{"X3_PRO11"		, "C", 001, 0},;
{"X3_BROWSE"	, "C", 001, 0},;
{"X3_BRO11"		, "C", 001, 0},;
{"X3_VISUAL"	, "C", 001, 0},;
{"X3_VIS11"		, "C", 001, 0},;
{"X3_CONTEXT"	, "C", 001, 0},;
{"X3_CONT11"	, "C", 001, 0},;
{"X3_OBRIGAT"	, "C", 001, 0},;
{"X3_OBR11"		, "C", 001, 0},;
{"X3_VLDUSER"	, "C", 128, 0},;
{"X3_VLD11"		, "C", 128, 0},;
{"X3_CBOX"		, "C", 128, 0},;
{"X3_CBO11"		, "C", 128, 0},;
{"X3_CBOXSPA"	, "C", 128, 0},;
{"X3_CSP11"		, "C", 128, 0},;
{"X3_CBOXENG"	, "C", 128, 0},;
{"X3_CEN11"		, "C", 128, 0},;
{"X3_PICTVAR"	, "C", 020, 0},;
{"X3_PIC110"	, "C", 020, 0},;
{"X3_WHEN"		, "C", 060, 0},;
{"X3_WHE11"		, "C", 060, 0},;
{"X3_INIBRW"	, "C", 080, 0},;
{"X3_INI11"		, "C", 080, 0},;
{"X3_GRPSXG"	, "C", 003, 0},;
{"X3_GRP11"		, "C", 003, 0},;
{"X3_FOLDER"	, "C", 001, 0},;
{"X3_FOL11"		, "C", 001, 0},;
{"X3_PYME"		, "C", 001, 0},;
{"X3_PYM11"		, "C", 001, 0},;
{"X3_CONDSQL"	, "C", 250, 0},;
{"X3_CON11"		, "C", 250, 0},;
{"X3_CHK11"		, "C", 250, 0},;
{"X3_CHKSQL"	, "C", 250, 0},;
{"X3_IDXSRV"	, "C", 001, 0},;
{"X3_IDX11"		, "C", 001, 0},;
{"X3_ORTOGRA"	, "C", 001, 0},;
{"X3_ORT11"		, "C", 001, 0},;
{"X3_IDXFLD"	, "C", 001, 0},;
{"X3_IDX110"	, "C", 001, 0},;
{"X3_TELA"		, "C", 015, 0},;
{"X3_TEL11"		, "C", 015, 0}}

//{"X3_AGRUP //CAMPO SOMENTE NA VERSAO 11

dbCreate("\1TOTVS\SX3\SX3COMP",_aStrut)
dbUseArea (.T.,,"\1TOTVS\SX3\SX3COMP","NEW",NIL,.F.)
IndRegua("NEW","SX3COMP","X3_CAMPO",,,OemToAnsi("Selecionando Registros..."), .T.)


Processa({|| X3P10()}, "Atualiza SX3_P10")

Return

Static Function X3P10()

DbSelectArea("SX3P10")
DbGotop()
ProcRegua(RecCount())

Do While !EOF()

	IncProc()
	
    RecLock("NEW",.T.)

	NEW->X3_ARQUIVO		:= SX3P10->X3_ARQUIVO
	NEW->X3_ARQ11		:= ""

	NEW->X3_ORDEM		:= SX3P10->X3_ORDEM
	NEW->X3_ORD11		:= ""

	NEW->X3_CAMPO		:= SX3P10->X3_CAMPO
	NEW->X3_CAM11		:= ""

	NEW->X3_TIPO		:= SX3P10->X3_TIPO
	NEW->X3_TIP11		:= ""

	NEW->X3_TAMANHO		:= SX3P10->X3_TAMANHO
	NEW->X3_TAM11		:= 0

	NEW->X3_DECIMAL		:= SX3P10->X3_DECIMAL
	NEW->X3_DEC11		:= 0

	NEW->X3_TITULO		:= SX3P10->X3_TITULO
	NEW->X3_TIT11		:= ""

	NEW->X3_TITSPA		:= SX3P10->X3_TITSPA
	NEW->X3_TSP11		:= ""

	NEW->X3_TITENG		:= SX3P10->X3_TITENG
	NEW->X3_TEN11		:= ""

	NEW->X3_DESCRIC		:= SX3P10->X3_DESCRIC
	NEW->X3_DES11		:= ""

	NEW->X3_DESCSPA		:= SX3P10->X3_DESCSPA
	NEW->X3_DSP11		:= ""

	NEW->X3_DESCENG		:= SX3P10->X3_DESCENG
	NEW->X3_DEN11		:= ""

	NEW->X3_PICTURE		:= SX3P10->X3_PICTURE
	NEW->X3_PIC11		:= ""

	NEW->X3_VALID		:= SX3P10->X3_VALID
	NEW->X3_VAL11		:= ""

	NEW->X3_USADO		:= SX3P10->X3_USADO
	NEW->X3_USA11		:= ""

	NEW->X3_RELACAO		:= SX3P10->X3_RELACAO
	NEW->X3_REL11		:= ""

	NEW->X3_F3			:= SX3P10->X3_F3
	NEW->X3_F311		:= ""

	NEW->X3_NIVEL		:= SX3P10->X3_NIVEL
	NEW->X3_NIV11		:= 0

	NEW->X3_RESERV		:= SX3P10->X3_RESERV
	NEW->X3_RES11		:= ""

	NEW->X3_CHECK		:= SX3P10->X3_CHECK
	NEW->X3_CHE11		:= ""

	NEW->X3_TRIGGER		:= SX3P10->X3_TRIGGER
	NEW->X3_TRI11		:= ""

	NEW->X3_PROPRI		:= SX3P10->X3_PROPRI
	NEW->X3_PRO11		:= ""

	NEW->X3_BROWSE		:= SX3P10->X3_BROWSE
	NEW->X3_BRO11		:= ""

	NEW->X3_VISUAL		:= SX3P10->X3_VISUAL
	NEW->X3_VIS11		:= ""

	NEW->X3_CONTEXT		:= SX3P10->X3_CONTEXT
	NEW->X3_CON11		:= ""

	NEW->X3_OBRIGAT		:= SX3P10->X3_OBRIGAT
	NEW->X3_OBR11		:= ""

	NEW->X3_VLDUSER		:= SX3P10->X3_VLDUSER
	NEW->X3_VLD11		:= ""

	NEW->X3_CBOX		:= SX3P10->X3_CBOX
	NEW->X3_CBO11		:= ""

	NEW->X3_CBOXSPA		:= SX3P10->X3_CBOXSPA
	NEW->X3_CSP11		:= ""

	NEW->X3_CBOXENG		:= SX3P10->X3_CBOXENG
	NEW->X3_CEN11		:= ""

	NEW->X3_PICTVAR		:= SX3P10->X3_PICTVAR
	NEW->X3_PIC110		:= ""

	NEW->X3_WHEN		:= SX3P10->X3_WHEN
	NEW->X3_WHE11		:= ""

	NEW->X3_INIBRW		:= SX3P10->X3_INIBRW
	NEW->X3_INI11		:= ""

	NEW->X3_GRPSXG		:= SX3P10->X3_GRPSXG
	NEW->X3_GRP11		:= ""

	NEW->X3_FOLDER		:= SX3P10->X3_FOLDER
	NEW->X3_FOL11		:= ""

	NEW->X3_PYME		:= SX3P10->X3_PYME
	NEW->X3_PYM11		:= ""

	NEW->X3_CONDSQL		:= SX3P10->X3_CONDSQL
	NEW->X3_CON11		:= ""

	NEW->X3_CHKSQL		:= SX3P10->X3_CHKSQL
	NEW->X3_CHK11		:= ""

	NEW->X3_IDXSRV		:= SX3P10->X3_IDXSRV
	NEW->X3_IDX11		:= ""

	NEW->X3_ORTOGRA		:= SX3P10->X3_ORTOGRA
	NEW->X3_ORT11		:= ""

	NEW->X3_IDXFLD		:= SX3P10->X3_IDXFLD
	NEW->X3_IDX110		:= ""

	NEW->X3_TELA		:= SX3P10->X3_TELA
	NEW->X3_TEL11		:= ""

    MsUnLock()
	DbSelectArea("SX3P10")
	DbSkip()
EndDo

Processa({|| X3P11()}, "Atualiza SX3_P11")

Return

Static Function X3P11()

DbSelectArea("SX3P11")
DbSetOrder(1)
DbGotop()
ProcRegua(RecCount())

Do While !EOF()

	IncProc()

	DbSelectArea("NEW")
	DbSetOrder(1)
	If DbSeek(SX3P11->X3_CAMPO)
	    RecLock("NEW",.F.)
		NEW->X3_ARQ11		:= SX3P11->X3_ARQUIVO
		NEW->X3_ORD11		:= SX3P11->X3_ORDEM
		NEW->X3_CAM11		:= SX3P11->X3_CAMPO
		NEW->X3_TIP11		:= SX3P11->X3_TIPO
		NEW->X3_TAM11		:= SX3P11->X3_TAMANHO
		NEW->X3_DEC11		:= SX3P11->X3_DECIMAL
		NEW->X3_TIT11		:= SX3P11->X3_TITULO
		NEW->X3_TSP11		:= SX3P11->X3_TITSPA
		NEW->X3_TEN11		:= SX3P11->X3_TITENG
		NEW->X3_DES11		:= SX3P11->X3_DESCRIC
		NEW->X3_DSP11		:= SX3P11->X3_DESCSPA
		NEW->X3_DEN11		:= SX3P11->X3_DESCENG
		NEW->X3_PIC11		:= SX3P11->X3_PICTURE
		NEW->X3_VAL11		:= SX3P11->X3_VALID
		NEW->X3_USA11		:= SX3P11->X3_USADO
		NEW->X3_REL11		:= SX3P11->X3_RELACAO
		NEW->X3_F311		:= SX3P11->X3_F3
		NEW->X3_NIV11		:= SX3P11->X3_NIVEL
		NEW->X3_RES11		:= SX3P11->X3_RESERV
		NEW->X3_CHE11		:= SX3P11->X3_CHECK
		NEW->X3_TRI11		:= SX3P11->X3_TRIGGER
		NEW->X3_PRO11		:= SX3P11->X3_PROPRI
		NEW->X3_BRO11		:= SX3P11->X3_BROWSE
		NEW->X3_VIS11		:= SX3P11->X3_VISUAL
		NEW->X3_CON11		:= SX3P11->X3_CONTEXT
		NEW->X3_OBR11		:= SX3P11->X3_OBRIGAT
		NEW->X3_VLD11		:= SX3P11->X3_VLDUSER
		NEW->X3_CBO11		:= SX3P11->X3_CBOX
		NEW->X3_CSP11		:= SX3P11->X3_CBOXSPA
		NEW->X3_CEN11		:= SX3P11->X3_CBOXENG
		NEW->X3_PIC110		:= SX3P11->X3_PICTVAR
		NEW->X3_WHE11		:= SX3P11->X3_WHEN
		NEW->X3_INI11		:= SX3P11->X3_INIBRW
		NEW->X3_GRP11		:= SX3P11->X3_GRPSXG
		NEW->X3_FOL11		:= SX3P11->X3_FOLDER
		NEW->X3_PYM11		:= SX3P11->X3_PYME
		NEW->X3_CON11		:= SX3P11->X3_CONDSQL
		NEW->X3_CHK11		:= SX3P11->X3_CHKSQL
		NEW->X3_IDX11		:= SX3P11->X3_IDXSRV
		NEW->X3_ORT11		:= SX3P11->X3_ORTOGRA
		NEW->X3_IDX110		:= SX3P11->X3_IDXFLD
		NEW->X3_TEL11		:= SX3P11->X3_TELA
	    MsUnLock()
	Else

	    RecLock("NEW",.T.)

		NEW->X3_ARQUIVO		:= ""
		NEW->X3_ARQ11		:= SX3P11->X3_ARQUIVO

		NEW->X3_ORDEM		:= ""
		NEW->X3_ORD11		:= SX3P11->X3_ORDEM
	
		NEW->X3_CAMPO		:= ""
		NEW->X3_CAM11		:= SX3P11->X3_CAMPO
	
		NEW->X3_TIPO		:= ""
		NEW->X3_TIP11		:= SX3P11->X3_TIPO
	
		NEW->X3_TAMANHO		:= 0
		NEW->X3_TAM11		:= SX3P11->X3_TAMANHO
	
		NEW->X3_DECIMAL		:= 0
		NEW->X3_DEC11		:= SX3P11->X3_DECIMAL
	
		NEW->X3_TITULO		:= ""
		NEW->X3_TIT11		:= SX3P11->X3_TITULO
	
		NEW->X3_TITSPA		:= ""
		NEW->X3_TSP11		:= SX3P11->X3_TITSPA
	
		NEW->X3_TITENG		:= ""
		NEW->X3_TEN11		:= SX3P11->X3_TITENG
	
		NEW->X3_DESCRIC		:= ""
		NEW->X3_DES11		:= SX3P11->X3_DESCRIC
	
		NEW->X3_DESCSPA		:= ""
		NEW->X3_DSP11		:= SX3P11->X3_DESCSPA
	
		NEW->X3_DESCENG		:= ""
		NEW->X3_DEN11		:= SX3P11->X3_DESCENG
	
		NEW->X3_PICTURE		:= ""
		NEW->X3_PIC11		:= SX3P11->X3_PICTURE
	
		NEW->X3_VALID		:= ""
		NEW->X3_VAL11		:= SX3P11->X3_VALID
	
		NEW->X3_USADO		:= ""
		NEW->X3_USA11		:= SX3P11->X3_USADO
	
		NEW->X3_RELACAO		:= ""
		NEW->X3_REL11		:= SX3P11->X3_RELACAO
	
		NEW->X3_F3			:= ""
		NEW->X3_F311		:= SX3P11->X3_F3
	
		NEW->X3_NIVEL		:= 0
		NEW->X3_NIV11		:= SX3P11->X3_NIVEL
	
		NEW->X3_RESERV		:= ""
		NEW->X3_RES11		:= SX3P11->X3_RESERV
	
		NEW->X3_CHECK		:= ""
		NEW->X3_CHE11		:= SX3P11->X3_CHECK
	
		NEW->X3_TRIGGER		:= ""
		NEW->X3_TRI11		:= SX3P11->X3_TRIGGER
	
		NEW->X3_PROPRI		:= ""
		NEW->X3_PRO11		:= SX3P11->X3_PROPRI
	
		NEW->X3_BROWSE		:= ""
		NEW->X3_BRO11		:= SX3P11->X3_BROWSE
	
		NEW->X3_VISUAL		:= ""
		NEW->X3_VIS11		:= SX3P11->X3_VISUAL
	
		NEW->X3_CONTEXT		:= ""
		NEW->X3_CON11		:= SX3P11->X3_CONTEXT
	
		NEW->X3_OBRIGAT		:= ""
		NEW->X3_OBR11		:= SX3P11->X3_OBRIGAT
	
		NEW->X3_VLDUSER		:= ""
		NEW->X3_VLD11		:= SX3P11->X3_VLDUSER
	
		NEW->X3_CBOX		:= ""
		NEW->X3_CBO11		:= SX3P11->X3_CBOX
	
		NEW->X3_CBOXSPA		:= ""
		NEW->X3_CSP11		:= SX3P11->X3_CBOXSPA
	
		NEW->X3_CBOXENG		:= ""
		NEW->X3_CEN11		:= SX3P11->X3_CBOXENG
	
		NEW->X3_PICTVAR		:= ""
		NEW->X3_PIC110		:= SX3P11->X3_PICTVAR
	
		NEW->X3_WHEN		:= ""
		NEW->X3_WHE11		:= SX3P11->X3_WHEN
	
		NEW->X3_INIBRW		:= ""
		NEW->X3_INI11		:= SX3P11->X3_INIBRW
	
		NEW->X3_GRPSXG		:= ""
		NEW->X3_GRP11		:= SX3P11->X3_GRPSXG
	
		NEW->X3_FOLDER		:= ""
		NEW->X3_FOL11		:= SX3P11->X3_FOLDER
	
		NEW->X3_PYME		:= ""
		NEW->X3_PYM11		:= SX3P11->X3_PYME
	
		NEW->X3_CONDSQL		:= ""
		NEW->X3_CON11		:= SX3P11->X3_CONDSQL
	
		NEW->X3_CHKSQL		:= ""
		NEW->X3_CHK11		:= SX3P11->X3_CHKSQL
	
		NEW->X3_IDXSRV		:= ""
		NEW->X3_IDX11		:= SX3P11->X3_IDXSRV
	
		NEW->X3_ORTOGRA		:= ""
		NEW->X3_ORT11		:= SX3P11->X3_ORTOGRA
	
		NEW->X3_IDXFLD		:= ""
		NEW->X3_IDX110		:= SX3P11->X3_IDXFLD
	
		NEW->X3_TELA		:= ""
		NEW->X3_TEL11		:= SX3P11->X3_TELA
	
	    MsUnLock()

	EndIf

	DbSelectArea("SX3P11")
	DbSkip()

EndDo

Return