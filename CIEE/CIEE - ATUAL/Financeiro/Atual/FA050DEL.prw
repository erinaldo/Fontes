#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA050DEL  บ Autor ณ Claudio Barros     บ Data ณ  08/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para validar a exclusใo do titulo         บฑฑ
ฑฑบ          ณ quando o movimento contabil for Real ou efetivado          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACOM - FINA050 - Excluir o lancamento Contabil          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FA050DEL()

Local _lRet := .T.
Private aExLcto	:= {}
Private xCT2Lote	:= ""

IF cEmpAnt == '01' 	// Somente CIEE-SP tem o novo controle das FLs
	If Alltrim(FunName()) <> "AFIN050TP"
		If AllTrim(SE2->E2_TIPO)=="FL"
			MsgBox("Nใo ้ permitida a exclusใo do tipo FL pela rotina de Contas a Pagar!!! Utilize a rotina adequada!!!",OemToAnsi("Aten็ใo"))	
			_lRet := .F.
			Return(_lRet)
		EndIf
	EndIf
EndIf

MsgRun("Processando Exclusao do Titulo e Lancamentos Contabeis!!!",,{|| RunDEL() })

Return(_lRet)

Static Function RunDEL()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := .T.
Local _cAlias := GetArea()
Private cString := "CT2"

dbSelectArea("SE2")

dbSelectArea("CT2")
dbSetOrder(1)

_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD, CT2_KEY "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND CT2_LOTE <> '009700'  "+_cFl
_cQuery += " AND CT2_KEY = '"+xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)

TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "1"
	MsgAlert("Exclusใo nใo permitida, contabiliza็ใo efetivada, Informe a contabilidade!!")
    _lRet := .F.
    Return(_lRet)
ELSE
	//Pesquisa e deleta registros de Amortizacao. Se tiver.
	If SE2->E2_TPAMORT == "S"
		_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD, CT2_KEY "+_cFl
		_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
		_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
		_cQuery += " AND CT2_LOTE = '009200'  "+_cFl
		_cQuery += " AND CT2_XKEY = '"+xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"' "+_cFl
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)

		TcSetField("TRB","CT2_DATA","D",8, 0 )

		Dbselectarea("TRB")
		TRB->(Dbgotop())
		_cAmortEfet	:= .F.
		Do While !EOF()
			If TRB->CT2_TPSALD == "1"
				_cAmortEfet	:= .T.
			EndIf
			TRB->(DbSkip())
		EndDo

		If Select("TRB") > 0
		   TRB->(DbcloseArea())
		Endif

		If _cAmortEfet
			MsgAlert("Exclusใo nใo permitida, contabiliza็ใo efetivada, Informe a contabilidade!!")
		    _lRet := .F.
		    Return(_lRet)
		 EndIf
    EndIf
    //Fim Amortizacao

	Dbselectarea("TRV")
	Dbselectarea("CT2")
	CT2->(DbSetorder(1))
	CT2->(Dbgotop())
	CT2->(Dbseek(xFilial("CT2")+Dtos(TRV->CT2_DATA)+TRV->CT2_LOTE+TRV->CT2_SBLOTE+TRV->CT2_DOC))	

    _cData   := TRV->CT2_DATA
    _cLote   := TRV->CT2_LOTE
    _cSblote := TRV->CT2_SBLOTE
    _cDoc    := TRV->CT2_DOC
    _cLinha  := TRV->CT2_LINHA
    _cKEY	 := ""
    _nPos    := ""
    _aDelSe2 := {}
    _cPar    := SE2->E2_PARCELA
		
	While CT2->CT2_FILIAL == xFilial("CT2") .AND. CT2->CT2_DATA == _cData .AND. CT2->CT2_LOTE == _cLote .AND.;
	      CT2->CT2_SBLOTE == _cSblote .AND. CT2->CT2_DOC == _cDoc 
	      
		xCT2Lote	:= CT2->CT2_LOTE
		_cKEY := ALLTRIM(CT2_KEY)
		RecLock("CT2",.F.)
		CT2->CT2_XUSER	:= cUserName
		CT2->CT2_XDTEXL	:= dDataBase
//		CT2->(DbDeLete())
		CT2->(MsUnlock())

		AADD(aExLcto,{DTOS(CT2->CT2_DATA)+CT2->(CT2_LOTE+CT2_SBLOTE+CT2_DOC), CT2->CT2_DATA, CT2->CT2_LOTE, CT2->CT2_SBLOTE, CT2->CT2_DOC, CT2->CT2_LINHA, CT2->CT2_DC, CT2->CT2_ITEMD, CT2->CT2_CCD, CT2->CT2_ITEMC, CT2->CT2_CCC, CT2->CT2_VALOR, CT2->CT2_HIST, CT2_ORIGEM})

		If !Empty(_cKEY)
			_nPos := aScan( _aDelSe2 , _cKEY )
			If _nPos == 0
				aAdd(_aDelSe2,_cKEY)
			EndIf
		EndIf

		CT2->(DBSKIP())
	End

	fExLcto(xCT2Lote,aExLcto)

	//Pesquisa e deleta registros de Amortizacao. Se tiver.
	If SE2->E2_TPAMORT == "S"
		_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD, CT2_KEY, CT2_XKEY "+_cFl
		_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
		_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
		_cQuery += " AND CT2_LOTE = '009200'  "+_cFl
		_cQuery += " AND CT2_XKEY = '"+xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"' "+_cFl
		_cQuery += " ORDER BY CT2_DATA "
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
		TcSetField("TRB","CT2_DATA","D",8, 0 )

		Dbselectarea("TRB")
		TRB->(Dbgotop())

	    _cData   := TRB->CT2_DATA
	    _cLote   := TRB->CT2_LOTE
	    _cSblote := TRB->CT2_SBLOTE
	    _cDoc    := TRB->CT2_DOC

		aExLcto	:= {}
		_cXKEY	:= alltrim(TRB->CT2_XKEY)

		While !EOF() .and. _cXKEY == alltrim(xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)

			Dbselectarea("CT2")
			CT2->(DbSetorder(1))
			CT2->(Dbgotop())
			If CT2->(Dbseek(xFilial("CT2")+Dtos(TRB->CT2_DATA)+TRB->CT2_LOTE+TRB->CT2_SBLOTE+TRB->CT2_DOC))	
				RecLock("CT2",.F.)
				CT2->CT2_XUSER	:= cUserName
				CT2->CT2_XDTEXL	:= dDataBase
//				CT2->(DbDeLete())
				CT2->(MsUnlock())
				AADD(aExLcto,{DTOS(CT2->CT2_DATA)+CT2->(CT2_LOTE+CT2_SBLOTE+CT2_DOC), CT2->CT2_DATA, CT2->CT2_LOTE, CT2->CT2_SBLOTE, CT2->CT2_DOC, CT2->CT2_LINHA, CT2->CT2_DC, CT2->CT2_ITEMD, CT2->CT2_CCD, CT2->CT2_ITEMC, CT2->CT2_CCC, CT2->CT2_VALOR, CT2->CT2_HIST, CT2_ORIGEM})
			EndIf
			Dbselectarea("TRB")
			TRB->(DBSKIP())
		End

		fExLcto("009200",aExLcto)

		If Select("TRB") > 0
		   TRB->(DbcloseArea())
		Endif

	EndIf
	//Fim Amortizacao

	If !Empty(_aDelSe2)
		DbSelectArea("SE2")
		DbSetOrder(1)
		For _nI := 1 to Len(_aDelSe2)
			If substr(_aDelSe2[_nI],12,1) <> _cPar
				If DbSeek(_aDelSe2[_nI])
					RecLock("SE2",.F.)
					SE2->(DbDeLete())
					SE2->(MsUnlock())
				EndIf
			EndIf
		Next
	EndIf

	If SE2->E2_MULNATU == "1"
		DbSelectArea("SEV")
		DbSetOrder(1)
		If DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
			Do While SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA == SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
				RecLock("SEV",.F.)
				DbDelete()
				MsUnLock()
				DbSelectArea("SEV")
				DbSkip()
			EndDo
		EndIf
	EndIf

EndIf

If Select("TRV") > 0
   TRV->(DbcloseArea())
Endif

RestArea(_cAlias)

Return(_lRet)


Static Function fExLcto(_cLote,aExLcto)

//		AADD(aExLcto,{CT2->(CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC), CT2->CT2_DATA, CT2->CT2_LOTE, CT2->CT2_SBLOTE, CT2->CT2_DOC, CT2->CT2_LINHA, CT2->CT2_DC, CT2->CT2_ITEMD, CT2->CT2_CCD, CT2->CT2_ITEMC, CT2->CT2_CCC, CT2->CT2_VALOR, CT2->CT2_HIST, CT2_ORIGEM})

aLanCab	:= aExLcto
aLanLot	:= {}

aCab		:= {}
aItem		:= {}
aTotItem	:= {}

Private lMsErroAuto := .F.

For _nI := 1 to Len(aLanCab)

	_nPos	:= aScan(aLanLot, {|x| AllTrim(x[5]) == aLanCab[_nI,1] })

	If _nPos == 0
		aadd(aLanLot, {aLanCab[_nI,2], aLanCab[_nI,3], aLanCab[_nI,4], aLanCab[_nI,5],(DTOS(aLanCab[_nI,2])+aLanCab[_nI,3]+aLanCab[_nI,4]+aLanCab[_nI,5])})
	EndIf

Next _nI

For _nY := 1 to Len(aLanLot)

	If aLanLot[_nY,2] == _cLote

		aCab := {{"DDATALANC"	, aLanLot[_nY,1] 		,NIL},;
				 {"CLOTE"		, Padr(aLanLot[_nY,2] 	,TamSx3("CT2_LOTE")[1]),NIL},;
				 {"CSUBLOTE"	, Padr(aLanLot[_nY,3] 	,TamSx3("CT2_SBLOTE")[1]),NIL},;
				 {"CDOC"		, aLanLot[_nY,4]			,NIL}}

		For _nX	:= 1 To Len(aLanCab)

			If DTOS(aLanLot[_nY,1])+aLanLot[_nY,2]+aLanLot[_nY,3]+aLanLot[_nY,4] == aLanCab[_nX,1]

				AADD(aItem,{{"CT2_FILIAL"	,xFilial("CT2") , NIL},;
							{"CT2_LINHA"	,aLanCab[_nX,06] , NIL},;
							{"CT2_DC"		,aLanCab[_nX,07] , NIL},;
							{"CT2_ITEMD"	,aLanCab[_nX,08] , NIL},;
							{"CT2_CCD"		,aLanCab[_nX,09] , NIL},;
							{"CT2_ITEMC"	,aLanCab[_nX,10] , NIL},;
							{"CT2_CCC"		,aLanCab[_nX,11] , NIL},;
							{"CT2_VALOR"	,aLanCab[_nX,12] , NIL},;
							{"CT2_HP"		,""             , NIL},;				
							{"CT2_HIST"		,aLanCab[_nX,13] , NIL},;
							{"CT2_TPSALD"	,"9"            , NIL},;
							{"CT2_ORIGEM"	,aLanCab[_nX,14] , NIL},;
							{"CT2_MOEDLC"	,"01"           , NIL}})
			EndIf
		Next _nX

		aadd(aTotItem,aItem)

		MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItem,5)

		aTotItem	:=	{}

		If lMsErroAuto
			ConOut("Erro na exclusใo")
			DisarmTransaction()
			MostraErro()
			Return .F.
		Else
			ConOut("Exclusใo com sucesso!")
		EndIf
	EndIf

Next _nY

Return