#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA60TRAN()

Rotina de Transferência de contas a receber

O ponto de entrada FA60TRAN será executado ao final da rotina de 
transferência de contas a receber, após gravação de dados e da 
contabilização.

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		12/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA60TRAN()

	//-----------------------------------------------------------------------
	// At. campo p/informar se o tit. é securitizado e gera fluxo de caixa
	//-----------------------------------------------------------------------
	U_ASFINA32()
	
RETURN