/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WPlReajS  ºAutor  ³Aline Catarina      º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o campo podera ser alterado                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Manutencao no Gestao de Contratos                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                
User Function WPlReajS()
	Local lRet     := .T.
	Local aArea    := GetArea()
    Local cTipoCon := ""
    Local cContrat := ""
    Local dDataCont:= ""
                             
    If AllTrim(M->CNA_CONTRA) != ""                         
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CNA")+M->CNA_CONTRA+M->CNA_REVISA)
			cTipoCon := CN9->CN9_TPCTO
			cContrat := CN9->CN9_CTRT
			dDataCont:= CN9->CN9_DTINIC
		Else  
			cTipoCon := M->CN9_TPCTO
			cContrat := M->CN9_CTRT
			dDataCont:= M->CN9_DTINIC	
		EndIf                                           
	
		If dDataCont < dDataBase
			DbSelectArea("CN1")
			DbSetOrder(1)       
			If DbSeek(xFilial("CN1")+cTipoCon) .And. ((CN1->CN1_MEDEVE == "1") .And. (cContrat == "2"))
				lRet := .F.
			EndIf
		Else
			lRet := .F.
		EndIf             	
    EndIf
	RestArea(aArea)	
Return lRet                      
