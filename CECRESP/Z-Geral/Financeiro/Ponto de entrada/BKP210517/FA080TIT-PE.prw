#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA080TIT()

Confirma baixas a pgar

O ponto de entrada FA080TIT sera utilizado na confirmacao da tela de 
baixa do contas a pagar, antes da gracacao dos dados.

@param		Nenhum
@return		lRet	=	.T. / .F.
@author 	Fabio Cazarini
@since 		05/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA080TIT()
	LOCAL lRet	:= .T.
	
	//-----------------------------------------------------------------------
	// Valida se o título a pagar foi enviado para o Fluig e liberado
	//-----------------------------------------------------------------------
	lRet := U_ASFINA04()
	
RETURN lRet