#include "rwmake.ch"

User Function CBDIM01()

_aArea  := GetArea()
_cAlias := Alias()
_lRet   := .T.

If _cAlias == "SZS"
	If M->ZS_ENDPAD == "1" //SIM
		DbSelectArea("SZT")
		DbSetOrder(1)
		If DbSeek(xFilial("SZT")+SZS->ZS_CODCONT)
			Do While SZT->ZT_CODCONT == SZS->ZS_CODCONT
				If Alltrim(SZT->ZT_END) == Alltrim(SZS->ZS_END) .and. SZT->ZT_ENDPAD == "1"
					msgbox("Endereco ja e padrao para uma Entidade")
					_lRet := .F.
					Exit
				EndIf
				DbSelectArea("SZT")
				DbSkip()
			EndDo
		EndIf
	EndIf
ElseIf _cAlias == "SZT"
	DbSelectArea("SZT")
	DbSetOrder(1)
	If DbSeek(xFilial("SZT")+CCODIGO)
		If M->ZT_ENDPAD == "1" //SIM
			DbSelectArea("SZS")
			DbSetOrder(4)
			If DbSeek(xFilial("SZS")+SZT->ZT_CODCONT)
				Do While SZS->ZS_CODCONT == SZT->ZT_CODCONT
					If Alltrim(SZS->ZS_END) == Alltrim(SZT->ZT_END) .and. SZS->ZS_ENDPAD == "1"
						msgbox("Endereco ja e padrao para um Contato")
						_lRet := .F.
						Exit
					EndIf
					DbSelectArea("SZS")
					DbSkip()
				EndDo
			EndIf
		EndIf
	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)