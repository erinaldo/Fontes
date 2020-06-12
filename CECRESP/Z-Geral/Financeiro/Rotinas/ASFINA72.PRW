#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA72()
Utilizado no cnab bradesco para retorno o tipo de conta do fornecedor
1=Conta Corrente
2=Conta Poupanca
 
@param		Tipo de Conta Corrente
@return		cTipCta 
@author 	Fabiano Albuquerque
@since 		26/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA72()
Local cTipCta   := '1'
Local cChaveFIL := xFilial("FIL")+SE2->(E2_FORNECE+E2_LOJA+E2_FORBCO+E2_FORAGE+E2_FORCTA)
Local aArea := GETAREA()

FIL->(DbSetOrder(2))

	IF FIL->(MsSeek(cChaveFIL))
		cTipCta := FIL->FIL_TIPCTA	
	EndIF
RestArea(aArea)

RETURN cTipCta