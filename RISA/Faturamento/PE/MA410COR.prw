#Include "protheus.ch"

/*/

{Protheus.doc} MA410COR
                 
Ponto de Entrada

@author  Milton J.dos Santos	
@since   15/07/20
@version 1.0

/*/

User Function MA410COR()
Local aCoresPE := ParamIXB

// E importante destacar que, ao utilizar este ponto de entrada, voce sera o responsavel por priorizar a validacao para cada 
// caracteri≠stica da legenda, de forma a existir apenas 01 condicao verdadeira.
// Caso contrario, sua customizacao pode n√£o ter o resultado esperado.

AADD(aCoresPE,{"C5_BLQ == 'X' .AND. C5_XAVAL <> 'R'"    , "BR_BRANCO"   , "Pedido Bloqueado no Comercial"})
AADD(aCoresPE,{"C5_BLQ == 'X' .AND. C5_XAVAL == 'R'"    , "BR_PRETO"    , "Pedido Bloqueado no Comercial REPROVADO"})
AADD(aCoresPE,{"C5_BLQ == 'Y' .AND. C5_XAVALG <> 'R'"   , "BR_CINZA"    , "Pedido Bloqueado na Garantia"})
AADD(aCoresPE,{"C5_BLQ == 'Y' .AND. C5_XAVALG == 'R'"   , "BR_PINK"     , "Pedido Bloqueado na Garantia REPROVADO"})

ASORT(aCoresPE, , , { | x,y | x[3] > y[3] } )

Return aCoresPE
