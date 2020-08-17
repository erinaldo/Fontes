#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA25()
Soma juros do MÊS para tipo de venda VF, será contabilizado em uma conta
separada

@param		
@return		nValJur -> Valor do Juros do Mês
@author 	Fabiano Albuquerque
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra

/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCTBA25()

Local aAreaAnt	:= GetArea()
Local aAreaSE1  := SE1->(GetArea())
Local aAreaFRU  := FRU->(GetArea())
Local cVenda	:= SE1->E1_XCONTRA 
LOCAL nValJur	:= 0
Local cTipo		:= "5"
LOCAL cQuery	:= ""
Local cDtTit	:= ""
LOCAL cTMPFRU	:= GetNextAlias()

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1))
IF MsSeek(xFilial("SZ9")+cVenda)
	cDtTit := SUBSTR(DTOC(SZ9->Z9_DTREAJU),7,4) + SUBSTR(DTOC(SZ9->Z9_DTREAJU),4,2)

	cQuery := "SELECT SUM(FRU.FRU_VALOR) AS JUROS"
	cQuery += " FROM " +RetSqlName("FRU")+ " FRU, " +RetSqlName("SE1")+ " SE1"
	cQuery += " WHERE "
	cQuery += " FRU.FRU_FILIAL = '" +xFilial("SE1")+ "'"
	cQuery += " AND FRU.FRU_PREFIX = SE1.E1_PREFIXO"
	cQuery += " AND FRU.FRU_NUM = SE1.E1_NUM"
	cQuery += " AND FRU.FRU_PARCEL = SE1.E1_PARCELA"
	cQuery += " AND FRU.FRU_TIPO = SE1.E1_TIPO"
	cQuery += " AND FRU.FRU_COD = '" +cTipo+ "'"
	cQuery += " AND SE1.E1_XCONTRA = '" +cVenda+ "'"
	cQuery += " AND SE1.E1_TIPO = 'REC'"
	cQuery += " AND SUBSTRING(CONVERT(CHAR(8),SE1.E1_VENCREA,112),1,6)= '" +cDtTit+ "'"
	cQuery += " AND FRU.D_E_L_E_T_ = ''"
	cQuery += " AND SE1.D_E_L_E_T_ = ''"


	cQuery:=ChangeQuery(cQuery)

	If Select(cTMPFRU)>0
		(cTMPFRU)->(dbCloseArea())
	Endif

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cTMPFRU, .T., .T. )

	nValJur := (cTMPFRU)->JUROS

	(cTMPFRU)->(dbCloseArea())

ENDIF

RestArea(aAreaFRU)
RestArea(aAreaSE1)
RestArea(aAreaAnt)

RETURN nValJur