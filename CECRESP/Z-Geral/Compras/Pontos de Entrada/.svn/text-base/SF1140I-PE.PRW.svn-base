#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} SF1140I

PE utilizado na atualização do cabeçalho do Pré-Documento de Entrada

@param		Nenhum 
@return		Lógico = Se OK
@author 	Zema
@since 		19/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function SF1140I()
	
	Local cArea	:= GetArea()
	
	// Atualiza os dados do PC caso seja integração com o TOP - Deduções do Pedido - Zema 19/09/17	
	U_ASTOP204()
	
	RestArea(cArea)
	
Return()
