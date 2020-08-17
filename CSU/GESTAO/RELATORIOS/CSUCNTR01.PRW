#INCLUDE "RWMAKE.CH"
#INCLUDE "CNTR010.CH"
#INCLUDE "PROTHEUS.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTR010  ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 03.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Contratos                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Cust³23/05/06³      ³Nome da funcao convertida para xxxxxR3    ³±±
±±³odio        ³        ³      ³para criacao de novo relario de acordo com³±±
±±³            ³        ³      ³a classe TReport                          ³±±
±±³Carlos Tagl ³19/12/06³      ³Personalizacao CSU. Inclusao do campo     ³±±
±±³iaferri Jr  ³        ³      ³CN9_X_SOLI-Solicitante.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSUCNTR01()
Local cMens := ""
Local nOpca := 0

Private cTitRel := OemToAnsi(STR0001) //Contratos
Private lEnd	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajustar perguntas do SX1									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Contrato de:                                 ³
//³ mv_par02     // Contrato ate:                                ³
//³ mv_par03     // Revisao de                                   ³
//³ mv_par04     // Revisao ate                                  ³
//³ mv_par05     // Vigencia de:                                 ³
//³ mv_par06     // Vigencia ate:                                ³
//³ mv_par07     // Situacao de:                                 ³
//³ mv_par08     // Situacao ate:                                ³
//³ mv_par09     // Fornecedor de:                               ³
//³ mv_par10     // Fornecedor ate:                              ³
//³ mv_par11     // Tipo de Contrato ?                           ³
//³ mv_par12     // Exibir Caucoes ? - Sim/Nao                   ³
//³ mv_par13     // Exibir Fornecedores ? - Sim/Nao              ³
//³ mv_par14     // Exibir Planilha ? - Sim/Nao                  ³
//³ mv_par15     // Exibir Cronograma ? - Sim/Nao                ³
//³ mv_par16     // Exibir Multas/Bonificacoes? - Sim/Nao        ³
//³ mv_par17     // Exibir Medicoes ? - Sim/Nao                  ³
//³ mv_par18     // Exibir Textos do Contrato ? - Sim/Nao        |
//| mv_par19     // Exibir Detalhes da Medicao ? - Sim/Nao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("CNR010",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela de configuracao do Relatorio							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi(STR0001) PIXEL    //"Contratos"
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi(STR0002) SIZE 268, 8 OF oDlg PIXEL    //"Este programa ira emitir uma relacao de contratos exibindo"
@ 38, 15 SAY OemToAnsi(STR0003) SIZE 268, 8 OF oDlg PIXEL    //"seus caucoes, fornecedores, planilhas, multas e medicoes"
@ 48, 15 SAY OemToAnsi(STR0004) SIZE 268, 8 OF oDlg PIXEL    //"referentes aos contrato selecionados."
DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte("CNR010",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento do Relatorio									        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|lEnd| CNR010Imp(@lEnd)})

EndIf	

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CNR010IMP³ Autor ³ Marcos V. Ferreira    ³ Data ³ 03.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CNR010Imp(lEnd)
Local cAliasTOP := CriaTrab(Nil, .F.)
Local cQuery	:= ""
Local cSeek		:= ""
Local aStrucCN8 := {}
Local aStrucCN9 := {}
Local nX		:= 0
Local cDirSpool := GetMv("MV_RELT")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera Picture dos Campos								           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPtVIGE	:= PesqPict("CN9","CN9_VIGE")
Local cPtMINCAU := PesqPict("CN9","CN9_MINCAU")
Local cPtVLINI  := PesqPict("CN9","CN9_VLINI")
Local cPtVLATU  := PesqPict("CN9","CN9_VLATU")
Local cPtSALDO  := PesqPict("CN9","CN9_SALDO")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont06	:= TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)
Local oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Local oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas pelo Objeto TMSPrinter					     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nlin	:= 2900
Private nPagina := 0
Private oPrint
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Objeto TMSPrinter								           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint	:= TMSPrinter():New(OemToAnsi(STR0001)) //"Contratos"
oPrint	:SetPortrait()	//-- Retrato
oPrint	:Setup() 		//-- Configurar Impressao
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query do Contrato											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStrucCN9 := CN9->(dbStruct())
cQuery := "SELECT DISTINCT CN9_NUMERO, CN9_REVISA, CN9_DTINIC, CN9_SITUAC, CN9_DTFIM, CN9_DTPROP, "
cQuery += "CN9_DTASSI, CN9_DTENCE, CN9_CONDPG, CN9_TPCTO, CN9_DTULST, CN9_VIGE, CN9_INDICE, CN9_X_SOLI, "
cQuery += "CN9_FLGCAU, CN9_MINCAU, CN9_FLGREJ, CN9_REVATU, CN9_VLINI, CN9_VLATU, CN9_SALDO, "
cQuery += "CN9_CODOBJ, CN9_CODCLA, CN9_CODJUS, CN9_UNVIGE "
cQuery += "FROM " + RetSqlName("CN9") + " CN9 
cQuery += "LEFT JOIN " + RetSqlName("CNC") + " CNC ON CN9.CN9_NUMERO = CNC.CNC_NUMERO "
cQuery += "WHERE "
cQuery += "CN9_FILIAL = '"		+	xFilial("CN9")	+ "' AND "
cQuery += "CNC_FILIAL = '"		+	xFilial("CNC")	+ "' AND "
cQuery += "CN9_NUMERO >= '"		+	mv_par01		+ "' AND "
cQuery += "CN9_NUMERO <= '"		+	mv_par02		+ "' AND "
cQuery += "CN9_REVISA >= '"		+	mv_par03		+ "' AND "
cQuery += "CN9_REVISA <= '"		+	mv_par04		+ "' AND "
cQuery += "CN9_DTINIC >= '"		+	dtos(mv_par05)	+ "' AND "
cQuery += "CN9_DTFIM  <= '"		+	dtos(mv_par06)	+ "' AND "
cQuery += "CN9_SITUAC >= '"		+	mv_par07		+ "' AND "
cQuery += "CN9_SITUAC <= '"		+	mv_par08		+ "' AND "
cQuery += "CNC_CODIGO >= '"		+	mv_par09		+ "' AND "
cQuery += "CNC_CODIGO <= '"		+	mv_par10		+ "' AND "
cQuery += "CN9_TPCTO = '"		+	mv_par11		+ "' AND "
cQuery += "CN9.D_E_L_E_T_ = '' AND "
cQuery += "CNC.D_E_L_E_T_ = '' "
cQuery += "ORDER BY CN9_NUMERO, CN9_REVISA "

cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTOP,.F.,.T.)},OemToAnsi(STR0022)) //-- Processando

For nX := 1 to Len(aStrucCN9)
	If aStrucCN9[nX,2] != 'C' .And. FieldPos(aStrucCN9[nx,1]) > 0
		TCSetField(cAliasTop,aStrucCN9[nX,1], aStrucCN9[nX,2],aStrucCN9[nX,3],aStrucCN9[nX,4])
	EndIf	
Next nX

dbSelectArea(cAliasTop)
SetRegua(LastRec())

Do While !Eof()
	If lEnd
		CNRBox(0050,2350,OemToAnsi(STR0034),,.T.,1) //-- CANCELADO PELO OPERADOR
		Exit
	EndIf

	IncProc()

	nLin := 2900 //-- Forca a Quebra da pagina por Contrato
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Contrato				      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//-- Cabecalho Contrato
	CNRBox(0050,2350,Upper(OemToAnsi(Substr(STR0001,1,8)))+" : "+(cAliasTop)->CN9_NUMERO,,.T.,1)
	//-- Numero do Contrato
	CNRBox(0050,0800,RetTitle("CN9_NUMERO"),(cAliasTop)->CN9_NUMERO,.F.)
	//-- Revisao
	CNRBox(0805,1200,RetTitle("CN9_REVISA"),(cAliasTop)->CN9_REVISA,.F.)
	//-- Data Inicio
	CNRBox(1205,1500,RetTitle("CN9_DTINIC"),dtoc((cAliasTop)->CN9_DTINIC),.F.)
	//-- Situacao
	CNRBox(1505,2350,RetTitle("CN9_SITUAC"),CNR010Sit((cAliasTop)->CN9_SITUAC),.T.)
	//-- Data Final
	CNRBox(0050,0800,RetTitle("CN9_DTFIM"),dtoc((cAliasTop)->CN9_DTFIM),.F.)
	//-- Data da Proposta
	CNRBox(0805,1200,RetTitle("CN9_DTPROP"),dtoc((cAliasTop)->CN9_DTPROP),.F.)
	//-- Data Assinatura
	CNRBox(1205,1500,RetTitle("CN9_DTASSI"),dtoc((cAliasTop)->CN9_DTASSI),.F.)
	//-- Data de Encerramento
	CNRBox(1505,2350,RetTitle("CN9_DTENCE"),dtoc((cAliasTop)->CN9_DTENCE),.T.)
	//-- Condicao de Pagamento
	CNRBox(0050,1500,RetTitle("CN9_CONDPG"),(cAliasTop)->CN9_CONDPG + " - " + Posicione("SE4",1,xFilial("SE4")+(cAliasTop)->CN9_CONDPG,"E4_DESCRI"),.F.)
	//-- Tipo do Documento
	CNRBox(1505,2350,RetTitle("CN9_TPCTO"),(cAliasTop)->CN9_TPCTO + " - " + Posicione("CN1",1,xFilial("CN1")+(cAliasTop)->CN9_TPCTO,"CN1_DESCRI"),.T.)
	//-- Data do ultimo status
	CNRBox(0050,0500,RetTitle("CN9_DTULST"),dtoc((cAliasTop)->CN9_DTULST),.F.)
	//-- Vigencia (Dias/Meses/Anos)                                                                                           
	CNRBox(0505,900,RetTitle("CN9_VIGE"),Transform((cAliasTop)->CN9_VIGE,cPtVIGE) + " - " +IIf((cAliasTop)->CN9_UNVIGE == "1",OemToAnsi(STR0017),IIf((cAliasTop)->CN9_UNVIGE=="2",OemToAnsi(STR0018),OemToAnsi(STR0019))),.F.)
	//-- Indice
	CNRBox(0905,1200,RetTitle("CN9_INDICE"),(cAliasTop)->CN9_INDICE + " - " + Posicione("CN6",1,xFilial("CN6")+(cAliasTop)->CN9_INDICE,"CN6_DESCRI"),.F.)
	//-- Solicitante
   	CNRBox(1205,2350,RetTitle("CN9_X_SOLI"),(cAliasTop)->CN9_X_SOLI,.T.)
	//-- Caucao (Sim/Nao)
	CNRBox(0050,0800,RetTitle("CN9_FLGCAU"),IIf((cAliasTop)->CN9_FLGCAU=="1",OemToAnsi(STR0020),OemToAnsi(STR0021)),.F.)
	//-- Porcentagem Caucao
	CNRBox(0805,1200,RetTitle("CN9_MINCAU"),TransForm((cAliasTop)->CN9_MINCAU,cPtMINCAU) + "%",.F.)
	//-- Reajuste (Sim/Nao)
	CNRBox(1205,1500,RetTitle("CN9_FLGREJ"),IIf((cAliasTop)->CN9_FLGREJ=="1",OemToAnsi(STR0020),OemToAnsi(STR0021)),.F.)
	//-- Revisao Atual
	CNRBox(1505,2350,RetTitle("CN9_REVATU"),(cAliasTop)->CN9_REVATU,.T.)
	//-- Valor Inicial
	CNRBox(0050,0800,RetTitle("CN9_VLINI"),TransForm((cAliasTop)->CN9_VLINI,cPtVLINI),.F.)
	//-- Valor Atual
	CNRBox(0805,1200,RetTitle("CN9_VLATU"),TransForm((cAliasTop)->CN9_VLATU,cPtVLATU),.F.)
	//-- Saldo
	CNRBox(1205,2350,RetTitle("CN9_SALDO"),TransForm((cAliasTop)->CN9_SALDO,cPtSALDO),.T.)

	nLin += 50 //-- Salta Linha
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos MEMO: Objeto, Clausulas e Justificativa  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par18 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Texto do Objeto do Contrato					       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		nTotLinha := MlCount(MSMM((cAliasTop)->CN9_CODOBJ))
		nTotLinha := MlCount((cAliasTop)->CN9_CODOBJ)
		CNRBox(0050,2350,OemToAnsi(STR0023),,.T.,1) //-- Cabecalho OBJETO
		For nX := 1 To nTotLinha
			CNRBox(0100,Nil,MemoLine(MSMM((cAliasTop)->CN9_CODOBJ),,nX),,.T.,4,oFont10)
		Next nX
	    If nTotLinha == 0
			CNRBox(0100,0100,OemToAnsi(STR0040),,.T.,4) //-- EM BRANCO
	    EndIf

		nLin += 50 //-- Salta linha

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Texto de Clausulas do Contrato					      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		nTotLinha := MlCount(MSMM((cAliasTop)->CN9_CODCLA))
		nTotLinha := MlCount((cAliasTop)->CN9_CODCLA)
		CNRBox(0050,2350,OemToAnsi(STR0024),,.T.,1) //-- Cabecalho CLAUSULAS
		For nX := 1 To nTotLinha
			CNRBox(0100,Nil,MemoLine(MSMM((cAliasTop)->CN9_CODCLA),,nX),,.T.,4,oFont10)
		Next nX
	    If nTotLinha == 0
			CNRBox(0100,0100,OemToAnsi(STR0040),,.T.,4) //-- EM BRANCO
	    EndIf

		nLin += 50 //-- Salta linha
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Texto de Justificativas do Contrato				      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		nTotLinha := MlCount(MSMM((cAliasTop)->CN9_CODJUS))
		nTotLinha := MlCount((cAliasTop)->CN9_CODJUS)
		CNRBox(0050,2350,OemToAnsi(STR0025),,.T.,1) //-- Cabecalho JUSTIFICATIVAS
		For nX := 1 To nTotLinha
			CNRBox(0100,Nil,MemoLine(MSMM((cAliasTop)->CN9_CODJUS),,nX),,.T.,4,oFont10)
		Next nXt
	    If nTotLinha == 0
			CNRBox(0100,0100,OemToAnsi(STR0040),,.T.,4) //-- EM BRANCO
	    EndIf

		nLin += 50 //-- Salta linha
	
	EndIf 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Caucoes						 	  		  		            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CNR010Cau((cAliasTop)->CN9_NUMERO,(cAliasTop)->CN9_REVISA)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Fornecedores						 		  		         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CNR010For((cAliasTop)->CN9_NUMERO)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao de Planilhas e Cronogramas							         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CNR010Pla((cAliasTop)->CN9_NUMERO,(cAliasTop)->CN9_REVISA,mv_par14==1, mv_par15==1, mv_par17==1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao das Multas				 							            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	CNR010Mul((cAliasTop)->CN9_NUMERO)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao de Medicoes										               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CNR010Med("",(cAliasTop)->CN9_NUMERO,(cAliasTop)->CN9_REVISA,mv_par17==1 .and. mv_par14 != 1)
 
	
	(cAliasTop)->(dbSkip())
EndDo

//-- Encerra arquivo de Trabalho
dbSelectArea(cAliasTop)
dbCloseArea()

//-- Grava Imagem em Disco
If !Empty(cDirSpool)
	oPrint:SaveAllAsJPEG(cDirSpool+"CNTR010",875,1170,140)
EndIF	

//-- Visualiza antes de Imprimir
oPrint:Preview()  

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNR010CAU³ Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Caucoes								                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Contrato                                 ³±±
±±³          ³ ExpC2 = Codigo da Revisao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010  		                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNR010Cau(cContrato,cRevisa)
Local aAreaAnt	:= GetArea()
Local cSeek		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera Picture dos Campos									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPtVLEFET := PesqPict("CN8","CN8_VLEFET")

Default cContrato := ""
Default cRevisa	  := ""

If !Empty(cContrato)
	If mv_par12 == 1
		dbSelectArea("CN8")
		dbSetOrder(2) //CN8_FILIAL+CN8_CONTRA+CN8_REVISA+CN8_CODIGO
		If MsSeek(cSeek:=xFilial("CN8")+cContrato+cRevisa)
			dbSelectArea("CN8")
			nLin += 50
			CNRBox(050,2350,Upper(OemToAnsi(STR0035)),,.T.,1) //-- Cabecalho CAUCOES
			Do While !Eof() .And. cSeek == CN8_FILIAL+CN8_CONTRA+CN8_REVISA
				//-- Caucao
				CNRBox(0050,1100,OemToAnsi(STR0026),CN8_CODIGO + " - " + Posicione("CN3",1,xFilial("CN3")+CN8->CN8_TPCAUC,"CN3->CN3_DESCRI"),.F.)
				//-- Codigo do Fornecedor
				CNRBox(1105,2350,RetTitle("CN8_FORNECE"),CN8_FORNECE + " - " + Posicione("SA2",1,xFilial("SA2")+CN8->CN8_FORNEC,"SA2->A2_NOME"),.T.)
				//-- Loja do Fornecedor
				CNRBox(0050,0350,RetTitle("CN8_LOJA"),CN8_LOJA,.F.)
				//-- Documento
				CNRBox(0355,0750,RetTitle("CN8_NUMDOC"),CN8_NUMDOC,.F.)
				//-- Data de Entrega
				CNRBox(0755,1050,RetTitle("CN8_DTENT"),DTOC(CN8_DTENT),.F.)
				//-- Data de Inicio
				CNRBox(1055,1550,RetTitle("CN8_DTINVI"),DTOC(CN8_DTINVI),.F.)
				//-- Data Fim
				CNRBox(1555,2350,RetTitle("CN8_DTFIVI"),DTOC(CN8_DTFIVI),.T.)
				//-- Valor Efetivo
				CNRBox(0050,0500,RetTitle("CN8_VLEFET"),TransForm(CN8_VLEFET,cPtVLEFET),.F.)
				//-- Moeda
				CNRBox(0505,1200,RetTitle("CN8_MOEDA"),AllTrim(Str(CN8->CN8_MOEDA,2)) + " - " + SuperGetMv("MV_MOEDA"+AllTrim(Str(CN8->CN8_MOEDA,2)),,""),.F.)
				//-- Emitente
				CNRBox(1205,2350,RetTitle("CN8_EMITEN"),CN8_EMITEN,.T.)

				nLin += 30 //-- Salta Linha

				dbSkip()
			EndDo
		EndIf	
	EndIf
EndIf	

RestArea(aAreaAnt)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNR010For³ Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fornecedores							                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Contrato                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010  		                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNR010For(cContrato)
Local aAreaAnt	:= GetArea()
Local cSeek		:= ""
Local lCabec	:= .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont06	:= TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)

Default cContrato := ""

If !Empty(cContrato)
	If mv_par13 == 1 
		dbSelectArea("CNC")
		dbSetOrder(1)
		If MsSeek(cSeek := xFilial("CNC")+cContrato)
			nLin += 50
			CNRBox(050,2350,Upper(OemToAnsi(STR0036)),,.T.,1) //-- Cabecalho FORNECEDORES
			Do While !Eof() .And. cSeek == CNC->CNC_FILIAL+CNC->CNC_NUMERO
				If CNC_CODIGO < mv_par09 .Or. CNC_CODIGO > mv_par10
					dbSkip()
					Loop
				EndIf
				If lCabec
					CNRBox(0050,0500,RetTitle("CN8_FORNECE"),,.F.,2,oFont06)
					CNRBox(0505,0700,RetTitle("CNC_LOJA"),,.F.,2,oFont06)
					CNRBox(0705,2350,RetTitle("CNC_NOME"),,.T.,2,oFont06)
					lCabec := .F.
				EndIf
				//-- Codigo do Fornecedor
				CNRBox(0050,0500,CNC_CODIGO,,.F.,2,oFont06)
				//-- Loja do Fornecedor
				CNRBox(0505,0700,CNC_LOJA,,.F.,2,oFont06)
				//-- Descricao do Fornecedor
				CNRBox(0705,2350,Posicione("SA2",1,xFilial("SA2")+CNC_CODIGO+CNC_LOJA,"A2_NOME"),,.T.,2,oFont06)
				dbSkip()			
			EndDo
		EndIf
	EndIf
EndIf
	
RestArea(aAreaAnt)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNR010Mul| Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Multas								                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Contrato                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010  		                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNR010Mul(cContrato)
Local aAreaAnt	:= GetArea()
Local cSeek		:= ""
Local lCabec	:= .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes										              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont06	:= TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)

Default cContrato := ""

If !Empty(cContrato)
	If mv_par16 == 1
		dbSelectArea("CNH")
		dbSetOrder(1)
		If MsSeek(cSeek := xFilial("CNC")+cContrato)
			nLin += 50
			CNRBox(050,2350,Upper(OemToAnsi(STR0028)),,.T.,1) //-- Cabecalho MULTAS
			Do While !Eof() .And. cSeek == CNH->CNH_FILIAL+CNH->CNH_NUMERO
				If lCabec
					CNRBox(0050,0800,OemToAnsi(STR0037),,.F.,2,oFont06)
					CNRBox(0805,2350,RetTitle("CN4_DESCRI"),,.T.,2,oFont06)
					lCabec := .F.
				EndIf
				//-- Codigo da Multa
				CNRBox(0050,0800,CNH_CODIGO,,.F.,2,oFont06)
				//-- Descricao da Multa
				CNRBox(0805,2350,Posicione("CN4",1,xFilial("CN4")+CNH->CNH_CODIGO,"CN4_DESCRI"),,.T.,2,oFont06)
				dbSkip()
			EndDo
		EndIf
	EndIf
EndIf	

RestArea(aAreaAnt)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNR010Pla| Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Planilhas							                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Contrato                                 ³±±
±±³          ³ ExpC2 = Codigo da Revisao                                  ³±±
±±³          ³ ExpL3 = Imprime Planilha                                   ³±±
±±³          ³ ExpL4 = Imprime Cronograma                                 ³±±
±±³          ³ ExpL5 = Imprime Medicao                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010 / CNTR020                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNR010Pla(cContrato,cRevisao,lImpPla,lImpCro,lImpMed)
Local aAreaAnt	:= GetArea()
Local cAliasPla := CriaTrab(Nil, .F.)
Local lCabecCro := .T.
Local cSeek		:= ""
Local cSeekCNF  := ""
Local cQuery	:= ""
Local cPlanilha := ""
Local cCronogra := ""
Local aStrucCNA	:= {}
Local nX		:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont06	:= TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera Picture dos Campos									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPtVLTOT1 := PesqPict("CNA","CNA_VLTOT")
Local cPtSALDO1 := PesqPict("CNA","CNA_SALDO")
Local cPtQUANT  := PesqPict("CNB","CNB_QUANT")
Local cPtVLTOT2 := PesqPict("CNB","CNB_VLTOT")
Local cPtVLUNIT := PesqPict("CNB","CNB_VLUNIT")
Local cPtDESC   := PesqPict("CNB","CNB_DESC")
Local cPtVLDESC := PesqPict("CNB","CNB_VLDESC")
Local cPtQTDMED := PesqPict("CNB","CNB_QTDMED")
Local cPtSLDMED := PesqPict("CNB","CNB_SLDMED")

Default cContrato := ""
Default cRevisao  := ""
Default lImpPla	  := .T.
Default lImpCro	  := .T.
Default lImpMed	  := .T. 		

If !Empty(cContrato)

	If lImpPla 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Query da Planilha  									           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aStrucCNA := CNA->(dbStruct())
		cQuery := "SELECT CNA_NUMERO,CNA_FORNEC,CNA_LJFORN,CNA_CRONOG,CNA_DTINI,CNA_VLTOT,CNA_SALDO,CNA_TIPPLA,CNA_DTFIM,CNA_FLREAJ, CNA_CONTRA, CNA_REVISA, "
		cQuery += "CNB_ITEM, CNB_PRODUT, CNB_QUANT, CNB_VLUNIT, CNB_VLTOT, CNB_VLTOT, CNB_DESC, CNB_VLDESC, CNB_QTDMED, CNB_SLDMED "
		cQuery += "FROM " + RetSqlName("CNA") + " CNA "
		cQuery += "LEFT JOIN " + RetSqlName("CNB") + " CNB ON CNA_NUMERO = CNB_NUMERO AND CNA_CONTRA = CNB_CONTRA AND "
		cQuery += "CNA_REVISA = CNB_REVISA "
		cQuery += "WHERE "
		cQuery += "CNA_FILIAL = '"		+	xFilial("CNA")	+ "' AND "
		cQuery += "CNB_FILIAL = '"		+	xFilial("CNB")	+ "' AND "
		cQuery += "CNA_CONTRA = '"		+	cContrato		+ "' AND "
		cQuery += "CNA_REVISA = '"		+	cRevisao		+ "' AND "
		cQuery += "CNB_CONTRA = '"		+	cContrato		+ "' AND "
		cQuery += "CNB_REVISA = '"		+	cRevisao		+ "' AND "
		cQuery += "CNA.D_E_L_E_T_ = '' AND "
		cQuery += "CNB.D_E_L_E_T_ = '' " 
		
		cQuery := ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasPla,.F.,.T.)},OemToAnsi(STR0022)) //Processando
		
		For nX := 1 to Len(aStrucCNA)
			If aStrucCNA[nX,2] != 'C' .And. FieldPos(aStrucCNA[nx,1]) > 0
				TCSetField(cAliasPla,aStrucCNA[nX,1], aStrucCNA[nX,2],aStrucCNA[nX,3],aStrucCNA[nX,4])
			EndIf	
		Next nX
		
		dbSelectArea(cAliasPla)

		Do While (cAliasPla)->(!Eof())
			If Empty(cPlanilha)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Informacoes sobre a Planilha						           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nLin += 50 //-- Salta Linha
				CNRBox(0050,2350,Upper(OemToAnsi(STR0029)),,.T.,1) //-- Cabecalho Planilhas
				//-- Numero da Planilha
				CNRBox(0050,0300,RetTitle("CNA_NUMERO"),(cAliasPla)->CNA_NUMERO,.F.)
				//-- Tipo da Planilha
				CNRBox(0305,1700,RetTitle("CNA_TIPPLA"),(cAliasPla)->CNA_TIPPLA + " - " + Posicione("CNL",1,xFilial("CNL")+(cAliasPla)->CNA_TIPPLA,"CNL_DESCRI"),.F.)
				//-- Valor Total
				CNRBox(1705,2350,RetTitle("CNA_VLTOT"),TransForm((cAliasPla)->CNA_VLTOT,cPtVLTOT1),.T.)
				//-- Codigo do Fornecedor 
				CNRBox(0050,0850,RetTitle("CNA_FORNEC"),(cAliasPla)->CNA_FORNEC,.F.)
				//-- Loja do Fornecedor 
				CNRBox(0855,1000,RetTitle("CNA_LJFORN"),(cAliasPla)->CNA_LJFORN,.F.)
				//-- Data Inicial 
				CNRBox(1005,1400,RetTitle("CNA_DTINI"),DTOC((cAliasPla)->CNA_DTINI),.F.)
				//-- Data Final
				CNRBox(1405,2000,RetTitle("CNA_DTFIM"),DTOC((cAliasPla)->CNA_DTFIM),.F.)
				//-- Saldo
				CNRBox(2005,2350,RetTitle("CNA_SALDO"),TransForm((cAliasPla)->CNA_SALDO,cPtSALDO1),.T.)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cabecalho dos Itens da Planilha						        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				CNRBox(0050,0210,RetTitle("CNB_ITEM"),,.F.,2,oFont06)
				CNRBox(0215,0470,RetTitle("CNB_PRODUT"),,.F.,2,oFont06)
				CNRBox(0475,0680,RetTitle("CNB_QUANT"),,.F.,2,oFont06)
				CNRBox(0685,0980,RetTitle("CNB_VLUNIT"),,.F.,2,oFont06)
				CNRBox(0985,1300,RetTitle("CNB_VLTOT"),,.F.,2,oFont06)
				CNRBox(1305,1480,RetTitle("CNB_DESC"),,.F.,2,oFont06)
				CNRBox(1485,1750,RetTitle("CNB_VLDESC"),,.F.,2,oFont06)
				CNRBox(1755,2050,RetTitle("CNB_QTDMED"),,.F.,2,oFont06)
				CNRBox(2055,2350,RetTitle("CNB_SLDMED"),,.T.,2,oFont06)

				cPlanilha := (cAliasPla)->CNA_NUMERO
				cCronogra := (cAliasPla)->CNA_CRONOG
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao dos Itens da Planilha						        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//-- Item da Planilha
				CNRBox(0050,0210,(cAliasPla)->CNB_ITEM,,.F.,2,oFont06)
				//-- Codigo do Produto
				CNRBox(0215,0470,(cAliasPla)->CNB_PRODUT,,.F.,2,oFont06)
				//-- Quantidade
				CNRBox(0475,0680,TransForm((cAliasPla)->CNB_QUANT,cPtQUANT),,.F.,2,oFont06,.T.)
				//-- Valor Unitario
				CNRBox(0685,0980,TransForm((cAliasPla)->CNB_VLUNIT,cPtVLUNIT),,.F.,2,oFont06,.T.)
				//-- Valor Total
				CNRBox(0985,1300,TransForm((cAliasPla)->CNB_VLTOT,cPtVLTOT2),,.F.,2,oFont06,.T.)
				//-- Desconto
				CNRBox(1305,1480,TransForm((cAliasPla)->CNB_DESC,cPtDESC),,.F.,2,oFont06,.T.)
				//-- Valor do Desconto
				CNRBox(1485,1750,TransForm((cAliasPla)->CNB_VLDESC,cPtVLDESC),,.F.,2,oFont06,.T.)
				//-- Quantidade Medida
				CNRBox(1755,2050,TransForm((cAliasPla)->CNB_QTDMED,cPtQTDMED),,.F.,2,oFont06,.T.)
				//-- Saldo
				CNRBox(2055,2350,TransForm((cAliasPla)->CNB_SLDMED,cPtSLDMED),,.T.,2,oFont06,.T.)

				(cAliasPla)->(dbSkip())
			EndIf

			If !(cPlanilha == (cAliasPla)->CNA_NUMERO)

				If lImpCro
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao dos Cronogramas							           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CNR010Cro(cCronogra,cContrato,cRevisao,lImpCro)
				EndIf	

				If lImpMed
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao das Medicoes								           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CNR010Med(cPlanilha,cContrato,cRevisao,lImpMed)
				EndIf	

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reinicia variaveis para impressao de nova planilha	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cPlanilha := ""
				cCronogra := ""
			EndIf
		EndDo

		//-- Finaliza a query
		(cAliasPla)->(dbCloseArea())
		
	EndIf

EndIf	

RestArea(aAreaAnt)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNR010Cro| Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cronogramas							                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Cronograma                               ³±±
±±³          ³ ExpC2 = Codigo do Contrato                                 ³±±
±±³          ³ ExpC3 = Codigo da Revisao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010 / CNTR020                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNR010Cro(cCronogra,cContrato,cRevisao,lImpCro)
Local aAreaAnt := GetArea()
Local cSeekCNF := ""
Local lCabecCro:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes										              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont06  := TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera Picture dos Campos									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPtVLPREV := PesqPict("CNF","CNF_VLPREV")
Local cPtSALDO2 := PesqPict("CNF","CNF_SALDO")
Local cPtVLREAL := PesqPict("CNF","CNF_VLREAL")

Default cCronogra := ""
Default cContrato := ""
Default cRevisao  := ""
Default lImpCro	  := .T. 	

If !Empty(cContrato) .And. !Empty(cCronogra)

	If lImpCro
		dbSelectArea("CNF")
		dbSetOrder(1) //-- CNF_FILIAL+CNF_NUMERO+CNF_CONTRA+CNF_REVISA
		If MsSeek(cSeekCNF := xFilial("CNF")+cCronogra+cContrato+cRevisao)
			nLin += 50
			lCabecCro := .T.
			CNRBox(050,2350,OemToAnsi(STR0038),,.T.,1) //-- Cabecalho CRONOGRAMA
			Do While !Eof() .And. cSeekCNF == CNF->CNF_FILIAL+CNF_NUMERO+CNF->CNF_CONTRA+CNF->CNF_REVISA
				If lCabecCro
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cabecalho dos Itens do Cronograma					        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CNRBox(0050,0280,RetTitle("CNF_NUMERO"),,.F.,2,oFont06)
					CNRBox(0285,0480,RetTitle("CNF_PARCEL"),,.F.,2,oFont06)
					CNRBox(0485,0680,RetTitle("CNF_COMPET"),,.F.,2,oFont06)
					CNRBox(0685,1050,RetTitle("CNF_VLPREV"),,.F.,2,oFont06)
					CNRBox(1055,1400,RetTitle("CNF_VLREAL"),,.F.,2,oFont06)
					CNRBox(1405,1720,RetTitle("CNF_SALDO"),,.F.,2,oFont06)
					CNRBox(1725,1900,RetTitle("CNF_DTVENC"),,.F.,2,oFont06)
					CNRBox(1905,2120,RetTitle("CNF_PRUMED"),,.F.,2,oFont06)
					CNRBox(2125,2350,RetTitle("CNF_DTREAL"),,.T.,2,oFont06)
					lCabecCro := .F.
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao dos Itens do Cronograma					        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//-- Num. Cronograma
				CNRBox(0050,0280,CNF->CNF_NUMERO,,.F.,2,oFont06)
				//-- Parcela
				CNRBox(0285,0480,CNF->CNF_PARCEL,,.F.,2,oFont06)
				//-- Competencia
				CNRBox(0485,0680,CNF->CNF_COMPET,,.F.,2,oFont06)
				//-- Vl.Prev. Parcela
				CNRBox(0685,1050,TransForm(CNF->CNF_VLPREV,cPtVLPREV),,.F.,2,oFont06,.T.)
				//-- Vl. Realizado
				CNRBox(1055,1400,TransForm(CNF->CNF_VLREAL,cPtVLREAL),,.F.,2,oFont06,.T.)
				//-- Saldo Parcela
				CNRBox(1405,1720,TransForm(CNF->CNF_SALDO,cPtSALDO2),,.F.,2,oFont06,.T.)
				//-- Data de Vencimento
				CNRBox(1725,1900,DTOC(CNF->CNF_DTVENC),,.F.,2,oFont06)
				//-- Dt. Prev. Med.
				CNRBox(1905,2120,DTOC(CNF->CNF_PRUMED),,.F.,2,oFont06)
				//-- Dt. Realizado
				CNRBox(2125,2350,DTOC(CNF->CNF_DTREAL),,.T.,2,oFont06)
				CNF->(dbSkip())
			EndDo
		EndIf
	EndIf
EndIf	
RestArea(aAreaAnt)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNR010Med| Autor ³ Marcos V. Ferreira	| Data ³03/03/06    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Medicoes								                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Planilha                                 ³±±
±±³          ³ ExpC2 = Codigo do Contrato                                 ³±±
±±³          ³ ExpC3 = Codigo da Revisao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010  		                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CNR010Med(cPlanilha,cContrato,cRevisao,lImpMed)
Local aAreaAnt	:= GetArea()
Local cAliasMed := CriaTrab(Nil, .F.)
Local cSeek		:= ""   
Local aStrucCND := {}
Local cQuery	:= ""
Local cMedicao	:= "" 
Local nX		:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont06	:= TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera Picture dos Campos									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPtVLMEAC := PesqPict("CND","CND_VLMEAC")
Local cPtVLSALD := PesqPict("CND","CND_VLSALD")
Local cPtVLTOT1 := PesqPict("CND","CND_VLTOT")
Local cPtQTDSOL := PesqPict("CNE","CNE_QTDSOL")
Local cPtQTAMED := PesqPict("CNE","CNE_QTAMED")
Local cPtQUANT  := PesqPict("CNE","CNE_QUANT")
Local cPtPERC   := PesqPict("CNE","CNE_PERC")
Local cPtVLUNIT := PesqPict("CNE","CNE_VLUNIT")
Local cPtVLTOT2 := PesqPict("CNE","CNE_VLTOT")

Default cContrato := ""
Default cRevisao  := ""
Default cPlanilha := ""
Default lImpMed	  := .T.

If !Empty(cContrato)

	If lImpMed
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Query da Planilha  									           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aStrucCND := CND->(dbStruct())
		cQuery := "SELECT CND_NUMMED, CND_NUMERO, CND_CONTRA, CND_FORNEC, CND_LJFORN,  CND_COMPET, CND_DTVENC, CND_VLMEAC, CND_VLSALD, CND_VLTOT,"
		cQuery += "CNE_ITEM, CNE_PRODUT, CNE_QTDSOL, CNE_QTAMED, CNE_QUANT, CNE_PERC, CNE_VLUNIT, CNE_VLTOT "
		cQuery += "FROM " + RetSqlName("CND") + " CND "
		cQuery += "LEFT JOIN " + RetSqlName("CNE") + " CNE ON CND_NUMERO = CNE_NUMERO AND "
		cQuery += "CND_CONTRA = CNE_CONTRA AND CND_REVISA = CNE_REVISA AND CND_NUMMED = CNE_NUMMED "
		cQuery += "WHERE "
		cQuery += "CND_FILIAL = '"		+	xFilial("CND")	+ "' AND "
		cQuery += "CNE_FILIAL = '"		+	xFilial("CNE")	+ "' AND "
		If !Empty(cPlanilha)
			cQuery += "CND_NUMERO = '"		+	cPlanilha		+ "' AND "
		EndIf
		cQuery += "CND_CONTRA = '"		+	cContrato		+ "' AND "
		cQuery += "CND_REVISA = '"		+	cRevisao		+ "' AND "
		cQuery += "CND.D_E_L_E_T_ = '' AND "
		cQuery += "CNE.D_E_L_E_T_ = '' " 
		
		cQuery := ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasMed,.F.,.T.)},OemToAnsi(STR0022)) //Processando
		
		For nX := 1 to Len(aStrucCND)
			If aStrucCND[nX,2] != 'C' .And. FieldPos(aStrucCND[nx,1]) > 0
				TCSetField(cAliasMed,aStrucCND[nX,1], aStrucCND[nX,2],aStrucCND[nX,3],aStrucCND[nX,4])
			EndIf	
		Next nX
		
		dbSelectArea(cAliasMed)

		Do While (cAliasMed)->(!Eof())

			If Empty(cMedicao)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Informacoes sobre a Medicao						   	     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nLin += 50 //-- Salta Linha
				CNRBox(0050,2350,Upper(OemToAnsi(STR0039)),,.T.,1) //-- Cabecalho MEDICOES
				//-- Numero da Medicao
				CNRBox(0050,0300,RetTitle("CND_NUMMED"),(cAliasMed)->CND_NUMMED,.F.)
				//-- Numero da Planilhao
				CNRBox(0305,0600,RetTitle("CND_NUMERO"),(cAliasMed)->CND_NUMERO,.F.)
				//-- Numero do Contrato
				CNRBox(0605,1000,RetTitle("CND_CONTRA"),(cAliasMed)->CND_CONTRA,.F.)
				//-- Fornecedor                                                                    '
			    CNRBox(1005,1900,RetTitle("CND_FORNEC"),(cAliasMed)->CND_FORNEC + " - " + Posicione("SA2",1,xFilial("SA2")+CND->CND_FORNEC,"SA2->A2_NOME"),.F.)
				//-- Loja Fornecedor
				CNRBox(1905,2000,RetTitle("CND_LJFORN"),(cAliasMed)->CND_LJFORN,.F.)
				//-- Competencia
				CNRBox(2005,2350,RetTitle("CND_COMPET"),(cAliasMed)->CND_COMPET,.T.)
				//-- Data de Vencimento
				CNRBox(0050,0400,RetTitle("CND_DTVENC"),DTOC((cAliasMed)->CND_DTVENC),.F.)
				//-- Medicoes Acumuladas
				CNRBox(0405,1050,RetTitle("CND_VLMEAC"),TransForm((cAliasMed)->CND_VLMEAC,cPtVLMEAC),.F.)
				//-- Saldo da Medicao
				CNRBox(1055,1800,RetTitle("CND_VLSALD"),TransForm((cAliasMed)->CND_VLSALD,cPtVLSALD),.F.)
				//-- Valor Total
				CNRBox(1805,2350,RetTitle("CND_VLTOT"),TransForm((cAliasMed)->CND_VLTOT,cPtVLTOT1),.T.)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cabecalho dos Itens da Medicao						        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				CNRBox(0050,0230,RetTitle("CNE_ITEM"),,.F.,2,oFont06)
				CNRBox(0235,0500,RetTitle("CNE_PRODUT"),,.F.,2,oFont06)
				CNRBox(0505,0800,RetTitle("CNE_QTDSOL"),,.F.,2,oFont06)
				CNRBox(0805,1100,RetTitle("CNE_QTAMED"),,.F.,2,oFont06)
				CNRBox(1105,1400,RetTitle("CNE_QUANT"),,.F.,2,oFont06)
				CNRBox(1405,1700,RetTitle("CNE_PERC"),,.F.,2,oFont06)
				CNRBox(1705,2000,RetTitle("CNE_VLUNIT"),,.F.,2,oFont06)
				CNRBox(2005,2350,RetTitle("CNE_VLTOT"),,.T.,2,oFont06)

				cMedicao := (cAliasMed)->CND_NUMMED
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao dos Itens da Medicao						        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//-- Item da Medicao
				CNRBox(0050,0230,(cAliasMed)->CNE_ITEM,,.F.,2,oFont06)
				//-- Produto
				CNRBox(0235,0500,(cAliasMed)->CNE_PRODUT,,.F.,2,oFont06)
				//-- Quantidade Solicitada
				CNRBox(0505,0800,TransForm((cAliasMed)->CNE_QTDSOL,cPtQTDSOL),,.F.,2,oFont06,.T.)
				//-- Quantidade Medida
				CNRBox(0805,1100,TransForm((cAliasMed)->CNE_QTAMED,cPtQTAMED),,.F.,2,oFont06,.T.)
				//-- Quantidade
				CNRBox(1105,1400,TransForm((cAliasMed)->CNE_QUANT,cPtQUANT),,.F.,2,oFont06,.T.)
				//-- Percentual
				CNRBox(1405,1700,TransForm((cAliasMed)->CNE_PERC,cPtPERC),,.F.,2,oFont06,.T.)
				//-- Valor Unitario
				CNRBox(1705,2000,TransForm((cAliasMed)->CNE_VLUNIT,cPtVLUNIT),,.F.,2,oFont06,.T.)
				//-- Valor Total
				CNRBox(2005,2350,TransForm((cAliasMed)->CNE_VLTOT,cPtVLTOT2),,.T.,2,oFont06,.T.)

				(cAliasMed)->(dbSkip())
			EndIf

			If (cMedicao != (cAliasMed)->CND_NUMMED)
				If mv_par19==1
					//CNTR030Mul (cMedicao,oFont06)
					CNR010Mul (cMedicao,oFont06)
					//CNTR030Desc(cMedicao,oFont06)
					//CNR030Cauc (cMedicao,oFont06)
					CNR010Cau (cMedicao,oFont06)
				EndIf
				dbselectarea("CND")
				cMedicao := ""
			Endif	

		EndDo

		//-- Finaliza a query
		dbSelectArea(cAliasMed)
		(cAliasMed)->(dbCloseArea())

	EndIf
EndIf	

RestArea(aAreaAnt)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNRCabec ³ Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cabecalho padrao para relatorios graficos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Posicao da coluna para impressao do cTexto         ³±±
±±³          ³ ExpC2 = Texto a ser impresso	                             ³±±
±±³          ³ ExpC3 = Titulo do Relatorio                                ³±±
±±³          ³ ExpO4 = Fonte para impressao do cTexto                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010 / CNR020	                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNRCabec(nCol,cTexto,cTitulo,oFontT)
Local cFileLogo	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Local oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)

Default nCol	:= 0
Default cTexto	:= ""
Default cTitulo := ""
Default oFontT  := oFont10

If nLin >= 2900
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabecalho da Pagina					      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPagina++ //-- Variavel Private
	nLin := 200 //-- Variavel private
	oPrint:EndPage() 	//-- Encerra a pagina anterior
	oPrint:StartPage()	//-- Inicia uma nova pagina
	oPrint:Line(50,50,50,2350)
	oPrint:Line(51,51,51,2351)
	oPrint:Line(200,50,200,2350)
	oPrint:Line(201,51,201,2351)
	oPrint:Say(110,1060,Upper(OemToAnsi(cTitulo)),oFont10n) 				//Texto do Cabecalho
	oPrint:Say(065,2000,OemToAnsi(STR0031)	+ StrZero(nPagina,3),oFont10) 	//"Folha....: "
	oPrint:Say(110,2000,OemToAnsi(STR0032)	+ Dtoc(dDataBase),oFont10) 		//"DT.Ref..: "
	oPrint:Say(160,2000,OemToAnsi(STR0033)	+ Dtoc(Date()),oFont10) 		//"Emissao.: "    
	cFileLogo += "LGRL"+SM0->M0_CODIGO+".BMP"
	oPrint:SayBitmap(70,60,cFileLogo,474,117) //-- Logotipo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salta para a proxima linha			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin += 50
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do texto					      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cTexto)
	oPrint:Say(nLin,nCol,cTexto,oFontT)
EndIf	

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNRBox() ³ Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Box para Textos			                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Posicao inicial da coluna para criacao do Box      ³±±
±±³          ³ ExpN2 = Posicao final da coluna para criacao do Box        ³±±
±±³          ³ ExpC3 = Texto da 1a. linha do Box                          ³±±
±±³          ³ ExpC4 = Texto da 2a. linha do Box                          ³±±
±±³          ³ ExpL5 = Quebra para proxima linha apos a impressao do Box  ³±±
±±³          ³         (.T. Com  Quebra / .F. Sem Quebra)                 ³±±
±±³          ³ ExpN6 = Tipo do Box : 									           ³±±
±±³          ³                      1 - Linha de Cabecalho                ³±±
±±³          ³                      2 - Linha Unica Simples               ³±±
±±³          ³                      3 - Linha de Detalhe                  ³±±
±±³          ³                      4 - Somente Texto                     ³±±
±±³          ³ ExpO7 = Fonte para impressao do Texto                      ³±±
±±³          ³ ExpL8 = Se .T. realiza o alinhamento do cTexto1 a Direita. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010  / CNTR020                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNRBox(nCol1,nCol2,cTexto1,cTexto2,lQuebra,nTipo,oFontB,lAlinDir)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Local oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)

Default nCol1	:= 0
Default nCol2	:= 0
Default cTexto1 := ""
Default cTexto2 := ""
Default lQuebra := .T.
Default nTipo   := 3
Default oFontB  := oFont10
Default lAlinDir:= .F.

If nLin >= 2900
	CNRCabec(Nil,Nil,OemToAnsi(cTitRel)) //-- Impressao do Cabecalho da pagina
EndIf

If nTipo == 1  //-- Linha de Cabecalho
	oPrint:Box(nLin,nCol1,nLin+55,nCol2)
	oPrint:Box(nLin+5,nCol1+5,nLin+50,nCol2-5)
	oPrint:Say(nLin+10,((nCol2-nCol1)/2)-((Len(alltrim(cTexto1))/2)*20),cTexto1,oFont10n)
ElseIf nTipo == 2 //-- Linha Unica Simples
	oPrint:Box(nLin,nCol1,nLin+45,nCol2)
	If lAlinDir //-- Alinhamento a Direita
		oPrint:Say(nLin+7,nCol2-5-TamTexto(Alltrim(cTexto1)),AllTrim(cTexto1),oFontB)
	Else 
		oPrint:Say(nLin+7,nCol1+10,cTexto1,oFontB)
	EndIf
ElseIf nTipo == 3 //-- Linha de Detalhe
	oPrint:Box(nLin,nCol1,nLin+100,nCol2)
	oPrint:Say(nLin+10,nCol1+10,cTexto1,oFont10n)
	oPrint:Say(nLin+50,nCol1+10,cTexto2,oFont10)
ElseIf nTipo == 4 //-- Somente Texto
	oPrint:Say(nLin+7,nCol1,cTexto1,oFontB)
EndIf
If lQuebra //-- Quebra Linha
	If nTipo == 1
		nLin += 60	//-- Cabecalho
	ElseIf nTipo == 2
		nLin += 50	//-- Unica Simples
	ElseIf nTipo == 3
		nLin += 110	//-- Detalhe
	ElseIf nTipo == 4 
		nLin += 50 //-- Somente Texto
	EndIf
EndIf	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ TamTexto | Autor ³ Marcos V. Ferreira    ³ Data ³08/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Recupera o tamanho de uma string em pixels                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010 / CNTR020                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TamTexto(cTexto)
Local nSize := 0
Local nx
Local aSize := {{17.241,2.692,15.241,13.692}} 
For nx := 1 to Len(cTexto)
	If Substr(cTexto,nx,1)=="." .Or. Substr(cTexto,nx,1)=="," .or.  Substr(UPPER(cTexto),nx,1)=="I" 
		nSize += aSize[1,2]
	ElseIf Substr(cTexto,nx,1)$"abcdefghijklmnopqrstuvxyzw"
		nSize += aSize[1,4]
	ElseIf Substr(UPPER(cTexto),nx,1)$"ABCDEFGHIJKLMNOPQRSTUVXWYZ""
		nSize += aSize[1,3]
	Else                     
		nSize += aSize[1,1]
	EndIf
Next
Return nSize

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNR010Sit³ Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o tipo da situacao do Contrato                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010  		                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNR010Sit(cTipo)
Local cRet := ""

Default cTipo := ""

cTipo := AllTrim(cTipo)

Do Case
Case cTipo == "01"
	cRet := OemToAnsi(STR0007) //-- 1-Cancelado
Case cTipo == "02"
	cRet := OemToAnsi(STR0008) //-- 2-Elaboracao
Case cTipo == "03"
	cRet := OemToAnsi(STR0009) //-- 3-Emitido
Case cTipo == "04"
	cRet := OemToAnsi(STR0010) //-- 4-Em Aprovacao
Case cTipo == "05"
	cRet := OemToAnsi(STR0011) //-- 5-Vigente
Case cTipo == "06"
	cRet := OemToAnsi(STR0012) //-- 6-Cancelado
Case cTipo == "07"
	cRet := OemToAnsi(STR0013) //-- 7-Solic. Finalizacao
Case cTipo == "08"
	cRet := OemToAnsi(STR0014) //-- 8-Finalizado
Case cTipo == "09"
	cRet := OemToAnsi(STR0015) //-- 9-Revisao
Case cTipo == "10"
	cRet := OemToAnsi(STR0016) //-- 10-Revisado
EndCase

Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AjustaSX1³ Autor ³ Marcos V. Ferreira    ³ Data ³03/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta as perguntas do SX1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010  		                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local cPerg	   := PADR("CNR010" 	,LEN(SX1->X1_GRUPO))

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {"Numero inicial do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"01","Contrato de:","","","mv_ch1","C",15,0,0,"G","","CN9","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor := {"Numero final do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"02","Contrato ate:","","","mv_ch2","C",15,0,0,"G","","CN9","","S","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor := {"Numero inicial da Revisao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"03","Revisao de:","","","mv_ch3","C",3,0,0,"G","","","","S","mv_par03","","","","001","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor := {"Numero final da Revisao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"04","Revisao ate:","","","mv_ch4","C",3,0,0,"G","","","","S","mv_par04","","","","ZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor := {"Data de inicio da Vigencia"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"05","Vigencia de:","","","mv_ch5","D",08,0,0,"G","","","","S","mv_par05","","","","01/01/06","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
aHelpPor := {"Data de termino da Vigencia"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"06","Vigencia ate:","","","mv_ch6","D",08,0,0,"G","","","","S","mv_par06","","","","31/12/49","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR07--------------------------------------------------
aHelpPor := {"Codigo inicial da Situacao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"07","Situacao de:","","","mv_ch7","C",2,0,0,"G","","","","S","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR08--------------------------------------------------
aHelpPor := {"Codigo final da Situacao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"08","Situacao ate:","","","mv_ch8","C",2,0,0,"G","","","","S","mv_par08","","","","99","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR09--------------------------------------------------
aHelpPor := {"Codigo inicial do Fornecedor"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"09","Fornecedor de:","","","mv_ch9","C",6,0,0,"G","","SA2","","S","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR10--------------------------------------------------
aHelpPor := {"Codigo final do Fornecedor"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"10","Fornecedor ate:","","","mv_cha","C",6,0,0,"G","","SA2","","S","mv_par10","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR11--------------------------------------------------
aHelpPor := {"Codigo do Tipo de Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"11","Tipo de Contrato ?","","","mv_chb","C",3,0,0,"G","","CN1","","S","mv_par11","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR12--------------------------------------------------
aHelpPor := {"Utilizada para exibir os Caucoes","do Contrato (Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"12","Exibir Caucoes ?","","","mv_chc","N",1,0,1,"C","","","","","mv_par12","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR13--------------------------------------------------
aHelpPor := {"Utilizada para exibir os Fornecedores","do Contrato (Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"13","Exibir Fornecedores ?","","","mv_chd","N",1,0,1,"C","","","","","mv_par13","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR14--------------------------------------------------
aHelpPor := {"Utilizada para exibir as Planilhas ","do Contrato (Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"14","Exibir Planilha ?","","","mv_che","N",1,0,1,"C","","","","","mv_par14","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR15--------------------------------------------------
aHelpPor := {"Utilizada para exibir os Cronogramas","do Contrato (Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"15","Exibir Cronograma ?","","","mv_chf","N",1,0,1,"C","","","","","mv_par15","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR16--------------------------------------------------
aHelpPor := {"Utilizada para exibir as Multas ","do Contrato (Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"16","Exibir Multas/Bonificacoes?","","","mv_chg","N",1,0,1,"C","","","","","mv_par16","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR17--------------------------------------------------
aHelpPor := {"Utilizada para exibir as Medicoes ","do Contrato (Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"17","Exibir Medicoes ?","","","mv_chh","N",1,0,1,"C","","","","","mv_par17","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR18--------------------------------------------------
aHelpPor := {"Permite exibir os campos Objeto,","Clausulas e Justificativas do Contrato","(Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"18","Exibir Textos do Contrato ?","","","mv_chi","N",1,0,1,"C","","","","","mv_par18","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR19--------------------------------------------------
aHelpPor := {"Permite exibir os Valores ","de Multas/Bonificacoes,Caucoes Retidas","e Descontos do Contrato (Sim/Nao)"}
aHelpEng := {""}
aHelpSpa := {""}

PutSx1(cPerg,"19","Exibir Detalhes da Medicao ?","","","mv_chj","N",1,0,1,"C","","","","","mv_par19","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aAreaAnt)
Return

/*----------Versao TReport-------------*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTR010  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Contratos - Convertido com base no fonte da rotina CNTR010R3³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CNTR010( )

If  FindFunction("TRepInUse") .And. TRepInUse()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01     // Contrato de:                                 ³
	//³ mv_par02     // Revisao de                                   ³
	//³ mv_par03     // Vigencia de:                                 ³
	//³ mv_par04     // Vigencia ate:                                ³
	//³ mv_par05     // Situacao de:                                 ³
	//³ mv_par06     // Fornecedor de:                               ³
	//³ mv_par07     // Tipo de Contrato ?                           ³
	//³ mv_par08     // Exibir Caucoes ? - Sim/Nao                   ³
	//³ mv_par09     // Exibir Fornecedores ? - Sim/Nao              ³
	//³ mv_par10     // Exibir Planilha ? - Sim/Nao                  ³
	//³ mv_par11     // Exibir Cronograma ? - Sim/Nao                ³
	//³ mv_par12     // Exibir Multas ? - Sim/Nao                    ³
	//³ mv_par13     // Exibir Medicoes ? - Sim/Nao                  ³
	//³ mv_par14     // Exibir Textos do Contrato ? - Sim/Nao        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("CNR011",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa definicao do relatorio           			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	oReport := ReportDef()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime relatorio                        			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	oReport:PrintDialog()
	
Else	
	Return CNTR010R3() // Executa versão anterior do fonte
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ReportDef³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define a configuracao do relatorio de contratos            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSectCab// Sessao Cabecalho
Local oSectPla// Sessao Planilhas
Local oSectItm// Sessao Itens de Planilhas
Local oSectCac// Sessao Caucoes
Local oSectFrn// Sessao Fornecedores
Local oSectCro// Sessao Cronograma
Local oSectMul// Sessao Multas
Local oSectMed// Sessao Medicoes
Local oSectIMe// Sessao Itens de medicoes

oReport := TReport():New("CNTR030",OemToAnsi(STR0001),"CNR011",{|oReport| CR010Imp(oReport)},"Imprime relatorio de contratos")

oSectCab := TRSection():New(oReport,OemToAnsi(STR0001),{"CN9","SE4","CN1"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do contrato                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oSectCab,"CN9_NUMERO","CN9")
TRCell():New(oSectCab,"CN9_REVISA","CN9")
TRCell():New(oSectCab,"CN9_SITUAC","CN9",,,,,{|| QA_CBox("CN9_SITUAC",AllTrim(QRYCN9->CN9_SITUAC))})
TRCell():New(oSectCab,"CN9_DTFIM","CN9")
TRCell():New(oSectCab,"CN1_DESCRI","CN1","Tipo")
TRCell():New(oSectCab,"CN9_VLATU","CN9")
TRCell():New(oSectCab,"CN9_SALDO","CN9")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fornecedores                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectFrn := TRSection():New(oSectCab,OemToAnsi(STR0041),{"CNC","SA2"})
TRCell():New(oSectFrn,"CNC_CODIGO","CNC")
TRCell():New(oSectFrn,"CNC_LOJA","CNC")
TRCell():New(oSectFrn,"A2_NOME","SA2",RetTitle("CNC_NOME"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Multas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectMul := TRSection():New(oSectCab,OemToAnsi(STR0042),{"CNH","CN4"})
TRCell():New(oSectMul,"CNH_CODIGO","CNH")
TRCell():New(oSectMul,"CN4_DESCRI","CN4")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caucoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCac := TRSection():New(oSectCab,OemToAnsi(STR0043),{"CN8","CN3"})
TRCell():New(oSectCac,"CN8_CODIGO","CN8")
TRCell():New(oSectCac,"CN3_DESCRI","CN3")
TRCell():New(oSectCac,"CN8_FORNECE","CN8")
TRCell():New(oSectCac,"CN8_LOJA","CN8")
TRCell():New(oSectCac,"CN8_NUMDOC","CN8")
TRCell():New(oSectCac,"CN8_DTINVI","CN8")
TRCell():New(oSectCac,"CN8_DTFIVI","CN8")
TRCell():New(oSectCac,"CN8_MOEDA","CN8")
TRCell():New(oSectCac,"CN8_EMITEN","CN8")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho das Planilhas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectPla := TRSection():New(oSectCab,OemToAnsi(STR0044),{"CNA","CNL"})
TRCell():New(oSectPla,"CNA_NUMERO","CNA")
TRCell():New(oSectPla,"CNL_DESCRI","CNL","Tipo")
TRCell():New(oSectPla,"CNA_FORNEC","CNA")
TRCell():New(oSectPla,"CNA_LJFORN","CNA")
TRCell():New(oSectPla,"CNA_VLTOT","CNA")
TRCell():New(oSectPla,"CNA_SALDO","CNA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Itens das planilhas                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectItm := TRSection():New(oSectPla,OemToAnsi(STR0045),{"CNB"})
TRCell():New(oSectItm,"CNB_ITEM","CNB")
TRCell():New(oSectItm,"CNB_PRODUT","CNB")
TRCell():New(oSectItm,"CNB_QUANT","CNB")
TRCell():New(oSectItm,"CNB_VLUNIT","CNB")          						 	 
TRCell():New(oSectItm,"CNB_VLTOT","CNB")
TRCell():New(oSectItm,"CNB_DESC","CNB")
TRCell():New(oSectItm,"CNB_VLDESC","CNB")
TRCell():New(oSectItm,"CNB_QTDMED","CNB")
TRCell():New(oSectItm,"CNB_SLDMED","CNB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cronogramas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCro := TRSection():New(oSectPla,OemToAnsi(STR0046),{"CNF"})
TRCell():New(oSectCro,"CNF_NUMERO","CNF")
TRCell():New(oSectCro,"CNF_PARCEL","CNF")
TRCell():New(oSectCro,"CNF_COMPET","CNF")
TRCell():New(oSectCro,"CNF_VLPREV","CNF")
TRCell():New(oSectCro,"CNF_VLREAL","CNF")
TRCell():New(oSectCro,"CNF_SALDO","CNF")
TRCell():New(oSectCro,"CNF_DTVENC","CNF")
TRCell():New(oSectCro,"CNF_PRUMED","CNF")
TRCell():New(oSectCro,"CNF_DTREAL","CNF")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho das Medicoes                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectMed := TRSection():New(oSectCab,OemToAnsi(STR0047),{"CND"})
TRCell():New(oSectMed,"CND_NUMMED","CND")
TRCell():New(oSectMed,"CND_NUMERO","CND")
TRCell():New(oSectMed,"CND_FORNEC","CND")
TRCell():New(oSectMed,"CND_LJFORN","CND")
TRCell():New(oSectMed,"CND_COMPET","CND")
TRCell():New(oSectMed,"CND_VLTOT","CND")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Itens de Medicoes                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectIMe := TRSection():New(oSectMed,OemToAnsi(STR0048),{"CNE"})
TRCell():New(oSectIMe,"CNE_ITEM","CNE")
TRCell():New(oSectIMe,"CNE_PRODUT","CNE")
TRCell():New(oSectIMe,"CNE_QTDSOL","CNE")
TRCell():New(oSectIMe,"CNE_QUANT","CNE")
TRCell():New(oSectIMe,"CNE_VLUNIT","CNE")
TRCell():New(oSectIMe,"CNE_VLTOT","CNE")


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Imp  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa impressao do relatorio de contratos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto principal do relatorio - TReport           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CR010Imp(oReport)
Local oSectCab := oReport:Section(1)//Cabecalho do contrato
Local oSectFrn := oReport:Section(1):Section(1)//Fornecedores
Local oSectMul := oReport:Section(1):Section(2)//Multas
Local oSectCac := oReport:Section(1):Section(3)//Caucoes
Local oSectPla := oReport:Section(1):Section(4)//Cabecalho da planilha
Local oSectItm := oReport:Section(1):Section(4):Section(1)//Itens de Planilhas
Local oSectCro := oReport:Section(1):Section(4):Section(2)//Cronogramas
Local oSectMed := oReport:Section(1):Section(5)//Medicoes
Local oSectIMe := oReport:Section(1):Section(5):Section(1)//Itens de Medicoes
Local lFstCNA  := .T.
Local lFstCND  := .T.
Local nTotLinha
Local nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura perguntas do tipo Range                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
MakeSqlExpr("CNR011")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Cabecalho                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
CR010Cab(oSectCab)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Imprime Fornecedores                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR09 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Fornecedores do contrato                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CR010Frn(oSectFrn)
Else
	oSectFrn:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Imprime Planilhas                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR10 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Planilhas e Itens                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CR010Pla(oSectPla)
	CR010Itm(oSectItm)
         
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se Imprime Cronogramas                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If MV_PAR11 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime cronogramas                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CR010Cro(oSectCro)
	Else
		oSectCro:Disable()
	EndIf
Else
	oSectCro:Disable()
	oSectItm:Disable()
	oSectPla:Disable()
EndIf
       	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Imprime Caucoes                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR08 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Caucoes                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CR010Cac(oSectCac)
Else
	oSectCac:Disable()
EndIf
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Imprime Multas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR12 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Multas do contrato                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CR010Mul(oSectMul)
Else
	oSectMul:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Imprime Medicoes                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR13 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Medicoes                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CR010Med(oSectMed)
	CR010IMe(oSectIMe)
Else
	oSectMed:Disable()
	oSectIMe:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa relatorio                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCab:Init()
While !QRYCN9->(Eof())
	If oReport:Cancel()
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime cabecalho do contrato                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSectCab:PrintLine()
   
   If MV_PAR14 == 1
	   oReport:SkipLine()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Texto do Objeto do Contrato   						   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODOBJ))
		CR010Box(oReport,STR0023)
		For nX := 1 To nTotLinha
			oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODOBJ),,nX))
			oReport:SkipLine()
		Next nX
	   If nTotLinha == 0
			oReport:PrintText(OemToAnsi(STR0040))
	   EndIf
	   oReport:SkipLine()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Texto de Clausulas do Contrato					      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODCLA))
		CR010Box(oReport,STR0024)
		For nX := 1 To nTotLinha
			oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODCLA),,nX))
			oReport:SkipLine()
		Next nX
	   If nTotLinha == 0
			oReport:PrintText(OemToAnsi(STR0040))
	   EndIf
	   oReport:SkipLine()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Texto de Justificativas do Contrato				      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   
		nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODJUS))
		CR010Box(oReport,STR0025)
		For nX := 1 To nTotLinha
			oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODJUS),,nX))
			oReport:SkipLine()
		Next nX
	   If nTotLinha == 0
			oReport:PrintText(OemToAnsi(STR0040))
	   EndIf
	   oReport:SkipLine()
   EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime listagem de fornecedores                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oSectFrn:lEnabled 
		oReport:SkipLine()
		oReport:SkipLine()
		CR010Box(oReport,OemToAnsi(STR0049)+QRYCN9->CN9_NUMERO+If(!Empty(QRYCN9->CN9_REVISA),"/"+QRYCN9->CN9_REVISA,""))
		oSectFrn:Print()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime listagem de multas do contrato             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oSectMul:lEnabled 
		oReport:SkipLine()
		oReport:SkipLine()
		CR010Box(oReport,OemToAnsi(STR0050)+QRYCN9->CN9_NUMERO+If(!Empty(QRYCN9->CN9_REVISA),"/"+QRYCN9->CN9_REVISA,""))
		oSectMul:Print()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime caucoes do contrato                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oSectCac:lEnabled
		oReport:SkipLine()
		oReport:SkipLine()
		CR010Box(oReport,OemToAnsi(STR0051)+QRYCN9->CN9_NUMERO+If(!Empty(QRYCN9->CN9_REVISA),"/"+QRYCN9->CN9_REVISA,""))
		oSectCac:Print()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime planilhas/itens/cronogramas                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oSectPla:lEnabled
		oSectPla:Init()
		lFstCNA := .T.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Percorre planilhas de acordo com o filtro da sessao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !QRYCNA->(Eof())//eval(oSectPla:bParentFilter,eval(oSectPla:bParentParam))
			If QRYCNA->CNA_CONTRA > QRYCN9->CN9_NUMERO .OR. QRYCNA->CNA_REVISA > QRYCN9->CN9_REVISA
				Exit
			EndIf
			If QRYCNA->CNA_CONTRA == QRYCN9->CN9_NUMERO .And. QRYCNA->CNA_REVISA == QRYCN9->CN9_REVISA
				oReport:SkipLine()
				oReport:SkipLine()
				CR010Box(oReport,OemToAnsi(STR0052)+QRYCN9->CN9_NUMERO+If(!Empty(QRYCN9->CN9_REVISA),"/"+QRYCN9->CN9_REVISA,""))
				If !lFstCNA
					oSectPla:PrintHeader()
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime cabecalho da planilha                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSectPla:PrintLine()
				lFstCNA := .F.
				oReport:SkipLine()
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime itens da planilha                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSectItm:Print()
				oReport:SkipLine()
				oReport:SkipLine()
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime cronograma da planilha                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				CR010Box(oReport,OemToAnsi(STR0053)+QRYCNA->CNA_NUMERO)
				oSectCro:Print()
			EndIf
			QRYCNA->(dbSkip())
		EndDo
		oSectPla:Finish()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime medicoes do contrato                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oSectMed:lEnabled
		oSectMed:Init()
		lFstCND := .T.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Percorre medicoes de acordo com o filtro da sessao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !QRYCND->(Eof())
			If QRYCND->CND_CONTRA > QRYCN9->CN9_NUMERO .OR. QRYCND->CND_REVISA > QRYCN9->CN9_REVISA
				Exit
			EndIf
			If QRYCND->CND_CONTRA == QRYCN9->CN9_NUMERO .OR. QRYCND->CND_REVISA == QRYCN9->CN9_REVISA
				oReport:SkipLine()
				oReport:SkipLine()
				CR010Box(oReport,OemToAnsi(STR0054)+QRYCN9->CN9_NUMERO+If(!Empty(QRYCN9->CN9_REVISA),"/"+QRYCN9->CN9_REVISA,""))
				
				If !lFstCND
					oSectMed:PrintHeader()
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime cabecalho da medicao                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSectMed:PrintLine()
				lFstCND := .F.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime itens da medicao                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSectIMe:Print()
				oReport:SkipLine()
			EndIf
			QRYCND->(dbSkip())
		EndDo
		
	EndIf
	
	QRYCN9->(dbSkip())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pula pagina quando houver contrato                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !QRYCN9->(Eof())
		oReport:EndPage()
	EndIf
EndDo

oSectCab:Finish()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Box  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime box com texto centralizado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CR010Box(oExp01,cExp02)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto do relatorio                               ³±±
±±³          ³ cExp02 - Texto impresso                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Box(oReport,cTexto)
Local nCol1 := 7
Local nCol2 := oReport:PageWidth()-40

oReport:Box(oReport:Row()-10,2,oReport:Row()+38,oReport:PageWidth()-35)
oReport:Box(oReport:Row()-5,nCol1,oReport:Row()+33,nCol2)
oReport:PrintText(cTexto,oReport:Row(),((nCol2-nCol1)/2)-((Len(alltrim(cTexto))/2)*20))
oReport:SkipLine()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Cab  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao do cabecalho de contratos                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao do cabecalho - TRSection                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Cab(oSectCab)
Local cPart := "%%"

If !Empty(mv_par07)
	cPart := "%AND CN9_TPCTO = '"+mv_par07+"'%"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro dos contratos                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCab:BeginQuery()
BeginSql alias "QRYCN9"
SELECT DISTINCT CN9_NUMERO,CN9_REVISA,CN9_DTINIC,CN9_SITUAC,CN9_DTFIM,CN9_DTPROP,CN9_DTASSI,CN9_DTENCE,CN9_CONDPG,CN9_TPCTO,CN9_DTULST,CN9_VIGE,CN9_INDICE,CN9_FLGCAU,CN9_MINCAU,CN9_FLGREJ,CN9_REVATU,CN9_VLINI,CN9_VLATU,CN9_SALDO,CN9_CODOBJ,CN9_CODCLA,CN9_CODJUS,CN9_UNVIGE
FROM %table:CN9% CN9, %table:CNC% CNC
WHERE CN9_FILIAL = %xfilial:CN9% AND
CNC_FILIAL = %xfilial:CNC% AND
CNC_NUMERO = CN9_NUMERO AND
CN9_DTINIC >= %exp:dtos(mv_par03)% AND
CN9_DTFIM  <= %exp:dtos(mv_par04)% AND
CN9.%notDel% AND
CNC.%notDel% %exp:cPart%

ORDER BY CN9_NUMERO, CN9_REVISA
EndSql

oSectCab:EndQuery({MV_PAR01,MV_PAR02,MV_PAR05,MV_PAR06})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura posicionamento das tabelas filhas        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSectCab,"SE4",1,"xFilial() + QRYCN9->CN9_CONDPG")//Cond. Pagto
TRPosition():New(oSectCab,"CN1",1,"xFilial() + QRYCN9->CN9_TPCTO")//Tipo de Contrato
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Pla  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao do cabecalho de planilhas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao do cabecalho - TRSection                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Pla(oSectPla)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CNA_CONTRA")
Local cRevisa:=Replace(mv_par02,"CN9_REVISA","CNA_REVISA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro das planilhas                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectPla:BeginQuery()

BeginSql alias "QRYCNA"
SELECT CNA_NUMERO,CNA_FORNEC,CNA_LJFORN,CNA_CRONOG,CNA_DTINI,CNA_VLTOT,CNA_SALDO,CNA_TIPPLA,CNA_DTFIM,CNA_FLREAJ, CNA_CONTRA, CNA_REVISA
FROM %table:CNA% CNA WHERE
CNA_FILIAL = %xfilial:CNA% AND
CNA.%notDel%
ORDER BY CNA_CONTRA,CNA_REVISA,CNA_NUMERO
EndSql
                           
oSectPla:EndQuery({cContra,cRevisa})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com os contratos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectPla:SetParentFilter({|aParam| QRYCNA->CNA_CONTRA == aParam[1] .AND. QRYCNA->CNA_REVISA == aParam[2]},{|| {QRYCN9->CN9_NUMERO,QRYCN9->CN9_REVISA}})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura posicionamento das tabelas filhas        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSectPla,"CNL",1,"xFilial() + QRYCNA->CNA_TIPPLA")//Tipos de Tabelas
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Itm  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao dos itens de planilhas                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao dos itens - TRSection                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Itm(oSectItm)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CNB_CONTRA")
Local cRevisa:=Replace(mv_par02,"CN9_REVISA","CNB_REVISA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro dos itens de planilhas        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectItm:BeginQuery()
BeginSql alias "QRYCNB"
SELECT CNB_ITEM, CNB_PRODUT, CNB_QUANT, CNB_VLUNIT, CNB_VLTOT, CNB_VLTOT, CNB_DESC, CNB_VLDESC, CNB_QTDMED, CNB_SLDMED, CNB_CONTRA, CNB_REVISA, CNB_NUMERO
FROM %table:CNB% CNB
WHERE
CNB_FILIAL = %xfilial:CNB% AND
CNB.%notDel%
ORDER BY CNB_CONTRA,CNB_REVISA,CNB_NUMERO,CNB_ITEM
EndSql
oSectItm:EndQuery({cContra,cRevisa})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com as planilhas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectItm:SetParentFilter({|aParam| QRYCNB->CNB_CONTRA == aParam[1] .AND. QRYCNB->CNB_REVISA == aParam[2] .AND. QRYCNB->CNB_NUMERO == aParam[3]},{|| {QRYCN9->CN9_NUMERO,QRYCN9->CN9_REVISA,QRYCNA->CNA_NUMERO}})
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Cro  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao dos cronogramas                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao dos cronogramas - TRSection                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Cro(oSectCro)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CNF_CONTRA")
Local cRevisa:=Replace(mv_par02,"CN9_REVISA","CNF_REVISA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro dos cronogramas               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCro:BeginQuery()	
BeginSql alias "QRYCNF"
SELECT CNF.*
FROM %table:CNF% CNF WHERE
CNF.%notDel%
ORDER BY CNF_CONTRA,CNF_REVISA,CNF_NUMERO,CNF_PARCEL
EndSql
                           
oSectCro:EndQuery({cContra,cRevisa})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com as planilhas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCro:SetParentFilter({|aParam| QRYCNF->CNF_CONTRA == aParam[1] .And. QRYCNF->CNF_REVISA == aParam[2] .And. QRYCNF->CNF_NUMERO == aParam[3]},{|| {QRYCN9->CN9_NUMERO,QRYCN9->CN9_REVISA,QRYCNA->CNA_CRONOG}})
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Cac  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao das caucoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao das caucoes  - TRSection                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Cac(oSectCac)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CN8_CONTRA")
Local cRevisa:=Replace(mv_par02,"CN9_REVISA","CN8_REVISA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro das caucoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCac:BeginQuery()	
BeginSql alias "QRYCN8"
SELECT CN8.*
FROM %table:CN8% CN8 WHERE
CN8_FILIAL = %xfilial:CN8% AND
CN8.%notDel%
ORDER BY CN8_CONTRA,CN8_REVISA,CN8_CODIGO
EndSql
                           
oSectCac:EndQuery({cContra,cRevisa})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com os contratos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectCac:SetParentFilter({|aParam| QRYCN8->CN8_CONTRA == aParam[1] .AND. QRYCN8->CN8_REVISA == aParam[2]},{|| {QRYCN9->CN9_NUMERO,QRYCN9->CN9_REVISA}})
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Frn  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao dos fornecedores de contratos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao dos fornecedores - TRSection               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Frn(oSectFrn)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CNC_NUMERO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro dos fornecedores              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectFrn:BeginQuery()	
BeginSql alias "QRYCNC"
SELECT CNC.*
FROM %table:CNC% CNC WHERE
CNC_FILIAL = %xfilial:CNC% AND
CNC.%notDel%
ORDER BY CNC_NUMERO,CNC_CODIGO,CNC_LOJA
EndSql
                           
oSectFrn:EndQuery(cContra)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com os contratos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectFrn:SetParentFilter({|cParam| QRYCNC->CNC_NUMERO == cParam },{|| QRYCN9->CN9_NUMERO})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura posicionamento das tabelas filhas        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSectFrn,"SA2",1,"xFilial() + QRYCNC->CNC_CODIGO + QRYCNC->CNC_LOJA")//Fornecedores
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Mul  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao das multas de contratos                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao dos multas - TRSection                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Mul(oSectMul)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CNH_NUMERO")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro das multas                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectMul:BeginQuery()	
BeginSql alias "QRYCNH"
SELECT CNH.*
FROM %table:CNH% CNH WHERE
CNH_FILIAL = %xfilial:CNH% AND
CNH.%notDel%
ORDER BY CNH_NUMERO,CNH_CODIGO
EndSql
                           
oSectMul:EndQuery(cContra)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com os contratos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectMul:SetParentFilter({|cParam| QRYCNH->CNH_NUMERO == cParam },{|| QRYCN9->CN9_NUMERO})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura posicionamento das tabelas filhas        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSectMul,"CN4",1,"xFilial() + QRYCNH->CNH_CODIGO")//Tipos de Multas
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010Med  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao dos cabecalhos de medicao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao do cabecalho de medicao - TRSection        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010Med(oSectMed)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CND_CONTRA")
Local cRevisa:=Replace(mv_par02,"CN9_REVISA","CND_REVISA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro das medicoes                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectMed:BeginQuery()	
BeginSql alias "QRYCND"
SELECT CND_NUMMED, CND_NUMERO, CND_CONTRA, CND_REVISA, CND_FORNEC, CND_LJFORN,  CND_COMPET, CND_DTVENC, CND_VLMEAC, CND_VLSALD, CND_VLTOT
FROM %table:CND% CND WHERE
CND_FILIAL = %xfilial:CND% AND
CND.%notDel%
ORDER BY CND_CONTRA,CND_REVISA,CND_NUMMED
EndSql
                           
oSectMed:EndQuery({cContra,cRevisa})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com os contratos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectMed:SetParentFilter({|aParam| QRYCND->CND_CONTRA == aParam[1] .And. QRYCND->CND_REVISA == aParam[2]},{|| {QRYCN9->CN9_NUMERO,QRYCN9->CN9_REVISA}})
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CR010IMe  ³ Autor ³ Marcelo Custodio      ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura sessao dos itens de medicoes                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR010Imp                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Sessao dos itens de medicoes - TRSection          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CR010IMe(oSectIMe)
Local cContra:=Replace(mv_par01,"CN9_NUMERO","CNE_CONTRA")
Local cRevisa:=Replace(mv_par02,"CN9_REVISA","CNE_REVISA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera query de filtro dos itens de medicoes         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectIMe:BeginQuery()	
BeginSql alias "QRYCNE"
SELECT CNE_ITEM, CNE_CONTRA, CNE_REVISA, CNE_NUMMED, CNE_PRODUT, CNE_QTDSOL, CNE_QTAMED, CNE_QUANT, CNE_PERC, CNE_VLUNIT, CNE_VLTOT
FROM %table:CNE% CNE WHERE
CNE_FILIAL = %xfilial:CNE% AND
CNE.%notDel%
ORDER BY CNE_CONTRA,CNE_REVISA,CNE_NUMMED,CNE_ITEM
EndSql
                           
oSectIMe:EndQuery({cContra,cRevisa})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura filtro de relacionamento com as medicoes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSectIMe:SetParentFilter({|aParam| QRYCNE->CNE_CONTRA == aParam[1] .And. QRYCNE->CNE_REVISA == aParam[2] .And. QRYCNE->CNE_NUMMED == aParam[3]},{|| {QRYCN9->CN9_NUMERO,QRYCN9->CN9_REVISA,QRYCND->CND_NUMMED}})
Return