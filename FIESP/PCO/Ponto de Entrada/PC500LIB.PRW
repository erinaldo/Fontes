#include "protheus.ch"

Static aCntgBak	:= {} // Backup de Contingencias

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PC500LIB  ºAutor  ³Microsiga           º Data ³  09/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE chamado apos liberacao da Contingencia                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11 - FIESP                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PC500LIB()
Local _cNumCt   := ALI->ALI_CDCNTG
Local _aResult  := {}
Local _aAreaAtu := GetArea()
Local _aAreaALI := ALI->(GetArea())
Local cFil      := ""
Local cNum      := ""
Local lLib      := .T.

If (ALI->ALI_PROCESS == "900001")
	SZ8->(DbSetOrder(2))
	If !(SZ8->(DbSeek(xFilial("SZ8") + _cNumCt)))
		Return()
	Endif
	
	ALI->(dbsetorder(1))
	If ALI->(dbSeek(xFilial("ALI") + _cNumCt))
		_cAreaALI := ALI->(GetArea())
		While ALI->(!Eof()) .and. ALI->ALI_FILIAL == XFilial("ALI") .and. ALI->ALI_CDCNTG == _cNumCt
			IF !(ALI->ALI_STATUS $ "03/05")
				Aadd(_aResult, ALI->ALI_NOME)
			ENDIF
			ALI->(dbSkip())
		EndDo
		RestArea(_cAreaALI)
	EndIf
	
	IF Len(_aResult) == 0 // Liberado
		_cMail := UsrRetMail(SZ7->Z7_USUSOL)
		_cBody := "Prezado "+UsrRetName(SZ7->Z7_USUSOL)+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody += "Sua contigência Nr. "+ALI->ALI_CDCNTG+" foi aprovada."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody += "Data da Aprovação : "+Dtoc(dDataBase)+"  -  Hora : "+Time()+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		ACSendMail( ,,,,_cMail,"Contig. "+ALI->ALI_CDCNTG+" (APROVADA)",_cBody)

		dbSelectArea("ALJ")
		dbSetOrder(1)
		dbSeek( xFilial("ALJ") + _cNumCt )
		
		While ALJ->(!Eof()) .and. ALJ->ALJ_FILIAL == XFilial("ALJ") .and. ALJ->ALJ_CDCNTG == _cNumCt
			
			aAreaAKD := AKD->(GetArea())
			
			DbSelectArea("ALJ")
			cChave := Padr("ALJ"+&(IndexKey())+ "02",Len(AKD->AKD_CHAVE))
			
			_fPCOLib(cChave)
			
			RestArea(aAreaAKD)
			
			ALJ->(dbSkip())
		Enddo
		
		cFil := xFilial("SZ8")
		
		PcoIniLan("900001")
		DbSelectArea("SZ8")
		SZ8->(DbSetOrder(2))
		If (SZ8->(DbSeek(cFil + _cNumCt)))
				DbSelectArea("SZ7")
				SZ7->(DbSetOrder(1))
				SZ7->(DbSeek(cFil + SZ8->Z8_NUMSC))
				
				PcoDetLan('900001','01','FIGCTX01')
				
				cNum := SZ8->Z8_NUMSC
				
				RecLock("SZ8", .F.)
				SZ8->Z8_CONTLIB := .T.
				SZ8->(MsUnlock())
		Endif
		PcoFinLan("900001")
		
		DbSelectArea("SZ8")
		SZ8->(DbSetOrder(1))
		If (SZ8->(DbSeek(cFil + cNum)))
			While ((SZ8->(!Eof())) .And. (cFil == SZ8->Z8_FILIAL) .And. (cNum == SZ8->Z8_NUMSC))
				If !(SZ8->Z8_CONTLIB)
					lLib := .F.
				Endif
			
				SZ8->(DbSkip())
			Enddo
		Endif
		
		If (lLib)
			DbSelectArea("SZ7")
			SZ7->(DbSetOrder(1))
			If (SZ7->(DbSeek(cFil + cNum)))
				// Atualiza status da Solicitacao de Contrato
				RecLock("SZ7",.F.)
				SZ7->Z7_STATUS := '4' // Aguardando Aprovação
				SZ7->(MsUnlock())   
		
				PcoIniLan('900001')
				PcoDetLan('900001','01','FIGCTX01')
				PcoFinLan('900001')
				
				MsgRun("Gerando Alçada. Aguarde... ","",{|| U_GCTE01Scr() })
				//If !(Empty(SZ1->Z1_GRPAPRV))
				//	U_FICOME05(cFil, cNum)
				//	
				//	RecLock("SZ1", .F.)
				//	SZ1->Z1_STATUS := "Q"
				//	SZ1->(MsUnlock())
				//Else
				//	RecLock("SZ1", .F.)
				//	SZ1->Z1_STATUS := "Y"
				//	SZ1->(MsUnlock())
				//Endif
			Endif
		Endif
	Endif
	
	/*// Verifica se é lançamento de Solicitação de Contrato
	//IF ALI->ALI_PROCESS <> "900001"
	//	Return()
	//ENDIF
	
	SZ7->(dbSetOrder(2))
	IF !SZ7->(dbSeek(XFilial("SZ7")+_cNumCt))
		Return()
	ENDIF
	
	ALI->(dbsetorder(1))
	If ALI->(dbSeek(xFilial("ALI") + _cNumCt))
		_cAreaALI := ALI->(GetArea())
		While ALI->(!Eof()) .and. ALI->ALI_FILIAL == XFilial("ALI") .and. ALI->ALI_CDCNTG == _cNumCt
			IF !(ALI->ALI_STATUS $ "03/05")
				Aadd(_aResult, ALI->ALI_NOME)
			ENDIF
			ALI->(dbSkip())
		EndDo
		RestArea(_cAreaALI)
	EndIf
	
	IF Len(_aResult) == 0 // Liberado
		
		_cMail := UsrRetMail(SZ7->Z7_USUSOL)
		_cBody := "Prezado "+UsrRetName(SZ7->Z7_USUSOL)+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody += "Sua contigência Nr. "+ALI->ALI_CDCNTG+" foi aprovada."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody += "Data da Aprovação : "+Dtoc(dDataBase)+"  -  Hora : "+Time()+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		ACSendMail( ,,,,_cMail,"Contig. "+ALI->ALI_CDCNTG+" (APROVADA)",_cBody)
		
		dbSelectArea("ALJ")
		dbSetOrder(1)
		dbSeek( xFilial("ALJ") + _cNumCt )
		
		While ALJ->(!Eof()) .and. ALJ->ALJ_FILIAL == XFilial("ALJ") .and. ALJ->ALJ_CDCNTG == _cNumCt
			
			aAreaAKD := AKD->(GetArea())
			
			DbSelectArea("ALJ")
			cChave := Padr("ALJ"+&(IndexKey())+ "02",Len(AKD->AKD_CHAVE))
			
			_fPCOLib(cChave)
			
			RestArea(aAreaAKD)
			
			ALJ->(dbSkip())
		Enddo
		
		// Atualiza status da Solicitacao de Contrato
		RecLock("SZ7",.F.)
		SZ7->Z7_STATUS := '4' // Aguardando Aprovação
		SZ7->(MsUnlock())   
		
		PcoIniLan('900001')
		PcoDetLan('900001','01','FIGCTX01')
		PcoFinLan('900001')
	
		// Gera Alçada
		MsgRun("Gerando Alçada. Aguarde... ","",{|| U_GCTE01Scr() })
		
	Endif*/
Elseif (ALI->ALI_PROCESS == "900002")
	SZ0->(DbSetOrder(2))
	If !(SZ0->(DbSeek(xFilial("SZ0") + _cNumCt)))
		Return()
	Endif
	
	ALI->(dbsetorder(1))
	If ALI->(dbSeek(xFilial("ALI") + _cNumCt))
		_cAreaALI := ALI->(GetArea())
		While ALI->(!Eof()) .and. ALI->ALI_FILIAL == XFilial("ALI") .and. ALI->ALI_CDCNTG == _cNumCt
			IF !(ALI->ALI_STATUS $ "03/05")
				Aadd(_aResult, ALI->ALI_NOME)
			ENDIF
			ALI->(dbSkip())
		EndDo
		RestArea(_cAreaALI)
	EndIf
	
	IF Len(_aResult) == 0 // Liberado
		dbSelectArea("ALJ")
		dbSetOrder(1)
		dbSeek( xFilial("ALJ") + _cNumCt )
		
		While ALJ->(!Eof()) .and. ALJ->ALJ_FILIAL == XFilial("ALJ") .and. ALJ->ALJ_CDCNTG == _cNumCt
			
			aAreaAKD := AKD->(GetArea())
			
			DbSelectArea("ALJ")
			cChave := Padr("ALJ"+&(IndexKey())+ "02",Len(AKD->AKD_CHAVE))
			
			_fPCOLib(cChave)
			
			RestArea(aAreaAKD)
			
			ALJ->(dbSkip())
		Enddo
		
		cFil := xFilial("SZ0")
		
		PcoIniLan("900002")
		DbSelectArea("SZ0")
		SZ0->(DbSetOrder(2))
		If (SZ0->(DbSeek(cFil + _cNumCt)))
				DbSelectArea("SZ1")
				SZ1->(DbSetOrder(1))
				SZ1->(DbSeek(cFil + SZ0->Z0_NUMSV))
				
				PcoDetLan("900002", "01", "FICDVA01")
				
				cNum := SZ0->Z0_NUMSV
				
				RecLock("SZ0", .F.)
				SZ0->Z0_CONTLIB := .T.
				SZ0->(MsUnlock())
		Endif
		PcoFinLan("900002")
		
		DbSelectArea("SZ0")
		SZ0->(DbSetOrder(1))
		If (SZ0->(DbSeek(cFil + cNum)))
			While ((SZ0->(!Eof())) .And. (cFil == SZ0->Z0_FILIAL) .And. (cNum == SZ0->Z0_NUMSV))
				If !(SZ0->Z0_CONTLIB)
					lLib := .F.
				Endif
			
				SZ0->(DbSkip())
			Enddo
		Endif
		
		If (lLib)
			DbSelectArea("SZ1")
			SZ1->(DbSetOrder(1))
			If (SZ1->(DbSeek(cFil + cNum)))
				If !(Empty(SZ1->Z1_GRPAPRV))
					U_FICOME05(cFil, cNum)
					
					RecLock("SZ1", .F.)
					SZ1->Z1_STATUS := "Q"
					SZ1->(MsUnlock())
				Else
					RecLock("SZ1", .F.)
					SZ1->Z1_STATUS := "Y"
					SZ1->(MsUnlock())
				Endif
			Endif
		Endif
	Endif
Endif

RestArea(_aAreaAtu)
RestArea(_aAreaALI)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCO500LIB ºAutor  ³Microsiga           º Data ³  08/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11 - SISTEMA INDUSTRIA                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fPCOLib(cChave)

AKD->(dbSetOrder(10))
IF AKD->(dbSeek(xFilial("AKD") + cChave ))
	// Utilizado para recuperar lançamentos caso processo seja cancelado
	PcoBackupAKD(aCntgBak)
	PcoIniLan("000356",.F.)
	PcoDetLan("000356","02","PCOA530",.T.)
	PcoFinLan("000356",,,.F.)
ENDIF

// O PcoIniLan deve ser repetido para nao dar erro de UNQ no Recall do Empenho
PcoIniLan("000356",.F.)
PcoDetLan("000356","01","PCOA530")
DbSelectArea("ALJ")// Utilizado para apagar lançamento caso processo seja cancelado
cChave := Padr("ALJ"+&(IndexKey())+ "01",Len(AKD->AKD_CHAVE))

AKD->(dbSetOrder(10))
IF AKD->(dbSeek(xFilial("AKD") + cChave ))
	aAdd(aCntgBak, { AKD->(Recno()), {} } )
EndIf
PcoFinLan("000356",,,.F.)

Return()
