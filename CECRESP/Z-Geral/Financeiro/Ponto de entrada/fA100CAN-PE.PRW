#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} FA100CAN
Ponto de entrada ao final da exclusão / cancelamento da mov. bancária
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		18/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA100CAN

//** Estorna os processos de mutuos 
IF !EMPTY(SE5->E5_XLOTMUT)
	U_ASFINA57(SE5->E5_XLOTMUT,SE5->(RECNO()))
ENDIF

RETURN
