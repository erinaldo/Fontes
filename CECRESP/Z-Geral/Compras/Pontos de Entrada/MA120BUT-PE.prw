#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MA120BUT()

Adiciona Botões no Pedido de Compras

LOCALIZAÇÃO : Function A120PEDIDO - Função do Pedido de Compras e 
Autorização de Entrega responsavel pela inclusão, alteração, exclusão e 
cópia dos PCs. 

EM QUE PONTO : No inico da Função, antes de&nbsp;montar a&nbsp;ToolBar 
do Pedido de Compras, deve ser usado para adicionar botões do usuario na 
toolbar do PC ou AE através do retorno de um Array com a estrutura do 
botão a adicionar.

@param		Nenhum 
@return		AButtUser(vetor) = Botões de usuário no PC
@author 	Fabio Cazarini
@since 		01/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MA120BUT()
	LOCAL AButtUser := {}
	
	//-----------------------------------------------------------------------
	// Adiciona botão para alterar o contrato do pedido de compras na AFG
	//-----------------------------------------------------------------------
	AButtUser := U_ASCOMA37(AButtUser)
	
RETURN AButtUser