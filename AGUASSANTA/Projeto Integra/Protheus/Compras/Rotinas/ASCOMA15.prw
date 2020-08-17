#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA15()

Grava informações complementares do pedido de compras ao analisar a 
cotação
Chamado pelo PE AVALCOPC

Contrato TOP 1=SIM, 2=NÃO

@param		cFilPed		= Filial do pedido
			cPedido		= Número do pedido
			aRatFin		= Rateio financeiro
			nValTotal 	= Valor total do pedido
@return		Nenhum	
@author 	Fabio Cazarini
@since 		23/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA15(cFilPed, cPedido, aRatFin, nValTotal)
	LOCAL aArea			:= GetArea()
	LOCAL lRet			:= .F.
	LOCAL oFont1 		:= TFont():New("MS Sans Serif",,028,,.F.,,,,,.F.,.F.)
	LOCAL oButton1
	LOCAL oNewDialog
	LOCAL cQuery		:= ""
	LOCAL aButtons 		:= {}
	LOCAL bOk			:= {|| VldProjeto(cFilPed, cPedido)}
	LOCAL bCancela		:= {|| VldCancela()}
	LOCAL nX			:= 0
	LOCAL cNUMSC		:= ""
	LOCAL cITEMSC		:= ""
	Local nOpcx         := 2
	Local ln            := 0
	Local lx            := 0	
	
	PRIVATE cCadastro  	:= "Pedido de compra - Gera Contrato TOP?"
	PRIVATE aPCHeader	:= {}
	PRIVATE aPCCols		:= {}
	PRIVATE oPCGetItem	:= NIL
	PRIVATE oEHCT
	PRIVATE cEHCT		:= "2"	// Contrato TOP 1=SIM, 2=NÃO
	PRIVATE cCONTR		:= SPACE( TAMSX3("AFG_XCONTR")[1] ) 
	PRIVATE lTemAFG		:= .F.
	PRIVATE bInfProjet	:= {||InfProjet(nOpcx,cPedido)}
	PRIVATE aRatAJ7     := {}
	PRIVATE cScOk     	:= "OK"

	//-----------------------------------------------------------------------
	// Monta aHeader
	//-----------------------------------------------------------------------
	Aadd(aPCHeader,{"Item"			,"C7_ITEM"		,X3Picture("C7_ITEM") 		,TamSx3("C7_ITEM")[1] 		,TamSx3("C7_ITEM")[2]		,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"Num.SC"		,"C7_NUMSC"		,X3Picture("C7_NUMSC")		,TamSx3("C7_NUMSC")[1]		,TamSx3("C7_NUMSC")[2]		,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"Produto"		,"C7_PRODUTO"	,X3Picture("C7_PRODUTO")	,TamSx3("C7_PRODUTO")[1]	,TamSx3("C7_PRODUTO")[2]	,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"Descrição"		,"B1_DESC"		,X3Picture("B1_DESC")		,TamSx3("B1_DESC")[1]		,TamSx3("B1_DESC")[2]		,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"UM"			,"C7_UM"		,X3Picture("C7_UM")			,TamSx3("C7_UM")[1]			,TamSx3("C7_UM")[2]			,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"Quantidade"	,"C7_QUANT"		,X3Picture("C7_QUANT")		,TamSx3("C7_QUANT")[1]		,TamSx3("C7_QUANT")[2]		,"","","N","","R","","","","V"})
	Aadd(aPCHeader,{"Preço"			,"C7_PRECO"		,X3Picture("C7_PRECO")		,TamSx3("C7_PRECO")[1]		,TamSx3("C7_PRECO")[2]		,"","","N","","R","","","","V"})
	Aadd(aPCHeader,{"Total"			,"C7_TOTAL"		,X3Picture("C7_TOTAL")		,TamSx3("C7_TOTAL")[1]		,TamSx3("C7_TOTAL")[2]		,"","","N","","R","","","","V"})
	Aadd(aPCHeader,{"Fornecedor"	,"C7_FORNECE"	,X3Picture("C7_FORNECE")	,TamSx3("C7_FORNECE")[1]	,TamSx3("C7_FORNECE")[2]	,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"Loja"			,"C7_LOJA"		,X3Picture("C7_LOJA")		,TamSx3("C7_LOJA")[1]		,TamSx3("C7_LOJA")[2]		,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"Nome"			,"A2_NOME"		,X3Picture("A2_NOME")		,TamSx3("A2_NOME")[1]		,TamSx3("A2_NOME")[2]		,"","","C","","R","","","","V"})
	Aadd(aPCHeader,{"Item.SC"		,"C7_ITEMSC"	,X3Picture("C7_ITEMSC")		,TamSx3("C7_ITEMSC")[1]		,TamSx3("C7_ITEMSC")[2]		,"","","C","","R","","","","V"})

	//-----------------------------------------------------------------------
	// Monta aCols
	//-----------------------------------------------------------------------
	DbSelectArea("SC7")
	SC7->( DbSetOrder(1) )
	SC7->( MsSeek(cFilPed + cPedido) )
	
	DO WHILE !EOF() .AND. ;
			(SC7->C7_FILIAL + SC7->C7_NUM == cFilPed + cPedido)
			
   		Aadd(aPCCols,Array(Len(aPCHeader)+1))
	
		aPCCols[Len(aPCCols)][01] := SC7->C7_ITEM
		aPCCols[Len(aPCCols)][02] := SC7->C7_NUMSC
		aPCCols[Len(aPCCols)][03] := SC7->C7_PRODUTO
		aPCCols[Len(aPCCols)][04] := GETADVFVAL("SB1","B1_DESC",xFILIAL("SB1") + SC7->C7_PRODUTO,1,"") 
		aPCCols[Len(aPCCols)][05] := SC7->C7_UM
		aPCCols[Len(aPCCols)][06] := SC7->C7_QUANT
		aPCCols[Len(aPCCols)][07] := SC7->C7_PRECO
		aPCCols[Len(aPCCols)][08] := SC7->C7_TOTAL
		aPCCols[Len(aPCCols)][09] := SC7->C7_FORNECE
		aPCCols[Len(aPCCols)][10] := SC7->C7_LOJA
		aPCCols[Len(aPCCols)][11] := GetAdvFVal("SA2","A2_NOME",xFILIAL("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA ,1,"")
		aPCCols[Len(aPCCols)][12] := SC7->C7_ITEMSC
		
		aPCCols[Len(aPCCols)][Len(aPCHeader)+1] := .F.
		
		DbSelectArea("SC7")
		DbSkip()
	ENDDO
	
	
	DbSelectArea("AFG")
	AFG->( DbSetOrder(2) ) // AFG_FILIAL+AFG_NUMSC+AFG_ITEMSC+AFG_PROJET+AFG_REVISA+AFG_TAREFA
	IF AFG->( MsSeek(cFilPed + aPCCols[01][02] ) ) //aPCCols[01][02] = número da solicitação de compra
		cEHCT	:= "1"	// Contrat-o TOP 1=SIM, 2=NÃO
		cCONTR 	:= AFG->AFG_XCONTR
		lTemAFG	:= .T.
	ENDIF
	
	
	DbSelectArea("AJ7")
	AJ7->( DbSetOrder(2) ) //AJ7_FILIAL+AJ7_NUMPC+AJ7_ITEMPC+AJ7_PROJET+AJ7_REVISA+AJ7_TAREFA
	IF AJ7->( MsSeek(cFilPed + cPedido) )

		DO WHILE !EOF() .AND. ;
				(AJ7->AJ7_FILIAL + AJ7->AJ7_NUMPC == cFilPed + cPedido)
						
			Aadd(aRatAJ7,Array(Len(aPCCols)))
			aRatAJ7[Len(aRatAJ7)][01] := AJ7->AJ7_PROJET
			aRatAJ7[Len(aRatAJ7)][02] := AJ7->AJ7_TAREFA
			aRatAJ7[Len(aRatAJ7)][03] := AJ7->AJ7_NUMPC
			aRatAJ7[Len(aRatAJ7)][04] := AJ7->AJ7_ITEMPC
			aRatAJ7[Len(aRatAJ7)][05] := AJ7->AJ7_COD
			aRatAJ7[Len(aRatAJ7)][06] := AJ7->AJ7_QUANT
			aRatAJ7[Len(aRatAJ7)][07] := AJ7->AJ7_TRT
			aRatAJ7[Len(aRatAJ7)][08] := AJ7->AJ7_QTSEGU
			aRatAJ7[Len(aRatAJ7)][09] := AJ7->AJ7_REVISA
			aRatAJ7[Len(aRatAJ7)][10] := AJ7->AJ7_PLANEJ
			aRatAJ7[Len(aRatAJ7)][11] := AJ7->AJ7_VIAINT
			aRatAJ7[Len(aRatAJ7)][12] := AJ7->AJ7_XCONTR
	
			DbSkip()
		ENDDO
	EndIF	
	
	//-----------------------------------------------------------------------
	// Dialog: Contrato TOP 1=SIM, 2=NÃO
	//-----------------------------------------------------------------------
	oNewDialog := TDialog():New(000,000,275,620,OemToAnsi(cCadastro),,,,,,,,oMainWnd,.T.)

	//-----------------------------------------------------------------------
	// Cabeçalho do PC
	//-----------------------------------------------------------------------
	SX3->( dbSetOrder(2) )
	SX3->( MsSeek("C7_XEHCT") )

	@ 34,08 SAY "Pedido" OF oNewDialog PIXEL SIZE 80,10
	@ 34,70 MSGET cPedido WHEN .F. PIXEL SIZE 60,06 OF oNewDialog PIXEL

	@ 34,170 SAY RetTitle("C7_XEHCT") OF oNewDialog PIXEL SIZE 80,10 // Contrato TOP 1=SIM, 2=NÃO
	@ 34,230 COMBOBOX oEHCT VAR cEHCT ITEMS StrTokArr(x3cbox(),';') PIXEL SIZE 80,10 OF oNewDialog PIXEL

	@ 46,08 SAY RetTitle("AFG_XCONTR") OF oNewDialog PIXEL SIZE 80,10 // Num. contrato
	@ 46,70 MSGET cCONTR WHEN cEHCT=="1" PICTURE PESQPICT("AFG","AFG_XCONTR") PIXEL SIZE 60,06 OF oNewDialog PIXEL

	//-----------------------------------------------------------------------
	// Grid de itens do PC
	//-----------------------------------------------------------------------
	oPCGetItem := MsNewGetDados():New(060,003,129,310,,,,,,0,Len(aPCCols),,,,oNewDialog,aPCHeader,aPCCols,.T.)
    
    Aadd( aButtons, {"Projeto", {||Eval(bInfProjet)}, "Projeto...", "Projeto" , {|| .T.}} ) 

	oNewDialog:bInit := {|| EnchoiceBar(oNewDialog, ;
							{||lRet := .T., IIF(Eval(bOk),oNewDialog:End(),lRet := .F.)},;
							{||lRet := .F., IIF(Eval(bCancela),oNewDialog:End(),lRet := .F.)};
							,,aButtons,,,.F.,.F.,.T.,.T.,.F.)}
	oNewDialog:lCentered := .T.
	oNewDialog:Activate()

	IF !lRet			// Se cancelou, grava o padrão (não é contrato TOP)
		cEHCT := "2"	// Contrato TOP 1=SIM, 2=NÃO
	ELSE
		IF cEHCT == "1"	.AND. !EMPTY(cCONTR) //.AND. cScOk == "ORIGEM_SC"
			//-----------------------------------------------------------------------
			// Grava o número do contrato
			//-----------------------------------------------------------------------
			AFG->(DBCOMMIT())
			FOR nX := 1 TO LEN(aPCCols)
				cNUMSC	:= aPCCols[nX][02]
				cITEMSC	:= aPCCols[nX][12]
				
				cQuery := "UPDATE " + RetSqlname("AFG") + " "
				cQuery += "SET 	AFG_XCONTR = '" + cCONTR + "' "
				cQuery += "WHERE 	AFG_FILIAL = '" + cFilPed + "' "
				cQuery += "		AND AFG_NUMSC = '" + cNUMSC + "' "
				cQuery += "		AND AFG_ITEMSC = '" + cITEMSC + "' "
				cQuery += "		AND D_E_L_E_T_ = ' ' "
				
				TcSqlExec(cQuery)
			NEXT nX
			AFG->(MsGoto(RecNo()))
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Grava complemento no pedido de compras: Contrato TOP 1=SIM, 2=NÃO
	//-----------------------------------------------------------------------
	SC7->(DBCOMMIT())
	
	cQuery := "UPDATE " + RetSqlname("SC7") + " "
	cQuery += "SET 	C7_XEHCT = '" + cEHCT + "' " + ", C7_XCONTOP = '" + cCONTR + "' "
	cQuery += "WHERE 	C7_FILIAL = '" + cFilPed + "' "
	cQuery += "		AND C7_NUM = '" + cPedido + "' "
	cQuery += "		AND D_E_L_E_T_ = ' ' "
	
	TcSqlExec(cQuery)
	SC7->(MsGoto(RecNo()))
    
	IF cScOk == "OK" 
		For ln := 1 TO LEN(aRatAJ7)
			For lx := 1 TO LEN(aRatAJ7[ln][2])
				
				RecLock("AJ7", .T.)
				
				AJ7_FILIAL	:= cFilPed
				AJ7_PROJET	:= aRatAJ7[ln][2][lx][1]
				AJ7_TAREFA	:= aRatAJ7[ln][2][lx][2]
				AJ7_NUMPC	:= cPedido
				AJ7_ITEMPC	:= aRatAJ7[ln][1]
				AJ7_COD		:= aPCCols[ln][3]
				AJ7_QUANT	:= aRatAJ7[ln][2][lx][3]
				AJ7_TRT		:= aRatAJ7[ln][2][lx][4]
				AJ7_QTSEGU	:= aRatAJ7[ln][2][lx][5]
				AJ7_REVISA	:= aRatAJ7[ln][2][lx][6]
				AJ7_XCONTR	:= cCONTR
				
				AJ7->(MsUnLock())
					
			Next lx
		Next ln
		
		
	EndIF
	RestArea( aArea )
RETURN lRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} VldProjeto()

Se contrato TOP, deve ser informado o projeto e tarefa

@param		Nenhum
@return		Lógico: Validado?	
@author 	Fabio Cazarini
@since 		26/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION VldProjeto(cFilPed, cPedido)
	LOCAL lRet			:= .T.
	LOCAL aProjeto		:= {}
	LOCAL aTarefa		:= {}
	LOCAL cGrupo		:= ""
	LOCAL cQuery		:= ""
	LOCAL n120Totlib	:= 0

	IF lRet
		IF cEHCT == "1"	// Contrato TOP 1=SIM, 2=NÃO
			IF EMPTY(cCONTR)
				Help('',1,'Contrato TOP - ' + PROCNAME(),,'Informe o contrato!',4,1)	
				lRet := .F.
			
			ELSE
				IF !lTemAFG .And. Len(aRatAJ7) < 1
				    Help('',1,'Contrato TOP - ' + PROCNAME(),,'É necessário informar o projeto!',4,1)	
					lRet := .F.
				ENDIF
			
			
			ENDIF
		ELSE
			cCONTR := SPACE( TAMSX3("AFG_XCONTR")[1] )
		ENDIF
	ENDIF	
	
	IF lRet
		//-----------------------------------------------------------------------
		// CONTRATO TOP - Se contrato TOP, deve ser informado o projeto e tarefa
		// Retorna array com os projetos do PC:
		// - {FILIAL, PROJET, CONTR, QUANTAJ7, nQUANTITC7, nTOTALITC7, nTOTAJ7}
		//-----------------------------------------------------------------------
		aProjeto 	:= {}
		aTarefa		:= {}
		lRet 		:= U_ASCOMA22(.F., .F., .T., cFilPed, cPedido, @aProjeto, @aTarefa)
	ENDIF
	
	//-----------------------------------------------------------------------
	// CONTRATO TOP - Vl max. liberado p/contrato TOP tem saldo disponivel?
	//-----------------------------------------------------------------------
	IF lRet
		IF LEN(aTarefa) > 0
			IF !U_ASCOMA23(cPedido, .F., aTarefa)
				//-----------------------------------------------------------------------
				// Projeto sem saldo no RM, Grp Aprov (C7_APROV) = AS_APRSSD
				//-----------------------------------------------------------------------
				cGrupo := ALLTRIM(SuperGetMv("AS_APRSSD",.T.,""))
				IF !EMPTY(cGrupo) // grupo de aprovação para projetos sem saldo no RM
					//SC7->(DBCOMMIT())
					//cQuery := "UPDATE " + RetSqlname("SC7") + " "
					//cQuery += "SET 	C7_APROV = '" + cGrupo + "' "
					//cQuery += "WHERE 	C7_FILIAL = '" + cFilPed + "' "
					//cQuery += "		AND C7_NUM = '" + cPedido + "' "
					//cQuery += "		AND D_E_L_E_T_ = ' ' "
					//TcSqlExec(cQuery)
					//SC7->(MsGoto(RecNo()))
					
					cQuery := " SELECT SC7.R_E_C_N_O_  AS REGSC7 "
					cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
					cQuery += " WHERE	SC7.C7_FILIAL = '" + cFilPed + "' " 
					cQuery += " 	AND SC7.C7_NUM = '" + cPedido + "' "
					cQuery += " 	AND SC7.D_E_L_E_T_ = ' '	"
				
					IF SELECT("TRBSC7") > 0
						TRBSC7->( dbCloseArea() )
					ENDIF    
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSC7" ,.F.,.T.)
					
					DbSelectArea("TRBSC7")
					TRBSC7->( DbGoTop() )
					DO WHILE !TRBSC7->( EOF() )
						IncProc( "Aguarde..." )
						
						DbSelectArea("SC7")
						SC7->( DbGoTo( TRBSC7->REGSC7 ) )
						
						RecLock("SC7", .F.)
						SC7->C7_APROV := cGrupo
						SC7->( MsUnLock() )	
						
						n120TotLib += (SC7->C7_TOTAL - SC7->C7_VLDESC)
						
						DbSelectArea("TRBSC7")
						TRBSC7->( DbSkip() )
					ENDDO
					TRBSC7->( dbCloseArea() )
				ENDIF
			
				//-----------------------------------------------------------------------
				// Cria alcada de aprovacao do IP ou PC 
				//-----------------------------------------------------------------------
				MaAlcDoc({cPedido,"PC",n120TotLib,,,cGrupo,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},SC7->C7_EMISSAO,3)
				If !Empty(cGrupo) 
					lFirstNiv := MaAlcDoc({cPedido,"PC",n120TotLib,,,cGrupo,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},,1)
				EndIf
			
			ENDIF
		ENDIF
	ENDIF

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} VldCancela()

Confirmação do 'Cancela' do enchoice

@param		Nenhum
@return		Lógico: Continua?	
@author 	Fabio Cazarini
@since 		26/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION VldCancela()
	LOCAL lRet	:= .T.
	LOCAL cCRLF	:= CHR(13) + CHR(10)

	lRet := MsgYesNo("Cancelando esta opção, será considerado que o pedido de compra não gera contrato no TOP." + cCRLF + cCRLF+ "Continua assim mesmo?") 

RETURN lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsDlgPC³ Autor ³ Edson Maricate          ³ Data ³ 22-12-2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao cria uma janela para configuracao e utilizacao    ³±±
±±³          ³do Pedido de Compras a um dterminado projeto.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA120,SIGAPMS                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InfProjet(nOpcao,cNumPC,aRatAuto)

Local lOk
Local oDlg
Local nPosPerc    := 0
Local nPosItem    := aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_ITEM"}) //aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEM"})
Local cItemPC     := aPCCols[oPCGetItem:nAt][nPosItem] //aCols[n][nPosItem]
Local cNumSC      := aPCCols[oPCGetItem:nAt][aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_NUMSC"})] //aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_NUMSC"})]
Local cItemSC     := aPCCols[oPCGetItem:nAt][aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_ITEMSC"})] //aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEMSC"})]
Local nQuantPC    := aPCCols[oPCGetItem:nAt][aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_QUANT"})] //aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_QUANT"})]
Local nVlrTotal   := aPCCols[oPCGetItem:nAt][aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})] //aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})]
Local nPosProj    := aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_PROJET"}) //aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PROJET"})
Local nPosVersao  := aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_REVISA"}) //aScan(aHeader,{|x| Alltrim(x[2]) == "C7_REVISA"})
Local nPosTaref   := aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_TAREFA"}) //aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TAREFA"})
Local nPosTrt     := aScan(aPCHeader,{|x| Alltrim(x[2]) == "C7_TRT"}) //aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TRT"})
Local nPosRat     := aScan(aRatAJ7,{|x| x[1] == aPCCols[oPCGetItem:nAt][nPosItem]})
Local aSavCols    := {}
Local aSavHeader  := {}
Local nSavN       := 1
Local lGetDados   := .T.
Local oGetDados   := Nil
Local nY          := 0
Local nOpcMsg     := 0
Local cProduto    := ""
Local cNumSA      := ""
Local lPmsAj7Cols := ExistBlock("PMSAJ7COLS")
Local aAlter      := {"AJ7_PROJET","AJ7_TAREFA", "AJ7_QUANT", "AJ7_QTSEGU" }
Local lPmsAj7Cpo  := Existblock("PmsAj7Cpo")
Local lRet        := .T.
Local lAuto       := aRatAuto <> NIL .and. ValType(aRatAuto) = 'A'
Local nX          := 0
Local aArea       := GetArea()
Local aAreaSC7    := SC7->(GetArea())
Local n           := 1
Local nTipoPed    := 1

Local bSavKeyF4   := SetKey(VK_F4 ,Nil)
Local bSavKeyF5   := SetKey(VK_F5 ,Nil)
Local bSavKeyF9   := SetKey(VK_F9 ,Nil)

PRIVATE aCols     := {}
PRIVATE aHeader   := {}



Default aRatAuto := {}


// Salva ambiente da rotina de pedido de compra
aSavCols   := aClone(aPCCols)
aSavHeader := aClone(aPCHeader)
nSavN      := oPCGetItem:nAt

n       := 1
aCols   := {}
aHeader := {}

If Empty(cCONTR)
	Aviso("Atenção", "É necessário o número do contrato.", {"Fechar"}, 2) 
	Return .F.
Endif

If !Empty(cNumSC) .And. !Empty(cItemSC)
     dbSelectArea("AFG")
     dbSetOrder(2)
     If MsSeek(xFilial()+cNumSC+cItemSC) .and. nTipoPed == 1 // 1 = Pedido ; 2 = Aut. Entrega.
         cScOk := "ORIGEM_SC"
     EndIF
EndIF

If cScOk =="OK"
	nQtMaxSC:= nQuantPC

	If nOpcao == 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do aHeader                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("AJ7")
		While !EOF() .And. (x3_arquivo == "AJ7")
			IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
				AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
					x3_tamanho, x3_decimal, x3_valid,;
					x3_usado, x3_tipo, x3_arquivo,x3_context } )
			Endif
			If AllTrim(x3_campo) == "AJ7_QUANT"
				nPosPerc	:= Len(aHeader)
			EndIf
			dbSkip()
		EndDo
		aHeaderAJ7	:= aClone(aHeader)
		If nPosRat > 0
			aCols	:= aClone(aRatAJ7[nPosRat][2])
			If Len(aCols) == 1
				aCols[1][Len(aHeader)+1] := .F.
			Endif
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a montagem de uma linha em branco no aCols.              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aadd(aCols,Array(Len(aHeader)+1))
			For ny := 1 to Len(aHeader)
				If Trim(aHeader[ny][2]) == "AJ7_ITEM"
					aCols[1][ny] 	:= "01"
				Else
					aCols[1][ny] := CriaVar(aHeader[ny][2])
				EndIf
				aCols[1][Len(aHeader)+1] := .F.
			Next ny
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do aHeader                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("AJ7")
		While !EOF() .And. (x3_arquivo == "AJ7")
			IF X3USO(x3_usado) .And. cNivel >= x3_nivel
				AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
					x3_tamanho, x3_decimal, x3_valid,;
					x3_usado, x3_tipo, x3_arquivo,x3_context } )
			Endif
			If AllTrim(x3_campo) == "AJ7_QUANT"
				nPosPerc	:= Len(aHeader)
			EndIf
			dbSkip()
		End
		aHeaderAJ7	:= aClone(aHeader)
		dbSelectArea("AJ7")
		dbSetOrder(2) //AJ7_FILIAL+AJ7_NUMPC+AJ7_ITEMPC+AJ7_PROJET+AJ7_REVISA+AJ7_TAREFA
		If nPosRat == 0
			If MsSeek(xFilial()+cNumPC+cITEMPC)
				While !Eof() .And. xFilial()+cNumPC+cITEMPC==;
						AJ7_FILIAL+AJ7_NUMPC+AJ7_ITEMPC
					If AJ7->AJ7_REVISA==PmsAF8Ver(AJ7->AJ7_PROJET)
						aADD(aCols,Array(Len(aHeader)+1))
						For ny := 1 to Len(aHeader)
							If ( aHeader[ny][10] != "V")
								aCols[Len(aCols)][ny] := FieldGet(FieldPos(aHeader[ny][2]))
							Else
								aCols[Len(aCols)][ny] := CriaVar(aHeader[ny][2])
							EndIf
							aCols[Len(aCols)][Len(aHeader)+1] := .F.
						Next ny
					EndIf
					dbSkip()
				End
			EndIf
			If Empty(aCols)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz a montagem de uma linha em branco no aCols.              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aadd(aCols,Array(Len(aHeader)+1))
				For ny := 1 to Len(aHeader)
					If Trim(aHeader[ny][2]) == "AJ7_ITEM"
						aCols[1][ny] 	:= "01"
					Else
						aCols[1][ny] := CriaVar(aHeader[ny][2])
					EndIf
					aCols[1][Len(aHeader)+1] := .F.
				Next ny
			EndIf
		Else
			aCols := aClone(aRatAJ7[nPosRat][2])
		EndIf
	EndIf

	If lPmsAj7Cols
		aUserCols := Execblock("PMSAJ7COLS", .F.,.F.,{cItemPC,cNumSC,cItemSC,nQuantPC,nVlrTotal,aHeader,aCols})
		If ValType(aUserCols) == "A"
			aCols := aClone(aUserCols)
		Endif
	Endif

	If lPmsAj7Cpo
		aAlter := aClone(Execblock("PmsAj7Cpo", .F.,.F.,{aAlter,aHeader,aCols}))
	Endif
	If lAuto
		// Compatibiliza array aheader com a funcao de campo PMSAJ7FOK
		For nX := 1 to Len(aRatAuto)
			For nY := 1 to Len(aRatAuto[nX])
				If ( aRatAuto[nX][nY][3] == Nil )
					nPos := aScan(aHeader,{|x| Alltrim(x[2]) == Alltrim(aRatAuto[nX][nY][1]) })
					If nPos > 0
						aRatAuto[nX][nY][3] := aHeader[nPos][6]
					EndIf
					If Empty(aRatAuto[nX][nY][3])
						aRatAuto[nX][nY][3] := "U_PrjFOk() "
					Else
						aRatAuto[nX][nY][3] += " .And. U_PrjFOk() "
					EndIf
				EndIf
			Next nY
		Next nX
		
		If !AJ7->(MsGetDAuto(aRatAuto,"U_PrjLinOk()",{|| U_PrjTOk()},,nOpcao))
			lOk  := .F.
			lRet := .F.
		Else
			lOk  := .T.
			lRet := .T.
		endif
	else
		If lGetDados
			DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
			DEFINE MSDIALOG oDlg FROM 88 ,22  TO 350,619 TITLE "Gerenciamento de Projetos - PC" Of oMainWnd PIXEL //"Gerenciamento de Projetos - PC"
			oGetDados := MSGetDados():New(23,3,112,296,nOpcao,'U_PrjLinOk','U_PrjTOk','+AJ7_ITEM',.T.,aAlter,,,100,'U_PrjFOk')
			@ 16 ,3   TO 18 ,310 LABEL '' OF oDlg PIXEL
			@ 6  ,10   SAY "Num. PC" Of oDlg PIXEL SIZE 27 ,9   //"Num. PC"
			@ 5  ,35  SAY  cNumPC+"/"+cITEMPC Of oDlg PIXEL SIZE 40,9 FONT oBold
			@ 6  ,190 SAY "Quantidade" Of oDlg PIXEL SIZE 30 ,9   //"Quantidade"
			@ 5  ,230 MSGET nQuantPC Picture "@E 999,999,999.99" When .F. PIXEL SIZE 65,9
			@ 118,249 BUTTON 'Confirma' SIZE 35 ,9   FONT oDlg:oFont ACTION {||If(oGetDados:TudoOk(),(lOk:=.T.,oDlg:End()),(lOk:=.F.))}  OF oDlg PIXEL //'Confirma'
			@ 118,210 BUTTON 'Cancelar' SIZE 35 ,9   FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL //'Cancelar'
			If ExistBlock("PMSPCSCR")
				ExecBlock("PMSPCSCR",.F.,.F.,{oDlg,nOpcao})
			Endif
			ACTIVATE MSDIALOG oDlg
		EndIf
	EndIf
	//If nOpcao <> 2 .And. lOk
	If nOpcao == 2 .And. lOk
		If nPosRat > 0
			aRatAJ7[nPosRat][2]	:= aClone(aCols)
		Else
			aADD(aRatAJ7,{aSavCols[nSavN][nPosItem],aClone(aCols)})
		EndIf

		If ExistBlock("PMSDLGPC")
			U_PMSDLGPC(aCols,aHeader,aSavCols,aSavHeader,nSavN)
		EndIf
	EndIf

	If lOk
		If nPosProj>0 .And. nPosVersao>0 .And. nPosTaref>0
			aSavCols[n][nPosProj]:=SPACE(TAMSX3("C7_PROJET")[1])
			aSavCols[n][nPosVersao]:=SPACE(TAMSX3("C7_REVISA")[1])
			aSavCols[n][nPosTaref]:=SPACE(TAMSX3("C7_TAREFA")[1])
		EndIf
				
		If nPosTrt>0
			aSavCols[n][nPosTrt]:=	SPACE(TAMSX3("C7_TRT")[1])
		EndIf
	EndIf
Else
	If lauto
		lRet := .F.
		Help( " ", 1, "PMSAUTOPC",, "Este item do pedido de compras esta relacionado a uma solicitção de compras amarrado a um projeto/tarefa e não poderá ser alterada. Utilize a rotina de manutenção de solicitações de compras ou verifique o item selecionado", 1, 0 )//"Este item do pedido de compras esta relacionado a uma solicitção de compras amarrado a um projeto/tarefa e não poderá ser alterada. Utilize a rotina de manutenção de solicitações de compras ou verifique o item selecionado"
	ElseIf cScOk == "ORIGEM_SC"
		If !isBlind()
			nOpcMsg := Aviso("Atenção!","Este item do pedido de compras esta relacionado a uma solicitação de compras amarrado a um projeto/tarefa e não poderá ser alterada. Utilize a rotina de manutenção de solicitações de compras ou verifique o item selecionado",If(nOpcao<>1,{"Fechar","Tabela de Dados"},{"Fechar"}),2)//"Atenção!"##"Este item do pedido de compras esta relacionado a uma solicitação de compras amarrado a um projeto/tarefa e não poderá ser alterada. Utilize a rotina de manutenção de solicitações de compras ou verifique o item selecionado"##"Fechar"##"Tabela de Dados"##"Fechar"
		Else
			nOpcMsg := 1
		EndIf

		If nOpcMsg == 2		// Visualiza SC
			MaViewSC(cNumSC)
		EndIf
	EndIF
EndIf

// Restaura ambiente do pedido de compras
aCols   := aClone(aSavCols)
aHeader := aClone(aSavHeader)
n       := nSavN

SetKey(VK_F4 ,bSavKeyF4)
SetKey(VK_F5 ,bSavKeyF5)
SetKey(VK_F9 ,bSavKeyF9)

RestArea(aAreaSC7)
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAJ7LOK³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de validacao LinOk da GetDados de rateio da SC.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSDLGSC,PMSXFUN                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PrjLinOk()
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os campos obrigatorios do SX3.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !aCols[n][Len(aCols[n])]
	lRet := PmsVldFase("AF8",aCols[n][aScan(aHeader,{|x| Substr(x[2],4,7) =="_PROJET" })],"52")
	If lRet 
		lRet := MaCheckCols(aHeader,aCols,n)
	EndIf
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAJ7TOK³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de validacao TudOk da GetDados de rateio da SC.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSDLGSC,PMSXFUN                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PrjTOk()

Local nx
Local lRet			:= .T.
Local nTotQuant		:= 0
Local nPosProjet	:= aScan(aHeader,{|x|AllTrim(x[2])=="AJ7_PROJET"})
Local nPosTarefa	:= aScan(aHeader,{|x|AllTrim(x[2])=="AJ7_TAREFA"})
Local nPosQuant		:= aScan(aHeader,{|x|AllTrim(x[2])=="AJ7_QUANT"})
Local nSavN			:= n
Local cChave		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os campos obrigatorios do SX3.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx := 1 to Len(aCols)
	n	:= nx
	If !aCols[n][len(aCols[n])]
		If !Empty(aCols[n][nPosProjet])
			If !PMSAJ7LOK()
				lRet := .F.
				Exit
			EndIf     
			// Verifica se existe algum registro com a mesma chave projeto+tarefa
			If Alltrim(aCols[n][nPosProjet])+Alltrim(aCols[n][nPosTarefa]) $ cChave
				lRet := .F.
				Aviso("Atenção", "Existem linhas com a mesma chave (Projeto+Tarefa) nesta tela. Favor deixar somente 1 registro para cada chave.", {"Fechar"}, 2) //"Atenção"##"Existem linhas com a mesma chave (Projeto+Tarefa) nesta tela. Favor deixar somente 1 registro para cada chave."##"Fechar"				
				Exit			
			Else
				cChave += Alltrim(aCols[n][nPosProjet])+Alltrim(aCols[n][nPosTarefa])+"|"
			Endif
			
			nTotQuant+=aCols[n][nPosQuant]
		EndIf
	EndIf
Next


If lRet .and. nTotQuant > nQtMaxSC
	Help("   ",1,"PMSQTSC")
	lRet := .F.
EndIf

If lRet .and. ExistBlock("PMSAJ7MB")
	lRet := ExecBlock("PMSAJ7MB", .F., .F., {lRet})	
EndIf

n := nSavN

Return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PMSAJ7FOK³ Autor ³ Edson Maricate         ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de validacao dos campos da GetDados de rateio da SC.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSDLGSC,PMSXFUN                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PrjFOk()

Local cTRT     := aCols[n][aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_TRT"})]
Local cProjeto := aCols[n][aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_PROJET"})]
Local cRevisa  := aCols[n][aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_REVISA"})]
Local cTarefa  := aCols[n][aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_TAREFA"})]
Local lRet     := .T.
Local cCampo   := AllTrim(ReadVar())
Local lGerEmp  := .F.  

Do Case
	Case cCampo == 'M->AJ7_PROJET'
		cProjeto:= M->AJ7_PROJET
		lRet := PMSExistCPO("AF8") .And. PmsVldFase("AF8",M->AJ7_PROJET,"52")
	Case cCampo == 'M->AJ7_TAREFA'
		cTarefa	:= M->AJ7_TAREFA
		lRet := ExistCpo("AF9",cProjeto+cRevisa+M->AJ7_TAREFA,1)
EndCase

If !Empty(cProjeto) .And. Empty(cTRT) .And. !Empty(cTarefa) .And. lRet .And. aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_TRT"}) > 0
// parametro que determina se gera empenho direto sem perguntar nada (.T.)
	lGerEmp := GetNewPar("MV_PMSSCGE",.F.)
	If lGerEmp  // gera empenho direto sem perguntar nada
		aCols[n][aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_TRT"})]	 := PmsPrxEmp(cProjeto,cRevisa,cTarefa)
	ElseIf GetMV("MV_PMSBXEM") .And.  ( !isBlind() .And. Aviso("Gerenciamento de Projetos","Voce deseja gerar um empenho deste item ao projeto ?",{"Sim","Nao"},2) == 1 )   //"Gerenciamento de Projetos"###"Voce deseja gerar um empenho deste item ao projeto ?"###"Sim"###"Nao"
		aCols[n][aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_TRT"})]	 := PmsPrxEmp(cProjeto,cRevisa,cTarefa)
	Else
		aCols[n][aScan(aHeader,{|x|Alltrim(x[2])=="AJ7_TRT"})]	 :=	SPACE(LEN(AJ7->AJ7_TRT))
	EndIf
EndIf

Return lRet
 