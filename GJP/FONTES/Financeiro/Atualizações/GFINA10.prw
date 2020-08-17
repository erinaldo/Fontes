#include "rwmake.ch"        

//IDENTIFICAÇÃO DA CARTEIRA - POS 136-138

User Function GFINA10() //PAGFOR
   
SetPrvt("_RETCAR,")

If SubStr(SE2->E2_CODBAR,1,3) == "237"
    _RetCar := StrZero(Val(SubStr(SE2->E2_CODBAR,24,2)),3)
Else
	_RetCar := "000"
EndIf

Return(_Retcar)       