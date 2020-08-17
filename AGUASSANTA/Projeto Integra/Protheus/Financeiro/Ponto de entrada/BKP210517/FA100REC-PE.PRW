#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} FA100REC
Ponto de entrada na gravação do movimento bancário receber
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		05/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA100REC                                  

// Atualiza o historico da movimentação na rotina de mutuo
IF IsInCallStack("U_ASFINA37")
	RECLOCK("SE5",.F.)
	SE5->E5_HISTOR := cHist100
	MsUnlock()
ENDIF	
RETURN