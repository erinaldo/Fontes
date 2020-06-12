
User Function xAjSE2()


Processa({|| RunCont() },"Processando...")

Return

Static Function RunCont()

DbSelectArea("SE2")
DbSetOrder(6) //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
DbGotop()
ProcRegua(RecCount())

Do While !Eof()

	IncProc()
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA))
		RecLock("SE2",.F.)
		SE2->E2_RAZSOC	:= SA2->A2_NOME
		MsUnLock()
	EndIf

	DbSelectArea("SE2")
	DbSkip()

EndDo


Return