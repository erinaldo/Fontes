#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA30()

Adiciona botão para executar a transferência do portador e situação em 
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
	// Executa a transferência do portador e situação em lote
	//-----------------------------------------------------------------------
	AADD( aROTINA, { "Transferir em lote" , "U_ASFINA31"  , 0 , 2} )

RETURN