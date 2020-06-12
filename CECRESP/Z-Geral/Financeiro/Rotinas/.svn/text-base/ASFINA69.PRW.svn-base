#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA69()
Executado via PE F340BROW, para filtrar os titulos no Browse liberados para compensação 
titulos a pagar está liberado 
 
@param		Nenhum
@return		cFiltro
@author 	Zema
@since 		05/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA69
Local cFiltro := " E2_XSFLUIG = 'A' .OR. E2_XSFLUIG = ' ' "
Local bCondic :=  { || E2_XSFLUIG = 'A' .OR. E2_XSFLUIG = ' ' }
DBSELECTAREA("SE2")
DBSETFILTER(bCondic,cFiltro)
RETURN