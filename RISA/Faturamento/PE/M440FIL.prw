#INCLUDE "TOTVS.CH"

/*/

{Protheus.doc} M440FIL
                 
Filtra os Pedidos de Venda na rotina de Liberacao do Pedido de Venda (MATA440)

@author  Milton J.dos Santos	
@since   21/09/2020
@version 1.0

/*/

User Function M440FIL

Local cFiltroUsr := " .not. (C5_BLQ $ 'XY') "

Return( cFiltroUsr )
