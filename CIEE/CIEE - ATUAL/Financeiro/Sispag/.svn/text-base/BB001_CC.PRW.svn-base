#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

User Function BB001_CC()

If Alltrim(SEA->EA_PORTADO) == "104"
	_cTxt := "0003"+STRZERO(Val(Substr(SEA->EA_NUMCON,1,(At("-",SEA->EA_NUMCON)-1))),08)
Else
	_cTxt := STRZERO(Val(Substr(SEA->EA_NUMCON,1,(At("-",SEA->EA_NUMCON)-1))),12)
EndIf

Return(_cTxt)