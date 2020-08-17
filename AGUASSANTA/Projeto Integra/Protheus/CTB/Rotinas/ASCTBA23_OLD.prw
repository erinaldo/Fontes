#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA23()
Soma os valores do longo prazo

@param		
@return		nValLP -> Valor do longo prazo
@author 	Fabiano Albuquerque
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra

/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCTBA23()

LOCAL aAreaAnt	:= GetArea()
LOCAL aAreaSE1  := SE1->(GetArea())
LOCAL nValLP	:= 0
LOCAL cQuery	:= ""
LOCAL cVenda	:= SE1->E1_XCONTRA
LOCAL cCliente	:= SE1->E1_CLIENTE
LOCAL nMonth    := 12
Local dDataLP
Local cTMPSE1	:= GetNextAlias()

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1))
IF MsSeek( xFilial("SZ9") + cVenda )
	dDataLP := dToC( FirstDate( MonthSum( SZ9->Z9_DTVENDA, nMonth ) ) )
	dDataLP := "20"+Substr(dDataLP,7,2)+Substr(dDataLP,4,2)+Substr(dDataLP,1,2)
EndIF


cQuery := "SELECT SUM(E1_SALDO) AS VALLP"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_XCONTRA = '"+cVenda+"'"
cQuery += " AND SE1.E1_CLIENTE = '"+cCliente+"'"
cQuery += " AND SE1.E1_VENCTO >= '"+dDataLP+"'"
cQuery += " AND SE1.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)

If Select(cTMPSE1)>0
	(cTMPSE1)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cTMPSE1, .T., .T. )

nValLP := (cTMPSE1)->VALLP

(cTMPSE1)->(dbCloseArea())

RestArea(aAreaSE1)
RestArea(aAreaAnt)

Return nValLP