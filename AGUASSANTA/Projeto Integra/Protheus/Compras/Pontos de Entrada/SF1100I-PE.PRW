#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} SF1100I()

Ponto de entrada na gravação do documento de entrada - MATA103

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		19/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION SF1100I

	// Atualiza os dados do PC caso seja integração com o TOP - Deduções do Pedido - Zema 19/09/17
	IF TYPE("l103Class") <> "U"
		If !l103Class
			U_ASTOP101()
		ENDIF
	ENDIF	
	// Atualiza os dados do PC caso seja integração com o TOP - Deduções do Pedido - Zema 19/09/17
	U_ASTOP204()
	
RETURN