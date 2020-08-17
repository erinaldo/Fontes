#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA21()

Função para contabilização do PA vindo do TOP
Chamada pelo LP 511

@param		
@return		cConta -> Conta Crédito
@author 	Fabiano Albuquerque
@since 		23/01/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ASCTBA21()

Local cConta := 0
Local aAreaAnt := GetArea()

DbSelectArea("SE5")
DbSelectArea("SA6")

SE5->(DbSetOrder(7))
IF SE5->(MsSeek( xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
	SA6->(DbSetOrder(1))
	IF SA6->(MsSeek(xFilial("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA)))
		cConta := SA6->A6_CONTA
	ENDIF
ENDIF

RestArea(aAreaAnt)

Return cConta