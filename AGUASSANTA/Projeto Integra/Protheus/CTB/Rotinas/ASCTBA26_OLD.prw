#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA26()
Consulta para verificar quais os valores para transfererir do longo prazo
para o curto prazo.

@param		
@return		nRet -> Valor para transferência do LP para CR
@author 	Fabiano Albuquerque
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra

/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCTBA26()

Local aAreaAnt	:= GetArea()
Local aAreaSE1  := SE1->(GetArea())
Local cVenda	:= SE1->E1_XCONTRA
Local cCliente	:= SE1->E1_CLIENTE
Local dDtReaj	
Local dDtIni
Local dDtFim
LOCAL nRet		:= 0
LOCAL nMonth	:= 12

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1))
IF MsSeek(xFilial("SZ9")+cVenda)
	IF Empty(SZ9->Z9_DTREAJU)
		Return nRet
	Else
		IF !Empty(SZ9->Z9_DTREAJU)
			dDtReaj	:= MonthSum( SZ9->Z9_DTREAJU, nMonth )
		EndIF
	EndIF
ENDIF	

IF !Empty(dDtReaj)
	dDtIni := "20"+Substr( dToC( FirstDate( dDtReaj ) ) ,7,2)+Substr( dToC( FirstDate( dDtReaj ) ),4,2)+Substr( dToC( FirstDate( dDtReaj ) ),1,2)
	dDtFim := "20"+Substr( dToC( LastDate( dDtReaj ) ) ,7,2)+Substr( dToC( LastDate( dDtReaj ) ),4,2)+Substr( dToC( LastDate( dDtReaj ) ),1,2)


	cQuery := "SELECT SUM(E1_SALDO) AS VALLP"
	cQuery += " FROM " + RetSqlName("SE1") + " SE1"
	cQuery += " WHERE "
	cQuery += " SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQuery += " AND SE1.E1_TIPO = 'REC'"
	cQuery += " AND SE1.E1_XCONTRA = '"+cVenda+"'"
	cQuery += " AND SE1.E1_CLIENTE = '"+cCliente+"'"
	cQuery += " AND SE1.E1_VENCTO BETWEEN '"+ dDtIni + "' AND '"+ dDtFim +"'"
	cQuery += " AND SE1.D_E_L_E_T_ = ''"

	cQuery:=ChangeQuery(cQuery)

	If Select(cTMPSE1)>0
		(cTMPSE1)->(dbCloseArea())
	Endif

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cTMPSE1, .T., .T. )

	nRet := (cTMPSE1)->VALLP

	(cTMPSE1)->(dbCloseArea())

EndIF

RestArea(aAreaSE1)
RestArea(aAreaAnt)

RETURN nRet