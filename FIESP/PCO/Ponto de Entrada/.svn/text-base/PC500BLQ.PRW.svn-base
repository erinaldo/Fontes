#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPC500BLQ  บAutor  ณMicrosiga           บ Data ณ  09/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE chamado apos reprova็ใo da Contingencia                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PC500BLQ()
Local _cNumCt   := ALI->ALI_CDCNTG
Local _aResult  := {}
Local _aAreaAtu := GetArea()
Local _aAreaALI := ALI->(GetArea())

If (ALI->ALI_PROCESS == "900001")
	SZ8->(DbSetOrder(2))
	If !(SZ8->(DbSeek(xFilial("SZ8") + _cNumCt)))
		Return()
	Else
		cNum := SZ8->Z8_NUMSc
	Endif
	
	dbSelectArea("ALI")
	_cFilter := dbFilter()
	SET FILTER TO
	
	_cMot := PC500Mot() // Chama tela para cadastrar o Motivo do Cancelamento.
	
	_cMail := UsrRetMail(SZ7->Z7_USUSOL)
	_cBody := "Prezado "+UsrRetName(SZ7->Z7_USUSOL)+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Sua contig๊ncia Nr. "+ALI->ALI_CDCNTG+" foi reprovada."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Data da Reprova็ใo : "+Dtoc(dDataBase)+"  -  Hora :"+Time()+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Motivo:"+Chr(13)+Chr(10)
	_cBody += _cMot
	ACSendMail( ,,,,_cMail,"Contig. "+ALI->ALI_CDCNTG+" (REPROVADA)",_cBody)
	
	// Estorno das contingencias
	dbSelectArea("ALJ")
	dbSetOrder(1)
	dbSeek( xFilial("ALJ") + _cNumCt )
	
	While ALJ->(!Eof()) .and. ALJ->ALJ_FILIAL == XFilial("ALJ") .and. ALJ->ALJ_CDCNTG == _cNumCt
		
		PcoIniLan("000356")
		PcoDetLan("000356","01","PCOA530",.T.) // Deleta Empenho caso exista
		PcoDetLan("000356","02","PCOA530",.T.) // Deleta Empenho caso exista
		PcoFinLan("000356")
		
		ALJ->(dbSkip())
	Enddo

	DbSelectArea("SZ7")
	SZ7->(DbSetOrder(1))
	SZ7->(DbSeek(xFilial("SZ7") + cNum))
	
	// Atualiza status da Solicitacao de Contrato
	RecLock("SZ7",.F.)
	SZ7->Z7_STATUS := '3' // Or็amento Reprovado
	SZ7->Z7_OBSPCO := _cMot
	SZ7->(MsUnlock())
	
	// Exclui os saldos Solicita็ใo caso exista
	PcoIniLan('900001')
	PcoDetLan('900001','01','FIGCTX01',.T.)
	PcoFinLan('900001')
	
	// Restaura Filtro
	SET FILTER TO &_cFilter
	
	/*
	// Verifica se ้ lan็amento de Solicita็ใo de Contrato
	//IF ALI->ALI_PROCESS <> "900001"
	//	Return()
	//ENDIF
	
	SZ7->(dbSetOrder(2))
	IF !SZ7->(dbSeek(XFilial("SZ7")+_cNumCt))
		Return()
	ENDIF
	
	dbSelectArea("ALI")
	_cFilter := dbFilter()
	SET FILTER TO
	
	_cMot := PC500Mot() // Chama tela para cadastrar o Motivo do Cancelamento.
	
	_cMail := UsrRetMail(SZ7->Z7_USUSOL)
	_cBody := "Prezado "+UsrRetName(SZ7->Z7_USUSOL)+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Sua contig๊ncia Nr. "+ALI->ALI_CDCNTG+" foi reprovada."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Data da Reprova็ใo : "+Dtoc(dDataBase)+"  -  Hora :"+Time()+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Motivo:"+Chr(13)+Chr(10)
	_cBody += _cMot
	ACSendMail( ,,,,_cMail,"Contig. "+ALI->ALI_CDCNTG+" (REPROVADA)",_cBody)
	
	// Estorno das contingencias
	dbSelectArea("ALJ")
	dbSetOrder(1)
	dbSeek( xFilial("ALJ") + _cNumCt )
	
	While ALJ->(!Eof()) .and. ALJ->ALJ_FILIAL == XFilial("ALJ") .and. ALJ->ALJ_CDCNTG == _cNumCt
		
		PcoIniLan("000356")
		PcoDetLan("000356","01","PCOA530",.T.) // Deleta Empenho caso exista
		PcoDetLan("000356","02","PCOA530",.T.) // Deleta Empenho caso exista
		PcoFinLan("000356")
		
		ALJ->(dbSkip())
	Enddo
	
	// Atualiza status da Solicitacao de Contrato
	RecLock("SZ7",.F.)
	SZ7->Z7_STATUS := '3' // Or็amento Reprovado
	SZ7->Z7_OBSPCO := _cMot
	SZ7->(MsUnlock())
	
	// Exclui os saldos Solicita็ใo caso exista
	PcoIniLan('900001')
	PcoDetLan('900001','01','FIGCTX01',.T.)
	PcoFinLan('900001')
	
	// Restaura Filtro
	SET FILTER TO &_cFilter*/
Elseif (ALI->ALI_PROCESS == "900002")
	SZ0->(DbSetOrder(2))
	If !(SZ0->(DbSeek(xFilial("SZ0") + _cNumCt)))
		Return()
	Else
		cNum := SZ0->Z0_NUMSV
	Endif
	
	dbSelectArea("ALI")
	_cFilter := dbFilter()
	SET FILTER TO
	
	// Estorno das contingencias
	dbSelectArea("ALJ")
	dbSetOrder(1)
	dbSeek( xFilial("ALJ") + _cNumCt )
	
	While ALJ->(!Eof()) .and. ALJ->ALJ_FILIAL == XFilial("ALJ") .and. ALJ->ALJ_CDCNTG == _cNumCt
		
		PcoIniLan("000356")
		PcoDetLan("000356","01","PCOA530",.T.) // Deleta Empenho caso exista
		PcoDetLan("000356","02","PCOA530",.T.) // Deleta Empenho caso exista
		PcoFinLan("000356")
		
		ALJ->(dbSkip())
	Enddo

	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	SZ1->(DbSeek(xFilial("SZ1") + cNum))
	
	RecLock("SZ1", .F.)
	SZ1->Z1_STATUS := "R"
	SZ1->(MsUnlock())
	
	PcoIniLan("900002")
	PcoDetLan("900002", "01", "FICDVA01", .T.)
	PcoFinLan("900002")
	
	// Restaura Filtro
	SET FILTER TO &_cFilter
Endif

RestArea(_aAreaAtu)
RestArea(_aAreaALI)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPC500Mot  บAutor  ณ TOTVS              บ Data ณ  29/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para Gerar o Motivo do cancelamento do Pedido de     บฑฑ
ฑฑบ          ณContingencia  .                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PC500Mot()
Local oOK
Local oGet
Local cGet := Space(60)
Local oMot
Local cRet
Static oDlg

DEFINE MSDIALOG oDlg TITLE "Motivo da Reprova็ใo" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL

@006,010 SAY oMot PROMPT "Motivo da Reprova็ใo:" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
@015,010 MSGET oGet VAR cGet SIZE 174, 030 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL
@050,152 BUTTON oOK PROMPT "OK" SIZE 031, 019 OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

If !Empty(cGet)
	cRet := cGet
Else
	cRet:= " "
EndIf

Return(cRet)
