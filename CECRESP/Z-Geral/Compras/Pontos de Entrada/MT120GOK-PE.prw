#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120GOK()

Tratamento no PC antes de sua contabilização

LOCALIZAÇÃO : Function A120PEDIDO - Função do Pedido de Compras e 
Autorização de Entrega responsavel pela inclusão, alteração, exclusão e 
cópia dos PCs.

EM QUE PONTO : Após a execução da função de gravação A120GRAVA e antes da 
contabilização do Pedido de compras / AE, Pode ser utilizado para qualquer 
tratamento que o usuario necessite realizar no PC antes da contabilização 
do mesmo.

@param		PARAMIXB	= Array contendo: { cA120Num , l120Inclui, l120Altera, l120Deleta } 
@return		Nenhum
@author 	Fabio Cazarini
@since 		26/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT120GOK()
	LOCAL cA120Num		:= PARAMIXB[1]	// Numero do Pedido de Compras
	LOCAL l120Inclui	:= PARAMIXB[2]	// Inclusão?
	LOCAL l120Altera	:= PARAMIXB[3]	// Alteração?
	LOCAL l120Deleta	:= PARAMIXB[4]	// Exclusão?
			
	//-----------------------------------------------------------------------
	// Gera a solicitação no Fluig
	//-----------------------------------------------------------------------
	U_ASCOMA01(cA120Num, l120Inclui, l120Altera, l120Deleta)
	
RETURN