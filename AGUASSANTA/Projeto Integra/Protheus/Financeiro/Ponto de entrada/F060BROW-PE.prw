#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F060BROW()

Prevalidação de dados
O ponto de entrada F060BROW sera executado antes da Mbrowse prevalidando 
os dados a serem exibidos.

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		08/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F060BROW()

	//-----------------------------------------------------------------------
	// Adiciona botão para executar a transferência do portador e situação 
	// em lote
	//-----------------------------------------------------------------------
	U_ASFINA30()
		
RETURN