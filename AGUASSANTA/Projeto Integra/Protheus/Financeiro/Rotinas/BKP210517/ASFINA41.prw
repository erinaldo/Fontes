#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA41()

Adiciona botão para :
Executar a transferência do portador e situação em lote
Executar a baixa a receber de parceiros

Chamado pelo PE FA740BRW e FI040ROT

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		22/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA41(aRotina)

	//-----------------------------------------------------------------------
	// Executa a transferência do portador e situação em lote
	//-----------------------------------------------------------------------
	AADD( aRotina, { "Transferir em lote" 	, "U_ASFINA31"  , 0 , 2} )
	AADD( aRotina, { "Baixa de parceiros" 	, "U_ASFINA13"  , 0 , 2} )
	AADD( aRotina, { "Gera part. parceiros" , "U_ASFINA50"  , 0 , 2} )
	
RETURN aRotina