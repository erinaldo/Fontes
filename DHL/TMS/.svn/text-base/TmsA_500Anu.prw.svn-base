#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TmsA500Anu ³ Autor ³ N3-DL                ³ Data ³ 16/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Anulacao                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TmsA500Anu()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSA500                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TmsA_500Anu()
Local aAreaAnt   := GetArea()
Local aAreaDTQ   := DTQ->(GetArea())
Local aAreaDUD   := DUD->(GetArea())
Local aAreaDT6   := DT6->(GetArea())
Local lHelp      := .F.
Local aCab       := {}
Local aItens     := {}
Local aItem      := {}
Local cItem      := "1"
Local cNumNF     := Space(Len(SF1->F1_DOC))
Local cSerieNF   := Space(Len(SF1->F1_SERIE))
Local lContrib   := .F.
Local cEspecie   := ""
Local cInscr     := ""
Local cContrib   := ""
Local cAliasSD2  := ""
Local nOpcAnul   := 0
Local nSldDev    := 0
Local nCntFor    := 0
Local dDatFech   := MVUlmes()
Local dDatFTMS   := GetMv("MV_DATATMS",.F.,CtoD(''))
Local dDatFFIN   := GetMV("MV_DATAFIN",.F.,CtoD(''))
Local lTMSCTe    := SuperGetMv( "MV_TMSCTE", .F., .F. )
Local cTipoNF    := SuperGetMV("MV_TPNRNFS") 
Local cTESAnula  := SuperGetMv("MV_TESANUL",,"")
Local cMv_Estado := SuperGetMV("MV_ESTADO",.F.,"")
Local lDUISEROUT := DUI->(FieldPos("DUI_SEROUT")) > 0 //TMS11R145 - Serie Outra UF
Local CDOCTMS    := "M"
Local oDlgAnul
//Local lMsErroAuto:= .F.

dbSelectArea("SF2")
dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
MsSeek(DT6->(DT6_FILORI+DT6_DOC+DT6_SERIE))

Private cSerie	:= ''

If lTMSCTe .And. DT6->DT6_IDRCTE <> '100'
	DTP->(DbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
	If	DTP->(MsSeek(xFilial('DTP')+DT6->DT6_FILORI+DT6->DT6_LOTNFC))
		If DTP->DTP_TIPLOT == '3'
			Help( " ", 1, "TMSA50100")	// "Doc Original ainda nao esta autorizado.
			Return( .F. )
		EndIf
	EndIf
EndIf

//-- Verifica a data de execucao
If GetNewPar("MV_NFCHGDT",.F.) //-- Informa se a data base do sistema deve ser alterada, se a data do sistema operacional for alterada, na preparacao do documento de saida.
	If MsDate()==dDataBase+1
		If MsgYesNo("O sistema identificou a troca da data do sistema operacional, deseja atualizar a data base do sistema?",OemToAnsi("Atencao !")) //"O sistema identificou a troca da data do sistema operacional, deseja atualizar a data base do sistema?"###"Atencao !"
			dDataBase := MsDate()
		EndIf
	EndIf
EndIf
If dDataBase <= dDatFech
	Help ( " ", 1, "FECHTO" ) //"Nao pode ser digitado movimento com data anterior a ultima data de fechamento (virada de saldos)"
	Return( .F. )
EndIf
If !Empty(dDatFTMS)
	If dDataBase <= dDatFTMS
		Help ( " ", 1, "FECHATMS" )
		Return( .F. )
	EndIf
EndIf
If !Empty(dDatFFIN)
	If dDataBase <= dDatFFIN
		Help ( " ", 1, "DTMOVFIN" )
		Return( .F. )
	EndIf
EndIf
If !Empty(GetMV("MV_DATAFIS",,""))
	If !FisChkDt(dDataBase)
		Return( .F. )
	EndIf
EndIf

If	DT6->DT6_STATUS <> StrZero(7, Len(DT6->DT6_STATUS) )
	Help( " ", 1, 'TMSA50094') //-- A anulação é permitida somente para documentos entregues.
	Return
Else
	//--Verifica a situacao atual do documento da viagem
	cAliasQry := GetNextAlias()
	cQuery := " SELECT MAX(R_E_C_N_O_) DUDRecNo"
	cQuery += " FROM " + RetSqlTab("DUD")
	cQuery += " WHERE DUD.DUD_FILIAL = '" + xFilial("DUD")  + "'"
	cQuery += "   AND DUD.DUD_FILDOC = '" + DT6->DT6_FILDOC + "'"
	cQuery += "   AND DUD.DUD_DOC    = '" + DT6->DT6_DOC    + "'"
	cQuery += "   AND DUD.DUD_SERIE  = '" + DT6->DT6_SERIE  + "'"
	cQuery += "   AND DUD.D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliasQry, .F., .T. )
	DUD->( DbGoTo( (cAliasQry)->DUDRecNo ) )
	(cAliasQry)->( DbCloseArea() )
EndIf

If DT6->DT6_DOCTMS == Replicate('M', Len( DT6->DT6_DOCTMS ) ) // CTRC Anulacao
	Help( " ", 1, "TMSA50097")	// "Este documento é de anulação, portanto não é possível gerar outro documento de anulação."
	Return
EndIf

If DT6->DT6_FILDOC != cFilAnt
	Help( " ", 1, "TMSA50095")	// "Anulacao permitida somente na filial de origem."
	Return
EndIf

If Empty(cTESAnula)
	Help( " ", 1, "TMSA50098") // "O Parametro MV_TESANUL nao esta preenchido.
	Return
Else
	DbSelectArea("SF4")
	DbSetOrder(1)
	If !SF4->(DbSeek(xFilial("SF4")+cTESAnula)) .Or. SF4->F4_TIPO != "E"
		Help( " ", 1, "TMSA50099") // "Não existe este código na tabela de TES ou a TES informada no parametro MV_TESANUL, não é do tipo Entrada"
		Return
	EndIf
EndIf

//-- Se escolheu documento do primeiro percurso, sempre o documento FOB( ou 2o percurso ) sera devolvido
If	DT6->DT6_PRIPER == StrZero(1,Len(DT6->DT6_PRIPER))
	DTC->(DbSetOrder(4))
	DTC->(MsSeek(xFilial('DTC') + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE))
	DT6->(MsSeek(xFilial('DT6') + DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE))
EndIf

aAreaDT6 := DT6->(GetArea())
DT6->(dbSetOrder(8))
If	DT6->(MsSeek(cSeek := xFilial("DT6") + DT6_FILDOC + DT6_DOC + DT6_SERIE))
	While DT6->(!Eof() .And. DT6_FILIAL + DT6_FILDCO + DT6_DOCDCO + DT6_SERDCO == cSeek)
		If DT6->DT6_DOCTMS == cDocTMS
			lHelp := .T.
			Exit
		EndIf
		DT6->(dbSkip())
	EndDo
EndIf
RestArea(aAreaDT6)
If lHelp
	Help(" ",1,"TMSA50019") // "Ja existe uma devolucao OU UMA ANULACAO para esse documento"
	Return
EndIf

//-- Verifica se cliente e contribuinte do ICMS
cInscr   := Posicione("SA1", 1, xFilial("SA1") + DT6->DT6_CLIDEV + DT6->DT6_LOJDEV,"A1_INSCR")
cContrib := Posicione("SA1", 1, xFilial("SA1") + DT6->DT6_CLIDEV + DT6->DT6_LOJDEV,"A1_CONTRIB")
If	Alltrim(cContrib) == "2" .Or. Empty(cInscr) .Or. Alltrim(Upper(cInscr)) $ "ISENT" .Or. ;
	Alltrim(Upper(cInscr)) $ "RG"
	lContrib := .F.
Else
	lContrib := .T.
EndIf
// ------------------------------------------------------------------------------------------------ //
// Ponto de entrada: TM500CON - Alterar tratamento para Cliente contribuinte / não contribuinte.    //
// Criado ponto de entrada TM500CON na rotina de Manutenção de Documentos / Anulação (TMSA500) para // 
// definir geração documento de devolução para clientes contribuintes do ICMS com formulário próprio//
// similar ao gerado para clientes não contribuinte do ICMS.                                        //
// Este ponto de entrada altera funcionalidade definida através do convenio SINIEF 02/08.           //
// Lógico (default .F.), onde.F. para geração de documento de devolução com formulário próprio.     //
// ------------------------------------------------------------------------------------------------ //
If lTm500CON
	lContrib := ExecBlock("TM500CON",.F.,.F.)
	If ValType(lContrib) <> "L"
		lContrib := .F.
	EndIf
EndIf

//-- Posiciona configuracao de documentos para obter a Serie do Documento de Anulacao.
DUI->(DbSetOrder(1))
If	DUI->(!MsSeek( xFilial("DUI") + "M", .F.))
	Help(" ", 1, "TMSA50006",,'Documento: ' + "M",4,1) //-- Documento nao encontrado na configuracao de documentos. (DUI) //'Documento: '
	Return
EndIf

//-- Verifica se informou serie para origem em outra filial.
If	lDUISEROUT .And. !Empty(DUI->DUI_SEROUT)
	If DUY->(MsSeek(xFilial("DUY")+DT6->DT6_CDRORI))
		If	cMv_Estado <> DUY->DUY_EST
			cSerie := DUI->DUI_SEROUT
		EndIf
	EndIf
EndIf

cSerie := DUI->DUI_SERIE
_cObsComp := ''
//-- Caso Cliente devedor nao seja contribuinte do ICMS e Esteja gerando documento de anulacao gera NF de entrada
/*
DEFINE MSDIALOG oDlgAnul TITLE OemToAnsi("NF de Anulação") FROM 0,0 TO 330,270 OF oDlgAnul PIXEL //"NF de Anulação"

	@ 06, 06 TO 46,130 LABEL OemToAnsi("Informe o Número e Série da NF do cliente.") OF oDlgAnul PIXEL //"Informe o Número e Série da NF do cliente."

	@ 20, 15 SAY OemToAnSi("Número da NF") SIZE 45,8 PIXEL OF oDlgAnul //"Número da NF"
	@ 30, 15 MSGET cNumNF	PICTURE PesqPict("SF1","F1_DOC")	WHEN lContrib SIZE 45,10 PIXEL OF oDlgAnul

	@ 20, 85 SAY OemToAnsi("Série da NF") SIZE 45,8 PIXEL OF oDlgAnul //"Série da NF"
	@ 30, 85 MSGET cSerieNF	PICTURE PesqPict("SF1","F1_SERIE")	WHEN lContrib SIZE 20,10 PIXEL OF oDlgAnul

	@ 50, 06 SAY OemToAnsi("Motivo") SIZE 45,8 PIXEL OF oDlgAnul //"Motivo"
	@ 60, 06 GET oGet VAR _cObsComp MEMO SIZE 125,40 VALID !Empty(_cObsComp) PIXEL OF oDlgAnul

	DEFINE SBUTTON FROM 152,  70 TYPE 1 ACTION {||nOpcAnul := 1, If((!Empty(cNumNF) .And. !Empty(cSerieNF) .Or. !lContrib),oDlgAnul:End(),MsgAlert(OemToAnsi("Preencha os campos Número e Série")))} ENABLE OF oDlgAnul //"Preencha os campos Número e Série"
	DEFINE SBUTTON FROM 152, 100 TYPE 2 ACTION {||nOpcAnul := 0, oDlgAnul:End()} ENABLE OF oDlgAnul
ACTIVATE MSDIALOG oDlgAnul CENTER
*/
_cObsComp := "Devolucao conforme docmento e serie "+ DT6->DT6_DOC + " - " + DT6->DT6_SERIE
nOpcAnul  := 1

If nOpcAnul == 1
	cEspecie := A460Especie(cSerie)
	If lContrib
		cSerie := cSerieNF
	Else
		If !Empty(aDocAnul[1])
			cNumNF   := aDocAnul[1]
		Else
			cNumNF   := NxtSX5Nota(DT6->DT6_SERIE,.T.,cTipoNF)
		EndIf
	EndIf
	Begin Transaction
		RecLock('DT6',.F.)
		DT6->DT6_STATUS := StrZero(9,Len(DT6->DT6_STATUS)) // Anulacao
		MsUnLock()
		//-- Execauto MATA103 NF de Devolucao -
		AAdd( aCab, { "F1_DOC"    , cNumNF		 						, Nil } ) // Numero da NF         : Obrigatorio
		AAdd( aCab, { "F1_SERIE"  , cSerie		 						, Nil } ) // Serie da NF          : Obrigatorio
		AAdd( aCab, { "F1_TIPO"   , "D"			 						, Nil } ) // Tipo da NF           : Obrigatorio
		AAdd( aCab, { "F1_FORNECE", DT6->DT6_CLIDEV						, Nil } ) // Codigo do Fornecedor : Obrigatorio
		AAdd( aCab, { "F1_LOJA"   , DT6->DT6_LOJDEV		 				, Nil } ) // Loja do Fornecedor   : Obrigatorio
		AAdd( aCab, { "F1_EMISSAO", dDataBase			 				, Nil } ) // Emissao da NF        : Obrigatorio
		AAdd( aCab, { "F1_FORMUL" , If(lContrib,"N","S")				, Nil } ) // Formulario
		AAdd( aCab, { "F1_ESPECIE", cEspecie							, Nil } ) // Especie
		AAdd( aCab, { "F1_MENNOTA", _cObsComp							, Nil } ) // Mensagem para nota
		AAdd( aCab, { "F1_TPCTE"  , "A"									, Nil } ) // Tipo CTE - A = Anulacao
		AAdd( aCab, { "F1_NFORIG" , DT6->DT6_DOC    					, Nil } ) // NF de Origem
		AAdd( aCab, { "F1_SERORIG", DT6->DT6_SERIE  					, Nil } ) // Serie de Origem
		//-- Monta itens da nota de devolucao.
		SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		aStruSD2  := SD2->(dbStruct())
		cAliasSD2 := GetNextAlias()
		cQuery := "SELECT SD2.*,SD2.R_E_C_N_O_  SD2RECNO "
		cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
		cQuery += "WHERE "
		cQuery += "SD2.D2_FILIAL  = '" + SF2->F2_FILIAL  + "' AND "
		cQuery += "SD2.D2_DOC     = '" + SF2->F2_DOC     + "' AND "
		cQuery += "SD2.D2_SERIE   = '" + SF2->F2_SERIE   + "' AND "
		cQuery += "SD2.D2_CLIENTE = '" + SF2->F2_CLIENTE + "' AND "
		cQuery += "SD2.D2_LOJA    = '" + SF2->F2_LOJA    + "' AND "
		cQuery += "SD2.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
		For nCntFor := 1 To Len(aStruSD2)
			If aStruSD2[nCntFor][2]<>"C"
				TcSetField(cAliasSD2,aStruSD2[nCntFor][1],aStruSD2[nCntFor][2],aStruSD2[nCntFor][3],aStruSD2[nCntFor][4])
			EndIf
		Next nCntFor
		While (cAliasSD2)->(!EOF())
			nSldDev := (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
			AAdd( aItens, { "D1_ITEM"   , StrZero(Val(cItem),Len(SD1->D1_ITEM))					, Nil } ) // Item
			AAdd( aItens, { "D1_COD"    , (cAliasSD2)->D2_COD										, Nil } ) // Codigo do Produto
			AAdd( aItens, { "D1_VUNIT"  , (cAliasSD2)->D2_PRCVEN									, Nil } ) // Valor Unitario
			AAdd( aItens, { "D1_QUANT"  , nSldDev													, Nil } ) // Quantidade
			If (cAliasSD2)->D2_QTDEDEV == 0
				AAdd( aItens, { "D1_TOTAL"  , (cAliasSD2)->D2_TOTAL  + (cAliasSD2)->D2_DESCON + (cAliasSD2)->D2_DESCZFR		, Nil } ) // Valor Total
				AAdd( aItens, { "D1_VALDESC", (cAliasSD2)->D2_DESCON + (cAliasSD2)->D2_DESCZFR		, Nil } ) // Desconto
			Else
				AAdd( aItens, { "D1_TOTAL"  , A410Arred(nSldDev*(cAliasSD2)->D2_PRCVEN,"D1_TOTAL")	, Nil } ) // Valor Total
				AAdd( aItens, { "D1_VALDESC", A410Arred((cAliasSD2)->D2_DESCON/(cAliasSD2)->D2_QUANT*nSldDev,"D1_VALDESC")	, Nil } ) // Desconto
			EndIf
			AAdd( aItens, { "D1_TES"    , cTESAnula													, Nil } ) // TES
			AAdd( aItens, { "D1_NFORI"  , (cAliasSD2)->D2_DOC	   									, Nil } ) // NF de Origem
			AAdd( aItens, { "D1_SERIORI", (cAliasSD2)->D2_SERIE  				 					, Nil } ) // Serie de Origem
			AAdd( aItens, { "D1_ITEMORI", StrZero(Val((cAliasSD2)->D2_ITEM),Len(SD2->D2_ITEM))	, Nil } ) // Item Origem
			AAdd( aItem, aItens )
			cItem := Soma1(cItem)
			aItens := {}
			(cAliasSD2)->(DbSkip())
		EndDo
		(cAliasSD2)->(dbCloseArea())
		//-- Início de transação
		//-- Modificado o local do inicio da transação pois ocorria um erro de 
		//-- dupla abertura de transação.
		aLogAutoANU		:= {}
		lMsHelpAuto 		:= .T.
		lAutoErrNoFile 	:= .T.
		
		If Len(aItem) > 0
			//MsgRun( "Gerando NF de Anulação", "Aguarde...", {|| MsExecAuto({|w,x,y,z|Mata103(w,x,y,z)},aCab,aItem,3,.F.) }) //"Gerando NF de Anulação" ### "Aguarde..."
			MsExecAuto({|w,x,y,z|Mata103(w,x,y,z)},aCab,aItem,3,.F.)
		EndIf
		If lMsErroAuto
			aLogAutoANU := GetAutoGRLog()
			lMsErroAuto := .F.
			DisarmTransaction()

//			MostraErro()
//			AutoGrLog("DTMSA004"+":: Ocorreram erros no Processamento - Empresa/Filial: "+cEmpAnt+"/"+cFilAnt)
//			AutoGrLog("DTMSA004"+"::")
//			AutoGrLog("DTMSA004"+":: MATA103 - ANULACAO")
//			AutoGrLog("DTMSA004"+"::"+TIME()+" "+DTOC(DDATABASE))
//			AutoGrLog("FIM        :: ---------------------------------------------------------------------------")
		EndIf
	End Transaction
EndIf

//Precisa zerar a observacao digitada por ser static
_cObsComp := ''

RestArea(aAreaDTQ)
RestArea(aAreaDUD)
RestArea(aAreaAnt)
Return(aLogAutoANU)