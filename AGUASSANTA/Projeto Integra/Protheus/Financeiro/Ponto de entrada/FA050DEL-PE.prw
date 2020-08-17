#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA050DEL()

Confirmação de exclusão de títulos

O ponto de entrada FA050DEL será executado logo após a confirmação da exclusão do título.

@param		Nenhum
@return		lRet	=	.T./.F. - Se retornar .F. o t¡tulo não será exclu¡do.
@author 	Fabio Cazarini
@since 		04/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA050DEL()
	LOCAL lRet	:= .T.
	
	IF lRet
		//-----------------------------------------------------------------------
		// Exclui alçada de aprovação do título a pagar na tabela SZ5 e cancela 
		// a solicitação no Fluig
		//-----------------------------------------------------------------------
		lRet := U_ASFINA01(55)
	ENDIF
	
RETURN lRet