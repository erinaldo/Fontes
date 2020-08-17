#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA17
Utilizado para contabilização do documento de entrada

@param		
@return		Valor do ISS Contabilização do ISS no Compras
@author 	Fabiano Albuquerque
@since 		13/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ASCTBA17()

Local aAreaAnt  := GetArea()
Local nRet		:= 0

DbSelectArea("SE2")
SE2->(DbSetOrder(1))

MsSeek(xFilial("SE2")+SD1->D1_SERIE+SD1->D1_DOC+Space(TamSX3('E2_PARCELA')[01])+"NF "+SD1->D1_FORNECE+SD1->D1_LOJA) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

nRet := SE2->E2_ISS

RestArea(aAreaAnt)
	
Return nRet