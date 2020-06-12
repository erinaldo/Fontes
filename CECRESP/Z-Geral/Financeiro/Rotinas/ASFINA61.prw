#Include "Protheus.ch"       

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA61
Chamado via Ponto de entrada F050MCP para edição dos campos na tabela SE2
@param		Array com os campos adicionado para edição
@return		aCpoAlt
@author 	Fabiano Albuquerque
@since 		07/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ASFINA61(aCpoAlt)

AADD(aCpoAlt,"E2_FORBCO") 
AADD(aCpoAlt,"E2_FORAGE") 
AADD(aCpoAlt,"E2_FAGEDV")
AADD(aCpoAlt,"E2_FORCTA")
AADD(aCpoAlt,"E2_FCTADV")
AADD(aCpoAlt,"E2_FORMPAG")

Return aCpoAlt
