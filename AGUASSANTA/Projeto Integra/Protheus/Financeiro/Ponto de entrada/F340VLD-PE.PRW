#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F340VLD()
Ponto de entrada na confirmação da compensação, permite validar o titulo a ser compensado 
@param		Nenhum
@return		lRet - .T. / .F.
@author 	Zema
@since 		05/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F340VLD
Local lRet := .T.
// Verifica se a ser compensado foi liberado no Fluig
lRet := U_ASFINA71()
RETURN lRet