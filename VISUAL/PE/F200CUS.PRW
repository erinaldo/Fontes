#INCLUDE "PROTHEUS.CH"

User Function F200CUS()

Local lCustodia := .F.   
Local Buffer    := PARAMIXB //PARAMIXB[1] 
Local _cArqConf := ALLTRIM(MV_PAR05) 
//Local _cPerg    := ALLTRIM(MV_PAR04)
                                                                      	
If _cArqConf $ "custodia.ret" .and. SubStr(BUFFER,140,2) == "06" .and. SubStr(BUFFER,1,1) == "0" //.and.  (_cPerg $ "CR" .OR. _cPerg $ "cr") Validação que não funciona
	lCustodia := .T.
EndIf

Return(lCustodia)