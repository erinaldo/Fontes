#include "rwmake.ch"
#include "topconn.ch"

User Function SLDGERCC(cMes,cAno,cMoeda,cPlanGer,cContGer,cCC)

cMes := STRZERO(Val(cMes),2)

cCC := ALLTRIM(cCC)

cAno := STRZERO(Val(substr(ALLTRIM(cAno),3,4)),2)

dDataIni := CTOD("01/"+cMes+"/"+cAno)

dDataFim := CTOD(STRZERO(Day(LastDay(dDataIni)),2)+"/"+cMes+"/"+cAno)

aSaveArea := GetArea()

DBSelectArea("CTT")
DBSetOrder(1)

If DBSeek(xFilial("CTT")+cCC,.F.)
	cCC := CTT->CTT_CUSTO
	
Else
	_nRet := 0
	RestArea(aSaveArea)
	Return(_nRet)
EndIf

_nSaldo := 0

DBselectArea("CT3")
DBSetOrder(2)

dbSelectArea("CTS")
dbSetOrder(2)

If dbSeek(xFilial("CTS")+cPlanGer+cContGer,.F.)
	
	While !Eof() .And. CTS->CTS_FILIAL == xFilial("CTS") .And.;
		CTS->CTS_CODPLA == cPlanGer .And. ALLTRIM(CTS->CTS_CONTAG)	== ALLTRIM(cContGer)
		
		If CTS->CTS_CLASSE == "1"
			dbSkip()
			Loop
		EndIf
		
//		If CT3->(!DBSeek(xFilial("CT3")+CTS->CTS_CT1INI+cCC+cMoeda+CTS->CTS_TPSALD,.F.))
			
//			RestArea(aSaveArea)
//	        Return(_nSaldo)
//		EndIf
		
		_nMovCC := CSaldTotCT3(cCC,CTS->CTS_CT1INI,;
		CTS->CTS_CT1FIM,dDataIni,dDataFim,cMoeda,CTS->CTS_TPSALD,CTS->CTS_NORMAL)
		
		// Calculos com os Fatores
		If CTS->CTS_IDENT == "1" .Or. CTS->CTS_IDENT == "2" 		// Soma / Subtrai
			If CTS->CTS_IDENT == "1"			// Somo os saldos
				
				_nSaldo := _nSaldo + _nMovCC
				
			ElseIf CTS->CTS_IDENT == "2"		// Subtraio os saldos
				
				_nSaldo := _nSaldo - _nMovCC
				
			EndIf
		EndIf
		dbSelectArea("CTS")
		dbSkip()
	EnddO
EndIf
_nRet := _nSaldo
RestArea(aSaveArea)
Return(_nRet)


Static Function CSaldTotCT3(_cCusto,cContaIni,cContaFim,dDataini,dDataFim,cMoeda,cTpSald,cNor)

_cQuery := " SELECT (SUM(CT3_CREDIT) - SUM(CT3_DEBITO)) AS VALOR  FROM "+RETSQLNAME('CT3')+" "
_cQuery += " WHERE CT3_CUSTO = '"+_cCusto+"' AND CT3_FILIAL = '"+xFilial("CT3")+"' AND "
_cQuery += " CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' AND  "
_cQuery += " CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND  '"+DTOS(dDataFim)+"' AND "
_cQuery += " CT3_MOEDA = '"+cMoeda+"' AND CT3_TPSALD = '"+cTpSald+"' "
_cQuery += " AND D_E_L_E_T_ <> '*' "


If Select("TRDEXC") >0
	DBSelectArea("TRDEXC")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "TRDEXC"

DBSelectArea("TRDEXC")
DBGotop()

_nRet := TRDEXC->VALOR

DBCloseArea()

If ALLTRIM(cNor) == "1"
	_nret := _nret * -1
EndIf

Return(_nRet)


User Function SLDPLGER(cMes,cAno,cMoeda,cPlanGer,cContGer)


cMes := STRZERO(Val(cMes),2)

cAno := STRZERO(Val(substr(ALLTRIM(cAno),3,4)),2)

dDataIni := CTOD("01/"+cMes+"/"+cAno)

dDataFim := CTOD(STRZERO(Day(LastDay(dDataIni)),2)+"/"+cMes+"/"+cAno)

aSaveArea := GetArea()

aSaldoAnt := {}
aSaldoAtu := {}
lConta 	:= .F.
lCusto	:= .F.
lItem	:= .F.
lClasse	:= .F.


nFator	 := 1
nSaldoDeb := 0
nSaldoCrd := 0
nSaldoAntD:= 0
nSaldoAntC:= 0
nSaldoAtuD:= 0
nSaldoAtuC:= 0
_nSaldo := 0



dbSelectArea("CTS")
dbSetOrder(2)

If dbSeek(xFilial("CTS")+cPlanGer+cContGer,.F.)
	
	While !Eof() .And. CTS->CTS_FILIAL == xFilial("CTS") .And.;
		CTS->CTS_CODPLA == cPlanGer .And. ALLTRIM(CTS->CTS_CONTAG)	== ALLTRIM(cContGer)
		
		_nRec := Recno()
		
		If CTS->CTS_CLASSE == "1"
			dbSkip()
			Loop
		EndIf
		
		lConta 	:= .F.
		lCusto	:= .F.
		lItem		:= .F.
		lClasse	:= .F.
		
		
		
		If (!Empty(CTS->CTS_CTHINI)	.Or. !Empty(CTS->CTS_CTHFIM))		// Saldo a partir da classe
			lClasse := .T.
		ElseIf (!Empty(CTS->CTS_CTDINI) .Or. !Empty(CTS->CTS_CTDFIM))	// Saldo a partir do Item
			lItem := .T.
		ElseIf (!Empty(CTS->CTS_CTTINI) .Or. !Empty(CTS->CTS_CTTFIM))	// Saldo a partir do C.Custo
			lCusto := .T.
		ElseIf (!Empty(CTS->CTS_CT1INI) .Or. !Empty(CTS->CTS_CT1FIM))	// Saldo a partir da Conta
			lConta := .T.
		EndIf
		
		If lConta .AND. lClasse == .F. .AND. lItem == .F. .and. lCusto == .F.
			aSaldoAnt := SaldTotCT7(CTS->CTS_CT1INI,CTS->CTS_CT1FIM,dDataIni,cMoeda,CTS->CTS_TPSALD)
			aSaldoAtu := SaldTotCT7(CTS->CTS_CT1INI,CTS->CTS_CT1FIM,dDataFim,cMoeda,CTS->CTS_TPSALD)
			dbSelectArea("CTS")
		EndIf
		If lCusto .AND. lClasse == .F. .AND. lItem == .F.
			aSaldoAnt := SaldTotCT3(CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataIni,cMoeda,CTS->CTS_TPSALD)
			aSaldoAtu := SaldTotCT3(CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataFim,cMoeda,CTS->CTS_TPSALD)
		EndIf
		If lItem .AND. lClasse == .F.
			aSaldoAnt := SaldTotCT4(CTS->CTS_CTDINI,CTS->CTS_CTDFIM,CTS->CTS_CTTINI,;
			CTS->CTS_CTTFIM,CTS->CTS_CT1INI,CTS->CTS_CT1FIM,;
			dDataIni,cMoeda,CTS->CTS_TPSALD)
			
			aSaldoAtu := SaldTotCT4(CTS->CTS_CTDINI,CTS->CTS_CTDFIM,CTS->CTS_CTTINI,;
			CTS->CTS_CTTFIM,CTS->CTS_CT1INI,CTS->CTS_CT1FIM,;
			dDataFim,cMoeda,CTS->CTS_TPSALD)
		EndIf
		If lClasse
			aSaldoAnt := SaldTotCTI(CTS->CTS_CTHINI,CTS->CTS_CTHFIM,CTS->CTS_CTDINI,;
			CTS->CTS_CTDFIM,CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataIni,cMoeda,CTS->CTS_TPSALD)
			
			aSaldoAtu := SaldTotCTI(CTS->CTS_CTHINI,CTS->CTS_CTHFIM,CTS->CTS_CTDINI,;
			CTS->CTS_CTDFIM,CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataFim,cMoeda,CTS->CTS_TPSALD)
			
		EndIf
		
		// Calculos com os Fatores
		If CTS->CTS_IDENT == "1" .Or. CTS->CTS_IDENT == "2" 		// Soma / Subtrai
			If CTS->CTS_IDENT == "1"			// Somo os saldos
				
				nSaldoAntD 	:= aSaldoAnt[7]
				nSaldoAntC 	:= aSaldoAnt[8]
				
				nSaldoAtuD 	:= aSaldoAtu[4]
				nSaldoAtuC 	:= aSaldoAtu[5]
				nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
				nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				_nSaldo := _nSaldo + ( nSaldoDeb - nSaldoCrd )
				
			ElseIf CTS->CTS_IDENT == "2"		// Subtraio os saldos
				
				nSaldoAntD 	:= aSaldoAnt[7]
				nSaldoAntC 	:= aSaldoAnt[8]
				
				nSaldoAtuD 	:= aSaldoAtu[4]
				nSaldoAtuC 	:= aSaldoAtu[5]
				
				nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
				nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				_nSaldo := _nSaldo - ( nSaldoDeb - nSaldoCrd )
				
			EndIf
		EndIf
		
		dbSelectArea("CTS")
		dbSetOrder(2)
		DBGoto(_nRec)
		
		dbSkip()
	EnddO
EndIf
_nRet := _nSaldo
RestArea(aSaveArea)
Return(_nRet)
            
User Function SLDPLACUM(cMes,cAno,cMoeda,cPlanGer,cContGer)


cMes := STRZERO(Val(cMes),2)

cAno := STRZERO(Val(substr(ALLTRIM(cAno),3,4)),2)

dDataIni := CTOD("01/"+cMes+"/"+cAno)

dDataFim := CTOD(STRZERO(Day(LastDay(dDataIni)),2)+"/"+cMes+"/"+cAno)

aSaveArea := GetArea()

aSaldoAnt := {}
aSaldoAtu := {}
lConta 	:= .F.
lCusto	:= .F.
lItem	:= .F.
lClasse	:= .F.


nFator	 := 1
nSaldoDeb := 0
nSaldoCrd := 0
nSaldoAntD:= 0
nSaldoAntC:= 0
nSaldoAtuD:= 0
nSaldoAtuC:= 0
_nSaldo := 0



dbSelectArea("CTS")
dbSetOrder(2)

If dbSeek(xFilial("CTS")+cPlanGer+cContGer,.F.)
	
	While !Eof() .And. CTS->CTS_FILIAL == xFilial("CTS") .And.;
		CTS->CTS_CODPLA == cPlanGer .And. ALLTRIM(CTS->CTS_CONTAG)	== ALLTRIM(cContGer)
		
		_nRec := Recno()
		
		If CTS->CTS_CLASSE == "1"
			dbSkip()
			Loop
		EndIf
		
		lConta 	:= .F.
		lCusto	:= .F.
		lItem		:= .F.
		lClasse	:= .F.
		
		
		
		If (!Empty(CTS->CTS_CTHINI)	.Or. !Empty(CTS->CTS_CTHFIM))		// Saldo a partir da classe
			lClasse := .T.
		ElseIf (!Empty(CTS->CTS_CTDINI) .Or. !Empty(CTS->CTS_CTDFIM))	// Saldo a partir do Item
			lItem := .T.
		ElseIf (!Empty(CTS->CTS_CTTINI) .Or. !Empty(CTS->CTS_CTTFIM))	// Saldo a partir do C.Custo
			lCusto := .T.
		ElseIf (!Empty(CTS->CTS_CT1INI) .Or. !Empty(CTS->CTS_CT1FIM))	// Saldo a partir da Conta
			lConta := .T.
		EndIf
		
		If lConta .AND. lClasse == .F. .AND. lItem == .F. .and. lCusto == .F.
			aSaldoAnt := SaldTotCT7(CTS->CTS_CT1INI,CTS->CTS_CT1FIM,dDataIni,cMoeda,CTS->CTS_TPSALD)
			aSaldoAtu := SaldTotCT7(CTS->CTS_CT1INI,CTS->CTS_CT1FIM,dDataFim,cMoeda,CTS->CTS_TPSALD)
			dbSelectArea("CTS")
		EndIf
		If lCusto .AND. lClasse == .F. .AND. lItem == .F.
			aSaldoAnt := SaldTotCT3(CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataIni,cMoeda,CTS->CTS_TPSALD)
			aSaldoAtu := SaldTotCT3(CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataFim,cMoeda,CTS->CTS_TPSALD)
		EndIf
		If lItem .AND. lClasse == .F.
			aSaldoAnt := SaldTotCT4(CTS->CTS_CTDINI,CTS->CTS_CTDFIM,CTS->CTS_CTTINI,;
			CTS->CTS_CTTFIM,CTS->CTS_CT1INI,CTS->CTS_CT1FIM,;
			dDataIni,cMoeda,CTS->CTS_TPSALD)
			
			aSaldoAtu := SaldTotCT4(CTS->CTS_CTDINI,CTS->CTS_CTDFIM,CTS->CTS_CTTINI,;
			CTS->CTS_CTTFIM,CTS->CTS_CT1INI,CTS->CTS_CT1FIM,;
			dDataFim,cMoeda,CTS->CTS_TPSALD)
		EndIf
		If lClasse
			aSaldoAnt := SaldTotCTI(CTS->CTS_CTHINI,CTS->CTS_CTHFIM,CTS->CTS_CTDINI,;
			CTS->CTS_CTDFIM,CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataIni,cMoeda,CTS->CTS_TPSALD)
			
			aSaldoAtu := SaldTotCTI(CTS->CTS_CTHINI,CTS->CTS_CTHFIM,CTS->CTS_CTDINI,;
			CTS->CTS_CTDFIM,CTS->CTS_CTTINI,CTS->CTS_CTTFIM,CTS->CTS_CT1INI,;
			CTS->CTS_CT1FIM,dDataFim,cMoeda,CTS->CTS_TPSALD)
			
		EndIf
		
		// Calculos com os Fatores
		If CTS->CTS_IDENT == "1" .Or. CTS->CTS_IDENT == "2" 		// Soma / Subtrai
			If CTS->CTS_IDENT == "1"			// Somo os saldos
				
				nSaldoAntD 	:= aSaldoAnt[7]
				nSaldoAntC 	:= aSaldoAnt[8]
				
				nSaldoAtuD 	:= aSaldoAtu[4]
				nSaldoAtuC 	:= aSaldoAtu[5]
				nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
				nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				_nSaldo := _nSaldo + ( nSaldoAtuD - nSaldoAtuC )
				
			ElseIf CTS->CTS_IDENT == "2"		// Subtraio os saldos
				
				nSaldoAntD 	:= aSaldoAnt[7]
				nSaldoAntC 	:= aSaldoAnt[8]
				
				nSaldoAtuD 	:= aSaldoAtu[4]
				nSaldoAtuC 	:= aSaldoAtu[5]
				
				nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
				nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				_nSaldo := _nSaldo - ( nSaldoAtuD - nSaldoAtuC )
				
			EndIf
		EndIf
		
		dbSelectArea("CTS")
		dbSetOrder(2)
		DBGoto(_nRec)
		
		dbSkip()
	EnddO
EndIf
_nRet := _nSaldo
RestArea(aSaveArea)
Return(_nRet)
            


User Function SLDGERSINT(cMes,cAno,cMoeda,cPlanGer,cContGer)

_aSint := {}
_aAnal := {}
_nRetSint := 0

dbSelectArea("CTS")
dbSetOrder(2)

If dbSeek(xFilial("CTS")+cPlanGer+cContGer,.F.)
	
	If CTS->CTS_CLASSE <> "1"
		Return(0)
	EndIf
	
EndIf


_aSint := _BuscaSint(cContGer,cPlanGer,_aSint)

_bCont := .F.
_i := 1

If Len(_aSint) > 0
	//busca todas as sinteticas relacionadas a primeira em todos os niveis
	While _bCont == .F.
		_aSint := _BuscaSint(_aSint[_i,1],cPlanGer,_aSint)
		If _i == Len(_aSint)
			_bCont := .T.
		EndIf
		_i++
	EndDo
EndIf

//Busca Analiticas
If Len(_aSint) > 0
	_aAnal := _BuscaAnal(_aSint,cPlanGer)
Else         
	AADD(_aSint , { cContGer ,cContGer })
	_aAnal := _BuscaAnal(_aSint,cPlanGer)
EndIf


//Pega Saldo Analiticas

For _i := 1 to len(_aAnal)
	
	_nRetSint := _nRetSint + U_SLDPLGER(cMes,cAno,cMoeda,cPlanGer,ALLTRIM(_aAnal[_i]))
	
Next

Return(_nRetSint)


User Function SLDGERACUM(cMes,cAno,cMoeda,cPlanGer,cContGer)

_aSint := {}
_aAnal := {}
_nRetSint := 0

dbSelectArea("CTS")
dbSetOrder(2)

If dbSeek(xFilial("CTS")+cPlanGer+cContGer,.F.)
	
	If CTS->CTS_CLASSE <> "1"
		Return(0)
	EndIf
	
EndIf


_aSint := _BuscaSint(cContGer,cPlanGer,_aSint)

_bCont := .F.
_i := 1

If Len(_aSint) > 0
	//busca todas as sinteticas relacionadas a primeira em todos os niveis
	While _bCont == .F.
		_aSint := _BuscaSint(_aSint[_i,1],cPlanGer,_aSint)
		If _i == Len(_aSint)
			_bCont := .T.
		EndIf
		_i++
	EndDo
EndIf

//Busca Analiticas
If Len(_aSint) > 0
	_aAnal := _BuscaAnal(_aSint,cPlanGer)
Else         
	AADD(_aSint , { cContGer ,cContGer })
	_aAnal := _BuscaAnal(_aSint,cPlanGer)
EndIf


//Pega Saldo Analiticas

For _i := 1 to len(_aAnal)
	
	_nRetSint := _nRetSint + U_SLDPLACUM(cMes,cAno,cMoeda,cPlanGer,ALLTRIM(_aAnal[_i]))
	
Next

Return(_nRetSint)


Static Function _BuscaSint(cContGer,cPlanGer,_aRes)

_cQuery := " SELECT CTS_CODPLA , CTS_CONTAG , CTS_CTASUP FROM "+RetSqlName("CTS")+" "
_cQuery += " WHERE CTS_CTASUP = '"+cContGer+"' AND CTS_CLASSE = '1' AND D_E_L_E_T_ <> '*' "
_cQuery += " AND CTS_FILIAL = '"+xFilial("CTS")+"' AND CTS_CODPLA = '"+cPlanGer+"' "
_cQuery += " ORDER BY CTS_CONTAG "


If Select("TRDEXC2") >0
	DBSelectArea("TRDEXC2")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "TRDEXC2"

DBSelectArea("TRDEXC2")

If !EOF()
	While !EOF()
		
		AADD(_aRes , { TRDEXC2->CTS_CONTAG ,TRDEXC2->CTS_CTASUP })
		
		DBSkip()
	EndDo
EndIf


DBCloseArea()
Return(_aRes)


Static Function _BuscaAnal(_aSint,cPlanGer)

_aRet := {}

For _i:= 1 to len(_aSint)
	
	_cQuery := " SELECT CTS_CONTAG  FROM "+RetSqlName("CTS")+" "
	_cQuery += " WHERE CTS_CTASUP = '"+ALLTRIM(_aSint[_i,1])+"' AND CTS_CLASSE = '2' AND D_E_L_E_T_ <> '*' "
	_cQuery += " AND CTS_FILIAL = '"+xFilial("CTS")+"' AND CTS_CODPLA = '"+cPlanGer+"' "
	_cQuery += " ORDER BY CTS_CONTAG "
	
	If Select("TRDEXC3") >0
		DBSelectArea("TRDEXC3")
		DBCloseArea()
	EndIf
	
	TCQUERY _cQuery NEW ALIAS "TRDEXC3"
	
	DBSelectArea("TRDEXC3")
	
	If !EOF()
		
		While !EOF()
			
			AADD(_aRet , TRDEXC3->CTS_CONTAG )
			
			DBSkip()
		EndDo
	EndIf
	
Next

Return(_aRet)


User Function USaldCT7(cConta,cMes,cAno,cMoeda)

DBSelectArea("CT7")   
DBSetOrder(1)      
                                     
cMes := STRZERO(Val(cMes),2)

cAno := STRZERO(Val(substr(ALLTRIM(cAno),3,4)),2)

dDataIni := CTOD("01/"+cMes+"/"+cAno)

dDataFim := CTOD(STRZERO(Day(LastDay(dDataIni)),2)+"/"+cMes+"/"+cAno)


_cQuery := " SELECT (SUM(CT7_CREDIT) - SUM(CT7_DEBITO)) AS VALORES  FROM "+RETSQLNAME('CT7')+" "
_cQuery += " WHERE CT7_FILIAL = '"+xFilial("CT7")+"' AND "
_cQuery += " CT7_CONTA = '"+cConta+"' AND  "
_cQuery += " CT7_DATA BETWEEN '"+DTOS(dDataIni)+"' AND  '"+DTOS(dDataFim)+"' AND "
_cQuery += " CT7_MOEDA = '"+cMoeda+"' AND CT7_TPSALD = '1' "
_cQuery += " AND D_E_L_E_T_ <> '*' "


If Select("TRDEXC4") >0
	DBSelectArea("TRDEXC4")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "TRDEXC4"

DBSelectArea("TRDEXC4")
DBGotop()                     


_nRet := TRDEXC4->VALORES

DBCloseArea()

DBSelectArea("CT1")
DBSetOrder(1)

If DBSeek(xFilial("CT1")+cConta,.F.)

cNor := CT1->CT1_NORMAL

EndIf

If ALLTRIM(cNor) == "1"
	_nret := _nret * -1
EndIf

Return(_nRet)  


User Function SaldAcum(cConta,cMes,cAno,cMoeda)   

DBSelectArea("CT7")   
DBSetOrder(1)   

cMes := STRZERO(Val(cMes),2)

cAno := STRZERO(Val(substr(ALLTRIM(cAno),3,4)),2)

dDataIni := CTOD("01/"+cMes+"/"+cAno)

dDataFim := CTOD(STRZERO(Day(LastDay(dDataIni)),2)+"/"+cMes+"/"+cAno)

_cQuery := " SELECT ((CT7_ATUCRD)- (CT7_ATUDEB)) AS VALOR FROM "+RETSQLNAME('CT7')+" "
_cQuery += " WHERE CT7_FILIAL = '"+xFilial("CT7")+"' AND "
_cQuery += " CT7_CONTA = '"+cConta+"' AND  "
_cQuery += " CT7_DATA <= '"+DTOS(dDataFim)+"' AND "
_cQuery += " CT7_MOEDA = '"+cMoeda+"' AND CT7_TPSALD = '1' "
_cQuery += " AND D_E_L_E_T_ <> '*' "
_cQuery += " ORDER BY CT7_DATA DESC"

If Select("TRDEXC5") >0
	DBSelectArea("TRDEXC5")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "TRDEXC5"

DBSelectArea("TRDEXC5")
DbGotop()
    
_nRet5 := TRDEXC5->VALOR
        

DBCloseArea()

DBSelectArea("CT1")
DBSetOrder(1)

If DBSeek(xFilial("CT1")+cConta,.F.)

cNor := CT1->CT1_NORMAL

EndIf

If ALLTRIM(cNor) == "1"
	_nret5 := _nret5 * -1
EndIf

Return(_nRet5)   