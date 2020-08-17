#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA24()

Adiciona botões à rotina do pedido de compra - Gerar Contrato no RM TOP
Chamado pelo PE MT120BRW

@param		Nenhum 
@return		Nenhum 
@author 	Fabio Cazarini
@since 		27/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA24()

	aAdd(aRotina,{ "Gerar Contrato no TOP", "U_ASCOMA25", 0 , 2})	
	
RETURN