#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA050FIN()

Trata dados contas a pagar

O ponto de entrada FA050FIN é chamado no programa de inclusão de contas 
a pagar após o fim do Begin Transaction.

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		03/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA050FIN()

	//-----------------------------------------------------------------------
	// Gera alçada de aprovação do título a pagar na tabela SZ5 e envia ao 
	// Fluig para aprovação
	//-----------------------------------------------------------------------
	U_ASFINA01(1)
	
RETURN