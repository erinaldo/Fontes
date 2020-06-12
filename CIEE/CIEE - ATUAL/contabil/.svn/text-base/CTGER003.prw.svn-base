#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTGER003  ºAutor  ³Claudio Barros      º Data ³  07/18/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetivacao de lotes contabeis (pre para efetivado)         º±±
±±º          ³ chamando ponto de entrada CTB350EF                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTGER003()

Local _cCT6 := "", _cCTC := "", _cChaveCT6 := "", _cChaveCTC := ""
Private cString := "CT2"

Pergunte("CTB350    ",.T.)

DbSelectArea("CT2")
DbSetOrder(1)

cIndex		:= CriaTrab(NIL,.F.)
cChave		:= CT2->(IndexKey())
nOldIndex	:= CT2->(IndexOrd())

//IndRegua("CT2", cIndex, cChave,,"CT2_LOTE>=MV_PAR01 .AND. CT2_LOTE<=MV_PAR02 .AND. CT2_DATA>=MV_PAR03 .AND. CT2_DATA<=MV_PAR04 .AND. CT2_SBLOTE>=MV_PAR09 .AND. CT2_SBLOTE<=MV_PAR10 .AND. CT2_DOC>=MV_PAR13 .AND. CT2_DOC<=MV_PAR14","Selecionando Registros...")
IndRegua("CT2", cIndex, cChave,,"CT2_LOTE>=MV_PAR01 .AND. CT2_LOTE<=MV_PAR02 .AND. CT2_DATA>=MV_PAR03 .AND. CT2_DATA<=MV_PAR04 .AND. CT2_SBLOTE>=MV_PAR09 .AND. CT2_SBLOTE<=MV_PAR10 .AND. CT2_DOC>=MV_PAR13 .AND. CT2_DOC<=MV_PAR14 .AND. CT2_TPSALD=='9'","Selecionando Registros...")
nIndex := RetIndex("CT2")

_aTST := {}
aAdd(_aTST,{"LOTE"  ,"C", 06,0})
aAdd(_aTST,{"DOC"   ,"C", 06,0})
aAdd(_aTST,{"REG"   ,"C", 06,0})
cArq 		:= CriaTrab(_aTST,.T.)
dbUseArea(.T.,,cArq,"TST",.T.)
_cIndTST  	:= CriaTrab(NIL,.F.)
_cChave   	:= "REG+LOTE+DOC"
IndRegua("TST",_cIndTST,_cChave,,,"Indice Temporario...")

If CT2->(Eof())				// Não há registros a serem processados
	MsgAlert("Não há registros a serem processados!","Atenção!")
	DbSelectArea("TST")
	DbCloseArea()
	fErase(cArq+".DBF")
	fErase(cIndex+OrdBagExt())
	Return
EndIf

/****************************************************************************************
** Executa rotina de Reprocessamento antes de Efetivar                                 **
** Function CTBA190(lDireto,dDataIni,dDataFim,cFilDe,cFilAte,cTpSald,lMoedaEsp,cMoeda) **
*****************************************************************************************/
//CTBA190(.T.,MV_PAR03,MV_PAR04,"  ","zz","9",.F.,"01")

DbSelectArea("CT2")
_cReg := CT2->(Recno())
Do While CT2->(!EOF())
	_cChaveCT6 := CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_MOEDLC+CT2_TPSALD)
	_cChaveCTC := CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC+CT2_TPSALD)
	If _cCT6 <> _cChaveCT6
		VerCT6(_cChaveCT6)
		_cCT6 := _cChaveCT6
	EndIf
	If _cCTC <> _cChaveCTC
		VerCTC(_cChaveCTC)
		_cCTC := _cChaveCTC
	EndIf
	DbSelectArea("TST")
	RecLock("TST",.T.)
	TST->LOTE := CT2->CT2_LOTE
	TST->DOC  := CT2->CT2_DOC
	TST->REG  := alltrim(strzero(CT2->(Recno()),6))
	MsUnLock()
	DbSelectArea("CT2")
	DbSkip()
EndDo

DbSelectArea("CT2")
DbGoto(_cReg)

CTBA350()

DbSelectArea("TST")
DbCloseArea()
fErase(cArq+".DBF")
fErase(cIndex+OrdBagExt())

Return        


// Função para verificar e ajustar saldo da CT6 antes da efetivação
Static Function VerCT6(_ChCT6)

Local cQuery := ""
Local _nDebCT2:=0, _nCreCT2:=0, _nDigCT2:=0
Local _nI:=0, _nRetQry:=0, _lCT2:=.F.
Local _cFilial:="", _dData:=CtoD(""), _cLote:="", _cSBLote:="", _cMoeda:=""

_ChCT6 := Left(_ChCT6, Len(_ChCT6)-1) + "1"
cQuery := "SELECT CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_MOEDLC, CT2_TPSALD, "
cQuery +=        "SUM(CASE WHEN CT2_DC='1' THEN CT2_VALOR "
cQuery +=                 "WHEN CT2_DC='3' THEN CT2_VALOR "
cQuery +=                 "ELSE 0 END) DEBITO, "
cQuery +=        "SUM(CASE WHEN CT2_DC='2' THEN CT2_VALOR "
cQuery +=                 "WHEN CT2_DC='3' THEN CT2_VALOR "
cQuery +=                 "ELSE 0 END) CREDITO, "
cQuery +=        "SUM(CT2_VALOR) DIGITADO "
cQuery +=   "FROM "+RetSqlName("CT2")+" CT2 "
cQuery +=  "WHERE D_E_L_E_T_='' "
cQuery +=    "AND CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_MOEDLC+CT2_TPSALD = '" + _ChCT6 + "' "
cQuery +=    "AND CT2_DC <= '3' "
cQuery +="GROUP BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_MOEDLC, CT2_TPSALD "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRAB', .F., .T.)
dbSelectArea("TRAB")
TRAB->(dbGoTop())
If TRAB->(!Eof().And.!Bof())
	_cFilial := TRAB->CT2_FILIAL
	_dData   := StoD(TRAB->CT2_DATA)
	_cLote   := TRAB->CT2_LOTE
	_cSBLote := TRAB->CT2_SBLOTE
	_cMoeda  := TRAB->CT2_MOEDLC
	_nDebCT2 := TRAB->DEBITO
	_nCreCT2 := TRAB->CREDITO
	_nDigCT2 := TRAB->DIGITADO       
	_lCT2	 := .T.
EndIf
TRAB->(dbCloseArea())

cQuery := "SELECT CT6_FILIAL, CT6_DATA, CT6_LOTE, CT6_SBLOTE, CT6_MOEDA, CT6_TPSALD, "
cQuery +=        "CT6_DEBITO DEBITO, CT6_CREDIT CREDITO, R_E_C_N_O_ CT6REC "
cQuery +=   "FROM "+RetSqlName("CT6") +" CT6 "
cQuery +=  "WHERE D_E_L_E_T_='' "
cQuery +=    "AND CT6_FILIAL+CT6_DATA+CT6_LOTE+CT6_SBLOTE+CT6_MOEDA+CT6_TPSALD = '" + _ChCT6 + "' "
cQuery +=    "AND CT6_STATUS='1' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRAB', .F., .T.)
If TRAB->(!Eof().And.!Bof())
	If _lCT2
		If TRAB->DEBITO <> _nDebCT2 .Or. TRAB->CREDITO <> _nCreCT2
			cQuery := "UPDATE "+RetSqlName("CT6")+" "
			cQuery += "SET CT6_DEBITO="+AllTrim(Str(_nDebCT2))+", CT6_CREDIT="+AllTrim(Str(_nCreCT2))+", CT6_DIG="+AllTrim(Str(_nDigCT2))+" "
			cQuery += "WHERE R_E_C_N_O_="+AllTrim(Str(TRAB->CT6REC))+" "
			_nRetQry = TcSqlExec(cQuery)
		EndIf
	Else
		cQuery := "DELETE FROM "+RetSqlName("CT6")+" "
		cQuery += "WHERE R_E_C_N_O_="+AllTrim(Str(TRAB->CT6REC))+" "
		_nRetQry = TcSqlExec(cQuery)
	EndIf
Else
	If _lCT2
		dbSelectArea("CT6")
		RecLock("CT6",.T.)
		CT6->CT6_FILIAL := _cFilial
		CT6->CT6_DATA	:= _dData
		CT6->CT6_LOTE	:= _cLote
		CT6->CT6_SBLOTE := _cSBLote
		CT6->CT6_MOEDA  := _cMoeda
		CT6->CT6_TPSALD := "1"
		CT6->CT6_STATUS := "1"
		CT6->CT6_DEBITO := _nDebCT2
		CT6->CT6_CREDIT := _nCreCT2
		CT6->CT6_DIG    := _nDigCT2
		CT6->(MsUnLock()) 
	EndIf	
EndIf
TRAB->(dbCloseArea())

Return


// Função para verificar e ajustar saldo da CTC antes da efetivação
Static Function VerCTC(_ChCTC)

Local cQuery := ""
Local _nDebCT2:=0, _nCreCT2:=0, _nDigCT2:=0
Local _nI:=0, _nRetQry:=0, _lCT2:=.F.
Local _cFilial:="", _dData:=CtoD(""), _cLote:="", _cSBLote:="", _cMoeda:="", _cDoc:=""

_ChCTC := Left(_ChCTC, Len(_ChCTC)-1) + "1"
cQuery := "SELECT CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_MOEDLC, CT2_TPSALD, "
cQuery +=        "SUM(CASE WHEN CT2_DC='1' THEN CT2_VALOR "
cQuery +=                 "WHEN CT2_DC='3' THEN CT2_VALOR "
cQuery +=                 "ELSE 0 END) DEBITO, "
cQuery +=        "SUM(CASE WHEN CT2_DC='2' THEN CT2_VALOR "
cQuery +=                 "WHEN CT2_DC='3' THEN CT2_VALOR "
cQuery +=                 "ELSE 0 END) CREDITO, "
cQuery +=        "SUM(CT2_VALOR) DIGITADO "
cQuery +=   "FROM "+RetSqlName("CT2")+" CT2 "
cQuery +=  "WHERE D_E_L_E_T_='' "
cQuery +=    "AND CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC+CT2_TPSALD = '" + _ChCTC + "' "
cQuery +=    "AND CT2_DC <= '3' "                                                               
cQuery += "GROUP BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_MOEDLC, CT2_TPSALD "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRAB', .F., .T.)
dbSelectArea("TRAB")
TRAB->(dbGoTop())
If TRAB->(!Eof().And.!Bof())
	_cFilial := TRAB->CT2_FILIAL
	_dData   := StoD(TRAB->CT2_DATA)
	_cLote   := TRAB->CT2_LOTE
	_cSBLote := TRAB->CT2_SBLOTE
	_cDoc    := TRAB->CT2_DOC
	_cMoeda  := TRAB->CT2_MOEDLC
	_nDebCT2 := TRAB->DEBITO
	_nCreCT2 := TRAB->CREDITO
	_nDigCT2 := TRAB->DIGITADO       
	_lCT2	 := .T.
EndIf
TRAB->(dbCloseArea())

cQuery := "SELECT CTC_FILIAL, CTC_DATA, CTC_LOTE, CTC_SBLOTE, CTC_DOC, CTC_MOEDA, CTC_TPSALD, "
cQuery +=        "CTC_DEBITO DEBITO, CTC_CREDIT CREDITO, R_E_C_N_O_ CTCREC "
cQuery +=   "FROM "+RetSqlName("CTC") +" CTC "
cQuery +=  "WHERE D_E_L_E_T_='' "
cQuery +=    "AND CTC_FILIAL+CTC_DATA+CTC_LOTE+CTC_SBLOTE+CTC_DOC+CTC_MOEDA+CTC_TPSALD = '" + _ChCTC + "' "
cQuery +=    "AND CTC_STATUS='1' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRAB', .F., .T.)
If TRAB->(!Eof().And.!Bof())
	If _lCT2
		If TRAB->DEBITO <> _nDebCT2 .Or. TRAB->CREDITO <> _nCreCT2
			cQuery := "UPDATE "+RetSqlName("CTC")+" "
			cQuery += "SET CTC_DEBITO="+AllTrim(Str(_nDebCT2))+", CTC_CREDIT="+AllTrim(Str(_nCreCT2))+", CTC_DIG="+AllTrim(Str(_nDigCT2))+" "
			cQuery += "WHERE R_E_C_N_O_="+AllTrim(Str(TRAB->CTCREC))+" "
			_nRetQry = TcSqlExec(cQuery)
		EndIf
	Else
		cQuery := "DELETE FROM "+RetSqlName("CTC")+" "
		cQuery += "WHERE R_E_C_N_O_="+AllTrim(Str(TRAB->CTCREC))+" "
		_nRetQry = TcSqlExec(cQuery)
	EndIf
Else
	If _lCT2
		dbSelectArea("CTC")
		RecLock("CTC",.T.)
		CTC->CTC_FILIAL := _cFilial
		CTC->CTC_DATA	:= _dData
		CTC->CTC_LOTE	:= _cLote
		CTC->CTC_SBLOTE := _cSBLote
		CTC->CTC_DOC    := _cDoc
		CTC->CTC_MOEDA  := _cMoeda
		CTC->CTC_TPSALD := "1"
		CTC->CTC_STATUS := "1"
		CTC->CTC_DEBITO := _nDebCT2
		CTC->CTC_CREDIT := _nCreCT2
		CTC->CTC_DIG    := _nDigCT2
		CTC->(MsUnLock()) 
	EndIf	
EndIf	
TRAB->(dbCloseArea())

Return
