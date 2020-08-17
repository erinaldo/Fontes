#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA11()

Importação de Pedidos de Compra
Exibe ou não exibe o item do pedido na importação do pedido de compras
Chamado pelo PE MT103VPC

@param		Nenhum 
@return		Lógico = Exibe ou não exibe o item do pedido na importação do pedido de compras
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA11()
	LOCAL lRet	:= .T.
	
	//-----------------------------------------------------------------------
	// Se o pedido de compras não estiver aprovado e
	// não foi originado pelo RM
	//-----------------------------------------------------------------------
	IF SC7->C7_XSFLUIG <> 'A' .AND. ALLTRIM(SC7->C7_ORIGEM) <> 'MSGEAI'  
		lRet := .F.
	ENDIF
	
RETURN lRet