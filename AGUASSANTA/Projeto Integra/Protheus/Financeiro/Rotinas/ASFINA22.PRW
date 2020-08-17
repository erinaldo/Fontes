#include "rwmake.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA22()

Informa o CNPJ/CPF do Fornecedor 
Cnab Bradesco a Pagar (PagFor) - 3 - 17

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_cCgc - CNPJ
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA22()

_cCgc := "0"+Left(SA2->A2_CGC,8)+Substr(SA2->A2_CGC,9,4)+Right(SA2->A2_CGC,2)

If SA2->A2_TIPO <> "J" 
   _cCgc := Left(SA2->A2_CGC,9)+"0000"+Substr(SA2->A2_CGC,10,2)
Endif

Return(_cCgc)
