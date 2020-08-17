#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA11()

Importa��o de Pedidos de Compra
Exibe ou n�o exibe o item do pedido na importa��o do pedido de compras
Chamado pelo PE MT103VPC

@param		Nenhum 
@return		L�gico = Exibe ou n�o exibe o item do pedido na importa��o do pedido de compras
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA11()
	LOCAL lRet	:= .T.
	
	//-----------------------------------------------------------------------
	// Se o pedido de compras n�o estiver aprovado e
	// n�o foi originado pelo RM
	//-----------------------------------------------------------------------
	IF SC7->C7_XSFLUIG <> 'A' .AND. ALLTRIM(SC7->C7_ORIGEM) <> 'MSGEAI'  
		lRet := .F.
	ENDIF
	
RETURN lRet