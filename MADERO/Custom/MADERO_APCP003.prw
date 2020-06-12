#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} APCP03SP
//TODO Efetua a gravação da tabela auxiliar de Saldo de Empenho na movimentação interna SIMPLES
@author Mario L. B. Faria
@since 13/07/2018
@param cTpMov, characters, Tipo do Movimento
/*/
User Function APCP03SP(cCod,cOp,cLote,nQtd,cTpMov)
	
	dbSelectArea("ZA1")

	RecLock("ZA1",.T.)
	ZA1->ZA1_FILIAL		:= xFilial("ZA1")
	ZA1->ZA1_COD		:= cCod
	ZA1->ZA1_OP			:= cOp
	ZA1->ZA1_LOTECT		:= cLote
	ZA1->ZA1_QTDSEP		:= nQtd
	ZA1->ZA1_TPMOV		:= cTpMov
	ZA1->(MSUNLOCK())
			
Return

/*/{Protheus.doc} APCP03MT
//TODO Efetua a gravação da tabela auxiliar de Saldo de Empenho na movimentação interna MULTIPLA
@author Mario L. B. Faria
@since 13/07/2018
/*/
User Function APCP03MT()

	Local aArea		:= GetArea()
	Local aAreaSD3	:= SD3->(GetArea())
	
	Local nPosCod	:= aScan(aHeader,{|X|Alltrim(X[2])=="D3_COD"})
	Local nPosOp	:= aScan(aHeader,{|X|Alltrim(X[2])=="D3_OP"})
	Local nPosLot	:= aScan(aHeader,{|X|Alltrim(X[2])=="D3_LOTECTL"})
	Local nPosQtd	:= aScan(aHeader,{|X|Alltrim(X[2])=="D3_QUANT"})
	
	Local nX		:= 0 
	
	dbSelectArea("SF5")
	SF5->(dbSetOrder(1))
	SF5->(dbGoTop())
	SF5->(dbSeek(xFilial("SF5")+cTm))
	
	If SF5->(Found()) .And. SF5->F5_ATUEMP == "S" .And. SF5->F5_TIPO $ ("RD")
		For nX := 1 to Len(aCols)
			If !Empty(aCols[nX,nPosOp]) .And. !u_IsBusiness() 
				U_APCP03SP(aCols[nX,nPosCod], aCols[nX,nPosOp], aCols[nX,nPosLot], aCols[nX,nPosQtd], SF5->F5_TIPO)
			EndIf
		Next nX
	EndIf

	RestArea(aAreaSD3)
	RestArea(aArea)

Return


User Function APCP03LG()

	Local cQuery	:= ""
	Local cAlEmp	:= ""
	Local lRet		:= .T.
	Local lTotAp	:= .T.

	cQuery := "	SELECT " + CRLF
	cQuery += "		COALESCE(SUM(H6_QTDPROD + H6_QTDPERD),0) TOT_SH6, " + CRLF 
	cQuery += "		COALESCE(SUM(CASE WHEN H6_PT = 'T' THEN 1 ELSE 0 END),0) QTD_F " + CRLF 
	cQuery += "	FROM " + RetSqlname("SH6") + " SH6 " + CRLF 
	cQuery += "	WHERE " + CRLF
	cQuery += "	        H6_FILIAL  = '" + xFilial("SH6") + "' " + CRLF
	cQuery += "	    AND H6_OP      = '" + SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) + "' " + CRLF
	cQuery += "	    AND H6_PRODUTO = '" + SC2->C2_PRODUTO + "' " + CRLF
	cQuery += "	    AND SH6.D_E_L_E_T_ = ' ' " + CRLF

//	MemoWrite("c:\temp\legenda.sql",cQuery)

	cQuery := ChangeQuery(cQuery)
	cAlEmp := MPSysOpenQuery(cQuery)

	If (cAlEmp)->QTD_F == 0
		If (cAlEmp)->TOT_SH6 >= SC2->C2_QUANT
			lTotAp := .T.
		Else
			lTotAp := .F.
		EndIf

	Else
		lTotAp := .F.
	EndIf
	
	(cAlEmp)->(dbCloseArea())
	
	If SC2->C2_TPOP == "F" .And. Empty(SC2->C2_DATRF) .And. lTotAp
		lRet := .T.
	Else
	 	lRet := .F.
	EndIf

Return lRet














