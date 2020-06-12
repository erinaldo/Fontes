#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MA120BUT()

Adiciona Bot�es no Pedido de Compras

LOCALIZA��O : Function A120PEDIDO - Fun��o do Pedido de Compras e 
Autoriza��o de Entrega responsavel pela inclus�o, altera��o, exclus�o e 
c�pia dos PCs. 

EM QUE PONTO : No inico da Fun��o, antes de&nbsp;montar a&nbsp;ToolBar 
do Pedido de Compras, deve ser usado para adicionar bot�es do usuario na 
toolbar do PC ou AE atrav�s do retorno de um Array com a estrutura do 
bot�o a adicionar.

@param		Nenhum 
@return		AButtUser(vetor) = Bot�es de usu�rio no PC
@author 	Fabio Cazarini
@since 		01/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MA120BUT()
	LOCAL AButtUser := {}
	
	//-----------------------------------------------------------------------
	// Adiciona bot�o para alterar o contrato do pedido de compras na AFG
	//-----------------------------------------------------------------------
	AButtUser := U_ASCOMA37(AButtUser)
	
RETURN AButtUser