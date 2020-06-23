#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F241MARK  ³ Autor ³ TOTVS                ³ Data ³ 12/09/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ O ponto entrada F240MARK altera as posições dos            ±±
±±³ campos de tela MarkBrowse fonte                                        ±±
±±³±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³Sintaxe   ³							           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F241MARK()
Local aArea := GetArea()
Local aRet  := PARAMIXB
Local cTitulo := ""
Local aRetReturn := {}

If !Empty(aRet)

	AADD(aRetReturn,aRet[1]) //E2_OK - Tem que ser sempre o primeiro Campo 
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("E2_XORDLIB")
		cTitulo := X3Titulo()
	EndIf
	AADD(aRetReturn,{"E2_XORDLIB","",cTitulo,""})
	
	If DbSeek("E2_DATALIB")
		cTitulo := X3Titulo()
	EndIf
	AADD(aRetReturn,{"E2_DATALIB","",cTitulo,""})
	
	For _nY := 2 to len(aRet)
		AADD(aRetReturn,aRet[_nY])
	Next _nY

Else
	Return aRet
EndIf

RestArea(aArea)

Return aRetReturn