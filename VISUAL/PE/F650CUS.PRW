#INCLUDE "PROTHEUS.CH"

User Function F650CUS()

Local lCustodia := .F.

If Alltrim(MV_PAR02) $ "custodia.ret" .and. SubStr(xBuffer,140,2) == "06" .and. SubStr(xBuffer,1,1) == "0"
	lCustodia := .T.
EndIf

Return(lCustodia)