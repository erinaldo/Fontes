#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOME05  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOME05(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SCR->(GetArea())}
Local lRet := .T.
Local nTotal := 0
Local dEmissao := dDataBase
Local lEstorna := .T.
Local cStatus := ""
Local nI := 0
Local c120GrpApr := ""

/*DbSelectArea("SC7")
SC7->(DbSetOrder(1))
If (SC7->(DbSeek(cPC)))
	While ((SC7->(!Eof())) .And. (cPC == SC7->C7_FILIAL + SC7->C7_NUM))
		nTotal += SC7->C7_TOTAL
		dEmissao := SC7->C7_EMISSAO
		c120GrpApr := SC7->C7_APROV

		SC7->(DbSkip())
	Enddo
Endif*/

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	nTotal := SZ1->Z1_TOTAL
	c120GrpApr := SZ1->Z1_GRPAPRV
Endif

DbSelectArea("SCR")
SCR->(DbSetOrder(1))

/*If !(INCLUI)
	If (SCR->(DbSeek(xFilial("SCR") + "CV" + cNum)))
		If (ALTERA)
			If (SCR->CR_TOTAL >= nTotal)
				lEstorna := .F.
			Endif
		Endif
		
		If (lEstorna)
			MaAlcDoc({cNum, "CV", nTotal, , , , , 1, 0, }, dEmissao, 3)
		Else
			While ((SCR->(!Eof())) .And. ;
					(SCR->CR_FILIAL == xFilial("SCR")) .And. ;
					(AllTrim(SCR->CR_NUM) == AllTrim(cNum)) .And. ;
					(SCR->CR_TIPO == "CV"))
				RecLock("SCR", .F.)
				SCR->CR_TOTAL := nTotal
				SCR->(MsUnlock())
				
				SCR->(DbSkip())
			Enddo
		Endif
		
		cStatus := _fVerifCV(cNum)

		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		If (SZ1->(DbSeek(cFil + cNum)))
			While ((SZ1->(!Eof())) .And. (cFil == SZ1->Z1_FILIAL) .And. (cNum == SZ1->Z1_NUM))
				RecLock("SZ1", .F.)
				SZ1->Z1_STATUS := cStatus
				SZ1->(MsUnlock())
		
				SZ1->(DbSkip())
			Enddo
		Endif
	Endif
Endif*/

If !(SCR->(DbSeek(xFilial("SCR") + "CV" + cNum)))
	MaAlcDoc({cNum, "CV", nTotal, , , c120GrpApr, , 1, 1, dEmissao}, , 1) 
Endif

/*If ((INCLUI) .Or. (ALTERA))
	If !(SCR->(DbSeek(xFilial("SCR") + "CV" + SubStr(cPC, TamSX3("C7_FILIAL")[1] + 1, TamSX3("C7_NUM")[1]))))
		MaAlcDoc({SubStr(cPC, TamSX3("C7_FILIAL")[1] + 1, TamSX3("C7_NUM")[1]), "CV", nTotal, , , c120GrpApr, , 1, 1, dEmissao}, , 1) 
	Endif
Endif*/

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOME05  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fVerifCV(cDoc)
Local cRet := "Q"

DbSelectArea("SCR")
SCR->(DbSetOrder(1))
SCR->(DbSeek(xFilial("SCR") + "CV" + cDoc))

While ((SCR->(!Eof())) .And. ;
		(SCR->CR_FILIAL == xFilial("SCR")) .And. ;
		(SCR->CR_TIPO == "CV") .And. ;
		(AllTrim(SCR->CR_NUM) == AllTrim(cDoc))) 
	If (SCR->CR_STATUS $ "03|05")
		cRet := "L"
	Elseif (SCR->CR_STATUS $ "04")
		cRet := "B"
	Elseif (SCR->CR_STATUS $ "02")
		cRet := "Q"
	Endif
	
	SCR->(DbSkip())
Enddo
Return(cRet)