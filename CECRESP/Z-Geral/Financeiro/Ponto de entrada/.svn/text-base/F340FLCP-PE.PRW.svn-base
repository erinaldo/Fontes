#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F340FLCP()
Ponto de entrada na seleção de titulos para compensação, 
permite filtrar os titulos para compensar 
 
@param		Nenhum
@return		cRet - Complemento da query
@author 	Zema
@since 		05/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F340FLCP
Local cRet := ""
// Filtra titulos não liberados no fluig
cRet := U_ASFINA70()
RETURN cRet