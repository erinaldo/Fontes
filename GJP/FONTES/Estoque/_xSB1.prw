User Function _xSB1

_aArea   := GetArea()
MV_PAR01 := "C:\TEMP\SB1xSF4.txt"
If (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	Help(" ",1,"NOFILE")
	Return
EndIf

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

_nLi	  := 1 //Linhas processadas
_lProc   := .F.

//Inicio Processamento arquivo
Do While !FT_FEOF()
	_cBuffer := FT_FREADLN()

	IncProc("Numero de Linhas "+ alltrim(strzero(_nLi,6)))
	
	cCod := substr(_cBuffer,1,at(";",_cBuffer)-1)
	cTES := substr(_cBuffer,at(";",_cBuffer)+1)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cCod)
		RecLock("SB1",.F.)
		SB1->B1_TS := cTES
		MsUnLock()
	EndIf

	_nLi++
	FT_FSKIP()
	
EndDo

FT_FUSE()

Return