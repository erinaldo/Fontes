#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT380INC
//TODO 	LOCALIZA��O : Function A380TudoOK() - Respons�vel por avaliar se o empenho pode ser efetuado.
		EM QUE PONTO : Este ponto de entrada tem a finalidade de confirmar ou n�o a inclus�o ou altera��o
@author Mario L. B. Faria
@since 25/06/2018
@version 1.0
@return lRet, l�gico, continua a ou n�o o processo
/*/
User Function MT380INC()
Local lRet	:= .T.
Local aArea := GetArea()
Local lIndus:= !U_IsBusiness()  // -> Verifica se � industria (n�o pode ser executada para as unidades de neg�cio)
	
	If Altera .and. lIndus
		//Chama rotina para verificar se possui separa��o
		lRet := U_APCP01SP(M->D4_OP,M->D4_COD,M->D4_LOTECTL,M->D4_QUANT)
	EndIf

	RestArea(aArea)

Return lRet