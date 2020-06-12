#include "rwmake.ch"


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA19()

Programa para retornar o codigo do banco do fornecedor.
Cnab a Pagar Bradesco (Posições 096 - 098)

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_cBanco = Banco de fornecedor
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA19()

Private _cBanco := ""

/*
If SUBSTR(SE2->E2_CODBAR,1,3) == "   "
	_cBanco := SUBSTR(SA2->A2_BANCO,1,3)
Else
*/

If SUBSTR(SE2->E2_CODBAR,1,3) == "   "
	_cBanco := SUBSTR(SE2->E2_FORBCO,1,3)
Else
	_cBanco := SUBSTR(SE2->E2_CODBAR,1,3)
Endif

Return(_cBanco)        