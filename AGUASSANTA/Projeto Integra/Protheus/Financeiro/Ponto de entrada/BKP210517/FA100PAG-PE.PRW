#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} FA100PAG
Ponto de entrada na grava��o do movimento banc�rio pagar
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		05/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA100PAG                                  

// Atualiza o historico da movimenta��o na rotina de mutuo
IF IsInCallStack("U_ASFINA37")
	RECLOCK("SE5",.F.)
	SE5->E5_HISTOR := cHist100
	MsUnlock()
ENDIF	
RETURN