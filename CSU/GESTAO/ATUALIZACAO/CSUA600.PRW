#INCLUDE "CNTA200.CH"
#INCLUDE "PROTHEUS.CH"

//Situacoes de contrato
#DEFINE DEF_SCANC "01" //Cancelado
#DEFINE DEF_SELAB "02" //Em Elaboracao
#DEFINE DEF_SEMIT "03" //Emitido                                           
#DEFINE DEF_SAPRO "04" //Em Aprovacao
#DEFINE DEF_SVIGE "05" //Vigente
#DEFINE DEF_SPARA "06" //Paralisado
#DEFINE DEF_SSPAR "07" //Sol Fina.
#DEFINE DEF_SFINA "08" //Finalizado
#DEFINE DEF_SREVS "09" //Revisao
#DEFINE DEF_SREVD "10" //Revisado

//Transacoes
#DEFINE DEF_TRAINC "007"//Inclusao de Planilhas
#DEFINE DEF_TRAEDT "008"//Edicao de Planilhas
#DEFINE DEF_TRAEXC "009	"//Exclusao de Planilhas
#DEFINE DEF_TRAVIS "032"//Visualizacao de Planilhas

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CSUA600  ³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de cadastro das planilhas de contrato               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSUA600()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSUA600()
Private cCadastro := OemToAnsi(STR0001) //Cadastro de Caucoes
Private aRotina := MenuDef()
mBrowse(6,1,22,75,"CNA")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600Manut³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de manutencao do cadastro de planilhas              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600Manut(cExp01,nExp02,nExp03,lExp04,lExp05,aExp06,aExp07³±±
±±³          ³            ,cExp08,cExp09,dExp10,dExp11)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Alias do arquivo                                  ³±±
±±³          ³ nExp02 - Registro selecionado                              ³±±
±±³          ³ nExp03 - Opcao selecionada pelo usuario                    ³±±
±±³          ³ lExp04 - Exibe campos referentes a revisao do tipo reali.  ³±±
±±³          ³ lExp05 - Exibe campos referentes a revisao do tipo readq.  ³±±
±±³          ³ aExp06 - Array com os cabecalhos de planilhas              ³±±
±±³          ³ aExp07 - Array com os itens das planilhas                  ³±±
±±³          ³ cExp08 - Codigo do contrato                                ³±±
±±³          ³ cExp09 - Numero de identificacao da planilha               ³±±
±±³          ³ dExp10 - Data de inicio do contrato                        ³±±
±±³          ³ dExp11 - Data de termino do contrato                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600Manut(cAlias,nReg,nOpc,xFiller,lReali,lReadq,aPlani,aPlIt,cContra,cPlani,dInicio,dTermino)
Local aArea     := GetArea()
Local l200SCC   := ExistBlock("CTA200SCC")
Local l200PLN   := ExistBlock("CTA200PLN")
Local nA        := 0
Local nPosCampo := 0
Local oDlg
Local oGetDados
Local aCpoEnch  := {}
Local nOpca     := 0
Local lRet      := .T.
Local aButtons  := {}
Local cFilCod
Local nTotCronog
Local nPos
Local nPlan
Local nx          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de variaveis de tela    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aHeader     := {}
Local aCols       := {}
Local nUsado      := 0
Local aSize     := MsAdvSize(,.F.,430)
Local aObjects  := {}
Local aPosObj   := {}
Local aRetPE    := {}
Local lCopiaReg:=nOpc == 6 // Identifica quando utiliza copia de registros

//Variaveis usadas pela consulta especifica
PRIVATE lContrEd  := (aPlani != Nil)
PRIVATE lBxCNT    := .F.
PRIVATE dCN9FIM   := dTermino

Private aTela[0][0]
Private aGets[0]

Default lReali := .F.
Default lReadq := .F.

// Troca opcao de copia para opcao de inclusao
If lCopiaReg
	nOpc:=3
EndIf

if nOpc != 3 .And. nOpc != 2 .And. !lContrEd
	lRet := CN240VldUsr(CNA->CNA_CONTRA,If(nOpc==4,DEF_TRAEDT,DEF_TRAEXC),.T.)
	
	If lRet
		dbSelectArea("CN9")
		dbSetOrder(1)
		dbSeek(xFilial("CN9")+CNA->CNA_CONTRA+CNA->CNA_REVISA)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o contrato aceita exclusao/inclusao ³
		//³ de planilhas                                    ³
		//³  - 2 - Elaboracao                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if AllTrim(CN9->CN9_SITUAC) != DEF_SELAB .AND. AllTrim(CN9->CN9_SITUAC) != DEF_SEMIT .AND. AllTrim(CN9->CN9_SITUAC) != DEF_SAPRO
			Help(" ",1,"CNTA200SIT") //"Situação de contrato inválida para exc/inc de planilhas"
			lRet := .F.
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a planilha possui cronograma e se   ³
		//³ o mesmo possui medicoes                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. !Empty(CNA->CNA_CRONOG)
			dbSelectArea("CNF")
			dbSetOrder(1)
			
			cFilCod := xFilial("CNF")
			If dbSeek(cFilCod+CNA->CNA_CRONOG)
				While CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG
					If !Empty(CNF->CNF_DTREAL)
						Help(" ",1,"CSUA600SEL") //"A planilha selecionada não pode ser alterada/excluída pois possui medições já efetuadas"
						lRet := .F.
						Exit
					EndIf
					dbSkip()
				EndDo
			EndIf
		EndIf
	EndIf
EndIF

If nOpc == 2 .And. Empty(aPlani)
	lRet := CN240VldUsr(CNA->CNA_CONTRA,DEF_TRAVIS,.T.)
EndIf

If lRet
	dbSelectArea("SX3")
	MsSeek("CNA")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona os campos do cabecalho das planilhas     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. SX3->X3_ARQUIVO == "CNA"
		
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CAMPO != "CNA_FILIAL" .And. SX3->X3_CAMPO != "CNA_ESPEL" .And. SX3->X3_CAMPO != "CNA_CRONOG" .And. SX3->X3_CAMPO != "CNA_DTMXMD"
			Aadd(aCpoEnch, SX3->X3_CAMPO )
		EndIF
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	RegToMemory("CNA",(nOpc == 3 .And.!lCopiaReg))
	// Na copia de registros "Limpa" dados 
	If lCopiaReg
		M->CNA_CONTRA	:=Criavar("CNA_CONTRA",.F.)
		M->CNA_NUMERO:=Criavar("CNA_NUMERO",.F.)
		M->CNA_REVISA:=Criavar("CNA_REVISA",.F.)
		M->CNA_FORNEC	:=Criavar("CNA_FORNEC",.F.)
		M->CNA_LJFORN:=Criavar("CNA_LJFORN",.F.)
		M->CNA_DTINI:=Criavar("CNA_DTINI",.F.)
		M->CNA_DTFIM	:=Criavar("CNA_DTFIM",.F.)
		M->CNA_CRONOG:=Criavar("CNA_CRONOG",.F.)
		M->CNA_ESPEL:=Criavar("CNA_ESPEL",.F.)
		M->CNA_DTMXMD:=Criavar("CNA_DTMXMD",.F.)
	EndIf
	If lContrEd
		nPlan := aScan(aPlani,{|x| x[CNA->(FieldPos("CNA_NUMERO"))] == cPlani})
		If nPlan > 0
			For na:=1 to len(aCpoEnch)
				nPos := CNA->(FieldPos(aCpoEnch[na]))
				If nPos > 0
					M->&(aCpoEnch[na]) := aPlani[nPlan,nPos]
				EndIf
			Next
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve o tamanho da tela atualmente no micro do usuario.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aSizeAut := MsAdvSize()
	
	Aadd(aObjects, { 100,  70, .T., .T. } )
	Aadd(aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 }
	aPosObj := MsObjSize(aInfo, aObjects)
	
	aHeader := u_CS600GerHd(nOpc,lReadq,lReali,lContrEd)
	nUsado  := len(aHeader)
	
	If nOpc != 3 .Or. lCopiaReg
		If !lContrEd
			cFilCod := xFilial("CNB")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta o aCols.                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNB")
			dbSetOrder(1)
			MsSeek(cFilCod + CNA->CNA_CONTRA + CNA->CNA_REVISA + CNA->CNA_NUMERO)
			
			While CNB->CNB_FILIAL == cFilCod .And. CNB->CNB_CONTRA == CNA->CNA_CONTRA .And.;
				CNB->CNB_REVISA == CNA->CNA_REVISA .And. CNB->CNB_NUMERO == CNA->CNA_NUMERO  .And. !Eof()
				Aadd(aCols, Array(nUsado + 1))
				
				For nA := 1 To Len(aHeader)
					If aHeader[nA][10] <> "V"
						nPosCampo := FieldPos(aHeader[nA][2])
						
						If !Empty(nPosCampo)
							aCols[Len(aCols)][nA] := FieldGet(nPosCampo)
						EndIf
					Else
						aCols[Len(aCols)][nA] := CriaVar(aHeader[nA][2])
					EndIf
				Next nA
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atribui .F. p/ a coluna que determina se a linha do aCols esta deletada.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCols[Len(aCols)][nUsado + 1] := .F.
				
				dbSelectArea("CNB")
				dbSkip()
			EndDo
		ElseIf nPlan > 0
			aCols := aPlIt[nPlan]
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada para manipulacao do aHeader e do Acols ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l200PLN
		aRetPE := ExecBlock("CTA200PLN",.F.,.F.,{nOpc,aClone(aHeader),aClone(aCols)})
		If Valtype(aRetPE) == "A"
			If ValType(aRetPE[1]) == "A"
            	aHeader := aRetPE[1]
            Endif
   			If ValType(aRetPE[2]) == "A"
            	aCols := aRetPE[2]
            Endif
        Endif    
	Endif	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada para tratamento do campo centro de custo na solicitacao compras.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l200SCC
		aFields :=	ExecBlock ("CTA200SCC",.F.,.F.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona botoes para importacao de SC                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc == 3 .Or. nOpc == 4
		aadd(aButtons,{"SOLICITA",{|| if(u_CS600CabOk(aCpoEnch,@oDlg),u_CS600SC(oGetDados),) },OemToAnsi(STR0008),OemToAnsi(STR0010)})	      //"Solicitacoes"
		aadd(aButtons,{"PEDIDO2",{|| if(u_CS600CabOk(aCpoEnch,@oDlg),u_CS600SCIt(oGetDados),) },OemToAnsi(STR0009),OemToAnsi(STR0011)})//"Solicitacoes por item"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Botao para exportar dados para EXCEL                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction("RemoteType") .And. RemoteType() == 1
		aAdd(aButtons   , {PmsBExcel()[1],{|| DlgToExcel({ {"ENCHOICE",STR0036,aGets,aTela},{"GETDADOS",OemToAnsi(STR0037),aHeader,aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
	EndIf
	
	If aRotina[ nOpc, 4 ] == 2
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botao do Tracker                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aButtons, { "ORDEM", { || CS600Track( aCols, aHeader ) }, STR0038, STR0039 } ) // "System Tracker", "Tracker"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botao do banco de conhecimento                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aButtons, { "BPMSDOC", { || u_CS600Conhec() }, STR0041, STR0042 } ) // "Banco de conhecimento", "Conhecim."
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche campos usados no cadastro atraves da rotina de ³
	//³ contratos                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cContra != Nil
		M->CNA_CONTRA := cContra
	EndIf                                                                           X'
	If cPlani != Nil
		M->CNA_NUMERO := cPlani
	EndIf
	If !Empty(dInicio)
		M->CNA_DTINI := dInicio
	EndIf
	If !Empty(dTermino)
		M->CNA_DTFIM := dTermino
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa lancamento do SIGAPCO   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lContrEd
		PcoIniLan("000354")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dialog.                                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	EnChoice( cAlias, nReg, nOpc,,,,aCpoEnch, aPosObj[1], , , , , , , , .T.)
	oGetDados:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(nOpc!=3 .And. nOpc!=4,0,GD_UPDATE+GD_INSERT+GD_DELETE),'u_CS600LinOk()','u_CS600TudOk()','+CNB_ITEM',,,999,,,,oDlg,aHeader,aCols)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida o cabecalho antes do preenchimento dos itens                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDados:oBrowse:bGotFocus	:= {||u_CS600CabOk(aCpoEnch,@oDlg) }
	
	//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(CS600CabOk(aCpoEnch,@oDlg) .And. oGetDados:TudoOk(),{nOpca:=1,oDlg:End()},nOpca:=0)},{||(nOpca:=2,oDlg:End())},,aButtons)
	//Alterado em 02/04/2008 por Aline Catarina
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(u_CS600CabOk(aCpoEnch,@oDlg) .And. u_CS600TudOk(oGetDados),{nOpca:=1,oDlg:End()},nOpca:=0)},{||(nOpca:=2,oDlg:End())},,aButtons)
	
	If (nOpca == 1 .And. nOpc != 2)
		If !lContrEd
			Begin Transaction
			u_CS600Grv(nOpc,oGetDados)
			End Transaction
		Else
			u_CS600AGrv(nOpc,aPlani,aPlIt,oGetDados)
		EndIf

		If nOpc == 4 .And. !Empty(CNA->CNA_CRONOG)
			dbSelectArea("CNF")
			dbSetOrder(2)
			cFilCod := xFilial("CNF")
			If dbSeek(cFilCod+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_CRONOG)
				nTotCronog := 0
				//Soma total do cronograma
				While CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG
					nTotCronog += CNF->CNF_VLPREV
					dbSkip()
				EndDo
				If nTotCronog != CNA->CNA_VLTOT
					If MsgYesNo(STR0035)//"O cronograma deve ser atualizado de acordo com a planilha. Selecione 'Sim' para regerar as parcelas e 'Nao' para alterá-las manualmente"
						u_CS410Manut("CNF",RecNo(),4,,CNA->CNA_CONTRA,CNA->CNA_REVISA,.T.,.T.)
					Else
						u_CS410Manut("CNF",RecNo(),4,,CNA->CNA_CONTRA,CNA->CNA_REVISA,.T.,.F.)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza lancamento do SIGAPCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lContrEd
		PcoFinLan("000354")  
		PcoFreeBlq("000354",,,,,(nOpc == 4 .And. nOpca!=1))
	EndIf

EndIF
RestArea(aArea)

If cPlani != Nil
	cPlani := M->CNA_NUMERO
EndIf

Return (nOpca == 1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CS600SC  ³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exibe Solicitacoes de compra em aberto                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600SC(oExp01)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - GetDados                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600SC(oGetDados)

Local aFields := {}
Local l200SCC := ExistBlock("CTA200SCC")
Local oDlg
Local oMark
Local cMarca	 := GetMark()
Local lInverte	 := .F.
Local aArea		 := GetArea()
Local aGrupo    := UsrGrComp(RetCodUsr())
Local aAreaSX3	 := SX3->(GetArea())
Local aAreaSC1	 := SC1->(GetArea())
Local aCpos		 := {}
Local aMarca	 := {}
Local aCampos	 := {"C1_OK","C1_NUM","C1_ITEM","C1_PRODUTO","C1_QUANT","C1_QUJE","C1_DESCRI","C1_GRUPCOM"}
Local cAlias    := "SC1"
Local cCampoOk	 := "C1_OK"
Local aButEnc	 := {}
Local nOpcA     := 0
Local aHeader   := oGetDados:aHeader
Local aCols     := oGetDados:aCols
Local nPosCod	 := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_PRODUT"})
Local nPosPrc	 := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLUNIT"})
Local nPosQuant := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_QUANT"})
Local nPosTotal := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLTOT"})
Local nPosNmSc  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_NUMSC"})
Local nPosItSc  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEMSC"})
Local nExistIt  := 0
Local nDeleta   := 0
Local cCadastro := OemToAnsi(STR0012)
Local nx        := 0
Local ny        := 0
Local aMark     := {}
Local aFiltro   := {}
Local cCpoPre   := If(GetMV("MV_CNPRECO"),"B1_UPRC","B1_CUSTD")
Local cFilSC1   := 'C1_FILIAL == "'+xFilial('SC1')+'".And. C1_QUJE < C1_QUANT .And. C1_TPOP<>"P" .And. C1_APROV$" ,L" .And.( C1_COTACAO == "'+Space(Len(SC1->C1_COTACAO))+'" .Or. C1_COTACAO == "'+Replicate("X",Len(SC1->C1_COTACAO))+'")'+' .And. ((SC1->C1_QUJE > 0 .And. SC1->C1_FLAGGCT=="1") .Or. (SC1->C1_QUJE == 0 ))'
Local cCS600Sc1 := ""

Private aGrupoSC := UsrGrComp(RetCodUsr())
If ExistBlock("u_CS600SC1()")
	cCS600Sc1 := 	ExecBlock("u_CS600SC1()",.F.,.F.)
	If ( ValType(cCS600Sc1) == "C" ) .And. !Empty(cCS600Sc1)	
		cFilSC1 += IIf(Empty(cFilSC1),"",".AND.")+cCS600Sc1
	EndIf
EndIf

dbSelectArea("SC1")
dbSetOrder(1)
Set Filter To &(cFilSC1)
cFilter := cFilSC1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os botoes da enchoice passando o filtro para ser restaurado na saida da visualizacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aButEnc	:=  {	{"PESQUISA",{|| axPesqui() },OemToAnsi(STR0013)} ,; 			      	//"Pesquisar"
{"ANALITIC",{||A110Visual("SC1",RecNo(),2)},OemToAnsi(STR0014)} }	//"Visualizar" -- Usa funcao de visualizacao do pedido de compra

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Header com os titulos do MsSelect             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)
For nx	:= 1 to Len(aCampos)
	If MsSeek(aCampos[nx])
		If AllTrim(aCampos[nx])=="C1_OK"
			AADD(aCpos,{aCampos[nx],""," ",X3_PICTURE})
		Else
			AADD(aCpos,{aCampos[nx],"",AllTrim(X3Titulo()),X3_PICTURE})
		EndIf
	EndIf
Next

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek(cAlias)
While !Eof() .And. SX3->X3_ARQUIVO == cAlias
	IF ( SX3->X3_BROWSE=="S".And.SX3->X3_CONTEXT <> "V" .And. X3Uso(SX3->X3_USADO).And. Ascan(aCpos,{|x| Alltrim(x[1]) == Alltrim(SX3->X3_CAMPO)})==0 )
		Aadd(aCpos,{SX3->X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
	EndIf
	dbSkip()
Enddo

DEFINE MSDIALOG oDlg TITLE cCadastro From 30,30 To 265,600 OF oMainWnd PIXEL

oMark := MsSelect():New(cAlias,cCampoOk,"CS600FLAG()",aCpos,@lInverte,@cMarca,{ 17,2,113,285})
oMark:bMark := {|| CS600AddMark(cMarca,@aMarca,cCampoOk),oMark:OBROWSE:Refresh()}


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpcA:=1),(oDlg:End())},{||oDlg:End()},,aButEnc)

dbSelectArea("SC1")
dbSetOrder(1)
dbClearFilter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aCols com as SCs selecionados                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA== 1
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada para tratamento do campo centro de custo na solicitacao compras.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l200SCC
		aFields :=	ExecBlock ("CTA200SCC",.F.,.F.)
	Endif
	
	For nx := 1 to Len(aMarca)
		
		dbSelectArea(cAlias)
		MsGoto(aMarca[nx])
		
		If !(aScan(aGrupo,SC1->C1_GRUPCOM) <= 0 ) .Or. Empty(SC1->C1_GRUPCOM)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Varre o aCols e compara se ja existe o item da solicitacao           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nExistIT := Ascan(aCols,{|x| x[nPosNmSc] == FieldGet(FieldPos(aCampos[2])) .And. x[nPosItSc] == FieldGet(FieldPos(aCampos[3]))})
			
			If nExistIT = 0
				If aMarca[nx] > 0
					
					nDeleta := Ascan(aCols,{|x| x[nPosCod] = " "})
					If nDeleta >0
						Adel(aCols,nDeleta)//Exclui linha em branco
						Asize(aCols,Len(aCols)-1)
					Endif
					
					cItem := IIf(Empty(aCols),StrZero(1,Len(CNB->CNB_ITEM)),Soma1(aCols[Len(aCols)][1]))
					AADD(aCols,Array(Len(aHeader)+1))//inclui novo item
					
					For nY := 1 To Len(aHeader)//Preenche os campos
						Do Case
							Case Trim(aHeader[nY][2]) == "CNB_ITEM"
								aCols[Len(aCols)][nY] := cItem
							Case Trim(aHeader[nY][2]) == "CNB_NUMERO"
								aCols[Len(aCols)][nY] := M->CNA_NUMERO
							Case Trim(aHeader[nY][2]) == "CNB_REVISAO"
								aCols[Len(aCols)][nY] := M->CNA_REVISAO
							Case Trim(aHeader[nY][2]) == "CNB_CONTRA"
								aCols[Len(aCols)][nY] := M->CNA_CONTRA
							Case Trim(aHeader[nY][2]) == "CNB_QUANT"
								aCols[Len(aCols)][nY] := SC1->C1_QUANT-SC1->C1_QUJE
							Case Trim(aHeader[nY][2]) == "CNB_PRODUT"
								aCols[Len(aCols)][nY] := SC1->C1_PRODUTO
							Case Trim(aHeader[nY][2]) == "CNB_NUMSC"
								aCols[Len(aCols)][nY] := SC1->C1_NUM
							Case Trim(aHeader[nY][2]) == "CNB_ITEMSC"
								aCols[Len(aCols)][nY] := SC1->C1_ITEM
							Case Trim(aHeader[nY][2]) == "CNB_QTDSOL"
								aCols[Len(aCols)][nY] := SC1->C1_QUANT-SC1->C1_QUJE
							Case Trim(aHeader[nY][2]) == "CNB_DESCRI"
								aCols[Len(aCols)][nY] := SC1->C1_DESCRI
							Case Trim(aHeader[nY][2]) == "CNB_UM"
								aCols[Len(aCols)][nY] := SC1->C1_UM
							Case Trim(aHeader[nY][2]) == "CNB_VLUNIT"
								aCols[Len(aCols)][nY] := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,cCpoPre)
							OtherWise
								aCols[Len(aCols)][nY] := CriaVar(aHeader[ny,2])
						EndCase
					Next nY
					
					aCols[Len(aCols)][nPosTotal] := aCols[Len(aCols)][nPosPrc]*aCols[Len(aCols)][nPosQuant]
					aCols[Len(aCols)][Len(aHeader)+1] := .F.
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impede que o item da planilha seja deletado pela getdados                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oGetDados:lNewLine:=.F.
					
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Varre array para preenchimento.																	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If len(aFields) > 0
						For nY := 1 To Len(afields)
							If (nposfield:= aScan(aHeader, {|x|AllTrim(x[2])==afields[nY,1]})) > 0
								aCols[len(aCols),nposfield]:= &(afields[nY,2])
							Endif
						Next ny
					EndIf
				EndIf
			EndIf
		EndIf
	Next
EndIf

oGetDados:Refresh()

RestArea(aAreaSC1)
RestArea(aAreaSX3)

RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CS600Flag³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o usuario atraves da solicitacao selecionada        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600Flag()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600Flag()

//Local aGrupoSC := UsrGrComp(RetCodUsr())
Local lSolic := IF(SuperGetMv("MV_RESTCOM")=="S",.T.,.F.)
Local cFlag	 := IIf(C1_QUJE>=C1_QUANT,'X',' ')+If(C1_TPOP=='P'.And.C1_APROV$"R,B",'X',' ');
+If(Empty(SC1->C1_GRUPCOM),' ',If(lSolic.And.aScan(aGrupoSC,SC1->C1_GRUPCOM) <= 0,'X',' '))
Return cFlag

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600AddMark³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Altera marcacao realizada pelo usuario                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600AddMark(cExp01,aExp02,cExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Marca                                               ³±±
±±³          ³ aExp02 - Array com as marcacoes                              ³±±
±±³          ³ cExp03 - Campo de validacao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600AddMark(cMarca,aMarca,cCampoOk)
Local cFilCod := xFilial("SC1")
Local cNum    := SC1->C1_NUM
Local cItem   := SC1->C1_ITEM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no inicio da solicitacao de compra          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSeek(xFilial("SC1")+cNum)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percorre os itens da mesma solicitacao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While SC1->C1_FILIAL == cFilCod .And. SC1->C1_NUM == cNum
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a solicitação de compra já esta marcada   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aScan(aMarca,RecNo())> 0
		aMarca[aScan(aMarca,RecNo())] := 0
		//Altera campo de marcacao para todos os itens
		If &(cCampoOk) == cMarca
			RecLock("SC1",.F.)
			&(cCampoOk) := ""
			MsUnlock()
		EndIf
	Else
		AADD(aMarca,Recno())
		//Altera campo de marcacao para todos os itens
		If &(cCampoOk) != cMarca
			RecLock("SC1",.F.)
			&(cCampoOk) := cMarca
			MsUnlock()
		EndIf
	EndIf
	
	dbSkip()
EndDo

//Retorna para o item selecionado
dbSeek(xFilial("SC1")+cNum+cItem)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CS600SCIT³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exibe solicitacoes de compra para importacao por item      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600SCIT(oExp01)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - GetDados                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600SCIT(oGetDados)

Local aArea	     := GetArea()
Local l200SCC    := ExistBlock("CTA200SCC")
Local aAreaSC1	  := SC1->(GetArea())
Local aAreaSB1	  := SB1->(GetArea())
Local aGrupo	  := UsrGrComp(RetCodUsr())
Local aCampos	  := {"C1_NUM","C1_ITEM","C1_PRODUTO","C1_QUANT","C1_DESCRI"}
Local aHeadCpos  := {" "}
Local aLineNew   := {}
Local aNewF4     := {}
Local aLineF4    := {}
Local aArrayF4	  := {}
Local aSavRec	  := {}
Local aFiltro    := {}
Local bWhile     := { || .T. }
Local bIf        := { || .T. }
Local aHeader    := oGetDados:aHeader
Local aCols      := oGetDados:aCols
Local nPosNumSc  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_NUMSC"})
Local nPosItem   := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEM"})
Local nPosItSc   := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEMSC"})
Local nPosCod	  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_PRODUT"})
Local nPosPrc	  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLUNIT"})
Local nPosQuant  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_QUANT"})
Local nPosTotal  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLTOT"})
Local nPosQtSol  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_QTDSOL"})
Local nOpcA      := 0
Local nSavQual   := 0
Local nX         := 0
Local nY         := 0
Local nInclui    := 0
Local n          := oGetDados:nAt
Local cVar		  := aCols[n][nPosCod]
Local cCadastro  := ""
Local cAliasQry  := ""
Local cQuery     := ""
Local cDescr     := ""
Local cLine      := ""
Local cQuerySc1  := ""
Local bLine      := ""
Local cItem      := "01"
Local oOk	     := LoadBitMap(GetResources(), "LBOK")
Local oNo		  := LoadBitMap(GetResources(), "LBNO")
Local lSolic	  := IF(SuperGetMv("MV_RESTCOM")=="S",.T.,.F.)
Local cCpoPre    := If(GetMV("MV_CNPRECO"),"B1_UPRC","B1_CUSTD")
Local aFields    := {}
Local oDlg
Local oQual

If !Empty(cVar)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Header com os titulos do MsSelect             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nx	:= 1 to Len(aCampos)
		If MsSeek(aCampos[nx])
			AADD(aHeadCpos,AllTrim(X3Titulo()) )
		EndIf
	Next
	
	dbSelectArea("SC1")
	dbSetOrder(2)
	If MsSeek(xFilial()+cVar)
		
		bFiltro := { || .T. }
		
		cAliasQry := CriaTrab( , .F. )
		
		cQuery := ""
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra solicitacoes de compra                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery += "SELECT R_E_C_N_O_ SC1RECNO FROM " + RetSqlName( "SC1" ) + " "
		cQuery += "WHERE "
		cQuery += "C1_FILIAL='"  + xFilial( "SC1" ) + "' AND "
		cQuery += "C1_PRODUTO='" + cVar             + "' AND "
		cQuery += "C1_QUJE<C1_QUANT AND "
		cQuery += "C1_TPOP<>'P' AND "
		cQuery += "C1_APROV IN(' ','L') AND "
		cQuery += "(C1_COTACAO ='"+Space(Len(C1_COTACAO))+"' OR C1_COTACAO = '"+Replicate("X",Len(C1_COTACAO))+"') AND "
		cQuery += "((C1_QUJE > 0 AND C1_FLAGGCT = '1') OR (C1_QUJE = 0)) AND "
		If ExistBlock("CS600IT")
			cQuerySc1 := ExecBlock("CS600IT",.F.,.F.) 
			If ( ValType(cQuerySc1) == "C" )
			cQuery += cQuerySc1 + " AND "
		    EndIf
		EndIf		
		cQuery += "D_E_L_E_T_<>'*'"
		
		cQuery := ChangeQuery( cQuery )
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )
		
		bWhile  := { || !( cAliasQry )->( Eof() ) }
		bIf     := { || .T. }
		
		
		While Eval( bWhile )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona o SC1                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SC1->( MsGoto( ( cAliasQry )->SC1RECNO ) )
			dbSelectArea( "SC1" )
			
			If Eval( bIf ) .And. Eval( bFiltro )
				
				If !(aScan(aGrupo,SC1->C1_GRUPCOM) <= 0 ) .Or. Empty(SC1->C1_GRUPCOM)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula saldo do item                                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSaldo	:= CS600SaldoSC(nPosCod,nPosNumSC,nPosItSC,nPosItem,nPosQuant,nPosQtSol,M->CNA_CONTRA,M->CNA_NUMERO,M->CNA_REVISA,aCols)
					If nSaldo > 0
						
						AADD(aArrayF4,{SC1->C1_NUM,SC1->C1_ITEM,SC1->C1_PRODUTO,TransForm(nSaldo,PesqPictQt("C1_QUANT")),SC1->C1_DESCRI})
						AADD(aSavRec,RecNo())						
					EndIf					
				EndIf				
			EndIf			
			dbSelectArea( cAliasQry )
			dbSkip()
		EndDo
	Else
		Help(" ",1,"A120F4")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona descricao do produto                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDescr := Substr(Posicione("SB1",1,xFilial("SB1")+cVar,"SB1->B1_DESC"),1,15)
	
	cCadastro := OemToAnsi(STR0012)	//"Solicita‡„o de Compras"
	
	aNewF4 := {}
	
	For nX := 1 To Len( aArrayF4 )
		aLineF4 := aArrayF4[ nX ]
		aLineNew := { .F. }
		AEval( aLineF4, { |x| AAdd( aLineNew, x ) } )
		AAdd( aNewF4, aLineNew )
	Next nX
	
	aArrayF4 := AClone( aNewF4 )
	
	If Len(aArrayF4) > 0
		nOpcA := 0
		
		cLine := "{If(aArrayF4[oQual:nAt,1],oOk,oNo)"
		
		For nX := 2 To Len( aHeadCpos )
			cLine += ",aArrayF4[oQual:nAT][" + AllTrim( Str( nX ) ) + "]"
		Next nX
		
		cLine += " } "
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta dinamicamente o bline do CodeBlock                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		bLine := &( "{ || " + cLine + " }" )
		
		DEFINE MSDIALOG oDlg FROM 30,30 TO 265,600 TITLE cCadastro OF oMainWnd PIXEL
		
		@ 15,4 Say STR0015 PIXEL //"Produto"
		@ 14,30 MSGET cDescr WHEN .F. PIXEL//Descricao do Produto
		oQual:= TWBrowse():New( 29,4,278,86,,aHeadCpos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oQual:SetArray(aArrayF4)
		oQual:bLDblClick := { || aArrayF4[oQual:nAt,1] := !aArrayF4[oQual:nAt,1] }
		oQual:bLine := bLine
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpcA := 1,nSavQual:= oQual:nAT,oDlg:End())},{||(nOpcA := 0,nSavQual:= oQual:nAt,oDlg:End())})
		
		If nOpcA == 1
			cFilCod := xFilial("SC1")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de Entrada para tratamento do campo centro de custo na solicitacao compras.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l200SCC
				aFields :=	ExecBlock ("CTA200SCC",.F.,.F.)
			Endif
			
			For nx := 1 to Len(aArrayF4)
				
				If aArrayF4[nx][1]
					
					dbSelectArea("SC1")
					
					dbSetOrder(1)
					MsSeek(cFilCod+aArrayF4[nx][2]+aArrayF4[nx][3])
					
					nInclui := Ascan(aCols,{|x| x[nPosQuant] = 0 .And. x[nPosTotal] = 0})
					
					If nInclui == 0
						cItem := IIf(Empty(aCols),"01",SomaIt(aCols[Len(aCols)][1]))
						AADD(aCols,Array(Len(aHeader)+1))
						
						For nY := 1 To Len(aHeader)//Preenche os campos de inclusao
							Do Case
								Case Trim(aHeader[nY][2]) == "CNB_ITEM"
									aCols[Len(aCols)][nY] := cItem
								Case Trim(aHeader[nY][2]) == "CNB_NUMERO"
									aCols[Len(aCols)][nY] := M->CNA_NUMERO
								Case Trim(aHeader[nY][2]) == "CNB_REVISAO"
									aCols[Len(aCols)][nY] := M->CNA_REVISAO
								Case Trim(aHeader[nY][2]) == "CNB_CONTRA"
									aCols[Len(aCols)][nY] := M->CNA_CONTRA
								Case Trim(aHeader[nY][2]) == "CNB_PRODUT"
									aCols[Len(aCols)][nY] := SC1->C1_PRODUTO
								Case Trim(aHeader[nY][2]) == "CNB_DESCRI"
									aCols[Len(aCols)][nY] := SC1->C1_DESCRI
								Case Trim(aHeader[nY][2]) == "CNB_UM"
									aCols[Len(aCols)][nY] := SC1->C1_UM
								OtherWise
									aCols[Len(aCols)][nY] := CriaVar(aHeader[ny,2])
							EndCase
						Next nY
						
						aCols[Len(aCols)][Len(aHeader)+1] := .F.
						n := Len(aCols)
					EndIf
					
					For nY := 1 To Len(aHeader)//Preenche os campos
						Do Case
							Case Trim(aHeader[nY][2]) == "CNB_UM"
								aCols[Len(aCols)][nY] := SC1->C1_UM
							Case Trim(aHeader[nY][2]) == "CNB_QTDSOL"
								aCols[Len(aCols)][nY] := val(aArrayF4[nx][5])
							Case Trim(aHeader[nY][2]) == "CNB_QUANT"
								aCols[Len(aCols)][nY] := val(aArrayF4[nx][5])
							Case Trim(aHeader[nY][2]) == "CNB_NUMSC"
								aCols[Len(aCols)][nY] := SC1->C1_NUM
							Case Trim(aHeader[nY][2]) == "CNB_ITEMSC"
								aCols[Len(aCols)][nY] := SC1->C1_ITEM
							Case Trim(aHeader[nY][2]) == "CNB_DESC"
								aCols[Len(aCols)][nY] := 0.00
							Case Trim(aHeader[nY][2]) == "CNB_QTDMED"
								aCols[Len(aCols)][nY] := 0.00
							Case Trim(aHeader[nY][2]) == "CNB_VLDESC"
								aCols[Len(aCols)][nY] := 0.00
							Case Trim(aHeader[nY][2]) == "CNB_SLDMED"
								aCols[Len(aCols)][nY] := 0.00
							Case Trim(aHeader[nY][2]) == "CNB_VLUNIT"
								aCols[Len(aCols)][nY] := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,cCpoPre)//Selecione preco de acordo com parametro MV_CNPRECO
							Case Trim(aHeader[nY][2]) == "CNB_SLDREC"
								aCols[Len(aCols)][nY] := 0.00
						EndCase
					Next nY
					//Calcula total do item
					aCols[Len(aCols)][nPosTotal] := aCols[Len(aCols)][nPosPrc]*aCols[Len(aCols)][nPosQuant]
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Varre array para preenchimento.																	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If len(aFields) > 0
					For nY := 1 To Len(afields)
						If (nposfield:= aScan(aHeader, {|x|AllTrim(x[2])==afields[nY,1]})) > 0
							aCols[len(aCols),nposfield]:= &(afields[nY,2])
						Endif
					Next ny
				EndIf
			Next
		EndIf
	Else
		MsgAlert(STR0033)//"Nao ha itens em aberto para o produto selecionado"
	EndIf
Else
	MsgAlert("Preencha o campo produto")
EndIf

oGetDados:Refresh()

RestArea(aAreaSC1)
RestArea(aAreaSB1)
RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600SaldoSC³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Calcula saldo do item                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Posicao do codigo do produto na CNB      (CNB_PRODUT) ³±±
±±³          ³ nExp02 - Posicao do numero da SC na CNB           (CNB_NUMSC)  ³±±
±±³          ³ nExp03 - Posicao do item da SC na CNB             (CNB_ITEMSC) ³±±
±±³          ³ nExp04 - Posicao do item da CNB                   (CNB_ITEM)   ³±±
±±³          ³ nExp05 - Posicao da quantidade da CNB             (CNB_QUANT)  ³±±
±±³          ³ nExp06 - Posicao da quantidade solicitada da CNB  (CNB_QTDSOL) ³±±
±±³          ³ nExp07 - Numero do contrato                                    ³±±
±±³          ³ cExp08 - Numero da planilha                                    ³±±
±±³          ³ cExp09 - Numero da revisao do contrato                         ³±±
±±³          ³ aExp10 - Acols dos itens de planilha                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600SaldoSC(nPosCod,nPosNumSC,nPosItSC,nPosItem,nPosQuant,nPosQtSol,cNumCont,cNumPla,cNumRevisa,aCols)

Local aArea		:= GetArea()
Local nSaldo	:= 0
Local nx

nSaldo	:= SC1->C1_QUANT - SC1->C1_QUJE//Verifica saldo da solicitacao
For nx := 1 to Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o item ja foi adicionado a planilha          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[nx][Len(aCols[nx])].And.!ATail(aCols[nx]).And.;
		(aCols[ nx, nPosCod  ] == C1_PRODUTO).And. ;
		(aCols[ nx, nPosNumSC] == C1_NUM).And. ;
		(aCols[ nx, nPosItSC ] == C1_ITEM)
		nSaldo -= aCols[nx,nPosQuant]//Retira quantidade ja atendida
		dbSelectArea("CNB")
		dbSetOrder(1)
	EndIf
Next nX

nSaldo := If(nSaldo > 0, nSaldo , 0 )

RestArea(aArea)
Return(nSaldo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CS600CabOk³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida cabecalho                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600CabOk(aExp01,oExp02)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array com os campos do cabecalho                     ³±±
±±³          ³ oExp02 - Dialog                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600CabOk(aCpoEnch,oDlg)
Local cCpo 	:= ""
Local cMens := ""
local lOk 	:= .T.
Local n

lOk := Obrigatorio(aGets,aTela)

If lOk
	If lContrEd
		If aScan(aForn,{|x| x[1] == M->CNA_FORNEC .And. x[2] == M->CNA_LJFORN}) == 0
			Aviso(STR0018,STR0021,{ "OK" },2)
			lOk := .F.
		EndIF
	Else
		dbselectarea("CNC")//Verifica se o fornecedor pertence ao contrato
		dbsetorder(1)
		If !dbSeek(xFilial("CNC")+M->CNA_CONTRA+M->CNA_FORNEC+M->CNA_LJFORN)
			Aviso(STR0018,STR0021,{ "OK" },2)
			lOk := .F.
		EndIF
	EndIF
EndIf

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CS600LinOk³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida item da planilha                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600LinOK(oExp01)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Estrutura da linha                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600LinOk(o)
Local lRet := .T.
Local nA := 0
Local nPosSC1   := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_NUMSC"})
Local nPosItSC1 := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEMSC"})
Local nPosQuant := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_QUANT"})
Local nPosVlUni := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLUNIT"})
Local nPosProd  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_PRODUT"})
Local nPosUM    := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_UM"})

//Campos obrigatorios da linha
Local aPosCto := {nPosQuant,nPosVlUni,nPosProd,nPosUM}

If !aCols[o:nAt,len(aHeader)+1]
	For nA := 1 to len(aPosCto)
		if Empty(aCols[o:nAt][aPosCto[nA]])
			lRet := .F.
			exit
		EndIf
	Next nA
	
	If !lRet
		Help(" ",1,"CSUA600OBR")  //"Preencha os campos obrigatórios"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida produto em relacao a solicitacao de compra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. !Empty(aCols[o:nAt][nPosSC1])
		dbSelectArea("SC1")
		dbSetOrder(1)
		If dbSeek(xFilial("SC1")+aCols[o:nAt][nPosSC1]+aCols[o:nAt][nPosItSC1])
			If SC1->C1_PRODUTO != aCols[o:nAt][nPosProd]
				Help(" ",1,"CSUA600INV") //"Produto invalido para o item"
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida lancamento do SIGAPCO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	lRet:=	PcoVldLan('000354','02','CSUA600',/*lUsaLote*/,/*lDeleta*/, .T./*lVldLinGrade*/)
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CS600TudOk³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida itens da planilha                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600TudOK()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600TudOk(o)
Local lRet      := .T.
Local lProdFr   := .F.
Local nA        := 0
Local nI        := 0
Local cFilSA5   := xFilial("SA5")
Local cFilSC1   := xFilial("SC1")
Local cFilSAD   := xFilial("SAD")
Local cFilSB1   := xFilial("SB1")
Local aHeader := o:aHeader
Local aCols   := o:aCols
Local nPosItem  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEM"})
Local nPosSC1   := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_NUMSC"})
Local nPosItSC1 := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEMSC"})
Local nPosQuant := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_QUANT"})
Local nPosVlUni := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLUNIT"})
Local nPosProd  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_PRODUT"})
Local nPosUM    := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_UM"})
Local nPosVlTot := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLTOT"})
Local nPosVlDec := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLDESC"})

//Campos obrigatorios da linha
Local aPosCto := {nPosQuant,nPosVlUni,nPosProd,nPosUM}

Local lVldPrd := ( GetNewPar("MV_CNVLAMR","N") == "S" )

//Verifica se existem itens na planilha
If len(aCols) == 0
	Help(" ",1,"CSUA600PLA") //"Insira um item na planilha"
	lRet := .F.
Else
	nI := 1
	//Verifica itens deletados
	While nI <= len(aCols) .And. aCols[nI][len(aHeader)+1]
		nI++
	EndDo
	
	If nI > len(aCols)
		Help(" ",1,"CSUA600PLA")  //"Insira um item na planilha"
		lRet := .F.
	EndIf
EndIf

If lRet
	M->CNA_VLTOT := 0
	
	For nI := 1 to len(aCols)
		//-- Nao validar linhas deletadas do aCols
		If aCols[nI][Len(aCols[1])]
			Loop
		EndIf
		For nA := 1 to len(aPosCto)
			If Empty(aCols[nI][aPosCto[nA]])
				lRet := .F.
				Exit
			EndIf
		Next nA
		
		If !lRet
			Help(" ",1,"CSUA600COR")  //"Preencha corretamente todos os itens"
			Exit
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida produto em relacao a solicitacao de compra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. !Empty(aCols[nI][nPosSC1])
			dbSelectArea("SC1")
			dbSetOrder(1)
			If dbSeek(cFilSC1+aCols[nI][nPosSC1]+aCols[nI][nPosItSC1])
				If SC1->C1_PRODUTO != aCols[nI][nPosProd]
					Help(" ",1,"CSUA600INV") //"Produto inválido para o item"
					lRet := .F.
					Exit
				EndIf
			EndIf
		EndIf
		
		If lRet .And. lVldPrd
			dbSelectArea("SA5")
			dbSetOrder(1)
			dbGoTop()
			
			lProdFr := dbSeek(cFilSA5+M->CNA_FORNEC+M->CNA_LJFORN+aCols[nI][nPosProd])
			If !lProdFr
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(cFilSB1+aCols[nI][nPosProd])
					dbSelectArea("SAD")
					dbSetOrder(1)
					lProdFr := dbSeek(cFilSAD+M->CNA_FORNEC+M->CNA_LJFORN+SB1->B1_GRUPO)
				EndIf
			EndIf
			                                                             
			If !lProdFr
				Aviso(STR0018,STR0044+AllTrim(aCols[nI][nPosItem])+STR0045,{ "OK" },2)//"O produto informado no item "###" não está amarrado ao fornecedor informado. Verifique a amarração produto X fornecedor."
				lRet := .F.
				Exit
			EndIf
		EndIf

		M->CNA_VLTOT += (aCols[nI][nPosVlTot]-aCols[nI][nPosVlDec])
	Next nI

	//Valida numero da planilha
	If lRet
		lRet := CS600VldNum()
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida lancamento do SIGAPCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		lRet:=	PcoVldLan('000354','01','CSUA600',/*lUsaLote*/,/*lDeleta*/, .F./*lVldLinGrade*/)
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600VldCon³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida contrato                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600VldCon()
Local aArea     := GetArea()
Local lRet      := .F.
Local cContrato := M->CNA_CONTRA
Local cRevisa   := M->CNA_REVISA

If !Empty(cContrato)
	
	lRet := CN240VldUsr(cContrato,DEF_TRAINC,.T.)
	
	If lRet
		dbSelectArea("CN9")
		dbSetOrder(1)
		
		If Empty(cRevisa)
			dbSeek(xFilial("CN9")+cContrato)
			//Seleciona revisao mais recente se houver
			If !Empty(CN9->CN9_REVATU)
				M->CNA_REVISA := cRevisa := CN9->CN9_REVATU
			EndIf
		EndIF
		
		If dbSeek(xFilial("CN9")+cContrato+cRevisa)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o contrato aceita planilha          ³
			//³ Situacoes que aceitam a inclusao de planilha    ³
			//³  - 2 - Elaboracao                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(CN9->CN9_SITUAC) == DEF_SELAB .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO
				If Empty(CN9->CN9_REVATU)
					//Quando altera o numero do contrato limpa o fornecedor
					If ALTERA .And. M->CNA_CONTRA != CNA->CNA_CONTRA
						M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
						M->CNA_LOJA	  := Space(TamSX3("CNA_LOJA")[1])
					Endif
					
					//Retorna numero na sequencia do contrato para a planilha
					M->CNA_NUMERO := u_CS600PlaNum(cContrato,cRevisa)
					//Retorna data inicial do contrato, ou a data atual
					M->CNA_DTINI  := If((CN9->CN9_DTINIC > dDataBase),CN9->CN9_DTINIC,dDataBase)
					//Retorna data final do contrato, ou a data atual
					M->CNA_DTFIM  := If((CN9->CN9_DTFIM > dDataBase),CN9->CN9_DTFIM,dDataBase)
					
					dbSelectArea("CNC")
					dbSetOrder(1)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Seleciona primeiro fornecedor relacionado       ³
					//³ ao contrato                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If dbSeek(xFilial("CNC")+M->CNA_CONTRA)
						M->CNA_FORNEC := CNC->CNC_CODIGO
						M->CNA_LJFORN := CNC->CNC_LOJA
					Else
						M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
						M->CNA_LJFORN := Space(TamSX3("CNA_LJFORN")[1])
					Endif
					lRet := .T.
				Else
					lRet := .F.
					Help(" ",1,"CSUA600CON") //"Contrato revisado, selecione a versão mais recente."
				EndIf
			Else
				lRet := .F.
				Help(" ",1,"CSUA600ATU") //"A situação atual do contrato não permite a inclusão de planilhas."
			EndIf
			
		Else
			//Limpa revisao quando o contrato nao for encontrado
			M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
		Endif
	EndIf
Endif

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600PlaNum³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna numero sequencial da planilha de acordo com o contrato³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ cExp01 := CS600PlaNum(cExp02,cExp03)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Numero sequencial da planilha                        ³±±
±±³          ³ cExp02 - Numero do contrato                                   ³±±
±±³          ³ cExp03 - Numero da revisao                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600PlaNum(cContra,cRevisa)
Local cNumPla := Strzero(0,TamSX3("CNA_NUMERO")[1])
Local aArea := GetArea()
Local cFilCod

dbSelectArea("CNA")
dbSetOrder(1)

cFilCod := xFilial("CNA")
dbSeek(cFilCod+cContra+cRevisa)
//Seleciona planilha mais recente
While CNA->CNA_FILIAL == cFilCod .And. CNA->CNA_CONTRA == cContra .And. CNA->CNA_REVISA == cRevisa
	cNumPla := CNA->CNA_NUMERO
	dbSkip()
EndDo

cNumPla := Soma1(cNumPla)

RestArea(aArea)
Return cNumPla

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CS600Grv  ³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Grava a planilha e os itens                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS600Grv(nExp01,oExp02)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao selecionada                                    ³±±
±±³          ³ oExp02 - Getdados dos itens                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600Grv(nOpc,oGetDados)
Local nCntFor  := 0
Local nTam     := 0
Local nUsado   := 0
Local nCntFor2 := 0
Local nItem    := 0
Local nTot     := 0
Local nTotAnt  := 0
Local nQtAtd   := 0
Local nX
Local cFilCod
Local cFilSC1  := xFilial("SC1")
Local aHeader  := oGetDados:aHeader
Local aCols    := oGetDados:aCols
Local nPosSC1  := aScan(aHeader,{|x| x[2]="CNB_NUMSC"})
Local nPosItSC := aScan(aHeader,{|x| x[2]="CNB_ITEMSC"})
Local nPosQtSol:= aScan(aHeader,{|x| x[2]="CNB_QTDSOL"})
Local nPosQuant:= aScan(aHeader,{|x| x[2]="CNB_QUANT"})
Local aItms    := {}
Local cItms    := ""
Local nPosItm  := 0
Local lCronog  := .F.
Local lFisico  := .F.
Local cFilCNS  := ""
Local cAlias   := ""
Local cQuery   := ""
Local cMedEven := ""

Do Case
	Case nOpc == 3		// Inclusao
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche campos do cabecalho                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNA")
		Reclock("CNA",.T.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)=="CNA_FILIAL")
				CNA->CNA_FILIAL := xFilial()
			Else
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		MsUnlock()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa o lancamento do SIGAPCO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000354","01","CSUA600")
		
		dbSelectArea("CNB")
		nUsado := Len(aHeader)
		cFilCod := xFilial("CNB")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche campos dos itens                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] )
				dbSelectArea("CNB")
				Reclock("CNB",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNB->CNB_FILIAL := cFilCod
				CNB->CNB_NUMERO := CNA->CNA_NUMERO
				CNB->CNB_REVISA := CNA->CNA_REVISA
				CNB->CNB_CONTRA := CNA->CNA_CONTRA
				CNB->CNB_DTCAD  := dDataBase
				CNB->CNB_SLDMED := CNB->CNB_QUANT
				CNB->CNB_SLDREC := CNB->CNB_QUANT
				nTot += CNB->CNB_VLTOT-CNB->CNB_VLDESC
				MsUnlock()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa o lancamento do SIGAPCO ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000354","02","CSUA600")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza solicitacao de compra                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(CNB->CNB_NUMSC)
					dbSelectArea("SC1")
					If dbSeek(cFilSC1+CNB->CNB_NUMSC+CNB->CNB_ITEMSC)
						nQtAtd := If(CNB->CNB_QUANT > (SC1->C1_QUANT-SC1->C1_QUJE),(SC1->C1_QUANT-SC1->C1_QUJE),CNB->CNB_QUANT)
						RecLock("SC1",.F.)
						SC1->C1_QUJE+= nQtAtd
						SC1->C1_QUJE:= If(SC1->C1_QUJE>SC1->C1_QUANT,SC1->C1_QUANT,SC1->C1_QUJE)
						SC1->C1_FLAGGCT:= "1" //Solicitacao bloqueada para SIGAGCT
						MsUnlock()
					EndIf
				EndIf
			EndIf
		Next
		
		//Atualiza valor total do cabecalho
		Reclock("CNA",.F.)
		CNA->CNA_VLTOT := nTot + M->CNA_REAJS
		CNA->CNA_SALDO := nTot + M->CNA_REAJS

		//CNA->CNA_VLTOT := nTot
		//CNA->CNA_SALDO := nTot
		MsUnlock()
		
		//Atualiza valor inicial,atual e saldo do contrato 09/04/07
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+M->CNA_CONTRA+M->CNA_REVISA)
			cMedEven := MedEven(CN9->CN9_TPCTO)		
			If !((cMedEven == "1") .And. (CN9->CN9_CTRT == "2"))  //Medicao Eventual - Fixo ou Nao Eventual 
				RecLock("CN9",.F.)            
				CN9->CN9_VLINI += nTot               
				CN9->CN9_VLATU += nTot + M->CNA_REAJS
				CN9->CN9_SALDO += nTot + M->CNA_REAJS
				CN9->CN9_REAJS += M->CNA_REAJS
				MsUnlock()			
			EndIf
		Else                                        
			cMedEven := MedEven(M->CN9_TPCTO)				
			If !((cMedEven == "1") .And. (M->CN9_CTRT == "2"))  //Medica Eventual - Variavel
				M->CN9_VLINI += nTot               
				M->CN9_VLATU += nTot + M->CNA_REAJS
				M->CN9_SALDO += nTot + M->CNA_REAJS
				M->CN9_REAJS += M->CNA_REAJS
			EndIf
		EndIf                                           
	Case nOpc == 4  //Alteracao
		lCronog := !Empty(CNA->CNA_CRONOG)
		
		If lCronog
			dbSelectArea("CN9")
			dbSetOrder(1)
			dbSeek(xFilial("CN9")+CNA->CNA_CONTRA+CNA->CNA_REVISA)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o contrato possui cronograma fisico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga os itens da planilha                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNB")
		dbSetOrder(1)
		If dbSeek(xFilial()+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_NUMERO)
			cFilCod := xFilial("CNB")
			While !Eof() .And. CNB->CNB_FILIAL = cFilCod .And. CNB->CNB_CONTRA == CNA->CNA_CONTRA .And. CNB->CNB_REVISA == CNA->CNA_REVISA .And. CNB->CNB_NUMERO == CNA->CNA_NUMERO
				If !Empty(CNB->CNB_ITEMSC)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Retira quantidade atendida da solicitacao de compra³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SC1")
					dbSetOrder(1)
					If dbSeek(cFilCod+CNB->CNB_NUMSC+CNB->CNB_ITEMSC)
						RecLock("SC1")
						SC1->C1_QUJE-=if(CNB->CNB_QUANT>CNB->CNB_QTDSOL,CNB->CNB_QTDSOL,CNB->CNB_QUANT)
						MsUnlock()
					EndIf
				EndIf
				
				RecLock("CNB", .F.)
				dbDelete()
				MsUnLock()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui o lancamento do SIGAPCO  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000354","02","CSUA600",.T.)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Armazena itens no array para controle do cronograma   ³
				//³ fisico                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFisico
					aAdd(aItms,CNB->CNB_ITEM)
				EndIf
				
				dbSelectArea("CNB")
				dbSkip()
			EndDo
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche campos da planilha                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNA")
		Reclock("CNA",.F.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)=="CNA_FILIAL")
				CNA->CNA_FILIAL := xFilial()
			Else
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		MsUnlock()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa o lancamento do SIGAPCO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000354","01","CSUA600")
		
		dbSelectArea("CNB")
		nUsado  := Len(aHeader)
		cFilCod := xFilial("CNB")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche campos dos itens                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] )
				dbSelectArea("CNB")
				Reclock("CNB",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNB->CNB_FILIAL := cFilCod
				CNB->CNB_NUMERO := CNA->CNA_NUMERO
				CNB->CNB_REVISA := CNA->CNA_REVISA
				CNB->CNB_CONTRA := CNA->CNA_CONTRA
				CNB->CNB_SLDMED := CNB->CNB_QUANT
				CNB->CNB_SLDREC := CNB->CNB_QUANT
				nTot += CNB->CNB_VLTOT-CNB->CNB_VLDESC
				MsUnlock()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa o lancamento do SIGAPCO ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000354","02","CSUA600")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza solicitacao de compra                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(CNB->CNB_NUMSC)
					dbSelectArea("SC1")
					If dbSeek(cFilSC1+CNB->CNB_NUMSC+CNB->CNB_ITEMSC)
						nQtAtd := If(CNB->CNB_QUANT > (SC1->C1_QUANT-SC1->C1_QUJE),(SC1->C1_QUANT-SC1->C1_QUJE),CNB->CNB_QUANT)
						RecLock("SC1",.F.)
						SC1->C1_QUJE	+= nQtAtd
						SC1->C1_QUJE	:= If(SC1->C1_QUJE>SC1->C1_QUANT,SC1->C1_QUANT,SC1->C1_QUJE)
						MsUnlock()
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o item foi incluido na planilha           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFisico .And. (nPosItm := aScan(aItms,CNB->CNB_ITEM)) == 0
					If Empty(cAlias)//Verifica se o alias do cronograma ja foi criado
						dbSelectArea("CNF")
						dbSetOrder(2)
						
						cQuery := "SELECT CNF.CNF_PARCEL FROM "+RetSQLName("CNF")+" CNF WHERE "
						cQuery += "CNF.CNF_FILIAL = '"+xFilial("CNF")+"' AND "
						cQuery += "CNF.CNF_CONTRA = '"+CNA->CNA_CONTRA+"' AND "
						cQuery += "CNF.CNF_REVISA = '"+CNA->CNA_REVISA+"' AND "
						cQuery += "CNF.CNF_NUMERO = '"+CNA->CNA_CRONOG+"' AND "
						cQuery += "CNF.D_E_L_E_T_ = ' '"
						
						cAlias := GetNextAlias()
						cQuery := ChangeQuery( cQuery )
						dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlias, .F., .T. )
					EndIf
					
					cFilCNS := xFilial("CNS")
					(cAlias)->(dbGoTop())
					
					While !(cAlias)->(Eof())
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Insere novo registro no cronograma fisico para todas  ³
						//³ as parcelas                                           ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("CNS")
						RecLock("CNS",.T.)
						CNS->CNS_FILIAL:=cFilCNS
						CNS->CNS_CONTRA:=CNA->CNA_CONTRA
						CNS->CNS_REVISA:=CNA->CNA_REVISA
						CNS->CNS_CRONOG:=CNA->CNA_CRONOG
						CNS->CNS_PARCEL:=(cAlias)->CNF_PARCEL
						CNS->CNS_PLANI :=CNA->CNA_NUMERO
						CNS->CNS_ITEM  :=CNB->CNB_ITEM
						MsUnlock()
						(cAlias)->(dbSkip())
					EndDo
				ElseIf nPosItm > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Quando o item nao foi incluso ou excluso apenas retira³
					//³ do array de controle                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aDel(aItms,nPosItm)
					aSize(aItms,len(aItms)-1)
				EndIf
				
			EndIf
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza alias do cronograma        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cAlias)
			(cAlias)->(dbCloseArea())
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se houveram itens excluidos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFisico .and. len(aItms) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta query para buscar os itens do cronograma fisico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cItms := ""
			For nx:=1 to len(aItms)
				cItms += "'"+aItms[nx]+"',"
			Next
			
			cQuery := "SELECT CNS.R_E_C_N_O_ AS RECNO FROM "+RetSQLName("CNS")+" CNS WHERE "
			cQuery += "CNS.CNS_FILIAL = '"+xFilial("CNS")+"' AND "
			cQuery += "CNS.CNS_CONTRA = '"+CNA->CNA_CONTRA+"' AND "
			cQuery += "CNS.CNS_REVISA = '"+CNA->CNA_REVISA+"' AND "
			cQuery += "CNS.CNS_CRONOG = '"+CNA->CNA_CRONOG+"' AND "
			cQuery += "CNS.CNS_ITEM IN ("+SubStr(cItms,1,len(cItms)-1)+") AND "
			cQuery += "CNS.D_E_L_E_T_ = ' '"
			
			cAlias := GetNextAlias()
			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlias, .F., .T. )
			
			dbSelectArea("CNS")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui os itens do cronograma fisico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !(cAlias)->(Eof())
				CNS->(dbGoTo((cAlias)->RECNO))
				RecLock("CNS",.F.)
				dbDelete()
				MsUnlock()
				(cAlias)->(dbSkip())
			EndDo
		EndIf
		
		//Armazena valor total antigo da planilha
		nTotAnt := CNA->CNA_VLTOT
		nReajAnt:= CNA->CNA_REAJS
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche valor total da planilha                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("CNA",.F.)
		CNA->CNA_VLTOT := nTot + M->CNA_REAJS
		CNA->CNA_SALDO := nTot + M->CNA_REAJS
		MsUnlock()
		
		//Exclui valor antigo do valor atual
		nTot  := nTot + M->CNA_REAJS - nTotAnt - nReajAnt
		nReaj := M->CNA_REAJS - nReajAnt
		
		//Atualiza valor inicial,atual e saldo do contrato 09/04/07
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CNA")+M->CNA_CONTRA+M->CNA_REVISA)
			cMedEven := MedEven(CN9->CN9_TPCTO)		
			If (cMedEven == "1") .And. (CN9->CN9_CTRT == "2")  //Medica Eventual - Variavel
				RecLock("CN9",.F.)
				CN9->CN9_SALDO += nTot + nReaj
				MsUnlock()			
			Else //Medicao Eventual - Fixo ou Nao Eventual 
				RecLock("CN9",.F.)            
				CN9->CN9_VLINI += nTot               
				CN9->CN9_VLATU += nTot + nReaj
				CN9->CN9_SALDO += nTot + nReaj
				CN9->CN9_REAJS += nReaj
				MsUnlock()			
			EndIf
		Else        
			cMedEven := MedEven(M->CN9_TPCTO)		
			If (cMedEven == "1") .And. (CN9->CN9_CTRT == "2")  //Medica Eventual - Variavel
				M->CN9_SALDO += nTot + nReaj
			Else //Medicao Eventual - Fixo ou Nao Eventual 
				M->CN9_VLINI += nTot               
				M->CN9_VLATU += nTot + nReaj
				M->CN9_SALDO += nTot + nReaj
				M->CN9_REAJS += nReaj
			EndIf
		EndIf                                           
	Case nOpc == 5  //Exclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga os itens da planilha                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNB")
		dbSetOrder(1)
		cFilCod := xFilial("CNB")
		If dbSeek(cFilCod+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_NUMERO)
			While !Eof() .And. CNB->CNB_FILIAL = cFilCod .And. CNB->CNB_CONTRA == CNA->CNA_CONTRA .And. CNB->CNB_REVISA == CNA->CNA_REVISA .And. CNB->CNB_NUMERO == CNA->CNA_NUMERO
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui o lancamento do SIGAPCO ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000354","02","CSUA600",.T.)
					
				If !Empty(CNB->CNB_ITEMSC)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Retira quantidade atendida da solicitacao de compra³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SC1")
					dbSetOrder(1)
					If dbSeek(cFilCod+CNB->CNB_NUMSC+CNB->CNB_ITEMSC)
						RecLock("SC1")
						SC1->C1_QUJE-=If(CNB->CNB_QUANT>CNB->CNB_QTDSOL,CNB->CNB_QTDSOL,CNB->CNB_QUANT)
						//-- Desbloqueia Solicitacao de Compras
						If SC1->C1_QUJE <= 0
							SC1->C1_FLAGGCT := ""
						EndIf
						MsUnlock()
					EndIf
				EndIf
				
				RecLock("CNB", .F.)
				dbDelete()
				MsUnLock()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui o lancamento do SIGAPCO  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000354","02","CSUA600",.T.)
				
				dbSelectArea("CNB")
				dbSkip()
			EndDo
		EndIf
		
		If !Empty(CNA->CNA_CRONOG)
			dbSelectArea("CNF")
			dbSetOrder(2)
			cFilCod := xFilial("CNF")
			dbSeek(cFilCod+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_CRONOG)
			
			//Apaga cronograma referente a planilha
			While !CNF->(Eof()) .And. CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_CONTRA == CNA->CNA_CONTRA .And. CNF->CNF_REVISA == CNA->CNA_REVISA .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG
				RecLock("CNF",.F.)
				dbDelete()
				MsUnlock()
				CNF->(dbSkip())
			EndDo
		EndIf
		
		
		//Atualiza valor inicial,atual e saldo do contrato
		dbSelectArea("CN9")
		If dbSeek(xFilial("CN9")+CNA->CNA_CONTRA+CNA->CNA_REVISA)
			RecLock("CN9",.F.)
			CN9->CN9_VLINI -= CNA->CNA_VLTOT
			CN9->CN9_VLATU -= CNA->CNA_VLTOT
			CN9->CN9_SALDO -= CNA->CNA_VLTOT
			MsUnlock()
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui a amarracao com os conhecimentos                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MsDocument( "CNA", CNA->( RecNo() ), 2, , 3 )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga cabecalho da planilha                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNA")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa o lancamento do SIGAPCO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000354","01","CSUA600",.T.)

		RecLock("CNA", .F.)
		dbDelete()
		MsUnLock()
		
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa PE apos a gravacao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CS600GRP")
	ExecBlock("CS600GRP",.F.,.F.,{nOpc})
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600FilFor³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de filtro da consulta padrao para filtrar apenas os    ³±±
±±³          ³ fornecedores do contrato                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOpc - Opcao selecionada                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600FilFor()
Local lRet := .F.
Local cProg := FunName()

Do Case
	case cProg == "CSUA600" .OR. cProg == "CNTA100"
		If !lContrEd
			lRet := CNC->(dbSeek(xFilial("CNC")+M->CNA_CONTRA+SA2->A2_COD+SA2->A2_LOJA))
		Else
			lRet := (aScan(aForn,{|x| x[1] == SA2->A2_COD .And. x[2] == SA2->A2_LOJA}) > 0)
		EndIf
	case cProg == "CNTA120"
		lRet := CNC->(dbSeek(xFilial("CNC")+M->CND_CONTRA+SA2->A2_COD+SA2->A2_LOJA))
	case cProg == "CNTA090"
		lRet := CNC->(dbSeek(xFilial("CNC")+M->CN8_CONTRA+SA2->A2_COD+SA2->A2_LOJA))
	case cProg == "CNTA220"
		lRet := CNC->(dbSeek(xFilial("CNC")+M->CNM_CONTRA+SA2->A2_COD+SA2->A2_LOJA))
	OtherWise
		lRet := .T.
End Case
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600VldNum³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica numero da planilha                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600VldNum()
Local lRet  := .T.
Local aArea := GetArea()

dbSelectArea("CNA")

If INCLUI
	If dbSeek(xFilial("CNA")+M->CNA_NUMERO+M->CNA_REVISA+M->CNA_NUMERO)
		Help(" ",1,"CSUA600JAE") //"Número de planilha já existente"
		lRet := .F.
	EndIf
Else
	If M->CNA_NUMERO != CNA->CNA_NUMERO .And. dbSeek(xFilial("CNA")+M->CNA_NUMERO+M->CNA_REVISA+M->CNA_NUMERO)
		Help(" ",1,"CSUA600JAE")  //"Número de planilha já existente"
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600VldDini³ Autor ³ Marcelo Custodio      ³ Data ³ 16.01.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica data de inicio da planilha                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600VldDini()
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de contrato                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CN9->CN9_NUMERO != M->CNA_CONTRA .And. CN9->CN9_REVISA != M->CNA_REVISA
	CN9->(dbSetOrder(1))
	CN9->(dbSeek(xFilial("CN9")+M->CNA_CONTRA+M->CNA_REVISA))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de inicio em relacao ao contrato  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dCN9FIM != NIL
	If M->CNA_DTINI < M->CN9_DTINIC .Or. M->CNA_DTINI > dCN9FIM .Or. M->CNA_DTINI < dDataBase
		Help(" ",1,"CSUA600DTI") //"Data de início inválida"
		lRet := .F.
	EndIf
Else
	If M->CNA_DTINI < CN9->CN9_DTINIC .Or. M->CNA_DTINI > CN9->CN9_DTFIM .Or. M->CNA_DTINI < dDataBase
		Help(" ",1,"CSUA600DTI") //"Data de início inválida"
		lRet := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de inicio em relacao a data de termino³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !Empty(M->CNA_DTFIM) .And. M->CNA_DTINI > M->CNA_DTFIM
	Help(" ",1,"CSUA600MEN") //"A data de início não pode ser menor que a data final da planilha"
	lRet := .F.
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS600VldDfim³ Autor ³ Marcelo Custodio      ³ Data ³ 16.01.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica data de termino da planilha                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA600                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS600VldDfim()
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de contrato                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CN9->CN9_NUMERO != M->CNA_CONTRA .And. CN9->CN9_REVISA != M->CNA_REVISA
	CN9->(dbSetOrder(1))
	CN9->(dbSeek(xFilial("CN9")+M->CNA_CONTRA+M->CNA_REVISA))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de termino em relacao ao contrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dCN9FIM != NIL
	If M->CNA_DTFIM < M->CN9_DTINIC .Or. M->CNA_DTFIM > dCN9FIM .Or. M->CNA_DTFIM < dDataBase
		Help(" ",1,"CSUA600DTF")  //"Data final inválida"
		lRet := .F.
	EndIf
Else
	If M->CNA_DTFIM < CN9->CN9_DTINIC .Or. M->CNA_DTFIM > CN9->CN9_DTFIM .Or. M->CNA_DTFIM < dDataBase
		Help(" ",1,"CSUA600DTF")  //"Data final inválida"
		lRet := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de termino em relacao a data de inicio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !Empty(M->CNA_DTINI) .And. M->CNA_DTINI > M->CNA_DTFIM
	Help(" ",1,"CSUA600DFM") //"A data final não pode ser menor que a data de início da planilha"
	lRet := .F.
EndIf
Return lRet

	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS600Track³ Autor ³ Sergio Silveira       ³ Data ³22/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600Track( aCols, aHeader )

Local aEnt     := {}
Local cKey     := M->CNA_CONTRA + M->CNA_REVISA + M->CNA_NUMERO

Local nPosItem := GDFieldPos( "CNB_ITEM", aHeader )
Local nLoop    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percorre o acols                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aCols )
	AAdd( aEnt, { "CNB", cKey + aCols[ nLoop, nPosItem ] } )
Next nLoop

MaTrkShow( aEnt )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS600AGrv ³ Autor ³ Marcelo Custodio      ³ Data ³08/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa gravacao da planilha nos arrays aPlani e aPlIt,    ³±±
±±³          ³ usados na rotina de inclusao de contratos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                       ³±±
±±³          ³ aExp02 - Array com os cabecalhos das planilhas             ³±±
±±³          ³ aExp03 - Array com os itens das planilhas(aCols)           ³±±
±±³          ³ oExp04 - Getdados dos itens                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600AGrv(nOpc,aPlani,aPlIt,oGetDados)
Local nCntFor    := 0
Local nTam       := 0
Local aHeader    := oGetDados:aHeader
Local aCols      := oGetDados:aCols
Local nUsado     := Len(aHeader)
Local nCntFor2   := 0
Local nItem      := 0
Local nTot       := 0
Local nTotAnt    := 0
Local nQtAtd     := 0
Local cFilSC1    := xFilial("SC1")
Local nPosSC1    := aScan(aHeader,{|x| x[2]="CNB_NUMSC"})
Local nPosItSC   := aScan(aHeader,{|x| x[2]="CNB_ITEMSC"})
Local nPosQtSol  := aScan(aHeader,{|x| x[2]="CNB_QTDSOL"})
Local nPosQuant  := aScan(aHeader,{|x| x[2]="CNB_QUANT"})
Local nPosCnaNum := (CNA->(FieldPos("CNA_NUMERO")))
Local nPosCnaRev := (CNA->(FieldPos("CNA_REVISA")))
Local nPosCnaCtr := (CNA->(FieldPos("CNA_CONTRA")))
Local nPosCnaVlt := (CNA->(FieldPos("CNA_VLTOT")))
Local nPosCnaSld := (CNA->(FieldPos("CNA_SALDO")))
Local nPosCnbQtd := (CNB->(FieldPos("CNB_QUANT")))
Local nPosCnbVlt := (CNB->(FieldPos("CNB_VLTOT")))
Local nPosCnbVld := (CNB->(FieldPos("CNB_VLDESC")))
Local cFilCod
Local nPlan
Local nReaj      := 0
Local nReajAnt   := 0  
Local cMedEven   := ""

Do Case
	Case nOpc == 3		// Inclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui planilha                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNA")
		aAdd(aPlani,Array(FCount()))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui itens da planilha                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aPlIt,aClone(aCols))
		nPlan := len(aPlani)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche campos do cabecalho                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)=="CNA_FILIAL")
				aPlani[len(aPlani),nCntFor] := xFilial()
			Else
				aPlani[len(aPlani),nCntFor] := M->&(FieldName(nCntFor))
			EndIf
		Next nCntFor
		
		
		dbSelectArea("CNB")
		nUsado := Len(aHeader)
		cFilCod := xFilial("CNB")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula total dos itens                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] )
				nTot += aCols[nCntFor,aScan(aHeader,{|x| AllTrim(x[2]) == "CNB_VLTOT"})]-aCols[nCntFor,aScan(aHeader,{|x| AllTrim(x[2]) == "CNB_VLDESC"})]
			EndIf
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza valor total do cabecalho               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aPlani[len(aPlani),nPosCnaVlt] := nTot + M->CNA_REAJS
		aPlani[len(aPlani),nPosCnaSld] := nTot	+ M->CNA_REAJS	
		
/*			//Atualiza valor inicial,atual e saldo do contrato 09/04/07
			dbSelectArea("CN9")
			dbSetOrder(1)
			If dbSeek(xFilial("CNA")+M->CNA_CONTRA+M->CNA_REVISA)
				cMedEven := MedEven(CN9->CN9_TPCTO)		
				If (cMedEven == "1") .And. (CN9->CN9_CTRT == "2")  //Medica Eventual - Variavel
					RecLock("CN9",.F.)
					CN9->CN9_SALDO += nTot + M->CNA_REAJS
					MsUnlock()			
				Else //Medicao Eventual - Fixo ou Nao Eventual 
					RecLock("CN9",.F.)            
					CN9->CN9_VLINI += nTot               
					CN9->CN9_VLATU += nTot + M->CNA_REAJS
					CN9->CN9_SALDO += nTot + M->CNA_REAJS
					CN9->CN9_REAJS += M->CNA_REAJS
					MsUnlock()			
				EndIf
			Else                                        
				cMedEven := MedEven(M->CN9_TPCTO)				
				If (cMedEven == "1") .And. (M->CN9_CTRT == "2")  //Medica Eventual - Variavel
					M->CN9_SALDO += nTot + M->CNA_REAJS
				Else //Medicao Eventual - Fixo ou Nao Eventual 
					M->CN9_VLINI += nTot               
					M->CN9_VLATU += nTot + M->CNA_REAJS
					M->CN9_SALDO += nTot + M->CNA_REAJS
					M->CN9_REAJS += M->CNA_REAJS
				EndIf
			EndIf                                           */

	Case nOpc == 4  //Alteracao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche campos do cabecalho                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNA")
		
		nPlan := aScan(aplani,{|x| x[CNA->(FieldPos("CNA_NUMERO"))] == M->CNA_NUMERO})
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)=="CNA_FILIAL")
				aPlani[nPlan,nCntFor] := xFilial()
			Else
				aPlani[nPlan,nCntFor] := M->&(FieldName(nCntFor))
			EndIf
		Next nCntFor
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula total dos itens                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] )
				nTot += aCols[nCntFor,aScan(aHeader,{|x| AllTrim(x[2]) == "CNB_VLTOT"})]-aCols[nCntFor,aScan(aHeader,{|x| AllTrim(x[2]) == "CNB_VLDESC"})]
			EndIf
		Next
		
		//Armazena valor total antigo da planilha
		nTotAnt := CNA->CNA_VLTOT
		nReajAnt:= CNA->CNA_REAJS
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza valor total do cabecalho               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aPlani[nPlan,nPosCnaVlt] := nTot + M->CNA_REAJS
		aPlani[nPlan,nPosCnaSld] := nTot + M->CNA_REAJS
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza itens da planilha                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aPlIt[nPlan] := aClone(aCols)    
		
		//Exclui valor antigo do valor atual
		nTot  := nTot + M->CNA_REAJS - nTotAnt - nReajAnt
		nReaj := M->CNA_REAJS - nReajAnt
	
/*			//Atualiza valor inicial,atual e saldo do contrato 09/04/07
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CNA")+M->CNA_CONTRA+M->CNA_REVISA)
			cMedEven := MedEven(CN9->CN9_TPCTO)		
			If (cMedEven == "1") .And. (CN9->CN9_CTRT == "2")  //Medica Eventual - Variavel
				RecLock("CN9",.F.)
				CN9->CN9_SALDO += nTot + nReaj
				MsUnlock()			
			Else //Medicao Eventual - Fixo ou Nao Eventual 
				RecLock("CN9",.F.)            
				CN9->CN9_VLINI += nTot               
				CN9->CN9_VLATU += nTot + nReaj
				CN9->CN9_SALDO += nTot + nReaj
				CN9->CN9_REAJS += nReaj
				MsUnlock()			
			EndIf
		Else        
			cMedEven := MedEven(M->CN9_TPCTO)		
			If (cMedEven == "1") .And. (CN9->CN9_CTRT == "2")  //Medica Eventual - Variavel
				M->CN9_SALDO += nTot + nReaj
			Else //Medicao Eventual - Fixo ou Nao Eventual 
				M->CN9_VLINI += nTot               
				M->CN9_VLATU += nTot + nReaj
				M->CN9_SALDO += nTot + nReaj
				M->CN9_REAJS += nReaj
			EndIf
		EndIf                                           */
	Case nOpc == 5  //Exclusao
		dbSelectArea("CNA")
		
		nPlan := aScan(aplani,{|x| x[CNA->(FieldPos("CNA_NUMERO"))] == M->CNA_NUMERO})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui planilha                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDel(aPlani,nPlan)
		aSize(aPlani,len(aPlani)-1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui itens da planilha                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDel(aPlIt,nPlan)
		aSize(aPlIt,len(aPlIt)-1)
		
EndCase

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS600GerHd³ Autor ³ Marcelo Custodio      ³ Data ³08/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera o aHeade dos itens, usado na  rotina de manutencao de ³±±
±±³          ³ planilhas e na rotina de inclusao de contratos, para       ³±±
±±³          ³ identificar os campos do array aPlIt                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                       ³±±
±±³          ³ lExp02 - Exibe campos de readequacao                       ³±±
±±³          ³ lExp03 - Exibe campos de realinhamento                     ³±±
±±³          ³ lExp04 - Informa se a edicao esta sendo realizada pela     ³±±
±±³          ³          rotina de inclusao de contrato                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS600GerHd(nOpc,lReadq,lReali,lContrEd)
//Campos excluidos na montagem do aHeader
Local aCpoNH  := {"CNB_FILIAL","CNB_NUMERO","CNB_REVISA","CNB_CODMEN","CNB_OBS","CNB_DTANIV","CNB_CONORC","CNB_CONTRA","CNB_DTCAD","CNB_DTPREV","CNB_CONTA","CNB_PERC","CNB_RATEIO","CNB_TIPO","CNB_ITSOMA","CNB_PRCORI","CNB_QTDORI","CNB_QTRDAC","CNB_QTRDRZ","CNB_PERCAL","CNB_FILHO"}
Local aHeader := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao exibe campos referentes aos saldos dos itens durante a inc/alter  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nOpc == 3 .Or. nOpc == 4) .Or. lContrEd
	aAdd(aCpoNH,"CNB_SLDMED")
	aAdd(aCpoNH,"CNB_SLDREC")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao exibe campos referentes a revisao do tipo realinhamento           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 3 .Or. nOpc == 4 .Or. !lReali .Or. lContrEd
	aAdd(aCpoNH,"CNB_DTREAL")
	aAdd(aCpoNH,"CNB_REALI")
	aAdd(aCpoNH,"CNB_VLTOTR")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao exibe campos referentes a revisao do tipo readequacao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 3 .Or. nOpc == 4 .Or. !lReadq .Or. lContrEd
	aAdd(aCpoNH,"CNB_QTREAD")
	aAdd(aCpoNH,"CNB_VLREAD")
	aAdd(aCpoNH,"CNB_VLRDGL")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MOnta aHeader                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("CNB")
While !EOF() .And. (SX3->X3_ARQUIVO == "CNB")
	If X3Uso(X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. Ascan(aCpoNH,{|x| x == alltrim(SX3->X3_CAMPO)}) == 0
		
		Aadd(aHeader, { alltrim( X3Titulo() ),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

Return aHeader


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS600Conhec³ Autor ³Sergio Silveira       ³ Data ³27/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada da visualizacao do banco de conhecimento            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS600Conhec()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CS600Conhec()
	
Local aRotBack  := AClone( aRotina )
	
Private aRotina := {}
	
Aadd(aRotina,{ STR0042,"MsDocument", 0 , 2}) // "Conhecim."
	
MsDocument( "CNA", CNA->( Recno() ), 1 )
	
aRotina := AClone( aRotBack )

Return( .t. )  
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³19/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     		  ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()     
PRIVATE aRotina	:= { 	{ OemToAnsi(STR0002), "AxPesqui"  , 0, 1, 0, .F.},;		//"Pesquisar"
							{ OemToAnsi(STR0003), "u_CS600Manut", 0, 2, 0, nil},;			//"Visualizar"
							{ OemToAnsi(STR0004), "u_CS600Manut", 0, 3, 0, nil},;			//"Incluir"
							{ OemToAnsi(STR0005), "u_CS600Manut", 0, 4, 0, nil},;			//"Alterar"
							{ OemToAnsi(STR0006), "u_CS600Manut", 0, 5, 0, nil},; 			//"Excluir"         
							{ OemToAnsi("Copiar"),"u_CS600Manut", 0, 3, 0, nil},; 			//"Copiar"
							{ OemToAnsi(STR0040), "MsDocument", 0, 4, 0, nil } }			//"Conhecimento"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTA200MNU")
	ExecBlock("CTA200MNU",.F.,.F.)
EndIf
Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MedEven   ºAutor  ³Aline Catarina      º Data ³  09/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o tipo de medicao                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MedEven(cTipoCon)
	Local cMedEv := ""
	
	DbSelectArea("CN1")
	DbSetOrder(1)       
	If DbSeek(xFilial("CN1")+cTipoCon)
		cMedEv := CN1->CN1_MEDEVE
	EndIf             	
Return (cMedEv)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSUA600W  ºAutor  ³Aline Catarina      º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o campo podera ser alterado                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gestao de Contratos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                
User Function CSUA600W()
	Local lRet := .T.
	Local aArea := GetArea()
    Local cTipoCon := "1"
                             
	If AllTrim(Upper(Funname())) = "CSUA600"
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CNA")+M->CNA_CONTRA+M->CNA_REVISA)
			cTipoCon := CN9_TPCTO
		EndIf             

		DbSelectArea("CN1")
		DbSetOrder(1)       
		If DbSeek(xFilial("CN1")+cTipoCon) .And. CN1->CN1_MEDEVE != "1"
			lRet := .F.
		EndIf             
	EndIf
	RestArea(aArea)	
Return lRet           
