#INCLUDE 'protheus.ch'

/*/

{Protheus.doc} MA410LEG
                 
Ponto de Entrada

@author  Milton J.dos Santos	
@since   15/07/20
@version 1.0

/*/

User Function MA410LEG()

Local aLegenda := PARAMIXB

//aLegenda := {}
AADD(aLegenda,{"BR_BRANCO"  , "Pedido Bloqueado no Comercial"})
AADD(aLegenda,{"BR_PRETO"   , "Pedido Bloqueado no Comercial REPROVADO"})
AADD(aLegenda,{"BR_CINZA"   , "Pedido Bloqueado na Garantia"})
AADD(aLegenda,{"BR_PINK"    , "Pedido Bloqueado na Garantia REPROVADO"})
ASORT(aLegenda, , , { | x,y | x[2] > y[2] } )

Return(aLegenda)
