#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MA030ROT()

INCLUSÃO DE NOVAS ROTINAS NO CADASTRO DE CLIENTES

@param		aRotAdic = Rotinas do menu de clientes
@return		aRotAdic = Adiciona rotinas ao aRotina
@author 	Fabio Cazarini
@since 		04/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCADA03(aRotAdic)
	
	AAdd( aRotAdic, { "Importação de clientes via CSV", "U_ASCADA01", 2, 0 } )
	
RETURN aRotAdic