#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} FA100PAG
Ponto de entrada na gravação do movimento bancário pagar
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		05/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA100PAG                                  
//DEFAULT cHist100 := ""
// Atualiza o historico da movimentação na rotina de mutuo
IF IsInCallStack("U_ASFINA37") .OR. IsInCallStack("U_ASFINA42").OR. IsInCallStack("U_ASFINA53").OR. IsInCallStack("U_ASFINA67")
	RECLOCK("SE5",.F.)
	SE5->E5_HISTOR := cHist100
	MsUnlock()
ENDIF	
RETURN