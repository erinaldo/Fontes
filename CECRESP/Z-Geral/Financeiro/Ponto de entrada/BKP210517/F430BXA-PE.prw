#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F430BXA()

O ponto de entrada F430BXA tem como finalidade gravar complemento das 
baixas CNAB a pagar do retorno bancario.

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		08/10/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F430BXA()

	//-----------------------------------------------------------------------
	// Mútuo de pagamentos:
	// - Baixa o título origem por dação 
	//-----------------------------------------------------------------------
	U_ASFINA42()
	
RETURN