#include "rwmake.ch"
#include "protheus.ch"

User Function MT100TOK

_lRet	:= .T.

If l103Class //Quando clicar em Classificação da Nota Fiscal
	If SF1->F1_XSTATUS == "B"
		_lRet	:= .F.
		msgbox("Pre-Nota não aprovada. Necessario aprovação do Solicitante!!!")
	EndIf
EndIf

Return(_lRet)