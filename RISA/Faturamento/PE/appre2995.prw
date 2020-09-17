#INCLUDE "TOTVS.CH"

/*/

{Protheus.doc} OM010TOK
                 
Ponto de entrada para validar condicao de pagamento em itens de freira

@author  Milton J.dos Santos	
@since   22/07/20
@version 1.0

/*/

User Function OM010TOK
Loca lRet := .T.

lRet := U_TABFEIRA( M->DA0_CONDPG )

Return lRet
