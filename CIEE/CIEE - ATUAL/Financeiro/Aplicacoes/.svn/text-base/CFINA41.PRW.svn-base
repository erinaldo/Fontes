#Include "rwmake.ch"
#Include "PROTHEUS.CH"
#include "TOPCONN.ch"
#Include "MSGRAPHI.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณEmerson Natali      บ Data ณ  20/02/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Demonstrativo Aplicacoes Financeiras                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA41()

LOCAL xRet := .T.
LOCAL lProc030a		:= .F.  // Carregar dados CDB PRE
LOCAL lProc030b		:= .F.  // Carregar dados CDB POS
LOCAL lProc030c		:= .F.  // Carregar dados BRADESCO
LOCAL lProc030d		:= .F.  // TOTAL POR CDB
LOCAL lProc030e		:= .F.  // TOTAL POR BANCO
LOCAL lProc030f		:= .F.  // TOTAL POR BANCO

PRIVATE cCadastro  := OemToAnsi("Consulta")
PRIVATE nTotal1    := nTotal2 := nTotal3 := nTotal4 := _nTotGer := 0

PRIVATE nCont		:= 0
PRIVATE aHeader		:= {}
PRIVATE aCols		:= {}
PRIVATE aAlt		:= {}

PRIVATE aHeader1	:= {}
PRIVATE aCols1		:= {}
PRIVATE aAlt1		:= {}

PRIVATE aHeader2	:= {}
PRIVATE aCols2		:= {}
PRIVATE aAlt2		:= {}

PRIVATE aHeader3	:= {}
PRIVATE aCols3		:= {}
PRIVATE aAlt3		:= {}

PRIVATE aSvHeader	:= {{},{},{},{}}
PRIVATE aSvCols		:= {{},{},{},{}}

PRIVATE oFolder030
PRIVATE nDest030
PRIVATE aCampos1 := {}
PRIVATE aCampos2 := {}
PRIVATE aCampos3 := {}
PRIVATE aCampos4 := {}
PRIVATE aCampos5 := {}
PRIVATE aNomearq[5]
PRIVATE nTitulos1  := nTitulos2 := nTitulos3 := 0

PRIVATE cParams		:= ""
PRIVATE cOpcoes		:= "1;0;1;Reserva Financeira"

PRIVATE _aAltaCols	:= {}

PRIVATE oLbx1,oLbx2,oLbx3,oLbx4,oLbx5,oLbx6

cPerg := "CFIN41    "

_xArea := GetArea()

If !LockByName("SZS",.F.,.F.)
	IF File("LCK.DBF")
		dbUseArea (.T.,,"LCK","LCK", NIL, .F.)
		dbSelectArea("LCK")
		_cMens := "  Tabela de Demonstrativo encontra-se Bloqueado!!!"+chr(10)+chr(13)
		_cMens += "  Nome do usuแrio: "+Alltrim(LCK->LCK_USER)+chr(10)+chr(13)
		MsgYesNoTimer(OemToAnsi(_cMens), OemToAnsi("Aten็ใo"))
		dbCloseArea()
	ENDIF
	Return
Else
	aCampUser := {{"LCK_USER" , "C", 20, 0, OemToAnsi("Usuario")}}
	dbCreate("LCK",aCampUser)
	dbUseArea (.T.,,"LCK","LCK", NIL, .F.)
	IndRegua("LCK","LCK","LCK_USER",,,OemToAnsi("Selecionando Registros..."))

	RecLock("LCK",.T.)
	LCK->LCK_USER := CUSERNAME
	MsUnLock()
	
	LCK->(dbCloseArea())

EndIf

RestArea(_xArea)

_fCriaSX1() // Cria os parametros da rotina

If !pergunte("CFIN41    ",.T.)
	UnLockByName("SZS",.F.,.F.)
	FERASE("LCK"+GetDBExtension())
	Ferase("LCK"+OrdBagExt())
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CDB PRE                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos1 :=	{{"COD"		, "C", 02, 0, OemToAnsi("Cod.")				},;
			{"NOMBCO"	, "C", 15, 0, OemToAnsi("Banco")	   		},;
			{"CONTA"	, "C", 10, 0, OemToAnsi("Nr Conta")			},;
			{"DTAPL"	, "D", 08, 0, OemToAnsi("Dt Aplic")			},;
			{"RESGAT"	, "D", 08, 0, OemToAnsi("Dt Resgate")		},;
			{"VLAPL"	, "N", 14, 2, OemToAnsi("Vl Aplic")			},;
			{"VLNOM"	, "N", 14, 2, OemToAnsi("Vl Nominal")		},;
			{"X252"		, "N", 10, 5, OemToAnsi("Ano 252")			},;
			{"X360"		, "N", 10, 5, OemToAnsi("Ano 360")			},;
			{"TXPER"	, "N", 10, 5, OemToAnsi("Periodo")			},;
			{"XDD"		, "N", 10, 5, OemToAnsi("30 Dias")			},;
			{"DIAS"		, "N", 02, 0, OemToAnsi("Dia Corrido")		},;
			{"DDECOR"	, "N", 03, 0, OemToAnsi("Decorridos")		},;
			{"DU"		, "N", 02, 0, OemToAnsi("Dias Uteis")		},;
			{"REND"		, "N", 14, 2, OemToAnsi("Rends Propor.")	},;
			{"VLATU"	, "N", 14, 2, OemToAnsi("Vl Atualizad")		},;
			{"AJUSTE"	, "N", 14, 2, OemToAnsi("Vl Ajuste")		}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CDB POS                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos2 :=	{{"COD"		, "C", 02, 0, OemToAnsi("Cod.")				},;
			{"NOMBCO"	, "C", 15, 0, OemToAnsi("Banco")	   		},;
			{"CONTA"	, "C", 10, 0, OemToAnsi("Nr Conta")			},;
			{"DTAPL"	, "D", 08, 0, OemToAnsi("Dt Aplic")			},;
			{"RESGAT"	, "D", 08, 0, OemToAnsi("Dt Resgate")		},;
			{"VLAPL"	, "N", 14, 2, OemToAnsi("Vl Aplic")			},;
			{"VLNOM"	, "N", 14, 2, OemToAnsi("Vl Nominal")		},;
			{"X252"		, "N", 10, 5, OemToAnsi("Ano 252")			},;
			{"X360"		, "N", 10, 5, OemToAnsi("Ano 360")			},;
			{"TXPER"	, "N", 10, 5, OemToAnsi("Periodo")			},;
			{"XDD"		, "N", 10, 5, OemToAnsi("30 Dias")			},;
			{"DIAS"		, "N", 02, 0, OemToAnsi("Dia Corrido")		},;
			{"DDECOR"	, "N", 03, 0, OemToAnsi("Decorridos")		},;
			{"DU"		, "N", 02, 0, OemToAnsi("Dias Uteis")		},;
			{"REND"		, "N", 14, 2, OemToAnsi("Rends Propor.")	},;
			{"VLATU"	, "N", 14, 2, OemToAnsi("Vl Atualizad")		},;
			{"AJUSTE"	, "N", 14, 2, OemToAnsi("Vl Ajuste")		}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ BRAM                                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos3 :=	{{"COD"		, "C", 02, 0, OemToAnsi("Cod.")				},;
			{"NOMBCO"	, "C", 15, 0, OemToAnsi("Banco")	   		},;
			{"CONTA"	, "C", 10, 0, OemToAnsi("Nr Conta")			},;
			{"DTAPL"	, "D", 08, 0, OemToAnsi("Dt Aplic")			},;
			{"RESGAT"	, "D", 08, 0, OemToAnsi("Dt Resgate")		},;
			{"VLAPL"	, "N", 14, 2, OemToAnsi("Vl Aplic")			},;
			{"VLNOM"	, "N", 14, 2, OemToAnsi("Vl Nominal")		},;
			{"X252"		, "N", 10, 5, OemToAnsi("Ano 252")			},;
			{"X360"		, "N", 10, 5, OemToAnsi("Ano 360")			},;
			{"TXPER"	, "N", 10, 5, OemToAnsi("Periodo")			},;
			{"XDD"		, "N", 10, 5, OemToAnsi("30 Dias")			},;
			{"DIAS"		, "N", 02, 0, OemToAnsi("Dia Corrido")		},;
			{"DDECOR"	, "N", 03, 0, OemToAnsi("Decorridos")		},;
			{"DU"		, "N", 02, 0, OemToAnsi("Dias Uteis")		},;
			{"REND"		, "N", 14, 2, OemToAnsi("Rends Propor.")	},;
			{"VLATU"	, "N", 14, 2, OemToAnsi("Vl Atualizad")		},;
			{"AJUSTE"	, "N", 14, 2, OemToAnsi("Vl Ajuste")		}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL CDB                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos4 :=	{{"BANCO"	, "C", 15, 0, OemToAnsi("Banco")			},;
			{"CDBPRE"	, "N", 14, 2, OemToAnsi("CDB PRE")	   		},;
			{"CDBPOS"	, "N", 14, 2, OemToAnsi("CDB POS")			},;
			{"BRAM"		, "N", 14, 2, OemToAnsi("BRAM")				}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL BANCO                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos5 :=	{{"BANCO"	, "C", 15, 0, OemToAnsi("Banco")		},;
			{"EM"		, "N", 14, 4, OemToAnsi("Em %")	   		},;
			{"VALOR"	, "N", 14, 2, OemToAnsi("Valor")		},;
			{"QTDEST"	, "N", 14, 2, OemToAnsi("Qtde.Estag")	}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os arquivos temporarios                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa( { |lEnd| Fc030Procri() } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se todos os arquivos foram criados					 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

For nCont := 1 to 5
	If !File(aNomeArq[nCont]+GetDBExtension())
		Help("",1,"Fc030NOARQ")
		UnLockByName("SZS",.F.,.F.)
		FERASE("LCK"+GetDBExtension())
		Ferase("LCK"+OrdBagExt())
		Return
	EndIf
Next nCont

If !lProc030a
	lProc030a := .T.
	Processa( { |lEnd| Fc030Gera(1,.F.) } )
EndIf

If !lProc030b
	lProc030b := .T.
	Processa( { |lEnd| Fc030Gera(2,.F.) } )
EndIf

If !lProc030c
	lProc030c := .T.
	Processa( { |lEnd| Fc030Gera(3,.F.) } )
EndIf

If !lProc030d
	lProc030d := .T.
	Processa( { |lEnd| Fc030Gera(4,.F.) } )
EndIf

If !lProc030e
	lProc030e := .T.
	Processa( { |lEnd| Fc030Gera(5,.F.) } )
EndIf

If !lProc030f
	lProc030f := .T.
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Exibe tela principal da consulta					 		 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FC030Mostr(lProc030a ,lProc030b,lProc030c,lProc030d,lProc030e,lProc030f)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Apaga os arquivos temporarios					 		     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nCont := 1 to 5
	If !Empty(aNomeArq[nCont])
		IF Select("cArq"+Str(nCont,1)) > 0
			dbSelectArea("cArq"+Str(nCont,1))
			dbCloseArea()
			FERASE(aNomearq[nCont]+GetDBExtension())
			Ferase(aNomeArq[nCont]+OrdBagExt())
		ENDIF
	EndIf
Next nCont

lProc030a := .F.  // Carregar dados de CDB PRE
lProc030b := .F.  // Carregar dados de CDB POS
lProc030c := .F.  // Carregar dados de BRADESCO
lProc030d := .F.  // TOTAL POR CDB
lProc030e := .F.  // TOTAL POR BANCO
lProc030f := .F.  // TOTAL POR BANCO

UnLockByName("SZS",.F.,.F.)
FERASE("LCK"+GetDBExtension())
Ferase("LCK"+OrdBagExt())
	
Return( xRet ) 

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfC030Procri ณ Autor ณ Pilar S. Albaladejo   ณ Data ณ 15/01/96 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria estruturas dos arquivos de Trabalho                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณfC030Procri()                                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ FINC030                                                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static FUNCTION Fc030Procri()

// Seta tamanho da regua
ProcRegua(3)

IncProc(OemToAnsi("Criando Arquivo de Trabalho - CDB PRE"))
cNomeArq := Fc030Cria(aCampos1,1)

IncProc(OemToAnsi("Criando Arquivo de Trabalho - CDB POS"))
cNomeArq := Fc030Cria(aCampos2,2)

IncProc(OemToAnsi("Criando Arquivo de Trabalho - BRAM"))
cNomeArq := Fc030Cria(aCampos3,3)

IncProc(OemToAnsi("Criando Arquivo de Trabalho - TOTAL CDB"))
cNomeArq := Fc030Cria(aCampos4,4)

IncProc(OemToAnsi("Criando Arquivo de Trabalho - TOTAL BANCO"))
cNomeArq := Fc030Cria(aCampos5,5)

Return Nil

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfC030Cria ณ Autor ณ Pilar S. Albaladejo   ณ Data ณ 15/01/96 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria estruturas dos arquivos de Trabalho                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณfC030Cria()                                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNao tem                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ FINC030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fc030Cria(aCampos,nCont)

If !Empty(aNomeArq[nCont])
	If (Select("cArq"+Str(nCont,1))<>0)
		dbSelectArea("cArq"+Str(nCont,1))
		dbCloseArea()
	Endif
Endif

//aNomeArq[nCont] := CriaTrab(aCampos)
dbCreate("cArq"+Str(nCont,1),aCampos)
aNomeArq[nCont] := "cArq"+Str(nCont,1)
dbUseArea (.T.,,aNomeArq[nCont],"cArq"+Str(nCont,1), NIL, .F.)
If STR(nCont,1)$"1|2|3"
	IndRegua("cArq"+Str(nCont,1),aNomeArq[nCont],"DTOS(RESGAT)+NOMBCO",,,OemToAnsi("Selecionando Registros..."))
Else
	IndRegua("cArq"+Str(nCont,1),aNomeArq[nCont],"BANCO",,,OemToAnsi("Selecionando Registros..."))
EndIf

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfC030Mostrณ Autor ณ Pilar S. Albaladejo   ณ Data ณ 15/01/96 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณMostra tela principal da consulta                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณfC030Mostr()                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNao tem                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ FINC030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FC030Mostr(lProc030a,lProc030b,lProc030c,lProc030d,lProc030e,lProc030f)
Local oDlg
//Local oLbx1,oLbx2,oLbx3,oLbx4,oLbx5,oLbx6
Local cMoeda
Local cPict
Local aObjects:= {},aPosObj :={}
Local aSize   := MsAdvSize()
Local aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local oBtnNF

cMoeda   	  := GetMv("MV_MCUSTO")
cMoeda   	  := SubStr(Getmv("MV_SIMB"+cMoeda)+Space(4),1,4)
cPict    	  := PesqPict("SA2","A2_CGC")

AADD(aObjects,{100,030,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE FONT oBold		NAME "Arial" SIZE 0, -18 BOLD
DEFINE FONT oBold_New	NAME "Courier" SIZE 0, -14 BOLD
DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]

@ 001,aPosObj[1,2] TO aPosObj[1,3]+20,aPosObj[1,4] OF oDlg PIXEL

@ 012,045 SAY OemToAnsi("Demonstrativo de Aplica็๕es Financeiras") OF oDlg PIXEL SIZE 245 ,12 FONT oBold COLOR CLR_BLUE

@ 012,255 BUTTON OemToAnsi("Relatorios")	SIZE 42,13 FONT oDlg:oFont ACTION CFINA41A() OF oDlg PIXEL
@ 027,255 BUTTON OemToAnsi("Grafico")		SIZE 42,13 FONT oDlg:oFont ACTION Grafico(oDlg) OF oDlg PIXEL

@ 012,300 BUTTON OemToAnsi("Fechamento")	SIZE 42,13 FONT oDlg:oFont ACTION Processa( {|| CFINA41B() }, "Processando Arquivos..." ) OF oDlg PIXEL
@ 027,300 BUTTON OemToAnsi("Sair")			SIZE 42,13 FONT oDlg:oFont ACTION CFINASAI(oDlg) OF oDlg PIXEL

@ 027,045 SAY OemToAnsi("Data de Referencia - ") OF oDlg PIXEL SIZE 245 ,12 FONT oBold COLOR CLR_BLUE
@ 027,145 SAY mv_par01 OF oDlg PIXEL SIZE 245 ,12 FONT oBold COLOR CLR_BLUE

@ 012,350 SAY OemToAnsi("Data do ฺltimo Fechamento - ")+DTOC(STOD(GETMV("CI_DTFECH"))) OF oDlg PIXEL SIZE 245 ,12 COLOR CLR_HRED

cFolder1 := OemToAnsi("CDB PRE")
cFolder2 := OemToAnsi("CDB POS")
cFolder3 := OemToAnsi("BRADESCO")
cFolder4 := OemToAnsi("PREVISTO")
cFolder5 := OemToAnsi("TOTAL POR CDB")
cFolder6 := OemToAnsi("TOTAL POR BANCO")

aFolder  := {cFolder1,cFolder2,cFolder3,cFolder4,cFolder5,cFolder6}

//oFolder030:=TFolder():New(aPosObj[2,1],aPosObj[2,2],aFolder,{},oDlg,,,, .T., .F.,aPosObj[2,4]-5,aPosObj[2,3]-55,) //versao 10
oFolder030:=TFolder():New(aPosObj[2,1]+20,aPosObj[2,2],aFolder,{},oDlg,,,, .T., .F.,aPosObj[2,4]-5,aPosObj[2,3]-55,) //versao 11
//oFolder030:bSetOption:={|nDest030| Fc030ChFol(nDest030,oFolder030:nOption,@lProc030a,@lProc030b,@lProc030c,@lProc030d,@lProc030e,@lProc030f,oLbx1,oLbx2,oLbx3,oLbx4,oLbx5,oLbx6)}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Informacoes do Folder - CDB PRE                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lDeleta := .F.

aHeader		:= {}
aG1 := { 	"ZS_COD",;
			"ZS_NOMBCO",;
			"ZS_CONTA",;
			"ZS_DTAPL",;
			"ZS_RESGAT",;
			"ZS_VLAPL",;
			"ZS_VLNOM",;
			"ZS_252",;
			"ZS_360",;
			"ZS_TXPER",;
			"ZS_30DD",;
			"ZS_DIAS",;
			"ZS_DDECOR",;
			"ZS_DU",;
			"ZS_REND",;
			"ZS_VLATU"}

//aHeader 		:= MontAhead("SZS")
aHeader 		:= aClone(CriaHeader('SZS',1,aG1))
//aCols			:= aClone(CriaCols('SZS',1,4,,,,aG1,"ZS_TPAPL=='PRE'"))
aSvHeader[1] 	:= aClone(aHeader)
aSvCols[1]		:= aClone(aCols)
//aCampos			:= {"ZS_COD"}
aCampos := {}
AADD(aCampos,"ZS_COD"	)
AADD(aCampos,"ZS_VLATU"	)

aSort(aCols,,, { |x, y| DTOS(x[5])+x[2] < DTOS(y[5])+x[2] })

nUsado  := Len(aHeader)
N       := 1 
nOpc	:= 6
oLbx1	:= MSGetDados():New(aPosObj[2,1]-48,aPosObj[2,2]-2,aPosObj[2,3]-82,aPosObj[2,4]-9,nOpc,"AllwaysTrue","AllwaysTrue",,lDeleta,aCampos,1,,,,,,,oFolder030:aDialogs[1])
oLbx1:oBrowse:bGotFocus 	:={|| Fd_Entra(1)}
oLbx1:oBrowse:bLostFocus	:={|| Fd_Sai(1)}
oLbx1:oBrowse:Default()	
oLbx1:oBrowse:Refresh()	

oFolder030:aDialogs[1]:Refresh()

oFolder030:SetOption(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Informacoes do Folder - CDB POS                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//lDeleta  := .F.
lDeleta  := .T.

aHeader1	:= {}
aG2 := { 	"ZS_COD",;
			"ZS_NOMBCO",;
			"ZS_CONTA",;
			"ZS_DTAPL",;
			"ZS_RESGAT",;
			"ZS_VLAPL",;
			"ZS_30DD",;
			"ZS_PERCDI",;
			"ZS_CDIDIA",;
			"ZS_DIAS",;
			"ZS_DDECOR",;
			"ZS_REND",;
			"ZS_VLATU"}//,;
//			"ZS_AJUSTE"}

//aHeader1 		:= MontAhead("SZS")
aHeader1 		:= aClone(CriaHeader('SZS',2,aG2))
aCols1			:= aClone(CriaCols('SZS',2,4,1,,,aG2,"ZS_TPAPL=='POS'"))

aSvHeader[2] 	:= aClone(aHeader1)
aSvCols[2]		:= aClone(aCols1)

aHeader := aHeader1
aCols	:= aCols1

nUsado   := Len(aHeader1)
n        := len(aCols)
//n        := 1
nOpc	 := 6
oLbx2	 := MSGetDados():New(aPosObj[2,1]-48,aPosObj[2,2]-2,aPosObj[2,3]-82,aPosObj[2,4]-9,nOpc,"AllwaysTrue","AllwaysTrue",,lDeleta,,1,,,,,,,oFolder030:aDialogs[2])
oLbx2:oBrowse:bGotFocus 	:={|| Fd_Entra(2)}
oLbx2:oBrowse:bLostFocus	:={|| Fd_Sai(2)}
oLbx2:oBrowse:Default()	
oLbx2:oBrowse:Refresh()	

oFolder030:aDialogs[2]:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Informacoes do Folder - BRADESCO                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lDeleta  := .T.

aHeader2	:= {}
aG3 := { 	"ZS_COD",;
			"ZS_NOMBCO",;
			"ZS_CONTA",;
			"ZS_DTAPL",;
			"ZS_RESGAT",;
			"ZS_VLAPL",;
			"ZS_30DD",;
			"ZS_PERBRAM",;
			"ZS_BRADIA",;
			"ZS_DIAS",;
			"ZS_DDECOR",;
			"ZS_REND",;
			"ZS_VLATU"}//,;
//			"ZS_AJUSTE"}

aHeader2 		:= aClone(CriaHeader('SZS',3,aG3))
aCols2			:= aClone(CriaCols('SZS',3,4,1,,,aG3,"ZS_TPAPL=='BRA'"))

aSvHeader[3] 	:= aClone(aHeader2)
aSvCols[3]		:= aClone(aCols2)

aHeader := aHeader2
aCols	:= aCols2

nUsado   := Len(aHeader2)
//N		 := 1 
n        := len(aCols)
nOpc	 := 6
oLbx3	 := MSGetDados():New(aPosObj[2,1]-48,aPosObj[2,2]-2,aPosObj[2,3]-82,aPosObj[2,4]-9,nOpc,"AllwaysTrue","AllwaysTrue",,lDeleta,,1,,,,,,,oFolder030:aDialogs[3])
oLbx3:oBrowse:bGotFocus 	:={|| Fd_Entra(3)}
oLbx3:oBrowse:bLostFocus	:={|| Fd_Sai(3)}
oLbx3:oBrowse:Default()	
oLbx3:oBrowse:Refresh()	

oFolder030:aDialogs[3]:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Informacoes do Folder - PREVISTO                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lDeleta  := .T.

aHeader3	:= {}
aG4 := { 	"ZS_ITEM",;
			"ZS_COD",;
			"ZS_DTAPL",;
			"ZS_RESGAT",;
			"ZS_VLAPL"}

//aHeader3 		:= MontAhead("SZS")
aHeader3 		:= aClone(CriaHeader('SZS',4,aG4))
aCols3			:= aClone(CriaCols('SZS',4,3,,,,aG4,"ZS_TPAPL=='PRV'"))

aSvHeader[4] 	:= aClone(aHeader3)
aSvCols[4]		:= aClone(aCols3)

aHeader := aHeader3
aCols	:= aCols3

aCampos := {}
AADD(aCampos,"ZS_COD"	)
AADD(aCampos,"ZS_DTAPL"	)
AADD(aCampos,"ZS_VLAPL"	)

nUsado   := Len(aHeader)
n        := len(aCols)
nOpc	 := 3
oLbx4	 := MSGetDados():New(aPosObj[2,1]-48,aPosObj[2,2]-2,aPosObj[2,3]-82,aPosObj[2,4]-9,nOpc,"AllwaysTrue","AllwaysTrue","+ZS_ITEM",lDeleta,aCampos,1,,,,,,,oFolder030:aDialogs[4])
oLbx4:oBrowse:bGotFocus 	:={|| Fd_Entra(4)}
oLbx4:oBrowse:bLostFocus	:={|| Fd_Sai(4)}
oLbx4:oBrowse:Default()	
oLbx4:oBrowse:Refresh()	

oFolder030:aDialogs[4]:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Informacoes do Folder - TOTAL POR CDB                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("cArq4")
dbGoTop()

@ aPosObj[2,1]-48,aPosObj[2,2]-2 LISTBOX oLbx5 FIELDS 	cArq4->BANCO,;
														Transform(cArq4->CDBPRE,"@E 999,999,999.99"),;
														Transform(cArq4->CDBPOS,"@E 999,999,999.99"),;
														Transform(cArq4->BRAM,"@E 999,999,999.99"),;
HEADER "Banco","CDB PRE","CDB POS","BRAM";
SIZE aPosObj[2,4]-9,aPosObj[2,3]-200 OF oFolder030:aDialogs[5] PIXEL 

@ aPosObj[2,3]-176.5,aPosObj[2,2] Say OemToAnsi("TOTAL CDB PRE  : ") + Transf(nTotal1,Tm(nTotal1,15,2)) OF oFolder030:aDialogs[5] PIXEL FONT oBold_New COLOR CLR_BLUE
@ aPosObj[2,3]-156.5,aPosObj[2,2] Say OemToAnsi("TOTAL CDB POS  : ") + Transf(nTotal2,Tm(nTotal2,15,2)) OF oFolder030:aDialogs[5] PIXEL FONT oBold_New COLOR CLR_BLUE
@ aPosObj[2,3]-136.5,aPosObj[2,2] Say OemToAnsi("TOTAL CDB BRAM : ") + Transf(nTotal3,Tm(nTotal3,15,2)) OF oFolder030:aDialogs[5] PIXEL FONT oBold_New COLOR CLR_BLUE
@ aPosObj[2,3]-116.5,aPosObj[2,2] Say OemToAnsi("TOTAL GERAL    : ") + Transf(nTotal4,Tm(nTotal4,15,2)) OF oFolder030:aDialogs[5] PIXEL FONT oBold_New COLOR CLR_BLUE

oFolder030:aDialogs[5]:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Informacoes do Folder - TOTAL POR BANCO                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("cArq5")
dbGoTop()

@ aPosObj[2,1]-48,aPosObj[2,2]-2 LISTBOX oLbx6 FIELDS 	cArq5->BANCO,;
														cArq5->EM,;
														Transform(cArq5->VALOR,"@E 999,999,999.99"),;
														cArq5->QTDEST,;
HEADER "Banco","Em %","Valor","Qtde.Estag";
SIZE aPosObj[2,4]-9,aPosObj[2,3]-200 OF oFolder030:aDialogs[6] PIXEL 

@ aPosObj[2,3]-176.5,aPosObj[2,2] Say OemToAnsi("TOTAL GERAL    : ") + Transf(nTotal4,Tm(nTotal4,15,2)) OF oFolder030:aDialogs[6] PIXEL FONT oBold_New COLOR CLR_BLUE

oFolder030:aDialogs[6]:Refresh()

ACTIVATE MSDIALOG oDlg

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณFC030ChFolณ Autor ณ Mauricio Pequim Jr    ณ Data ณ 13/11/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Direcionamento da criacao dos arquivos                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ FINC030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fc030ChFol(nDest030,nAtual,lProc030a,lProc030b,lProc030c,lProc030d,lProc030e,lProc030f,oLbx1,oLbx2,oLbx3,oLbx4,oLbx5,oLbx6)

If nDest030 != nAtual
	// Carregar CDB PRE
//	If nDest030 == 1
//		If !lProc030a
//			lProc030a := .T.
//			Processa( { |lEnd| Fc030Gera(1) } )
//		EndIf
//		oLbx1:Refresh()
//		oFolder030:SetOption(1)
//	Endif
	
	// Carregar CDB POS
//	If nDest030 == 2  
//		If !lProc030b
//			lProc030b := .T.
//			Processa( { |lEnd| Fc030Gera(2) } )
//		EndIf
//		oLbx2:Refresh()
//		oFolder030:SetOption(2)
//		oLbx2:SetFocus()
//	Endif
	
	// Carregar BRADESCO
//	If nDest030 == 3
//		If !lProc030c
//			lProc030c := .T.
//			Processa( { |lEnd| Fc030Gera(3) } )
//		EndIf
//		oLbx3:Gotop()
//		oLbx3:Refresh()
//	Endif

//	If nDest030 == 4
//		If !lProc030f
//			lProc030f := .T.
//			Processa( { |lEnd| Fc030Gera(5) } )
//		EndIf
//	Endif

	// Carregar TOTAL POR CDB
	If nDest030 == 5
//		If !lProc030d
//			lProc030d := .T.
			If Alltrim(Str(nAtual,1)) $ "1|2|3|4"
				Fd_Sai(nAtual)
			EndIf
			_fAtualiza()
			Processa( { |lEnd| Fc030Gera(4,.T.) } )
//		EndIf
		oLbx5:Gotop()
		oLbx5:Refresh()
		Return
	Endif

	// Carregar TOTAL POR BANCO
	If nDest030 == 6
//		If !lProc030e
//			lProc030e := .T.
			If Alltrim(Str(nAtual,1)) $ "1|2|3|4"
				Fd_Sai(nAtual)
			EndIf
			_fAtualiza()
			Processa( { |lEnd| Fc030Gera(5,.T.) } )
//		EndIf
		oLbx6:Gotop()
		oLbx6:Refresh()
		Return
	Endif
/*
	If Alltrim(Str(nDest030,1)) $ "1|2|3|4"
		Fd_Entra(nDest030)
	EndIf
*/
Endif	

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfC030Gera ณ Autor ณ Pilar S. Albaladejo   ณ Data ณ 15/01/96 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณGera registros dos arquivos de trabalho                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณfC030Gera()                                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNao tem                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ FINC030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fc030Gera(nProcess,_lAtual)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CDB - PRE                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nProcess == 1
	aCols := {}
	IncProc("CDB PRE")

	DbSelectArea("SZS")
	DbSetOrder(1)
	DbGotop()
	While !EOF()

		If SZS->ZS_TPAPL <> "PRE"
			dbSelectArea("SZS")
			DbSkip()
			Loop
		EndIf
		// Grava registros no arquivo temporario
		dbSelectArea("cArq1")
		_cDU1	 := Iif((mv_par01 - SZS->ZS_DTAPL)>0,(mv_par01 - SZS->ZS_DTAPL),0)
		_cRend1	 := Round(((((SZS->ZS_TXPER/100)+1)^(_cDU1/SZS->ZS_DIAS))*SZS->ZS_VLAPL) - SZS->ZS_VLAPL,2)
		_cVlAtu1 := Round(((((SZS->ZS_TXPER/100)+1)^(_cDU1/SZS->ZS_DIAS))*SZS->ZS_VLAPL),2)

		aaDD(aCols, {	SZS->ZS_COD,;
						SZS->ZS_NOMBCO,;
						SZS->ZS_CONTA,;
						SZS->ZS_DTAPL,;
						SZS->ZS_RESGAT,;
						SZS->ZS_VLAPL,;
						SZS->ZS_VLNOM,;
						SZS->ZS_252,;
						SZS->ZS_360,;
						SZS->ZS_TXPER,;
						SZS->ZS_30DD,;
						SZS->ZS_DIAS,;
						_cDU1,;
						SZS->ZS_DU,;
						_cRend1,;
						_cVlAtu1})

		AAdd(aAlt, SZS->(Recno()))

		dbSelectArea("SZS")
		dbSkip()
	EndDo

	aSort(aCols,,, { |x, y| DTOS(x[5])+x[2] < DTOS(y[5])+x[2] })
	dbSelectArea("cArq1")
	dbGotop()
Endif
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CDB - POS                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nProcess == 2
	aCols1 := {}
	IncProc("CDB POS")
	
	DbSelectArea("SZS")
	DbSetOrder(1)
	DbGotop()
	While !EOF()
		
		If SZS->ZS_TPAPL <> "POS"
			dbSelectArea("SZS")
			DbSkip()
			Loop
		EndIf

		// Grava registros no arquivo temporario
		dbSelectArea("cArq2")
		_cDU2	 := Iif((mv_par01 - SZS->ZS_DTAPL)>0,(mv_par01 - SZS->ZS_DTAPL),0)
		_cRend2	 := Round((((SZS->ZS_VLAPL * ((((mv_par02*SZS->ZS_30DD)/100)/31) * (_cDU2/100))) + SZS->ZS_VLAPL) - SZS->ZS_VLAPL),2)
		_cVlAtu2 := Round(((SZS->ZS_VLAPL * ((((mv_par02*SZS->ZS_30DD)/100)/31) * (_cDU2/100))) + SZS->ZS_VLAPL),2)

		aaDD(aCols1, {	SZS->ZS_COD,;
						SZS->ZS_NOMBCO,;
						SZS->ZS_CONTA,;
						SZS->ZS_DTAPL,;
						SZS->ZS_RESGAT,;
						SZS->ZS_VLAPL,;
						SZS->ZS_30DD,;
						(mv_par02*SZS->ZS_30DD)/100,;
						(((mv_par02*SZS->ZS_30DD)/100)/31) * ((mv_par01 - SZS->ZS_DTAPL)/100),;
						SZS->ZS_DIAS,;
						_cDU2,;
						_cRend2,;
						_cVlAtu2,;
						SZS->ZS_AJUSTE})

		AAdd(aAlt1, SZS->(Recno()))
				
		dbSelectArea("SZS")
		dbSkip()
	EndDo

	dbSelectArea("cArq2")
	dbGotop()
Endif		

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ BRADESCO                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nProcess == 3
	IncProc("BRADESCO")

	DbSelectArea("SZS")
	DbSetOrder(1)
	DbGotop()
	While !EOF()
		
		If SZS->ZS_TPAPL <> "BRA"
			dbSelectArea("SZS")
			DbSkip()
			Loop
		EndIf

		// Grava registros no arquivo temporario
		dbSelectArea("cArq3")
		_cDU3	 := Iif((mv_par01 - SZS->ZS_DTAPL)>0,(mv_par01 - SZS->ZS_DTAPL),0)
		_cRend3	 := Round(((((SZS->ZS_VLAPL * ((mv_par03/SZS->ZS_DIAS)*_cDU3))/100) + SZS->ZS_VLAPL) - SZS->ZS_VLAPL),2)
		_cVlAtu3 := Round((((SZS->ZS_VLAPL * ((mv_par03/SZS->ZS_DIAS)*_cDU3))/100) + SZS->ZS_VLAPL),2)

		aaDD(aCols2, {	SZS->ZS_COD,;
						SZS->ZS_NOMBCO,;
						SZS->ZS_CONTA,;
						SZS->ZS_DTAPL,;
						SZS->ZS_RESGAT,;
						SZS->ZS_VLAPL,;
						SZS->ZS_30DD,;
						mv_par03/SZS->ZS_DIAS,;
						((mv_par03/SZS->ZS_DIAS)*(mv_par01 - SZS->ZS_DTAPL)),;
						SZS->ZS_DIAS,;
						_cDU3,;
						_cRend3,;
						_cVlAtu3,;
						SZS->ZS_AJUSTE})

		AAdd(aAlt2, SZS->(Recno()))
		
		dbSelectArea("SZS")
		dbSkip()
	EndDo

	dbSelectArea("cArq3")
	dbGotop()

Endif	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL CDB                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nProcess == 4

	If _lAtual
		dbSelectArea("cArq4")
		Do While !EOF()
			RecLock("cArq4",.F.)
			DbDelete()
			MsUnLock()
			dbSelectArea("cArq4")
			cArq4->(DbSkip())
		EndDo
	EndIf

	IncProc("TOTAL CDB")

	nTotal1    := nTotal2 := nTotal3 := nTotal4 := 0
	
	DbSelectArea("SZS")
	DbSetOrder(1)
	DbGotop()
	_cBanco	:= ""
	While !EOF()

		If _lAtual

			IF SZS->ZS_TPAPL == "PRV"
				dBSkip()
				Loop
			Else
				_nValApl	:= SZS->ZS_VLATU
			EndIf
		
		Else
	
			_cDU4	 := Iif((mv_par01 - SZS->ZS_DTAPL)>0,(mv_par01 - SZS->ZS_DTAPL),0)
		
			If SZS->ZS_TPAPL == "BRA"
				_nValApl	:= Round((((SZS->ZS_VLAPL * ((mv_par03/SZS->ZS_DIAS)*_cDU4))/100) + SZS->ZS_VLAPL),2)
			ElseIf SZS->ZS_TPAPL == "POS"
				_nValApl	:= Round(((SZS->ZS_VLAPL * ((((mv_par02*SZS->ZS_30DD)/100)/31) * (_cDU4/100))) + SZS->ZS_VLAPL),2)
			ElseIf SZS->ZS_TPAPL == "PRE"
				_nValApl	:= Round(((((SZS->ZS_TXPER/100)+1)^(_cDU4/SZS->ZS_DIAS))*SZS->ZS_VLAPL),2)
			ElseIF SZS->ZS_TPAPL == "PRV"
				dBSkip()
				Loop
			EndIf
		EndIf

		If SZS->ZS_NOMBCO == _cBanco
			// Grava registros no arquivo temporario
			dbSelectArea("cArq4")
			RecLock("cArq4",.F.)
			Do Case
				Case SZS->ZS_TPAPL == "PRE"
					cArq4->CDBPRE	+= _nValApl
				Case SZS->ZS_TPAPL == "POS"
					cArq4->CDBPOS	+= _nValApl
				Case SZS->ZS_TPAPL == "BRA"
					cArq4->BRAM		+= _nValApl
			EndCase
			MsUnLock()
		Else
			// Grava registros no arquivo temporario
			dbSelectArea("cArq4")
			dbSetorder(1)
			If !_lAtual
				If !DbSeek(SZS->ZS_NOMBCO)
					RecLock("cArq4",.T.)
					cArq4->BANCO	:= SZS->ZS_NOMBCO
					Do Case
						Case SZS->ZS_TPAPL == "PRE"
							cArq4->CDBPRE	:= _nValApl
						Case SZS->ZS_TPAPL == "POS"
							cArq4->CDBPOS	:= _nValApl
						Case SZS->ZS_TPAPL == "BRA"
							cArq4->BRAM		:= _nValApl
					EndCase
					MsUnLock()
					_cBanco	:= SZS->ZS_NOMBCO
				EndIf
			Else
				RecLock("cArq4",.T.)
				cArq4->BANCO	:= SZS->ZS_NOMBCO
				Do Case
					Case SZS->ZS_TPAPL == "PRE"
						cArq4->CDBPRE	:= _nValApl
					Case SZS->ZS_TPAPL == "POS"
						cArq4->CDBPOS	:= _nValApl
					Case SZS->ZS_TPAPL == "BRA"
						cArq4->BRAM		:= _nValApl
				EndCase
				MsUnLock()
				_cBanco	:= SZS->ZS_NOMBCO
			EndIf
		EndIf
		
		Do Case
			Case SZS->ZS_TPAPL == "PRE"
				nTotal1	+= _nValApl
			Case SZS->ZS_TPAPL == "POS"
				nTotal2	+= _nValApl
			Case SZS->ZS_TPAPL == "BRA"
				nTotal3	+= _nValApl
		EndCase
		
		nTotal4 += _nValApl //Total Geral

		dbSelectArea("SZS")
		dbSkip()
	EndDo

	dbSelectArea("cArq4")
	dbGotop()

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL BANCO                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nProcess == 5

	If _lAtual
		dbSelectArea("cArq5")
		Do While !EOF()
			RecLock("cArq5",.F.)
			DbDelete()
			MsUnLock()
			dbSelectArea("cArq5")
			cArq5->(DbSkip())
		EndDo
	EndIf

	IncProc("TOTAL BANCOS")

	_nTotGer := 0

	DbSelectArea("SZS")
	DbSetOrder(1)
	DbGotop()
	_cBanco		:= ""
	While !EOF()

		If _lAtual
		
			IF SZS->ZS_TPAPL == "PRV"
				dBSkip()
				Loop
			Else
				_nValApl	:= SZS->ZS_VLATU
			EndIf
			
		Else

			_cDU5	 := Iif((mv_par01 - SZS->ZS_DTAPL)>0,(mv_par01 - SZS->ZS_DTAPL),0)
		
			If SZS->ZS_TPAPL == "BRA"
				_nValApl	:= Round((((SZS->ZS_VLAPL * ((mv_par03/SZS->ZS_DIAS)*_cDU5))/100) + SZS->ZS_VLAPL),2)
			ElseIf SZS->ZS_TPAPL == "POS"
				_nValApl	:= Round(((SZS->ZS_VLAPL * ((((mv_par02*SZS->ZS_30DD)/100)/31) * (_cDU5/100))) + SZS->ZS_VLAPL),2)
			ElseIf SZS->ZS_TPAPL == "PRE"
				_nValApl	:= Round(((((SZS->ZS_TXPER/100)+1)^(_cDU5/SZS->ZS_DIAS))*SZS->ZS_VLAPL),2)
			ElseIf SZS->ZS_TPAPL == "PRV"
				dbSelectArea("SZS")
				DbSkip()
				Loop
			EndIf
		EndIf

		If SZS->ZS_NOMBCO == _cBanco
			// Grava registros no arquivo temporario
			dbSelectArea("cArq5")
			RecLock("cArq5",.F.)
			cArq5->VALOR	+= _nValApl
			cArq5->EM		:= 0
			cArq5->QTDEST	+= 0
			MsUnLock()
		Else
			// Grava registros no arquivo temporario
			dbSelectArea("cArq5")
			dbSetorder(1)
			If !_lAtual
				If !DbSeek(SZS->ZS_NOMBCO)
					RecLock("cArq5",.T.)
					cArq5->BANCO	:= SZS->ZS_NOMBCO
					cArq5->EM		:= 0
					cArq5->VALOR	:= _nValApl
					cArq5->QTDEST	:= 0
					MsUnLock()
					_cBanco	:= SZS->ZS_NOMBCO
				EndIf
			Else
				RecLock("cArq5",.T.)
				cArq5->BANCO	:= SZS->ZS_NOMBCO
				cArq5->EM		:= 0
				cArq5->VALOR	:= _nValApl
				cArq5->QTDEST	:= 0
				MsUnLock()
				_cBanco	:= SZS->ZS_NOMBCO
			EndIf
		EndIf
		
		_nTotGer += _nValApl
		dbSelectArea("SZS")
		dbSkip()

	EndDo

	dbSelectArea("cArq5")
	dbGotop()
	Do While !EOF()
		dbSelectArea("cArq5")
		RecLock("cArq5",.F.)
		cArq5->EM		:= Round((cArq5->VALOR/_nTotGer)*100,4)
		MsUnLock()
		dbSelectArea("cArq5")
		dbSkip()
	EndDo	

	dbSelectArea("cArq5")
	dbGotop()

EndIf

Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  03/26/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fAtualiza()

Local nCont := 1

//Este bloco e para realizar a Alteracao no registro SZS. (Nao pode incluir nem deletar linha)

// Blocos para Folder CDB PRE
dbSelectArea("SZS")
DbSetOrder(1)
For i := 1 To Len(aSvCols[1])
	If i <= Len(aAlt)
		dbGoTo(aAlt[i])
		RecLock("SZS", .F.)
		For y := 1 To Len(aSvHeader[1])
			FieldPut(FieldPos(Trim(aSvHeader[1][y][2])), aSvCols[1][i][y])
		Next
		MSUnlock()
	EndIf
Next i

// Blocos para Folder CDB POS
For i := 1 To Len(aSvCols[2])
	If i <= Len(aAlt1)
		dbGoTo(aAlt1[i])
		If aSvCols[2][i][Len(aSvHeader[2])+1]
			RecLock("SZS", .F.)	
			DbDelete()
			MsUnLock()
		Else
			RecLock("SZS", .F.)
			For y := 1 To Len(aSvHeader[2])
				FieldPut(FieldPos(Trim(aSvHeader[2][y][2])), aSvCols[2][i][y])
			Next
			MSUnlock()
		EndIf
	EndIf
Next i

// Blocos para Folder BRADESCO
For i := 1 To Len(aSvCols[3])
	If i <= Len(aAlt2)
		dbGoTo(aAlt2[i])
		If aSvCols[3][i][Len(aSvHeader[3])+1]
			RecLock("SZS", .F.)	
			DbDelete()
			MsUnLock()
		Else
			RecLock("SZS", .F.)
			For y := 1 To Len(aSvHeader[3])
				FieldPut(FieldPos(Trim(aSvHeader[3][y][2])), aSvCols[3][i][y])
			Next
			MSUnlock()
		EndIf
	EndIf
Next i

// Blocos para Folder PREVISTO
//ALTERACAO
/*
For i := 1 to Len(_aAltaCols)
		DbGoto(_aAltaCols[I])
		RecLock("SZS", .F.)
		For nI := 1 to Len(aSvHeader[4])
		   cCampo	:= "SZS->"+Trim(aSvHeader[4][nI][2])
		   uValor	:= aSvCols[4][i][nI]
		   &cCampo	:= uValor
		Next
		MsUnLock()
		nCont++
Next
*/

//INCLUSAO
/*
For i := nCont To Len(aSvCols[4])
*/
For i := 1 To Len(aSvCols[4])
		If aSvCols[4][i][5] > 0 //Campo de Valor igual a zero nao incluir
			DbSetOrder(2)
			If dbSeek(xFilial("SZS")+aSvCols[4][i][1]) //Pesquisa registro por Item para Alteracao/Inclusao
				RecLock("SZS", .F.)
					For nI := 1 to Len(aSvHeader[4])
					   cCampo	:= "SZS->"+Trim(aSvHeader[4][nI][2])
					   uValor	:= aSvCols[4][i][nI]
					   &cCampo	:= uValor
					Next
				MsUnLock()
			Else
				RecLock("SZS", .T.)
				SZS->ZS_TPAPL := "PRV"
				For nI := 1 to Len(aSvHeader[4])
				   cCampo	:= "SZS->"+Trim(aSvHeader[4][nI][2])
				   uValor	:= aSvCols[4][i][nI]
				   &cCampo	:= uValor
				Next
				MSUnlock()
			EndIf
		EndIf
Next i

DbSetOrder(1)
//DELECAO
For i := 1 To Len(aSvCols[4])
	If aSvCols[4][i][Len(aSvHeader[4])+1]
		DbSelectArea("SZS")
		DbSetOrder(2) //ITEM
		If DbSeek(xFilial("SZS")+aSvCols[4][i][1])
			RecLock("SZS", .F.)
			DbDelete()
			MSUnlock()
		EndIf
	EndIf
Next i

DbSetOrder(1)

Return

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFd_Entra   ณAutor ณ Eduardo Motta         ณ Data ณ 12.12.00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Retorna aCols e aHeader quando se foca a GETDADOS          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ nE - Numero da GetDados.                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Fd_Entra(nE)
Local cVar := "oLbx"+StrZero(nE,1)
aHeader	:= AClone(aSvHeader[nE])
aCols	:= AClone(aSvCols[nE])
n		:= 1
oFolder030:SetOption(nE)
oFolder030:Refresh()
return           

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFd_Sai     ณAutor ณ Eduardo Motta         ณ Data ณ 12.12.00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Guarda aCols e aHeader quando se sai da GETDADOS           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ nE - Numero da GetDados.                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Fd_Sai(nE)
/*
Do Case
	Case nE == 1 //PRE
		aHeader := aClone(aHeader)
		aCols	:= aClone(aCols)
	Case nE == 2 //POS
		aHeader := aClone(aHeader1)
		aCols	:= aClone(aCols1)
	Case nE == 3 //BRA
		aHeader := aClone(aHeader2)
		aCols	:= aClone(aCols2)
	Case nE == 4 //PRV
		aHeader := aClone(aHeader3)
		aCols	:= aClone(aCols3)
EndCase
*/
aSvHeader[nE]	:= aClone(aHeader)
aSvCols[nE]		:= aClone(aCols)
n 				:= 1

_fAtualiza()

Processa( { |lEnd| Fc030Gera(4,.T.) } )
Processa( { |lEnd| Fc030Gera(5,.T.) } )

return

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCriaHeader ณAutor ณ Eduardo Motta         ณ Data ณ 12.12.00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Funcao de criacao do aHeader.                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CriaHeader(cAlias,nF,aNaoCampos)
Local aTmpheader := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
nUsado := 0
While !EOF() .And. (x3_arquivo == cAlias)
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. !Empty( AScan( aNaoCampos, { |x| x == AllTrim(SX3->X3_CAMPO) } ) )
		nUsado++
		AADD(aTmpHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context } )
	EndIf
	dbSkip()
End    
aSvHeader[nF] := aClone(aTmpHeader)
Return aTmpheader

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX1       บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt             ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01     ,def01    ,defspa01,defeng01,cnt01 ,var02,def02 ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3 ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data Referencia"   ,""       ,""       ,"mv_ch1","D" ,08 ,00 ,0  ,"G",""    ,"mv_par01",""       ,""      ,""      ,""    ,""   ,""   ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Previsao CDI ?"    ,""       ,""       ,"mv_ch2","N" ,09 ,05 ,0  ,"G",""    ,"mv_par02",""       ,""      ,""      ,""    ,""   ,""   ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Previsao CDI Brad?",""       ,""       ,"mv_ch3","N" ,09 ,05 ,0  ,"G",""    ,"mv_par03",""       ,""      ,""      ,""    ,""   ,""   ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"","","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  04/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CFINA41A()

Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )
Local oDlg1

Private oLby1

lRet := .T.

//Atualiza as informacoes alteradas pelo usuario
_fAtualiza()
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ4 
Fc030Gera(4,.T.)
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ5
Fc030Gera(5,.T.)

aRelat	:= {}

aAdd(aRelat,{.F.,OemToAnsi("Demonstrativo de Aplica็๕es")	})
aAdd(aRelat,{.F.,OemToAnsi("Composi็ใo de Aplica็๕es")		})


DEFINE MSDIALOG oDlg1 FROM  31,58 TO 300,500 TITLE "Qual Relatorio Deseja Imprimir?" PIXEL
@ 05,05 LISTBOX oLby1 FIELDS HEADER "","Relatorio" SIZE 215, 85 OF oDlg1 PIXEL ON DBLCLICK (U_MARKREL())
	
oLby1:SetArray(aRelat)
oLby1:bLine := { || {If(aRelat[oLby1:nAt,1],oOk,oNo),aRelat[oLby1:nAt,2] } }
oLby1:nFreeze  := 1
	
DEFINE SBUTTON FROM 94, 150 TYPE 1  ENABLE OF oDlg1 ACTION Processa({||  U_ExecRel() },"Processando Registros...")
//DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg1 ACTION (lRet :=.F.,oDlg1:End())
DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg1 ACTION _fFechaTela(oDlg1)
	
ACTIVATE MSDIALOG oDlg1 CENTERED

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  04/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ExecRel()

cParams := DTOC(mv_par01)

If aRelat[oLby1:nAt,1] .and. oLby1:nAt == 1
	CALLCRYS("CRY041", cParams, cOpcoes)
ElseIf aRelat[oLby1:nAt,1] .and. oLby1:nAt == 2
	CALLCRYS("CRY042", cParams, cOpcoes)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  04/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MARKREL()
If aRelat[oLby1:nAt,1]
	aRelat[oLby1:nAt,1] := .F.
Else
	For _nI := 1 to Len(aRelat)
		aRelat[_nI,1] := .F.	
	Next _nI
	aRelat[oLby1:nAt,1] := .T.
EndIf
oLby1:Refresh(.T.)
Return


/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCriaCols   ณAutor ณ Eduardo Motta         ณ Data ณ 12.12.00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Funcao de criacao do aCols de acordo com o aHeader         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

//              CriaCols('SZS' ,4 ,3     ,      ,    ,         ,aG4       ,"ZS_TPAPL=='PRV'")
Static Function CriaCols(cAlias,nF,nOpcao,nOrdem,cKey,cConteudo,aNaoCampos,cFiltro)
Local nUsado:= 0
Local aTmpHeader:= {}, aTmpCols:= {}
Local nCnt:=0
Local cVar,i,nI

nOrdem 		:= if(nOrdem==NIL,2,nOrdem)         
cKey   		:= if(cKey==NIL,'',cKey) 
cConteudo	:= if(cConteudo=NIL,'',cConteudo)
aNaoCampos  := if(aNaoCampos=NIL,{},aNaoCampos)

aTmpHeader := aClone(aSvHeader[nF])

If cFiltro == NIL .or. Empty(cFiltro)
   cFiltro := ".T."
EndIf
cFiltro := "("+Trim(cFiltro)+")"
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbSeek(cConteudo)
While !EOF() .and. if(cKey=='',.t.,(&cKey == cConteudo))
	If ! &cFiltro
       DbSkip()
       Loop
    EndIf
	nCnt++
   	dbSkip()
End	
nCnt := IIF(nCnt=0,nCnt:=1,nCnt)
aTmpCols := Array(nCnt, Len(aTmpHeader) + 1)
nCnt := 0
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbSeek(cConteudo)
While !EOF() .and. if(cKey=='',.t.,(&cKey == cConteudo))
	If ! &cFiltro
       DbSkip()
       Loop
    EndIf
	nCnt++
	nUsado:=0
    dbSelectArea("SX3")
   	dbSeek( cAlias )
   	While !EOF() .And. x3_arquivo == cAlias
   		If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. !Empty( AScan( aNaoCampos, { |x| x == AllTrim(SX3->X3_CAMPO) } ) )
	   		nUsado++
		   	If x3_context # "V"
	   			aTmpCols[nCnt][nUsado] := &(cAlias+"->"+Trim(x3_campo))
		   	ElseIf x3_context == "V"
			   	aTmpCols[nCnt][nUsado] := CriaVar(AllTrim(x3_campo))
   			EndIf
	   	EndIf
   		dbSkip()
   	End
	If SZS->ZS_TPAPL == "PRV"
	   	aadd(_aAltaCols,SZS->(Recno()))
	EndIF
   	dbSelectArea(cAlias)
   	dbSkip()
EndDo

If Len(aTmpCols) == 0
	aTmpCols := Array(1, Len(aTmpHeader) + 1)
	aTmpCols[1,Len(aTmpHeader)+1] := .F.
EndIf	


If cFiltro == "(ZS_TPAPL=='POS')"
	aTmpCols := aCols1
ElseIf cFiltro == "(ZS_TPAPL=='BRA')"
	aTmpCols := aCols2
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Array de 1 elemento ณ
//ณ vazio. Se incluso.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If !Empty(aTmpCols)
	If Empty(aTmpCols[1][1])		//Inclusao ou arquivo vazio
		dbSelectArea("SX3")
		dbSeek(cAlias)
		nUsado:=0
		While !EOF() .And. (x3_arquivo == cAlias)
			If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.	!Empty( AScan( aNaoCampos, { |x| x == AllTrim(SX3->X3_CAMPO) } ) )
				nUsado++
				If x3_tipo == "C" 			
				   	aTmpCols[1][nUsado] := iif(alltrim(x3_campo)=="ZS_ITEM","0001",SPACE(x3_tamanho))
				ElseIf x3_tipo == "N"		
				   	aTmpCols[1][nUsado] := 0
				ElseIf x3_tipo == "D"		
					aTmpCols[1][nUsado] := If(Empty(CriaVar(allTrim(x3_campo))),dDataBase,CriaVar(allTrim(x3_campo)))
				ElseIf x3_tipo == "M"		
					aTmpCols[1][nUsado] := ""
				Else						
					aTmpCols[1][nUsado] := .F.
				EndIf
				If x3_context == "V"		
					aTmpCols[1][nUsado] := CriaVar(allTrim(x3_campo))
				EndIf
			EndIf
			dbSkip()
		EndDo		
	EndIf                                               
EndIf                                               

For nI:=1 To Len(aTmpCols)
   aTmpCols[nI][Len(aTmpHeader)+1] := .F.
Next nI	

aSvCols[nF]	:=aClone(aTmpCols)
Return aTmpCols

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณ FC030GRF ณ Autor ณ Larson Zordan         ณ Data ณ 16/04/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Grafico da Estatistica financeira - a Pagar e Pagos        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ FINC030                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CFINAGRF(nCbx,nVisual)
Local oGraph,oDlgGra
Local aSizeGra    	:= MsAdvSize(.F.)
Local lFlatMode	:= If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
Local lVideo	:= .F.

//Verifica se a resolu็ใo de vํdeo ้ menor que 1024x768
If oMainWnd:nClientWidth < 1000
	lVideo := .T.
EndIf

If nCbx == 5
	nCbx := 10 //Pizza
EndIf

DEFINE MSDIALOG oDlgGra TITLE "Grafico da Estatistica Financeira" OF oMainWnd PIXEL FROM aSizeGra[7],0 TO aSizeGra[6],aSizeGra[5]

oDlgGra:lMaximized := .T.

// Layout da janela
@ 000, 000 BITMAP oBmp RESNAME "ProjetoAP" oF oDlgGra SIZE 50, 270 NOBORDER WHEN .F. PIXEL

@ 010, 055 MSGRAPHIC oGraph SIZE 450, 230 OF oDlgGra PIXEL

If nVisual == 1
	oGraph:SetTitle("Total por Bancos" ,"",CLR_HBLUE,3,.F.)
ElseIf nVisual == 2
	oGraph:SetTitle("Total por CDBs" ,"",CLR_HBLUE,3,.F.)
ElseIf nVisual == 3
	oGraph:SetTitle("Total por Composi็ใo" ,"",CLR_HBLUE,3,.F.)
EndIf

oGraph:SetMargins( 2, 6, 6, 6 )

nSerie := oGraph:CreateSerie(nCbx,,2)

_aArea := GetArea()

If nVisual == 1
	DbSelectArea("cArq5")
	DbGotop()
	nCont	:= 1
	Do While !EOF()

		Do Case            
			Case nCont == 1
				_nCor	:= CLR_HBLUE
			Case nCont == 2
				_nCor	:= CLR_YELLOW
			Case nCont == 3
				_nCor	:= CLR_GREEN
			Case nCont == 4
				_nCor	:= CLR_HRED
			Case nCont == 5
				_nCor	:= CLR_HGRAY
			Case nCont == 6
				_nCor	:= CLR_WHITE
			Case nCont == 7
				_nCor	:= CLR_CYAN
			Case nCont == 8
				_nCor	:= CLR_MAGENTA
			Case nCont == 9
				_nCor	:= CLR_BROWN
			Otherwise
				nCont	:= 1
				_nCor	:= CLR_HBLUE
		EndCase
	
		oGraph:Add(nSerie,cArq5->VALOR/1000, cArq5->BANCO,_nCor)

		nCont++	
	    cArq5->(DbSkip())
	EndDo
ElseIf nVisual == 2
	_aTpApl := {}
	nCont	:= 1
	
	DbSelectArea("cArq4")
	DbGotop()
	Do While !EOF()

		If cArq4->CDBPRE > 0
			_nPos1 := ascan(_aTpApl, { |x| x[1] == "CDB PRE"})
			If _nPos1 > 0
				_aTpApl[_nPos1,2] += cArq4->CDBPRE
			Else
				AADD(_aTpApl, {"CDB PRE", cArq4->CDBPRE})
			EndIf
		EndIf
	
		If cArq4->CDBPOS > 0
			_nPos2 := ascan(_aTpApl, { |x| x[1] == "CDB POS"})
			If _nPos2 > 0
				_aTpApl[_nPos2,2] += cArq4->CDBPOS
			Else
				AADD(_aTpApl, {"CDB POS", cArq4->CDBPOS})
			EndIf
		EndIf

		If cArq4->BRAM > 0
			_nPos3 := ascan(_aTpApl, { |x| x[1] == "BRAM"})
			If _nPos3 > 0
				_aTpApl[_nPos3,2] += cArq4->BRAM
			Else
				AADD(_aTpApl, {"BRAM", cArq4->BRAM})
			EndIf
		EndIf

		cArq4->(dbSkip())
	EndDo

	For _nY := 1 to Len(_aTpApl)

		Do Case            
			Case nCont == 1
				_nCor	:= CLR_HBLUE
			Case nCont == 2
				_nCor	:= CLR_YELLOW
			Case nCont == 3
				_nCor	:= CLR_GREEN
			Case nCont == 4
				_nCor	:= CLR_HRED
			Case nCont == 5
				_nCor	:= CLR_HGRAY
			Case nCont == 6
				_nCor	:= CLR_WHITE
			Case nCont == 7
				_nCor	:= CLR_CYAN
			Case nCont == 8
				_nCor	:= CLR_MAGENTA
			Case nCont == 9
				_nCor	:= CLR_BROWN
			Otherwise
				nCont	:= 1
				_nCor	:= CLR_HBLUE
		EndCase

		oGraph:Add(nSerie,_aTpApl[_nY,2]/1000, _aTpApl[_nY,1],_nCor)
		nCont++	
	Next

ElseIf nVisual == 3

	_aTpComp	:= {}
	nCont		:= 1
	
	DbSelectArea("SZS")
	DbGotop()
	Do While !EOF()
		_nPos := ascan(_aTpComp, { |x| x[1] == SZS->ZS_COD})
		If _nPos > 0
			_aTpComp[_nPos,2] += SZS->ZS_VLATU
		Else
			AADD(_aTpComp, {SZS->ZS_COD, SZS->ZS_VLATU})
		EndIf

		SZS->(DbSkip())
	EndDo


	For _nY := 1 to Len(_aTpComp)

		Do Case            
			Case nCont == 1
				_nCor	:= CLR_HBLUE
			Case nCont == 2
				_nCor	:= CLR_YELLOW
			Case nCont == 3
				_nCor	:= CLR_GREEN
			Case nCont == 4
				_nCor	:= CLR_HRED
			Case nCont == 5
				_nCor	:= CLR_HGRAY
			Case nCont == 6
				_nCor	:= CLR_WHITE
			Case nCont == 7
				_nCor	:= CLR_CYAN
			Case nCont == 8
				_nCor	:= CLR_MAGENTA
			Case nCont == 9
				_nCor	:= CLR_BROWN
			Otherwise
				nCont	:= 1
				_nCor	:= CLR_HBLUE
		EndCase

		DbSelectArea("SZT")
		DbSetOrder(1)
		If DbSeek(xFilial("SZT")+_aTpComp[_nY,1])
			oGraph:Add(nSerie,_aTpComp[_nY,2]/1000, Alltrim(SZT->ZT_DESCRI) ,_nCor)
		EndIf
		nCont++	
	Next

EndIf

If nCbx == 4
	oGraph:l3D := .T.
Else
	oGraph:l3D := .F.
EndIf

RestArea(_aArea)

If nCbx <> 10
	// Habilita a legenda, apenas se houver mais de uma serie de dados.
	oGraph:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
EndIf

oPanel := TPanel():New(0,0,'',oDlgGra,, .T., .T.,,,25,25,.T.,.T. )

oPanel:Align := CONTROL_ALIGN_BOTTOM

oGraph:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraph:SetTitle( "Em milhares de R$","", CLR_HRED , A_LEFTJUST , GRP_TITLE )
oGraph:SetTitle( "", "Dias", CLR_GREEN, A_RIGHTJUS , GRP_FOOT  )

@ 005, If(!lVideo,300,200) BUTTON o3D PROMPT "&3D" SIZE 40,14 OF oPanel PIXEL ACTION (oGraph:l3D := !oGraph:l3D, o3d:cCaption := If(oGraph:l3D, "&2D", "&3D"))
@ 005, If(!lVideo,350,250) BUTTON "&Salva BMP"   SIZE 40,14 OF oPanel PIXEL ACTION GrafSavBmp( oGraph )
//@ 005, If(!lVideo,450,350) BUTTON "&Sair" SIZE 40,14 OF oPanel PIXEL ACTION oDlgGra:End()
@ 005, If(!lVideo,450,350) BUTTON "&Sair" SIZE 40,14 OF oPanel PIXEL ACTION _fFechaTela(oDlgGra)

If lVideo
	oGraph:Align := CONTROL_ALIGN_ALLCLIENT
EndIf

ACTIVATE MSDIALOG oDlgGra

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGrafico   บAutor  ณClaudio D. de Souza บ Data ณ  30/08/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Selecionar o tipo da serie de dados e o tipo de grafico    บฑฑ
ฑฑบ          ณ Parametros:                                                บฑฑ
ฑฑบ          ณ oDlg   -> Objeto dialog onde sera exibido a tela do graficoบฑฑ
ฑฑบ          ณ cAlias -> Alias do arquivo temporario que sera processado  บฑฑ
ฑฑบ          ณ nMoeda -> Codigo da moeda                                  บฑฑ
ฑฑบ          ณ cTit   -> Titulo do eixo X                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Finc021                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Grafico(oDlg)
Local oDlgSer
Local oSer
Local oVisual
Local cCbx := "Linha"
Local cVisual := "Total por Bancos"
Local nCbx := 1
Local aCbx := { "Linha"	, "มrea", "Pontos", "Barras", "Pizza"}
Local aVisual := {"Total por Bancos","Total CDBs","Total por Composi็ใo" }
Local nVisual := 1

//Atualiza as informacoes alteradas pelo usuario
_fAtualiza()
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ4 
Fc030Gera(4,.T.)
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ5
Fc030Gera(5,.T.)

Do Case
	Case oFolder030:nOption == 1
		aHeader	:= aSvHeader[1]
		aCols	:= aSvCols[1]
	Case oFolder030:nOption == 2
		aHeader	:= aSvHeader[2]
		aCols	:= aSvCols[2]
	Case oFolder030:nOption == 3
		aHeader	:= aSvHeader[3]
		aCols	:= aSvCols[3]
	Case oFolder030:nOption == 4
		aHeader	:= aSvHeader[4]
		aCols	:= aSvCols[4]
EndCase

DEFINE MSDIALOG oDlgSer TITLE "Tipo do grแfico" FROM 0,0 TO 100,280 PIXEL OF oDlg

@ 008, 005 SAY "Escolha o tipo de s้rie:" PIXEL OF oDlgSer
@ 008, 063 MSCOMBOBOX oSer VAR cCbx ITEMS aCbx SIZE 077, 120 OF oDlgSer PIXEL ON CHANGE nCbx := oSer:nAt
@ 022, 005 SAY "Tipo de Visualiza็ใo   :" PIXEL OF oDlgSer
@ 022, 063 MSCOMBOBOX oVisual VAR cVisual ITEMS aVisual SIZE 077, 120 OF oDlgSer PIXEL ON CHANGE nVisual := oVisual:nAt
@ 035, 045 BUTTON "&Ok"   SIZE 30,12 OF oDlgSer PIXEL ACTION CFINAGRF(nCbx,nVisual) //(CFINAGRF(nCbx,nVisual),oDlgSer:End())
@ 035, 080 BUTTON "&Sair" SIZE 30,12 OF oDlgSer PIXEL ACTION (oDlgSer:End())

ACTIVATE MSDIALOG oDlgSer CENTER

Return Nil

User Function ValAcols() // Valida acols da tela de DEMONSTRATIVO

_aArea 	:= GetArea()
_lRet 	:= .T.

DbSelectArea("SZT")
DbSetOrder(1)
If DbSeek(xFilial("SZT")+M->ZS_COD)
	If SZT->ZT_BLOQ == "S"
		_cMsg := "C๓digo tipo de Reserva Bloqueado!!!"
		MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
		_lRet := .F.
	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)

User Function ValCotac() // Valida campo de Codigo na tela de Cotacao

_aArea 	:= GetArea()
_lRet 	:= .T.

DbSelectArea("SZT")
DbSetOrder(1)
If DbSeek(xFilial("SZT")+M->ZO_COD)
	If SZT->ZT_BLOQ == "S"
		_cMsg := "C๓digo tipo de Reserva Bloqueado!!!"
		MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
		_lRet := .F.
	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  05/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CFINA41B()

_cDtFech	:= STOD(GETMV("CI_DTFECH"))
_aValTot	:= {}
_aValSE5	:= {}
_nPos		:= 0
_cDt		:= Substr(GETMV("CI_DTFECH"),7,2)+"/"+Substr(GETMV("CI_DTFECH"),5,2)+"/"+Substr(GETMV("CI_DTFECH"),1,4)

_mesFev		:= val(substr(dtoc(LastDay(ctod("01/02/"+str(year(dDataBase),4)))),1,2))

_aMeses	:=	{	{01, "Janeiro"		,31 },;
				{02, "Fevereiro"	,_mesFev },;
				{03, "Marco"		,31 },;
				{04, "Abril"		,30 },;
				{05, "Maio"			,31 },;
				{06, "Junho"		,30 },;
				{07, "Julho"		,31 },;
				{08, "Agosto"		,31 },;
				{09, "Setembro"		,30 },;
				{10, "Outubro"		,31 },;
				{11, "Novembro"		,30 },;
				{12, "Dezembro"		,31 }}

//Atualiza as informacoes alteradas pelo usuario
_fAtualiza()
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ4 
Fc030Gera(4,.T.)
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ5
Fc030Gera(5,.T.)

If mv_par01 < _cDtFech 
	_cMsg := "Ultimo dia do fechamento gerado em: "+_cDt+" !!!"
	MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
	Return
EndIf

_cMesAnoFech := Val(Substr(GETMV("CI_DTFECH"),1,6))
_cMesFech	 := Val(Substr(GETMV("CI_DTFECH"),5,2))
_cDiaFech	 := Val(Substr(GETMV("CI_DTFECH"),7,2))
_cAnoFech	 := Val(Substr(GETMV("CI_DTFECH"),1,4))

If _cMesAnoFech < Val(Substr(DTOS(mv_par01),1,6))

	If _cAnoFech < Year(mv_par01) 
		_nValMes	:= (Val(Substr(DTOS(mv_par01),1,6))) - _cMesAnoFech
	Else
		_nValMes	:= 	(MONTH(mv_par01)-_cMesFech)	
	EndIf

	If _nValMes == 1 .or. _nValMes == 89
		_nPosMES	:= ascan(_aMeses, {|x| x[1] == _cMesFech })
		If _nPosMES > 0
			If !(_cDiaFech == _aMeses[_nPosMES,3])
				_cMsg := "Fechamento nใo Realizado !!!"+CHR(10)+CHR(13)
				_cMsg += "Ultimo dia do fechamento gerado em: "+_cDt+" !!!"
				MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
				Return
			EndIf
		EndIf
	Else
		_nPosMES	:= ascan(_aMeses, {|x| x[1] == _cMesFech })
		If _nPosMES > 0
			_cMsg := "Fechamento nใo Realizado !!!"+CHR(10)+CHR(13)
			_cMsg += "Ultimo dia do fechamento gerado em: "+_cDt+" !!!"
			MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
			Return
		EndIf
	EndIf
EndIf

//Realiza Pesquisa na Base de Contabilidade para verificar
//se nao tem lancamentos Efetivados no periodo selecionado (MES e ANO do Parametro)
If !_fPesqLanc()
	Return
EndIf

DbSelectArea("SZS") 
DbGotop()
ProcRegua(RecCount())

Do While !EOF()

	IncProc("Processando Fechamento...")
	DbSelectArea("SZX")
	DbSetOrder(1)
	If DbSeek(xFilial("SZX")+DTOS(MV_PAR01))
		RecLock("SZX",.F.)
		DbDelete()
		MsUnLock()
	EndIf
EndDo

DbSelectArea("SZS") 
DbGotop()
ProcRegua(RecCount())

Do While !EOF()
	IncProc("Processando Fechamento...")
	DbSelectArea("SZX")
	DbSetOrder(1)
	If DbSeek(xFilial("SZX")+DTOS(MV_PAR01)+SZS->ZS_NOMBCO+SZS->ZS_CONTA+STR(SZS->ZS_VLAPL,14,2)+SZS->ZS_COD) //ACRESCENTADO ZS_COD DIA 01/04/09 PARA NAO DELETAR UM REGISTRO COM COD DIFERENTE
		RecLock("SZX",.F.)
		SZX->ZX_FILIAL	:= xFilial("SZX")
		SZX->ZX_DTFECH	:= mv_par01
		SZX->ZX_MESANO	:= STR(YEAR(mv_par01),4)+ STRZERO(MONTH(mv_par01),2)
		SZX->ZX_TPAPL 	:= SZS->ZS_TPAPL
		SZX->ZX_ITEM 	:= SZS->ZS_ITEM
		SZX->ZX_COD 	:= SZS->ZS_COD
		SZX->ZX_NOMBCO 	:= SZS->ZS_NOMBCO
		SZX->ZX_CONTA 	:= SZS->ZS_CONTA
		SZX->ZX_DTAPL 	:= SZS->ZS_DTAPL
		SZX->ZX_RESGAT 	:= SZS->ZS_RESGAT
		SZX->ZX_VLAPL 	:= SZS->ZS_VLAPL
		SZX->ZX_VLNOM 	:= SZS->ZS_VLNOM
		SZX->ZX_252 	:= SZS->ZS_252
		SZX->ZX_360 	:= SZS->ZS_360
		SZX->ZX_TXPER 	:= SZS->ZS_TXPER
		SZX->ZX_30DD 	:= SZS->ZS_30DD
		SZX->ZX_PERCDI 	:= SZS->ZS_PERCDI
		SZX->ZX_CDIDIA 	:= SZS->ZS_CDIDIA
		SZX->ZX_DIAS 	:= SZS->ZS_DIAS
		SZX->ZX_DDECOR 	:= IIF(SZS->ZS_DDECOR>0, SZS->ZS_DDECOR, 0)
		SZX->ZX_DU 		:= SZS->ZS_DU
		SZX->ZX_REND 	:= IIF(SZS->ZS_REND>0, SZS->ZS_REND, 0)
		SZX->ZX_VLATU 	:= SZS->ZS_VLATU
		SZX->ZX_AJUSTE 	:= SZS->ZS_AJUSTE
		SZX->ZX_COTAC 	:= SZS->ZS_COTAC
		SZX->ZX_PERBRAM	:= SZS->ZS_PERBRAM
		SZX->ZX_BRADIA 	:= SZS->ZS_BRADIA
		MsUnLock()
	Else
		RecLock("SZX",.T.)
		SZX->ZX_FILIAL	:= xFilial("SZX")
		SZX->ZX_DTFECH	:= mv_par01
		SZX->ZX_MESANO	:= STR(YEAR(mv_par01),4)+ STRZERO(MONTH(mv_par01),2)		
		SZX->ZX_TPAPL 	:= SZS->ZS_TPAPL
		SZX->ZX_ITEM 	:= SZS->ZS_ITEM
		SZX->ZX_COD 	:= SZS->ZS_COD
		SZX->ZX_NOMBCO 	:= SZS->ZS_NOMBCO
		SZX->ZX_CONTA 	:= SZS->ZS_CONTA
		SZX->ZX_DTAPL 	:= SZS->ZS_DTAPL
		SZX->ZX_RESGAT 	:= SZS->ZS_RESGAT
		SZX->ZX_VLAPL 	:= SZS->ZS_VLAPL
		SZX->ZX_VLNOM 	:= SZS->ZS_VLNOM
		SZX->ZX_252 	:= SZS->ZS_252
		SZX->ZX_360 	:= SZS->ZS_360
		SZX->ZX_TXPER 	:= SZS->ZS_TXPER
		SZX->ZX_30DD 	:= SZS->ZS_30DD
		SZX->ZX_PERCDI 	:= SZS->ZS_PERCDI
		SZX->ZX_CDIDIA 	:= SZS->ZS_CDIDIA
		SZX->ZX_DIAS 	:= SZS->ZS_DIAS
		SZX->ZX_DDECOR 	:= SZS->ZS_DDECOR
		SZX->ZX_DU 		:= SZS->ZS_DU
		SZX->ZX_REND 	:= SZS->ZS_REND
		SZX->ZX_VLATU 	:= SZS->ZS_VLATU
		SZX->ZX_AJUSTE 	:= SZS->ZS_AJUSTE
		SZX->ZX_COTAC 	:= SZS->ZS_COTAC
		SZX->ZX_PERBRAM	:= SZS->ZS_PERBRAM
		SZX->ZX_BRADIA 	:= SZS->ZS_BRADIA
		MsUnLock()
	EndIf
	
	DbSelectArea("SZS") 
	SZS->(DbSkip())
EndDo
/*
DbSelectArea("SZS") 
DbGotop()

Do While !EOF()
	DbSelectArea("SZX")
	DbSetOrder(1)

	_MES		:= Val(SUBSTR(DTOS(MV_PAR01),5,2))
	If _MES == 1
		_MES := 12
	Else
		_MES-= 1
	EndIf

	_nPosMES	:= ascan(_aMeses, {|x| x[1] == _MES })
	If _nPosMES > 0
		_nDIA	:= STR(_aMeses[_nPosMES,3],2)
	EndIf
	
	_nANO_MES	:= Str(Val(SUBSTR(DTOS(MV_PAR01),1,6))-1,6)

	If _MES == 2 //Fevereiro
		If DbSeek(xFilial("SZX")+_nANO_MES+"29"+SZS->ZS_NOMBCO+SZS->ZS_CONTA+STR(SZS->ZS_VLAPL,14,2))
			_nRend	:= SZS->ZS_VLATU - SZX->ZX_VLATU
		ElseIf DbSeek(xFilial("SZX")+_nANO_MES+_nDIA+SZS->ZS_NOMBCO+SZS->ZS_CONTA+STR(SZS->ZS_VLAPL,14,2))
			_nRend	:= SZS->ZS_VLATU - SZX->ZX_VLATU
		Else
			_nRend	:= SZS->ZS_REND
		EndIf	
	Else
		If DbSeek(xFilial("SZX")+_nANO_MES+_nDIA+SZS->ZS_NOMBCO+SZS->ZS_CONTA+STR(SZS->ZS_VLAPL,14,2))
			_nRend	:= SZS->ZS_VLATU - SZX->ZX_VLATU
		Else
			_nRend	:= SZS->ZS_REND
		EndIf
	EndIf

	If _nRend > 0
		_nPos := ascan(_aValTot, {|x| x[2] == SZS->ZS_CONTA })
		If _nPos > 0
			_aValTot[_nPos,3]+=_nRend
		Else
			Aadd(_aValTot,{SZS->ZS_NOMBCO,SZS->ZS_CONTA,_nRend,mv_par01})
		EndIf
	EndIf

	DbSelectArea("SZS") 
	SZS->(DbSkip())
EndDo
*/

_cQuery	:= "SELECT MAX(ZX_DTFECH) ULT_DATA " //Ultima data do fechamento no mes
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery	+= "WHERE D_E_L_E_T_ = '' "
_cQuery	+= "AND ZX_DTFECH LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "
TCQUERY _cQuery ALIAS "TMPDTATU" NEW

DbSelectArea("TMPDTATU")
If !EOF()
	_xDtUlt := TMPDTATU->ULT_DATA
Else
	_xDtUlt := ""
EndIf

DbSelectArea("TMPDTATU")
TMPDTATU->(DbCloseArea())

_cQuery	:= "SELECT ZX_TPAPL, ZX_NOMBCO, ZX_CONTA, SUM(ZX_VLATU) AS VALOR "
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery += "WHERE D_E_L_E_T_ = '' "
_cQuery += "AND ZX_DTFECH = '"+_xDtUlt+"' "
_cQuery += "AND ZX_VLATU > 0 "
_cQuery += "GROUP BY ZX_TPAPL, ZX_NOMBCO, ZX_CONTA "
_cQuery += "ORDER BY ZX_TPAPL, ZX_NOMBCO "
TCQUERY _cQuery ALIAS "TMPATU" NEW

//_cQuery += "AND ZX_DTFECH LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "

DbSelectArea("TMPATU")
Do While !EOF()

	If Alltrim(TMPATU->ZX_TPAPL) $ "POS|BRA"
		_nPos := ascan(_aValTot, {|x| x[4] == "ESP" }) // CDI/BRA
		If _nPos > 0
			_aValTot[_nPos,3] += TMPATU->VALOR	
		Else
			Aadd(_aValTot,{TMPATU->ZX_NOMBCO,TMPATU->ZX_CONTA,TMPATU->VALOR,"ESP"})
		EndIf
	Else
//		Aadd(_aValTot,{TMPATU->ZX_NOMBCO,TMPATU->ZX_CONTA,TMPATU->VALOR,TMPATU->ZX_TPAPL}) //Por Banco (individual)
		_nPos := ascan(_aValTot, {|x| x[4] == "PRE" }) // PRE
		If _nPos > 0
			_aValTot[_nPos,3] += TMPATU->VALOR	
		Else
			Aadd(_aValTot,{TMPATU->ZX_NOMBCO,TMPATU->ZX_CONTA,TMPATU->VALOR,"PRE"})
		EndIf
	EndIf

	_nPos0 := ascan(_aValSE5, {|x| x[2] == TMPATU->ZX_CONTA })
	If _nPos0 > 0
		_aValSE5[_nPos0,3] += TMPATU->VALOR	
	Else
		Aadd(_aValSE5,{TMPATU->ZX_NOMBCO,TMPATU->ZX_CONTA,TMPATU->VALOR,TMPATU->ZX_TPAPL})
	EndIf

	DbSelectArea("TMPATU")
	DbSkip()
EndDo

DbSelectArea("TMPATU")
TMPATU->(DbCloseArea())

_xMes := Val(Substr(Dtos(mv_par01),5,2))
If _xMes == 01
	_xAnoMes := Str(Val(Substr(Dtos(mv_par01),1,4))-1,4)+"12"
Else
	_xAnoMes := Str(Val(Substr(Dtos(mv_par01),1,6))-1,6)
EndIf

_cQuery	:= "SELECT MAX(ZX_DTFECH) ANT_DATA " //Ultima data do fechamento do mes anterior
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery	+= "WHERE D_E_L_E_T_ = '' 
_cQuery	+= "AND ZX_DTFECH LIKE '"+_xAnoMes+"%' "
TCQUERY _cQuery ALIAS "TMPDTANT" NEW

DbSelectArea("TMPDTANT")
If !EOF()
	_xDtAnt := TMPDTANT->ANT_DATA
Else
	_xDtAnt := ""
EndIf

DbSelectArea("TMPDTANT")
TMPDTANT->(DbCloseArea())

_cQuery	:= "SELECT ZX_TPAPL, ZX_NOMBCO, ZX_CONTA, SUM(ZX_VLATU) AS VALOR "
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery += "WHERE D_E_L_E_T_ = '' "
_cQuery += "AND ZX_DTFECH = '"+_xDtAnt+"' "
_cQuery += "AND ZX_VLATU > 0 "
_cQuery += "GROUP BY ZX_TPAPL, ZX_NOMBCO, ZX_CONTA "
_cQuery += "ORDER BY ZX_TPAPL, ZX_NOMBCO "
TCQUERY _cQuery ALIAS "TMPANT" NEW

//_cQuery += "AND ZX_DTFECH LIKE '"+_xAnoMes+"%' "

DbSelectArea("TMPANT")
Do While !EOF()

	If Alltrim(TMPANT->ZX_TPAPL) $ "POS|BRA"
		_nPos := ascan(_aValTot, {|x| x[4] == "ESP" }) // CDI/BRA
		If _nPos > 0
			_aValTot[_nPos,3] -= TMPANT->VALOR	
		EndIf
	Else
//		_nPos := ascan(_aValTot, {|x| x[2] == TMPANT->ZX_CONTA }) //Por Banco (individual)
		_nPos := ascan(_aValTot, {|x| x[4] == "PRE" }) //PRE
		If _nPos > 0
			_aValTot[_nPos,3] -= TMPANT->VALOR
		EndIf
	EndIf

	_nPos1 := ascan(_aValSE5, {|x| x[2] == TMPANT->ZX_CONTA })
	If _nPos1 > 0
		_aValSE5[_nPos1,3] -= TMPANT->VALOR
	Else
		Aadd(_aValSE5,{TMPANT->ZX_NOMBCO,TMPANT->ZX_CONTA,(TMPANT->VALOR*-1),TMPANT->ZX_TPAPL})
	EndIf

	DbSelectArea("TMPANT")
	DbSkip()
EndDo

DbSelectArea("TMPANT")
TMPANT->(DbCloseArea())

//verifica movimentos de resgate para as contas correntes
_cQuery := "SELECT SUM(E5_VALOR) AS VALAPL , MONTH(E5_DATA) AS MES, E5_RECPAG, E5_CONTA "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND (E5_MOEDA = 'RS' OR E5_MOEDA = 'RF') "
_cQuery += "AND (E5_NATUREZ = '5.01.02' OR E5_NATUREZ = '5.02.02' OR "
_cQuery += "     E5_NATUREZ = '29020101' OR E5_NATUREZ = '29050101' ) "
_cQuery += "AND (E5_TIPODOC <> 'TE' AND E5_TIPODOC <> 'CA')"
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND E5_RECPAG = 'R' "
_cQuery += "AND (SUBSTRING(E5_HISTOR,1,3) = 'POS' OR SUBSTRING(E5_HISTOR,1,3) = 'BRA') "
_cQuery += "AND E5_DATA LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "
_cQuery += "GROUP BY MONTH(E5_DATA), E5_RECPAG, E5_CONTA "
_cQuery += "ORDER BY MONTH(E5_DATA), E5_CONTA "
TCQUERY _cQuery ALIAS "TMPAPL" NEW

DbSelectArea("TMPAPL")
Do While !EOF()

	_nPos := ascan(_aValTot, {|x| x[4] == "ESP" })
	If _nPos > 0
		_aValTot[_nPos,3] += TMPAPL->VALAPL
	EndIf
	
	DbSelectArea("TMPAPL")
	DbSkip()
EndDo

DbSelectArea("TMPAPL")
TMPAPL->(DbCloseArea())

//verifica movimentos de aplicacao para as contas de aplicacao
_cQuery := "SELECT SUM(E5_VALOR) AS VALAPL , MONTH(E5_DATA) AS MES, E5_RECPAG, E5_CONTA "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND (E5_MOEDA = 'RS' OR E5_MOEDA = 'RF') "
_cQuery += "AND (E5_NATUREZ = '5.01.01' OR E5_NATUREZ = '5.02.01' OR E5_NATUREZ = '6.09.03' OR "
_cQuery += "     E5_NATUREZ = '29010101' OR E5_NATUREZ = '29040101' OR E5_NATUREZ = '33090103') "
_cQuery += "AND (E5_TIPODOC <> 'TE' AND E5_TIPODOC <> 'CA')"
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND E5_RECPAG = 'P' "
_cQuery += "AND (SUBSTRING(E5_HISTOR,1,3) = 'POS' OR SUBSTRING(E5_HISTOR,1,3) = 'BRA') "
_cQuery += "AND E5_DATA LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "
_cQuery += "GROUP BY MONTH(E5_DATA), E5_RECPAG, E5_CONTA "
_cQuery += "ORDER BY MONTH(E5_DATA), E5_CONTA "
TCQUERY _cQuery ALIAS "TMPAPL" NEW

DbSelectArea("TMPAPL")
Do While !EOF()

	_nPos := ascan(_aValTot, {|x| x[4] == "ESP" })
	If _nPos > 0
		_aValTot[_nPos,3] -= TMPAPL->VALAPL
	EndIf
	
	DbSelectArea("TMPAPL")
	DbSkip()
EndDo

DbSelectArea("TMPAPL")
TMPAPL->(DbCloseArea())

//verifica movimentos de resgate 
_cQuery := "SELECT SUM(E5_VALOR) AS VALAPL , MONTH(E5_DATA) AS MES, E5_RECPAG, E5_CONTA "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND (E5_MOEDA = 'RS' OR E5_MOEDA = 'RF') "
_cQuery += "AND (E5_NATUREZ = '5.01.02' OR E5_NATUREZ = '5.02.02') "     
_cQuery += "AND (E5_NATUREZ = '29020101' OR E5_NATUREZ = '29050101' OR "
_cQuery += "     E5_TIPODOC <> 'TE' AND E5_TIPODOC <> 'CA')"
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND E5_RECPAG = 'R' "
_cQuery += "AND SUBSTRING(E5_HISTOR,1,3) = 'PRE' "
_cQuery += "AND E5_DATA LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "
_cQuery += "GROUP BY MONTH(E5_DATA), E5_RECPAG, E5_CONTA "
_cQuery += "ORDER BY MONTH(E5_DATA), E5_CONTA "
TCQUERY _cQuery ALIAS "TMPAPL" NEW

DbSelectArea("TMPAPL")
Do While !EOF()

//	_nPos := ascan(_aValTot, {|x| x[2] == TMPAPL->E5_CONTA }) //Por Banco (individual)
	_nPos := ascan(_aValTot, {|x| x[4] == "PRE" })
	If _nPos > 0
		_aValTot[_nPos,3] += TMPAPL->VALAPL
	EndIf

	DbSelectArea("TMPAPL")
	DbSkip()
EndDo

DbSelectArea("TMPAPL")
TMPAPL->(DbCloseArea())

//verifica movimentos de aplicacao
_cQuery := "SELECT SUM(E5_VALOR) AS VALAPL , MONTH(E5_DATA) AS MES, E5_RECPAG, E5_CONTA "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND (E5_MOEDA = 'RS' OR E5_MOEDA = 'RF') "
_cQuery += "AND (E5_NATUREZ = '5.01.01' OR E5_NATUREZ = '5.02.01' OR E5_NATUREZ = '6.09.03' OR "
_cQuery += "     E5_NATUREZ = '29010101' OR E5_NATUREZ = '29040101' OR E5_NATUREZ = '33090103') "
_cQuery += "AND (E5_TIPODOC <> 'TE' AND E5_TIPODOC <> 'CA')"
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND E5_RECPAG = 'P' "
_cQuery += "AND SUBSTRING(E5_HISTOR,1,3) = 'PRE' "
_cQuery += "AND E5_DATA LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "
_cQuery += "GROUP BY MONTH(E5_DATA), E5_RECPAG, E5_CONTA "
_cQuery += "ORDER BY MONTH(E5_DATA), E5_CONTA "
TCQUERY _cQuery ALIAS "TMPAPL" NEW

DbSelectArea("TMPAPL")
Do While !EOF()

//	_nPos := ascan(_aValTot, {|x| x[2] == TMPAPL->E5_CONTA }) //Por Banco (individual)
	_nPos := ascan(_aValTot, {|x| x[4] == "PRE" })
	If _nPos > 0
		_aValTot[_nPos,3] -= TMPAPL->VALAPL
	EndIf

	DbSelectArea("TMPAPL")
	DbSkip()
EndDo

DbSelectArea("TMPAPL")
TMPAPL->(DbCloseArea())

//verifica movimento resgate
_cQuery := "SELECT SUM(E5_VALOR) AS VALAPL , MONTH(E5_DATA) AS MES, E5_RECPAG, E5_CONTA "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND (E5_MOEDA = 'RS' OR E5_MOEDA = 'RF') "
_cQuery += "AND (E5_NATUREZ = '5.01.02' OR E5_NATUREZ = '5.02.02' OR "
_cQuery += "     E5_NATUREZ = '29020101' OR E5_NATUREZ = '29050101' ) "
_cQuery += "AND (E5_TIPODOC <> 'TE' AND E5_TIPODOC <> 'CA')"
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND E5_RECPAG = 'R' "
_cQuery += "AND E5_DATA LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "
_cQuery += "GROUP BY MONTH(E5_DATA), E5_RECPAG, E5_CONTA "
_cQuery += "ORDER BY MONTH(E5_DATA), E5_CONTA "
TCQUERY _cQuery ALIAS "TMPAPL" NEW

DbSelectArea("TMPAPL")
Do While !EOF()

	_nPos := ascan(_aValSE5, {|x| x[2] == TMPAPL->E5_CONTA })
	If _nPos > 0
		_aValSE5[_nPos,3] += TMPAPL->VALAPL
	EndIf

	DbSelectArea("TMPAPL")
	DbSkip()
EndDo

DbSelectArea("TMPAPL")
TMPAPL->(DbCloseArea())

//verifica movimento aplicacao
_cQuery := "SELECT SUM(E5_VALOR) AS VALAPL , MONTH(E5_DATA) AS MES, E5_RECPAG, E5_CONTA "
_cQuery	+= "FROM " + RetSqlName("SE5")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND (E5_MOEDA = 'RS' OR E5_MOEDA = 'RF') "
_cQuery += "AND (E5_NATUREZ = '5.01.01' OR E5_NATUREZ = '5.02.01' OR E5_NATUREZ = '6.09.03' OR "
_cQuery += "     E5_NATUREZ = '29010101' OR E5_NATUREZ = '29040101' OR E5_NATUREZ = '33090103') "
_cQuery += "AND (E5_TIPODOC <> 'TE' AND E5_TIPODOC <> 'CA')"
_cQuery += "AND E5_SITUACA = '' "
_cQuery += "AND E5_RECPAG = 'P' "
_cQuery += "AND E5_DATA LIKE '"+Str(Val(Substr(Dtos(mv_par01),1,6)),6)+"%' "
_cQuery += "GROUP BY MONTH(E5_DATA), E5_RECPAG, E5_CONTA "
_cQuery += "ORDER BY MONTH(E5_DATA), E5_CONTA "
TCQUERY _cQuery ALIAS "TMPAPL" NEW

DbSelectArea("TMPAPL")
Do While !EOF()

	_nPos := ascan(_aValSE5, {|x| x[2] == TMPAPL->E5_CONTA })
	If _nPos > 0
		_aValSE5[_nPos,3] -= TMPAPL->VALAPL
	EndIf

	DbSelectArea("TMPAPL")
	DbSkip()
EndDo

DbSelectArea("TMPAPL")
TMPAPL->(DbCloseArea())

DbSelectArea("SX6")
DbSetOrder(1)
If DbSeek(xFilial("SX6")+"CI_DTFECH")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD	:= DTOS(mv_par01)
	MsUnLock()
EndIf

//Cria os Movimentos Bancarios (SE5)
Processa( {|| GeraSE5(_aValSE5) }, "Gravando Movimento Bancario..." )

//Cria os Lancamentos Contabeis (CT2)
Processa( {|| _fContabil(_aValTot) }, "Gravando Lancamentos Contabeis..." )

MsgBox("Finalizado Processo de Fechamento", "Aviso", "ALERT")

Do Case
	Case oFolder030:nOption == 1
		aHeader	:= aSvHeader[1]
		aCols	:= aSvCols[1]
//		oLbx1:oBrowse:SetFocus()
	Case oFolder030:nOption == 2
		aHeader	:= aSvHeader[2]
		aCols	:= aSvCols[2]
//		oLbx2:oBrowse:SetFocus()
	Case oFolder030:nOption == 3
		aHeader	:= aSvHeader[3]
		aCols	:= aSvCols[3]
//		oLbx3:oBrowse:SetFocus()
	Case oFolder030:nOption == 4
		aHeader	:= aSvHeader[4]
		aCols	:= aSvCols[4]
//		oLbx4:oBrowse:SetFocus()
EndCase

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  05/19/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraSE5(_aValSE5)

                               
Local cNatGrv:=''
//Se Encontrar um Movimento com a Data e a Natureza
//Deleta o registro para incluir (logo abaixo) o novo registro atualizado
_cQuery	:= "UPDATE "+ RetSqlName("SE5")+" SET D_E_L_E_T_ = '*' "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND E5_MOEDA = 'RE' "
_cQuery += "AND ( E5_NATUREZ = '26010102' OR E5_NATUREZ = '3.01.02' )"
_cQuery += "AND MONTH(E5_DATA) = "+STRZERO(MONTH(mv_par01),2)+" "
TcSQLExec(_cQuery)
    
If cEmpant=="01"
	cNatGrv:="26010102"
Else       
	cNatGrv:="3.01.02"
EndIf
For _nI := 1 to Len(_aValSE5)

	DbSelectArea("SA6")
	DbSetOrder(5) //FILIAL + NUMERO DA CONTA
	If DbSeek(xFilial("SA6")+_aValSE5[_nI,2])
		_cBanco 	:= SA6->A6_COD
		_cAgencia 	:= SA6->A6_AGENCIA
		_cNumConta	:= SA6->A6_NUMCON
	Else
		_cBanco 	:= ""
		_cAgencia 	:= ""
		_cNumConta	:= ""
	EndIf

	RecLock("SE5", .T.)
	SE5->E5_FILIAL  := xFilial("SE5")
	SE5->E5_DATA    := mv_par01
	SE5->E5_MOEDA   := "RE" //Cadastro de Moeda (Tabela - 06) RE=RENDIMENTO
	SE5->E5_VALOR   := _aValSE5[_nI,3]
	SE5->E5_NATUREZ := cNatGrv
	SE5->E5_BANCO   := _cBanco
	SE5->E5_AGENCIA := _cAgencia
	SE5->E5_CONTA   := _cNumConta
	SE5->E5_DOCUMEN := "REND "+Strzero(MONTH(mv_par01),2)+Str(YEAR(mv_par01),4)
	SE5->E5_VENCTO  := mv_par01
	SE5->E5_RECPAG  := "R"
	SE5->E5_LA      := "S"
	SE5->E5_DTDIGIT := mv_par01
	SE5->E5_TIPOLAN := "X"
	SE5->E5_ITEMD   := "49112"
	SE5->E5_DEBITO  := "401090010002"
	SE5->E5_CCD     := "00026"
	SE5->E5_RATEIO  := "N"
	SE5->E5_RECONC  := "x"  // Jแ reconciliado
	SE5->E5_DTDISPO := mv_par01
	SE5->E5_FILORIG := "01"
	SE5->E5_MODSPB  := "1"
	SE5->E5_CODORCA := "PADRAOPR"
	SE5->(msUnLock())

Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  05/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fContabil(_aValTot)

aCab		:= {}
aItem		:= {}
aTotItem	:=	{}
lMsErroAuto := .f.

//Se Encontrar um Movimento do Lote 009400 (Rendimentos)
//Deleta o registro para incluir (logo abaixo) o novo registro atualizado
_cQuery	:= "UPDATE "+ RetSqlName("CT2")+" SET D_E_L_E_T_ = '*' "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND CT2_LOTE = '009400' "
_cQuery += "AND MONTH(CT2_DATA) = "+STRZERO(MONTH(mv_par01),2)+" "
_cQuery += "AND CT2_ORIGEM = 'RENDIM' "
TcSQLExec(_cQuery)


aCab := {	{"dDataLanc", mv_par01	,NIL},;
			{"cLote"	, "009400"	,NIL},;
			{"cSubLote"	, "001"		,NIL}}

For _nI := 1 to Len(_aValTot)

	DbSelectArea("SA6")
	DbSetOrder(5) //FILIAL + NUMERO DA CONTA
	If DbSeek(xFilial("SA6")+_aValTot[_nI,2])
		_cCtaRed	:= SA6->A6_CONTABI		//Item Contabil (Conta Reduzida)
		_cConta 	:= SA6->A6_CONTA		//Conta Contabil (completa)
	Else
		_cCtaRed	:= ""
		_cConta 	:= ""
	EndIf

	_cTp := ""
	Do Case
		Case _aValTot[_nI,4] == "ESP"
			_cTp := "POS/BRAM"
		Case _aValTot[_nI,4] == "PRE"
			_cTp := "PRE"
	EndCase

//					{"CT2_ITEMD"	, IIF(_aValTot[_nI,4]=="ESP","122111", _cCtaRed)	, NIL},;
	AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")									, NIL},;
					{"CT2_LINHA"	, StrZero(_nI,3)									, NIL},;
					{"CT2_DC"		, "3"	 											, NIL},;
					{"CT2_ITEMD"	, "1221111"											, NIL},;
					{"CT2_ITEMC"	, "49112"											, NIL},;
					{"CT2_CCD"		, ""												, NIL},;
					{"CT2_CCC"		, "00026"											, NIL},;
					{"CT2_VALOR"	, Round(_aValTot[_nI,3],2)							, NIL},;
					{"CT2_HP"		, ""												, NIL},;
					{"CT2_HIST"		, "RENDIMENTO RESERVA FINANCEIRA "+_cTp				, NIL},;
					{"CT2_TPSALD"	, "9"												, NIL},;
					{"CT2_ORIGEM"	, "RENDIM"											, NIL},;
					{"CT2_MOEDLC"	, "01"												, NIL},;
					{"CT2_EMPORI"	, ""												, NIL},;
					{"CT2_ROTINA"	, ""												, NIL},;
					{"CT2_LP"		, ""												, NIL},;
					{"CT2_KEY"		, ""												, NIL}})
Next

aadd(aTotItem,aItem)
MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
aTotItem	:=	{}

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
	Return .F.
Endif

aCab	:= {}
aItem	:= {}

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  05/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fPesqLanc()

_lRet	:= .T.

_cQuery	:= "SELECT COUNT(CT2_LOTE) AS NUMREG "
_cQuery	+= "FROM " + RetSqlName("CT2")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND CT2_LOTE = '009400' "
_cQuery += "AND MONTH(CT2_DATA) = "+STRZERO(MONTH(mv_par01),2)+" "
_cQuery += "AND YEAR(CT2_DATA) = "+STRZERO(YEAR(mv_par01),4)+" "
_cQuery += "AND CT2_TPSALD = '1' "
_cQuery += "AND CT2_ORIGEM = 'RENDIM' "
_cQuery += "GROUP BY CT2_LOTE "
_cQuery += "ORDER BY CT2_LOTE"
TCQUERY _cQuery ALIAS "TMPREG" NEW

DbSelectArea("TMPREG")
If TMPREG->NUMREG > 0
	_cMsg := "Existem lan็ใmentos Efetivados no perํodo !!!"
	MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
	_lRet := .F.
EndIf

DbSelectArea("TMPREG")
TMPREG->(DbCloseArea())

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA41   บAutor  ณMicrosiga           บ Data ณ  06/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fFechaTela(oTela)

Do Case
	Case oFolder030:nOption == 1
		aHeader	:= aSvHeader[1]
		aCols	:= aSvCols[1]
		oTela:End()
//		oLbx1:oBrowse:SetFocus()
	Case oFolder030:nOption == 2
		aHeader	:= aSvHeader[2]
		aCols	:= aSvCols[2]
		oTela:End()
//		oLbx2:oBrowse:SetFocus()
	Case oFolder030:nOption == 3
		aHeader	:= aSvHeader[3]
		aCols	:= aSvCols[3]
		oTela:End()
//		oLbx3:oBrowse:SetFocus()
	Case oFolder030:nOption == 4
		aHeader	:= aSvHeader[4]
		oTela:End()
		oLbx4:oBrowse:SetFocus()
//		aCols	:= aSvCols[4]
EndCase

Return

Static Function CFINASAI(oDlg)

_fAtualiza()
oDlg:End()

Return()