#include "rwmake.ch"  

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA26()

Retorna o valor do documento do codigo de barra da posição 06 - 19
Cnab Bradesco a Pagar (PagFor) - (POSICAO 190-204)
quando o código de barras for informado no SE2

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_VALOR - Valor do documento
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA26() 

SetPrvt("_VALOR,")

_VALOR :=Replicate("0",15)

IF SUBSTR(SE2->E2_CODBAR,1,3) == "   "
    _VALOR   :=  STRZERO((SE2->E2_SALDO*100),15,0)
Else
    _VALOR  :=  "0" + SUBSTR(SE2->E2_CODBAR,6,14)
Endif

Return(_VALOR)