#include "rwmake.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA25()

Retorna o tipo da conta do fornecedor, de acordo com o tipo de bordero
Cnab Bradesco a Pagar (PagFor) - (POSICAO 479 - 479)

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_aTipoCC - Tipo da Conta
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA25()

Private _aTipoCC := "0"			// VALOR PADRAO QUE SÓ DEVERÁ SER INFORMADO CASO SEJA DEPOSITO EM CONTA

/*
If SEA->EA_MODELO=="01"	   		// CREDITO EM C/C
	_aTipoCC := "1"
ElseIF SEA->EA_MODELO=="05"		// CREDITO EM CONTA POUPANCA
	_aTipoCC := "2"
Endif
*/


If SE2->E2_FORMPAG=="01"	   		// CREDITO EM C/C
	_aTipoCC := "1"
ElseIF SE2->E2_FORMPAG=="05"		// CREDITO EM CONTA POUPANCA
	_aTipoCC := "2"
Endif



Return(_aTipoCC)