#include "rwmake.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA23()

Informa a modalidade de pagamento
Cnab Bradesco a Pagar (PagFor) - 264 - 265

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_aModel - Modalidade de Pagamento
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA23()

Private _aModel := ""

/*
IF SEA->EA_MODELO$"01/02/03/05" 	// CREDITO EM C.C. / CHEQUE / DOC / CREDITO EM CONTA POUPANCA ou REAL TIME
	_aModel := SEA->EA_MODELO
ELSEIF SEA->EA_MODELO$"43"		// TED MESMA TITULARIDADE
	_amodel := "07"
ELSEIF SEA->EA_MODELO$"41"		// TED OUTRA TITULARIDADE
	_amodel := "08"
ELSE
	_aModel := "31"		// TITULO SEM RASTREAMENTO
ENDIF
*/


IF SE2->E2_FORMPAG$"01/02/03/05" 	// CREDITO EM C.C. / CHEQUE / DOC / CREDITO EM CONTA POUPANCA ou REAL TIME
	_aModel := SE2->E2_FORMPAG
ELSEIF SE2->E2_FORMPAG$"43"		// TED MESMA TITULARIDADE
	_amodel := "07"
ELSEIF SE2->E2_FORMPAG$"41"		// TED OUTRA TITULARIDADE
	_amodel := "08"
ELSE
	_aModel := "31"		// TITULO SEM RASTREAMENTO
ENDIF


Return(_aModel)       