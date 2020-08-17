#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA75()
Utilizado na Rotina de AVP
Chamado pelo Formula AVP

@param		Nil
@return		nValAVP - Valor do AVP
@author 	Fabiano Albuquerque
@since 		26/02/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA75()

Local aAreaAnt	:= GetArea()
Local nIndDia	:= 0
Local nDiasAvp  := 0
Local dDataFin  := SE1->E1_VENCTO
Local dDataIni  := SE1->E1_EMISSAO
Local nValVP	:= 0
Local nDecimais := TamSX3("FIN_VLRAVP")[2]
Local nValTit 	:= SE1->E1_VALOR
Local nTxFin
Local cVenda	:= SE1->E1_XCONTRA	

DbSelectArea("SZ9")
SZ9->( DbSetOrder(1) )
IF MsSeek( xFilial("SZ9") + cVenda )
	nTxFin := SZ9->Z9_TXFIN
EndIF

//Converto a Taxa informada
nIndDia := 1+(nTxFin/100) //Taxa equivalente

//Calculo o numero de dias para AVP
nDiasAvp := DateDiffMonth(dDataFin, dDataIni)

//Valor Presente
nValVP	:= Round( nValTit / (nIndDia**nDiasAVP), nDecimais)

RestArea(aAreaAnt)

Return nValVP