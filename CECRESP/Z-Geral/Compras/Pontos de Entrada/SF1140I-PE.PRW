#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} SF1140I

PE utilizado na atualiza��o do cabe�alho do Pr�-Documento de Entrada

@param		Nenhum 
@return		L�gico = Se OK
@author 	Zema
@since 		19/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function SF1140I()
	
	Local cArea	:= GetArea()
	
	// Atualiza os dados do PC caso seja integra��o com o TOP - Dedu��es do Pedido - Zema 19/09/17	
	U_ASTOP204()
	
	RestArea(cArea)
	
Return()
