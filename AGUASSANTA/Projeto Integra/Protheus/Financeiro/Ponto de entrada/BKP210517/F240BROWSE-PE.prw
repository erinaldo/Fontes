#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F240BROWSE()


@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		22/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F240BROWSE()
	LOCAL cCondicao
	
	//-----------------------------------------------------------------------
	// Adiciona o item Altera filial pagadora
	//-----------------------------------------------------------------------
	U_ASFINA05(@aRotina)
	
RETURN cCondicao