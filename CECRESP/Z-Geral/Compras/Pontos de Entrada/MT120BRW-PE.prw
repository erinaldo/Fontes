#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120BRW()

Adiciona bot�es � rotina

LOCALIZA��O : Function MATA120 - Fun��o do Pedido de Compras e Autoriza��o 
de Entrega.

EM QUE PONTO : Ap�s a montagem do Filtro da tabela SC7 e antes da execu��o 
da Mbrowse do PC, utilizado para adicionar mais op��es no aRotina.
 
@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		27/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT120BRW()

	//-----------------------------------------------------------------------
	// Adiciona bot�es � rotina do PC - Gerar Contrato no RM TOP
	//-----------------------------------------------------------------------
	U_ASCOMA24()
	
RETURN