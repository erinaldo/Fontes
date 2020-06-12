#include "rwmake.ch"
#include "protheus.ch"

User Function FIXVALMNAT()

_lRet	:= .T.

_nPosNaturez	:= ascan(aHeader, {|x| AllTrim(x[2]) == "EV_NATUREZ"})
_nPosxCompet	:= ascan(aHeader, {|x| AllTrim(x[2]) == "EV_XCOMPET"})
                                                                       
For _nI := 1 to Len(aCols)
	If Substr(Alltrim(aCols[_nI,_nPosNaturez]),1,4) $ "0401|0402" .or.  Substr(Alltrim(aCols[_nI,_nPosNaturez]),1,4) $ "6.10|6.11"
		If Empty(Alltrim(aCols[_nI,_nPosxCompet]))
			_lRet	:= .F.
			msgbox("O item "+strzero(_nI,4)+" esta sem competencia!!!")
			Exit
		EndIf
	EndIf
Next

Return(_lRet)