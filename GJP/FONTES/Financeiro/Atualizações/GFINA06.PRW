#include "rwmake.ch"     

//POS - 003 A 017 //PAGFOR
User Function GFINA06()

_cCgc := "0"+Left(SA2->A2_CGC,8)+Substr(SA2->A2_CGC,9,4)+Right(SA2->A2_CGC,2)

If SA2->A2_TIPO <> "J" 
   _cCgc := Left(SA2->A2_CGC,9)+"0000"+Substr(SA2->A2_CGC,10,2)
Endif

Return(_cCgc)