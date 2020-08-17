#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} F080PCAN
Ponto de entrada ao final da exclusão / cancelamento da baixa a pagar - FINA080
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		17/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F080PCAN

//** Estorna os processos de mutuos 
IF !EMPTY(SE5->E5_XLOTMUT)
	U_ASFINA57(SE5->E5_XLOTMUT,0)
ENDIF

RETURN