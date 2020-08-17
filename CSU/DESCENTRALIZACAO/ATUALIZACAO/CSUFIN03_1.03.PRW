#INCLUDE "rwmake.ch"

// *** Rotina de validação da inclusão da Natureza Financeira em Títulos a Pagar.
// *** Data: 13/03/2002

User Function CSUFIN03( cNaturez )

DbSelectArea("SED")
DbSetOrder(1)

If DbSeek ( xFilial("SED") + cNaturez )

   If SED->ED_TPNAT <> "A"
  	  MsgAlert("Somente Naturezas Financeiras ANALITICAS podem ser amarradas a Títulos !!!","Atencao!")
 	  Return .f.
   EndIf
  
   If !(SED->ED_RECDEP $ "DP")
      MsgAlert("Somente Naturezas Financeiras de DESPESA/PATRIMONIAL podem ser amarradas a Títulos a Pagar !!!","Atencao!")
  	  Return .f.
   EndIf
   
Endif

Return .t.