#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE08  บAutor  ณMicrosiga           บ Data ณ  11/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Fechamento/ Contabilizacao do processo de        บฑฑ
ฑฑบ          ณ Aplicacao Financeira                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINE08

Private oLeTxt
Private _aArea
Private _dDtIni	:= FirstDay(GetMv("FI_XFECHAP")+1)
Private _dDtFim	:= LastDay(GetMv("FI_XFECHAP")+1)

Private nValorSZI
Private nVlIRFSZI

dbSelectArea("SZH")
dbSetOrder(1)

_aArea	:= GetArea()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Fechamento Mensal - Contabilizacao")
@ 02,10 TO 060,190
@ 10,018 Say " Este programa tem como objetivo efetuar o fechamento mensal "
@ 18,018 Say " do processo de Aplicacao Finaneira e Contabilizar os movimentos"
@ 26,018 Say " Para o fechamento devemos estar com a Database igual ao ultimo "
@ 34,018 Say " dia do mes subsequente "
@ 42,018 Say " Ultimo Fechamento : " + dtoc(GetMv("FI_XFECHAP"))

@ 70,128 BMPBUTTON TYPE 01 ACTION (RunFech(),Close(oLeTxt))
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE08  บAutor  ณMicrosiga           บ Data ณ  11/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunFech

If LastDay((GetMv("FI_XFECHAP")+1)) <> dDataBase
	Aviso("Fechamento Mensal", "A Database igual ao ultimo dia do mes subsequente", {"Sair"} )
	Return()
EndIf

BEGIN TRANSACTION

//Fecha o Calendario de Indices. 
_cQuery	:= "UPDATE "+ RetSqlName("SZJ")+" SET ZJ_STATUS = 'C' "
_cQuery += "WHERE ZJ_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' " 
TcSQLExec(_cQuery)

//Lancamento Contabil
_aAreaSZH	:= SZH->(GetArea())
DbSelectArea("SZH")
DbSetOrder(1)
DbGotop()
Do While !EOF()
	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR, SUM(ZI_VALIRF) AS ZI_VALIRF "
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS = '1' "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)
	
	nValorSZI	:= SZITRB->ZI_VALOR  //Soma de todos os Rendimentos
	nVlIRFSZI	:= SZITRB->ZI_VALIRF //Soma de todos os IRRF
	
	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR"
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS IN ('2') "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)
	
	nVlrProvDeb	:= SZITRB->ZI_VALOR  //Soma de todos Provisao de IR

	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR"
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS IN ('3') "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)
	
	nVlrProvCre	:= SZITRB->ZI_VALOR  //Soma de todos Estorno Provisao de IR

	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR"
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS IN ('4') "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)
	
	nVlrAceDeb	:= SZITRB->ZI_VALOR  //Soma de todos Acertos Debito

	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR"
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS IN ('6') "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)
	
	nVlrResg	:= SZITRB->ZI_VALOR  //Soma de todos Resgates

	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR"
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS IN ('5') "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)

	nVlrAceCrd	:= SZITRB->ZI_VALOR  //Soma de todos Acertos Credito

	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR"
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS IN ('7') "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)

	nVlrApor	:= SZITRB->ZI_VALOR  //Soma de todos Novo Aporte

	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	_cQuery	:= "SELECT SUM(ZI_VALOR) AS ZI_VALOR"
	_cQuery	+= "FROM "+RetSqlName("SZI")+ " "
	_cQuery	+= "WHERE D_E_L_E_T_ = ' ' "
	_cQuery	+= "AND ZI_NUMERO = '"+SZH->ZH_NUMERO+"'"
	_cQuery	+= "AND ZI_STATUS IN ('8') "
	_cQuery	+= "AND ZI_DATA BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZITRB',.T.,.T.)

	nVlrPgtIR	:= SZITRB->ZI_VALOR  //Soma de todos Pgto de IRRF

	DbSelectArea("SZITRB")
	SZITRB->(DbCloseArea())

	RecLock("SZH",.F.)
//	SZH->ZH_SLDANT := SZH->ZH_SALDO
//	SZH->ZH_SALDO  := ((SZH->ZH_SALDO + nValorSZI) - (nVlrAceDeb+nVlrResg) )+ (nVlrAceCrd+nVlrApor)
//	SZH->ZH_SLDATU := SZH->ZH_SALDO

	SZH->ZH_SLDANT := ZH_SLDATU

	MsUnLock()

	DbSelectArea("SA6")
	DbSetOrder(1)
	If !(DbSeek(xFilial("SA6")+SZH->(ZH_BANCO+ZH_AGENCI+ZH_CONTA))) //FILIAL+COD+AGENCIA+NUMCON
		alert("Banco nao Encontrado")
		DisarmTransaction()
		Return
	EndIf
	
	_fGeraCTB()
	
	DbSelectArea("SZH")
	SZH->(DbSkip())
EndDo
RestArea(_aAreaSZH)

//Atualiza o Paramentro com a Data do Fechamento realizado
_aAreaSX6 := SX6->(GetArea())

DbSelectArea("SX6")
DbSetOrder(1)
If DbSeek(xfilial("SX6")+"FI_XFECHAP")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := DTOC(dDataBase)
	SX6->X6_CONTSPA := DTOC(dDataBase)
	SX6->X6_CONTENG := DTOC(dDataBase)
	MsUnLock()
EndIf
RestArea(_aAreaSX6)

END TRANSACTION

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE08  บAutor  ณMicrosiga           บ Data ณ  11/21/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fGeraCTB()

cPadrao	:= "400"
aCab		:= {}
aItem		:= {}
aTotItem	:= {}
lMsErroAuto := .f.
_nLin		:= 1

aCab := {	{"dDataLanc", dDataBase	,NIL},;
			{"cLote"	, "009800"	,NIL},;
			{"cSubLote"	, "001"		,NIL}}


lPadrao	:= VerPadrao(cPadrao)

Do While !EOF() .and. CT5->CT5_LANPAD == cPadrao 

	_cDC		:= IIF(Empty(CT5->CT5_DC)		,"",&(CT5->CT5_DC)		)
	_cDebito	:= IIF(Empty(CT5->CT5_DEBITO)	,"",&(CT5->CT5_DEBITO)	)
	_cCredito	:= IIF(Empty(CT5->CT5_CREDIT)	,"",&(CT5->CT5_CREDIT)	)
	_cCCDebit	:= IIF(Empty(CT5->CT5_CCD)		,"",&(CT5->CT5_CCD)		)
	_cCCCredi	:= IIF(Empty(CT5->CT5_CCC)		,"",&(CT5->CT5_CCC)		)
	_cITDebit	:= IIF(Empty(CT5->CT5_ITEMD)	,"",&(CT5->CT5_ITEMD)	)
	_cITCredi	:= IIF(Empty(CT5->CT5_ITEMC)	,"",&(CT5->CT5_ITEMC)	)
	_cCLDebit	:= IIF(Empty(CT5->CT5_CLVLDB)	,"",&(CT5->CT5_CLVLDB)	)
	_cCLCredi	:= IIF(Empty(CT5->CT5_CLVLCR)	,"",&(CT5->CT5_CLVLCR)	)
	_nValor		:= IIF(Empty(CT5->CT5_VLR01)	,"",&(CT5->CT5_VLR01)	)
	_cHist 		:= IIF(Empty(CT5->CT5_HIST)		,"",&(CT5->CT5_HIST)	)
	_cOrigem	:= IIF(Empty(CT5->CT5_ORIGEM)	,"",&(CT5->CT5_ORIGEM)	)
	_cTPsld		:= IIF(Empty(CT5->CT5_TPSALD)	,"",&(CT5->CT5_TPSALD)	)

	If _nValor > 0 
		AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")		, NIL},;
						{"CT2_LINHA"	, StrZero(_nLin,3)		, NIL},;
						{"CT2_DC"		, _cDC	 				, NIL},;	//Partida Dobrada
						{"CT2_DEBITO"	, _cDebito				, NIL},;	//DEBITO  Conta Contabil
						{"CT2_CREDIT"	, _cCredito				, NIL},;	//CREDITO Conta Contabil
						{"CT2_ITEMD"	, _cITDebit				, NIL},;	//DEBITO  Item Contabil
						{"CT2_CCD"		, _cCCDebit				, NIL},;	//DEBITO  Centro de Custo
						{"CT2_ITEMC"	, _cITCredi				, NIL},;	//CREDITO Item Contabil
						{"CT2_CCC"		, _cCCCredi				, NIL},;	//CREDITO Centro de Custo
						{"CT2_VALOR"	, _nValor				, NIL},;
						{"CT2_HP"		, ""					, NIL},;
						{"CT2_HIST"		, _cHist				, NIL},;
						{"CT2_TPSALD"	, _cTPsld				, NIL},;
						{"CT2_ORIGEM"	, _cOrigem				, NIL},;
						{"CT2_MOEDLC"	, "01"					, NIL},;
						{"CT2_EMPORI"	, ""					, NIL},;
						{"CT2_ROTINA"	, ""					, NIL},;
						{"CT2_LP"		, cPadrao				, NIL},;
						{"CT2_KEY"		, ""					, NIL}})
	EndIf
	_nLin++

	CT5->(DbSkip())
EndDo

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

//*************************************************
//FIM Contabiliza
//*************************************************
Return