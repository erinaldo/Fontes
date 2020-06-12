#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120BRW()

Adiciona botões à rotina

LOCALIZAÇÃO : Function MATA120 - Função do Pedido de Compras e Autorização 
de Entrega.

EM QUE PONTO : Após a montagem do Filtro da tabela SC7 e antes da execução 
da Mbrowse do PC, utilizado para adicionar mais opções no aRotina.
 
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
	// Adiciona botões à rotina do PC - Gerar Contrato no RM TOP
	//-----------------------------------------------------------------------
	U_ASCOMA24()
	
RETURN