#INCLUDE "rwmake.ch"

// *** Rotina de valida��o da inclus�o da Natureza Financeira em T�tulos a Receber.
// *** Data: 13/03/2002

User Function CSUFIN04()

DbSelectArea("SED")
DbSetOrder(1)

If DbSeek ( xFilial("SED") + M->E1_NATUREZ )

   If SED->ED_TPNAT <> "A"
   	   MsgAlert("Somente Naturezas Financeiras ANALITICAS podem ser amarradas a T�tulos !!!","Atencao!")
 	   Return .f.
   EndIf
  
   If SED->ED_RECDEP <> "R"
	   MsgAlert("Somente Naturezas Financeiras de RECEITA podem ser amarradas a T�tulos a Receber !!!","Atencao!")
	   Return .f.
   EndIf

Endif   

Return .t.