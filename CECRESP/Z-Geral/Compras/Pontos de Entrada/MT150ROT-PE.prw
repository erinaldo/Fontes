#INCLUDE 'Rwmake.ch'
#INCLUDE 'AP5Mail.ch'
#INCLUDE "Protheus.Ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT150ROT()

Adiciona mais opções no aRotina

LOCALIZAÇÃO   : Function MATA150 - Função da atualização de cotações. 

EM QUE PONTO  : No inico da rotina e antes da execução da Mbrowse da 
                cotação, utilizado para adicionar mais opções no aRotina.

@param		Nenhum
@return		aRotina (Rotinas adicionadas)
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------


USER FUNCTION MT150ROT()

	//-----------------------------------------------------------------------
	// Adiciona o botao no browse da rotina "Atualiza cotacao" Enviar e-mail 
	//-----------------------------------------------------------------------
	U_ASCOMA31()

Return aRotina