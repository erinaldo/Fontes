#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA120BUT ºAutor  ³ Leonardo Soncin    º Data ³  Out/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±ºDesc.     ³Acrescenta botao na Enchoice do pedido de compras.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA120BUT()

Local _aButt := {}
Local cAlias:= Alias()
Local nReg:= Recno()
Local nOpcx := 2

aadd(_aButt,{"BUDGETY",{|| U_xPosic(cAlias,nReg,nOpcx,"PC")},OemToAnsi("Consulta Aprovacao - Uso CSU"),OemToAnsi("Consulta Aprovacao - Uso CSU")})
// Melhoria solicitada - botao para informacao do usuario que incluiu o pedido - Carlos Tagliaferri Jr. 11/Jun/07
If !Inclui
	AAdd(_aButt,{"USER"	, { || xUserMed() }, "Usuário" } )
EndIf

Return(_aButt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ xPosic   ºAutor  ³ Leonardo Soncin    º Data ³  Out/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta Aprovacao - Apresenta os nomes dos usuarios.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xPosic(cAlias,nReg,nOpcx,cTipoDoc)

Local aArea		:= GetArea()
Local cHelpApv  := OemToAnsi("Este documento nao possui controle de aprovacao.")
Local cComprador:= ""
Local cSituaca  := ""
Local dSituaca  := Ctod("")  //OS 2852-11 inserido por Jose Maria 
Local cNumDoc   := ""
Local cStatus   := ""
Local cTitle    := ""
Local cTitDoc   := ""

Local lBloq     := .F.

Local nUsado	:= 0
Local nX   		:= 0
Local nY        := 0

Local oDlg
Local oGet
Local oBold
//Local lAprovPend := .F.

#IFDEF TOP
	Local cQuery   := ""
	Local aStruSCR := {}
	Local aStruSCX := {}
#ENDIF

If Type( 'aCols' ) == 'A'
	Private aSavCols  := aClone(aCols)
	Private aSavHead  := aClone(aHeader)
	Private nSavN     := n
EndIf

Private cAliasSCR := "TMP"
Private cAliasSCX := "TMX"

//DEFAULT cTipoDoc := "PC"

dbSelectArea(cAlias)
dbGoto(nReg)

IF cTipoDoc == "PC" .Or. cTipoDoc == "AE"
	If !Empty(SC7->C7_APROV)
		cTitle    := OemToAnsi("Aprovacao do Pedido de Compra")
		cTitDoc   := OemToAnsi("Pedido" )
		cHelpApv  := OemToAnsi("Este pedido nao possui controle de aprovacao.")
		cNumDoc   := SC7->C7_NUM
		cComprador:= UsrFullName(SC7->C7_USER)
		cStatus   := IIF(SC7->C7_CONAPRO=="L",OemToAnsi("Pedido Liberado"),OemToAnsi("Aguardando Lib."))
	EndIf                                                                                       
ElseIf cTipoDoc == "CP"
	If !Empty(SC3->C3_APROV)
		cTitle    := OemToAnsi( "Aprovacao do Contrato de Parceria")
		cTitDoc   := OemToAnsi( "Contrato" )
		cHelpApv  := OemToAnsi("Este Contrato nao possui controle de aprovacao." )
		cNumDoc   := SC3->C3_NUM
		cComprador:= UsrFullName(SC3->C3_USER)
		cStatus   := IIF(SC3->C3_CONAPRO=="L",OemToAnsi("CONTRATO LIBERADO"),OemToAnsi("AGUARDANDO LIB."))
	EndIf
ElseIf cTipoDoc == "NF"
	If !Empty(SF1->F1_APROV)
		cTitle    := OemToAnsi( "Aprovacao da Nota Fiscal de Entrada")
		cTitDoc   := OemToAnsi( "Nota Fiscal" )
		cHelpApv  := OemToAnsi( "Esta Nota Fiscal nao possui controle de aprovacao." )
		cNumDoc   := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		cStatus   := IIF(SF1->F1_STATUS=="B",OemToAnsi("NF AGUARDANDO LIB."),OemToAnsi("NF LIBERADA" ))
	EndIf
EndIf

If !Empty(cNumDoc)
	
	aHeader:= {}
	aCols  := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aHeader com os campos fixos.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SCR")
	While !Eof() .And. (SX3->X3_ARQUIVO == "SCR")
		IF AllTrim(X3_CAMPO)$"CR_OBS/CR_DATALIB"
			
			If AllTrim(x3_campo) == "CR_DATALIB"
				nUsado++
				AADD(aHeader,{ OemToAnsi("Laudo"),"CR_X_LAUDO","",90,0,"","","M","",""} ) //"Laudo da Negociacao."
				nUsado++
				AADD(aHeader,{ OemToAnsi("Procurement"),"bSINAL",   "",01,0,"","","C","",""} ) // Sinalizador - MEMO
				nUsado++
				AADD(aHeader,{ OemToAnsi("Nome"),"bCR_NOMEC",   "",20,0,"","","C","",""} ) // Nome Completo
				nUsado++
				AADD(aHeader,{ OemToAnsi("Situação"),"bCR_SITUACA","",15,0,"","","C","",""} ) //"Situacao"
				nUsado++
				AADD(aHeader,{ OemToAnsi("Aprovado por"),"bCR_NOMELIB","",15,0,"","","C","",""} ) //"Usuario Lib."
				nUsado++
				AADD(aHeader,{ OemToAnsi("Nome"),"bCR_NOMECLIB","",30,0,"","","C","",""} ) //"Usuario Lib."
				nUsado++
				AADD(aHeader,{ OemToAnsi("Usuário"),"bCR_NOME",   "",15,0,"","","C","",""} ) // Usuario
				nUsado++
				AADD(aHeader,{ OemToAnsi("Aprovador Original"),"bCR_NOMORI",   "",30,0,"","","C","",""} ) // Aprovador Original
			EndIf
			
			nUsado++
			AADD(aHeader,{	TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
			
		Endif
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	#IFDEF TOP
		
		IF cTipoDoc == "PC" .Or. cTipoDoc == "AE"
			
			//Tatiana Barbosa - OS 2852-11 - Fev. 2012
			aStruSCX := SCR->(dbStruct())
			cTipoDoc := "PC"
			cAliasSCX := GetNextAlias()
			cQuery    := "SELECT R_E_C_N_O_ AS REGSCR, * FROM "+RetSqlName("SCR")+" SCR "
			cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
			cQuery    += "SCR.CR_NUM = '"+Padr(SC7->C7_NUM,Len(SCR->CR_NUM))+"' AND "
			cQuery    += "SCR.CR_TIPO = 'PC' AND CR_X_TPLIB = 'S' AND "
			cQuery    += "SCR.D_E_L_E_T_=' ' "
			cQuery    += "ORDER BY SCR.CR_NIVEL"		
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCX)
            //
			
			IF SY1->(DbSetOrder(3),DbSeek(xFilial("SY1")+__cUserId))
				aStruSCR := SCR->(dbStruct())
				cTipoDoc := "PC"
				cAliasSCR := GetNextAlias()
				cQuery    := "SELECT R_E_C_N_O_ AS REGSCR, * "
				cQuery    += "FROM "+RetSqlName("SCR")+" SCR "
				cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
				cQuery    += "SCR.CR_NUM = '"+Padr(SC7->C7_NUM,Len(SCR->CR_NUM))+"' AND "
				cQuery    += "SCR.CR_TIPO = 'PC' AND "
				cQuery    += "SCR.D_E_L_E_T_=' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)
			Else
				
				aStruSCR := SCR->(dbStruct())
				cTipoDoc := "PC"
				cAliasSCR := GetNextAlias()
				cQuery    := "SELECT R_E_C_N_O_ AS REGSCR, * FROM "+RetSqlName("SCR")+" SCR "
				cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
				cQuery    += "SCR.CR_NUM = '"+Padr(SC7->C7_NUM,Len(SCR->CR_NUM))+"' AND "
				cQuery    += "SCR.CR_TIPO = 'PC' AND CR_X_TPLIB <> 'S' AND "
				cQuery    += "SCR.D_E_L_E_T_=' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)
								
			EndIf
			
			If (cAliasSCR)->(Eof())
				(cAliasSCR)->(dbCloseArea())
				cTipoDoc  := "AE"
				cAliasSCR := GetNextAlias()
				cQuery    := "SELECT * FROM "+RetSqlName("SCR")+" SCR "
				cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
				cQuery    += "SCR.CR_NUM = '"+Padr(SC7->C7_NUM,Len(SCR->CR_NUM))+"' AND "
				cQuery    += "SCR.CR_TIPO = 'AE' AND "
				cQuery    += "SCR.D_E_L_E_T_=' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)
			EndIf
			
		ElseIf cTipoDoc == "CP"
			
			aStruSCR  := SCR->(dbStruct())
			cAliasSCR := GetNextAlias()
			cQuery    := "SELECT * FROM "+RetSqlName("SCR")+" SCR "
			cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
			cQuery    += "SCR.CR_NUM = '"+Padr(SC3->C3_NUM,Len(SCR->CR_NUM))+"' AND "
			cQuery    += "SCR.CR_TIPO = 'CP' AND "
			cQuery    += "SCR.D_E_L_E_T_=' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)
			
		ElseIf cTipoDoc == "NF"
			
			aStruSCR  := SCR->(dbStruct())
			cAliasSCR := GetNextAlias()
			cQuery    := "SELECT * FROM "+RetSqlName("SCR")+" SCR "
			cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
			cQuery    += "SCR.CR_NUM = '"+Padr(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,Len(SCR->CR_NUM))+"' AND "
			cQuery    += "SCR.CR_TIPO = 'NF' AND "
			cQuery    += "SCR.D_E_L_E_T_=' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)
			
		EndIf
		
		For nX := 1 To Len(aStruSCR)
			If !aStruSCR[nX][2]$"C/M/N"
				TcSetField(cAliasSCR,aStruSCR[nX][1],aStruSCR[nX][2],aStruSCR[nX][3],aStruSCR[nX][4])
			EndIf
		Next nX

		//Tatiana Barbosa - OS 2852-11 - Fev. 2012	
		For nX := 1 To Len(aStruSCX)
			If !aStruSCX[nX][2]$"C/M/N"
				TcSetField(cAliasSCX,aStruSCX[nX][1],aStruSCX[nX][2],aStruSCX[nX][3],aStruSCX[nX][4])
			EndIf
		Next nX
        //
        
	#ELSE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre o arquivo SCR sem filtros    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ChkFile("SCR",.F.,"TMP")
		
		dbSelectArea(cAliasSCR)
		dbSetOrder(1)
		
		IF cTipoDoc == "PC" .Or. cTipoDoc == "AE"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ A rotina a seguir garante o funcionamento correto na base historica dos clientes, ³
			//³ pois com a implementacao do parametro MV_AEAPROV que estende o controle de alcadas³
			//³ para a AE, em 22/07/04 foi alterada a gravacao do tipo do doc para PC e AE afim   ³
			//³ de diferenciar o tipo de doc nos arquivos SC7 e SCR sem afetar o funcionamento ant³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTipoDoc := "PC"
			MsSeek(xFilial("SCR")+cTipoDoc+Padr(SC7->C7_NUM,Len(SCR->CR_NUM)))
			If (cAliasSCR)->( Eof() )
				cTipoDoc := "AE"
				MsSeek(xFilial("SCR")+cTipoDoc+Padr(SC7->C7_NUM,Len(SCR->CR_NUM)))
			EndIf
		ElseIf cTipoDoc == "CP"
			MsSeek(xFilial("SCR")+cTipoDoc+Padr(SC3->C3_NUM,Len(SCR->CR_NUM)))
		ElseIf cTipoDoc == "NF"
			MsSeek(xFilial("SCR")+cTipoDoc+Padr(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,Len(SCR->CR_NUM)))
		EndIf
	#ENDIF
//	nVez := 0
	
	dbSelectArea(cAliasSCR)                                         
		
	While !Eof() .And.(cAliasSCR)->CR_FILIAL+(cAliasSCR)->CR_TIPO+Substr((cAliasSCR)->CR_NUM,1,;
		len(IIF(cTipoDoc == "PC" .Or. cTipoDoc == "AE",SC7->C7_NUM ,IIF(cTipoDoc == "CP",SC3->C3_NUM,SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )))) ;
		== xFilial("SCR") + cTipoDoc + cNumDoc

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao exibir o processo de aprovacao do Depto de compras enquanto ³
		//³ nao estiver liberado. - Marcos Rocha - 27/08/2010.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
		If cTipoDoc == "PC"
			// Nao exibe o processo/historico de cotacao de compras para usuarios que nao sao do depto
			If  (cAliasSCR)->CR_X_TPLIB == "S" .And. // Campo que identifica quem esta aprovando -> 'S' =  Compras
				dbSkip()
				Loop
			EndIf
		EndIf
		nVez ++
/*/

		Aadd(aCols,Array(nUsado+1))
		nY++
		For nX := 1 to Len(aHeader)
			If aHeader[nX][02] == "bSINAL"
				SCR->( DbGoTo( (cAliasSCR)->REGSCR ) )
				aCols[nY][nX] := IIF( !Empty(SCR->CR_X_LAUDO), 'Sim',' ' )
			ElseIf aHeader[nX][02] == "bCR_NOMEC"
				aCols[nY][nX] := UsrFullName((cAliasSCR)->CR_USER)
			ElseIf aHeader[nX][02] == "bCR_NOME"
				aCols[nY][nX] := UsrRetName((cAliasSCR)->CR_USER)
			ElseIf aHeader[nX][02] == "bCR_SITUACA"
				Do Case
					Case (cAliasSCR)->CR_STATUS == "01"
						cSituaca := OemToAnsi("Aguardando")
					Case (cAliasSCR)->CR_STATUS == "02"
						cSituaca := OemToAnsi("Em Aprovacao")
					Case (cAliasSCR)->CR_STATUS == "03"
						cSituaca := IIF(cTipoDoc == "PC" .Or. cTipoDoc == "AE",OemToAnsi("Aprovado"),IIF(cTipoDoc == "CP",OemToAnsi("Aprovado"),OemToAnsi("Aprovado")))  
					    /*
						If SCR->CR_X_TPLIB == "S"               
						   dSituaca := SCR->CR_DATALIB  //OS 2852-11 inserido por Jose Maria 
						Endif  
						*/
					Case (cAliasSCR)->CR_STATUS == "04"
						cSituaca := IIF(cTipoDoc == "PC" .Or. cTipoDoc == "AE",OemToAnsi("Bloqueado"),IIF(cTipoDoc == "CP",OemToAnsi("Bloqueado"),OemToAnsi("Bloqueado")))
						lBloq := .T.
					Case (cAliasSCR)->CR_STATUS == "05"
						cSituaca := OemToAnsi( "Nivel Liberado ")
				EndCase
				aCols[nY][nX] := cSituaca
			ElseIf aHeader[nX][02] == "bCR_NOMECLIB" 
				//CORRECAO DO APROVADOR 
				If (cAliasSCR)->CR_USERLIB!='      '
					aCols[nY][nX] := UsrFullName((cAliasSCR)->CR_USERLIB)
				ENDIF
			ElseIf aHeader[nX][02] == "bCR_NOMELIB"  
					//CORRECAO DO APROVADOR 
				If (cAliasSCR)->CR_USERLIB!='      '
					aCols[nY][nX] := UsrRetName((cAliasSCR)->CR_USERLIB)
				endif
			ElseIf aHeader[nX][02] == "bCR_NOMORI"   
			    //CORRECAO DO APROVADOR 
				If (cAliasSCR)->CR_USERORI!='      '					   					   		
					aCols[nY][nX] := UsrFullName((cAliasSCR)->CR_USERORI)
			 	ENDIF
			ElseIf ( aHeader[nX][10] != "V")
				SCR->( DbGoTo( (cAliasSCR)->REGSCR ) )
				aCols[nY][nX] := SCR->&(aHeader[nX][2])
			EndIf
		Next nX
		
		
		aCols[nY][nUsado+1] := .F.
		dbSkip()
	EndDo
	
	//Tatiana Barbosa - OS 2852-11 - Fev. 2012	
	dbSelectArea(cAliasSCX)
	dbGotop()
	                                         
	While (cAliasSCX)->(!Eof())// .And. !Empty((cAliasSCX)->CR_DATALIB)
		dSituaca := (cAliasSCX)->CR_DATALIB
		(cAliasSCX)->(DbSkip())
	EndDo	
	//
	
	If !Empty(aCols)
		If lBloq
			cStatus := IIF(cTipoDoc == "PC" .Or. cTipoDoc == "AE",OemToAnsi("Bloqueado"),IIF(cTipoDoc == "CP",OemToAnsi("Bloqueado"),OemToAnsi("Bloqueado")))
		EndIf
		If Type('n') == 'N'
			n:=	 IIF(n > Len(aCols), Len(aCols), n)  // Feito isto p/evitar erro fatal(Array out of Bounds). Gilson-Localizações
		EndIf
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg TITLE cTitle From 109,095 To 440/*400*/,600 OF oMainWnd PIXEL	 //"Aprovacao do Pedido de Compra // Contrato"
		@ 005,003 TO 032,250 LABEL "" OF oDlg PIXEL
		@ 015,007 SAY cTitDoc OF oDlg FONT oBold PIXEL SIZE 046,009 // "Pedido" / "Contrato" / "Nota Fiscal"
		@ 014,041 MSGET cNumDoc PICTURE "" WHEN .F. PIXEL SIZE 050,009 OF oDlg FONT oBold
		If cTipoDoc <> "NF"
			@ 015,103 SAY OemToAnsi("Comprador") OF oDlg PIXEL SIZE 033,009 FONT oBold
			@ 014,138 MSGET cComprador PICTURE "" WHEN .F. of oDlg PIXEL SIZE 103,009 FONT oBold
		EndIF
		@ 132,008 SAY 'Situacao :' OF oDlg PIXEL SIZE 052,009
		@ 132,038 SAY cStatus OF oDlg PIXEL SIZE 120,009 FONT oBold
		@ 147,008 SAY 'Data Procurement:' OF oDlg PIXEL SIZE 052,009
		@ 147,058 SAY dSituaca OF oDlg PIXEL SIZE 120,009 FONT oBold  //OS 2852-11 inserido por Jose Maria 
		@ 132,170 BUTTON 'Laudos Procurement' SIZE 070 ,010  FONT oDlg:oFont ACTION (xLaudProc()) OF oDlg PIXEL // Tatiana A. Barbosa - OS 2022/11 - 08/2011
		@ 149,205 BUTTON 'Fechar' SIZE 035 ,010  FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL
		oGet:= MSGetDados():New(038,003,120,250,nOpcx,,,"")
		oGet:Refresh()
		@ 126,002 TO 127,250 LABEL "" OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Aviso("Atencao",cHelpApv,{"Voltar"}) //###"Este pedido nao possui controle de aprovacao."###
	EndIf
	
	dbSelectArea(cAliasSCR)
	dbCloseArea()
	
	If Type( 'aSavHead' ) == 'A'
		aHeader := aClone(aSavHead)
		aCols   := aClone(aSavCols)
		N		:= nSavN
	EndIf
	
Else
	Aviso("Atencao",cHelpApv,{"Voltar"}) //###"Este Documento nao possui controle de aprovacao."###
EndIf

dbSelectArea(cAlias)
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³xUserMed  ³ Autor ³ Carlos Tagliaferri Jr.³ Data ³ Jun/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta usuario que incluiu a medicao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xUserMed()

Local aArea 	:= GetArea()
Local cNome		:= "", cNextAlias := GetNextAlias()
Local cCodigo	:= "", cSql := "", cMsg1 := ""

SC7->( DbSetOrder(1), DbSeek(xFilial("SC7") + cA120Num) )

If Empty( SC7->C7_CONTRA )
	cCodigo := SC7->C7_USER
	cMsg1   := "Nome do Usuário da Inclusão: "
Else
	// CNB_X_GTEC -> Gestor Tecnico [ SIX(1): CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_PRODUT ]
	// SC7        ->                          C7_CONTRA +C7_CONTREV+C7_PLANILH+C7_PRODUTO
	
	cSql := " SELECT DISTINCT CNB_X_GTEC "
	cSql += " FROM "+RetSqlName('CNB')
	cSql += " WHERE CNB_FILIAL = '"+xFilial('CNB')+"' "
	cSql += " AND   CNB_CONTRA = '"+SC7->C7_CONTRA+"' "
	cSql += " AND   CNB_REVISA = '"+SC7->C7_CONTREV+"' "
	cSql += " AND   CNB_NUMERO = '"+SC7->C7_PLANILH+"' "
	cSql += " AND   CNB_PRODUT = '"+SC7->C7_PRODUTO+"' "
	cSql += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cSql, cNextAlias )
	
	(cNextAlias)->( DbGoTop() )
	
	cCodigo := Posicione("SAK",1,xFilial("SAK")+(cNextAlias)->CNB_X_GTEC, "AK_USER"  )
	
	If Empty( cCodigo )
		
		Aviso("GESTOR TECNICO NAO PREENCHIDO","A planilha referente à esta medição("+SC7->C7_MEDICAO+") não possui gestor técnico.",;
		{"&Fechar"},3,"Planilha sem Gestor Tecnico",,;
		"PCOLOCK")
		
	EndIf
	
	cMsg1   := "Nome do Gestor Técnico: "

EndIf

cNome := UsrFullName(cCodigo)

Aviso(cMsg1,Alltrim(cCodigo)+" - "+Alltrim(cNome),{'OK'})

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³xLaudProc  ³ Autor ³ Tatiana A. Barbosa    ³ Data ³ Jul/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta dos Laudos incluidos na aprovação do PC           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ 				                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xLaudProc()      

Local MsgLau := ""    
Local _Enter := Chr(10)+Chr(13)
Local _CrNum := SCR->CR_NUM
Local _Tipo	 := Alltrim(SCR->CR_TIPO)  
Local nXY	 := 1
Local nXZ	 := 0
Local cQuery := ""
Local cNextAlias := GetNextAlias()

cQuery    := "SELECT R_E_C_N_O_ AS REGSCR, * "
cQuery    += "FROM "+RetSqlName("SCR")+" SCR "
cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
cQuery    += "SCR.CR_NUM = '"+Padr(_CrNum,Len(_CrNum))+"' AND "
cQuery    += "SCR.CR_TIPO = 'PC' AND "
cQuery    += "SCR.D_E_L_E_T_=' ' "

U_MontaView( cQuery, cNextAlias )
	
(cNextAlias)->( DbGoTop() )

// OS 2458-11
While !(cNextAlias)->( Eof() )
	nXZ := PadL(nXY,2,"0")
	SCR->( DbGoTo( (cNextAlias)->REGSCR ) )
	If !Empty(SCR->CR_X_LAUDO) //.And. SCR->CR_X_TPLIB=="S" 
			MsgLau += "----- Laudo Aprov. " + nXZ + " -----" + _Enter + SCR->CR_X_LAUDO + _Enter
	EndIf
	nXY++
	(cNextAlias)->(DbSkip())	
EndDo

/*
For nXY := 1 to Len(aCols)
	nXZ := PadL(nXY,2,"0")
	SCR->(dbSeek(XFILIAL("SCR")+_Tipo+_CrNum+nXZ))
		If !Empty(SCR->CR_X_LAUDO) //.And. SCR->CR_X_TPLIB=="S" - OS 2458-11
			MsgLau += "----- Laudo Aprov. " + nXZ + " -----" + _Enter + SCR->CR_X_LAUDO + _Enter
		EndIf
Next 
*/
If Empty(MsgLau)
	MsgAlert("Não existem laudos cadastrados.")
Else
	MsgInfo( MsgLau ,"LAUDOS")
EndIf

(cNextAlias)->(DbCloseArea())

Return()