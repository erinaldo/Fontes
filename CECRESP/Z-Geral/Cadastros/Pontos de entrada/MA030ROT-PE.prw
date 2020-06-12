#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MA030ROT()

INCLUSÃO DE NOVAS ROTINAS NO CADASTRO DE CLIENTES

@param		Nenhum
@return		aRotAdic = Adiciona rotinas ao aRotina
@author 	Fabio Cazarini
@since 		04/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MA030ROT()
	LOCAL aRotAdic	:= {}
	
	//-----------------------------------------------------------------------
	// Adiciona Importação de clientes via CSV no menu do cadastro de clientes
	//-----------------------------------------------------------------------
	aRotAdic := U_ASCADA03(aRotAdic)
	
RETURN aRotAdic