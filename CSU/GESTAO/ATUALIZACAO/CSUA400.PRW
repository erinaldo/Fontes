

#INCLUDE "CNTA100.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"

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

//Tipos de Revisao
#DEFINE DEF_ADITI "1" //Aditivo
#DEFINE DEF_REAJU "2" //Reajuste
#DEFINE DEF_REALI "3" //Realinhamento
#DEFINE DEF_READQ "4" //Readequacao
#DEFINE DEF_PARAL "5" //Paralisacao
#DEFINE DEF_REINI "6" //Reinicio
#DEFINE DEF_CLAUS "7" //Alteracao de Clausula

#DEFINE DEF_TRANS  "001"//Transacao de controle total do contrato
#DEFINE DEF_TRASIT "018"//Transacao de controle de situacoes
#DEFINE DEF_TRAVIS "037"//Transacao de visualizacao do contrato
#DEFINE DEF_TRABCO "038"//Transacao de controle sobre o banco de conhecimento
#DEFINE DEF_TRAEDT "039"//Transacao de controle sobre a edicao do contrato   
#DEFINE DEF_TRARET "040"//Transacao de controle sobre a baixa da retencao

#DEFINE FLD_BAIXA "BAIXA"//Campo de baixa da retencao
#DEFINE FLD_SALDO "SALDO"//Campo de saldo da retencao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CSUA400  ³ Autor ³ Microsiga      ³ Data ³26.12.2005       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Contratos                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSUA400()                                                  ³±±
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
User Function CSUA400()
Local aCores := {	{ "Alltrim(CN9->CN9_SITUAC) == '01'", "BR_VERMELHO"},;		// Cancelado
			  			{ "Alltrim(CN9->CN9_SITUAC) == '02'", "BR_AMARELO"	},;	  	// Elaboracao
						{ "Alltrim(CN9->CN9_SITUAC) == '03'", "BR_AZUL"		},;   	// Emitido
						{ "Alltrim(CN9->CN9_SITUAC) == '04'", "BR_LARANJA"	},;    	// Em Aprovacao
						{ "Alltrim(CN9->CN9_SITUAC) == '05'", "BR_VERDE"	},;		// Vigente
						{ "Alltrim(CN9->CN9_SITUAC) == '06'", "BR_CINZA"	},;		// Paralisado
			  			{ "Alltrim(CN9->CN9_SITUAC) == '07'", "BR_MARRON"	},;   	// Sol. Finalizacao
			  			{ "Alltrim(CN9->CN9_SITUAC) == '08'", "BR_PRETO"	},;		// Finalizado
			  			{ "Alltrim(CN9->CN9_SITUAC) == '09'", "BR_PINK"		},;   	// Revisao
			 			{ "Alltrim(CN9->CN9_SITUAC) == '10'", "BR_BRANCO"	}}			// Revisado

Private cCadastro := OemToAnsi(STR0001) //Manutencao de Contratos
Private lVal	  := .T.
Private aRotina   := MenuDef()

AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Mostra Lancamentos   S/N                          ³
//³ mv_par02 - Aglut Lancamentos    S/N                          ³
//³ mv_par03 - Lancamentos Online   S/N                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey(VK_F12,{|| Pergunte("CNT100",.T.)})

Pergunte("CNT100",.F.)

mBrowse(6,1,22,75,"CN9",,,,,,aCores)

SetKey( VK_F12 , Nil )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Cron  ³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina que realiza chamada para o Wizard de cronogramas     ³±±
±±³          ³ CSUA400                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Cron(nExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA400                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Cron(nOpc)
Local aArea := GetArea()
Local nCntFor

dbSelectArea("CNF")
dbSetOrder(2)
If dbSeek(xFilial("CNF")+M->CN9_NUMERO+M->CN9_REVISA)
	u_CS410Manut("CNF",CNF->(Recno()),nOpc,,M->CN9_NUMERO,M->CN9_REVISA)
	
	//Atualiza cronograma
	dbSelectArea("CNF")
	dbGoTop()
	dbSetOrder(2)
	dbSeek(xFilial("CNF")+M->CN9_NUMERO+M->CN9_REVISA)
	aCols4 := {}
	While !Eof() .And. CNF->CNF_FILIAL = xFilial("CNF") .And. CNF->CNF_CONTRA == M->CN9_NUMERO .And. CNF->CNF_REVISA == M->CN9_REVISA
		aAdd(aCols4,Array(Len(aHeader4)+1))
		For nCntFor	:= 1 To Len(aHeader4)
			cCampo := Alltrim(aHeader4[nCntFor,2])
			If ( aHeader4[nCntFor][10] != "V" )
				aCols4[Len(aCols4)][nCntFor] := FieldGet(FieldPos(aHeader4[nCntFor][2]))
			Else
				aCols4[Len(aCols4)][nCntFor] := CriaVar(aHeader4[nCntFor][2])
			EndIf
		Next nCntFor
		aCols4[Len(aCols4), Len(aHeader4)+1] := .F.
		dbSelectArea("CNF")
		dbSkip()
	EndDo

	oGetDad4:aCols := aCols4
Else
	Aviso("CSUA400",OemtoAnsi(STR0138),{"Ok"})//"O contrato não possui cronograma financeiro/físico"
EndIf

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Manut ³ Autor ³ Microsiga      ³ Data ³26.12.2005       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de manutencao de contrato                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  CS400Manut(cExp01,nExp02,nExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Alias                                              ³±±
±±³          ³ nExp02 - Registro atual                                     ³±±
±±³          ³ nExp03 - Opcao atual                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA400                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400Manut(cAlias,nReg,nOpc)

Local aSize      := MsAdvSize()
Local aPosObj    := {}
Local aObjects   := {}
Local aArea      := GetArea()
Local aTitles    := {OemtoAnsi(STR0008),OemtoAnsi(STR0009),OemtoAnsi(STR0010),OemtoAnsi(STR0011),OemtoAnsi(STR0012),OemtoAnsi(STR0062)}//"Fornecedores"##"Caucoes"##Planilhas"##"Cronogramas"##"Multas"##"Documentos"
Local nGd1       := 0
Local nGd2       := 0
Local nGd3       := 0
Local nGd4       := 0
Local nOpcA      := 0
Local aCpos      := {}
Local lMedEve    := .F.//Med. Enventual
Local lContinua  := .T.
Local aButtons   := {}
Local lContraVld := ExistBlock("u_CSVLDPER")
Local oDlg
Local nX
Local lAntInc

//Campos nao exibidos para o contrato
Local aCpoN      := {"CN9_JUSTIF","CN9_DESSTA","CN9_TIPREV","CN9_MOTPAR","CN9_DTFIMP","CN9_DTREIN","CN9_DTREAJ","CN9_VLREAJ","CN9_NUMTIT","CN9_ALTCLA","CN9_VLMEAC","CN9_TXADM","CN9_FORMA","CN9_DTENTR","CN9_LOCENT","CN9_CODENT","CN9_DESLOC","CN9_DESFIN","CN9_CONTFI","CN9_DTINPR","CN9_PERPRO","CN9_UNIPRO","CN9_VLRPRO","CN9_DTINCP"}

Local aTela[0][0]
Local aGets[0]

//Planilhas
Local aPlani := {}
Local aPlIt  := {}
Local lAltPla:= (nOpc == 3 .Or. nOpc == 4)

Local lCaucRet   := (nOpc != 3 .And. (CN9->( FieldPos("CN9_TPCAUC") ) > 0) .And. CN9->CN9_FLGCAU == "1" .And. CN9->CN9_TPCAUC == "2")

//Controle da numeracao sequencial
Local nStack    := GetSX8Len()

If nOpc != 3 .And. !Empty(CN9->CN9_NUMERO)
	lContinua := CN240VldUsr(CN9->CN9_NUMERO,If(nOpc==2,DEF_TRAVIS,DEF_TRAEDT),.T.)
EndIf

If lContinua
	Private oFolder
	//Controles do fornecedor - CNC
	Private aHeader1  := {}
	Private aCols1    := {}
	Private aRecCNC   := {}
	Private oGetDad1
	//Controles da caucao - CN8
	Private aHeader2  := {}
	Private aCols2    := {}
	Private oGetDad2
	//Controles das planilhas - CNA
	Private aHeader3  := {}
	Private aCols3    := {}
	Private oGetDad3
	//Controles dos cronogramas - CNF
	Private aHeader4  := {}
	Private aCols4    := {}
	Private oGetDad4
	//Controles das multas - CNA
	Private aHeader5  := {}
	Private aCols5    := {}
	Private aRecCNH   := {}
	Private oGetDad5
	//Controles dos documentos - CNK
	Private aHeader6  := {}
	Private aCols6    := {}
	Private aRecCNK   := {}
	Private oGetDad6
	
	If lCaucRet
		//Caucoes Retidas - CNT
		Private aHeader7  := {}
		Private aCols7    := {}
		Private aRecCNT   := {}
		Private oGetDad7
		aAdd(aTitles,STR0086)//"Caucões Retidas"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle para verificacao da estrutura do campo    ³
	//³ CNK_CONTRA                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	CN170AjSX3()
	
	//Verifica se o contrato possui revisao
	If (nOpc == 4 .OR. nOpc == 5) .And. !Empty(CN9->CN9_REVATU)
		Help(" ",1,"CSUA400REV") //"Contrato revisado"
		Return .F.
	EndIf
	
	If (nOpc == 4 .OR. nOpc == 5) .And. AllTrim(CN9->CN9_SITUAC) != DEF_SELAB
		Help(" ",1,"CSUA400ELB") //"Acao disponivel apenas para contratos em Elaboracao"
		Return .F.
	EndIf
	
	dbSelectArea("SX3")
	MsSeek("CN9")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona os campos do cabecalho dos contratos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. SX3->X3_ARQUIVO == "CN9"
		
		If X3Uso(X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. Ascan(aCpoN,{|x| x == alltrim(SX3->X3_CAMPO)}) == 0
			Aadd(aCpos, SX3->X3_CAMPO )
		EndIF
		
		If	( SX3->X3_CONTEXT == "V"  .Or. nOpc == 3 )
			M->&(SX3->X3_CAMPO) := CriaVar(SX3->X3_CAMPO)
		Else
			M->&(SX3->X3_CAMPO) := CN9->(FieldGet(FieldPos(SX3->X3_CAMPO)))
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos Memo do Contrato³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc != 3
		M->CN9_OBJCTO := MSMM(M->CN9_CODOBJ)
		M->CN9_JUSTIF := MSMM(M->CN9_CODJUS)
		Aadd(aCpos,"CN9_JUSTIF")
		M->CN9_ALTCLA := MSMM(M->CN9_CODCLA)
		Aadd(aCpos,"CN9_ALTCLA")
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos acols e aheaders dos folders 		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS400Acols(nOpc,lCaucRet)
	
	SETAPILHA()
	
	//Configura botoes de acesso ao cronograma e planilhas na alteracao
	If nOpc == 4
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o contrato tem medicao eventual 	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMedEve := (Posicione("CN1",1,xFilial("CN1")+M->CN9_TPCTO,"CN1_MEDEVE") == "1")
		If !lMedEve//Exibe o botao de cronograma quando o contrato nao for de med. eventual
			Aadd(aButtons,{"BUDGET"   ,{|| CS400Cron(nOpc)},OemToAnsi(STR0015),OemtoAnsi(STR0054)})//"Cronogramas"
		EndIf
	EndIf
	Aadd(aButtons,{"NOTE",{|| CS400Hist(M->CN9_NUMERO)},OemtoAnsi(STR0034)})//"Historico"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Botao para exportar dados para EXCEL                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction("RemoteType") .And. RemoteType() == 1
		aAdd(aButtons   , {PmsBExcel()[1],{|| DlgToExcel({ {"ENCHOICE",STR0036,aGets,aTela},{"GETDADOS",OemToAnsi(STR0008),aHeader1,aCols1},{"GETDADOS",OemToAnsi(STR0009),aHeader2,aCols2},{"GETDADOS",OemToAnsi(STR0014),aHeader3,aCols3},{"GETDADOS",OemToAnsi(STR0011),aHeader4,aCols4},{"GETDADOS",OemToAnsi(STR0012),aHeader5,aCols5} })},PmsBExcel()[2],PmsBExcel()[3]})
	EndIf
	
	If aRotina[ nOpc, 4 ] == 2
		AAdd(aButtons,{ "BPMSDOC", {|| CS400Conh()  }, STR0056, STR0057 } ) // "Banco de Conhecimento", "Conhecim."
		AAdd(aButtons,{ "ORDEM",   {|| CS400Track() }, STR0059, STR0060 } ) // "System Tracker", "Tracker"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa integracao com o PCO      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aRotina[ nOpc, 4 ] == 3
		PcoIniLan("000354")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a Tela Principal										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	aAdd( aObjects, {   0, 119, .t., .t. } )
	aAdd( aObjects, { 120, 101, .t., .t. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
	
	EnChoice( cAlias, nReg, nOpc, , , ,aCpos, aPosObj[1], , , , , , , , .T.)
	oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitles,,oDlg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define as posicoes da Getdados a partir do folder    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nGd1 := 2
	nGd2 := 2
	nGd3 := aPosObj[2,3]-aPosObj[2,1]-15
	nGd4 := aPosObj[2,4]-aPosObj[2,2]-2
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta folder das multas (CNH) permitindo insercao    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad5 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),"u_CSVldMul()",,,,,,,,,oFolder:aDialogs[5],aHeader5,aCols5)
	DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION CS400Visual() ENABLE OF oFolder:aDialogs[5]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta folder dos cronogramas                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad4 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,0,,,,,,,,,,oFolder:aDialogs[4],aHeader4,aCols4)
	DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION CS400Visual() ENABLE OF oFolder:aDialogs[4]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta folder das planilhas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad3 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,0,,,,,,,,,,oFolder:aDialogs[3],aHeader3,aCols3)
	DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION CS400Visual(nOpc,aPlani,aPlIt) ENABLE OF oFolder:aDialogs[3]//Visualizar
	@ nGd3-12 ,nGd4-119 BUTTON OemToAnsi(STR0007) SIZE 29 ,13  FONT oDlg:oFont WHEN lAltPla ACTION If(nOpc==3,CS400IncArr(nOpc,aPlani,aPlIt),CS400IncPla()) OF oFolder:aDialogs[3] PIXEL//Incluir
	@ nGd3-12 ,nGd4-89  BUTTON OemToAnsi(STR0083) SIZE 29 ,13  FONT oDlg:oFont WHEN lAltPla ACTION If(nOpc==3,CS400AltArr(4,aPlani,aPlIt),CS400AltPla(4)) OF oFolder:aDialogs[3] PIXEL//Editar
	@ nGd3-12 ,nGd4-59  BUTTON OemToAnsi(STR0006) SIZE 29 ,13  FONT oDlg:oFont WHEN lAltPla ACTION If(nOpc==3,CS400AltArr(5,aPlani,aPlIt),CS400AltPla(5)) OF oFolder:aDialogs[3] PIXEL//Excluir
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta folder das caucoes                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad2 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,0,,,,,,,,,,oFolder:aDialogs[2],aHeader2,aCols2)
	DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION CS400Visual() ENABLE OF oFolder:aDialogs[2]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta folder dos fornecedores, permitindo insercao   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad1 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),"u_CSVldFor()",,,,,999,,,"u_CSDelFor()",oFolder:aDialogs[1],@aHeader1,@aCols1)
	DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION CS400Visual() ENABLE OF oFolder:aDialogs[1]
	@ nGd3-12 ,nGd4-59  BUTTON OemToAnsi(STR0082) SIZE 29 ,13  FONT oDlg:oFont ACTION CN220Aval("CNM",nReg,nOpc,,.T.,,oGetDad1:aCols[oGetDad1:nAt,aScan(oGetDad1:aHeader,{|x| x[2] == "CNC_CODIGO"})],oGetDad1:aCols[oGetDad1:nAt,aScan(oGetDad1:aHeader,{|x| x[2] == "CNC_LOJA"})]) OF oFolder:aDialogs[1] PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta folder de visualizacao de documentos           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad6 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,0,,,,,,,,,,oFolder:aDialogs[6],@aHeader6,@aCols6)
	DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION CS400Visual() ENABLE OF oFolder:aDialogs[6]
	
	If lCaucRet
		oGetDad7 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,0,,,,,,,,,,oFolder:aDialogs[7],@aHeader7,@aCols7)
		@ nGd3-12 ,nGd4-35  BUTTON STR0114 SIZE 35 ,13  FONT oDlg:oFont ACTION CS400BxCauc(.T.) OF oFolder:aDialogs[7] PIXEL//"Baixar"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui linha em branco das getdados de visualizacao  ³
	//³ quando nao houver informacao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aCols4) == 0
		aDel(oGetDad4:aCols,1)
		aSize(oGetDad4:aCols,0)
	EndIf
	If Len(aCols3) == 0
		aDel(oGetDad3:aCols,1)
		aSize(oGetDad3:aCols,0)
	EndIf
	If Len(aCols2) == 0
		aDel(oGetDad2:aCols,1)
		aSize(oGetDad2:aCols,0)
	EndIf
	
	oFolder:bSetOption:={|nAtu| CS400FoldCh(nAtu,oFolder:nOption)}
	
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| If(Obrigatorio(aGets,aTela) .And. u_CSVldFor() .And. u_CSVldMul() .And. u_CS400TudOk() .And. If(nOpc!=3 .And. nOpc!=2,CSVldPer(),.T.) .And. If (lContraVld, ExecBlock("u_CSVLDPER",.F.,.F.), .T.),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||(nOpcA:=2,oDlg:End())},,aButtons))
	
	If nOpcA == 1 .And. nOpc != 2
		//Atualiza aCols
		aCols1 := oGetDad1:aCols
		aCols5 := oGetDad5:aCols
		CS400Grv(nOpc,aPlani,aPlIt)
		While GetSX8Len() > nStack
			ConfirmSX8()
		EndDo
		EvalTrigger()
		msUnlockAll()
		
		//Atualiza campos MEMO
		If nOpc != 5
			MSMM(M->CN9_CODOBJ,,,M->CN9_OBJCTO,1,,,"CN9","CN9_CODOBJ")
			MSMM(M->CN9_ALTCLA,,,M->CN9_ALTCLA,1,,,"CN9","CN9_CODCLA")
		EndIf
	Else
		While GetSX8Len() > nStack
			RollBackSX8()
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza lancamentos do PCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If aRotina[ nOpc, 4 ] == 3
		PcoFinLan("000354")  
		PcoFreeBlq("000354")
	EndIf
EndIf

RestArea(aArea)
Return nOpcA


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Acols ³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Monta acols para as getdados do folder                      ³±±
±±³          ³ -Fornecedor                                                 ³±±
±±³          ³ -Caucao                                                     ³±±
±±³          ³ -Planilha                                                   ³±±
±±³          ³ -Cronograma                                                 ³±±
±±³          ³ -Multas                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  CS400Acols(nExp01)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA400                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Acols(nOpc,lCaucRet)
Local aCpoH      := {}//Tabelas dos  folders
Local aCpoNH     := {}//Campos nao exibidos
Local nCntFor    := 0
Local nX         := 0
Local nA         := 0
Local cQuery
Local aStrucCNK  := CNK->(dbStruct())
Local aStrucCN8  := CN8->(dbStruct())
Local aStrucCNF  := CNF->(dbStruct())
Local aStrucCNT  := {}

dbSelectArea("CNK")
dbSelectArea("CN5")

If lCaucRet .And. AliasInDic("CNT")
	aStructCNT := CNT->(dbStruct())
Else
	lCaucRet := .F.
EndIf

dbSelectArea("SX2")
dbSetOrder(1)
If dbSeek("CNM")
	dbSelectArea("CNM")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os aHeaders 								     	  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCpoH  := {"CNC","CN8","CNA","CNF","CNH","CNK"}
aCpoNH := {"CNC_NUMERO","CN8_CONTRA|CN8_REVISA","CNA_CONTRA|CNA_REVISA","CNF_CONTRA|CNF_REVISA","CNH_NUMERO","CNK_OBS","CNK_CONTRA|CNK_TPCOD"}

If lCaucRet
	aAdd(aCpoH,"CNT")
	aAdd(aCpoNH,"CNT_CONTRA")
EndIF

For nA:=1 To len(aCpoH)
	cNomeHeader := 'aHeader'+StrZero(nA,1)
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	If dbSeek(aCpoH[nA], .F.)
		Do While !Eof() .And. SX3->X3_ARQUIVO==aCpoH[nA]
			If ( X3USO(SX3->X3_USADO)) .And. !(Alltrim(SX3->X3_CAMPO) $ aCpoNH[nA]) .And. cNivel >= SX3->X3_NIVEL
				aAdd(&(cNomeHeader),{AllTrim(X3Titulo()),;
				AllTrim(SX3->X3_CAMPO),;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT})
			EndIf
			dbSkip()
		EndDo
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui campo com a descricao do documento                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbsetorder(2)
If dbSeek("CN5_DESCRI")
	If ( X3USO(SX3->X3_USADO))
		aAdd(aHeader6,{AllTrim(X3Titulo()),;
		AllTrim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos aCols 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CNC - Fornecedores											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNC")
dbSetOrder(1) //CNC_FILIAL+CNC_NUMERO+CNC_CODIGO+CNC_LOJA
If dbSeek(xFilial("CNC")+M->CN9_NUMERO)
	While !Eof() .And. CNC->CNC_FILIAL = xFilial("CNC") .And. CNC->CNC_NUMERO == M->CN9_NUMERO
		aAdd(aCols1,Array(Len(aHeader1)+1))
		For nCntFor	:= 1 To Len(aHeader1)
			cCampo := Alltrim(aHeader1[nCntFor,2])
			If ( aHeader1[nCntFor][10] != "V" )
				aCols1[Len(aCols1)][nCntFor] := FieldGet(FieldPos(aHeader1[nCntFor][2]))
			Else
				aCols1[Len(aCols1)][nCntFor] := CriaVar(aHeader1[nCntFor][2])
			EndIf
		Next nCntFor
		aCols1[Len(aCols1), Len(aHeader1)+1] := .F.
		Aadd(aRecCNC,Recno())
		dbSelectArea("CNC")
		dbSkip()
	EndDo
Else
	aAdd(aCols1,Array(Len(aHeader1)+1))
	For nX := 1 To Len(aHeader1)
		aCols1[1, nX] := CriaVar(aHeader1[nX, 2])
	Next nX
	aCols1[Len(aCols1), Len(aHeader1)+1] := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CN8 - Caucoes			           					 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CN8")
cQuery := "Select CN8.* from "+ RetSQLName("CN8") +" CN8 "
cQuery += "where CN8.CN8_FILIAL = '"+ xFilial("CN8") +"' AND "
cQuery += "CN8.CN8_CONTRA = '"+ M->CN9_NUMERO +"' AND "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra caucao pelo codigo do contrato quando o contrato for  ³
//³ uma revisao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(CN9->CN9_SITUAC) != DEF_SREVS
	cQuery += "CN8.CN8_REVISA = '"+ M->CN9_REVISA +"' AND "
EndIf
cQuery += "CN8.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY CN8.CN8_CODIGO"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CN8TMP",.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura campos especiais                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to len(aStrucCN8)
	if CN8TMP->(FieldPos(aStrucCN8[nx,1])) > 0 .And. aStrucCN8[nx,2] <> "C"
		TCSetField( "CN8TMP", aStrucCN8[nx,1], aStrucCN8[nx,2], aStrucCN8[nx,3], aStrucCN8[nx,4] )
	endif
Next

If !CN8TMP->(Eof())
	While !CN8TMP->(Eof())
		aAdd(aCols2,Array(Len(aHeader2)+1))
		For nCntFor	:= 1 To Len(aHeader2)
			cCampo := Alltrim(aHeader2[nCntFor,2])
			If ( aHeader2[nCntFor][10] != "V" )
				aCols2[Len(aCols2)][nCntFor] := CN8TMP->&(aHeader2[nCntFor][2])
			Else
				aCols2[Len(aCols2)][nCntFor] := CriaVar(aHeader2[nCntFor][2])
			EndIf
		Next nCntFor
		aCols2[Len(aCols2), Len(aHeader2)+1] := .F.
		
		CN8TMP->(dbSkip())
	EndDo
Else
	aAdd(aCols2,Array(Len(aHeader2)+1))
	For nX := 1 To Len(aHeader2)
		aCols2[1, nX] := CriaVar(aHeader2[nX, 2],.F.)
	Next nX
	aCols2[Len(aCols2), Len(aHeader2)+1] := .F.
EndIf

CN8TMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CNA - Cabecalho das Planilhas								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNA")
dbSetOrder(3) //CNA_FILIAL+CNA_CONTRA+CNA_REVISA
If dbSeek(xFilial("CNA")+M->CN9_NUMERO+M->CN9_REVISA)
	While !Eof() .And. CNA->CNA_FILIAL = xFilial("CNA") .And. CNA->CNA_CONTRA == M->CN9_NUMERO .And. CNA->CNA_REVISA == M->CN9_REVISA
		aAdd(aCols3,Array(Len(aHeader3)+1))
		For nCntFor	:= 1 To Len(aHeader3)
			cCampo := Alltrim(aHeader3[nCntFor,2])
			If ( aHeader3[nCntFor][10] != "V" )
				aCols3[Len(aCols3)][nCntFor] := FieldGet(FieldPos(aHeader3[nCntFor][2]))
			Else
				aCols3[Len(aCols3)][nCntFor] := CriaVar(aHeader3[nCntFor][2])
			EndIf
		Next nCntFor
		aCols3[Len(aCols3), Len(aHeader3)+1] := .F.
		dbSelectArea("CNA")
		dbSkip()
	EndDo
Else
	aAdd(aCols3,Array(Len(aHeader3)+1))
	For nX := 1 To Len(aHeader3)
		aCols3[1, nX] := CriaVar(aHeader3[nX, 2],.F.)
	Next nX
	aCols3[Len(aCols3), Len(aHeader3)+1] := .F.
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CNF - Cronograma		               				 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNF")
cQuery := "Select CNF.* from "+ RetSQLName("CNF") +" CNF "
cQuery += "where CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
cQuery += "CNF.CNF_CONTRA = '"+ M->CN9_NUMERO +"' AND "
cQuery += "CNF.CNF_REVISA = '"+ M->CN9_REVISA +"' AND "
cQuery += "CNF.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY CNF.CNF_NUMERO,CNF.CNF_PARCEL"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CNFTMP",.F.,.T.)

For nx:=1 to len(aStrucCNF)
	if CNFTMP->(FieldPos(aStrucCNF[nx,1])) > 0 .And. aStrucCNF[nx,2] <> "C"
		TCSetField( "CNFTMP", aStrucCNF[nx,1], aStrucCNF[nx,2], aStrucCNF[nx,3], aStrucCNF[nx,4] )
	endif
Next

If !CNFTMP->(Eof())
	While !CNFTMP->(Eof())
		aAdd(aCols4,Array(Len(aHeader4)+1))
		For nCntFor	:= 1 To Len(aHeader4)
			cCampo := Alltrim(aHeader4[nCntFor,2])
			If ( aHeader4[nCntFor][10] != "V" )
				aCols4[Len(aCols4)][nCntFor] := CNFTMP->&(aHeader4[nCntFor][2])
			Else
				aCols4[Len(aCols4)][nCntFor] := CriaVar(aHeader4[nCntFor][2])
			EndIf
		Next nCntFor
		aCols4[Len(aCols4), Len(aHeader4)+1] := .F.
		CNFTMP->(dbSkip())
	EndDo
Else
	aAdd(aCols4,Array(Len(aHeader4)+1))
	For nX := 1 To Len(aHeader4)
		aCols4[1, nX] := CriaVar(aHeader4[nX, 2],.F.)
	Next nX
	aCols4[Len(aCols4), Len(aHeader4)+1] := .F.
EndIF

CNFTMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CNH - Multas												 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNH")
dbSetOrder(1) //CNH_FILIAL+CNH_NUMERO+CNH_CODIGO
If dbSeek(xFilial("CNH")+M->CN9_NUMERO)
	While !Eof() .And. CNH->CNH_FILIAL = xFilial("CNH") .And. CNH->CNH_NUMERO == M->CN9_NUMERO
		aAdd(aCols5,Array(Len(aHeader5)+1))
		For nCntFor	:= 1 To Len(aHeader5)
			cCampo := Alltrim(aHeader5[nCntFor,2])
			If ( aHeader5[nCntFor][10] != "V" )
				aCols5[Len(aCols5)][nCntFor] := FieldGet(FieldPos(aHeader5[nCntFor][2]))
			Else
				aCols5[Len(aCols5)][nCntFor] := CriaVar(aHeader5[nCntFor][2])
			EndIf
		Next nCntFor
		aCols5[Len(aCols5), Len(aHeader5)+1] := .F.
		Aadd(aRecCNH,Recno())
		dbSelectArea("CNH")
		dbSkip()
	EndDo
Else
	aAdd(aCols5,Array(Len(aHeader5)+1))
	For nX := 1 To Len(aHeader5)
		aCols5[1, nX] := CriaVar(aHeader5[nX, 2])
	Next nX
	aCols5[Len(aCols5), Len(aHeader5)+1] := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CNK - Documentos                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNK")

cQuery := "SELECT CN5.CN5_DESCRI,CNK.* FROM "+ RetSQLName("CN5") +" CN5, "+ RetSQLName("CNK") +" CNK WHERE "
cQuery += "CN5.CN5_FILIAL = '"+xFilial("CN5")+"' AND "
cQuery += "CNK.CNK_FILIAL = '"+xFilial("CNK")+"' AND "
cQuery += "CNK.CNK_CONTRA = '"+ M->CN9_NUMERO +"' AND "
cQuery += "CNK.CNK_TPDOC = CN5.CN5_CODIGO AND "
cQuery += "CN5.D_E_L_E_T_ <> '*' AND "
cQuery += "CNK.D_E_L_E_T_ <> '*'"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CNKTMP",.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura campos especiais                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to len(aStrucCNK)
	if CNKTMP->(FieldPos(aStrucCNK[nx,1])) > 0 .And. aStrucCNK[nx,2] <> "C"
		TCSetField( "CNKTMP", aStrucCNK[nx,1], aStrucCNK[nx,2], aStrucCNK[nx,3], aStrucCNK[nx,4] )
	endif
Next

If !CNKTMP->(Eof())
	While !CNKTMP->(Eof())
		aAdd(aCols6,Array(Len(aHeader6)+1))
		For nCntFor	:= 1 To Len(aHeader6)
			cCampo := Alltrim(aHeader6[nCntFor,2])
			If ( aHeader6[nCntFor][10] != "V" )
				aCols6[Len(aCols6)][nCntFor] := CNKTMP->&(aHeader6[nCntFor][2])
			Else
				aCols6[Len(aCols6)][nCntFor] := CriaVar(aHeader6[nCntFor][2])
			EndIf
		Next nCntFor
		aCols6[Len(aCols6), Len(aHeader6)+1] := .F.
		
		CNKTMP->(dbSkip())
	EndDo
Else
	aAdd(aCols6,Array(Len(aHeader6)+1))
	For nX := 1 To Len(aHeader6)
		aCols6[1, nX] := CriaVar(aHeader6[nX, 2],.F.)
	Next nX
	aCols6[Len(aCols6), Len(aHeader6)+1] := .F.
EndIf

CNKTMP->(dbCloseArea())

If lCaucRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CNT - Retencao de Caucao                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS400AtuCNT()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira os campos sequenciais da caucao e do cronograma para  |
//| nao interferir no codigo automatico do contrato quando       |
//| nao houverem registros                                       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if len(aCols2) == 0
	nCntFor := aScan(aHeader2,{|x| x[2] == "CN8_CODIGO"})
	aDel(aHeader2,nCntFor)
	aSize(aHeader2,len(aHeader2)-1)
EndIf
if len(aCols4) == 0
	nCntFor := aScan(aHeader4,{|x| x[2] == "CNF_NUMERO"})
	aDel(aHeader4,nCntFor)
	aSize(aHeader4,len(aHeader4)-1)
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CSVldPer   ³ Autor ³ Microsiga      ³ Data ³26.12.2005       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida a vigencia contra os periodos dos cronogramas e      ³±±
±±³          ³ planilhas cadastrados para o contrato                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSVldPer()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA400                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSVldPer()
Local lRet := .T.
Local dTermino := CS400DtFim(M->CN9_UNVIGE,M->CN9_DTINIC,M->CN9_VIGE)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida periodo contra os cronogramas               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNF")
dbSetOrder(2)
dbSeek(xFilial("CNF")+M->CN9_NUMERO+M->CN9_REVISA)
While CNF->CNF_FILIAL == xFilial("CNF") .And. CNF->CNF_CONTRA == M->CN9_NUMERO .And. CNF->CNF_REVISA == M->CN9_REVISA
	If CNF->CNF_PRUMED > dTermino
		lRet := .F.
		Help(" ",1,"CNTA100VIG") //"Vigencia invalida para os cronogramas ja inclusos"
		Exit
	EndIf
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida periodo contra as planilhas                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	dbSelectArea("CNA")
	dbSetOrder(1)
	dbSeek(xFilial("CNA")+M->CN9_NUMERO+M->CN9_REVISA)
	While CNA->CNA_FILIAL == xFilial("CNA") .And. CNA->CNA_CONTRA == M->CN9_NUMERO .And. CNA->CNA_REVISA == M->CN9_REVISA
		If CNA->CNA_DTFIM > dTermino
			lRet := .F.
			Help(" ",1,"CNTA100VIP") //"Vigencia invalida para as planilhas ja inclusas"
			Exit
		EndIf
		dbSkip()
	EndDo
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Grv   ³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a gravacao do contrato                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Grv(nExp01,aExp02,aExp03)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                        ³±±
±±³          ³ aExp02 - Array com as planilhas adicionadas                 ³±±
±±³          ³ aExp03 - Array com os itens de planilhas adicionadas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Grv(nOpc,aPlani,aPlIt)
Local nCntFor  := 0
Local nCntFor2 := 0
Local nUsado   := 0
Local lRet     := .T.
Local dTermino := CS400DtFim(M->CN9_UNVIGE,M->CN9_DTINIC,M->CN9_VIGE)
Local cQuery	:= ""
Local cArqTrb	:= ""
Local cFilCNS  := ""
Local lFixo    := .T.
Local lValor   := .T.
Local lCNT100IN := ExistBlock("CNT100IN")

dbSelectArea("CN1")
dbSetOrder(1)
If (CN1->(FieldPos("CN1_CTRFIX")) > 0) .And. dbSeek(xFilial("CN1")+M->CN9_TPCTO)
	lFixo  := Empty(CN1->CN1_CTRFIX) .Or. (CN1->CN1_CTRFIX == "1")
	lValor := Empty(CN1->CN1_VLRPRV) .Or. (CN1->CN1_VLRPRV == "1")
EndIf

Do Case
	Case nOpc == 3  //Incluir
		Begin Transaction
		
		//Atualiza Contratos (Principal)
		dbSelectArea("CN9")
		Reclock("CN9",.T.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)!="CN9_FILIAL")
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		CN9->CN9_FILIAL := xFilial("CN9")
		CN9->CN9_SITUAC := DEF_SELAB//Em elaboracao
		CN9->CN9_DTFIM  := dTermino
		
		//Zera a vigencia quando indefinida
		If CN9->CN9_UNVIGE == "4"
			CN9->CN9_VIGE = 0
		EndIf
		
		//Verifica se o contrato possui planilha
		If !lFixo
			If lValor//Verifica se o contrato tem valor definido
				CN9->CN9_VLATU := CN9->CN9_VLINI
				CN9->CN9_SALDO := CN9->CN9_VLINI
			Else
				CN9->CN9_VLINI := 0
				CN9->CN9_VLATU := 0
				CN9->CN9_SALDO := 0
			EndIf
		EndIf
		
		MsUnlock()
		
		CN9->(FKCommit())
		
		//Atualiza Fornecedores
		nUsado := Len(aHeader1)
		For nCntFor := 1 To Len(aCols1)
			If ( !aCols1[nCntFor][nUsado+1] ) .And. !Empty(aCols1[nCntFor][1])
				dbSelectArea("CNC")
				Reclock("CNC",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader1[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader1[nCntFor2][2]),aCols1[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNC->CNC_FILIAL := xFilial("CNC")
				CNC->CNC_NUMERO := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
		
		//Atualiza Multas
		nUsado := Len(aHeader5)
		For nCntFor := 1 To Len(aCols5)
			If ( !aCols5[nCntFor][nUsado+1] ) .And. !Empty(aCols5[nCntFor][1])
				dbSelectArea("CNH")
				Reclock("CNH",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader5[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader5[nCntFor2][2]),aCols5[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNH->CNH_FILIAL := xFilial("CNH")
				CNH->CNH_NUMERO := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
		
		If len(aPlani) > 0 .And. lFixo
			CS400PlGr(aPlani,aPlIt)
		EndIf
		
		MSMM(,,,M->CN9_OBJCTO,1,,,"CN9","CN9_CODOBJ")
		If AliasInDic("CNN")
			//Gera permissão de controle total sobre o contrato
			dbSelectArea("CNN")
			RecLock("CNN",.T.)
			CNN->CNN_FILIAL := xFilial("CNN")
			CNN->CNN_CONTRA := M->CN9_NUMERO
			CNN->CNN_USRCOD := RetCodUsr()
			CNN->CNN_TRACOD := DEF_TRANS
			MsUnlock()
		EndIf
		// Ponto de Entrada na Inclusão do Contrato.
		If lCNT100IN 
			Execblock("CNT100IN",.F.,.F.)
		endif 
		
		End Transaction
	Case nOpc == 4  //Atualizar
		Begin Transaction
		//Atualiza Contrato
		dbSelectArea("CN9")
		Reclock("CN9",.F.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)!="CN9_FILIAL")
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		CN9->CN9_FILIAL := xFilial("CN9")
		CN9->CN9_DTFIM  := dTermino
		//Zera a vigencia quando indefinida
		If CN9->CN9_UNVIGE == "4"
			CN9->CN9_VIGE = 0
		EndIf
		//Verifica se o contrato possui planilha
		If !lFixo
			If lValor//Verifica se o contrato tem valor definido
				CN9->CN9_VLATU := CN9->CN9_VLINI
				CN9->CN9_SALDO := CN9->CN9_VLINI
			Else
				CN9->CN9_VLINI := 0
				CN9->CN9_VLATU := 0
				CN9->CN9_SALDO := 0
			EndIf
		EndIf
		MsUnlock()
		
		MSMM(M->CN9_CODOBJ,,,M->CN9_OBJCTO,1,,,"CN9","CN9_CODOBJ")
		
		//Apaga Fornecedores
		dbSelectArea("CNC")
		For nCntFor := 1 To Len(aRecCNC)
			dbGoto(aRecCNC[nCntFor])
			Reclock("CNC",.F.)
			dbDelete()
			MsUnlock()
		Next
		
		//Atualiza Fornecedores
		nUsado := Len(aHeader1)
		For nCntFor := 1 To Len(aCols1)
			If ( !aCols1[nCntFor][nUsado+1] ) .And. !Empty(aCols1[nCntFor][1])
				dbSelectArea("CNC")
				Reclock("CNC",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader1[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader1[nCntFor2][2]),aCols1[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNC->CNC_FILIAL := xFilial("CNC")
				CNC->CNC_NUMERO := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
		
		//Apaga Multas
		dbSelectArea("CNH")
		For nCntFor := 1 To Len(aRecCNH)
			dbGoto(aRecCNH[nCntFor])
			Reclock("CNH",.F.)
			dbDelete()
			MsUnlock()
		Next
		
		//Atualiza Multas
		nUsado := Len(aHeader5)
		For nCntFor := 1 To Len(aCols5)
			If ( !aCols5[nCntFor][nUsado+1] )  .And. !Empty(aCols5[nCntFor][1])
				dbSelectArea("CNH")
				Reclock("CNH",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader5[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader5[nCntFor2][2]),aCols5[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNH->CNH_FILIAL := xFilial("CNH")
				CNH->CNH_NUMERO := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
		End Transaction
	Case nOpc == 5  //Exclusao

		If allTrim(CN9->CN9_SITUAC) == DEF_SELAB//Permite exclusao apenas para contratos em elaboracao
			PcoIniLan("000354")
			Begin Transaction
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui a amarracao com os conhecimentos                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MsDocument( "CN9", CN9->( RecNo() ), 2, , 3 )
			
			//Apaga Fornecedores X Contratos
			dbSelectArea("CNC")
			dbSetOrder(1)
			If dbSeek(xFilial("CNC")+CN9->CN9_NUMERO)
				While !Eof() .And. CNC->CNC_FILIAL = xFilial("CNC") .And. CNC->CNC_NUMERO == CN9->CN9_NUMERO
					RecLock("CNC", .F.)
					dbDelete()
					MsUnLock()
					dbSelectArea("CNC")
					dbSkip()
				EndDo
			EndIf
			
			CNC->(FKCommit())
			
			//Apaga Caucoes
			dbSelectArea("CN8")
			dbSetOrder(2)
			If dbSeek(xFilial("CN8")+CN9->CN9_NUMERO)
				While !Eof() .And. CN8->CN8_FILIAL = xFilial("CN8") .And. CN8->CN8_CONTRA == CN9->CN9_NUMERO
					RecLock("CN8", .F.)
					dbDelete()
					MsUnLock()
					dbSelectArea("CN8")
					dbSkip()
				EndDo
			EndIf
			
			CN8->(FKCommit())
			
			//Apaga Itens das Planilhas
			dbSelectArea("CNB")
			dbSetOrder(1)
			If dbSeek(xFilial("CNB")+CN9->CN9_NUMERO+CN9->CN9_REVISA)
				While !Eof() .And. CNB->CNB_FILIAL = xFilial("CNB") .And. CNB->CNB_CONTRA == CN9->CN9_NUMERO .And. CNB->CNB_REVISA == CN9->CN9_REVISA
					if !Empty(CNB->CNB_ITEMSC)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Retira quantidade atendida da solicitacao de compra³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SC1")
						dbSetOrder(1)
						if dbSeek(xFilial("SC1")+CNB->CNB_NUMSC+CNB->CNB_ITEMSC)
							RecLock("SC1")
							SC1->C1_QUJE-=if(CNB->CNB_QUANT>CNB->CNB_QTDSOL,CNB->CNB_QTDSOL,CNB->CNB_QUANT)
							MsUnlock()
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Executa lancamento do PCO    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PcoDetLan("000354","02","CNTA200",.T.)

					RecLock("CNB", .F.)
					dbDelete()
					MsUnLock()
	
					dbSelectArea("CNB")
					dbSetOrder(1)
					dbSkip()
				EndDo
			EndIf
			
			CNB->(FKCommit())
			
			//Apaga Planilhas
			dbSelectArea("CNA")
			dbSetOrder(3)
			If dbSeek(xFilial("CNA")+CN9->CN9_NUMERO+CN9->CN9_REVISA)
				While !Eof() .And. CNA->CNA_FILIAL = xFilial("CNA") .And. CNA->CNA_CONTRA == CN9->CN9_NUMERO .And. CNA->CNA_REVISA == CN9->CN9_REVISA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Executa lancamento do PCO    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PcoDetLan("000354","01","CNTA200",.T.)

					RecLock("CNA", .F.)
					dbDelete()
					MsUnLock()

					dbSelectArea("CNA")
					dbSkip()
				EndDo
			EndIf
			
			CNA->(FKCommit())
			
			//Apaga Cronograma Fisico
			If AliasInDic("CNS")
				dbSelectArea("CNS")
				dbSetOrder(2)
				cFilCNS := xFilial("CNS")
				If dbSeek(cFilCNS+CN9->CN9_NUMERO+CN9->CN9_REVISA)
					While !Eof() .And. CNS->CNS_FILIAL = cFilCNS .And. CNS->CNS_CONTRA == CN9->CN9_NUMERO .And. CNS->CNS_REVISA == CN9->CN9_REVISA
						RecLock("CNS", .F.)
						dbDelete()
						MsUnLock()
						dbSelectArea("CNS")
						dbSkip()
					EndDo
				EndIf
				
				CNS->(FKCommit())
			EndIf
			
			//Apaga Cronograma Financeiro
			dbSelectArea("CNF")
			dbSetOrder(2)
			If dbSeek(xFilial("CNF")+CN9->CN9_NUMERO+CN9->CN9_REVISA)
				While !Eof() .And. CNF->CNF_FILIAL = xFilial("CNF") .And. CNF->CNF_CONTRA == CN9->CN9_NUMERO .And. CNF->CNF_REVISA == CN9->CN9_REVISA
					RecLock("CNF", .F.)
					dbDelete()
					MsUnLock()
					dbSelectArea("CNF")
					dbSkip()
				EndDo
			EndIf
			
			CNF->(FKCommit())
			
			//Apaga Multas X Contrato
			dbSelectArea("CNH")
			dbSetOrder(1)
			If dbSeek(xFilial("CNH")+CN9->CN9_NUMERO)
				While !Eof() .And. CNH->CNH_FILIAL = xFilial("CNH") .And. CNH->CNH_NUMERO == CN9->CN9_NUMERO
					RecLock("CNH", .F.)
					dbDelete()
					MsUnLock()
					dbSelectArea("CNH")
					dbSkip()
				EndDo
			EndIf
			
			CNH->(FKCommit())
			
			//Apaga Multas X Contrato
			dbSelectArea("CNH")
			dbSetOrder(1)
			If dbSeek(xFilial("CNH")+CN9->CN9_NUMERO)
				While !Eof() .And. CNH->CNH_FILIAL = xFilial("CNH") .And. CNH->CNH_NUMERO == CN9->CN9_NUMERO
					RecLock("CNH", .F.)
					dbDelete()
					MsUnLock()
					dbSelectArea("CNH")
					dbSkip()
				EndDo
			EndIf
			
			CNH->(FKCommit())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Exclui documentos relacionados ao contrato  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNK")
			
			cArqTrb	:= CriaTrab( nil, .F. )
			cQuery := "SELECT R_E_C_N_O_ as RECNO "
			cQuery += "FROM "+RetSQLName("CNK")+" CNK "
			cQuery += "WHERE CNK.CNK_FILIAL = '"+xFilial("CNK")+"' "
			cQuery += "AND CNK.CNK_CONTRA = '"+CN9->CN9_NUMERO+"' "
			cQuery += "AND CNK.D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery( cQuery )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra os itens de nota fiscal com a multa selecionada                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )
			
			While !(cArqTrb)->(Eof())
				CNK->(dbGoTo((cArqTrb)->RECNO))
				RecLock("CNK",.F.)
				dbDelete()
				MsUnlock()
				
				(cArqTrb)->(dbSkip())
			EndDo
			
			(cArqTrb)->( dbCloseArea() )
			
			CNK->(FKCommit())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Exclui pemissoes de acesso relacionadas ao contrato  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNN")
			
			cArqTrb	:= CriaTrab( nil, .F. )
			cQuery := "SELECT R_E_C_N_O_ as RECNO "
			cQuery += "FROM "+RetSQLName("CNN")+" CNN "
			cQuery += "WHERE CNN.CNN_FILIAL = '"+xFilial("CNN")+"' "
			cQuery += "AND CNN.CNN_CONTRA = '"+CN9->CN9_NUMERO+"' "
			cQuery += "AND CNN.D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery( cQuery )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra os itens de nota fiscal com a multa selecionada                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )
			
			While !(cArqTrb)->(Eof())
				CNN->(dbGoTo((cArqTrb)->RECNO))
				RecLock("CNN",.F.)
				dbDelete()
				MsUnlock()
				
				(cArqTrb)->(dbSkip())
			EndDo
			
			(cArqTrb)->( dbCloseArea() )
			
			CNN->(FKCommit())
			
			//Apaga Contratos
			dbSelectArea("CN9")
			MSMM(CN9_CODOBJ,,,,2)
			MSMM(CN9_CODJUS,,,,2)
			MSMM(CN9_CODCLA,,,,2)
			
			Reclock("CN9",.F.)
			dbDelete()
			MsUnlock()
			End Transaction

			//Finaliza lancamentos do SIGAPCO		
			PcoFinLan("000354")  
			PcoFreeBlq("000354")
		Else
			Help(" ",1,"CNTA100EXC") //"Exclusao permitida apenas para contratos em elaboracao"
			lRet := .F.
		EndIf
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa ponto de entrada apos a gravacao do contrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. ExistBlock("CS400GRC")
	ExecBlock("CS400GRC",.F.,.F.,{nOpc,aPlani,aPlIt})
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Visual³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa a rotina de visualizacao dos elementos do contrato  ³±±
±±³          ³ de acordo com o folder atual                                ³±±
±±³          ³ 1 - Fornecedor                                              ³±±
±±³          ³ 2 - Caucao                                                  ³±±
±±³          ³ 3 - Planilha                                                ³±±
±±³          ³ 4 - Cronograma                                              ³±±
±±³          ³ 5 - Multas                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Visual(nExp01,aExp02,aExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                        ³±±
±±³          ³ aExp02 - Array com as planilhas adicionadas                 ³±±
±±³          ³ aExp03 - Array com os itens das planilhas adicionadas       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Visual(nOpc,aPlani,aPlIt)

Local aArea	  := GetArea()
Local nFolder := oFolder:nOption
Local lRotRevis:= .F.

Do Case
	Case nFolder == 1  //Fornecedores
		If Len(ogetDad1:aCols) > 0
			dbSelectArea("SA2")
			dbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA
			if dbSeek(xFilial("SA2")+ogetDad1:aCols[ogetDad1:nAt][aScan(aHeader1,{|x| x[2] == "CNC_CODIGO"})]+ogetDad1:aCols[ogetDad1:nAt][aScan(aHeader1,{|x| x[2] == "CNC_LOJA"})])
				AxVisual("SA2",Recno(),2)
			EndIf
		EndIf
		
	Case nFolder == 2  //Caucoes
		If Len(ogetDad2:aCols) > 0
			dbSelectArea("CN8")
			dbSetOrder(1)
			if dbSeek(xFilial("CN8")+ogetDad2:aCols[ogetDad2:nAt][aScan(aHeader2,{|x| x[2] == "CN8_CODIGO"})])
				CN090Manut("CN8",Recno(),2)
			EndIf
		EndIf
		
	Case nFolder == 3  //Planilhas
		PRIVATE aForn := aEval(oGetDad1:aCols,{|x| {x[aScan(aHeader1,{|x| x[2] == "CNC_CODIGO"})],x[aScan(aHeader1,{|x| x[2] == "CNC_LOJA"})]}})
		If nOpc != 3
			If Len(ogetDad3:aCols) > 0
				dbSelectArea("CNA")
				dbSetOrder(1)
				if dbSeek(xFilial("CNA")+M->CN9_NUMERO+M->CN9_REVISA+ogetDad3:aCols[ogetDad3:nAt][aScan(aHeader3,{|x| x[2] == "CNA_NUMERO"})])
					lRotRevis := (FunName() $ "CNTA140|CNTA150")
					u_CS600Manut("CNA",Recno(),2,,(lRotRevis .And. Posicione("CN0",1,xFilial("CN0")+M->CN9_TIPREV,"CN0_TIPO")==DEF_REALI),(lRotRevis .And. Posicione("CN0",1,xFilial("CN0")+M->CN9_TIPREV,"CN0_TIPO")==DEF_READQ))
				EndIf
			EndIf
		Else
			If len(aPlani)> 0
				u_CS600Manut("CNA",5000,2,,.F.,.F.,aPlani,aPlIt,M->CN9_NUMERO,oGetDad3:aCols[oGetDad3:nAt,aScan(aHeader3,{|x| x[2] == "CNA_NUMERO"})])
			EndIf
		EndIf
		
	Case nFolder == 4  //Cronograma Financeiro
		If Len(ogetDad4:aCols) > 0
			dbSelectArea("CNF")
			dbSetOrder(2)
			if dbSeek(xFilial("CNF")+M->CN9_NUMERO+M->CN9_REVISA+ogetDad4:aCols[ogetDad4:nAt][aScan(aHeader4,{|x| x[2] == "CNF_NUMERO"})])
				u_CS410Manut("CNF",Recno(),2)
			EndIf
		EndIf
		
	Case nFolder == 5  //Multas
		If Len(ogetDad5:aCols) > 0
			dbSelectArea("CN4")
			dbSetOrder(1)
			if dbSeek(xFilial("CN4")+ogetDad5:aCols[ogetDad5:nAt][aScan(aHeader5,{|x| x[2] == "CNH_CODIGO"})])
				AxVisual("CN4",Recno(),2)
			EndIf
		EndIf
		
	Case nFolder == 6  //Documentos
		If Len(ogetDad6:aCols) > 0
			dbSelectArea("CNK")
			dbSetOrder(1)
			if dbSeek(xFilial("CNK")+ogetDad6:aCols[ogetDad6:nAt][aScan(aHeader6,{|x| x[2] == "CNK_CODIGO"})])
				CN170Manut("CNK",Recno(),2)
			EndIf
		EndIf
EndCase

RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Mul³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida as multas do contrato                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Mul()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400Mul()
Local nI
Local lRepetido := .F.
Local lRet := .T.
Local nPosMult := Ascan( aheader5, {|x| x[2] == "CNH_CODIGO"})
Local nPos := oGetDad5:nAt

if !Empty(oGetDad5:aCols[nPos,nPosMult])
	If Len( oGetDad5:aCols ) > 1 .And. !oGetDad5:aCols[nPos][len( aHeader5 ) + 1]
		
		For nI:= 1 To Len( oGetDad5:aCols )
			If ( nI != nPos ) .and. !oGetDad5:aCols[nI][len( aHeader5 ) + 1]
				If oGetDad5:aCols[nI,nPosMult] == oGetDad5:aCols[nPos,nPosMult]
					lRepetido := .T.
					Exit
				Endif
			Endif
		Next nI
		
		If lRepetido
			lRet:=.F.
			Help(" ",1,"JAGRAVADO")
		End
	Endif
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400For³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida os fornecedores do contrato                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400For()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400For()
Local nI
Local lRepetido := .F.
Local lRet := .T.
Local nPosForn := Ascan( aheader1, {|x| x[2] == "CNC_CODIGO"})
Local nPosLoja := Ascan( aheader1, {|x| x[2] == "CNC_LOJA"})
Local nPos := oGetDad1:nAt
Local m := 0

If !Empty(oGetDad1:aCols[nPos,nPosForn]) .Or. !Empty(oGetDad1:aCols[nPos,nPosLoja])
	lRet := ExistCpo("SA2",oGetDad1:aCols[nPos,nPosForn]+oGetDad1:aCols[nPos,nPosLoja])
	
	If lRet .And. Len( oGetDad1:aCols ) > 1 .And. !oGetDad1:aCols[nPos][len( aHeader1 ) + 1]
		
		For nI:= 1 To Len( oGetDad1:aCols )
			If ( nI != nPos ) .and. !oGetDad1:aCols[nI][len( aHeader1 ) + 1]
				If oGetDad1:aCols[nI,nPosForn] == oGetDad1:aCols[nPos,nPosForn] .And. oGetDad1:aCols[nI,nPosLoja] == oGetDad1:aCols[nPos,nPosLoja]
					lRepetido := .T.
					Exit
				Endif
			Endif
		Next nI
		
		If lRepetido
			lRet:=.F.
			Help(" ",1,"JAGRAVADO")
		End
	Endif
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400FoldCh³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa a alteracao de folder                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400FoldCh(nExp01,nExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Folder de destino                                  ³±±
±±³          ³ nExp02 - Folder atual                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400FoldCh(nFldDes,nFldAtu)

Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ So deixa mudar de folder se o getdados estiver OK		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFldAtu == 1
	if len(oGetDad1:aCols) > 0
		if !u_CS400For()
			lRet := .F.
		EndIf
	EndIf
ElseIf nFldAtu == 5
	if len(oGetDad5:aCols) > 0
		If !u_CS400Mul()
			lRet := .F.
		EndIf
	EndIf
Endif

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida destino	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case nFldDes == 3//Planilha
			dbSelectArea("CN1")
			dbSetOrder(1)
			If (CN1->(FieldPos("CN1_CTRFIX")) > 0) .And. dbSeek(xFilial("CN1")+M->CN9_TPCTO)
				lRet := (Empty(CN1->CN1_CTRFIX) .Or. CN1->CN1_CTRFIX == "1")
			EndIf
		Case nFldDes == 4//Cronograma
			dbSelectArea("CN1")
			dbSetOrder(1)
			If (CN1->(FieldPos("CN1_VLRPRV")) > 0) .And. dbSeek(xFilial("CN1")+M->CN9_TPCTO)
				lRet := (Empty(CN1->CN1_CTRFIX) .Or. CN1->CN1_CTRFIX == "1")
				//				lRet := (Empty(CN1->CN1_VLRPRV) .Or. CN1->CN1_VLRPRV == "1")
			EndIf
	EndCase
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Legenda³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de legenda do contrato                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Legenda(nExp01,nExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Legenda()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com as cores que representam a situacao de cada Contrato na mBrowse.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aLegenda := {	{"BR_VERMELHO", OemtoAnsi(STR0042)	},; // Cancelado
							{"BR_AMARELO" , OemtoAnsi(STR0043)	},; // Em Elaboracao
							{"BR_AZUL"    , OemtoAnsi(STR0044)	},; // Emitido
							{"BR_LARANJA" , OemtoAnsi(STR0045)	},; // Em Aprovacao
							{"BR_VERDE"   , OemtoAnsi(STR0046)	},; // Vigente
							{"BR_CINZA"   , OemtoAnsi(STR0047)	},; // Paralisado
							{"BR_MARRON"  , OemtoAnsi(STR0048)	},; // Sol. Finalizacao
							{"BR_PRETO"	  , OemtoAnsi(STR0049)	},; // Finalizado
							{"BR_PINK"    , OemtoAnsi(STR0050)	},; // Revisao
							{"BR_BRANCO"  , OemtoAnsi(STR0051)	}}  // Revisado

BrwLegenda(cCadastro, OemtoAnsi(STR0018), aLegenda)//"Legendas"

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Ini ³ Autor ³ Microsiga      ³ Data ³13.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida data inicial                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Ini()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400Ini()
Local lRet := .T.

lRet := (M->CN9_DTINIC >= dDataBase)

If lRet .And. !Empty(M->CN9_DTASSI)
	lRet := (M->CN9_DTINIC > M->CN9_DTASSI)
EndIf

If !lRet
	Help(" ",1,"CNTA100DTI") //"Data de inicio invalida"
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Ass ³ Autor ³ Microsiga      ³ Data ³13.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida data de assinatura                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Ass()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400Ass()
Local lRet := .T.

If !Empty(M->CN9_DTINIC)
	lRet := (M->CN9_DTASSI >= M->CN9_DTINIC)
EndIf

If !lRet
	Help(" ",1,"CNTA100DTA") //"Data de assinatura deve ser menor que a data de inicio"
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400DtFim  ³ Autor ³ Microsiga      ³ Data ³13.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Calcula data final de acordo com a vigencia escolhida        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ dExp01 := CS400DtFim(cExp02,dExp03,cExp04)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dExp01 - Data calculada                                      ³±±
±±³          ³ cExp04 - Tipo de Vigencia                                    ³±±
±±³          ³          "1" - Dias                                          ³±±
±±³          ³          "2" - Meses                                         ³±±
±±³          ³          "3" - Anos                                          ³±±
±±³          ³ cExp02 - Data calculada                                      ³±±
±±³          ³ dExp03 - Vigencia                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400DtFim(cTipV,dDtIni,nVig)
Local nx

Do Case
	Case cTipV == "1"//Dia
		dDtIni += nVig
	Case cTipV == "2"//Mes
		for nX:=1 to nVig
			dDtIni += Day(LastDay(dDtIni))
		Next
	Case cTipV == "3"//Ano
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida ano bissexto                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if Day(dDtIni) == 29 .And. Month(dDtIni) == 2 .And. ((Year(dDtIni)+nVig) % 4 != 0)
			dDtIni := cTod("28/02/"+str(Year(dDtIni)+nVig))
		else
			dDtIni := cTod(str(Day(dDtIni))+"/"+str(Month(dDtIni))+"/"+str(Year(dDtIni)+nVig))
		EndIf
	Case cTipV == "4"//Indeterminada
		dDtIni := CTOD("31/12/49")//Retorna data limite do sistema
EndCase
Return dDtIni

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400TudOk  ³ Autor ³ Microsiga      ³ Data ³13.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o cabecalho do contrato                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400TudOk()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400TudOk()
Local lRet := .T.
Local nPosForn := aScan(ogetDad1:aHeader,{|x| x[2] == "CNC_CODIGO"})
Local nPosLoja := aScan(ogetDad1:aHeader,{|x| x[2] == "CNC_LOJA"})
Local lForn    := .T.
Local nX

If Len(oGetDad1:aCols) == 1 .And. Empty(oGetDad1:aCols[1,nPosForn]) .And. Empty(oGetDad1:aCols[1,nPosLoja])
	Help(" ",1,"CNTA100FOR") //"Inclua ao menos um fornecedor no contrato"
	lRet := .F.
Else
	nI := 1
	//Verifica itens deletados
	while nI <= len(oGetDad1:aCols) .And. oGetDad1:aCols[nI][len(ogetDad1:aHeader)+1]
		nI++
	EndDo
	
	If nI > len(oGetDad1:aCols)
		Help(" ",1,"CNTA100FOR") //"Inclua ao menos um fornecedor no contrato"
		lRet := .F.
	EndIf
EndIf

If lRet .And. (M->CN9_FLGCAU == "1") .And. Empty(M->CN9_MINCAU)
	Help(" ",1,"CNTA100PER") //"Preencha o percentual minimo de caucao"
	lRet := .F.
EndIf

If !Empty(CN9->( FieldPos("CN9_TPCAUC") ) )
	If lRet .And. (M->CN9_FLGCAU == "1") .And.  Empty(M->CN9_TPCAUC)
		Help(" ",1,"CNTA100TPC") //"Informe o tipo de tratamento da caucao"
		lRet := .F.
	EndIf
EndIf

If lRet .And. (M->CN9_FLGREJ == "1") .And. Empty(M->CN9_INDICE)
	Help(" ",1,"CNTA100IND") //"Preencha o indice de reajuste do contrato"
	lRet := .F.
EndIf

If lRet .And. !Empty(CN9->(FieldPos("CN9_MOEDA"))) .And. ((M->CN9_MOEDA < 1) .Or. (M->CN9_MOEDA > MOEDFIN()))
	Help(" ",1,"CNTA100MOE") //"Preencha a moeda corrente"
	lRet := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400SitCh³ Autor ³ Microsiga      ³ Data ³18.01.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Altera situacao do contrato, executando todas as validacoes³±±
±±³          ³ necessarias                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400SitCh(cExp01,cExp02,cExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Numero do contrato                                ³±±
±±³          ³ cExp02 - Revisao do contrato                               ³±±
±±³          ³ cExp03 - Nova situacao do contrato                         ³±±
±±³          ³          1 - Cancelado                                     ³±±
±±³          ³          2 - Em elaboracao                                 ³±±
±±³          ³          3 - Emitido                                       ³±±
±±³          ³          4 - Em aprovacao                                  ³±±
±±³          ³          5 - Vigente                                       ³±±
±±³          ³          6 - Paralisado                                    ³±±
±±³          ³          7 - Sol Paralisacao                               ³±±
±±³          ³          8 - Finalizado                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400SitCh(cContra,cRevisa,cNewSituc)
Local lRet := .T.
Local lMedeve
Local lCaucao
Local nPCauc
Local nTotPlan := 0//Quant de Planilhas
Local nMotPlan := 0//Montante das planilhas
Local nMotCron := 0//Montante dos cronogramas
Local nMotCauc := 0//Montante das caucoes
Local cFilCod
Local dDataAssi := dDataBase

//Informa variacao do contrato fixo/variavel
//através do ponto de entrada CS400FIX
Private lFixo   := .T.

//Ponto de entrada para validacao da troca de situacao
If ExistBlock("CS400VST")
	uRet := ExecBlock("CS400VST",.F.,.F.,{cNewSituc})
	If valtype(uRet) == "L"
		lRet := uRet
	EndIf
EndIf

If lRet
	Do Case
		Case cNewSituc  = DEF_SEMIT
			dbSelectArea("CN9")
			dbSetOrder(1)
			//Inclui data de assinatura
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				Aviso("CNTA100",OemtoAnsi(STR0029),{"Ok"})// "Situacao alterada com sucesso"
			EndIf
		Case (cNewSituc  = DEF_SAPRO)//Atualiza situacao para "Em Aprovacao"
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTASSI := dDataAssi//Inclui data de assinatura
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				Aviso("CNTA100",OemtoAnsi(STR0029),{"Ok"})// "Situacao alterada com sucesso"
			EndIf
		Case cNewSituc  = DEF_SVIGE//Atualiza situacao para Vigente
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica situação atual do contrato                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim(CN9->CN9_SITUAC) == DEF_SELAB .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO
					//Medicao Eventual
					lMedeve := (Posicione("CN1",1,xFilial("CN1")+CN9_TPCTO,"CN1_MEDEVE") == "1")
					
					//Controla ou nao caucao
					lCaucao := (CN9->CN9_FLGCAU == "1" .And. If((CN9->(FieldPos("CN9_TPCAUC")) > 0),(CN9->CN9_TPCAUC == "1"),.T.))
					
					//Controla ou nao planilhas
					If (CN1->(FieldPos("CN1_CTRFIX")) > 0)
						lFixo := Empty(CN1->CN1_CTRFIX) .Or. CN1->CN1_CTRFIX = "1"
					EndIf
					
					If lCaucao
						nPCauc := CN9->CN9_MINCAU//Percentual minimo de caucao
					EndIf
					
					If lFixo
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica planilhas do contrato                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("CNA")
						dbSetOrder(1)
						cFilCod := xFilial("CNA")
						dbSeek(cFilCod+CN9->CN9_NUMERO+CN9->CN9_REVISA)
						
						While CNA->CNA_FILIAL = cFilCod .And. CNA->CNA_CONTRA = CN9->CN9_NUMERO .And. CNA->CNA_REVISA = CN9->CN9_REVISA
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica cronograma da planilha se o contrato      ³
							//³ nao for de medicao eventual                        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !lMedeve .And. Empty(CNA->CNA_CRONOG)
								Help(" ",1,"CNTA100PLA") //"Todas as planilhas devem pertencer a um cronograma"
								lRet := .F.
								exit
							Else
								//Soma montante das planilhas
								nMotPlan+=CNA->CNA_VLTOT
							EndIf
							nTotPlan++
							dbSkip()
						EndDo
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica contrato fixo/variavel                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("CS400FIX")
						lFixo := ExecBlock("CS400FIX",.F.,.F.)
						if Type("lFixo") <> "L"
							lFixo := .T. // o Contrato é do tipo Fixo
						endif
					endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o contrato possui planilhas            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lRet .And. nTotPlan == 0 .and. lFixo
						Help(" ",1,"CNTA100POP") //"O contrato nao possui planilhas"
						lRet := .F.
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica cronogramas se nao for medicao eventual   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if lRet .And. !lMedeve
						
						dbSelectArea("CNF")
						dbSetOrder(2)
						cFilCod := xFilial("CNF")
						dbSeek(cFilCod+CN9->CN9_NUMERO+CN9->CN9_REVISA)
						
						while CNF->CNF_FILIAL = cFilCod .And. CNF->CNF_CONTRA = CN9->CN9_NUMERO .And. CNF->CNF_REVISA = CN9->CN9_REVISA
							//Soma montante dos cronogramas
							nMotCron+=CNF->CNF_VLPREV
							dbSkip()
						EndDo
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Arredonda valores totais de cronograma e planilha    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nMotCron := Round(nMotCron,TamSX3("CNF_VLPREV")[2])
						nMotPlan := Round(nMotPlan,TamSX3("CNA_VLTOT")[2])
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica montante dos cronogramas contra montante    ³
						//³ das planilhas                                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If nMotPlan != nMotCron
							Help(" ",1,"CNTA100MON") //"O montante das planilhas nao equivale ao montante dos cronogramas"
							lRet := .F.
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica caucoes quando houver controle              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lRet .And. lCaucao
						dbSelectArea("CN8")
						dbSetOrder(2)
						cFilCod := xFilial("CN8")
						dbSeek(cFilCod+CN9->CN9_NUMERO+CN9->CN9_REVISA)
						
						While CN8->CN8_FILIAL = cFilCod .And. CN8->CN8_CONTRA = CN9->CN9_NUMERO .And. CN8->CN8_REVISA = CN9->CN9_REVISA
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Soma montante das caucoes quando nao estiver baixada ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Empty(CN8_DTBX)
								nMotCauc+=CN8->CN8_VLEFET
							EndIf
							dbSkip()
						EndDo
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica percentual minimo de caucao                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (CN9->CN9_VLINI*nPCauc)/100 > nMotCauc
							Help(" ",1,"CNTA100MIN") //"O contrato nao possui o percentual minimo de caucao especificado"
							lRet := .F.
						EndIf
					EndIf
				Else
					Help(" ",1,"CNTA100INV") //"Situacao atual invalida"
					lRet := .F.
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa alteracao quando todas as validacoes estiverem OK ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRet
					if !Empty(CN9->CN9_DTASSI)
						dDataAssi := CN9->CN9_DTASSI
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Contabiliza a ativacao do contrato ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CS400Contab()
					
					if lFixo
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza data de aniversario dos itens com a data de      ³
						//³ assinatura                                                ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("CNB")
						dbSetOrder(1)
						cFilCod := xFilial("CNB")
						dbSeek(xFilial("CNB")+CN9->CN9_NUMERO+CN9->CN9_REVISA)
						
						While !CNB->(Eof()) .And. CNB->CNB_FILIAL == cFilCod .And. CNB->CNB_CONTRA == CN9->CN9_NUMERO .And. CNB->CNB_REVISA == CN9->CN9_REVISA
							RecLock("CNB")
							CNB->CNB_DTANIV := dDataAssi
							MsUnlock()
							CNB->(dbSkip())
						EndDo
					EndIf
					
					RecLock("CN9",.F.)
					CN9->CN9_SITUAC := cNewSituc
					If Empty(CN9->CN9_DTASSI)
						CN9->CN9_DTASSI := dDataBase
					EndIf
					CN9->CN9_DTULST := dDataBase
					MsUnlock()
					Aviso("CNTA100",OemtoAnsi(STR0029),{"Ok"})// "Situacao alterada com sucesso"
				EndIf
			EndIf
			
			If lRet .And. !lMedeve .And. (GetNewPar( "MV_CNPROVI" ,  "S" ) == "S")
				MsAguarde({||u_CS400CTit(cContra,cRevisa)},STR0058)//Gera Titulos provisorios
			EndIf
		Case cNewSituc == DEF_SFINA
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				If (GetNewPar( "MV_CNPROVI" , "S" ) == "S")
					MsAguarde({||u_CS400ETit(cContra,cRevisa)},STR0061)//"Estornando títulos"
				EndIf
				Aviso("CNTA100",OemtoAnsi(STR0029),{"Ok"})// "Situacao alterada com sucesso"
			EndIf
		Otherwise
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				If cNewSituc == "01" // Cancelado
					If lRet .And. !lMedeve .And. (GetNewPar( "MV_CNPROVI" ,  "S" ) == "S")
						MsAguarde({||u_CS400ETit(cContra,cRevisa)},STR0061)//"Estornando títulos"
					EndIf
				EndIf	
				Aviso("CNTA100",OemtoAnsi(STR0029),{"Ok"})// "Situacao alterada com sucesso"
			EndIf
	EndCase
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CSDelFor   ³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida exclusao de fornecedor                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSDelFor                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA400                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSDelFor()
Local lRet := .T.
Local nPosForn := aScan(aHeader,{|x| x[2] == "CNC_CODIGO"})
Local nPosLoja := aScan(aHeader,{|x| x[2] == "CNC_LOJA"})
Local nPos := oGetDad1:nAt
//Verifica a existencia de planilhas para o fornecedor atual
Local nFornCNA := aScan(oGetDad3:aCols,{|x| x[aScan(aHeader3,{|x| x[2] == "CNA_FORNEC"})] == oGetDad1:aCols[nPos,nPosForn] .And. x[aScan(aHeader3,{|x| x[2] == "CNA_LJFORN"})] == oGetDad1:aCols[nPos,nPosLoja]})
Local nFornCN8

lRet := (nFornCNA == 0)

if lRet
	//Verifica a existencia de caucoes para o fornecedor atual
	nFornCN8 := aScan(oGetDad2:aCols,{|x| x[aScan(aHeader2,{|x| x[2] == "CN8_FORNEC"})] == oGetDad1:aCols[nPos,nPosForn] .And. x[aScan(aHeader2,{|x| x[2] == "CN8_LOJA"})] == oGetDad1:aCols[nPos,nPosLoja]})
	lRet := (nFornCN8 == 0)
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Hist  ³ Autor ³ Microsiga      ³ Data ³20.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Historico do contrato                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Hist(cExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Contrato                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Hist(cContra)
Local cAntCadastro := cCadastro
Local aAntRotina   := aRotina
Local cFilter      := 'CNG_FILIAL == "' + xFilial("CNG") + '" .And. CNG_CONTRA == "' + cContra + '"'
Local aIndCNG      := {}

Private cCadastro  := OemToAnsi(STR0034) //"Historico"

Private aRotina := 	{ 	{ OemToAnsi(STR0002), "AxPesqui", 0, 1},;//"Pesquisar"
{ OemToAnsi(STR0003), "AxVisual", 0, 2}} //"Visualizar"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra multas do contrato              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FilBrowse("CNG",@aIndCNG,cFilter)

mBrowse(6,1,22,75,"CNG")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira filtro do arquivo de multas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("CNG",aIndCNG)

cCadastro := cAntCadastro
aRotina   := aAntRotina
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Situac³ Autor ³ Microsiga      ³ Data ³20.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Controle de situacoes do contrato                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Situac(cExp01,cExp02,nExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Alias do arquivo                                   ³±±
±±³          ³ cExp02 - Registro atual                                     ³±±
±±³          ³ nExp03 - Opcao atual                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Situac(cAlias,nReg,nOpc)
Local cCadastro := OemToAnsi(STR0035) //"Controle de Situacoes"
Local aSituac   := RetSx3Box( Posicione("SX3", 2, "CN9_SITUAC", "X3CBox()" ),,, TamSX3("CN9_SITUAC")[1] )
Local aSitTx    := {}
Local oSituCb
Local oDlg
Local oGet01,oGet02,oGet03
Local cSitAtu
Local cSitOrg
Local nOpcA
Local cContra
Local cRevisa
Local lSituAll := (GetNewPar( "MV_CNSITAL", "S" ) == "S")

If CN240VldUsr(CN9->CN9_NUMERO,DEF_TRASIT,.T.)
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	//Situacao atual
	cSitOrg := CN9->CN9_SITUAC
	cSitAtu := AllTrim( aSituac[Ascan( aSituac, { |aBox| substr(aBox[1],1,At("=",aBox[1])-1) = AllTrim(cSitOrg)} )][3] )
	
	dbSelectArea("CN9")
	dbGoto(nReg)
	
	cContra := CN9->CN9_NUMERO
	cRevisa := CN9->CN9_REVISA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Disponibliza as situacoes de acordo    ³
	//³ com a atual                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ De: Elaboracao                         ³
		//³ Para: Emitido, Aprovacao, Vigente      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SELAB
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SEMIT})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SAPRO})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SVIGE})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Emitido                            ³
			//³ Para: Aprovacao, Vigente, Cancelado    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SAPRO})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SVIGE})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SCANC})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Aprovacao                          ³
			//³ Para: Vigente, Cancelado               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SVIGE})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SCANC})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Vigente                            ³
			//³ Para: Sol. Finalizacao, Cancelado      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SVIGE
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SSPAR})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SCANC})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Sol Finalizacao                    ³
			//³ Para: Finalizado, Cancelado            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SSPAR
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SFINA})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| x[2] == DEF_SCANC})][1])
	EndCase
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 165,115 TO 290,430 PIXEL
	
	@ 7,10 Say STR0036 Of oDlg PIXEL//"Contrato"
	@ 5,50 MsGet oGet01 Var cContra Picture PesqPict("CN9","CN9_NUMERO") When .F. PIXEL  Size 50,5 Of oDlg
	
	@ 7,102 Say STR0037 Of oDlg PIXEL//"Revisão"
	@ 5,125 MsGet oGet02 Var cRevisa Picture PesqPict("CN9","CN9_REVISA") When .F. PIXEL  Size 10,5 Of oDlg
	
	@ 22,10 Say STR0038 Of oDlg PIXEL//"Situacao Atual"
	@ 20,50 MsGet oGet03 Var cSitAtu When .F. Of oDlg PIXEL
	
	@ 37,10 Say STR0039 Of oDlg PIXEL//"Nova Situacao"
	@ 35,50 MsComboBox oSituCb ITEMS aSitTx When (len(aSitTx) > 0) SIZE 60,5 OF oDlg PIXEL
	
	DEFINE SBUTTON FROM 50, 93 TYPE 1 When (len(aSitTx) > 0) ACTION (if(!Empty(oSituCb),(nopca:=1,oDlg:End()),Aviso("CNTA100",OemtoAnsi(STR0040),{"Ok"}))) ENABLE OF oDlg
	DEFINE SBUTTON FROM 50, 123 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpca == 1 .And. Aviso("CNTA100",OemtoAnsi(STR0041),{STR0052,STR0053}) == 1 .And. CS400Doc(nReg,{oSituCb},.T.)//"Confirma a mudanca de situacao do contrato?"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Rotina de alteracao da situacao do contrato³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If CS400SitCh(CN9->CN9_NUMERO,CN9->CN9_REVISA,oSituCb)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Chama ponto de entrada para tratamento de inclusao  ³
			//³ de novas rotinas apos alterar a situacao do contrato³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("CS400SIT")
				ExecBlock("CS400SIT",.f.,.f.,{cSitOrg,oSituCb})
			EndIf
			
			If lSituAll .Or. oSituCb == DEF_SPARA .Or. oSituCb == DEF_SSPAR .Or. oSituCb == DEF_SFINA
				CN220Aval(cAlias,nReg,nOpc,,.F.,oSituCb)
			EndIf
		EndIf
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400FilCont³ Autor ³ Microsiga      ³ Data ³20.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Filtra consulta padrao CN9001 apenas com contratos vigentes  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400FilCont()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400FilCont()

Return "@#CN9_SITUAC == '"+DEF_SVIGE+"'@#"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS400Conh ³ Autor ³Sergio Silveira        ³ Data ³15/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada da visualizacao do banco de conhecimento            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS400Conh()                                                 ³±±
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

Static Function CS400Conh()

Local aRotBack := AClone( aRotina )
Local nBack    := 0

If Type( "N" ) == "N"
	nBack := N
EndIf

Private aRotina := {}

Aadd(aRotina,{STR0055,"MsDocument", 0 , 2}) //"Conhecimento"

MsDocument( "CN9", CN9->( Recno() ), 1 )

aRotina := AClone( aRotBack )

If !Empty( nBack )
	N := nBack
EndIf

Return( .t. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS400CTit ³ Autor ³Microsiga       ³ Data ³17/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera titulos provisorios a pagar com base no cronograma     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS400CTit(cExp01,cExp02,cExp03,cExp04,nExp05)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cExp01 - Codigo do Contrato                                 ³±±
±±³          ³cExp02 - Codigo da revisao                                  ³±±
±±³          ³cExp03 - Numero do cronograma - opcional                    ³±±
±±³          ³cExp04 - Parcela do cronograma - opcional                   ³±±
±±³          ³nExp05 - Saldo restante - opcional                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400CTit(cContra,cRevisa,cCronog,cParcel,nSaldo)
Local cQuery := ""
Local cMaxTit := ""
Local aStrucCNF:= CNF->(dbStruct())
Local cPrefixo := PadR( GetNewPar( "MV_CNPREF",  "" ), Len( SE2->E2_PREFIXO ) )
Local cNatTit  := PadR( GetNewPar( "MV_CNNAT" ,  "" ), Len( SE2->E2_NATUREZ ) )
Local aArea    := GetArea()
Local cFilSE2  := xFilial("SE2")
Local lConvert := (GetNewPar( "MV_CNMOEDA", "S" ) == "S")
Local lMoeda   := !Empty( CN9->( FieldPos( "CN9_MOEDA" ) ) )
Local nx
Local lPeSE2   := Existblock("CNTPRSE2")

Default cCronog := ""
Default cParcel := ""
Default nSaldo  := -1

dbSelectArea("CN9")
dbSetOrder(1)
If dbSeek(xFilial("CN9")+cContra+cRevisa)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa a natureza do contrato            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( CN9->( FieldPos( "CN9_NATURE" ) ) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso tenha natureza preenchida, substitui  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( CN9->CN9_NATURE )
			cNatTit := CN9->CN9_NATURE
		EndIf
	EndIf
	
	dbSelectArea("SE2")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona sequencia dos titulos a pagar    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "Select MAX(SE2.E2_NUM) as E2_NUM from "+ RetSQLName("SE2") +" SE2 "
	cQuery += "where SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
	cQuery += "SE2.E2_PREFIXO = '"+ cPrefixo +"' AND "
	cQuery += "SE2.D_E_L_E_T_ = ' '"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE2TMP",.F.,.T.)
	
	cMaxTit := Soma1(SE2TMP->E2_NUM)
	
	SE2TMP->(dbCloseArea())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona parcelas dos cronogramas         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "select distinct CNF.*,CNA.CNA_NUMERO,CNA.CNA_FORNEC,CNA.CNA_LJFORN from "+ RetSQLName("CNF") + " CNF,"+ RetSQLName("CNA") +" CNA where "
	cQuery += "CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
	cQuery += "CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND "
	cQuery += "CNA.CNA_CRONOG = CNF.CNF_NUMERO AND "
	If !Empty(cCronog)
		cQuery += "CNA.CNA_CRONOG = '"+ cCronog +"' AND "
		cQuery += "CNF.CNF_NUMERO = '"+ cCronog +"' AND "
	EndIf
	If !Empty(cParcel)
		cQuery += "CNF.CNF_PARCEL = '"+ cParcel +"' AND "
	EndIf
	cQuery += "CNF.CNF_CONTRA = '"+ CN9->CN9_NUMERO +"' AND "
	cQuery += "CNF.CNF_REVISA = '"+ CN9->CN9_REVISA +"' AND "
	cQuery += "CNF.D_E_L_E_T_ <> '*'"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CNFTMP",.F.,.T.)
	
	For nx:=1 to len(aStrucCNF)
		if CNFTMP->(FieldPos(aStrucCNF[nx,1])) > 0 .And. aStrucCNF[nx,2] <> "C"
			TCSetField( "CNFTMP", aStrucCNF[nx,1], aStrucCNF[nx,2], aStrucCNF[nx,3], aStrucCNF[nx,4] )
		endif
	Next
	
	nSaldo := If(nSaldo == -1,CNFTMP->CNF_SALDO,nSaldo)
	
	While !CNFTMP->(Eof())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera titulo provisorio de compras          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nSaldo > 0
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+CNFTMP->CNA_FORNEC+CNFTMP->CNA_LJFORN)
			
			dbSelectArea("SE2")
			dbSetOrder(1)
			SE2->( dbGoTop() )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica numeracao do SE2          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While dbSeek(cFilSE2+cPrefixo+cMaxTit)
				cMaxTit := Soma1(cPrefixo)
			EndDo
			
			RecLock("SE2",.T.)
			SE2->E2_FILIAL    := xFilial("SE2")
			SE2->E2_PREFIXO   := cPrefixo
			SE2->E2_NUM       := cMaxTit
			SE2->E2_PARCELA   := CNFTMP->CNF_PARCEL
			SE2->E2_TIPO      := "PR"
			SE2->E2_FORNECE   := CNFTMP->CNA_FORNEC
			SE2->E2_LOJA      := CNFTMP->CNA_LJFORN
			SE2->E2_NOMFOR    := SA2->A2_NOME
			SE2->E2_EMIS1     := CN9->CN9_DTASSI
			SE2->E2_EMISSAO   := CN9->CN9_DTASSI 
			SE2->E2_VENCTO    := CNFTMP->CNF_DTVENC
			SE2->E2_VENCREA   := DataValida(CNFTMP->CNF_DTVENC)
			SE2->E2_VENCORI   := SE2->E2_VENCTO

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trata moeda e conversao            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	lMoeda
   			if lConvert
					SE2->E2_VALOR  := nSaldo
		 			SE2->E2_TXMOEDA:= CNFTMP->CNF_TXMOED
					SE2->E2_MOEDA  := CN9->CN9_MOEDA
				Else
					SE2->E2_VALOR  := xMoeda(nSaldo,CN9->CN9_MOEDA,1,CNFTMP->CNF_PRUMED,,CNFTMP->CNF_TXMOED)
					SE2->E2_MOEDA  := 1
				EndIf
				SE2->E2_VLCRUZ    := xMoeda(nSaldo,CN9->CN9_MOEDA,1,CNFTMP->CNF_PRUMED,,CNFTMP->CNF_TXMOED)
			Else
				SE2->E2_VALOR     := nSaldo
				SE2->E2_MOEDA     := 1				
				SE2->E2_VLCRUZ    := SE2->E2_VALOR
			EndIf
			
			SE2->E2_SALDO     := SE2->E2_VALOR
			SE2->E2_NATUREZ   := cNatTit
			SE2->E2_ORIGEM    := "CNTA100"
			SE2->E2_RATEIO    := "N"
			SE2->E2_FLUXO     := "S"
			SE2->E2_MDCONTR   := CN9->CN9_NUMERO
			SE2->E2_MDREVIS   := CN9->CN9_REVISA
			SE2->E2_MDPLANI   := CNFTMP->CNA_NUMERO
			SE2->E2_MDCRON    := CNFTMP->CNF_NUMERO
			SE2->E2_MDPARCE   := CNFTMP->CNF_PARCEL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa ponto de entrada para preenchimento de ³
			//³ campos especificos no SE2                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If lPeSE2
				ExecBlock("CNTPRSE2",.F.,.F.)
			EndIf
			
			MsUnlock()
			FaAvalSE2(1,SE2->E2_ORIGEM)
			
			cMaxTit := Soma1(cMaxTit)
		EndIf
		
		CNFTMP->(dbSkip())
		nSaldo := CNFTMP->CNF_SALDO
	EndDo
	CNFTMP->(dbCloseArea())
EndIf

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS400ETit ³ Autor ³Microsiga       ³ Data ³17/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Realiza exclusao dos titulos provisorios do                 ³±±
±±³          ³contrato/cronograma                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS400ETit(cExp01,cExp02,cExp03,cExp04)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cExp01 - Codigo do Contrato                                 ³±±
±±³          ³cExp02 - Codigo da revisao                                  ³±±
±±³          ³cExp03 - Numero do cronograma - opcional                    ³±±
±±³          ³cExp04 - Parcela do cronograma - opcional                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS400ETit(cContra,cRevisa,cCronog,cParcel)
Local cQuery := ""
Local aArea    := GetArea()

Default cCronog := ""
Default cParcel := ""

dbSelectArea("CN9")
dbSetOrder(1)
If dbSeek(xFilial("CN9")+cContra+cRevisa)
	dbSelectArea("SE2")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona titulos provisorios              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "Select SE2.R_E_C_N_O_ as RECNO from "+ RetSQLName("SE2") +" SE2 "
	cQuery += "where SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
	cQuery += "SE2.E2_MDCONTR = '"+ cContra +"' AND "
	cQuery += "SE2.E2_MDREVIS = '"+ cRevisa +"' AND "
	If !Empty(cCronog)
		cQuery += "SE2.E2_MDCRON = '"+ cCronog +"' AND "
	EndIf
	If !Empty(cParcel)
		cQuery += "SE2.E2_MDPARCE = '"+ cParcel +"' AND "
	EndIf
	cQuery += "SE2.D_E_L_E_T_ = ' '"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE2TMP",.F.,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza exclusao dos titulos               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !SE2TMP->(Eof())
		dbSelectArea("SE2")
		dbGoTo(SE2TMP->RECNO)
		
		RecLock("SE2",.F.)
		dbDelete()
		FaAvalSE2(2,"CNTA100")
		FaAvalSE2(3,"CNTA100")
		MsUnlock()
		
		SE2TMP->(dbSkip())
	EndDo
	
	SE2TMP->(dbCloseArea())
EndIf

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS400Track³ Autor ³ Sergio Silveira       ³ Data ³22/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS400Track()

Local aEnt     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percorre o acols                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aEnt, { "CN9", M->CN9_NUMERO + M->CN9_REVISA } )

MaTrkShow( aEnt )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400IncDoc³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Visualiza o documento ou o banco de conhecimento do item    ³±±
±±³          ³ selecionado na tree                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400IncDoc(oExp01,aExp02,cExp03,lExp04)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto dbTree                                      ³±±
±±³          ³ aExp02 - Array com as informacoes dos documentos            ³±±
±±³          ³ cExp03 - Codigo do contrato                                 ³±±
±±³          ³ lExp04 - Valida banco de conhecimento                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400IncDoc(oTree,aDocs,cContra,lBcVld)
Local nPos   := 0
Local cCargo := oTree:GetCargo()
Local aArea  := GetArea()
Local nPosN  := 0
Local cCod   := ""
Local lValid :=.F.
Local cRsrc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o item selecionado representa um grupo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "A" $ cCargo
	nPos := val(SubStr(cCargo,2,len(cCargo)))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama rotina de inclusao                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If CN170Manut("CNK",,3,,cContra,aDocs[nPos,1],@cCod)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona registro incluso                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNK")
		dbSetOrder(1)
		dbSeek(xFilial("CNK")+cCod)
		
		npos := aScan(aDocs,{|x| x[1] == CNK->CNK_TPDOC})
		
		If nPos > 0 .And. CNK->CNK_CONTRA == cContra
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o item se encontra vazio               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aDocs[nPos,3])
				nPosN := nPos
				cCargo := "V"+AllTrim(str(nPos))
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se valida banco de conhecimento           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lBcVld
				lValid := .F.//Nao valida documento, quando houver controle do banco de conhec.
			Else
				lValid := (CNK->CNK_DTEMIS <= dDataBase .And. CNK->CNK_DTVALI >= dDataBase)//Valida datas do documento
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa contadores dos documentos               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aEval(aDocs,{|x| If(x[1] == aDocs[nPos,1],(If(lValid,x[8]++,),x[9]++),)})
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Seleciona resource de acordo com a validacao       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cRsrc := If(lValid,"LBTIK","LBNO")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona documento no array                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aDocs,{aDocs[nPos,1],aDocs[nPos,2],CNK->CNK_CODIGO,CNK->CNK_DESCRI,CNK->CNK_DTEMIS,CNK->CNK_DTVALI,CNK->CNK_OBS,aDocs[nPos,8],aDocs[nPos,9],aDocs[nPos,10]})
			
			oTree:BeginUpdate()
			oTree:TreeSeek("A"+AllTrim(str(nPos)))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera resource da arvore qd o doc estiver valido  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lValid
				oTree:ChangeBmp("LBTIK","LBTIK")
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona item na dbtree                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oTree:AddItem(CNK->CNK_CODIGO+"-"+CNK->CNK_DESCRI,alltrim(str(len(aDocs))),cRsrc,cRsrc,,,2)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o grupo ja possui docs                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oTree:TreeSeek("V"+AllTrim(str(nPos)))
				oTree:DelItem()
			EndIf
			
			oTree:EndUpdate()
			oTree:Refresh()
		EndIf
	EndIf
Else
	Aviso("CNTA100",OemtoAnsi(STR0081),{"OK"})
EndIf

RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400VisDoc³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Visualiza o documento ou o banco de conhecimento do item    ³±±
±±³          ³ selecionado na tree                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400VisDoc(oExp01,aExp02,lExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto dbTree                                      ³±±
±±³          ³ aExp02 - Array com as informacoes dos documentos            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400VisDoc(oTree,aDocs,lVisBC)
Local nPos := 0
Local cCargo := oTree:GetCargo()
Local aArea := GetArea()

If "A" $ cCargo .OR. "V" $ cCargo
	nPos := val(SubStr(cCargo,2,len(cCargo)))
Else
	nPos := val(cCargo)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe documento para o grupo          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPos > 0 .And. !Empty(aDocs[nPos,3])
	dbSelectArea("CNK")
	dbSetOrder(1)
	If dbSeek(xFilial("CNK")+aDocs[npos,3])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chama banco de conhecimento ou visualizacao do doc ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lVisBC
			CN170Manut("CNK",CNK->(RECNO()),2)
		Else
			CN170Conh()
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Doc  ³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de validacao dos documentos, executada na alteracao ³±±
±±³          ³ de situacao do contrato                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA100Doc(nExp01,cExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Contrato selecionado                              ³±±
±±³          ³ aExp02 - Situacoes para qual o contrato sera alterado      ³±±
±±³          ³ lExp03 - Valida situacoes inferiores                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400Doc(nReg,aSituac,lAll)
Local oDlDoc
Local oTree       //Objeto dbtree
Local cCod        //Codigo do tipo de documento
Local lFirst      //Identifica varredura dos tipos de documento
Local cRsrc       //Resource usado
Local nTotTree    //Total de docs para cada tipo de documento
Local nTotDVld    //Total de docs validos para cada tipo de documento
Local cDescLib := ""     //Situacao de todos os documentos
Local cDescTpc := ""     //Tipo do Contrato
Local cCadastro:= STR0078//"Check-List de Documentos"
Local aCtrs  := Array(11)//Array com os controles de tela
Local lBsCnh := (GetNewPar( "MV_CNDOCBC", "S" ) == "S")//Verifica se a validacao leva em consideracao o banco de conhec.
Local aSits  := RetSx3Box( Posicione("SX3", 2, "CN9_SITUAC", "X3CBox()" ),,, 1 )
Local cDescSt:= ""
Local aIfDoc := {}//Array com as informacoes de exibicao
Local cQuery := ""
Local aDocs  := {}
Local cAlias := GetNextAlias()
Local lBcoAc := CN240VldUsr(CN9->CN9_NUMERO,DEF_TRABCO,.F.)
Local nx
Local nPos
Local cCargo
Local lLiber:= .T.
Local lContinua := .T.
Local nTotBc:=0
Local cSituac := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controles visuais                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fixa dimensao da dialog                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSize     := MsAdvSize( .F. )//{0,0,300,200,690,422,17}//MsAdvSize( .F. )
Local aObjects  := {}
Local aObjects2 := {}
Local aUsButtons:= {}
Local aPosObj1  := {}
Local aPosObj2  := {}
Local oPanel,oGroup1,oGroup2
Local lInc
Local lExecFormula:=.T.
Local lFormus:=CN5->(FieldPos("CN5_FORMUS")) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta estrutura das situacoes para pesquisa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(aSituac) > 1
	For nx:=1 to len(aSituac)
		cSituac+="'"+aSituac[nx]+"',"
		cDescSt+= AllTrim( aSits[Ascan( aSits, { |aBox| substr(aBox[1],1,At("=",aBox[1])-1) = AllTrim(aSituac[nx])} )][3] )+", "
	Next
	cSituac := SubStr(cSituac,1,len(cSituac)-1)
Else
	cDescSt:= AllTrim( aSits[Ascan( aSits, { |aBox| substr(aBox[1],1,At("=",aBox[1])-1) = AllTrim(aSituac[1])} )][3] )
EndIf

dbSelectArea("AC9")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do aIfDoc                                   ³
//³ aIfDoc[1] - Codigo do tipo de documento               ³
//³ aIfDoc[2] - Descricao do tipo de documento            ³
//³ aIfDoc[3] - Codigo do Documento                       ³
//³ aIfDoc[4] - Descricao do Documento                    ³
//³ aIfDoc[5] - Data de emissao do documento              ³
//³ aIfDoc[6] - Data de validacao do documento            ³
//³ aIfDoc[7] - Obs do documento                          ³
//³ aIfDoc[8] - Total de documentos do tipo de documento  ³
//³ aIfDoc[9] - Total de documentos validos do tipo de doc³
//³ aIfDoc[10]- Total de registros no banco de conhecim.  ³
//³ aIfDoc[11]- Situacao do documento                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aIfDoc := {"","","","",CTOD("  /  /  "),CTOD("  /  /  "),"",0,0,0,""}

dbSelectArea("CN9")
dbGoTo(nReg)

cDescTpc := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_DESCRI")

dbSelectArea("CNJ")
dbSelectArea("CN5")
dbSelectArea("CNK")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna documentos requisitados pela nova situacao ³
//³ junto com os documentos ja cadastrados             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFormUs
	cQuery := "SELECT CN5.CN5_CODIGO,CN5.CN5_DESCRI,CN5.CN5_FORMUS,CNK.CNK_CODIGO,CNK.CNK_DESCRI,CNK.CNK_DTEMIS,CNK.CNK_DTVALI,CNK.CNK_OBS,CNJ.CNJ_SITUAC "
Else
	cQuery := "SELECT CN5.CN5_CODIGO,CN5.CN5_DESCRI,CNK.CNK_CODIGO,CNK.CNK_DESCRI,CNK.CNK_DTEMIS,CNK.CNK_DTVALI,CNK.CNK_OBS,CNJ.CNJ_SITUAC "
EndIf
cQuery += "FROM "+ RetSQLName("CNJ") +" CNJ , "+ RetSQLName("CN5") +" CN5, "+ RetSQLName("CNK") +" CNK WHERE "
cQuery += "CNJ.CNJ_FILIAL = '"+xFilial("CNJ")+"' AND "
cQuery += "CN5.CN5_FILIAL = '"+xFilial("CN5")+"' AND "
cQuery += "CNK.CNK_FILIAL = '"+xFilial("CNK")+"' AND "
cQuery += "CNJ.CNJ_TPCTO in ('','"+ CN9->CN9_TPCTO +"') AND "
If len(aSituac) > 1
	cQuery += "CNJ.CNJ_SITUAC IN ("+cSituac+") AND "
Else
	cQuery += "CNJ.CNJ_SITUAC = '"+ aSituac[1] +"' AND "
EndIf
cQuery += "CNJ.CNJ_TPDOC = CN5.CN5_CODIGO AND "
cQuery += "CNK.CNK_CONTRA = '"+ CN9->CN9_NUMERO +"' AND "
cQuery += "CNK.CNK_TPDOC = CN5.CN5_CODIGO AND "
cQuery += "CNJ.D_E_L_E_T_ <> '*' AND "
cQuery += "CN5.D_E_L_E_T_ <> '*' AND "
cQuery += "CNK.D_E_L_E_T_ <> '*' "
cQuery += "UNION "
If lFormUs
	cQuery += "SELECT CN5.CN5_CODIGO,CN5.CN5_DESCRI,CN5.CN5_FORMUS,'"+Space(TamSx3("CNK_CODIGO")[1])+"' as CNK_CODIGO,'"+Space(TamSx3("CNK_DESCRI")[1])+"' as CNK_DESCRI,'        ' as CNK_DTEMIS,'        ' as CNK_DTVALI,'"+Space(TamSx3("CNK_OBS")[1])+"' as CNK_OBS,CNJ_SITUAC FROM "+ RetSQLName("CNJ") +" CNJ , "+ RetSQLName("CN5") +" CN5 WHERE "
Else
	cQuery += "SELECT CN5.CN5_CODIGO,CN5.CN5_DESCRI,'"+Space(TamSx3("CNK_CODIGO")[1])+"' as CNK_CODIGO,'"+Space(TamSx3("CNK_DESCRI")[1])+"' as CNK_DESCRI,'        ' as CNK_DTEMIS,'        ' as CNK_DTVALI,'"+Space(TamSx3("CNK_OBS")[1])+"' as CNK_OBS,CNJ_SITUAC FROM "+ RetSQLName("CNJ") +" CNJ , "+ RetSQLName("CN5") +" CN5 WHERE "
EndIf
cQuery += "CNJ.CNJ_FILIAL = '"+xFilial("CNJ")+"' AND "
cQuery += "CN5.CN5_FILIAL = '"+xFilial("CN5")+"' AND "
cQuery += "CNJ.CNJ_TPCTO in ('','"+CN9->CN9_TPCTO +"') AND "
If len(aSituac) > 1
	cQuery += "CNJ.CNJ_SITUAC IN ("+cSituac+") AND "
Else
	cQuery += "CNJ.CNJ_SITUAC <= '"+ aSituac[1] +"' AND "
EndIf
cQuery += "CNJ.CNJ_TPDOC = CN5.CN5_CODIGO AND "
cQuery += "NOT EXISTS (Select CNK.CNK_CODIGO from "+ RetSQLName("CNK") +" CNK where CNK.CNK_FILIAL = '"+xFilial("CNK")+"' AND CNK.CNK_CONTRA = '"+CN9->CN9_NUMERO+"' AND CNK.CNK_TPDOC = CNJ.CNJ_TPDOC AND CNK.D_E_L_E_T_ = '') AND "
cQuery += "CNJ.D_E_L_E_T_ <> '*' AND "
cQuery += "CN5.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY 1,5"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

TCSetField(cAlias,"CNK_DTEMIS","D",08,0)
TCSetField(cAlias,"CNK_DTVALI","D",08,0)

lContinua := !((cAlias)->(Eof()))

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena documentos no array aDocs                     ³
	//³ Estrutura do aDocs                                     ³
	//³ aDocs[x,1] - Codigo do tipo de documento               ³
	//³ aDocs[x,2] - Descricao do tipo de documento            ³
	//³ aDocs[x,3] - Codigo do Documento                       ³
	//³ aDocs[x,4] - Descricao do Documento                    ³
	//³ aDocs[x,5] - Data de emissao do documento              ³
	//³ aDocs[x,6] - Data de validacao do documento            ³
	//³ aDocs[x,7] - Obs do documento                          ³
	//³ aDocs[x,8] - Total de documentos validos do tipo de doc³
	//³ aDocs[x,9] - Total de documentos do tipo de documento  ³
	//³ aDocs[x,10]- Total de registros no banco de conhecim.  ³
	//³ aDocs[x,11]- Indica se o documento é necessario neste contrato (formula do cadastro) 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(cAlias)->(Eof())
		lInc := .T.
		nTotBc:=0
		If lBsCnh .And. !Empty((cAlias)->CNK_CODIGO)
			cQuery := "SELECT COUNT(AC9.AC9_ENTIDA) AS BS_CONHE FROM "+ RetSQLName("AC9") +" AC9 "
			cQuery += "WHERE AC9.AC9_FILIAL = '"+xFilial("AC9")+"' AND "
			cQuery += "AC9.AC9_ENTIDA='CNK' AND "
			cQuery += "AC9.AC9_CODENT = '"+(cAlias)->CNK_CODIGO+"' "
			cQuery += "AND AC9.D_E_L_E_T_ = ''"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBAC9",.F.,.T.)
			
			nTotBc := TRBAC9->BS_CONHE
			
			TRBAC9->(dbCloseArea())
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica documentos de situacoes anteriores que    ³
		//³ ja tenham sido validados e nao devem ser           ³
		//³ listados                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If len(aSituac) == 1 .And. aSituac[1] > (cAlias)->CNJ_SITUAC
			If lAll
				lInc := !((cAlias)->CNK_DTEMIS <= dDataBase .AND. (cAlias)->CNK_DTVALI >= dDataBase)
				if lBsCnh
					lInc := (nTotBc == 0)
				EndIf
			Else
				lInc := .F.
			EndIf
		EndIf
		
		If lInc
			// Checa necessidade do documento para o contrato em questao
			If lFormUs
				lExecFormula:=.T.
				If !Empty((cAlias)->CN5_FORMUS)
					// Executa formula
					lExecFormula:=Formula((cAlias)->CN5_FORMUS)	
				EndIf		
			EndIf
			aAdd(aDocs,{(cAlias)->CN5_CODIGO,(cAlias)->CN5_DESCRI,(cAlias)->CNK_CODIGO,(cAlias)->CNK_DESCRI,(cAlias)->CNK_DTEMIS,(cAlias)->CNK_DTVALI,(cAlias)->CNK_OBS,0,0,nTotBc,lExecFormula})
		EndIf
		(cAlias)->(dbSkip())
	EndDo         
	
	(cAlias)->(dbCloseArea())
	
	dbSelectArea("CN9")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula posicao dos objetos na tela                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	AAdd( aObjects, { 230, 030, .T., .F., .T. } )//Painel superior
	AAdd( aObjects, { 120, 144, .T., .T., .F. } )//dbTree
	AAdd( aObjects, { 120, 20, .T., .F., .F. } )//Botoes
	
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj1 := MsObjSize( aInfo, aObjects, .T., .F. )
	
	AAdd( aObjects2, { 120, 144, .T., .T., .F. } )//Group: Tipo de Documento
	AAdd( aObjects2, { 170, 144, .F., .T., .F. } )//Group: Informacoes do documento
	
	aInfo    := { aPosObj1[2,2],aPosObj1[2,1], aPosObj1[2,4], aPosObj1[2,3], 3, 3 }
	aPosObj2 := MsObjSize( aInfo, aObjects2, .F., .T. )
	
	DEFINE MSDIALOG oDlDoc TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] PIXEL
	
	@ aPosObj1[1,1], aPosObj1[1,2] MSPANEL oPanel PROMPT "" SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlDoc
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Situacao do contrato                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 001,000 Say RetTitle("CN9_SITUAC") Of oPanel PIXEL
	@ 000,024 MsGet oGetSit Var cDescSt When .F. PIXEL  Size 50,5 Of oPanel
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo do contrato                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 001,082 Say RetTitle("CN9_TPCTO") Of oPanel PIXEL
	@ 000,122 MsGet oGetTCto Var cDescTpc When .F. PIXEL  Size 100,5 Of oPanel
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Situacao geral dos documentos                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 013,000 Say STR0063 Of oPanel PIXEL//"Situação Geral"
	@ 012,47 MsGet oGetSLib Var cDescLib When .F. PIXEL  Size 100,5 Of oPanel
	
	@ aPosObj1[2,1]-008,aPosObj1[2,2] Say STR0064 Of oDlDoc PIXEL//"Documentos Requisitados"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DBtree - Estrutura                                 ³
	//³ ÀÄNivel 1 - Tipos de Documentos                    ³
	//³ ÀÄÄÄNivel 2 - Documentos cadastrados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE DBTREE oTree ON CHANGE {CS400AlDoc(@oTree,aDocs,aIfDoc,lBsCnh),aEval(aCtrs,{|x| If (x!=Nil,x:Refresh(),)})} FROM aPosObj2[1,1],aPosObj2[1,2] TO aPosObj2[1,3],aPosObj2[1,4] OF oDlDoc CARGO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Menu de visualizacao do documento                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MENU oMenuTree POPUP
	MENUITEM OemToAnsi(STR0003) Action CS400VisDoc(oTree,aDocs,.F.)//"Visualizar"
	MENUITEM OemToAnsi(STR0080) Action (CS400IncDoc(oTree,aDocs,CN9->CN9_NUMERO,lBsCnh),If(aScan(aDocs,{|x| x[8] == 0})==0,(lLiber:=.T.,cDescLib:=STR0066,oGetSLib:Refresh()),))//If((oTree:GetCargo() $ "A"),CS400IncDoc(oTree,aDocs,.F.,CN9->CN9_NUMERO),Aviso("CNTA100",OemtoAnsi(STR0081),{"OK"}))//"Incluir Documento"
	If lBcoAc//Quando o usuario possui acesso ao banco de conhecimento
		MENUITEM OemToAnsi(STR0056) ACTION CS400VisDoc(oTree,aDocs,.T.)//"Banco de Conhecimento"
	EndIf
	ENDMENU
	
	oTree:bRClicked   := { |oObject,nx,ny| oMenuTree:Activate( nX-80, nY-200, oObject ) }
	
	lFirst := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Arvore principal                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DBADDTREE oTree PROMPT cDescTpc OPEN OPENED CARGO "V0000"
	
	for nx:=1 to len(aDocs)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Primeiro registro do tipo de documento             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFirst
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o tipo de documento possui algum       ³
			//³ documento valido ou se a formula de uso retornou negativo                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !aDocs[nx,11] .Or. (aScan(aDocs,{|x| x[1] = aDocs[nX,1] .And. x[5] <= dDataBase .And. x[6] >= dDataBase .And. If(lBsCnh,x[10]>0,.T.)}) > 0)
				cRsrc := "LBTIK"
			Else
				cRsrc := "LBNO"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta arvore do tipo de documento com a identificacao³
			//³ "A" no cargo                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCargo := "A"+alltrim(str(nX))
			DBADDTREE oTree PROMPT aDocs[nX,1]+"-"+aDocs[nX,2] RESOURCE cRsrc CARGO cCargo
			lFirst := .F.
			cCod :=  aDocs[nX,1]
			nTotTree:=0
			nTotDVld:=0
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera item do documento                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aDocs[nx,5]) .Or. !aDocs[nx,11]
			If !aDocs[nx,11] .Or. (aDocs[nx,5] <= dDataBase .And. aDocs[nx,6] >= dDataBase .And. If(lBsCnh,aDocs[nx,10]>0,.T.))
				nTotDVlD++
				cRsrc := "LBTIK"
			Else
				cRsrc := "LBNO"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Identifica cargo com a posicao do array aDocs      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !aDocs[nx,11]	
				cCargo := "V"+alltrim(str(nX))
				DBADDITEM oTree PROMPT OemToAnsi(STR0143) CARGO cCargo //"Documento nao necessario"
            Else
				cCargo := alltrim(str(nX))
				DBADDITEM oTree PROMPT aDocs[nx,3]+"-"+aDocs[nx,4] RESOURCE cRsrc CARGO cCargo            
            EndIf
			nTotTree++
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se e o ultimo elemento do grupo           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nx == len(aDocs) .Or. aDocs[nX+1,1] != cCod
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza campos totalizadores do grupo             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aDocs := aEval(aDocs,{|x| If(x[1] == aDocs[nX,1],(x[8]:=nTotDVlD,x[9]:=nTotTree),)})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera item quando o grupo nao possuir documentos    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTotTree==0
				cCargo := "V"+alltrim(str(nX))
				DBADDITEM oTree PROMPT STR0065 CARGO cCargo//"Documento não fornecido"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o tipo de documento foi liberado       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lLiber
				lLiber := (nTotTree > 0 .And. nTotDVlD>0)
			EndIf
			nTotTree:=0
			DBENDTREE oTree
			lFirst := .T.
		EndIf
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera elemento quando nao houver estrutura          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If len(aDocs) == 0
		DBADDITEM oTree PROMPT STR0079 CARGO "V0000"//"Vazio"
	EndIf
	
	DBENDTREE oTree
	
	cDescLib := If(lLiber,STR0066,STR0067)//"Docs Liberados"##"Docs Pendentes"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Componentes visuais de identificacao do documento  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ aPosObj2[2,1],aPosObj2[2,2] GROUP oGroup1 To aPosObj2[2,3],aPosObj2[2,4] Label OemToAnsi(STR0068) Of oDlDoc PIXEL//"Tipo do Documento"
	
	@ aPosObj2[2,1]+008,aPosObj2[2,2]+005 Say oCdTDoc Var RetTitle("CN5_CODIGO") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+008,aPosObj2[2,2]+060 MsGet aCtrs[1] Var aIfDoc[1] Picture PesqPict("CN5","CN5_CODIGO") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+019,aPosObj2[2,2]+005 Say oNmTDoc Var RetTitle("CN5_DESCRI") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+019,aPosObj2[2,2]+060 MsGet aCtrs[2] Var aIfDoc[2] Picture PesqPict("CN5","CN5_DESCRI") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+032,aPosObj2[2,2]+005 Say aCtrs[9] Var OemToAnsi(STR0069)+AllTrim(str(aIfDoc[9])) Size 100,8 Of oGroup1 PIXEL//"Total de Documentos: "
	@ aPosObj2[2,1]+032,aPosObj2[2,2]+075 Say aCtrs[10] Var OemToAnsi(STR0070)+AllTrim(str(aIfDoc[8])) Size __DlgWidth(oDlDoc)-42,8 Of oGroup1 PIXEL//"Documentos Válidos: "
	
	@ aPosObj2[2,1]+047,aPosObj2[2,2]+005 Say OemToAnsi(STR0071) Size 100,8 Of oGroup1 PIXEL//"Detalhes do Documento"
	@ aPosObj2[2,1]+057,aPosObj2[2,2]+005 Say oCdDoc Var RetTitle("CNK_CODIGO") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+057,aPosObj2[2,2]+060 MsGet aCtrs[4] Var aIfDoc[3] Picture PesqPict("CNK","CNK_CODIGO") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+068,aPosObj2[2,2]+005 Say oNmDoc Var RetTitle("CNK_DESCRI") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+068,aPosObj2[2,2]+060 MsGet aCtrs[3] Var aIfDoc[4] Picture PesqPict("CNK","CNK_DESCRI") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+079,aPosObj2[2,2]+005 Say oDeDoc Var RetTitle("CNK_DTEMIS") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+079,aPosObj2[2,2]+060 MsGet aCtrs[5] Var aIfDoc[5] Picture PesqPict("CNK","CNK_DTEMIS") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+090,aPosObj2[2,2]+005 Say oDvDoc Var RetTitle("CNK_DTVALI") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+090,aPosObj2[2,2]+060 MsGet aCtrs[6] Var aIfDoc[6] Picture PesqPict("CNK","CNK_DTVALI") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+101,aPosObj2[2,2]+005 Say oObDoc Var RetTitle("CNK_OBS") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+101,aPosObj2[2,2]+060 MsGet aCtrs[7] Var aIfDoc[7] Picture PesqPict("CNK","CNK_OBS") When .F. Size 100,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+112,aPosObj2[2,2]+005 Say oStDoc Var OemToAnsi(STR0072) Size 50,8 Of oGroup1 PIXEL//"Status"
	@ aPosObj2[2,1]+112,aPosObj2[2,2]+060 MsGet aCtrs[8] Var aIfDoc[11] When .F. Size 100,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+125,aPosObj2[2,2]+005 Say aCtrs[11] Var OemToAnsi(STR0073)+AllTrim(str(aIfDoc[10]))+OemToAnsi(STR0074) Size __DlgWidth(oDlDoc)-42,8 Of oGroup1 PIXEL//"Base de Conhecimento: "##" registro(s)"
	
	DEFINE SBUTTON FROM aPosObj1[3,1], aPosObj1[3,4]-55 TYPE 1 ACTION (If((nPos:=aScan(aDocs,{|x| x[8]==0})==0),(oDlDoc:End()),(Help(" ",1,"CNTA100DOC"),oDlDoc:End()))) ENABLE OF oDlDoc
	DEFINE SBUTTON FROM aPosObj1[3,1], aPosObj1[3,4]-25 TYPE 2 ACTION (lLiber:=.F.,oDlDoc:End()) ENABLE OF oDlDoc
	
	ACTIVATE MSDIALOG oDlDoc CENTERED
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera validacao quando nao houver documentos relacionados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lLiber:=.T.
	(cAlias)->(dbCloseArea())
EndIf

RestArea(aArea)
Return lLiber

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400AlDoc³ Autor ³ Microsiga      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza valores de exibicao do elemento selecionado       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400AlDoc(oExp01,aExp02,aExp03,lExp04)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - DbTree                                            ³±±
±±³          ³ aExp02 - Array com as informacoes dos documentos           ³±±
±±³          ³ aExp03 - Array com os valores exibidos na dialog           ³±±
±±³          ³ aExp04 - Valida documento com base no banco de conhecimento³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400AlDoc(oTree,aDocs,aIfDoc,lBsCnh)
Local nPos := 0
Local cCargo := oTree:GetCargo()

aIfDoc := {}//Limpa array de exibicao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica posicao no array aDocs                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "A" $ cCargo .Or. "V" $ cCargo
	nPos := val(SubStr(cCargo,2,len(cCargo)))
Else
	nPos := val(cCargo)
EndIf
If nPos == 0
	aIfDoc := {"","","","",CTOD("  /  /  "),CTOD("  /  /  "),"",0,0,0,""}
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera copia do item do aDocs para o aIfDoc          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aIfDoc:=aClone(aDocs[nPos])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica situacao do documento quando o mesmo existir³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aDocs[nPos,3])
		If aDocs[nPos,5] <= dDataBase .And. aDocs[nPos,6] >= dDataBase
			If !lBsCnh
				aAdd(aIfDoc,STR0075)//"Válido"
			elseIf aDocs[nPos,10]==0
				aAdd(aIfDoc,STR0076)//"Não possui banco de conhecimento"
			else
				aAdd(aIfDoc,STR0075)//"Válido"
			EndIf
		Else
			aAdd(aIfDoc,STR0077)//"Vencido"
		EndIf
	Else
		aAdd(aIfDoc,"")//"Vencido"
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400IncArr³ Autor ³ Microsiga      ³ Data ³07.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a inclusao de planilhas no array aPlani, durante    ³±±
±±³          ³ a inclusao do contrato                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400IncArr(nExp01,aExp02,aExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                        ³±±
±±³          ³ aExp02 - Array com as informacoes das planilhas             ³±±
±±³          ³ aExp03 - Array com os itens(acols) das planilhas            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400IncArr(npc,aPlani,aPlIt)
Local nTotPlan := len(aPlani)
Local ny
Local cPlani := strzero(1,TamSx3("CNA_NUMERO")[1])
Local nPosForn := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})
Local nPosLoja := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})
Local nPosTotP := aScan(aHeader3,{|x| x[2] == "CNA_VLTOT"})
Local dTermino
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA

cCadastro := STR0084//"Cadastro de Planilhas"
INCLUI := .T.
ALTERA := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera array de fornecedores usado na validacao da planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aForn := aEval(oGetDad1:aCols,{|x| {x[nPosForn],x[nPosLoja]}})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula data de termino do contrato  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(M->CN9_UNVIGE)
	dTermino := CS400DtFim(M->CN9_UNVIGE,M->CN9_DTINIC,M->CN9_VIGE)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula numero sequencial da planilha com base nas planilhas existentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(aPlani) > 0
	For ny:=1 to len(aPlani)
		If aPlani[ny,CNA->(FieldPos("CNA_NUMERO"))] >= cPlani
			cPlani := Soma1(aPlani[ny,CNA->(FieldPos("CNA_NUMERO"))])
		EndIf
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotina de manutencao das planilhas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If u_CS600Manut("CNA",5000,npc,,.F.,.F.,aPlani,aPlIt,M->CN9_NUMERO,cPlani,M->CN9_DTINIC,dTermino)
	If nTotPlan != len(aPlani)
		If len(aCols3) > 1 .Or. !Empty(aCols3[1,1])
			aAdd(aCols3,Array(len(aHeader3)+1))
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza folder das planilhas com base na inclusao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ny:=1 to len(aHeader3)
			aCols3[len(aCols3),ny] := aPlani[len(aPlani),CNA->(FieldPos(aHeader3[ny,2]))]
		Next
		aCols3[len(aCols3),len(aHeader3)+1] := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza totais do contrato         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI + aCols3[len(aCols3),nPosTotP]
		
		oGetDad3:aCols := aCols3
		oGetDad3:oBrowse:Refresh()
		oGetDad3:Refresh()
	EndIf
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400IncPla³ Autor ³ Microsiga      ³ Data ³07.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a inclusao de planilhas durante a edicao do contrato³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400IncPla()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400IncPla()
Local nTotPlan := len(oGetDad3:aCols)
Local ny
Local cPlani := strzero(1,TamSx3("CNA_NUMERO")[1])
Local nPosForn := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})
Local nPosLoja := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})
Local nPosTotP := aScan(aHeader3,{|x| x[2] == "CNA_VLTOT"})
Local nPosNumP := aScan(aHeader3,{|x| x[2] == "CNA_NUMERO"})
Local dTermino
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA

cCadastro := STR0084//"Cadastro de Planilhas"
INCLUI := .T.
ALTERA := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera array de fornecedores usado na validacao da planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aForn := aEval(oGetDad1:aCols,{|x| {x[nPosForn],x[nPosLoja]}})

aCols3 := oGetDad3:aCols

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula data de termino do contrato  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(M->CN9_UNVIGE) .And. !Empty(M->CN9_VIGE)
	dTermino := CS400DtFim(M->CN9_UNVIGE,M->CN9_DTINIC,M->CN9_VIGE)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica total de planilhas          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotPlan == 1 .And. Empty(aCols3[1,nPosNumP])
	nTotPlan := 0
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula numero sequencial da planilha com base nas planilhas existentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotPlan > 0
	For ny:=1 to len(aCols3)
		If aCols3[ny,nPosNumP] >= cPlani
			cPlani := Soma1(aCols3[ny,nPosNumP])
		EndIf
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotina de manutencao das planilhas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If u_CS600Manut("CNA",5000,3,,.F.,.F.,,,M->CN9_NUMERO,@cPlani,M->CN9_DTINIC,dTermino)
	If len(aCols3) == 1 .And. Empty(aCols3[1,1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui linha da planilha em branco              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDel(aCols3,1)
		aSize(aCols3,0)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza item da planilha no folder             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNA")
	dbSetOrder(1)
	If dbSeek(xFilial("CNA")+M->CN9_NUMERO+M->CN9_REVISA+cPlani)
		aAdd(aCols3,Array(len(aHeader3)+1))
		For nY	:= 1 To Len(aHeader3)
			cCampo := Alltrim(aHeader3[nY,2])
			If ( aHeader3[nY][10] != "V" )
				aCols3[len(aCols3),nY] := FieldGet(FieldPos(aHeader3[nY][2]))
			Else
				aCols3[len(aCols3),nY] := CriaVar(aHeader3[nY][2])
			EndIf
		Next nY
		aCols3[len(aCols3),Len(aHeader3)+1] := .F.
	EndIf
	oGetDad3:aCols := aCols3
	oGetDad3:oBrowse:Refresh()
	oGetDad3:Refresh()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza valores totais do contrato             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CN9")
	dbSetOrder(1)
	If dbSeek(xFilial("CN9")+M->CN9_NUMERO+M->CN9_REVISA)
		M->CN9_VLATU := CN9->CN9_VLATU
		M->CN9_SALDO := CN9->CN9_SALDO
		M->CN9_VLINI := CN9->CN9_VLINI
	EndIf
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400AltArr³ Autor ³ Microsiga      ³ Data ³07.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a alteracao de planilhas no array aPlani, durante   ³±±
±±³          ³ a inclusao do contrato                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400AltArr(nExp01,aExp02,aExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                        ³±±
±±³          ³ aExp02 - Array com as informacoes das planilhas             ³±±
±±³          ³ aExp03 - Array com os itens(acols) das planilhas            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400AltArr(npc,aPlani,aPlIt)
Local nTotPlan := len(aPlani)
Local ny
Local cPlani := strzero(1,TamSx3("CNA_NUMERO")[1])
Local nPosForn := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})
Local nPosLoja := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})
Local nPosPlan := aScan(aHeader3,{|x| x[2] == "CNA_NUMERO"})
Local nPosTotP := aScan(aHeader3,{|x| x[2] == "CNA_VLTOT"})
Local nPlan
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA

cCadastro := STR0084//"Cadastro de Planilhas"
INCLUI := .F.
ALTERA := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera array de fornecedores usado na validacao da planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aForn := aEval(oGetDad1:aCols,{|x| {x[nPosForn],x[nPosLoja]}})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica planilha selecionada                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPlani := oGetDad3:aCols[oGetDad3:nAt,nPosPlan]
nPlan  := aScan(aPlani,{|x| x[CNA->(FieldPos("CNA_NUMERO"))] == cPlani})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotina de manutencao de planilhas       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if u_CS600Manut("CNA",5000,npc,,.F.,.F.,aPlani,aPlIt,M->CN9_NUMERO,cPlani)
	
	If npc != 5//Alteracao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui valor antigo                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI - aCols3[nPlan,nPosTotP]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza folder de planilhas                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ny:=1 to len(aHeader3)
			aCols3[nPlan,ny] := aPlani[nPlan,CNA->(FieldPos(aHeader3[ny,2]))]
		Next
		aCols3[nPlan,len(aHeader3)+1] := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza totais do contrato                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI + aCols3[nPlan,nPosTotP]
	Else//Exclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui valor da planilha dos totais do contrato ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI - aCols3[nPlan,nPosTotP]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui planilha da folder                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDel(aCols3,nPlan)
		aSize(aCols3,len(aCols3)-1)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza folder                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad3:aCols := aCols3
	oGetDad3:oBrowse:Refresh()
	oGetDad3:Refresh()
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400AltPla³ Autor ³ Microsiga      ³ Data ³07.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a alteracao de planilhas durante a edicao do        ³±±
±±³          ³ contrato                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400AltPla(nExp01)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400AltPla(npc)
Local nPlan
Local cPlan
Local nRecno := 0
Local nCntFor
Local cCampo
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA

cCadastro := STR0084//"Cadastro de Planilhas"
INCLUI := .F.
ALTERA := .T.

aCols3 := oGetDad3:aCols

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica planilha selecionada                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPlan := oGetDad3:nAt
cPlan := aCols3[nPlan,aScan(aHeader3,{|x| x[2] == "CNA_NUMERO"})]

dbSelectArea("CNA")
dbSetOrder(1)
dbSeek(xFilial("CNA")+M->CN9_NUMERO+M->CN9_REVISA+cPlan)

nRecNo := CNA->(RecNo())

If nRecno > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa rotina de manutencao da planilha        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If u_CS600Manut("CNA",CNA->(RecNo()),npc)
		If npc == 4//Alteracao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera registro selecionado                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbGoto(nRecno)
			For nCntFor	:= 1 To Len(aHeader3)
				cCampo := Alltrim(aHeader3[nCntFor,2])
				If ( aHeader3[nCntFor][10] != "V" )
					aCols3[nPlan,nCntFor] := FieldGet(FieldPos(aHeader3[nCntFor][2]))
				Else
					aCols3[nPlan,nCntFor] := CriaVar(aHeader3[nCntFor][2])
				EndIf
			Next nCntFor
			aCols3[nPlan,Len(aHeader3)+1] := .F.
		Else//Exclusao
			aDel(aCols3,nPlan)
			aSize(aCols3,len(aCols3)-1)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza folder das planilhas                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oGetDad3:aCols := aCols3
		oGetDad3:oBrowse:Refresh()
		oGetDad3:Refresh()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza campos totais do contrato              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+M->CN9_NUMERO+M->CN9_REVISA)
			M->CN9_VLATU := CN9->CN9_VLATU
			M->CN9_SALDO := CN9->CN9_SALDO
			M->CN9_VLINI := CN9->CN9_VLINI
		EndIf
	EndIf
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400PlGr  ³ Autor ³ Microsiga      ³ Data ³07.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa gravacao do array de planilhas no banco             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400PlGr(aExp01,aExp02)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Opcao atual                                        ³±±
±±³          ³ aExp02 - Opcao atual                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400PlGr(aPlani,aPlIt)
Local nCntFor  := 0
Local nTam     := 0
Local nUsado   := 0
Local nCntFor2 := 0
Local nItem    := 0
Local nTot     := 0
Local nTotAnt  := 0
Local nQtAtd   := 0
Local aHeader  := u_CS600GerHd(1,.F.,.F.,.T.)
Local cFilCod
Local cFilSC1  := xFilial("SC1")
Local nPosSC1  := aScan(aHeader,{|x| x[2]="CNB_NUMSC"})
Local nPosItSC := aScan(aHeader,{|x| x[2]="CNB_ITEMSC"})
Local nPosQtSol:= aScan(aHeader,{|x| x[2]="CNB_QTDSOL"})
Local nPosQuant:= aScan(aHeader,{|x| x[2]="CNB_QUANT"})
Local nx

For nx:=1 to len(aPlani)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche campos do cabecalho                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNA")
	Reclock("CNA",.T.)
	For nCntFor := 1 To FCount()
		If (FieldName(nCntFor)=="CNA_FILIAL")
			CNA->CNA_FILIAL := xFilial()
		Else
			FieldPut(nCntFor,aPlani[nx,nCntFor])
		EndIf
	Next nCntFor
	MsUnlock()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa lancamento do PCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoDetLan("000354","01","CNTA200")
	
	dbSelectArea("CNB")
	nUsado := Len(aHeader)
	cFilCod := xFilial("CNB")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche campos dos itens                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCntFor := 1 To Len(aPlIt[nx])
		If ( !aPlIt[nx,nCntFor,nUsado+1] )
			dbSelectArea("CNB")
			Reclock("CNB",.T.)
			For nCntFor2 := 1 To nUsado
				If ( aHeader[nCntFor2][10] != "V" )
					FieldPut(FieldPos(aHeader[nCntFor2][2]),aPlIt[nx,nCntFor,nCntFor2])
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa lancamento PCO      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			PcoDetLan("000354","02","CNTA200")
			
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
					SC1->C1_FLAGGCT	:= "1" //Solicitacao bloqueada para SIGAGCT
					MsUnlock()
				EndIf
			EndIf
		EndIf
	Next
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400BxCauc³ Autor ³ Microsiga      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa baixa das caucoes de retencao do contrato           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400PlGr(lExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lExp01 -Informa se a rotina de baixa de caucao foi executada³±±
±±³          ³          pela visualizacao de contrato                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400BxCauc(lVisu)
Local oDlg
Local nVlEft    := 0
Local nVlReg    := 0
Local cPicture  := PesqPict("CNT","CNT_VLRET")
Local nOpca     := 0
Local lRet      := .T.
Local cTpTit    := PadR( GetNewPar( "MV_CNRETTC",  "NDF" ), Len( SE2->E2_TIPO ) )//Tipo do titulo - PADRAO: Nota de Debito ao Fornecedor
Local cNumTit   := ""
Local cBco      := Space(TamSX3("A6_COD")[1])//Banco
Local cAgc      := Space(TamSX3("A6_AGENCIA")[1])//Agencia
Local cCta      := Space(TamSX3("A6_CONTA")[1])//Conta
Local cRetNat   := PadR( GetNewPar( "MV_CNRETNA",  "" ), Len( SE2->E2_NATUREZ ) )//Natureza
Local cRetPrf   := PadR( GetNewPar( "MV_CNRETPR", "CRE" ), Len( SE2->E2_PREFIXO ) )//Prefixo
Local aNoFields := {"CNT_FILIAL","CNT_CONTRA","CNT_FORNEC","CNT_LJFORN"}
Local aHeader   := {}
Local aCols     := {}
Local nx        := 0
Local lBxPe     := .F.

If !CN240VldUsr(CN9->CN9_NUMERO,DEF_TRARET,.T.)
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida natureza informada no parametro MV_CNRETNA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( cRetNat )
	Aviso( STR0088, STR0089, { "OK" }, 2 )//"Atencao !"#"Configurar a natureza financeira do titulo de caucao atraves do parametro MV_CNRETNA."
	lRet := .F.
EndIf

SED->( dbSetOrder( 1 ) )

If lRet .And. !SED->( MsSeek( xFilial( "SED" ) + cRetNat ) )
	Aviso( STR0088, STR0090, { "OK" }, 2 ) // "Atencao !"#"A natureza definida pelo parametro MV_CNRETNA nao esta cadastrada."
	lRet := .F.
EndIf

If lRet
	DEFAULT lVisu := .F.
	
	PRIVATE lBxCNT   := .T.
	PRIVATE cFornCNT := Space(TamSX3("A2_COD")[1])
	PRIVATE cLojaCNT := Space(TamSX3("A2_LOJA")[1])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona campos para a baixa do contrato          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aHeader,{STR0139,FLD_BAIXA,PesqPict("CNT","CNT_VLRET"),15,2,"u_CS400Bx()","","N","","V"})	// Baixa
	aAdd(aHeader,{STR0140,FLD_SALDO,PesqPict("CNT","CNT_VLRET"),15,2,"","","N","","V"})				// Saldo
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	If dbSeek("CNT")
		Do While !Eof() .And. SX3->X3_ARQUIVO=="CNT"
			If ( X3USO(SX3->X3_USADO)) .And. cNivel >= SX3->X3_NIVEL .And. aScan(aNoFields, {|x| x == AllTrim(SX3->X3_CAMPO)}) == 0
				aAdd(aHeader,{AllTrim(X3Titulo()),;
				AllTrim(SX3->X3_CAMPO),;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT})
			EndIf
			dbSkip()
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a dialog de retencao          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0091) FROM 0,0 TO 300,590 OF oMainWnd PIXEL // "Baixa da Caução de Retenção"
	
	@ 10, 004 Say OemToAnsi(STR0095) Size 60,8 PIXEL//"Fornecedor"
	@ 09, 034 MsGet cFornCNT SIZE 25,8 F3 "CNC001" Valid If(!Empty(cFornCNT),u_CS400Cauc(CN9->CN9_NUMERO,cFornCNT,cLojaCNT,@nVlEft,oGetCNT),.T.) PIXEL
	
	@ 10, 075 Say OemToAnsi(STR0097) Size 60,8 PIXEL//"Loja"
	@ 09, 088 MsGet cLojaCNT SIZE 25,8 Valid If(!Empty(cLojaCNT),u_CS400Cauc(CN9->CN9_NUMERO,cFornCNT,cLojaCNT,@nVlEft,oGetCNT),.T.) PIXEL
	
	oGetCNT := MsNewGetDados():New(30,4,__DlgHeight(oDlg)-30,__DlgWidth(oDlg)-4,GD_UPDATE,,,,{FLD_BAIXA,"CNT_HIST"},,,,,,oDlg,aHeader,aCols)
	
	@ __DlgHeight(oDlg)-27,__DlgWidth(oDlg)-80  BUTTON STR0114 SIZE 35 ,13  FONT oDlg:oFont ACTION (If(!Empty(cFornCNT+cLojaCNT),(nOpca:=1,oDlg:End()),u_CS400Cauc(CN9->CN9_NUMERO,cFornCNT,cLojaCNT,@nVlEft,oGetCNT))) OF oDlg PIXEL//"Baixar"
	@ __DlgHeight(oDlg)-27,__DlgWidth(oDlg)-40  BUTTON STR0142 SIZE 35 ,13  FONT oDlg:oFont ACTION (nOpca:=0,oDlg:End()) OF oDlg PIXEL//"Sair"
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpca == 1

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula valor do resgate            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nVlReg:=0
		nPosBx:=aScan(oGetCNT:aHeader,{|x| AllTrim(x[2])==FLD_BAIXA})
		For nx:=1 to len(oGetCNT:aCols)
			nVlReg+=oGetCNT:aCols[nx,nPosBx]
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Validacao para nao permitir baixa com valor zerado  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If QtdComp(nVlReg) == QtdComp(0)
			Aviso(STR0088,STR0141,{"Ok"}) //"Não e possivel realizar a baixa de retenção com valor zerado !"
			Return
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa processamento da baixa         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa({|| IF((lRet:=CS400PrcBxRet(CN9->CN9_NUMERO,CN9->CN9_REVISA,cFornCNT,cLojaCNT,cBco,cAgc,cCta,nVlReg,cRetNat,cRetPrf,cTpTit,@cNumTit,oGetCNT:aCols,oGetCNT:aHeader,@lBxPe)) .And. lVisu,CS400AtuCNT(),)},,OemToAnsi(STR0103))//"Processando Baixa"
		
		If lRet	.And. !lBxPe
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe o resumo                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0104) FROM 9,0 TO 25,50 OF oMainWnd //"Resumo"
			@ 00,00 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 30, 120 NOBORDER WHEN .F. PIXEL
			DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
			@ 08,38 SAY OemToAnsi(STR0104) FONT oBold PIXEL//"Resumo"
			
			@ 24,30 TO 26 ,400 LABEL '' OF oDlg   PIXEL
			
			@ 31,38 SAY OemToAnsi(STR0105) PIXEL OF oDlg // "Prefixo"
			@ 41,38 SAY OemToAnsi(STR0106) PIXEL OF oDlg // "Numero do Titulo"
			@ 51,38 SAY OemToAnsi(STR0107) PIXEL OF oDlg // "Tipo"
			@ 61,38 SAY OemToAnsi(STR0108) PIXEL OF oDlg // "Valor"
			
			@ 31,110 SAY cRetPrf SIZE 80, 10 PIXEL   RIGHT
			@ 41,110 SAY cNumTit  SIZE 80, 10 PIXEL   RIGHT
			@ 51,110 SAY cTpTit   SIZE 80, 10 PIXEL   RIGHT
			@ 61,110 SAY Transform(nVlReg  ,PesqPict("SE2","E2_VALOR"))  SIZE 80, 10 PIXEL   RIGHT
			
			@ 90,030 TO 92 ,400 LABEL '' OF oDlg PIXEL
			
			DEFINE SBUTTON oBut FROM 101,162  TYPE 1 ACTION ( oDlg:End() ) ENABLE of oDlg
			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400AtuCNT³ Autor ³ Microsiga      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Carrega as retencoes do contrato                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400AtuCNT()                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400AtuCNT()
Local nCntFor   := 0
Local cCampo    := ""
Local aStrucCNT := {}
Local nX        := 0

aCols7 := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CNT - Retencao de Caucao                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNT")

cQuery := "SELECT CNT.* FROM "+ RetSQLName("CNT") +" CNT WHERE "
cQuery += "CNT.CNT_FILIAL = '"+xFilial("CNT")+"' AND "
cQuery += "CNT.CNT_CONTRA = '"+ M->CN9_NUMERO +"' AND "
cQuery += "CNT.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY CNT.CNT_FORNEC,CNT.CNT_LJFORN,CNT.CNT_DTMED"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CNTTMP",.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura campos especiais                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStrucCNT := CNT->(dbStruct())
For nx:=1 to len(aStrucCNT)
	if CNTTMP->(FieldPos(aStrucCNT[nx,1])) > 0 .And. aStrucCNT[nx,2] <> "C"
		TCSetField( "CNTTMP", aStrucCNT[nx,1], aStrucCNT[nx,2], aStrucCNT[nx,3], aStrucCNT[nx,4] )
	endif
Next

If !CNTTMP->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche o aCols                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !CNTTMP->(Eof())
		aAdd(aCols7,Array(Len(aHeader7)+1))
		For nCntFor	:= 1 To Len(aHeader7)
			cCampo := Alltrim(aHeader7[nCntFor,2])
			If ( aHeader7[nCntFor][10] != "V" )
				aCols7[Len(aCols7)][nCntFor] := CNTTMP->&(aHeader7[nCntFor][2])
			Else
				aCols7[Len(aCols7)][nCntFor] := CriaVar(aHeader7[nCntFor][2])
			EndIf
		Next nCntFor
		aCols7[Len(aCols7), Len(aHeader7)+1] := .F.
		
		CNTTMP->(dbSkip())
	EndDo
Else
	aAdd(aCols7,Array(Len(aHeader7)+1))
	For nX := 1 To Len(aHeader7)
		aCols7[1, nX] := CriaVar(aHeader7[nX, 2],.F.)
	Next nX
	aCols7[Len(aCols7), Len(aHeader7)+1] := .F.
EndIf

CNTTMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza a getdados com os valores da retencao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oGetDad7 != Nil
	oGetDad7:aCols := aCols7
	oGetDad7:oBrowse:Refresh()
	oGetDad7:Refresh()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Cauc³ Autor ³ Microsiga      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o fornecedor informado e calcula o valor retido       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Cauc(cExp01,cExp02,cEpx03,nExp04)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do contrato                                  ³±±
±±³          ³ cExp02 - Codigo do fornecedor                                ³±±
±±³          ³ cExp03 - Codigo da loja                                      ³±±
±±³          ³ nExp04 - Valor efetivo - referencia                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CS400Cauc(cContra,cForn,cLoja,nVlEft,oGetCNT)
Local cQuery    := ""
Local lRet      := .T.
Local aArea     := GetArea()
Local cAlias    := GetNextAlias()
Local nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida o fornecedor                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := ExistCpo("SA2",cForn+If(Empty(cLoja),"",cLoja))

oGetCNT:aCols := {}

If lRet .And. !Empty(cForn) .And. !Empty(cLoja)
	
	cQuery := "SELECT CNT.*,(CNT.CNT_VLRET-CNT.CNT_VLBX) AS CNT_SALDO FROM "+RetSQLName("CNT")+" CNT WHERE "
	cQuery += "CNT.CNT_FILIAL = '"+xFilial("CNT")+"' AND "
	cQuery += "CNT.CNT_CONTRA = '"+cContra+"' AND "
	cQuery += "CNT.CNT_FORNEC = '"+cForn+"' AND "
	cQuery += "CNT.CNT_LJFORN = '"+cLoja+"' AND "
	cQuery += "CNT.CNT_VLRET > CNT.CNT_VLBX AND "
	cQuery += "CNT.D_E_L_E_T_ = ' '
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
	
	aStrucCNT := CNT->(dbStruct())
	For nx:=1 to len(aStrucCNT)
		if (cAlias)->(FieldPos(aStrucCNT[nx,1])) > 0 .And. aStrucCNT[nx,2] <> "C"
			TCSetField( cAlias, aStrucCNT[nx,1], aStrucCNT[nx,2], aStrucCNT[nx,3], aStrucCNT[nx,4] )
		endif
	Next
	
	TCSetField(cAlias,"CNT_SALDO" ,"N",TamSX3("CNT_VLRET")[1],TamSX3("CNT_VLRET")[1])
	
	If (cAlias)->(Eof())
		lRet := .F.
		Aviso( STR0089, STR0109, {"OK"})//"O fornecedor selecionado não possui valor retido em caução!"
	Else
		
		While !(cAlias)->(Eof())
			
			aAdd(oGetCNT:aCols,Array(Len(oGetCNT:aHeader)+1))
			
			For nx	:= 1 To Len(oGetCNT:aHeader)
				cCampo := Alltrim(oGetCNT:aHeader[nx,2])
				
				If ( oGetCNT:aHeader[nx][10] != "V" )
					oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := (cAlias)->( FieldGet( (cAlias)->( FieldPos(oGetCNT:aHeader[nx][2]) ) ) )
				Else
					Do Case
						Case oGetCNT:aHeader[nx][2] == FLD_SALDO
							oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := (cAlias)->CNT_SALDO
						Case oGetCNT:aHeader[nx][2] == FLD_BAIXA
							oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := 0
						OtherWise
							oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := CriaVar(oGetCNT:aHeader[nx][2])
					EndCase
				EndIf
			Next nX
			oGetCNT:aCols[Len(oGetCNT:aCols), Len(oGetCNT:aHeader)+1] := .F.
			
			(cAlias)->( dbSkip() )
		EndDo
		
	EndIf
EndIf

if len(oGetCNT:aCols) == 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria linha em branco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aAdd(oGetCNT:aCols,Array(Len(oGetCNT:aHeader)+1))
	For nx:=1 To Len(oGetCNT:aHeader)
		cCampo := Alltrim(oGetCNT:aHeader[nx,2])
		
		Do Case
			Case oGetCNT:aHeader[nx][2] == FLD_SALDO
				oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := 0
			Case oGetCNT:aHeader[nx][2] == FLD_BAIXA
				oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := 0
			OtherWise
				oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := CriaVar(oGetCNT:aHeader[nx][2])
		EndCase
	Next
	
	oGetCNT:aCols[Len(oGetCNT:aCols), Len(oGetCNT:aHeader)+1] := .F.
EndIf

oGetCNT:Refresh()

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Cauc³ Autor ³ Microsiga      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera o titulo a pagar para o valor retido do contrato        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Cauc(cExp01,cExp02,cEpx03,cExp04,cExp05,nExp06,cExp07³±±
±±³          ³              ,cExp08,cExp09,cExp10)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Fornecedor                                          ³±±
±±³          ³ cExp02 - Loja do fornecedor                                  ³±±
±±³          ³ cExp03 - Codigo do banco                                     ³±±
±±³          ³ cExp04 - Agencia                                             ³±±
±±³          ³ cExp05 - Conta                                               ³±±
±±³          ³ nExp06 - Valor do titulo                                     ³±±
±±³          ³ cExp07 - Natureza do titulo                                  ³±±
±±³          ³ cExp08 - Prefixo do titulo                                   ³±±
±±³          ³ cExp09 - Tipo do titulo                                      ³±±
±±³          ³ cExp10 - Numero do titulo - referencia                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CS400GerSE2(cForn,cLoja,cBco,cAgc,cCta,nVlRet,cRetNat,cRetPrf,cTpTit,cNumTit)
Local aRotAuto := {}
Local cQuery   := ""
Local cMaxTit  := ""
Local aArea    := GetArea()
Local cParcela := ""
Local cMoeda   := ""
Local aAreaSub
Local nx
Local lRet     := .T.
Local aAfrBck  := {}
Local lExcPms  := IntePMS() .And. (GetNewPar( "MV_CNEXPMS", "N" ) == "S")
Local cFilSE2  := xFilial("SE2")
Local lMoeda   := !Empty( CN9->( FieldPos( "CN9_MOEDA" ) ) )

PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona sequencia dos titulos a pagar    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "Select MAX(SE2.E2_NUM) as E2_NUM from "+ RetSQLName("SE2") +" SE2 "
cQuery += "where SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
cQuery += "SE2.E2_PREFIXO = '"+ cRetPrf +"' AND "
cQuery += "SE2.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE2TMP",.F.,.T.)

cNumTit := Soma1(SE2TMP->E2_NUM)

cParcela := CriaVar("E2_PARCELA")

If lMoeda
	cMoeda   := CN9->CN9_MOEDA
Else
	cMoeda   := CriaVar("E2_MOEDA")
EndIf

SE2TMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe integracao com o PMS    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lExcPms
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Simula chamada do FINA050  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aRatAfr := {}
	Private lF050Auto := .T.
	Private M->E2_VALOR := nVlRet
	Private M->E2_MOEDA := cMoeda
	Private M->E2_EMISSAO := dDataBase
	Private M->E2_MDCONTR := CN9->CN9_NUMERO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa Dialog para preenchimento do projeto  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaSub := GetArea()
	PmsDlgFS(3,cRetPrf,cNumTit,cParcela,cTpTit,cForn,cLoja)
	RestArea(aAreaSub)
	aAfrBck  := aRatAfr
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validacao do rateio do projeto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CNTVLDPMS")
	lRet := ExecBlock("CNTVLDPMS",.F.,.F.,{nVlRet})
EndIf

If lRet
	dbSelectArea("SE2")
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica numeracao disponivel para o SE2   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While dbSeek(cFilSE2+cRetPrf+cNumTit)
		cNumTit := Soma1(cNumTit)
	EndDo
	
	BEGIN TRANSACTION
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera nota de debito ao fornecedor          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd( aRotAuto, { "E2_NUM"    , cNumTit, NIL } )
	AAdd( aRotAuto, { "E2_PREFIXO", cRetPrf, NIL } )
	AAdd( aRotAuto, { "E2_NATUREZ", cRetNat, NIL } )
	AAdd( aRotAuto, { "E2_PARCELA", cParcela, NIL } )
	AAdd( aRotAuto, { "E2_TIPO"   , cTpTit, NIL } )
	AAdd( aRotAuto, { "E2_FORNECE", cForn, NIL } )
	AAdd( aRotAuto, { "E2_LOJA"   , cLoja, NIL } )
	AAdd( aRotAuto, { "E2_VALOR"  , nVlRet, NIL } )
	AAdd( aRotAuto, { "E2_EMISSAO", dDataBase, NIL } )
	AAdd( aRotAuto, { "E2_VENCTO" , dDataBase, NIL } )
	AAdd( aRotAuto, { "E2_VENCREA", DataValida( dDataBase ), NIL } )
	AADD( aRotAuto, { "E2_VENCORI", DataValida( Ddatabase,.T.),NIL })
	AADD( aRotAuto, { "E2_MOEDA"  , cMoeda, NIL})
	AADD( aRotAuto, { "E2_MDCONTR", CN9->CN9_NUMERO, NIL})
	AADD( aRotAuto, { "E2_MDREVIS", CN9->CN9_REVISA, NIL})
	AAdd( aRotAuto, { "AUTBANCO"  , cBco, NIL } )
	AAdd( aRotAuto, { "AUTAGENCIA", cAgc, NIL } )
	AAdd( aRotAuto, { "AUTCONTA"  , cCta, NIL } )
	
	MSExecAuto({|x, y| FINA050(x, y)}, aRotAuto, 3)
	
	If !lMsErroAuto
		aRatAfr := aAfrBck
		If !Empty(aRatAfr)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava informacao de despesa do projeto  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PmsWriteFI(1,"SE2")
			aRatAfr := {}
		EndIf
	EndIf
	END TRANSACTION
	
	If lMsErroAuto
		MOSTRAERRO()
		lRet := .F.
	EndIf
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400BxRet  ³ Autor ³ Microsiga      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa baixa das retencoes do contrato                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400BxRet(nExp01,cExp02,cEpx03,cExp04)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Valor a ser resgatado                               ³±±
±±³          ³ cExp02 - Codigo do contrato                                  ³±±
±±³          ³ cExp03 - Codigo do fornecedor                                ³±±
±±³          ³ cExp04 - Loja do fornecedor                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400BxRet(aCols,aHeader,cContra,cForn,cLoja)
Local nx        := 0
Local ny        := 0
Local nPosBx    := aScan(aHeader,{|x| AllTrim(x[2])==FLD_BAIXA})
Local nPosMed   := aScan(aHeader,{|x| AllTrim(x[2])=="CNT_NUMMED"})

dbSelectArea("CNT")
dbSetOrder(1)

For nx:=1 to len(aCols)
	
	If dbSeek(xFilial("CNT")+cContra+aCols[nx,nPosMed])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza a baixa                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("CNT",.F.)

		If	aCols[nx,nPosBx] > 0
			CNT->CNT_DTBX := dDataBase
		EndIf
		CNT->CNT_VLBX += aCols[nx,nPosBx]
		For ny:=1 to len(aHeader)
			If !(aHeader[ny,2] $ "BAIXA|SALDO|CNT_VLBX|CNT_VLRET|CNT_DTBX")
				CNT->&(aHeader[ny,2]) := aCols[nx,ny]
			EndIf
		Next
		
		MsUnlock()
	EndIf
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400PrcBxRet³ Autor ³ Microsiga      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa o processamento da baixa de retencao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400PrcBxRet(cExp01,cExp02,cEpx03,cExp04,cExp05,cExp06,cExp07³±±
±±³          ³               nExp08,cExp09,cEpx10,cExp11,cExp12)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do contrato                                   ³±±
±±³          ³ cExp02 - Codigo da revisao                                    ³±±
±±³          ³ cExp03 - Codigo do fornecedor                                 ³±±
±±³          ³ cExp04 - Loja do fornecedor                                   ³±±
±±³          ³ cExp05 - Codigo do banco                                      ³±±
±±³          ³ cExp06 - Codigo da agencia                                    ³±±
±±³          ³ cExp07 - Codigo da conta                                      ³±±
±±³          ³ cExp08 - Valor do resgate                                     ³±±
±±³          ³ cExp09 - Natureza do titulo                                   ³±±
±±³          ³ cExp10 - Prefixo do titulo                                    ³±±
±±³          ³ cExp11 - Tipo do titulo                                       ³±±
±±³          ³ cExp12 - Numero do titulo - referencia                        ³±±
±±³          ³ lExp13 - Informa se existe ponto de entrada para baixa - refer³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400PrcBxRet(cContra,cRevisa,cForn,cLoja,cBco,cAgc,cCta,nVlReg,cRetNat,cRetPrf,cTpTit,cNumTit,aCols,aHeader,lBxPe)
Local lRet  := .F.

lBxPe := ExistBlock("CS400BxRet")

ProcRegua(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe ponto de entrada para baixa da retencao ³
//³ Tratamento especifico para Galvao, para geracao das DAPs   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IncProc()
If lBxPe
	lRet := ExecBlock("CS400BxRet",.F.,.F.,{cForn,cLoja,nVlReg,aCols,aHeader})
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera o titulo                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := CS400GerSE2(cForn,cLoja,cBco,cAgc,cCta,nVlReg,cRetNat,cRetPrf,cTpTit,@cNumTit)
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a baixa das retencoes                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS400BxRet(aCols,aHeader,CN9->CN9_NUMERO,cForn,cLoja)
	IncProc()
	
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400CtrRet  ³ Autor ³ Microsiga      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa a baixa dos valores retidos atraves do browse de      ³±±
±±³          ³ contrato                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400CtrRet()                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400CtrRet()

If CN9->CN9_FLGCAU == "1" .And. CN9->CN9_TPCAUC == "2"
	CS400BxCauc(.F.)
Else
	Aviso(STR0089,STR0112,{"OK"})//"O contrato selecionado não possui caução de retenção."
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
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
PRIVATE aRotina	:= { 	{ OemToAnsi(STR0002), "AxPesqui"	   	, 0, 1, 0, .F.},;	//"Pesquisar"
						{ OemToAnsi(STR0003), "u_CS400Manut"			, 0, 2, 0, Nil},;	//"Visualizar"
						{ OemToAnsi(STR0007), "u_CS400Manut"			, 0, 3, 0, Nil},;	//"Incluir"
						{ OemToAnsi(STR0004), "u_CS400Manut"			, 0, 4, 0, Nil},;	//"Atualizar"
						{ OemToAnsi(STR0006), "u_CS400Manut"			, 0, 5, 0, Nil},;	//"Excluir"
						{ OemToAnsi(STR0030), "CS400Situac"				, 0, 6, 0, Nil},;	//"Situacao"
						{ OemToAnsi(STR0013), "CS400Legenda"			, 0, 7, 0, .F.},; 	//"Legenda"
						{ OemToAnsi(STR0082), "CN220Aval"   			, 0, 8, 0, Nil},; 	//"Avaliação"
						{ OemToAnsi(STR0085), "CN240Acesso"   		 	, 0, 8, 0, Nil},; 	//"Acesso"
						{ OemToAnsi(STR0055), "MsDocument"     		, 0, 4, 0, Nil}}  	//"Conhecimento"

If CN9->( FieldPos("CN9_TPCAUC") ) > 0
	aAdd(aRotina,{ OemToAnsi(STR0114), "CS400CtrRet"     , 0, 4, 0, Nil})//"Bx. Retenção"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTA100MNU")
	ExecBlock("CTA100MNU",.F.,.F.)
EndIf
Return(aRotina)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CS400Bx³ Autor ³ Microsiga      ³ Data ³05/03/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida o valor informado na baixa das caucoes de retencao  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CS400Bx()
Local lRet    := .T.
Local aCols   := o:OMOTHER:ACOLS
Local aHeader := o:OMOTHER:aHeader
Local nAt     := o:nAt
Local nPosBx  := aScan(aHeader,{|x| x[2]==FLD_BAIXA})
Local nPosSld := aScan(aHeader,{|x| x[2]==FLD_SALDO})
Local nPosVl  := aScan(aHeader,{|x| x[2]=="CNT_VLRET"})
Local nPosVlb := aScan(aHeader,{|x| x[2]=="CNT_VLBX"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o valor informado na baixa, e inferior ao saldo da retencao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := (M->BAIXA <= (aCols[nAt,nPosVl]-aCols[nAt,nPosVlb]))

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza saldo     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[nAt,nPosSld] := (aCols[nAt,nPosVl]-aCols[nAt,nPosVlb])-M->BAIXA
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza objeto    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
o:Refresh()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400Contab³ Autor ³ Microsiga      ³ Data ³17.04.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Contabiliza a emissao do contrato                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS400Contab()                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400Contab()

LOCAL aArea     := GetArea()

LOCAL cPadrao   := "694"
LOCAL cLoteCtb  := ""

LOCAL lDigita   := If(MV_PAR02==1,.T.,.F.)
LOCAL lPadrao   := .F.

LOCAL nHdlPrv   := 0
LOCAL nTotal    := 0

Private cArquivo := " "

dbSelectArea("CN9")
dbSetOrder(1)

lPadrao := VerPadrao(cPadrao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Lancamento Contabil³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lPadrao .and. MV_PAR01 == 1 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o numero do lote contabil                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSetOrder(1)
	If MsSeek(xFilial()+"09GCT")
		cLoteCtb := AllTrim(X5Descri())
	Else
		cLoteCtb := "GCT "
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa o execblock                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At(UPPER("EXEC"),X5Descri()) > 0
		cLoteCtb := &(X5Descri())
	EndIf
	
	nHdlPrv := HeadProva(cLoteCtb,"CNTA100",Substr(cUsuario,7,6),@cArquivo)
	nTotal  += DetProva(nHdlPrv,cPadrao,"CNTA100",cLoteCtb)
	RodaProva(nHdlPrv,nTotal)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia para Lancamento Contabil³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cA100Incl(cArquivo,nHdlPrv,3,cLoteCtb,lDigita,.F.)
EndIf

RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³AjustaSX1  ³ Autor ³ Microsiga      ³ Data ³17.04.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Configura as perguntas da rotina de contrato                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AjustaSX1()                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()
Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local cPerg	   := "CNT100"

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {"Contabiliza o contrato?"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"01","Contabiliza ?","¨Contabiliza ?","Account for ?","mv_ch1","N",1,0,1,"C","","","","N","mv_par01","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor := {"Exibe contabilização do contrato?"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"02","Mostra Lanc Contab ?","¨Mostra Asiento Contab ?","Show Accounting Entries ?","mv_ch2","N",1,0,1,"C","","","","N","mv_par02","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor := {"Informa se aglutina os lançamentos contábeis?"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"03","Aglut Lancamentos ?","¨Aglut Asientos ?","Group Entries ?","mv_ch3","N",1,0,1,"C","","","","N","mv_par03","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aAreaAnt)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS400EnVl  ³ Autor ³ Microsiga      ³ Data ³26.04.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Trata campo do valor                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS400EnVl()
Local lRet := .F.

If !Empty(M->CN9_TPCTO) .And. (CN1->(FieldPos("CN1_CTRFIX")) > 0)
	dbSelectArea("CN1")
	dbSetOrder(1)
	
	If dbSeek(xFilial("CN1")+M->CN9_TPCTO)
		lRet := (CN1->CN1_CTRFIX == "2" .And. CN1->CN1_VLRPRV == "1")
	EndIf
EndIf

Return lRet
