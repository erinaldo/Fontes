#Include 'Protheus.ch'

User Function F590COK()

_cTipoBord	:= PARAMIXB[1] //Tipo de Bordero ("P" - Pagar / "R" - Receber)
_cBordero	:= PARAMIXB[2] //Numero do Bordero
_lRet		:= .T.

If _cTipoBord = "P"
	If SE2->E2_XSTSAPV = "2" //Aprovado
		msginfo("Registro esta Aprovado não pode tirar do Bordero")
		_lRet		:= .F.		
	ElseIf SE2->E2_XSTSAPV = "3" // Reprovado
		_lRet		:= .T.
	EndIf
EndIf

Return(_lRet)