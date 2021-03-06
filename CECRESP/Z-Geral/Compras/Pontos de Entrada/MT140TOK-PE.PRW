#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT140TOK()

Na confirma da inclus�o da Pr�-nota

@param		Nenhum 
@return		L�gico = Se OK
@author 	Zema
@since 		19/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT140TOK
	LOCAL lRet	:= .T.
	
	// Atualiza os dados do PC caso seja integra��o com o TOP - Dedu��es do Pedido - Zema 19/09/17
	U_ASTOP101()
	U_ASTOP203()
	
	
	// Valida as informa��es da dedu��o do Pedido de Compras vindo do RM-TOP	
	lRet := U_ASTOP201("P")

RETURN lRet