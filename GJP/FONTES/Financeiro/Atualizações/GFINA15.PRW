#include "rwmake.ch"    

User Function GFINA15()  //PAGFOR

SetPrvt("_RetDat,")

////  CONSIDERA DATA EFETIVA DO PAGAMENTO 
/// POS - 266 A 273

If empty(SE2->E2_DATAAGE)
  _RetDat := DTOS(SE2->E2_VENCREA)
   else
  _RetDat := DTOS(SE2->E2_DATAAGE)
Endif 
   
Return(_RetDat)
