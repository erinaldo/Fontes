#include "rwmake.ch"
#include "protheus.ch"

User Function FA090TIT()

_lRet := .T.

If E2_PORTADO <> ParamIxb[1]
	_lRet := .F.
	MsgBox("O Titulo "+ALLTRIM(E2_NUM)+ " do Bordero "+Alltrim(E2_NUMBOR)+" nao pertence ao banco selecionado!!!")
Else
	_lRet := .T.
EndIf

Return(_lRet)