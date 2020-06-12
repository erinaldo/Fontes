#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120GOK()

Tratamento no PC antes de sua contabiliza��o

LOCALIZA��O : Function A120PEDIDO - Fun��o do Pedido de Compras e 
Autoriza��o de Entrega responsavel pela inclus�o, altera��o, exclus�o e 
c�pia dos PCs.

EM QUE PONTO : Ap�s a execu��o da fun��o de grava��o A120GRAVA e antes da 
contabiliza��o do Pedido de compras / AE, Pode ser utilizado para qualquer 
tratamento que o usuario necessite realizar no PC antes da contabiliza��o 
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
	LOCAL l120Inclui	:= PARAMIXB[2]	// Inclus�o?
	LOCAL l120Altera	:= PARAMIXB[3]	// Altera��o?
	LOCAL l120Deleta	:= PARAMIXB[4]	// Exclus�o?
			
	//-----------------------------------------------------------------------
	// Gera a solicita��o no Fluig
	//-----------------------------------------------------------------------
	U_ASCOMA01(cA120Num, l120Inclui, l120Altera, l120Deleta)
	
RETURN