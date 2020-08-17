#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F060BROW()

Prevalida��o de dados
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
	// Adiciona bot�o para executar a transfer�ncia do portador e situa��o 
	// em lote
	//-----------------------------------------------------------------------
	U_ASFINA30()
		
RETURN