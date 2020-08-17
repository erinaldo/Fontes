#INCLUDE "rwmake.ch"

// *** Rotina de validação da inclusão da Natureza Financeira em Títulos a Receber.
// *** Data: 13/03/2002

User Function CSUFIN04()

DbSelectArea("SED")
DbSetOrder(1)

If DbSeek ( xFilial("SED") + M->E1_NATUREZ )

   If SED->ED_TPNAT <> "A"
   	   MsgAlert("Somente Naturezas Financeiras ANALITICAS podem ser amarradas a Títulos !!!","Atencao!")
 	   Return .f.
   EndIf
  
   If SED->ED_RECDEP <> "R"
	   MsgAlert("Somente Naturezas Financeiras de RECEITA podem ser amarradas a Títulos a Receber !!!","Atencao!")
	   Return .f.
   EndIf

Endif   

Return .t.