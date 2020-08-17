#include "rwmake.ch"
#include "topconn.ch"



User Function  CSUFIN11(_cPref)      

_aArea := {}

_aArea := GetArea()

_cRet := "INFORMAR CONTA"

_cPref := ALLTRIM(_cPref)

_cQuery := " SELECT Z1_CCONTAB AS CONTA  FROM SZ1010 WHERE D_E_L_E_T_ <> '*' "
_cQuery += " AND Z1_GRUPOCC IN ( '01' , '00') AND Z1_NATUREZ = '"+_cPref+"' AND Z1_FILIAL = '' "
_cQuery += " ORDER BY Z1_CCONTAB "

If Select("_FIN11") >0
	DBSelectArea("_FIN11")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "_FIN11"

DBSelectArea("_FIN11")
DBGotop()

If !EOF()
	
	_cRet := ALLTRIM(_FIN11->CONTA)
	
EndIf

DBSelectArea("_FIN11")
DBCloseArea()

RestArea(_aArea)

Return(_cRet)


