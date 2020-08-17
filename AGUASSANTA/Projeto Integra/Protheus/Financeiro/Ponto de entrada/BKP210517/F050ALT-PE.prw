#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F050ALT()

Valida alteração

O ponto de entrada F050ALT é utilizado para validação pós confirmação de 
alteração, executado antes de atualizar saldo do fornecedor.

@param		nOpca	=		Número da opção selecionada na janela de alteração
@return		Nenhum
@author 	Fabio Cazarini
@since 		04/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F050ALT()
	LOCAL nOpca := PARAMIXB[1]
	
	//-----------------------------------------------------------------------
	// Gera alçada de aprovação do título a pagar na tabela SZ5 e envia ao 
	// Fluig para aprovação
	//-----------------------------------------------------------------------
	U_ASFINA01(nOpca)

RETURN