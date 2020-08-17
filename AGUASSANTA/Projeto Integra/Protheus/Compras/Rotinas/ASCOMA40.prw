#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA40()

Libera a Solicitação de Compra

@param		Nenhum
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		02/02/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA40()

RECLOCK("SC1", .F.) //Alteração
	SC1->C1_APROV := "L"
SC1->(MsUnlock())

RETURN 