#include "rwmake.ch"
#include "protheus.ch"

User Function MT100TOK

_lRet	:= .T.

If l103Class //Quando clicar em Classifica��o da Nota Fiscal
	If SF1->F1_XSTATUS == "B"
		_lRet	:= .F.
		msgbox("Pre-Nota n�o aprovada. Necessario aprova��o do Solicitante!!!")
	EndIf
EndIf

Return(_lRet)