

User Function _xAtuSC8

Processa({|| RunProc()}, "Atualiza SC8 Usuarios")

Return


Static Function RunProc()


DbSelectArea("SC8")
DbSetOrder(1)
DbGotop()
ProcRegua(RecCount())

Do While !EOF()

	IncProc()

	DbSelectArea("SC1")
	DbSetOrder(1)
	If DbSeek(xFilial("SC1")+SC8->C8_NUMSC)
		_cSolicit	:= SC1->C1_SOLICIT
	Else
		DbSelectArea("SC8")
		DbSkip()
		Loop
	
	EndIf

	RecLock("SC8",.F.)
	SC8->C8_SOLICIT := _cSolicit
	MsUnLock()

	DbSelectArea("SC8")
	DbSkip()

EndDo



Return