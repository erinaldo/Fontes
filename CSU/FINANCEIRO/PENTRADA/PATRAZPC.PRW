#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#Include 'TopConn.ch'
#Define _cEnter Chr(13) + Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PATrazPC  ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³04/07/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina chamada pela Consulta Específica SC7PA, que filtra  ³±±
±±³          ³ e exibe uma lista de Pedidos de Compras válidos para vin-  ³±±
±±³          ³ culação ao PA digitado, que tem de ser do mesmo fornecedor,³±±
±±³          ³ ter o mesmo valor do PA e não ter outro PA já vinculado    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nTraz: 1=Mostra o Browse com os PCs e valida os PCs.       ³±±
±±³          ³        2=Não mostra, somente valida os PCS                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SCU                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PATrazPC(nTraz)

Local nSldPed    := 0
Local nOpc       := 0
Local nx         := 0
Local cQuery     := ""
Local cAliasSC7  := "SC7"
Local lQuery     := .F.
Local bSavSetKey := SetKey(VK_F4,Nil)
Local bSavKeyF5  := SetKey(VK_F5,Nil)
Local bSavKeyF6  := SetKey(VK_F6,Nil)
Local bSavKeyF7  := SetKey(VK_F7,Nil)
Local bSavKeyF8  := SetKey(VK_F8,Nil)
Local bSavKeyF9  := SetKey(VK_F9,Nil)
Local bSavKeyF10 := SetKey(VK_F10,Nil)
Local bSavKeyF11 := SetKey(VK_F11,Nil)
Local bWhile
Local cChave     := ""
Local cCadastro  := ""
Local aArea      := GetArea()
Local aAreaSA2   := SA2->(GetArea())
Local aStruSC7   := SC7->(dbStruct())
Local aF4For     := {}
Local nF4For     := 0
Local oOk        := LoadBitMap(GetResources(), "LBOK")
Local oNo        := LoadBitMap(GetResources(), "LBNO")
Local aButtons   := { {'PESQUISA',{||A103VisuPC(aRecSC7[oListBox:nAt])},"Visualiza Pedido","Visualiza Pedido2"} }
Local oDlg,oListBox
Local cNomeFor   := ''
Local aRecSC7    := {}
Local aTitCampos := {}
Local aConteudos := {}
Local aUsCont    := {}
Local aUsTitu    := {}
Local bLine      := { || .T. }
Local cLine      := ""
Local nLoop      := 0
Local lRet103Vpc := .T.
Local lContinua  := .T.
Local cCdFornec	 := M->E2_FORNECE
Local cLjFornec	 := M->E2_LOJA
Local cRet		 := ""
Local aF4Clone	 := {} 
Local lAchou	 := .F.
DEFAULT nTraz	 := 1

dbSelectArea("SA2")
dbSetOrder(1)
MsSeek(xFilial()+cCdFornec+cLjFornec)
cNomeFor	:= SA2->A2_NOME

dbSelectArea("SC7")
SC7->( dbSetOrder( 9 ) )
lQuery    := .T.
cAliasSC7 := "SC7PA"

cQuery := "SELECT SC7.*, R_E_C_N_O_ RECSC7, "+_cEnter
cQuery +=        "((C7_QUANT-C7_QUJE) * C7_PRECO) SALDO "+_cEnter
cQuery +=   "FROM "+_cEnter
cQuery +=   RetSqlName("SC7") + " SC7 "+_cEnter
cQuery +=  "WHERE "+_cEnter
cQuery +=        "SC7.C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND SC7.D_E_L_E_T_ = ' ' "+_cEnter
cQuery +=    "AND C7_FORNECE='"+M->E2_FORNECE+"' "+_cEnter
cQuery +=    "AND C7_LOJA='"+M->E2_LOJA+"' "+_cEnter
cQuery +=    "AND C7_CONAPRO='L' "+_cEnter
cQuery +=    "AND C7_ENCER<>'E' "+_cEnter
cQuery +=    "AND (SC7.C7_QUANT-SC7.C7_QUJE)>0 "+_cEnter
cQuery += "ORDER BY " + SqlOrder( SC7->( IndexKey() ) )+_cEnter

cQuery := ChangeQuery(cQuery)

If Select(cAliasSC7)>0
	(cAliasSC7)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

For nX := 1 To Len(aStruSC7)
	If aStruSC7[nX,2]<>"C"
		TcSetField(cAliasSC7,aStruSC7[nX,1],aStruSC7[nX,2],aStruSC7[nX,3],aStruSC7[nX,4])
	EndIf
Next nX

(cAliasSC7)->(dbGoTop())
bWhile := {|| (cAliasSC7)->(!Eof())}

While Eval(bWhile)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se nao h  residuos  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( Empty((cAliasSC7)->C7_RESIDUO) .And. (cAliasSC7)->C7_TPOP <> "P" )
		nF4For := aScan(aF4For,{|x|x[2]==(cAliasSC7)->C7_LOJA .And. x[3]==(cAliasSC7)->C7_NUM})
		If ( nF4For == 0 )
			aConteudos := {.F.,(cAliasSC7)->C7_LOJA,(cAliasSC7)->C7_NUM,DTOC((cAliasSC7)->C7_EMISSAO),IIF((cAliasSC7)->C7_TIPO==2,"AE","PC"), (cAliasSC7)->SALDO, (cAliasSC7)->RECSC7 }
			aadd(aF4For, aConteudos )
		Else
			aF4For[nF4For][6] += (cAliasSC7)->SALDO
		EndIf
	EndIf
	
	(cAliasSC7)->(dbSkip())
EndDo

If lQuery
	If Select(cAliasSC7)>0
		(cAliasSC7)->(dbCloseArea())
	EndIf
Endif

For _nI:=1 to Len(aF4For)
	
	cQuery := " SELECT SUM(E2_VALOR) VALOR "+_cEnter
	cQuery +=   " FROM "+RetSqlName("SE2")+" TSE2 "+_cEnter
	cQuery +=  " WHERE D_E_L_E_T_<>'*' AND E2_FILIAL='"+xFilial("SE2")+"' "+_cEnter
	cQuery +=    " AND E2_TIPO='PA' "+_cEnter
	cQuery +=    " AND E2_NUMPC='"+aF4For[_nI][3]+"' "+_cEnter
	cQuery +=    " AND E2_FORNECE='"+M->E2_FORNECE+"' "+_cEnter
	cQuery +=    " AND E2_LOJA='"+M->E2_LOJA+"' "+_cEnter

	cQuery := ChangeQuery(cQuery)

	If Select("E2TMP")>0
		E2TMP->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"E2TMP",.T.,.T.)

	E2TMP->(dbGoTop())
	If !E2TMP->(EOF().AND.BOF())
		TcSetField("E2TMP","VALOR","N",16,2)
		aF4For[_nI][6] -= E2TMP->VALOR
		E2TMP->(dbCloseArea())
	EndIf
	
Next _nI
	
aF4Clone := aClone(aF4For)
aF4For	 := {}
For _nI:=1 to Len(aF4Clone)
	If aF4Clone[_nI][6]>=M->E2_VALOR 
		aAdd(aF4For, aF4Clone[_nI])
		aAdd(aRecSC7,aF4Clone[_nI][7])
	EndIf
Next _nI

If nTraz==1		// Consulta específica do campo E2_NUMPC

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe os dados na Tela                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( !Empty(aF4For) )
		
		aTitCampos := {" ","Loja","Pedido","Emissao","Origem","Saldo" }
		
		cLine := '{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],'+;
		'aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],Transform(aF4For[oListBox:nAT][6],"@E 9999,999,999.99")'
		
		cLine += " } "
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta dinamicamente o bline do CodeBlock                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		bLine := &( "{ || " + cLine + " }" )
		
		DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi("Selecionar Pedido de Compra - <F5> ") Of oMainWnd PIXEL
		
		oListBox := TWBrowse():New( 27,4,243,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aF4For)
		oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
		oListBox:bLine := bLine
		
		@ 15  ,4   SAY OemToAnsi("Fornecedor") Of oDlg PIXEL SIZE 47 ,9
		@ 14  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oDlg PIXEL SIZE 120,9
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)
		
		If ( nOpc == 1 )
			For nx	:= 1 to Len(aF4For)
				If aF4For[nx][1]
					SC7->(dbGoTo(aF4For[nx][7]))
					M->E2_NUMPC := SC7->C7_NUM
					Exit
				EndIf
			Next nx
		EndIf
		
	Else
		Help(" ",1,"A103F4")
	EndIf
	
Else 
    // Validação do campo E2
	For _nI:=1 to Len(aF4For)
		If aF4For[_nI][3]==M->E2_NUMPC .And. aF4For[_nI][6]>=M->E2_VALOR
			lAchou:=.T.
		EndIf
	Next _nI
	If !lAchou
		Aviso("A T E N Ç Ã O!","Este Pedido de Compras não é válido para este PA!",{"Fechar"},3)
		Return(.F.)
	Else
		Return(.T.)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados de Entrada              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)

RestArea(aAreaSA2)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103VisuPC³ Autor ³ Daniel G.Jr.TI1239   ³ Data ³17/07/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama a rotina de visualizacao dos Pedidos de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Dicionario de Dados - Campo:D1_TOTAL                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A103VisuPC(nRecSC7)

Local aArea			:= GetArea()
Local aAreaSC7		:= SC7->(GetArea())
Local cSavCadastro	:= cCadastro
Local nBack         := n
PRIVATE nTipo 		:= 1
PRIVATE cCadastro	:= "Consulta ao Pedido de Compra"
PRIVATE l120Auto	:= .F.
PRIVATE aBackSC7  	:= {}  //Sera utilizada na visualizacao do pedido - MATA120

dbSelectArea("SC7")
MsGoto(nRecSC7)

A120Pedido(Alias(),RecNo(),2)
n := nBack
cCadastro	:= cSavCadastro
RestArea(aAreaSC7)
RestArea(aArea)

Return .T.
