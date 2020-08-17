#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA30()

Adiciona bot�o para executar a transfer�ncia do portador e situa��o em 
lote

Chamado pelo PE F060BROW

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		08/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA30()

	//-----------------------------------------------------------------------
	// Executa a transfer�ncia do portador e situa��o em lote
	//-----------------------------------------------------------------------
	AADD( aROTINA, { "Transferir em lote" , "U_ASFINA31"  , 0 , 2} )

RETURN