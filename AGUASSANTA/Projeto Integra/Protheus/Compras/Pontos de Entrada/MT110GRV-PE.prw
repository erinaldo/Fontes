#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT110GRV()

LOCALIZAÇÃO : Function A110GRAVA - Função da Solicitação de Compras 
responsavel pela gravação das SCs.

EM QUE PONTO : No laco de gravação dos itens da SC na função A110GRAVA, 
executado após gravar o item da SC, a cada item gravado da SC o ponto é 
executado.

@param		Nenhum 
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		02/02/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT110GRV()
lExp1 :=  PARAMIXB[1]

U_ASCOMA40()// Função utilizada para liberar as solicitações de compra 

Return

