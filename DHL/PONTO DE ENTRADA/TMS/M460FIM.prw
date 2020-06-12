
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  07/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM

lRet      := .T.
_aAreaSD2 := GetArea()

If IsInCallStack("U_DTMS004")
	If alltrim(SF2->F2_ESPECIE) == "CTE"
		
		_xCFOP	:= X8_XCFOP //POSICIONE("SF4",1,XFILIAL("SF4")+SD2->D2_TES,"F4_CF")

		RecLock("SD2",.F.)
		SD2->D2_CF := _xCFOP
		MsUnLock()
		
		RecLock("SF3",.F.)
		SF3->F3_CFO     := _xCFOP
		SF3->F3_CHVNFE  := IIF(alltrim(X6_CODNFE) == "102", "", X6_CHVCTE) //Codigo de CT-e Inutilizado. Para esses casos a Chave tem que ser Branca
		SF3->F3_CODRSEF := X6_CODNFE
		MsUnLock()
		
		RecLock("SFT",.F.)
		SFT->FT_CFOP    := _xCFOP
		SFT->FT_CHVNFE  := IIF(alltrim(X6_CODNFE) == "102", "", X6_CHVCTE) //Codigo de CT-e Inutilizado. Para esses casos a Chave tem que ser Branca
		MsUnLock()
		
		If ALLTRIM(DT6->DT6_DOCTMS) == "8" //Complementar
			RecLock("SF2",.F.)
			SF2->F2_TIPO := "C"
			MsUnLock()
			
			RecLock("SD2",.F.)
			SD2->D2_TIPO := "C"
			MsUnLock()
			
			RecLock("SF3",.F.)
			SF3->F3_TIPO := "C"
			MsUnLock()
			
			RecLock("SFT",.F.)
			SFT->FT_TIPO := "C"
			MsUnLock()
		EndIf
	EndIf
EndIf

RestArea(_aAreaSD2)
Return(lRet)