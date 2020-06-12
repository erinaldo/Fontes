#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT380INC
//TODO 	LOCALIZAÇÃO : Function A380TudoOK() - Responsável por avaliar se o empenho pode ser efetuado.
		EM QUE PONTO : Este ponto de entrada tem a finalidade de confirmar ou não a inclusão ou alteração
@author Mario L. B. Faria
@since 25/06/2018
@version 1.0
@return lRet, lógico, continua a ou não o processo
/*/
User Function MT380INC()
Local lRet	:= .T.
Local aArea := GetArea()
Local lIndus:= !U_IsBusiness()  // -> Verifica se é industria (não pode ser executada para as unidades de negócio)
	
	If Altera .and. lIndus
		//Chama rotina para verificar se possui separação
		lRet := U_APCP01SP(M->D4_OP,M->D4_COD,M->D4_LOTECTL,M->D4_QUANT)
	EndIf

	RestArea(aArea)

Return lRet