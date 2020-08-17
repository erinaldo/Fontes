

User Function _xSBZ

DbSelectArea("SBZ")
DbSetOrder(1)
DbGotop()

Do While SBZ->(!EOF())

	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+SBZ->BZ_COD)
		RecLock("SBZ",.F.)
		SBZ->BZ_XDESCRI := SB1->B1_DESC
		SBZ->BZ_XLEGADO := SB1->B1_XLEGADO
		MsUnLock()
	EndIf

	SBZ->(DbSkip())

EndDo
Return