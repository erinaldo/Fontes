#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} M030ALT()

Ponto de entrada na altera��o de clientes
@param		Nenhum
@return		.T./.F.
@author 	Zema
@since 		26/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function M030ALT()           
Local lRet := .T.                

// Gera o cadastro de itens cont�beis com o CNPJ do fornecedor / cliente
U_ASCTBA11("SA1")

Return(lRet)
