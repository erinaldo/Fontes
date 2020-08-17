

User Function _xSG1

DbSelectArea("SG1")
DbSetOrder(1)
DbGotop()

Do While SG1->(!EOF())

	DbSelectArea("SBZ")
	DbSetOrder(1)
	If DbSeek(xFilial("SBZ")+SG1->G1_COMP) .AND. SG1->G1_XCUSTO == "1"
		RecLock("SBZ",.F.)
		SBZ->BZ_FANTASM := "N"
		MsUnLock()
	ElseIf DbSeek(xFilial("SBZ")+SG1->G1_COMP) .AND. SG1->G1_XCUSTO == "2"
		RecLock("SBZ",.F.)
		SBZ->BZ_FANTASM := "S"
		MsUnLock()
	EndIf
	
	SG1->(DbSkip())

EndDo
Return