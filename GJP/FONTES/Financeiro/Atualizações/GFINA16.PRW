#include "rwmake.ch"     

User Function GFINA16()   //PAGFOR


SetPrvt("_Doc,_Mod,")

/////  PROGRAMA GRAVAR AS INFORMACOES COMPLEMENTARES
/////  CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (374-413)
//_Mod := SUBSTR(SEA->EA_MODELO,1,2)

_Mod := SUBSTR(SEA->EA_MODELO,1,2)


DO CASE
   CASE _Mod == "01" .or. _Mod == "05"
        _Doc := space(40)
   CASE _Mod == "03" .OR. _Mod == "07" .OR. _Mod == "08" .OR. _Mod == "41"  .or. _Mod == "43" 
        _Doc := IIF(SA2->A2_CGC==SM0->M0_CGC,"D","C")+"000000"+"01"+"0"+"1"+SPACE(29)
   CASE _Mod == "31"  //trata boletos de todos os bancos
        _Doc := SUBSTR(SE2->E2_CODBAR,20,25)+SUBSTR(SE2->E2_CODBAR,5,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
   CASE _Mod == "30"
        _Doc := SUBSTR(SE2->E2_CODBAR,20,25)+SUBSTR(SE2->E2_CODBAR,5,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
ENDCASE

Return(_Doc)   

