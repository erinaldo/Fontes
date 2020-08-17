#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} M030INC()

Ponto de entrada na inclusão de clientes
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		26/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function M030INC()
                                                                        
IF PROCNAME(2) == "MA030TRANS"                                                                        
                                                                        
	// Gera o cadastro de itens contábeis com o CNPJ do fornecedor / cliente
	U_ASCTBA11("SA1")
ENDIF

Return
