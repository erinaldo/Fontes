#include "rwmake.ch" 

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA24()

Retorna o nosso numero quando o valor no E2_CODBAR, e zeros quando não
tem valor.
Cnab Bradesco a Pagar (PagFor) - 139 - 150

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_RETNOS - Nosso numero
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA24()

SetPrvt("_RETNOS,")

IF SUBS(SE2->E2_CODBAR,01,3) != "237"
    _RETNOS := "000000000000"
Else           
    _RETNOS := "0"+SUBS(SE2->E2_CODBAR,26,11)
EndIf

Return(_RETNOS)