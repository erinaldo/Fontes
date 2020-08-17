#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TBICONN.CH"
#Include 'TopConn.ch'
#Define _cEnter Chr(13) + Chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CSUCTB12 ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ 29/06/07   	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Manutenção de Provisionamentos Contábeis                     	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Específico CSU                                               	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³  DATA    ³  O.S.   ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Daniel G.Jr  ³ 06/01/09 ³ 3017/08 ³ Inclusão da gravação de histórico de     ³±±
±±³              ³          ³         ³ ocorrências                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Douglas David ³ 09/06/15 ³ 1564/14 ³ Correção de Query para realizar validação³±±
±±³                                     corretamente. Contemplando OS 2552/14    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSUCTB12()

Local nPos      := 0
Private aRotina	:= {{ "Pesquisar"	, "AxPesqui"   , 0, 1 },;
{ "Visualizar" 	, "U_ProvManut", 0, 2 },;
{ "Incluir"		, "U_ProvManut", 0, 3 },;
{ "Alterar"		, "U_ProvManut", 0, 4 },;
{ "Excluir"		, "U_ProvManut", 0, 5 },;    
{ "LOG - Desflegue", "U_LogDesf", 0, 4 },;
{ "Desflegue Prov", "U_DesflegP", 0, 4 },;
{ "Contabilizar", "U_ProvContab(1)", 0, 4 },;
{ "Estornar"	, "U_ProvContab(2)", 0, 4 },;
{ "Imprimir"	, "U_ProvImpri", 0, 4 },;
{ "Legenda"		, "U_ProvLegen", 0, 2 }}

Private aCores    := { 	{ 'Empty(ZB1_DTLCTO).And. Empty(ZB1_DTESTO).And.ZB1_SLDEST==0.And.Empty(ZB1_PCEXC) .And. ZB1_CONFER<>"S"'	, 'ENABLE'		},;	// Provisao Aberta
{ '!Empty(ZB1_DTLCTO).And. ZB1_SLDEST==0.And.Empty(ZB1_PCEXC) .And. ZB1_CONFER<>"S"'		, 'BR_AZUL'		},;	// Provisao Contabilizada
{ 'ZB1_SLDEST<>ZB1_VALDOC.And.ZB1_SLDEST<>0.And.Empty(ZB1_PCEXC) .And. ZB1_CONFER<>"S"'		, 'BR_CINZA'	},;	// Provisao parcialmente Estornada
{ '!Empty(ZB1_PCEXC) .And. ZB1_SLDEST<>ZB1_VALDOC .And. ZB1_CONFER<>"S"'					, 'BR_PRETO'	},;	// Provisao com PC Excluido
{ 'ZB1_CONFER == "S" '		 																, 'BR_BRANCO'	},; // Provissao Off-Line // 130317 - Eduardo Dias
{ '!Empty(ZB1_PCEXC) .And. ZB1_SLDEST==ZB1_VALDOC .And. ZB1_CONFER<>"S"'					, 'DISABLE'		},;	// Provisao com PC Excluido - Estornada		 //Incluido por Tatiana Barbosa em 18/02/10
{ 'ZB1_SLDEST==ZB1_VALDOC .And. ZB1_CONFER<>"S"'											, 'DISABLE'		}}	// Provisao Estornada

PRIVATE cCadastro	:= "Manutenção de Provisão"
PRIVATE aBackZB2    := {}	// ABACKSD1
Private lExec	   	:= .F.
Private cEol        := Chr(13)+Chr(10)

//Atualiza dicionário - OS 2965/16 - Eduardo Dias
AtuDci()

ChkFile("ZB2")
dbSelectArea("ZB2")
ChkFile("ZB1")
dbSelectArea("ZB1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Interface com o usuario via Mbrowse                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(6,1,22,75,"ZB1",,,,,,aCores)

Return(.T.)

/*/                                                                  
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ProvManut ³ Autor ³ Daniel G.Jr.TI1239   ³ Data ³28/06/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Incl/Alter/Excl/Visu.de Provisionamento Contbl.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ProvManut(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUCTB12                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ProvManut(cAlias,nReg,nOpcx)

// Variaveis Locais da Funcao
Local nRecZB1	 := 0
Local nOpc		 := 0
//Local nUsado	 := 0
Local nX         := 0
Local nY         := 0
Local nCounterZB2:= 0

Local aObjects	 := {}
Local aInfo 	 := {}
Local aPosGet	 := {}
Local aPosObj	 := {}
Local aSizeAut	 := {}
Local aButVisual := {}
Local aButtons	 := {}
Local aRecClasZB2:= {}

Local cCadastro	 := "Provisão"
Local cQuery     := ""
Local cAliasZB2  := "ZB2"
Local cVarFoco   := "     "
Local cIndex     := ""
Local cCond      := ""

Local oDlg

Local bCabOk     := {|| .T.}
Local bWhileZB2  := {|| .T.}
Local bSaida     := { |lF0| lF0 }

Local cBlqProv	 := Alltrim(GetMv("MV_PROVBLQ"))

// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private aCabPC := {}
Private aItePC := {}
Private aSldPC := {}
Private cTheme := Upper(Alltrim(GetTheme()))
Private lPrima := .T.

Private aStruZB2   	:= {}
Private aRecZB2	 	:= {}
Private nPosNPCEZ   := 0
Private nPosCusEZ   := 0
Private nPosPerEZ   := 0
Private nPosValEZ   := 0
Private nPosDesEZ   := 0
Private nPosClaEZ   := 0
Private nPosIteEZ   := 0
Private nPosNatEZ	:= 0
Private nPosContr	:= 0
Private cCtaNatur	:= " "
Private nVlDocume	:= 0
Private nVlSldPC 	:= 0
Private nPercTot	:= 0
Private nValTot	 	:= 0
Private nPercFalt	:= 0
Private nValFalta	:= 0

Private lContinua   := .T.
Private lProvInclui := .F.
Private lProvExclui := .F.
Private lProvAltera := .F.
Private lQuery      := .F.
Private lProcGet    := .T.

PRIVATE lProvVisual	:= .F.
PRIVATE n          	:= 1
PRIVATE aCols	   	:= {}
PRIVATE aHeader    	:= {}

PRIVATE oGetDados
PRIVATE oFocoProv
PRIVATE bGDRefresh 	:= {|| IIf(oGetDados<>Nil,(oGetDados:oBrowse:Refresh()),.F.) }		// Efetua o Refresh da GetDados
PRIVATE nUsado	 	:= 0
PRIVATE cCdFornec	 := " "
PRIVATE cLjFornec	 := " "
PRIVATE cAprovAnt	 := "N"
PRIVATE cCompeten	 := " "
PRIVATE dEmDocume	 := CtoD(" ")
PRIVATE dVcDocume	 := CtoD(" ")
PRIVATE cNomUsuar	 := UsrFullName(__CUserID)	// usrretname
PRIVATE cNrContra	 := " "
PRIVATE cNrDocume	 := " "
PRIVATE cNrPedCom	 := " "
PRIVATE cProvisao	 := " "
PRIVATE dLctConta	 := CtoD(" ")
PRIVATE cHistoric	 := Space(40)
PRIVATE dDtDigita	 := dDataBase
PRIVATE aCpoAlt		 := {}
PRIVATE nGetMethod
PRIVATE oDtDigita
PRIVATE oAprovAnt
PRIVATE odLctConta
PRIVATE oHistoric
PRIVATE oCdFornec
PRIVATE oCompeten
PRIVATE oEmDocume
PRIVATE oVcDocume
PRIVATE oLjFornec
PRIVATE oNomUsuar
PRIVATE oNrContra
PRIVATE oNrDocume
PRIVATE oNrPedCom
PRIVATE oPercTot
PRIVATE oValTot
PRIVATE oPercFalt
PRIVATE oValFalta
PRIVATE oVlDocume
PRIVATE oProvisao
PRIVATE lF0 := .F.
PRIVATE aCpoEnchoice:={}

Define Font oBoldIV  Name  "Arial"  Size 07 , -13 BOLD

lWhenGet   := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case aRotina[nOpcx][4] == 2
		lProvVisual := .T.
		VISUAL := .T.
		
	Case aRotina[nOpcx][4] == 3
		If cBlqProv == "Desbloqueado"               		//Alterado por Tatiana Barbosa em 23/08/10 - OS 2104/10
			lProvInclui	:= .T.
			INCLUI := .T.
		Else
			MsgAlert("A inclusão de provisões foi bloqueada pelo departamento contábil. Tente novamente mais tarde.","Função Bloqueada")		   //Alterado por Tatiana Barbosa em 23/08/10 - OS 2104/10
			lProvInclui	:= .F.
			INCLUI := .F.
			Return()
		EndIf
		
	Case aRotina[nOpcx][4] == 4    						  //Alterado por Tatiana Barbosa em 23/08/10 - OS 2104/10
		If cBlqProv == "Desbloqueado"
			lProvAltera	:= .T.
			ALTERA := .T.
		Else
			MsgAlert("A alteração de provisões foi bloqueada pelo departamento contábil. Tente novamente mais tarde.","Função Bloqueada")	     //Alterado por Tatiana Barbosa em 23/08/10 - OS 2104/10
			lProvAltera	:= .F.
			ALTERA := .F.
			Return()
		EndIf
		
	Case aRotina[nOpcx][4] == 5
		If cBlqProv == "Desbloqueado"					//Alterado por Tatiana Barbosa em 23/08/10 - OS 2104/10
			lProvExclui	:= .T.
			VISUAL := .T.
		Else
			MsgAlert("A exclusão de provisões foi bloqueada pelo departamento contábil. Tente novamente mais tarde.","Função Bloqueada")  		//Alterado por Tatiana Barbosa em 23/08/10 - OS 2104/10
			lProvExclui	:= .F.
			VISUAL := .F.
			Return()
		EndIf
		
	OtherWise
		lProvVisual := .T.
		VISUAL := .T.
EndCase

If INCLUI
	aAdd(aButtons, {'PEDIDO',{||TrazPC()},OemToAnsi( "Selecionar Pedido de Compra - <F5> "),"Pedidos"} )
	SetKey(VK_F5,{||TrazPC()})
	aAdd(aButtons, {'PEDIDO2',{||TrazItPC()},OemToAnsi("Selecionar Pedido de Compra ( por item ) - <F6> "),"Itens de Pedidos"} )
	SetKey(VK_F6,{||TrazItPC()})
	aAdd(aButtons, {'PMSSETAUP',{||FazRateio()},OemToAnsi("Executar o Rateio Externo - <F7> "),"Rateio Externo"} )
	SetKey(VK_F7,{||FazRateio()})
	
	//VG - 2011.01.18 - Botão para o carregamento da Tabela de Rateios
	aAdd(aButtons, {'BMPTRG',{||CarrTabRat()},OemToAnsi("Carregar Tabela de Rateios - <F8> "),"Tabela Rateios"} )
	SetKey(VK_F8,{||CarrTabRat()})
EndIf

nRecZB1	 := IIF(INCLUI,0,ZB1->(RecNo()))

// Verifica se o registro pode ser alterado / excluido
If (lProvAltera .Or. lProvExclui) .And. !Empty( DtoS(ZB1->ZB1_DTLCTO)+DtoS(ZB1->ZB1_DTESTO) )
	cMsg:="Provisão já contabilizada não pode sofrer alterações ou exclusão!"
	Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
	Return()
EndIf

// Criar Variaveis da Enchoice
RegToMemory("ZB1",lProvInclui)
M->ZB1_APROVA:="N"

// Montar o GetDados
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZB1")

While ! Eof() .and. X3_ARQUIVO == "ZB1"
	
	If X3USO(x3_usado) .and. cNivel >= X3_NIVEL
		Aadd(aCpoEnchoice,x3_campo)
	EndIf
	
	DbSkip()
	
End

If lProvInclui
	M->ZB1_PROVIS := GetSXENum('ZB1','ZB1_PROVIS') 	// Pegar o proximo numero
	M->ZB1_DTDIGI := dDataBase        				// Pegar a data da emissao
EndIf
cProvisao := M->ZB1_PROVIS
cAprovAnt := "N"

dbSelectArea("ZB1")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as variaveis do pergunte                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("PRVCTB",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("aBackZB2")=="U" .Or. Empty(aBackZB2)
	
	aBackZB2 := {}
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("ZB2")
	While !Eof() .And. (SX3->X3_ARQUIVO == "ZB2")
		IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			
			AADD( aBackZB2,{ TRIM(x3titulo()),;
			SX3->X3_CAMPO	,;
			SX3->X3_PICTURE	,;
			SX3->X3_TAMANHO	,;
			SX3->X3_DECIMAL	,;
			SX3->X3_VALID	,;
			SX3->X3_USADO	,;
			SX3->X3_TIPO	,;
			SX3->X3_F3		,;
			SX3->X3_CONTEXT } )
			
			If     Alltrim(aBackZB2[Len(aBackZB2)][2]) == "ZB2_PERCEN"
				aBackZB2[Len(aBackZB2)][6] := 'u_CalValZB2() .And. M->ZB2_PERCEN > 0 .And. M->ZB2_PERCEN < 100.01'
				aBackZB2[Len(aBackZB2)][3] := '@E 999.99999'
			ElseIf Alltrim(aBackZB2[Len(aBackZB2)][2]) == "ZB2_VALOR"
				aBackZB2[Len(aBackZB2)][6] := 'u_CalPerZB2() .And. M->ZB2_VALOR > 0'		// .And. M->ZB2_VALOR <= nVlDocume'
			ElseIf Alltrim(aBackZB2[Len(aBackZB2)][2]) == "ZB2_NATURE"
				aBackZB2[Len(aBackZB2)][6] := 'u_VldNatFor( M->ZB2_NATURE , cCdFornec , cLjFornec )'
				aBackZB2[Len(aBackZB2)][9] := 'SZHZB2'
			ElseIf Alltrim(aBackZB2[Len(aBackZB2)][2]) == "ZB2_CCUSTO"
				//aBackZB2[Len(aBackZB2)][6] := 'ExistCpo("CTT") .And. u_VerCCBloq(M->ZB2_CCUSTO) .And. Ctb105CC()'
				aBackZB2[Len(aBackZB2)][6] := 'ExistCpo("CTT") .And. u_VerCCBloq(M->ZB2_CCUSTO)'
			ElseIf Alltrim(aBackZB2[Len(aBackZB2)][2]) == "ZB2_ITEMCT"
				//aBackZB2[Len(aBackZB2)][6] := 'ExistCpo("CTD") .And. Ctb105Item()'
				aBackZB2[Len(aBackZB2)][6] := 'ExistCpo("CTD")'
			ElseIf Alltrim(aBackZB2[Len(aBackZB2)][2]) == "ZB2_CLVL"
				//aBackZB2[Len(aBackZB2)][6] := 'ExistCpo("CTH") .And. Ctb105ClVl()'
				aBackZB2[Len(aBackZB2)][6] := 'ExistCpo("CTH")'
			ElseIf Alltrim(aBackZB2[Len(aBackZB2)][2]) == "ZB2_PEDCOM"
				aBackZB2[Len(aBackZB2)][6] := 'U_VerPC()'
			Endif
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
EndIf
aHeader := aBackZB2
nUsado  := Len(aHeader)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica a posicao dos campos no acols                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerPosZB2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do acols e arrays acessorios.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If INCLUI
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem de uma linha em branco no aCols.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	AdicCols()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aCols com os registros selecionados        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	MontAcols(cProvisao,.T.)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Tela de Provisionamento                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo        := "Manutencao no Cadastro de Provisão Contábil"
cAliasEnchoice := "ZB1"
PRIVATE aTELA[0][0],aGETS[0]
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos( aSize[3]-aSize[1], 315, { { 003, 033, 160, 200, 240, 265 } } )

Private aCpos2         := aClone(aCpoEnchoice)

nGetMethod  := If ( Inclui .Or. Altera, GD_INSERT + GD_UPDATE + GD_DELETE, 0 )
aCpoAlt	  := { "ZB2_PEDCOM","ZB2_NATURE", "ZB2_PERCEN", "ZB2_VALOR", "ZB2_CCUSTO", "ZB2_ITEMCT", "ZB2_CLVL" }

DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] TITLE "Provisão Contábil" Of oMainWnd PIXEL

EnChoice( cAliasEnchoice, ZB1->(Recno()), nOpcx, , , , , aPosObj[1],aCpos2,3,,,"ProvVldTOk")

oGetDados := MSNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nGetMethod, 'U_VldLinZB2', 'U_VldTudZB2', '+ZB2_ITEM', aCpoAlt , , 9999, , , "U_DelOk()", oDlg, aHeader, aCols )

nGetLin := aPosObj[3,1]

If cTheme!="FLAT"
	@ nGetLin,060 Say 	"Percentual" 	Size 	C(035),C(008) COLOR CLR_BLUE 	Font oBoldIV PIXEL OF oDlg
	@ nGetLin,100 MsGet oPercTot 		Var 	nPercTot 	Size C(060),C(009) COLOR CLR_BLACK Font oBoldIV PICTURE "@E 999.99999" PIXEL OF oDlg WHEN .F.
	@ nGetLin,210 Say 	"Valor" 		Size 	C(035),C(008) COLOR CLR_BLUE 	Font oBoldIV PIXEL OF oDlg
	@ nGetLin,230 MsGet oValTot 		Var 	nValTot 	Size C(060),C(009) COLOR CLR_BLACK Font oBoldIV PICTURE "@E 99999,999,999.99" PIXEL OF oDlg WHEN .F.
	@ nGetLin,350 Say 	"Falta %" 		Size 	C(035),C(007) COLOR CLR_RED 	PIXEL OF oDlg
	@ nGetLin,370 MsGet oPercFalt		Var 	nPercFalt	Size C(040),C(005) COLOR CLR_BLACK PICTURE "@E 999.99999" PIXEL OF oDlg WHEN .F.
	@ nGetLin,435 Say 	"Valor" 		Size 	C(035),C(007) COLOR CLR_RED		PIXEL OF oDlg
	@ nGetLin,450 MsGet oValFalta		Var 	nValFalta	Size C(040),C(005) COLOR CLR_BLACK PICTURE "@E 99999,999,999.99" PIXEL OF oDlg WHEN .F.
Else
	@ nGetLin,C(060) Say 	"Percentual" 	Size 	C(035),C(008) COLOR CLR_BLUE 	Font oBoldIV PIXEL OF oDlg
	@ nGetLin,C(095) MsGet 	oPercTot 		Var 	nPercTot 	Size C(060),C(009) COLOR CLR_BLACK Font oBoldIV PICTURE "@E 999.99999" PIXEL OF oDlg WHEN .F.
	@ nGetLin,C(195) Say 	"Valor" 		Size 	C(035),C(008) COLOR CLR_BLUE 	Font oBoldIV PIXEL OF oDlg
	@ nGetLin,C(215) MsGet 	oValTot 		Var 	nValTot 	Size C(060),C(009) COLOR CLR_BLACK Font oBoldIV PICTURE "@E 99999,999,999.99" PIXEL OF oDlg WHEN .F.
	@ nGetLin,C(327) Say 	"Falta %" 		Size 	C(035),C(007) COLOR CLR_RED 	PIXEL OF oDlg
	@ nGetLin,C(343) MsGet 	oPercFalt		Var 	nPercFalt	Size C(040),C(005) COLOR CLR_BLACK PICTURE "@E 999.99999" PIXEL OF oDlg WHEN .F.
	@ nGetLin,C(386) Say 	"Valor" 		Size 	C(035),C(007) COLOR CLR_RED		PIXEL OF oDlg
	@ nGetLin,C(398) MsGet 	oValFalta		Var 	nValFalta	Size C(040),C(005) COLOR CLR_BLACK PICTURE "@E 99999,999,999.99" PIXEL OF oDlg WHEN .F.
EndIf

If lProvVisual
	RecValZB2()
EndIf

ACTIVATE MSDIALOG oDlg ON INIT ( EnchoiceBar( oDlg , {|| aCols := oGetDados:aCols, lF0 := U_VldTudZB2() ,;
If(Eval(bSaida,lF0), (oDlg:End(), nOpc:=1), (nOpc:=0))},;
	{|| oDlg:End() }, , aButtons )) CENTERED
	
	If nOpc == 1 .And. (lProvInclui.Or.lProvAltera.Or.lProvExclui)
		ProvGrava( lProvExclui,nRecZB1,aRecZB2,lProvAltera )
	ElseIf nOpc == 0 .And. lProvInclui
		RollBackSX8()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Destrava os registros na alteracao e exclusao          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lProvAltera .Or. lProvExclui
		MsUnlockAll()
	EndIf
	
	Return .T.
	
	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ProvLegen ³ Autor ³ Daniel G.Jr.TI1239   ³ Data ³ 28/06/07 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CSUCTB12                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	User Function ProvLegen()
	
	
	Local aLegenda := { { "ENABLE"		, "Aberta"	  					},;
	{ "BR_AZUL"		, "Contabilizada"				},;
	{ "BR_CINZA"	, "Parcialmete Estornada"		},;
	{ "BR_PRETO"	, "Pendente de Estorno com PC Excluido"	},;      //Alterado por Tatiana Barbosa em 18/02/10
	{ "BR_BRANCO"	, "Estorno Off-Line"		},;
	{ "DISABLE"		, "Estornada"					}}
	
	BrwLegenda(cCadastro,"Legenda" ,aLegenda)
	
	Return .T.
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ProvGrava ³ Autor ³ Daniel G.Jr.TI1239   ³ Data ³28/06/07  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Gravacao do Provisionamento Contabil                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ ProvGrava(ExpC1,ExpN2,ExpA3)                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ nExpC1 : Controle de Gravacao  1,                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CSUCTB12                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function ProvGrava( lDeleta,nRecZB1,aRecZB2,lProvAltera )
	
	Local cArquivo  := ""
	Local cLote     := ""
	Local nHdlPrv   := 0
	Local nTotalLcto:= 0
	Local nV        := 0
	Local nX        := 0
	Local nY        := 0
	Local nZ        := 0
	Local nW        := 0
	Local nOper     := 0
	Local lQuery    := .F.
	Local cQuery    := ""
	Local cProvis 	:= cTipo := cHistor := cNomUsu := cOrigem := ""
	Local dData   	:= CtoD("")
	Local nValor  	:= nValCr := nValDb := 0
	
	cNomUsu := cNomUsuar
	cOrigem := "MANUTENCAO DE PROVISAO"
	dData	:= DDATABASE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a operacao a ser realizada (Inclusao ou Exclusao )  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lDeleta
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizacao do cabecalho do documento de entrada             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("ZB1")
		dbSetOrder(1)
		If nRecZB1 <> 0		// alteraçao
			MsGoto(nRecZB1)
			RecLock("ZB1",.F.)
			nOper := 2
		Else				// inclusão
			RecLock("ZB1",.T.)
			nOper := 1
		EndIf
		ZB1->ZB1_FILIAL	:= xFilial("ZB1")
		ZB1->ZB1_PROVIS	:= M->ZB1_PROVIS
		ZB1->ZB1_COMPET	:= M->ZB1_COMPET
		ZB1->ZB1_FORNEC	:= M->ZB1_FORNEC
		ZB1->ZB1_LOJA	:= M->ZB1_LOJA
		ZB1->ZB1_DOC	:= M->ZB1_DOC
		ZB1->ZB1_EMIDOC	:= M->ZB1_EMIDOC
		ZB1->ZB1_VENCTO	:= M->ZB1_VENCTO
		ZB1->ZB1_VALDOC	:= M->ZB1_VALDOC
		ZB1->ZB1_HISTOR	:= M->ZB1_HISTOR
		ZB1->ZB1_DTLCTO	:= M->ZB1_DTLCTO
		ZB1->ZB1_SALDO	:= M->ZB1_VALDOC
		ZB1->ZB1_SLDEST	:= 0
		ZB1->ZB1_DTDIGI := dDtDigita
		ZB1->ZB1_USUARI := cNomUsuar
		ZB1->ZB1_APROVA := cAprovAnt
		ZB1->(FkCommit())
		If nOper = 1		// inclusão
			ConfirmSX8("ZB1","ZB1_PROVIS")
		EndIf
		cProvis := ZB1->ZB1_PROVIS
		nValor	:= ZB1->ZB1_SALDO
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizacao dos itens do provisionamento                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 to Len(aCols)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza a tabela de itens da provisão                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !aCols[nx][Len(aHeader)+1]
				dbSelectArea("ZB2")
				If nX <= Len(aRecZB2)    	// altera itens já cadastrados
					MsGoto(aRecZB2[nx])
					RecLock("ZB2",.F.)
				Else
					RecLock("ZB2",.T.)		// inclui novos ítens
				EndIf
				ZB2->ZB2_FILIAL	:= xFilial("ZB2")
				ZB2->ZB2_PROVIS	:= M->ZB1_PROVIS
				ZB2->ZB2_FORNEC	:= M->ZB1_FORNEC
				ZB2->ZB2_LOJA	:= M->ZB1_LOJA
				ZB2->ZB2_COMPET	:= M->ZB1_COMPET
				For nY := 1 To Len(aHeader)
					If aHeader[nY][10] # "V"
						ZB2->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
					EndIf
				Next nY
				ZB2->ZB2_SALDO	:= aCols[nx][nPosValEZ]
				ZB2->ZB2_SLDEST	:= 0
				ZB2->(MsUnLock())
				nValCr += ZB2->ZB2_SALDO
				
			Else							// exclui ítens já cadastrados
				If  nX <= Len(aRecZB2)
					MsGoto(aRecZB2[nx])
					nValDB += ZB2->ZB2_SALDO
					RecLock("ZB2",.F.)
					ZB2->(dbDelete())
					ZB2->(MsUnLock())
				EndIf
			EndIf
		Next nX
	Else			// exclusão da provisão
		For nX := 1 to Len(aRecZB2)
			dbSelectArea("ZB2")
			MsGoto(aRecZB2[nx])
			nValDb += ZB2->ZB2_SALDO
			RecLock("ZB2",.F.,.T.)
			ZB2->(dbDelete())
			ZB2->(MsUnlock())
		Next nX
		
		ZB2->(FkCommit())
		
		dbSelectArea("ZB1")
		MsGoto(nRecZB1)
		RecLock("ZB1",.F.,.T.)
		nOper := 3
		
		ZB1->(dbDelete())
		ZB1->(MsUnlock())
		ZB1->(FkCommit())
		
	EndIf
	
	If nOper==1
		cTipo 	:= "3"
		cHistor	:= "INCLUSAO DA PROVISAO"
	ElseIf nOper==2
		cTipo	:= "4"
		cHistor	:= "ALTERACAO DA PROVISAO"
	ElseIf nOper==3
		cTipo	:= "5"
		cHistor	:= "EXCLUSAO DA PROVISAO"
	EndIf
	
	If nValor<>(nValCr+nValDb)
		nValor := nValor - nValCr + nValDb
	EndIf
	
	// Grava ocorrencias da provisao
	lOcor := U_GrvOcorPrv(cProvis,cTipo,dData,nValor,cOrigem,cHistor,cNomUsu)
	
	Return
	
	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
	±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
	Static Function C(nTam)
	Local nHRes	 := oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	Local cTheme := Upper(Alltrim(GetTheme()))
	
	If nHRes == 640		// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800) 		// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para tema "Flat"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
	Return Int(nTam)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ProvVldTOkº Autor ³ Daniel G.Jr.TI1239 º Data ³  03/07/2007 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Valida campos da enchoice                                  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                             º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function ProvVldTOk()
	
	Local lRet := .T.
	Local cMsg := ""
	
	// Inicializa variáveis
	cProvisao  	:= M->ZB1_PROVIS
	cCompeten  	:= M->ZB1_COMPET
	cCdFornec  	:= M->ZB1_FORNEC
	cLjFornec  	:= M->ZB1_LOJA
	cNoFornec  	:= Posicione("SA2",1,xFilial("SA2")+M->ZB1_FORNEC,"A2_NOME")
	cNrDocume  	:= M->ZB1_DOC
	dEmDocume  	:= M->ZB1_EMIDOC
	dVcDocume  	:= M->ZB1_VENCTO
	nVlDocume  	:= M->ZB1_VALDOC
	cHistoric	:= M->ZB1_HISTOR
	dLctConta  	:= M->ZB1_DTLCTO
	dDtDigita	:= M->ZB1_DTDIGI
	cAprovAnt  	:= "N"
	If Empty(cHistoric)
		cMsg += "Digite o histórico"+Chr(10)
		lRet := .F.
	EndIf
	If nVlDocume == 0
		cMsg += "Digite o valor da Provisão"+Chr(10)
		lRet := .F.
	EndIf
	
	If !lRet
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
	EndIf
	
	Return(lRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³CalValZB2 º Autor ³ Daniel G.Jr.TI1239 º Data ³  03/07/2007 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Calcula o Valor com Base no Percentual Informado           º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                             º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function CalValZB2()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³              Declara as Variaveis Locais Utilizadas na Rotina              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Local lRet   := .F.
	Local cAlias := Alias()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³            Calcula o Valor de Acordo com o Percentual Digitado             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	If !Empty( M->ZB2_PERCEN )
		
		aCols[n][nPosValEZ] := Round( ( M->ZB2_PERCEN / 100 ) * M->ZB1_VALDOC , 2 )
		aCols[n][nPosPerEZ] := M->ZB2_PERCEN
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³         Chama a Funcao que Atualiza o Campo do Valor Distribuido           ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		oGetDados:aCols := aCols
		RecValZB2()
		lRet := .T.
		
	Endif
	
	Return lRet
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³CalPerZB2 º Autor ³ Cristiano Figueiroaº Data ³  11/01/2006 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Calcula o Percentual com Base no Valor Informado           º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                             º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function CalPerZB2()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³              Declara as Variaveis Locais Utilizadas na Rotina              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Local lRet   := .F.
	Local cAlias := Alias()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³            Calcula o Valor de Acordo com o Percentual Digitado             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	If !Empty( M->ZB2_VALOR )
		
		aCols[n][nPosPerEZ]  := Round( M->ZB2_VALOR / M->ZB1_VALDOC * 100 , 5 )
		aCols[n][nPosValEZ]  := Round( ( aCols[n][nPosPerEZ] / 100 ) * M->ZB1_VALDOC , 2 )
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³         Chama a Funcao que Atualiza o Campo do Valor Distribuido           ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		oGetDados:aCols := aCols
		RecValZB2()
		lRet := .T.
		
	Endif
	
	Return lRet
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜßÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VldLinZB2 º Autor ³ Cristiano Figueiroaº Data ³  16/01/2006 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Valida a Linha Digitada no Rateio por Centro de Custo       º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                              º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function VldLinZB2()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³              Declara as Variaveis Utilizadas na Rotina                     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Local cObrig     := "ZB2_PEDCOM¹ZB2_NATURE¹ZB2_PERCEN¹ZB2_VALOR¹ZB2_CCUSTO¹ZB2_ITEMCT¹ZB2_CLVL" // Campos Obrigatorios
	Local nContVlr   := 0
	Local cmsg 		 := ""
	Local lRet		 := .T.
	Local cAliasSC7  := "_QRYSC7"
	Local cMsg2      := " Este pedido já foi utilizado em outra provisão, favor verificar um pedido válido nos botões PEDIDO e ITENS DO PEDIDO."
	Local wxp		 := 0
	Local lAchou     := .F.
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³         Chama a Funcao que Atualiza o Campo do Valor Distribuido           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	RecValZB2()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³      Caso a linha esteja deletada nao efetua qualquer validacao     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	If aCols[ n , Len(aHeader) + 1 ]
		Return .T.
	Endif
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	For x := 1 to Len(aHeader)
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Valida as linhas nao deletadas e obrigatorias                       ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		If Trim(aHeader[x , 2] ) $ cObrig
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Valida os campos obrigatorios e caractere                           ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			If Empty(aCols[ n , x ])
				cMsg += "O Campo : " + Trim(aHeader[ x , 1 ]) + "' é de preenchimento obrigatório!"+Chr(10)
				lRet:=.F.
			Endif
			
		Endif
		
	Next
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³               Valida as informacoes digitadas                       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	//If nValTot > M->ZB1_VALDOC
	//	cMsg += "O Valor informado nao pode ser Maior que o Valor a ser Rateado !"+Chr(10)
	//	lRet:=.F.
	//Endif
	
	If !lRet
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
	EndIf
	
	If lRet
		lRet := U_VldCTBg( BuscaCols('ZB2_ITEMCT'), BuscaCols('ZB2_CCUSTO'), BuscaCols('ZB2_CLVL'), Nil )
	EndIf
	
	If lRet			//Criado por Tatiana Barbosa em 05/07/10 - OS 1791/10
		lRet := U_VerCCBloq(BuscaCols('ZB2_CCUSTO'))
	EndIf
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. Foi mantido o   ³
	³                                  metodo anterior para consulta.                                       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ((C7_QUANT-C7_QUJE)* C7_PRECO) SALDO "+_cEnter
	cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ( ((C7_QUANT-C7_QUJE)* C7_PRECO)+C7_VALIPI ) SALDO "+_cEnter
	cQuery += "FROM		"+RetSqlName("SC7")+" SC7 "+_cEnter
	cQuery += "WHERE 	SC7.D_E_L_E_T_ = '' "+_cEnter
	cQuery += "AND		SC7.C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' "+_cEnter
	cQuery += "AND		SC7.C7_FORNECE = '"+M->ZB1_FORNEC+"' "+_cEnter
	cQuery += "AND		(SC7.C7_QUANT-SC7.C7_QUJE) > 0 "+_cEnter
	cQuery += "AND 		SC7.C7_NUM IN ("+_cEnter
	
	cQuery += 		"SELECT PEDIDO "+_cEnter
	
	cQuery += 		"FROM "+_cEnter
	cQuery += 			"( "+_cEnter
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. O campo C7_VALIPI³
	³                                  foi incluido na soma.                                                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cQuery += 				"SELECT	SC7.C7_NUM PEDIDO, (SC7.C7_QUANT*SC7.C7_PRECO)+C7_VALIPI VALOR "+_cEnter
	cQuery += 				"FROM	"+RetSqlName("SC7")+" SC7 "+_cEnter
	cQuery += 				"WHERE	SC7.D_E_L_E_T_ = '' "+_cEnter
	cQuery += 				"AND	SC7.C7_FORNECE = '"+M->ZB1_FORNEC+"' "+_cEnter
	
	// OS 0556-12 - Permitir que sejam incluidas provisoes para pedidos já incluidos que contenham saldo.
	
	cQuery += 				"AND	C7_QUANT > C7_QUJE  "+_cEnter
	
	cQuery += 				"UNION	ALL "+_cEnter
	
	cQuery += 				"SELECT	ZB2_PEDCOM PEDIDO, -ZB2_VALOR VALOR "+_cEnter
	cQuery += 				"FROM	"+RetSqlName("ZB2")+" ZB2 "+_cEnter
	cQuery += 				"WHERE	ZB2.D_E_L_E_T_ = '' "+_cEnter
	cQuery += 				"AND	ZB2.ZB2_FORNEC = '"+cCdFornec+"' "+_cEnter
	cQuery += 				"AND	ZB2.ZB2_LOJA = '"+M->ZB1_LOJA+"' "+_cEnter
	cQuery += 				"AND	ZB2.ZB2_VLESTO <= 0 "+_cEnter
	//cQuery += 				"AND	ZB2.ZB2_PROVIS <> '"+M->ZB1_PROVIS+"' "+_cEnter
	cQuery += 			") AS T "+_cEnter
	
	cQuery += 			"GROUP BY PEDIDO "+_cEnter
	
	cQuery += 			"HAVING SUM(VALOR) > "+IIF(M->ZB1_VALDOC > 0, ALLTRIM( STR ( M->ZB1_VALDOC - 0.01 ) ) , "99999999999999999.99" )+" "+_cEnter
	
	cQuery += 			")"+_cEnter
	
	cQuery += 			"ORDER BY SC7.C7_NUM,SC7.C7_ITEM "+_cEnter
	//Aviso("1-Query",cQuery,{"&fechar"},3,"Query",,"PCOLOCK")
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasSC7)>0
		(cAliasSC7)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
	
	(cAliasSC7)->(DbGoTop())
	
	While (cAliasSC7)->(!Eof())
		For wxp := 1 To Len(aCols)
			If !aCols[wXP][ Len( aCols[wXP])]
				If aCols[wxp][GdFieldPos("ZB2_PEDCOM")] == (cAliasSC7)->C7_NUM
					lAchou := .T.
				EndIf
			EndIf
		Next
		(cAliasSC7)->(DbSkip())
		
	EndDo
	
	If !lAchou
		Aviso("Pedido de compras já utilizado",cMsg2,{"Fechar"},3)
		lRet := .F.
	EndIf
	
	Return (lRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VldTudZB2 º Autor ³ Cristiano Figueiroaº Data ³  16/01/2006 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Valida todos os Dados digitados no Rateio                   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                              º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function VldTudZB2()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³              Declara as Variaveis Utilizadas na Rotina                     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Local cObrig     := "ZB2_PEDCOM¹ZB2_NATURE¹ZB2_PERCEN¹ZB2_VALOR¹ZB2_CCUSTO¹ZB2_ITEMCT¹ZB2_CLVL" // Campos Obrigatorios
	Local nValTotal  := 0, nTamVal := TamSX3("ZB1_VALDOC")[1]
	Local nValPerc   := 0
	Local lRet		 := .T.
	Local aPCSld	 := {}
	Local cAliasSC7  := "_QRYSC7"
	Local cMsg2      := " Este pedido já foi utilizado em outra provisão, favor verificar um pedido válido nos botões PEDIDO e ITENS DO PEDIDO."
	Local wxp		 := 0
	Local lAchou     := .f., lSED := .t.
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³   Caso seja Visualizacao ou Exclusao nao valida as informacoes      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	If lProvExclui .Or. lProvVisual
		Return .T.
	Endif
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	aCpos:={ M->ZB1_COMPET, M->ZB1_FORNEC, M->ZB1_VALDOC, M->ZB1_HISTOR }
	//aCpos:={ M->ZB1_COMPET, M->ZB1_FORNEC, M->ZB1_HISTOR }
	aTits:={ "Competência","Cód.do Fornecedor","Valor do Documento","Histórico" }
	cMsg:=""
	For nI:=1 To Len(aCpos)
		If Empty(aCpos[nI])
			cMsg += "O Campo: '"+ aTits[nI] + "' é de preenchimento obrigatório!"+Chr(10)
			lRet := .F.
		EndIf
	Next nI
	
	SED->( DbSetOrder(1) )
	
	For x := 1 to Len(aCols)
		If ! aCols[ x , Len(aHeader) + 1 ]
			For y := 1 to Len(aHeader)
				If Trim(aHeader[y , 2] ) $ cObrig
					
					/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³ Valida os campos obrigatorios                                       ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					
					If Empty(aCols[ x , y ])
						cMsg += "O Campo : " + Trim(aHeader[ y , 1 ]) + "' é de preenchimento obrigatório!"+Chr(10)
						lRet := .F.
					Endif
				EndIf
			Next y
			
			nPC := Ascan( aPCSld, { |y| y[1] = aCols[x][nPosNPCEZ] } )
			If nPC>0
				aPCSld[nPc][2] += aCols[x][nPosValEZ]
			Else
				aAdd( aPCSld, { aCols[x][nPosNPCEZ], aCols[x][nPosValEZ] } )
				aSort(aPCSld,,, { |y,z| y[1] < z[1] } )
			EndIf
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Soma o Valor Total dos Movimentos                                   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			nValTotal += Acols[x][nPosValEZ]
			nValPerc  += Acols[x][nPosPerEZ]
			
		Endif
		
		If lRet
			lRet := U_VldCTBg( BuscaCols('ZB2_ITEMCT'), BuscaCols('ZB2_CCUSTO'), BuscaCols('ZB2_CLVL'), Nil )
			If !lRet
				cMsg += "Regra x Contra-Regra foi violada, verifique! (linha:"+Str(x,4)+")"+Chr(10)
			EndIf
		EndIf
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ OS 0585/10: Verificar se a natureza eh valida.                                                                          ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If !SED->( DbSeek( xFilial('SED')+aCols[x][GdFieldPos('ZB2_NATURE')] ) )
			cMsg += "A natureza: " + aCols[x][GdFieldPos('ZB2_NATURE')] + " informada no item "+AllTrim(Str(x))+" é inválida!"+Chr(10)
			lSED := .f.
		EndIf
		
	Next x
	
	lRet := lRet .And. lSED
	
	For nX:=1 to Len(aSldPC)
		nPC := Ascan( aPCSld, { |x| x[1] = aSldPC[nX][1] } )
		If nPc>0
			If aSldPC[nX][2] < aPCSld[nPC][2]
				cMsg += "Valor provisionado é maior que o saldo do Pedido "+aSldPC[nX][1]+"!"+Chr(10)
				lRet := .F.
			EndIf
		EndIf
	Next nX
	
	If !lRet
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		Return .F.
	EndIf
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³               Valida as informacoes digitadas                       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	AjustaDif( M->ZB1_VALDOC, nValTot)
	
	//If Round( nValPerc , 2 )   <> 100
	If Round( nPercTot , 2 )   <> 100
		cMsg:="O Percentual Rateado devera ser 100 % !"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		Return .F.
	Endif
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ OS 2052/10: A soma dos itens da provisao nao podera ser superior a rotina ³
	³ que ajusta a Diferenca encontrada.                                        ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If Round( M->ZB1_VALDOC, nTamVal ) <> Round( nValTot, nTamVal )
		//AjustaDif ( M->ZB1_VALDOC , nValTot )
		Aviso("Somatoria dos Itens x Total" , "A somatória do total dos itens não está igual ao valor total da provisão." , {"Ok"} , 1 , "Erro" )
		lRet := .f.
	Endif
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. Foi mantido o   ³
	³                                  metodo anterior para consulta.                                       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ((C7_QUANT-C7_QUJE)* C7_PRECO) SALDO "+_cEnter
	cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ( ((C7_QUANT-C7_QUJE)* C7_PRECO)+C7_VALIPI ) SALDO "+_cEnter
	cQuery += "FROM		"+RetSqlName("SC7")+" SC7 "+_cEnter
	cQuery += "WHERE 	SC7.D_E_L_E_T_ = '' "+_cEnter
	cQuery += "AND		SC7.C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' "+_cEnter
	cQuery += "AND		SC7.C7_FORNECE = '"+M->ZB1_FORNEC+"' "+_cEnter
	cQuery += "AND		(SC7.C7_QUANT-SC7.C7_QUJE) > 0 "+_cEnter
	cQuery += "AND 		SC7.C7_NUM IN ("+_cEnter
	
	cQuery += 		"SELECT PEDIDO "+_cEnter
	
	cQuery += 		"FROM "+_cEnter
	cQuery += 			"( "+_cEnter
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. O campo C7_VALIPI³
	³                                  foi incluido na soma.                                                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cQuery += 				"SELECT	SC7.C7_NUM PEDIDO, (SC7.C7_QUANT*SC7.C7_PRECO)+C7_VALIPI VALOR "+_cEnter
	cQuery += 				"FROM	"+RetSqlName("SC7")+" SC7 "+_cEnter
	cQuery += 				"WHERE	SC7.D_E_L_E_T_ = '' "+_cEnter
	cQuery += 				"AND	SC7.C7_FORNECE = '"+M->ZB1_FORNEC+"' "+_cEnter
	
	// OS 0556-12 - Permitir que sejam incluidas provisoes para pedidos já incluidos que contenham saldo.
	cQuery += 				"AND	C7_QUANT > C7_QUJE  "+_cEnter
	
	cQuery += 				"UNION	ALL "+_cEnter
	
	cQuery += 				"SELECT	ZB2_PEDCOM PEDIDO, -ZB2_VALOR VALOR "+_cEnter
	cQuery += 				"FROM	"+RetSqlName("ZB2")+" ZB2 "+_cEnter
	cQuery += 				"WHERE	ZB2.D_E_L_E_T_ = '' "+_cEnter
	cQuery += 				"AND	ZB2.ZB2_FORNEC = '"+cCdFornec+"' "+_cEnter
	cQuery += 				"AND	ZB2.ZB2_LOJA = '"+M->ZB1_LOJA+"' "+_cEnter
	cQuery += 				"AND	ZB2.ZB2_VLESTO <= 0 "+_cEnter
	//cQuery += 				"AND	ZB2.ZB2_PROVIS <> '"+M->ZB1_PROVIS+"' "+_cEnter
	cQuery += 			") AS T "+_cEnter
	
	cQuery += 			"GROUP BY PEDIDO "+_cEnter
	
	cQuery += 			"HAVING SUM(VALOR) > "+IIF(M->ZB1_VALDOC > 0, ALLTRIM( STR ( M->ZB1_VALDOC - 0.01 ) ) , "99999999999999999.99" )+" "+_cEnter
	
	cQuery += 			")"+_cEnter
	
	cQuery += 			"ORDER BY SC7.C7_NUM,SC7.C7_ITEM "+_cEnter
	
	//Aviso("2-Query",cQuery,{"&fechar"},3,"Query",,"PCOLOCK")
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasSC7)>0
		(cAliasSC7)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
	
	(cAliasSC7)->(DbGoTop())
	
	While (cAliasSC7)->(!Eof())
		For wxp := 1 To Len(aCols)
			If !aCols[wXP][ Len( aCols[wXP])]
				If aCols[wxp][GdFieldPos("ZB2_PEDCOM")] == (cAliasSC7)->C7_NUM
					lAchou := .T.
				EndIf
			EndIf
		Next
		(cAliasSC7)->(DbSkip())
		
	EndDo
	
	If !lAchou
		Aviso("Pedido de compras já utilizado",cMsg2,{"Fechar"},3)
		Return .F.
	EndIf
	
	nAux := n
	CCBloqProv	:= 0
	
	If lRet    //Criado por Tatiana Barbosa em 05/07/10 - OS 1791/10
		For n := 1 To Len( aCols )
			If !GdDeleted(n)
				lRet := U_VerCCBloq(BuscaCols('ZB2_CCUSTO'))
				If !lRet
					CCBloqProv ++
				EndIf
			EndIf
		Next
	EndIf
	
	If CCBloqProv > 0	//Criado por Tatiana Barbosa em 05/07/10 - OS 1791/10
		lRet := .F.
	Else
		lRet := .T.
	EndIf
	
	n := nAux
	
	Return (lRet)//.T.			//Alterado por Tatiana Barbosa em 05/07/10 - OS 1791/10
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³RecValZB2 º Autor ³ Cristiano Figueiroaº Data ³  12/01/2006 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Recalcula o Valor Distribuido no Acols                     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                             º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function RecValZB2(nTipo)
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³              Declara as Variaveis Locais Utilizadas na Rotina              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Local i, lRecalc:=.F.
	Default nTipo := 0
	
	If Len(oGetDados:aCols)>1
		aCols := oGetDados:aCols
	Endif
	
	If nTipo==1 .And. !lPrima .And. Aviso("Alteração do Valor da Provisão","Executa o recálculo dos valores pelo percentual?",{"Confirma","Cancela"},3)==1
		lRecalc:=.T.
	EndIf
	
	lPrima:=.F.
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³                   Zera a Variavel do Valor Distribuido                     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	nValTot  := 0
	nPercTot := 0
	nVlDocume:= M->ZB1_VALDOC
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³                 Zera a Variavel da Quantidade de Registros                 ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	nRegs    := 0
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³                        Calcula o Valor Distribuido                         ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	For i := 1 To Len(aCols)
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³       Se a linha nao estiver deletada , acumula o valor digitado           ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		If !aCols[i][nUsado + 1]
			If (nTipo==1 .And. cAprovAnt!="S") .Or. lRecalc
				aCols[i][nPosValEZ] := Round(nVlDocume * aCols[i][nPosPerEZ] * 0.01,2)
			EndIf
			nValTot  += aCols[i][nPosValEZ ]
			nPercTot += aCols[i][nPosPerEZ ]
			
			If aCols [ i , nPosValEZ ] <> 0
				nRegs  ++
			Endif
			
		EndIf
		
	Next
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³                        Atualiza o Objeto na Tela                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	nValFalta := M->ZB1_VALDOC - nValTot
	nPercFalt := (nValFalta / M->ZB1_VALDOC) * 100
	nPercTot  := (nValTot / M->ZB1_VALDOC) * 100
	
	If nTipo==1
		oGetDados:aCols := aCols
		oGetDados:ForceRefresh()
	EndIf
	oValTot:Refresh()
	oPercTot:Refresh()
	oValFalta:Refresh()
	oPercFalt:Refresh()
	
	Return(.T.)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³  AdicCols    º Autor ³ Cristiano Figueiroaº Data ³ 30/01/2006 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Adiciona linha em branco no Acols                             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function AdicCols()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³              Declara as Variaveis Locais Utilizadas na Rotina              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Local nNum, nX
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³                     Adiciona Nova Linha no Acols                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Aadd( aCols , Array( nUsado + 1) )
	nX:=Len(aCols)
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³                     Adiciona Nova Linha no Acols                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	For nHeader := 1 to nUsado
		If ( Trim(aHeader[nHeader][2])=="ZB2_ITEM" )
			aCols[nX][nHeader] := StrZero(nX,3)
		Else
			If ( aHeader[nHeader][10] <> "V" )
				aCols[nX][nHeader] := CriaVar(AllTrim(aHeader[nHeader][2]))
			Else
				_cTpCp := aHeader[nHeader][9]
				aCols[nX][nHeader] := Iif(_cTpCP="1",Space(aHeader[nHeader][5]),;		// Tipo Caracter
				Iif(_cTpCp="2",0,;									// Tipo Numerico
				Iif(_cTpCp="4",CtoD(Space(8)),;					// Tipo Data
				CriaVar(AllTrim(aHeader[nHeader][2])))))
			EndIf
		EndIf
	Next nHeader
	aCols[ nX , nUsado + 1] := .F.
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜßÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VerPosZB2    º Autor ³ Cristiano Figueiroaº Data ³  26/12/2005 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Ver a Posicao dos Campos no aHeader do Centro de Custo         º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function VerPosZB2()
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³         Verifica a Posicao dos Campos no aHeader             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	nPosNPCEZ	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_PEDCOM"  })
	nPosNatEZ	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_NATURE"  })
	nPosCusEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_CCUSTO"  })
	nPosIteEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_ITEMCT"  })
	nPosClaEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_CLVL"    })
	nPosPerEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_PERCEN"  })
	nPosValEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_VALOR"   })
	nPosDesEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_NATDES"  })
	nPosContr   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "ZB2_CONTRA"  })
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜßÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VerFornece   º Autor ³ Daniel G.Jr.TI1239 º Data ³  04/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Validar campo de fornecedor                                    º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function VerFornece()
	
	Local aArea:=GetArea()
	Local lRet:=.T.
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	If SA2->(dbSeek(xFilial("SA2")+M->ZB1_FORNEC))
		M->ZB1_NOFORN := SA2->A2_NOME
		M->ZB1_LOJA	  := SA2->A2_LOJA
	Else
		cMsg:="Fornecedor não encontrado!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		Ret := .F.
	EndIf
	
	RestArea(aArea)
	
	Return(lRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜßÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VerPC        º Autor ³ Daniel G.Jr.TI1239 º Data ³  04/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Validar campo de pedido de compras                             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function VerPC()
	
	Local aArea:=GetArea()
	Local lRet:=.T.
	
	dbSelectArea("SC7")
	dbSetOrder(3)
	If SC7->(dbSeek(xFilial("SC7")+M->ZB1_FORNEC+M->ZB1_LOJA+M->ZB2_PEDCOM))
		lRet := .T.
	Else
		cMsg:="Pedido de Compras não encontrado, ou não pertence ao mesmo fornecedor!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		lRet := .F.
	EndIf
	
	RestArea(aArea)
	
	Return(lRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³TrazPC    ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³04/07/07  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Tela de visualizacao do pedido de compras                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³SCUCTB12                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function TrazPC()
	
	Local nSldPed    := 0
	Local nOpc       := 0
	Local nx         := 0
	Local cQuery     := ""
	Local cAliasSC7  := "SC7"
	Local lQuery     := .F.
	Local bSavSetKey := SetKey(VK_F4,Nil)
	Local bSavKeyF5  := SetKey(VK_F5,{||TrazPC()})
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
	Local aAreaSC7   := SC7->(GetArea())
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
	Local aButtons   := {}
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial()+cCdFornec+cLjFornec)
	cNomeFor	:= SA2->A2_NOME
	
	dbSelectArea("SC7")
	SC7->( dbSetOrder( 9 ) )
	lQuery    := .T.
	cAliasSC7 := "_QRYSC7"
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. Foi mantido o   ³
	³                                  metodo anterior para consulta.                                       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ((C7_QUANT-C7_QUJE)* C7_PRECO) SALDO "+_cEnter
	cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ( ((C7_QUANT-C7_QUJE)* C7_PRECO)+C7_VALIPI ) SALDO "+_cEnter
	cQuery += "FROM		"+RetSqlName("SC7")+" SC7 "+_cEnter
	cQuery += "WHERE 	SC7.D_E_L_E_T_ = '' "+_cEnter
	cQuery += "AND		SC7.C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' "+_cEnter
	cQuery += "AND		SC7.C7_FORNECE = '"+M->ZB1_FORNEC+"' "+_cEnter
	cQuery += "AND		(SC7.C7_QUANT-SC7.C7_QUJE) > 0 "+_cEnter
	cQuery += "AND 		SC7.C7_NUM IN ("+_cEnter
	
	cQuery += 		"SELECT PEDIDO "+_cEnter
	
	cQuery += 		"FROM "+_cEnter
	cQuery += 			"( "+_cEnter
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. O campo C7_VALIPI³
	³                                  foi incluido na soma.                                                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cQuery += 				"SELECT	SC7.C7_NUM PEDIDO, (SC7.C7_QUANT*SC7.C7_PRECO)+C7_VALIPI VALOR "+_cEnter
	cQuery += 				"FROM	"+RetSqlName("SC7")+" SC7 "+_cEnter
	cQuery += 				"WHERE	SC7.D_E_L_E_T_ = '' "+_cEnter
	cQuery += 				"AND	SC7.C7_FORNECE = '"+M->ZB1_FORNEC+"' "+_cEnter
	cQuery += 				"AND	C7_QUANT > C7_QUJE  "+_cEnter
	
	cQuery += 				"UNION	ALL "+_cEnter
	
	cQuery += 				"SELECT	ZB2_PEDCOM PEDIDO, -ZB2_VALOR VALOR "+_cEnter
	cQuery += 				"FROM	"+RetSqlName("ZB2")+" ZB2 "+_cEnter
	cQuery += 				"WHERE	ZB2.D_E_L_E_T_ = '' "+_cEnter
	cQuery += 				"AND	ZB2.ZB2_FORNEC = '"+cCdFornec+"' "+_cEnter
	cQuery += 			") AS T "+_cEnter
	
	cQuery += 			"GROUP BY PEDIDO "+_cEnter
	
	cQuery += 			"HAVING SUM(VALOR) > "+IIF(M->ZB1_VALDOC > 0, ALLTRIM( STR ( M->ZB1_VALDOC - 0.01 ) ) , "99999999999999999.99" )+" "+_cEnter
	
	cQuery += 			")"+_cEnter
	
	cQuery += 			"ORDER BY SC7.C7_NUM,SC7.C7_ITEM "+_cEnter
	
	/*
	cQuery := "SELECT SC7.*, R_E_C_N_O_ RECSC7, "+_cEnter
	cQuery += "((C7_QUANT-C7_QUJE)* C7_PRECO) SALDO "+_cEnter
	cQuery += "FROM "+_cEnter
	cQuery += RetSqlName("SC7") + " SC7 "+_cEnter
	cQuery += "WHERE "+_cEnter
	cQuery += "SC7.C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND SC7.D_E_L_E_T_ = ' ' AND "+_cEnter
	cQuery += "SC7.C7_FORNECE = '"+cCdFornec+"' AND "+_cEnter
	cQuery += "(SC7.C7_QUANT-SC7.C7_QUJE)>0 AND "+_cEnter
	cQuery += "( ((SC7.C7_QUANT-SC7.C7_QUJE)*SC7.C7_PRECO) > (SELECT SUM(ZB2_VALOR) SALDO "+_cEnter
	cQuery += 				   					   "FROM "+RetSqlName("ZB1")+" ZB1a, "+RetSqlName("ZB2")+" ZB2a "+_cEnter
	cQuery += 									  "WHERE ZB1a.ZB1_FILIAL='"+xFilial("ZB1")+"' AND ZB1a.D_E_L_E_T_ = ' ' "+_cEnter
	cQuery +=									    "AND ZB2a.ZB2_FILIAL='"+xFilial("ZB2")+"' AND ZB2a.D_E_L_E_T_ = ' ' "+_cEnter
	cQuery += 									    "AND ZB1a.ZB1_FORNEC+ZB1a.ZB1_LOJA='"+cCdFornec+cLjFornec+"' "+_cEnter
	cQuery +=									 	"AND ZB2a.ZB2_PEDCOM=SC7.C7_NUM "+_cEnter
	cQuery += 									 	"AND ZB2a.ZB2_PROVIS=ZB1a.ZB1_PROVIS) "+_cEnter
	cQuery += "OR SC7.C7_NUM NOT IN (SELECT ZB2_PEDCOM FROM "+RetSqlName("ZB2")+" ZB2b "
	cQuery += 					 "WHERE ZB2b.ZB2_FILIAL='"+xFilial("ZB2")+"' AND ZB2b.D_E_L_E_T_ = ' ' "
	cQuery += 					   "AND ZB2b.ZB2_FORNEC+ZB2b.ZB2_LOJA='"+cCdFornec+cLjFornec+"') ) "
	
	cQuery += "ORDER BY " + SqlOrder( SC7->( IndexKey() ) )
	*/
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
				aConteudos := {.F.,(cAliasSC7)->C7_LOJA,(cAliasSC7)->C7_NUM,DTOC((cAliasSC7)->C7_EMISSAO),IIF((cAliasSC7)->C7_TIPO==2,"AE","PC"), (cAliasSC7)->SALDO }
				aadd(aF4For, aConteudos )
				aAdd(aRecSC7,Iif(lQuery,(cAliasSC7)->RECSC7,RecNo()))
			Else
				aF4For[nF4For][6] += (cAliasSC7)->SALDO
			EndIf
		EndIf
		
		(cAliasSC7)->(dbSkip())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe os dados na Tela                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( !Empty(aF4For) )
		
		aTitCampos := {" ","Loja","Pedido","Emissao","Origem","Saldo" }
		
		cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],"+;
		"aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],Transform(aF4For[oListBox:nAT][6], '@E 999,999,999.99')"
		
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
		
		If M->ZB1_VALDOC<=0
			cMsg:="Digite primeiramente o valor da Provisão!"
			Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
			Return(.T.)
		EndIf
		
		Processa({|| TrazPCVl(aF4For,nOpc,cCdFornec,cLjFornec)})
		
		//	VlDocume:Refresh()
		
	Else
		Help(" ",1,"A103F4")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a Integridade dos dados de Entrada              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lQuery
		(cAliasSC7)->(dbCloseArea())
	Endif
	SetKey(VK_F4,bSavSetKey)
	SetKey(VK_F5,bSavKeyF5)
	SetKey(VK_F6,bSavKeyF6)
	SetKey(VK_F7,bSavKeyF7)
	SetKey(VK_F8,bSavKeyF8)
	SetKey(VK_F9,bSavKeyF9)
	SetKey(VK_F10,bSavKeyF10)
	SetKey(VK_F11,bSavKeyF11)
	
	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aArea)
	
	Return(.T.)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³TrazPCVl  ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³04/07/07  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Processa o carregamento do pedido de compras para a        ³±±
	±±³          ³ Provisao Contabil                                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpA1 = Array com os itens do pedido de compras            ³±±
	±±³          ³ ExpN1 = Opcao valida                                       ³±±
	±±³          ³ ExpC1 = Fornecedor                                         ³±±
	±±³          ³ ExpC2 = loja fornecedor                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ SCUCTB12                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function TrazPCVl(aF4For,nOpc,cA100For,cLoja)
	
	Local nx           := 0
	Local cSeek        := ""
	Local aStruZB1     := ZB1->(dbStruct())
	Local aTemp 	   := {}
	Local nVlSaldo	   := 0
	Local lFirst := .T.
	
	If ( nOpc == 1 )
		For nx	:= 1 to Len(aF4For)
			If aF4For[nx][1]
				If lFirst
					aCabPC := {}
					aSldPc := {}
					lFirst := .F.
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona Fornecedor                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial()+cA100For+cLoja)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona Pedido de Compra                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SC7")
				dbSetOrder(9)
				cSeek := ""
				cSeek += xFilEnt(xFilial())+cA100For
				cSeek += aF4For[nx][2]+aF4For[nx][3]
				MsSeek(cSeek)
				dbSelectArea("SC7")
				dbSetOrder(14)
				//			cNrContra := SC7->C7_CONTRA
				cNrPedCom := SC7->C7_NUM
				While ( !Eof() .And. SC7->C7_FILENT+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM==cSeek )
					/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. O campo C7_VALIPI³
					³                                  foi incluido na soma.       											 ³
					³ Douglas em Nov/2016: OS 3241/16 - Inclusão da função Round, para realizar arredondamento do Total.     ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				//	nTotPed:=	Round(SC7->((C7_QUANT-C7_QUJE-C7_QTDACLA)*C7_PRECO)+SC7->C7_VALIPI,2)
					nTotPed:=	Round(SC7->((C7_QUANT-C7_QUJE)*C7_PRECO)+SC7->C7_VALIPI,2) // OS 0237/17 - Douglas David
					
					aAdd( aCabPC, { SC7->C7_NUM, SC7->C7_CC, SC7->C7_ITEMCTA, SC7->C7_CLVL, nTotPed, SC7->C7_CONTRA, "", 0 } )
					
					dbSelectArea("SC7")
					dbSkip()
				End
				If cAprovAnt=="S"
					Exit
				EndIf
				//			nVlSldPC:=nVlDocume
			EndIf
		Next
		
		If Len(aCabPC)>0
			
			aTemp 	:= aClone(aCabPC)
			aSort(aTemp,,, { |x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4] } )
			aCabPC	:= {}
			
			cChAnt := " "
			For nI:=1 to Len(aTemp)
				If aTemp[nI][1]+aTemp[nI][2]+aTemp[nI][3]+aTemp[nI][4] != cChAnt
					aAdd(aCabPC, aTemp[nI])
					cChAnt := aTemp[nI][1]+aTemp[nI][2]+aTemp[nI][3]+aTemp[nI][4]
					nIt:=nI
				Else
					// aCabPC[nIt][5]+=aTemp[nI][5]
					// -> Sergio em 01/Ago/2007: Ajuste no Array Out Of Bounds. A linha acima era a linha
					//                           original. Abaixo, o Ascan resolve o problema
					nAxot := Ascan( aCabPC, { |x| x[1]+x[2]+x[3]+x[4] == aTemp[nI][1]+aTemp[nI][2]+aTemp[nI][3]+aTemp[nI][4] } )
					aCabPC[nAxot][5] += aTemp[nI][5]
				EndIf
			Next nI
			
			For nI:=1 to Len(aCabPC)
				
				cChAnt := aCabPC[nI][1]+aCabPC[nI][2]+aCabPC[nI][3]+aCabPC[nI][4]
				
				cAliasZB1 := "QRYVAL"
				
				If Select(cAliasZB1)>0
					(cAliasZB1)->(dbCloseArea())
				EndIf
				
				cQuery := "SELECT SUM(ZB2_VALOR) VALOR FROM "+_cEnter
				cQuery += RetSqlName("ZB2") + " ZB2 "+_cEnter
				cQuery += "WHERE "+_cEnter
				cQuery += "ZB2_FILIAL = '"+xFilial("ZB2")+"' AND ZB2.D_E_L_E_T_ = ' ' AND "+_cEnter
				cQuery += "ZB2_FORNEC+ZB2_LOJA = '"+cCdFornec+cLjFornec+"' AND "+_cEnter
				cQuery += "ZB2_PEDCOM+ZB2_CCUSTO+ZB2_ITEMCT+ZB2_CLVL='"+cChAnt+"' "
				
				cQuery := ChangeQuery(cQuery)
				
				If Select(cAliasZB1)>0
					(cAliasZB1)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZB1,.T.,.T.)
				
				(cAliasZB1)->(dbGoTop())
				
				If !(cAliasZB1)->(Eof().And.Bof())
					nVlSaldo := (cAliasZB1)->VALOR
				Else
					nVlSaldo := 0
				EndIf
				
				aCabPC[nI][5]-=nVlSaldo
				
				nPC := Ascan( aSldPC, { |x| x[1] = aCabPC[nI][1] } )
				If nPC>0
					aSldPC[nPc][2] += aCabPC[nI][5]
				Else
					aAdd( aSldPC, { aCabPC[nI][1], aCabPC[nI][5] } )
					aSort(aSldPC,,, { |x,y| x[1] < y[1] } )
				EndIf
				
			Next nI
			
			MontAcols(,,aCabPC)
			
			If !Empty(aCols[1][1])
				RecValZB2()
				For nI:=1 to Len(aCols)
					aCols[nI][nPosPerEZ] := Round( ( aCols[nI][nPosValEZ] / M->ZB1_VALDOC) * 100  , 2 )
				Next nI
				oGetDados:aCols := aCols
				oGetDados:ForceRefresh()
				
			EndIf
		EndIf
		
	EndIf
	
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
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ TrazItPC ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³17/07/07  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Tela de importacao de Pedidos de Compra por Item.           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³TrazItPC()                                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³CSUCTB12                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function TrazItPC(aPedido)
	
	Local cSeek      := ""
	Local nOpca      := 0
	Local aArea      := GetArea()
	Local aAreaSA2	  := SA2->(GetArea())
	Local aAreaSC7	  := SC7->(GetArea())
	Local aAreaSB1	  := SB1->(GetArea())
	Local aStruSC7   := SC7->(dbStruct())
	Local aCab       := {}
	Local aCampos    := {}
	Local aNew       := {}
	Local aArrayF4	  := {}
	Local aArrSldo	 := {}
	Local aTamCab     := {}
	Local oOk        := LoadBitMap(GetResources(), "LBOK")
	Local oNo        := LoadBitMap(GetResources(), "LBNO")
	Local aButtons	  := { 	{'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},"Visualiza Pedido","Visualiza Pedido2"},;
	{'DBG10',{||A103PesqP(aCab,aCampos,aArrayF4,oQual)},"Pesquisar"} }
	Local bSavSetKey  := SetKey(VK_F4,Nil)
	Local bSavKeyF5   := SetKey(VK_F5,Nil)
	Local bSavKeyF6   := SetKey(VK_F6,Nil)
	Local bSavKeyF7   := SetKey(VK_F7,Nil)
	Local bSavKeyF8   := SetKey(VK_F8,Nil)
	Local bSavKeyF9   := SetKey(VK_F9,Nil)
	Local bSavKeyF10  := SetKey(VK_F10,Nil)
	Local bSavKeyF11  := SetKey(VK_F11,Nil)
	Local nFreeQt     := 0
	Local cQuery      := ""
	Local cAliasSC7   := "SC7"
	Local cCpoObri    := ""
	Local nSavQual
	Local nPed        := 0
	Local nX          := 0
	Local nAuxCNT     := 0
	Local lRet103Vpc  := .T.
	Local lContinua   := .T.
	Local lQuery      := .F.
	Local oQual
	Local oDlg
	Local bWhile
	Local nVlSaldo 	  := 0
	Local lFirst := .T.
	DEFAULT aPedido	  := {}
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial()+cCdFornec+cLjFornec)
	cNomeFor	:= SA2->A2_NOME
	
	dbSelectArea("SC7")
	
	lQuery    := .T.
	cAliasSC7 := "_QRYSC7"
	
	If Select(cAliasSC7)>0
		(cAliasSC7)->(dbCloseArea())
	EndIf
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. Foi mantido o   ³
	³                                  metodo anterior para consulta.                                       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ((C7_QUANT-C7_QUJE)* C7_PRECO) SALDO "+_cEnter
	cQuery := "SELECT 	SC7.*, R_E_C_N_O_ RECSC7, ( ((C7_QUANT-C7_QUJE)* C7_PRECO)+C7_VALIPI ) SALDO "+_cEnter
	cQuery += "FROM "+_cEnter
	cQuery += RetSqlName("SC7") + " SC7 "+_cEnter
	cQuery += "WHERE "+_cEnter
	cQuery += "SC7.C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND SC7.D_E_L_E_T_ = ' ' AND "+_cEnter
	cQuery += "SC7.C7_FORNECE = '"+M->ZB1_FORNEC+"' AND "+_cEnter
	cQuery += "(SC7.C7_QUANT-SC7.C7_QUJE)>0 AND "+_cEnter
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. O campo C7_VALIPI³
	³                                  foi incluido na soma.                                                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cQuery += "( ( ((SC7.C7_QUANT-SC7.C7_QUJE)*SC7.C7_PRECO)+C7_VALIPI) > (SELECT SUM(ZB2_VALOR) SALDO "+_cEnter
	cQuery += 				   					   "FROM "+RetSqlName("ZB1")+" ZB1a, "+RetSqlName("ZB2")+" ZB2a "+_cEnter
	cQuery += 									  "WHERE ZB1a.ZB1_FILIAL='"+xFilial("ZB1")+"' AND ZB1a.D_E_L_E_T_ = ' ' "+_cEnter
	cQuery +=									    "AND ZB2a.ZB2_FILIAL='"+xFilial("ZB2")+"' AND ZB2a.D_E_L_E_T_ = ' ' "+_cEnter
	cQuery += 									    "AND ZB1a.ZB1_FORNEC+ZB1a.ZB1_LOJA='"+cCdFornec+cLjFornec+"' "+_cEnter
	cQuery +=									 	"AND ZB2a.ZB2_PEDCOM=SC7.C7_NUM "+_cEnter
	//cQuery +=										"AND ZB2a.ZB2_PRODUT=SC7.C7_PRODUTO "+_cEnter
	cQuery += 									 	"AND ZB2a.ZB2_PROVIS=ZB1a.ZB1_PROVIS) "+_cEnter
	cQuery += "OR SC7.C7_NUM NOT IN (SELECT ZB2_PEDCOM FROM "+RetSqlName("ZB2")+" ZB2b "+_cEnter
	cQuery += 					 "WHERE ZB2b.ZB2_FILIAL='"+xFilial("ZB2")+"' AND ZB2b.D_E_L_E_T_ = ' ' "+_cEnter
	cQuery += 					   "AND ZB2b.ZB2_FORNEC+ZB2b.ZB2_LOJA='"+cCdFornec+cLjFornec+"') ) "+_cEnter
	
	cQuery += "ORDER BY " + SqlOrder( SC7->( IndexKey() ) )
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
	
	For nX := 1 To Len(aStruSC7)
		If aStruSC7[nX,2]<>"C"
			TcSetField(cAliasSC7,aStruSC7[nX,1],aStruSC7[nX,2],aStruSC7[nX,3],aStruSC7[nX,4])
		EndIf
	Next nX
	
	bWhile := {|| (cAliasSC7)->(!Eof())}
	
	aCpoObri := { "C7_LOJA","C7_NUM","C7_ITEM","C7_PRODUTO","SALDO","C7_DESCRI"}
	
	If (cAliasSC7)->(!Eof())
		aCols := {}
		
		aAdd(aCab," ")
		aAdd(aCampos,{"OK","L",,})
		aAdd(aTamCab,2)
		
		For _nY=1 to Len(aCpoObri)
			If aCpoObri[_nY]=="SALDO"
				aAdd(aCab,"Saldo")
				aAdd(aCampos,{"SALDO","N",,"@E 9999,999,999.99"})
				aAdd(aTamCab,15)
			Else
				dbSelectArea("SX3")
				dbSetOrder(2)
				MsSeek(aCpoObri[_nY])
				AAdd(aCab,x3Titulo())
				Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
				aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
			EndIf
		Next _nY
		
		dbSelectArea(cAliasSC7)
		While Eval(bWhile)
			
			If ( Empty((cAliasSC7)->C7_RESIDUO) .And. (cAliasSC7)->C7_TPOP <> "P" )
				
				Aadd(aArrayF4,Array(Len(aCampos)))
				For nX := 1 to Len(aCampos)
					
					If aCampos[nX][3] != "V"
						If aCampos[nX][2] == "N"
							If Alltrim(aCampos[nX][1]) == "SALDO"
								aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->SALDO,"@E 9999,999,999.99")
							Else
								aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
							Endif
						Else
							If nX==1
								aArrayF4[Len(aArrayF4)][nX] := .F.
							Else
								aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))
							Endif
						Endif
					Else
						aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
					EndIf
				Next nX
				
				AAdd( aArrSldo,{(cAliasSC7)->SALDO,Iif(lQuery,(cAliasSC7)->RECSC7,RecNo())} )
			EndIf
			(cAliasSC7)->(dbSkip())
		End
		
		If !Empty(aArrayF4)
			
			cLine := "{ If( aArrayF4[oQual:nAt,1],oOk,oNo ), aArrayF4[oQual:nAT][2], aArrayF4[oQual:nAT][3], aArrayF4[oQual:nAT][4], aArrayF4[oQual:nAT][5], aArrayF4[oQual:nAT][6] }"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta dinamicamente o bline do CodeBlock                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			bLine := &( "{ || " + cLine + " }" )
			
			
			DEFINE MSDIALOG oDlg FROM 30,20  TO 265,521 TITLE OemToAnsi("Selecionar Pedido de Compra ( por item ) - <F6> ") Of oMainWnd PIXEL
			
			oQual := TWBrowse():New( 29,4,243,76,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oQual:SetArray(aArrayF4)
			oQual:bLDblClick := { || aArrayF4[oQual:nAt,1] := !aArrayF4[oQual:nAt,1] }
			oQual:bLine := bLine
			
			@ 15  ,4   SAY OemToAnsi("Fornecedor") Of oDlg PIXEL SIZE 47 ,9
			@ 14  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oDlg PIXEL SIZE 120,9
			
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nSavQual:=oQual:nAT,nOpca:=1,oDlg:End()},{||oDlg:End()},,aButtons)
			
			If M->ZB1_VALDOC<=0
				cMsg:="Digite primeiramente o valor da Provisão!"
				Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
				Return(.T.)
			EndIf
			
			If nOpca == 1
				For nI:=1 to Len(aArrayF4)
					If aArrayF4[nI][1]
						If lFirst
							aItePC := {}
							aSldPC := {}
							lFirst := .F.
						EndIf
						dbSelectArea("SC7")
						MsGoto(aArrSldo[nI][2])
						/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Sergio em Jun/2010: OS 0880/10 - Considerar o valor do FRETE para totalizar o Pedido. O campo C7_VALIPI³
						³                                  foi incluido na soma.                                                ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						aAdd( aItePC, { SC7->C7_NUM, SC7->C7_CC, SC7->C7_ITEMCTA, SC7->C7_CLVL, SC7->((C7_QUANT-C7_QUJE)*C7_PRECO)+SC7->C7_VALIPI, SC7->C7_CONTRA," ", 0 } )
						If cAprovAnt=="S"
							Exit
						Endif
					EndIf
				Next nI
				
				If Len(aItePC)>0
					aTemp 	:= aClone(aItePC)
					aSort(aTemp,,, { |x,y| x[1]+x[7]+x[2]+x[3]+x[4] < y[1]+y[7]+y[2]+y[3]+y[4] } )
					aItePC	:= {}
					
					cChAnt := " "
					For nI:=1 to Len(aTemp)
						If aTemp[nI][1]+aTemp[nI][7]+aTemp[nI][2]+aTemp[nI][3]+aTemp[nI][4] != cChAnt
							aAdd(aItePC, aTemp[nI])
							cChAnt := aTemp[nI][1]+aTemp[nI][7]+aTemp[nI][2]+aTemp[nI][3]+aTemp[nI][4]
							nAt:=nI
						Else
							nAxot := Ascan( aItePC, { |x| x[1]+x[2]+x[3]+x[4] == aTemp[nI][1]+aTemp[nI][2]+aTemp[nI][3]+aTemp[nI][4] } )
							aItePC[nAxot][5] += aTemp[nI][5]
						EndIf
					Next nI
					
					For nI:=1 to Len(aItePC)
						
						//					cChAnt := aItePC[nI][1]+aItePC[nI][7]+aItePC[nI][2]+aItePC[nI][3]+aItePC[nI][4]
						cChAnt := aItePC[nI][1]+aItePC[nI][2]+aItePC[nI][3]+aItePC[nI][4]
						
						cAliasZB1 := "QRYVAL"
						
						If Select(cAliasZB1)>0
							(cAliasZB1)->(dbCloseArea())
						EndIf
						
						cQuery := "SELECT SUM(ZB2_VALOR) VALOR FROM "+_cEnter
						cQuery += RetSqlName("ZB2") + " ZB2 "+_cEnter
						cQuery += "WHERE "+_cEnter
						cQuery += "ZB2_FILIAL = '"+xFilial("ZB2")+"' AND ZB2.D_E_L_E_T_ = ' ' AND "+_cEnter
						cQuery += "ZB2_FORNEC+ZB2_LOJA = '"+cCdFornec+cLjFornec+"' AND "+_cEnter
						//					cQuery += "ZB2_PEDCOM+ZB2_PRODUT+ZB2_CCUSTO+ZB2_ITEMCT+ZB2_CLVL='"+cChAnt+"' "
						cQuery += "ZB2_PEDCOM+ZB2_CCUSTO+ZB2_ITEMCT+ZB2_CLVL='"+cChAnt+"' "
						
						cQuery := ChangeQuery(cQuery)
						
						If Select(cAliasZB1)>0
							(cAliasZB1)->(dbCloseArea())
						EndIf
						
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZB1,.T.,.T.)
						
						(cAliasZB1)->(dbGoTop())
						
						If !(cAliasZB1)->(Eof().And.Bof())
							nVlSaldo := (cAliasZB1)->VALOR
						Else
							nVlSaldo := 0
						EndIf
						
						aItePC[nI][5]-=nVlSaldo
						
						nPC := Ascan( aSldPC, { |x| x[1] = aItePC[nI][1] } )
						If nPC>0
							aSldPC[nPc][2] += aItePC[nI][5]
						Else
							aAdd( aSldPC, { aItePC[nI][1], aItePC[nI][5] } )
							aSort(aSldPC,,, { |x,y| x[1] < y[1] } )
						EndIf
						
					Next nI
					
					MontAcols(,,aItePC)
					
					If !Empty(aCols[1][1])
						RecValZB2()
						For nI:=1 to Len(aCols)
							aCols[nI][nPosPerEZ] := Round( ( aCols[nI][nPosValEZ] / M->ZB1_VALDOC) * 100  , 2 )
						Next nI
						oGetDados:aCols := aCols
						oGetDados:ForceRefresh()
					EndIf
				EndIf
			EndIf
			
		Else
			Help(" ",1,"A103F4")
		EndIf
	Else
		Help(" ",1,"A103F4")
	EndIf
	
	If Select(cAliasSC7)>0
		(cAliasSC7)->(dbCloseArea())
	EndIf
	
	SetKey(VK_F4,bSavSetKey)
	SetKey(VK_F5,bSavKeyF5)
	SetKey(VK_F6,bSavKeyF6)
	SetKey(VK_F7,bSavKeyF7)
	SetKey(VK_F8,bSavKeyF8)
	SetKey(VK_F9,bSavKeyF9)
	SetKey(VK_F10,bSavKeyF10)
	SetKey(VK_F11,bSavKeyF11)
	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aAreaSB1)
	RestArea(aArea)
	
	Return(.T.)
	
	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³a103PesqP ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³17/07/07   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Seek no browse de itens de pedidos de compra                 ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpA1 : Array das descricoes dos cabecalhos                  ³±±
	±±³          ³ExpA2 : Array com os campos                                  ³±±
	±±³          ³ExpA3 : Array com os conteudos                               ³±±
	±±³          ³ExpO4 : Objeto do listbox                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                       ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Esta rotina tem como objetivo abrir uma janela de pesquisa   ³±±
	±±³          ³em browses de getdados poisicionando na llinha caso encontre ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function a103PesqP(aCab,aCampos,aArrayF4,oQual)
	
	Local aCpoBusca := {}
	Local aCpoPict  := {}
	
	Local cPesq   := Space(30)
	Local cBusca  := ""
	Local cTitulo := OemtoAnsi("Pesquisar")
	
	Local nOpca   := 0
	Local nPos    := 0
	Local nx      := 0
	Local nTipo   := 1
	Local nBusca  := Iif(oQual:nAt == Len(aArrayF4) .Or. oQual:nAt == 1, oQual:nAt, oQual:nAt+1 )
	
	Local oDlg
	Local oBusca
	Local oPesq1
	Local oPesq2
	Local oPesq3
	Local oPesq4
	
	For nX := 1 to Len(aCampos)
		AAdd(aCpoBusca,aCab[nX])
		AAdd(aCpoPict,aCampos[nX][4])
	Next
	
	If Len(aCampos) > 0 .And. Len(aArrayF4) > 0
		
		DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo)  FROM 00,0 TO 100,490 OF oMainWnd PIXEL
		
		@ 05,05 MSCOMBOBOX oBusca VAR cBusca ITEMS aCpoBusca SIZE 206, 36 OF oDlg PIXEL ON CHANGE (nTipo := oBusca:nAt,A103ChgPic(nTipo,aCampos,@cPesq,@oPesq1,@oPesq2,@oPesq3,@oPesq4))
		
		@ 022,005 MSGET oPesq1 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
		
		@ 022,005 MSGET oPesq2 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
		
		@ 022,005 MSGET oPesq3 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
		
		@ 022,005 MSGET oPesq4 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
		
		oPesq1:Hide()
		oPesq2:Hide()
		oPesq3:Hide()
		oPesq4:Hide()
		
		Do Case
			Case aCampos[1][2] == "C"
				
				dbSelectArea("SX3")
				dbSetOrder(2)
				If MsSeek(aCampos[1][1])
					If !Empty(SX3->X3_F3)
						oPesq2:cF3 := SX3->X3_F3
						oPesq1:Hide()
						oPesq2:Show()
						oPesq3:Hide()
						oPesq4:Hide()
					Else
						oPesq1:Show()
						oPesq2:Hide()
						oPesq3:Hide()
						oPesq4:Hide()
					Endif
				Endif
				
			Case aCampos[1][2] == "D"
				oPesq1:Hide()
				oPesq2:Hide()
				oPesq3:Show()
				oPesq4:Hide()
			Case aCampos[1][2] == "N"
				oPesq1:Hide()
				oPesq2:Hide()
				oPesq3:Hide()
				oPesq4:Show()
		EndCase
		
		cPesq := CriaVar(aCampos[1][1],.F.)
		cPict := aCampos[1][4]
		
		DEFINE SBUTTON oBut1 FROM 05, 215 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE of oDlg
		DEFINE SBUTTON oBut1 FROM 20, 215 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpca == 1
			
			Do Case
				
				Case aCampos[nTipo][2] == "C"
					nPos := Ascan(aArrayF4,{|x| Alltrim(cPesq) == Alltrim(x[nTipo])},nBusca)
				Case aCampos[nTipo][2] == "N"
					nPos := Ascan(aArrayF4,{|x| Transform(cPesq,PesqPict("SC7",aCampos[nTipo][1])) == x[nTipo]},nBusca)
				Case aCampos[nTipo][2] == "D"
					nPos := Ascan(aArrayF4,{|x| Dtos(cPesq) == Dtos(x[nTipo])},nBusca)
			EndCase
			
			If nPos > 0
				oQual:bLine := { || aArrayF4[oQual:nAT] }
				oQual:nFreeze := 1
				oQual:nAt := nPos
				oQual:Refresh()
				oQual:SetFocus()
			Else
				Help(" ",1,"REGNOIS")
			Endif
			
		EndIf
		
	Endif
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜßÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VerRatAnt    º Autor ³ Daniel G.Jr.TI1239 º Data ³  04/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Validar campo de Aproveitar Provisao Anterior                  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function VerRatAnt()
	
	Local nSldPed    := 0
	Local nOpc       := 0
	Local nx         := 0
	Local cQuery     := ""
	Local cAliasZB1  := "ZB1"
	Local lQuery     := .F.
	Local bSavSetKey := SetKey(VK_F4,Nil)
	Local bSavKeyF5  := SetKey(VK_F5,{||TrazPC()})
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
	Local aAreaZB1   := ZB1->(GetArea())
	Local aStruZB1   := ZB1->(dbStruct())
	Local aF4For     := {}
	Local nF4For     := 0
	Local oOk        := LoadBitMap(GetResources(), "LBOK")
	Local oNo        := LoadBitMap(GetResources(), "LBNO")
	Local oDlg,oListBox
	Local cNomeFor   := ''
	Local aRecZB1    := {}
	Local aTitCampos := {}
	Local aConteudos := {}
	Local aUsCont    := {}
	Local aUsTitu    := {}
	Local bLine      := { || .T. }
	Local cLine      := ""
	Local nLoop      := 0
	Local lContinua  := .T.
	Local aButtons   := {}
	Local cProvis    := ""
	
	If M->ZB1_APROVA=="N"
		Return(.T.)
	EndIf
	
	If M->ZB1_VALDOC<=0
		cMsg:="Digite primeiramente o valor da Provisão!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		Return(.T.)
	EndIf
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial()+cCdFornec+cLjFornec)
	cNomeFor	:= SA2->A2_NOME
	
	dbSelectArea("ZB1")
	ZB1->( dbSetOrder( 1 ) )
	lQuery    := .T.
	cAliasZB1 := "QRYZB1"
	
	cQuery := "SELECT ZB1.*, R_E_C_N_O_ RECZB1 FROM "+_cEnter
	cQuery += RetSqlName("ZB1") + " ZB1 "+_cEnter
	cQuery += "WHERE "+_cEnter
	cQuery += "ZB1_FILIAL = '"+xFilial("ZB1")+"' AND "+_cEnter
	cQuery += "ZB1_FORNEC = '"+cCdFornec+"' AND "+_cEnter
	cQuery += "ZB1.D_E_L_E_T_ = ' ' "+_cEnter
	cQuery += "ORDER BY " + SqlOrder( ZB1->( IndexKey() ) )
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasZB1)>0
		(cAliasZB1)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZB1,.T.,.T.)
	
	For nX := 1 To Len(aStruZB1)
		If aStruZB1[nX,2]<>"C"
			TcSetField(cAliasZB1,aStruZB1[nX,1],aStruZB1[nX,2],aStruZB1[nX,3],aStruZB1[nX,4])
		EndIf
	Next nX
	
	(cAliasZB1)->(dbGoTop())
	bWhile := {|| (cAliasZB1)->(!Eof())}
	
	While Eval(bWhile)
		
		nF4For := aScan(aF4For,{|x|x[2]==(cAliasZB1)->ZB1_LOJA .And. x[3]==(cAliasZB1)->ZB1_PROVIS})
		If ( nF4For == 0 )
			
			aConteudos := {.F., (cAliasZB1)->ZB1_LOJA, (cAliasZB1)->ZB1_PROVIS, DTOC((cAliasZB1)->ZB1_DTDIGI), (cAliasZB1)->ZB1_VALDOC, (cAliasZB1)->ZB1_USUARI }
			
			aadd(aF4For, aConteudos )
			aAdd(aRecZB1,Iif(lQuery,(cAliasZB1)->RECZB1,RecNo()))
		EndIf
		(cAliasZB1)->(dbSkip())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe os dados na Tela                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( !Empty(aF4For) )
		
		aTitCampos := {" ","Loja","Provisão","Dt.Digita.","Valor","Usuário" }
		
		cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],Transform(aF4For[oListBox:nAT][6], '@E 999,999,999.99')"
		
		cLine += " } "
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta dinamicamente o bline do CodeBlock                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		bLine := &( "{ || " + cLine + " }" )
		
		
		DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi("Selecionar Provisão Anterior") Of oMainWnd PIXEL
		
		oListBox := TWBrowse():New( 27,4,243,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aF4For)
		oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
		oListBox:bLine := bLine
		
		@ 15  ,4   SAY OemToAnsi("Fornecedor") Of oDlg PIXEL SIZE 47 ,9
		@ 14  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oDlg PIXEL SIZE 120,9
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)
		
		If ( nOpc == 1 )
			cProvis := ""
			For nx	:= 1 to Len(aF4For)
				If aF4For[nx][1]
					cProvis := aF4For[nx][3]
					Exit
				EndIf
			Next nx
			
			If Empty(cProvis)
				Aviso("Atenção!","Nenhuma Provisão anterior foi escolhida!",{"Fechar"},2)
			Else
				MontAcols(cProvis,.F.)
				
				If !Empty(aCols[1][1])
					For nI:=1 to Len(aCols)
						aCols[nI][nPosValEZ] := Round( ( aCols[nI][nPosPerEZ] / 100 ) * M->ZB1_VALDOC , 2 )
					Next nI
					oGetDados:aCols := aCols
					oGetDados:ForceRefresh()
					RecValZB2()
				EndIf
			EndIf
		EndIf
		
	Else
		Help(" ",1,"A103F4")
		M->ZB1_APROVA:="N"
		cAprovAnt:="N"
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a Integrida dos dados de Entrada                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lQuery
		(cAliasZB1)->(dbCloseArea())
	Endif
	SetKey(VK_F4,bSavSetKey)
	SetKey(VK_F5,bSavKeyF5)
	SetKey(VK_F6,bSavKeyF6)
	SetKey(VK_F7,bSavKeyF7)
	SetKey(VK_F8,bSavKeyF8)
	SetKey(VK_F9,bSavKeyF9)
	SetKey(VK_F10,bSavKeyF10)
	SetKey(VK_F11,bSavKeyF11)
	
	RestArea(aAreaSA2)
	RestArea(aAreaZB1)
	RestArea(aArea)
	
	Return(.T.)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜßÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ MontAcols    º Autor ³ Daniel G.Jr.TI1239 º Data ³  04/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Montar aCols com provisão                                      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function MontAcols(cProvis,lRec,aPedidos)
	
	Local lFirst	:=	.T.
	Local lContinua	:=	.T.
	Local lPedidos  :=  .F.
	Local nI, nY,cCampo,cItem:="001"
	Local cNCampos:="ZB2_PEDCOM,ZB2_VALOR,ZB2_CONTRA"
	
	Default cProvis := ""
	Default lRec    := .F.
	Default aPedidos:= {}
	lPedidos		:= Len(aPedidos)>0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trava os registros do ZB1 - Alteracao e Exclusao       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALTERA .Or. lProvExclui
		If !SoftLock("ZB1")
			lContinua := .F.
		EndIf
	EndIf
	If lContinua
		If lPedidos
			If M->ZB1_APROVA!="S"
				aCols := {}
			EndIf
			For nI:=1 to Len(aPedidos)
				
				If M->ZB1_APROVA!="S"
					
					If Len(aCols)<nI
						AdicCols()
					EndIf
					
					If !aCols[nI][nUsado+1]
						
						nX:=Len(aCols)
						
						For nY := 1 To nUsado
							//SC7->C7_NUM, SC7->C7_CC, SC7->C7_ITEMCTA, SC7->C7_CLVL, SC7->((C7_QUANT-C7_QUJE-C7_QTDACLA)*C7_PRECO), SC7->C7_CONTRA
							cCampo:=AllTrim(aHeader[nY][2])
							Do Case
								Case cCampo=="ZB2_ITEM"
									aCols[nX][nY] := StrZero(nX,3)
								Case cCampo=="ZB2_NATURE"
									aCols[nX][nY] := Iif(!Empty(aPedidos[nI][7]),aPedidos[nI][7],CriaVar(aHeader[nY][2]))
								Case cCampo=="ZB2_PEDCOM"
									aCols[nX][nY] := aPedidos[nI][1]
								Case cCampo=="ZB2_CCUSTO"
									aCols[nX][nY] := aPedidos[nI][2]
								Case cCampo=="ZB2_ITEMCT"
									aCols[nX][nY] := aPedidos[nI][3]
								Case cCampo=="ZB2_CLVL"
									aCols[nX][nY] := aPedidos[nI][4]
								Case cCampo=="ZB2_VALOR"
									aCols[nX][nY] := aPedidos[nI][5]
								Case cCampo=="ZB2_CONTRA"
									aCols[nX][nY] := aPedidos[nI][6]
								Case cCampo=="ZB2_PERCEN"
									aCols[nX][nY] := Iif(!Empty(aPedidos[nI][8]),aPedidos[nI][8],CriaVar(aHeader[nY][2]))
								Otherwise
									aCols[nX][nY] := CriaVar(aHeader[nY][2])
							EndCase
						Next nY
						aCols[Len(aCols)][nUsado+1] := .F.
						
						// Inicializa Descricao da Natureza
						aCols[Len(aCols)][nPosDesEZ] := Posicione("SED",1,xFilial("SED")+aCols[Len(aCols)][nPosNatEZ],"ED_DESCRIC")
						
					EndIf
				Else			// Carrega Provisao com aproveitamento de anterior
					
					aCols:=oGetDados:aCols
					For _nI:=1 To Len(aCols)
						aCols[_nI][nPosNPCEZ] := aPedidos[nI][1]
						//	aCols[_nI][nPosValEZ] := Round( aCols[_nI][nPosPerEZ] * aPedidos[nI][5] * 0.01 , 2 )
					Next _nI
					
					oGetDados:aCols := aCols
					oGetDados:ForceRefresh()
					lRet := .T.
					Exit
				EndIf
			Next nI
		Else
			//ÚÄÄuÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a montagem do aCols com os dados do ZB2                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("ZB2")
			dbSetOrder(1)
			lQuery    := .T.
			cAliasZB2 := "ProvZB2"
			aStruZB2  := ZB2->(dbStruct())
			cQuery    := "SELECT ZB2.*,ZB2.R_E_C_N_O_ ZB2RECNO "+_cEnter
			cQuery    += "FROM "+RetSqlName("ZB2")+" ZB2 "+_cEnter
			cQuery    += "WHERE ZB2.ZB2_FILIAL='"+xFilial("ZB2")+"' AND "+_cEnter
			cQuery    += "ZB2.ZB2_PROVIS='"+cProvis+"' AND "+_cEnter
			cQuery    += "ZB2.D_E_L_E_T_=' ' "+_cEnter
			cQuery    += "ORDER BY "+SqlOrder(ZB2->(IndexKey()))
			
			cQuery := ChangeQuery(cQuery)
			
			If Select(cAliasZB2)>0
				(cAliasZB2)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZB2,.T.,.T.)
			For nX := 1 To Len(aStruZB2)
				If aStruZB2[nX][2]<>"C"
					TcSetField(cAliasZB2,aStruZB2[nX][1],aStruZB2[nX][2],aStruZB2[nX][3],aStruZB2[nX][4])
				EndIf
			Next nX
			
			bWhileZB2 := { || ( !Eof().And. lContinua .And. ;
			(cAliasZB2)->ZB2_FILIAL == xFilial("ZB2") .And. ;
			(cAliasZB2)->ZB2_PROVIS == cProvis) }
			
			While Eval( bWhileZB2 )
				
				// Para evitar a inclusao de RECNOs de provisao aproveitada
				If lRec
					aadd(aRecZB2,If(lQuery,(cAliasZB2)->ZB2RECNO,(cAliasZB2)->(RecNo())))
				EndIf
				
				If M->ZB1_APROVA!="S" .Or. (M->ZB1_APROVA=="S".And.!lFirst)
					AdicCols()
				EndIf
				
				lFirst:=.F.
				
				For nY := 1 To nUsado
					
					If ( aHeader[nY][10] <> "V")
						If !AllTrim(aHeader[nY][2])$cNCampos .Or. (AllTrim(aHeader[nY][2])$cNCampos .And. M->ZB1_APROVA<>"S")
							aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
						Else
							aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
						EndIf
					Else
						aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
					EndIf
				Next nY
				aCols[Len(aCols)][nUsado+1] := .F.
				
				// Inicializa Descricao da Natureza
				aCols[Len(aCols)][nPosDesEZ] := Posicione("SED",1,xFilial("SED")+aCols[Len(aCols)][nPosNatEZ],"ED_DESCRIC")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua skip na area ZB2 ( regra geral ) ou incrementa o contador ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasZB2)
				dbSkip()
			End
			If lQuery
				(cAliasZB2)->(dbCloseArea())
			EndIf
		EndIf
	EndIf
	If !Len(aCols) > 0
		lContinua := .F.
		Help(" ",1,"RECNO")
	EndIf
	If !lContinua
		If lProvAltera .Or. lProvExclui
			MsUnlockAll()
		EndIf
	EndIf
	
	Return (lContinua)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VerCompet    º Autor ³ Daniel G.Jr.TI1239 º Data ³  04/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Verificar campo competencia                                    º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function VerCompet()
	
	Local lRet	:=	.T.
	Local dCompet := SuperGetMv("MV_XMESNFE")
	Local cCompet := ""
	If !Empty(dCompet)
		cCompet := Left(DtoS(dCompet),6)
	Else
		cCompet := Left(DtoS(dDatabase),6)
	EndIf
	
	If Val(Left(M->ZB1_COMPET,2))<1 .Or. Val(Left(M->ZB1_COMPET,2))>12 .Or. Val(Right(M->ZB1_COMPET,4))<2006
		cMsg:="Mês/Ano de Competência informado está incorreto, verifique!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		lRet := .F.
	Else
		If (Right(M->ZB1_COMPET,4)+Left(M->ZB1_COMPET,2)) > cCompet
			cMsg:="Mês/Ano de Competência informado deve ser menor ou igual ao atual!"+Chr(10)+;
			" (Competência atual: "+Right(cCompet,2)+"/"+Left(cCompet,4)+")"
			Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
			lRet := .F.
		EndIf
	EndIf
	
	Return(lRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ VerValor     º Autor ³ Daniel G.Jr.TI1239 º Data ³  04/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Verificar campo Valor                                          º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function VerValor()
	
	Local lRet	:=	.T.
	
	If M->ZB1_VALDOC > nVlSldPC
		cMsg:="Valor deve ser menor ou igual ao saldo do PC!"+Chr(10)+;
		" (Saldo do PC: "+TransForm(nVlSldPc,"@E 9999,999,999.99")+")"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		lRet := .F.
	EndIf
	
	Return(lRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ DELOK    ºAutor  ³Daniel G.Jr.TI1239  º Data ³  25/01/05   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Funcao acionada na deleção de linha no browse              º±±
	±±º          ³ recalcula os valores                                       º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ MP8                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function DelOk()
	
	Local _lRet := .t., _N:=oGetDados:nAt
	Local _lDel := aCols[_N, Len(aCols[_N])]
	
	If !lExec
		If !_lDel
			nValTot  -= aCols[_N][nPosValEZ]
			nPercTot := (nValTot / M->ZB1_VALDOC) * 100
			oValTot:Refresh()
			oPercTot:Refresh()
		Else
			nValTot  += aCols[_N][nPosValEZ]
			nPercTot := (nValTot / M->ZB1_VALDOC) * 100
			oValTot:Refresh()
			oPercTot:Refresh()
		EndIf
		lExec := .T.
	Else
		lExec := .F.
	EndIf
	
	Return(_lRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³  AjustaDif   º Autor ³ Cristiano Figueiroaº Data ³ 15/03/2006 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Efetua um ajuste na ultima linha do Rateio caso haja          º±±
	±±º          ³ divergencia entr eo Valor a Ratear e Valor Rateado.           º±±
	±±º          ³ Vale apontar que tal rotina somente devera ser disparado      º±±
	±±ºDescricao ³ quando o Percentual Rateado ja tiver atingido os 100 %        º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function AjustaDif( _nValRat , _nValTotal )
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³              Declara as Variaveis Locais Utilizadas na Rotina              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	Local q
	Local nNumColunas := Len( aCols )
	Local lAjuste     := .F.
	Local nValAjuste  := _nValRat - _nValTotal
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	For q := Len( aCols ) to 1 Step -1
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³       Executa o ajuste enquando o Flag estiver igual a Falso        ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		If !lAjuste
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³             Desconsidera os Itens do Acols Deletados                ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			If ! aCols[ q , Len(aHeader) + 1 ]
				
				/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³   Caso o Ajuste seja Negativo Verifica se Tenho Valor Disponivel para Subtrair   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				
				If nValAjuste < 0
					
					If aCols[q][nPosValEZ ] > nValAjuste * -1
						aCols[q][nPosValEZ ] += nValAjuste
						lAjuste := .T.
					Endif
					
				Else
					
					/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³   Caso o Ajuste seja Positivo soma o Valor na Ultima Linha do Rateio             ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					
					aCols[q][nPosValEZ ] += nValAjuste
					lAjuste := .T.
					
				Endif
				
				aCols[q][nPosPerEZ ] := ( aCols[q][nPosValEZ ] / _nValTotal ) * 100
			Endif
			
		Endif
		
		
	Next q
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³PROVCONTABºAutor  ³Daniel G.Jr.TI1239  º Data ³  11/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³Essa Rotina tem como chamar a execucao das rotinas de       º±±
	±±º          ³contabilizacao ou estorno de contabilizacao das provisoes   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ CSU                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function PROVCONTAB(nTipo)
	
	Local aSay    := {}
	Local aButton := {}
	Local nOpc    := 0
	Local cDTipo  := Iif(nTipo==1,"Contabilização","Estorno")
	Local cTitulo := cDTipo+" de provisoes de Pedidos de Compra"
	Local cDesc1  := "Esta rotina tem como finalidade gerar um lancamento padrao para cada "
	Local cDesc2  := "Provisao (Contabilização ou Estorno) "
	Local cDesc3  := " "
	Local cDesc4  := " "
	
	Private cProvis 	:= cTipo := cHistor := cNomUsu := cOrigem := ""
	Private dData   	:= CtoD("")
	Private nValor  	:= nValCr := nValDb := 0
	Private lCtbOk      := .T.
	
	Private cPerg := "CSUC12"
	
	Private lProvContab	:= nTipo==1
	Private lProvEstorn := nTipo==2
	
	cNomUsu := UsrFullName(__CUserID)
	cOrigem := "MANUTENCAO PROVISAO"
	dData	:= DDATABASE
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	
	aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc == 1
		cProvis	:= ZB1->ZB1_PROVIS
		If lProvContab
			Processa( {|| U_ProvConD()},"Aguarde ...","Processando...")
			cHistor := "CONTABILIZACAO DA PROVISAO"
			cTipo	:= "1"
		EndIf
		If lProvEstorn
			Processa( {|| U_ProvEstD()},"Aguarde ...","Processando...")
			cHistor := "ESTORNO DA PROVISAO"
			cTipo	:= "2"
		EndIf
		
		If lCtbOk		// Se foi contabilizado corretamente
			
			// Grava ocorrencias da provisao
			lOcor := U_GrvOcorPrv(cProvis,cTipo,dData,nValor,cOrigem,cHistor,cNomUsu)
			
			Aviso("ATENÇÃO!","A Rotina de "+cDTipo+" das Provisões foi Executada com Sucesso !",{"Ok"})
			
		EndIf
		
	Endif
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ProvConta ºAutor  ³Daniel G.Jr.TI1239  º Data ³  10/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³Processamento das Provisoes Contabeis                       º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³CSU                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function ProvConD()
	
	Local _cQuery
	Local nHdlPrv
	Local cArquivo	:= ""
	Local cPadrao	:= "210"
	Local lPadrao210:= .F.
	Local lPadrao215:= .F.
	//Local nValor 	:= 0
	Local nTotal	:= 0
	Local nZB1Rec	:= 0
	Local cChavSC7	:= ""
	Local _cData	:= mv_par07
	Private cLote	:= ""
	Private cAliasZB1:="WORK"
	Private aStruZB1:= ZB1->(dbStruct())
	Private cRotina := "CSUCTB12"
	Private lCancel	:= .F.
	Private nRazao	:= Iif(lCancel,-1,1)
	
	lPadrao210 := VerPadrao(cPadrao)
	lPadrao215 := VerPadrao("215")
	
	If !lPadrao210 .Or. !lPadrao215
		cMsg:="Lançamento Padrão 210 e/ou 215 não está(ão) configurado(s)!"+cEnter+"Falar com a Contabilidade!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		lCtbOk := .F.
		Return
	EndIf
	
	_cQuery:= "SELECT ZB1.*, ZB1.R_E_C_N_O_  RECZB1, ZB2.R_E_C_N_O_ RECZB2 "+_cEnter
	_cQuery+=   "FROM "
	_cQuery+=   RetSqlName('ZB1')+" ZB1, "+_cEnter
	_cQuery+=   RetSqlName('ZB2')+" ZB2  "+_cEnter
	_cQuery+= "WHERE "
	_cQuery+= 	    "ZB1_FILIAL = '"+xFilial("ZB1")+"' AND ZB1.D_E_L_E_T_ = ' ' "
	_cQuery+=   "AND ZB2_FILIAL = '"+xFilial("ZB2")+"' AND ZB2.D_E_L_E_T_ = ' ' "
	_cQuery+=   "AND ZB1_PROVIS BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+_cEnter
	_cQuery+=   "AND ZB1_DTDIGI BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "+_cEnter
	_cQuery+=   "AND ZB1_FORNEC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "+_cEnter
	_cQuery+=   "AND ZB1_CONFER = 'S' "
	//_cQuery+=   "AND ZB1_DTLCTO = ' ' "+_cEnter
	//_cQuery+=   "AND ZB1_DTESTO = ' ' "+_cEnter
	_cQuery+=   "AND ZB2_PROVIS = ZB1_PROVIS "+_cEnter
	_cQuery+= "ORDER BY ZB1_PROVIS, ZB1_FORNEC "
	_cQuery:= ChangeQuery( _cQuery )
	
	If Select ("WORK") > 0
		WORK->(dbCloseArea())
	EndIf
	
	TcQuery _cQuery New Alias "WORK"
	
	If Select ("WORK") == 0
		ApMSgStop('Não Existem Registros para Serem Processados Nesta Empresa!','Aviso')
		WORK->(dbCloseArea())
		lCtbOk := .F.
		Return
	EndIf
	
	For nX := 1 To Len(aStruZB1)
		If aStruZB1[nX,2]<>"C"
			TcSetField(cAliasZB1,aStruZB1[nX,1],aStruZB1[nX,2],aStruZB1[nX,3],aStruZB1[nX,4])
		EndIf
	Next nX
	
	If "CSUCTB12" $ FunName()
		aF4For := ExibeProvis(1)
	Else
		aF4For := { { , Work->ZB1_PROVIS } }
	EndIf
	
	aProvis:={}
	
	For nI:=1 to Len(aF4For)
		If "CSUCTB12" $ FunName()
			If aF4For[nI][1]
				aAdd(aProvis, aF4For[nI][2])
			EndIf
		Else
			aAdd(aProvis, aF4For[nI][2])
		EndIf
	Next nI
	
	If Len(aProvis)>0
		
		dbSelectArea("WORK")
		WORK->(dbGoTop())
		
		cLote    := "090010"	//LoteCont('COM')
		nHdlPrv  := HeadProva(cLote,cRotina,Substr(cUsuario,7,6),@cArquivo)
		
		u_ContProv1() // 1303 - EDS
		
		While WORK->(!Eof())
			
			If aScan(aProvis,WORK->ZB1_PROVIS)>0
				
				dbSelectArea("ZB1")
				ZB1->(dbSetOrder(1))
				ZB1->(dbGoTo(WORK->RECZB1))
				nZB1Rec  := WORK->RECZB1
				ZB2->(dbSetOrder(1))
				ZB2->(dbGoTo(WORK->RECZB2))
				cChavSC7 := xFilial("SC7")+ZB1->(ZB1_FORNECE+ZB1_LOJA)+ZB2->ZB2_PEDCOM
				_cProvis := WORK->ZB1_PROVIS
				
				dbSelectArea("SA2")
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+ZB1->(ZB1_FORNEC+ZB1_LOJA)))
				
				While WORK->(!Eof()).And.WORK->ZB1_PROVIS=_cProvis
					dbSelectArea("ZB2")
					ZB2->(dbGoTo(WORK->RECZB2))
					nTotal := 0
					nTotal += DetProva(nHdlPrv,cPadrao,cRotina,cLote)
					nValor += nTotal
					RecLock("ZB2",.F.)
					ZB2->ZB2_CONFER	:= ""	
					//ZB2->ZB2_SALDO	+= nTotal
					//ZB2->ZB2_SLDEST	-= Iif(ZB2->ZB2_SLDEST>0 .And. ZB2->ZB2_SLDEST>=nTotal, nTotal, 0)
					ZB2->(MsUnlock())
					WORK->(dbSkip())
				End
				
				nTotal += DetProva(nHdlPrv,"215",cRotina,cLote)
				
				ZB1->(dbGoTo(nZB1Rec))
				RecLock("ZB1",.F.)
				ZB1->ZB1_CONFER	:= ""
				ZB1->ZB1_DTLCTO := _cData
				//ZB1->ZB1_SALDO	+= nTotal
				//ZB1->ZB1_SLDEST	-= Iif(ZB1->ZB1_SLDEST>0 .And. ZB1->ZB1_SLDEST>=nTotal, nTotal, 0)
				MsUnLock()
				

				dbSelectArea("SC7")
				SC7->(dbSetOrder(1))
				If SC7->(dbSeek(cChavSC7))
					While SC7->(!Eof()).And.SC7->(C7_FILIAL+C7_FORNECE+C7_LOJA+C7_NUM)==cChavSC7
						RecLock("SC7",.F.)
						SC7->C7_X_PROV := 'S'
						MsUnLock()
						SC7->(dbSkip())
					End
				EndIf
				
			Else
				WORK->(dbSkip())
			EndIf
		End
		
		nValor := nTotal
		RodaProva(nHdlPrv,nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLote,Iif(mv_par08==1,.T.,.F.),.F.,,_cData)
		lCtbOk := .T.
		
	Else
		
		lCtbOk := .F.
		
	EndIf
	
	WORK->(dbCloseArea())
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ProvEstor ºAutor  ³Daniel G.Jr.TI1239  º Data ³  10/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³Processamento das Provisoes Contabeis                       º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³CSU                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function ProvEstD()
	
	Local _cQuery
	Local nHdlPrv
	Local cArquivo	:= ""
	Local cPadrao	:= "220"
	Local lPadrao220:= .F.
	Local lPadrao225:= .F.
	//Local nValor 	:= 0
	Local nTotal	:= 0
	Local nZB1Rec	:= 0
	Local nTotSld   := 0
	Local cChavSC7	:= ""
	Local _cData	:= mv_par07
	Private cLote	:= ""
	Private cLote	:= LoteCont('COM')
	Private cAliasZB1:="WORK"
	Private aStruZB1:= ZB1->(dbStruct())
	Private cRotina := "CSUCTB12"
	
	lPadrao220 := VerPadrao(cPadrao)
	lPadrao225 := VerPadrao("225")
	
	If !lPadrao220 .Or. !lPadrao225
		cMsg:="Lançamento Padrão 220 e/ou 225 não está(ão) configurado(s)!"+cEnter+"Falar com a Contabilidade!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		lCtbOk := .F.
		Return()
	EndIf
	
	_cQuery:= "SELECT ZB1.*, ZB1.R_E_C_N_O_  RECZB1, ZB2.R_E_C_N_O_ RECZB2 "+_cEnter
	_cQuery+=   "FROM "
	_cQuery+=   RetSqlName('ZB1')+" ZB1, "+_cEnter
	_cQuery+=   RetSqlName('ZB2')+" ZB2  "+_cEnter
	_cQuery+= "WHERE "
	_cQuery+= 	    "ZB1_FILIAL = '"+xFilial("ZB1")+"' AND ZB1.D_E_L_E_T_ = ' ' "
	_cQuery+=   "AND ZB2_FILIAL = '"+xFilial("ZB2")+"' AND ZB2.D_E_L_E_T_ = ' ' "
	_cQuery+=   "AND ZB1_PROVIS BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+_cEnter
	_cQuery+=   "AND ZB1_DTDIGI BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "+_cEnter
	_cQuery+=   "AND ZB1_FORNEC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "+_cEnter
	//_cQuery+=   "AND ZB1_DTLCTO <>' ' "+_cEnter
	_cQuery+=   "AND ZB1_SLDEST < ZB1_VALDOC "+_cEnter
	_cQuery+=   "AND ZB2_PROVIS = ZB1_PROVIS "+_cEnter
	_cQuery+= "ORDER BY ZB1_PROVIS, ZB1_FORNEC "
	_cQuery:= ChangeQuery( _cQuery )
	
	MemoWrite("C:\ESTORNA.sql",_cQuery)
	
	If Select (cAliasZB1) > 0
		WORK->(dbCloseArea())
	EndIf
	
	TcQuery _cQuery New Alias "WORK"
	
	Work->( DbGoTop() )
	
	If Select ("WORK") == 0
		ApMSgStop('Não Existem Registros para Serem Processados Nesta Empresa!','Aviso')
		WORK->(dbCloseArea())
		lCtbOk := .F.
		Return
	EndIf
	
	For nX := 1 To Len(aStruZB1)
		If aStruZB1[nX,2]<>"C"
			TcSetField(cAliasZB1,aStruZB1[nX,1],aStruZB1[nX,2],aStruZB1[nX,3],aStruZB1[nX,4])
		EndIf
	Next nX
	
	If "CSUCTB12" $ FunName()
		aF4For := ExibeProvis(2)
	Else
		aF4For := { { , Work->ZB1_PROVIS } }
	EndIf
	
	aProvis:={}
	
	For nI:=1 to Len(aF4For)
		If "CSUCTB12" $ FunName()
			If aF4For[nI][1]
				aAdd(aProvis, aF4For[nI][2])
			EndIf
		Else
			aAdd(aProvis, aF4For[nI][2])
		EndIf
	Next nI
	
	If Len(aProvis)>0
		
		dbSelectArea("WORK")
		WORK->(dbGoTop())
		
		cLote    := "090020"		// LoteCont('COM')
		nHdlPrv  := HeadProva(cLote,cRotina,Substr(cUsuario,7,6),@cArquivo)
		
		While WORK->(!Eof())
			
			If aScan(aProvis,WORK->ZB1_PROVIS)>0
				
				dbSelectArea("ZB1")
				ZB1->(dbGoTo(WORK->RECZB1))
				nZB1Rec  := WORK->RECZB1
				ZB2->(dbGoTo(WORK->RECZB2))
				cChavSC7 := xFilial("SC7")+ZB1->(ZB1_FORNECE+ZB1_LOJA)+ZB2->ZB2_PEDCOM
				_cProvis := WORK->ZB1_PROVIS
				
				dbSelectArea("SA2")
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+ZB1->(ZB1_FORNEC+ZB1_LOJA)))
				
				nTotSld := 0
				While WORK->(!Eof()).And.WORK->ZB1_PROVIS=_cProvis
					dbSelectArea("ZB2")
					ZB2->(dbGoTo(WORK->RECZB2))
					nTotal := 0
					nTotal += DetProva(nHdlPrv,cPadrao,cRotina,cLote)
					RecLock("ZB2",.F.)
					ZB2->ZB2_SALDO	-= nTotal
					ZB2->ZB2_SLDEST	+= nTotal
					ZB2->ZB2_VLESTO := nTotal
					If ZB2->ZB2_SALDO >= 1.00  // Alterado operador de '<' para '>=' OS 3770/15
						ZB2->ZB2_SALDO:=0
						ZB2->ZB2_SLDEST:=ZB2->ZB2_VALOR
					EndIf
					ZB2->(MsUnlock())
					nTotSld += nTotal
					WORK->(dbSkip())
				EndDo
				
				ZB1->(dbGoTo(nZB1Rec))
				RecLock("ZB1",.F.)
				ZB1->ZB1_DTESTO := _cData
				ZB1->ZB1_SALDO	-= nTotSld
				ZB1->ZB1_SLDEST	+= nTotSld
				ZB1->ZB1_VLESTO := nTotSld
				If ZB1->ZB1_SALDO >= 1.00
					ZB1->ZB1_SALDO:=0
					ZB1->ZB1_SLDEST:=ZB1->ZB1_VALDOC
				EndIf
				MsUnLock()
				
				nTotal += DetProva(nHdlPrv,"225",cRotina,cLote)
				
				dbSelectArea("SC7")
				SC7->(dbSetOrder(1))
				If SC7->(dbSeek(cChavSC7))
					While SC7->(!Eof()).And.SC7->(C7_FILIAL+C7_FORNECE+C7_LOJA+C7_NUM)==cChavSC7
						RecLock("SC7",.F.)
						SC7->C7_X_PROV := ' '
						MsUnLock()
						SC7->(dbSkip())
					End
				EndIf
				
			Else
				WORK->(dbSkip())
			EndIf
		End
		
		nValor := nTotal
		RodaProva(nHdlPrv,nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLote,Iif(mv_par08==1,.T.,.F.),.F.,,_cData)
		lCtbOk := .T.
		
	Else
		
		lCtbOk := .F.
		
	EndIf
	
	WORK->(dbCloseArea())
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜßÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ ExibeProvis  º Autor ³ Daniel G.Jr.TI1239 º Data ³  04/07/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Exibe provisoes a ser contabilizadas / estornadas              º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Csu CardSystem                                                 º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function ExibeProvis(nCtEs)
	
	Local nOpc       := 0
	Local nx         := 0
	Local cQuery     := ""
	Local cAliasZB1  := "WORK"
	Local lQuery     := .F.
	Local cDTipo      := Iif(nCtEs==1,"Contabilizar","Estornar")
	Local bSavSetKey := SetKey(VK_F4,Nil)
	Local bSavKeyF5  := SetKey(VK_F5,{||TrazPC()})
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
	Local aAreaZB1   := ZB1->(GetArea())
	Local aStruZB1   := ZB1->(dbStruct())
	Local aF4For     := {}
	Local nF4For     := 0
	Local oOk        := LoadBitMap(GetResources(), "LBOK")
	Local oNo        := LoadBitMap(GetResources(), "LBNO")
	Local oDlg,oListBox
	Local aRecZB1    := {}
	Local aTitCampos := {}
	Local aConteudos := {}
	Local aUsCont    := {}
	Local aUsTitu    := {}
	Local bLine      := { || .T. }
	Local cLine      := ""
	Local nLoop      := 0
	Local lContinua  := .T.
	Local aButtons   := {}
	Local _lFaz		 := .F.
	
	dbSelectArea("ZB1")
	ZB1->( dbSetOrder( 1 ) )
	
	(cAliasZB1)->(dbGoTop())
	bWhile := {|| (cAliasZB1)->(!Eof())}
	
	While Eval(bWhile)
		
		_lFaz := ( ( nCtEs==1.And.Empty( (cAliasZB1)->ZB1_DTLCTO ) .Or. ( nCtEs==2.And.(cAliasZB1)->ZB1_SLDEST < (cAliasZB1)->ZB1_VALDOC ) ) )
		nF4For := aScan(aF4For,{|x| x[2]==(cAliasZB1)->ZB1_PROVIS})
		If ( nF4For == 0 ) .And. _lFaz
			
			aConteudos := {.F., (cAliasZB1)->ZB1_PROVIS, DTOC((cAliasZB1)->ZB1_DTDIGI), Transform((cAliasZB1)->ZB1_SALDO, "@E 99999,999,999.99") , (cAliasZB1)->ZB1_USUARI }
			
			aadd(aF4For, aConteudos )
			aAdd(aRecZB1,Iif(lQuery,(cAliasZB1)->RECZB1,RecNo()))
		EndIf
		(cAliasZB1)->(dbSkip())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe os dados na Tela                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( !Empty(aF4For) )
		
		aTitCampos := {" ","Provisão","Dt.Digita.","Valor","Usuário" }
		
		cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5]"
		
		cLine += " } "
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta dinamicamente o bline do CodeBlock                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		bLine := &( "{ || " + cLine + " }" )
		
		
		DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi("Selecionar Provisões para "+cDTipo) Of oMainWnd PIXEL
		
		oListBox := TWBrowse():New( 27,4,243,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aF4For)
		oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
		oListBox:bLine := bLine
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)
		
		If nOpc==0
			aF4For:={}
		EndIf
		
	Else
		Help(" ",1,"A103F4")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a Integrida dos dados de Entrada                ³
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
	RestArea(aAreaZB1)
	RestArea(aArea)
	
	Return(aF4For)
	
	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ProvImpri ³ Autor ³Daniel G.Jr.TI1239    ³ Data ³28/06/07  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Efetua a chamada do relatorio padrao ou do usuario         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ ExpX1 := A103Impri( ExpC1, ExpN1, ExpN2 )                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 -> Alias do arquivo                                  ³±±
	±±³          ³ ExpN1 -> Recno do registro                                 ³±±
	±±³          ³ ExpN2 -> Opcao do Menu                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ ExpX1 -> Retorno do relatorio                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CSUCTB12                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	User Function ProvImpri( cAlias, nRecno, nOpc )
	
	Private cPerg := "CSC12B"
	private nomeprog  := "CSUCTB12"
	private lweb      := IsBlind()
	private lPrimVez  := .t.
	Private oPrn
	
	//Fontes Arial
	Private oFont1 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
	Private oFont3 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
	
	//Fontes Courier New (para campos numericos)
	Private oFont1c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
	Private oFont9c := TFont():New( "Courier New",,8,,.f.,,,,,.f. )
	
	ValidPer2(cPerg)
	Pergunte(cPerg,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Variaveis utilizadas para parametros
	//³ mv_par01	Provisao de      ?
	//³ mv_par02	Provisao ate     ?
	//³ mv_par03	Dt.Digitacao de  ?
	//³ mv_par04	Dt.Digitacao ate ?
	//³ mv_par05	Fornecedor de    ?
	//³ mv_par06	Fornecedor ate   ?
	//³ mv_par07	Dt.Contabilizacao de?
	//³ mv_par08	Dt.Contabilizacao ate?
	//³ mv_par09	Imprime saldo zerado? sim/nao
	//| mv_par10    Data de Referência
	//| mv_par11    Imprime Ocorrências?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	@ 200,1 TO 380,380 DIALOG o_dlg TITLE OemToAnsi("Relaçao de Provisões Contábeis")
	@ 02,10 TO 080,180
	@ 10,018 Say OemToAnsi("Esta rotina imprime a Relaçao de Provisões Contábeis")
	@ 18,018 Say OemToAnsi("")
	@ 26,018 Say OemToAnsi("")
	@ 34,018 Say OemToAnsi("")
	@ 65,038 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 65,068 BMPBUTTON TYPE 01 ACTION OkProc()
	@ 65,098 BMPBUTTON TYPE 02 ACTION Close(o_dlg)
	@ 65,128 BMPBUTTON TYPE 07 ACTION oPrn:=Setup()
	Activate Dialog o_dlg Centered
	
	if Select( "TRB" ) > 0
		dbSelectArea( "TRB" )
		dbCloseArea()
	endif
	
	MS_FLUSH()
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ OkProc   ºAutor  ³Microsiga           º Data ³  07/03/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function OkProc()
	
	Local aStruZB1 := ZB1->(dbStruct())
	Local aStruZB2 := ZB2->(dbStruct())
	Private bProcessa, cTitulo, cMsg, lAborta
	
	Close(o_dlg)
	
	cQuery := "SELECT ZB1.* "
	cQuery += "  FROM "+RetSQLName("ZB1")+" ZB1 "
	cQuery += " WHERE ZB1.D_E_L_E_T_<>'*' "
	cQuery += "   AND ZB1_PROVIS BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "   AND ZB1_DTDIGI BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "
	cQuery += "   AND ZB1_FORNEC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += "   AND ZB1_DTLCTO BETWEEN '"+DtoS(mv_par07)+"' AND '"+DtoS(mv_par08)+"' "
	If mv_par09=2	// saldo zerado nao
		If Empty(mv_par10)
			cQuery += " AND ZB1_SALDO > 0 "
		Else
			cQuery += " AND ZB1_DTLCTO<='"+DtoS(mv_par10)+"' AND ( ZB1_SALDO > 0 OR ( ZB1_SALDO=0 AND ZB1_DTESTO>'"+DtoS(mv_par10)+"' ) ) "
		EndIf
	EndIf
	cQuery += "ORDER BY ZB1_PROVIS, ZB1_DTDIGI, ZB1_FORNEC "
	
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("C:\CSUIMPRO.sql",cQuery)
	
	If Select("TRB")>0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)
	
	For nX := 1 To Len(aStruZB1)
		If aStruZB1[nX,2]<>"C"
			TcSetField("TRB",aStruZB1[nX,1],aStruZB1[nX,2],aStruZB1[nX,3],aStruZB1[nX,4])
		EndIf
	Next nX
	
	bProcessa := { |lFim| ImpRelato(@lFim) }
	cTitulo   := "Impressão do Relatório"
	cMsg      := "Imprimindo... Aguarde..."
	lAborta   := .T.
	Processa( bProcessa, cTitulo, cMsg, lAborta )
	
	Return
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³NOVO6     º Autor ³ AP6 IDE            º Data ³  26/06/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP6 IDE                                                    º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function ImpRelato(lFim)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2    	:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3    	:= "Relação de Provisões Contábeis"
	Local cPict     	:= ""
	Local titulo    	:= "Relação de Provisões Contábeis"
	Local nLin      	:= 80
	Local Cabec1    	:= ""
	Local Cabec2    	:= ""
	Local imprime   	:= .T.
	Local aOrd := {}
	
	Private lEnd    	:= .F.
	Private lAbortPrint := .F.
	Private CbTxt   	:= ""
	Private limite     	:= 132
	Private tamanho     := "G"
	Private nomeprog    := "CSUCTB12" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   	:= 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "CSUPROVI" // Coloque aqui o nome do arquivo usado para impressao em disco
	
	Private cString := "ZB1"
	
	If mv_par11!=1		// Se não imprime ocorrências
		Cabec1    	:= "                                                   --------- DOCUMENTO ----------                                                                  PC                                                                      "
		//         	   "XXXXXX    XXXXXX/XX-123456789,123456789,123456789  XXXXXX  DD/MM/AAAA  DD/MM/AAAA 123456789,123456789,123456789,12345 123456789,12345 DD/MM/AAAA    S   DD/MM/AAAA  99,999,999.99  99,999,999.99   DD/MM/AAAA  99,999,999.99
		Cabec2    	:= "PROVISÃO  COD.FORNEC-NOME DO FORNECEDOR            NUMERO  EMISSÃO     VENCIMENTO HISTÓRICO                           USUÁRIO         DT.PROVISAO  EXC  DT.CONTAB        PROVISÃO        ESTORNO   DT.ESTORNO         SALDO"
		//Cabec2   	:= "0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.1234
		//Cabec2   	:= "          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	Else
		//         	   " XXXXXX   XXXXXX/XX-123456789,123456789,123456789 XXXXXX  DD/MM/AAAA  DD/MM/AAAA 123456789,123456789,123456789,12345 123456789,12345 DD/MM/AAAA    S   DD/MM/AAAA  99,999,999.99  99,999,999.99   DD/MM/AAAA  99,999,999.99
		Cabec1    	:= "PROVISÃO  COD.FORNEC-NOME DO FORNECEDOR            NUMERO  EMISSÃO     VENCIMENTO HISTÓRICO                           USUÁRIO         DT.PROVISAO  PC   DT.CONTAB        PROVISÃO        ESTORNO   DT.ESTORNO         SALDO"
		//Cabec1   	:= "0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.1234
		//Cabec1   	:= "          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
		Cabec2    	:= "           SEQ  DATA        TIPO        ORIGEM                 HISTORICO                                         VALOR                             EXC                                                                     "
		//             "           XXX  DD/MM/AAAA  XXXXXXXXXX  123456789,123456789,  123456789,123456789,123456789,123456789,  99,999,999.99
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
	Return
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/06/07   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
	±±º          ³ monta a janela com a regua de processamento.               º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	
	Local nOrdem
	Local cProvis
	Local dDtProv
	Local nValor
	Local nVlesto
	Local nSaldo
	Local nLin:=66
	Local aTipo := { "PROVISÃO","ESTORNO","INCLUSÃO","ALTERAÇÃO","EXCLUSÃO" }
	
	dbSelectArea(cString)
	dbSetOrder(1)
	
	dbSelectArea("TRB")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())
	
	TRB->(dbGoTop())
	If TRB->(Eof().And.Bof())
		cMsg:="Não há dados para este relatório!"
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		Return()
	EndIf
	
	cChave:=""
	aTot:={0,0,0}
	While TRB->(!EOF())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 56 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,000 PSAY TRB->ZB1_PROVIS
		@nLin,010 PSAY TRB->ZB1_FORNEC+"/"+ZB1_LOJA+"-"+Left(Posicione("SA2",1,xFilial("SA2")+TRB->(ZB1_FORNEC+ZB1_LOJA),"A2_NOME"),30)
		@nLin,051 PSAY TRB->ZB1_DOC
		@nLin,059 PSAY TRB->ZB1_EMIDOC	PICTURE "@D"
		@nLin,071 PSAY TRB->ZB1_VENCTO	PICTURE "@D"
		@nLin,082 PSAY Left(TRB->ZB1_HISTOR,35)	PICTURE "@!"
		@nLin,118 PSAY TRB->ZB1_USUARI	PICTURE "@!"
		@nLin,134 PSAY TRB->ZB1_DTDIGI	PICTURE "@D"
		@nLin,148 PSAY TRB->ZB1_PCEXC	PICTURE "@!"
		@nLin,152 PSAY TRB->ZB1_DTLCTO	PICTURE "@D"
		@nLin,164 PSAY TRB->ZB1_VALDOC 	PICTURE "@E 99,999,999.99"
		@nLin,179 PSAY TRB->ZB1_SLDEST 	PICTURE "@E 99,999,999.99"
		@nLin,195 PSAY TRB->ZB1_DTESTO 	PICTURE "@D"
		_nSaldo := 0
		If mv_par09=2	// saldo zerado nao
			If Empty(mv_par10)
				_nSaldo := TRB->ZB1_SALDO
			Else
				_nSaldo := Iif(Empty(TRB->ZB1_DTESTO), TRB->ZB1_SALDO, TRB->(ZB1_SALDO+ZB1_SLDEST))
			EndIf
		EndIf
		
		@nLin,206 PSAY _nSaldo 	PICTURE "@E 99,999,999.99"
		
		If mv_par11==1
			
			// Impressão de ocorrências da Provisão
			
			dbSelectArea("ZB3")
			dbSetOrder(1)
			If ZB3->(dbSeek(xFilial("ZB3")+TRB->ZB1_PROVIS))
				
				While ZB3->(!Eof().And.ZB3->ZB3_PROVIS=TRB->ZB1_PROVIS)
					
					nLin++
					
					If nLin > 56 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
					
					@nLin,012 PSAY ZB3->ZB3_SEQUEN  PICTURE "@!"
					@nLin,017 PSAY ZB3->ZB3_DATA	PICTURE "@D"
					@nLin,029 PSAY aTipo[Val(ZB3->ZB3_TIPO)] PICTURE "@!"
					@nLin,041 PSAY ZB3->ZB3_ORIGEM	PICTURE "@!"
					@nLin,063 PSAY ZB3->ZB3_HISTOR  PICTURE "@!"
					@nLin,105 PSAY ZB3->ZB3_VALOR 	PICTURE "@E 99,999,999.99"
					
					ZB3->(dbSkip())
					
				End
			EndIf
		EndIf
		
		aTot[1]+=TRB->ZB1_VALDOC
		aTot[2]+=TRB->ZB1_SLDEST
		aTot[3]+=_nSaldo
		
		nLin++
		
		TRB->(dbSkip())
	End
	
	If aTot[1]>0
		nLin+=3
		If nLin>53
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 12
		EndIf
		@nLin,163 PSAY "--------------"
		@nLin,178 PSAY "--------------"
		@nLin,205 PSAY "--------------"
		nLin++
		@nLin,001 PSAY "TOTAL GERAL"
		@nLin,163 PSAY aTot[1] PICTURE "@E 999,999,999.99"
		@nLin,178 PSAY aTot[2] PICTURE "@E 999,999,999.99"
		@nLin,205 PSAY aTot[3] PICTURE "@E 999,999,999.99"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
	Return
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  16/08/01   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
	±±º          ³ necessario (caso nao existam).                             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function ValidPerg(cPerg)
	
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))
	
	aAdd(aRegs,{cPerg,"01","Provisao de      ?"		,""	,"" ,"mv_ch1","C",9,0,0,"G",""	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","ZB1","",""})
	aAdd(aRegs,{cPerg,"02","Provisao até     ?"		,""	,"" ,"mv_ch2","C",9,0,0,"G",""	,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","ZB1","",""})
	aAdd(aRegs,{cPerg,"03","Dt.Digitação de  ?"		,"" ,"" ,"mv_ch3","D",8,0,0,"G",""	,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Dt.Digitação até ?"		,"" ,"" ,"mv_ch4","D",8,0,0,"G",""	,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Fornecedor de    ?"		,"" ,"" ,"mv_ch5","C",6,0,0,"G",""	,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
	aAdd(aRegs,{cPerg,"06","Fornecedor até   ?"		,"" ,"" ,"mv_ch6","C",6,0,0,"G",""	,"MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
	aAdd(aRegs,{cPerg,"07","Data Contabilização?"	,""	,"" ,"mv_ch7","D",8,0,0,"G",""	,"MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08",'Exibe Contabilização?'	,''	,''	,'mv_ch8','C',1,0,2,'C',''	,'mv_par08','Sim','','','','','Não','','','','','','','','','','','','','','','','','','','','','','',''})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	dbSelectArea(_sAlias)
	
	Return
	
	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³FazRateio ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ 17/11/08 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Escolhe o rateio pre-configurado 					 		  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe	 ³FazRateio( ExpC1,ExpC2,ExpC3 ) 							  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ FINA050,FINA100											  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function FazRateio()
	
	Local oDlg11
	Local cCodRateio	:= CriaVar("CTJ_RATEIO")
	Local nOpca 		:= 0
	Local cHistorico 	:= CriaVar("CT2_HIST")
	Local cSeq			:= ""
	Local nIncAlt		:= 3
	
	Private cDebito	 	:= CriaVar("CT2_DEBITO")
	Private cCredito 	:= CriaVar("CT2_CREDIT")
	
	If !CtbInUse()
		Return
	Endif
	
	aCols := oGetDados:aCols
	cMsg:=""
	If Len(aCols)>1
		cMsg:="O rateio externo só pode ser efetuado para Pedido de Compras único!"+Chr(10)
	EndIf
	If Empty(aCols[1][nPosNPCEZ])
		cMsg:="Indique o nr. do Pedido de Compras antes de solicitar o rateio externo!"+Chr(10)
	EndIf
	If Empty(aCols[1][nPosNatEZ])
		cMsg:="Indique o código da Natureza antes de solicitar o rateio externo!"+Chr(10)
	EndIf
	
	If !Empty(cMsg)
		Aviso("Verifique as inconsistências",cMsg,{"Fechar"},3)
		Return
	EndIf
	
	DEFINE MSDIALOG oDlg11 FROM  120,1 TO 250,310 TITLE OemToAnsi("Rateio Externo") PIXEL
	
	@ 20,10 Say 	OemToAnsi("Código Rateio:") PIXEL
	@ 20,50 MSGET 	oRateio Var cCodRateio F3 "CTJ" Picture "@!";
	SIZE 070,10 OF oDLG11 PIXEL
	
	DEFINE SBUTTON oBtn FROM 050,120 TYPE 1 ENABLE OF oDlg11 ACTION  (Close(oDlg11),TrazCTJ(cCodRateio))
	
	ACTIVATE MSDIALOG oDlg11 CENTERED
	
	Return
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³TrazCTJ   ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ 21/11/08 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Carrega dados do rateio externo                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ Nenhum                                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpN1 = Opcao do Menu                                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function TrazCTJ(cCodRateio)		//nTipo,cCodRateio,cProg,cPadrao,cDebito,cCredito,cHistorico)
	
	Local aSaveArea	:= GetArea()
	Local lCusto	:= CtbMovSaldo("CTT")
	Local lItem	 	:= CtbMovSaldo("CTD")
	Local lCLVL	 	:= CtbMovSaldo("CTH")
	Local nValor	:= 0
	Local nValRat	:= 0
	Local cNumPC	:= ""
	Local cContrato	:= ""
	Local cNatureza := ""
	Local aCabPC	:= {}
	
	cNumPc := aCols[1][nPosNPCEZ]
	nValor := aCols[1][nPosValEZ]
	cContrato:=aCols[1][nPosContr]
	cNatureza:=aCols[1][nPosNatEZ]
	nValRat		:= 0
	
	dbSelectArea("CTJ")			// Vale somente para digitacao
	dbSetOrder(1)
	dbSeek(xFilial("CTJ")+cCodRateio)
	While CTJ->(!Eof()) .And. CTJ->CTJ_FILIAL == xFilial() .And. CTJ->CTJ_RATEIO == cCodRateio
		aAdd( aCabPC, { cNumPc, CTJ->CTJ_CCD, CTJ->CTJ_ITEMD, CTJ->CTJ_CLVLDB, Round(nValor*CTJ->CTJ_PERCEN*0.01,2), cContrato, cNatureza, CTJ->CTJ_PERCEN } )
		nValRat += aCabPC[Len(aCabPC)][5]
		CTJ->(dbSkip())
	EndDo
	
	RestArea(aSaveArea)
	
	MontAcols(,,aCabPC)
	
	If !Empty(aCols[1][1])
		oGetDados:aCols := aCols
		oGetDados:ForceRefresh()
	EndIf
	
	Return
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³VALIDPER2 º Autor ³ AP5 IDE            º Data ³  16/08/01   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
	±±º          ³ necessario (caso nao existam).                             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function ValidPer2(cPerg)
	
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))
	
	aAdd(aRegs,{cPerg,"01","Provisao de      ?"		,""	,"" ,"mv_ch1","C",9,0,0,"G",""	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","ZB1","",""})
	aAdd(aRegs,{cPerg,"02","Provisao até     ?"		,""	,"" ,"mv_ch2","C",9,0,0,"G",""	,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","ZB1","",""})
	aAdd(aRegs,{cPerg,"03","Dt.Digitação de  ?"		,"" ,"" ,"mv_ch3","D",8,0,0,"G",""	,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Dt.Digitação até ?"		,"" ,"" ,"mv_ch4","D",8,0,0,"G",""	,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Fornecedor de    ?"		,"" ,"" ,"mv_ch5","C",6,0,0,"G",""	,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
	aAdd(aRegs,{cPerg,"06","Fornecedor até   ?"		,"" ,"" ,"mv_ch6","C",6,0,0,"G",""	,"MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
	aAdd(aRegs,{cPerg,"07","Dt.Contabilização de?"	,""	,"" ,"mv_ch7","D",8,0,0,"G",""	,"MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","Dt.Contabilização até?"	,""	,"" ,"mv_ch8","D",8,0,0,"G",""	,"MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09","Imprime Saldo Zerado?"	,""	,"" ,"mv_ch9","N",1,0,2,"C",""	,"MV_PAR09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","Data de Referência:"	,""	,"" ,"mv_cha","D",8,0,0,"G",""	,"MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11",'Imprime Ocorrências?'	,''	,''	,'mv_chb','C',1,0,2,'C',''	,'mv_par11','Sim','','','','','Não','','','','','','','','','','','','','','','','','','','','','','',''})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	dbSelectArea(_sAlias)
	
	Return
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³GrvOcorPrvº Autor ³ Daniel G.Jr.TI123  º Data ³  06/01/09   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Grava o histórico de ocorrências das Provisões Contábeis   º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ CSU                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	User Function GrvOcorPrv(cProvis,cTipo,dData,nValor,cOrigem,cHistor,cNomUsu)
	
	Local aArea	  := GetArea()
	Local cSequen := ""
	
	// IDENTIFICA O ÚLTIMO NÚMERO SEQUENCIAL PARA ESTA PROVISAO
	cQuery := " SELECT MAX(ZB3_SEQUEN) SEQUEN "+_cEnter
	cQuery += " FROM "+RetSqlName("ZB3") + " ZB3 "+_cEnter
	cQuery += " WHERE ZB3.ZB3_FILIAL = '"+xFilial("ZB3")+"' "+_cEnter
	cQuery += "  AND ZB3.ZB3_PROVIS  = '"+cProvis+"' "+_cEnter
	cQuery += "  AND ZB3.D_E_L_E_T_  = ' ' "+_cEnter
	
	cQuery := ChangeQuery(cQuery)
	
	U_MontaView( cQuery, "TIMP" )
	
	TIMP->( DbGoTop() )
	
	If TIMP->( Eof() )
		cSequen := "001"
	Else
		cSequen := Soma1(TIMP->SEQUEN)
	EndIf
	
	ZB3->( RecLock("ZB3",.t.) )
	ZB3->ZB3_FILIAL	:= xFilial("ZB3")
	ZB3->ZB3_PROVIS	:= cProvis
	ZB3->ZB3_TIPO	:= cTipo
	ZB3->ZB3_DATA	:= DDATABASE
	ZB3->ZB3_VALOR	:= nValor
	ZB3->ZB3_ORIGEM	:= cOrigem
	ZB3->ZB3_HISTOR	:= cHistor // C - 40
	ZB3->ZB3_USUARI := cNomUsu
	ZB3->ZB3_SEQUEN := cSequen
	ZB3->(MsUnLock())
	
	RestArea(aArea)
	
	Return(.t.)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³CarrTabRatºAutor  ³V. Gregório         º Data ³  18/01/11   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Carrega as informações de uma tabela de rateios para o     º±±
	±±º          ³ aCols                                                      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ CSU                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function CarrTabRat()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração de variáveis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea		:= GetArea()
	Local lRetorno	:= .T.
	Local aRegs		:= {}
	Local cPerg		:= PADR("CTB12TR",Len(SX1->X1_GRUPO))
	Local cAnoMes	:= ""
	Local cUltRev	:= ""
	Local nLoop		:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VG - 2011.03.11                                  ³
	//³Natureza e Ped. Compra da primeira linha do aCols³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cNaturez	:= ""
	Local cPedCom	:= ""
	Local cNatDes	:= ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montar o pergunte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aRegs,{cPerg,"01","Tabela de Rateio"		,"","","mv_ch1","C",06,0,0,"G","ExistCpo('ZB7')"	,"MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","ZBA"	,"","","","" })
	aAdd(aRegs,{cPerg,"02","Mês/Ano da Tabela"		,"","","mv_ch2","D",08,0,0,"G",""					,"MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
	
	CriaSx1(aRegs)
	
	If !Pergunte(cPerg,.T.)
		Return .F.
	Endif
	
	dbSelectArea("ZBA")
	dbSetOrder(1)
	If !dbSeek(xFilial("ZBA")+MV_PAR01+__cUserID,.F.)
		Aviso("Aviso","A tabela de rateio não existe ou o usuário logado não tem permissão de utilizá-la.",{"OK"},,"Atenção",,"BMPPERG")
		Return .F.
	Endif
	
	cAnoMes	:= Substr(DTOS(MV_PAR02),1,6)
	cUltRev	:= U_RZB7ULTR(MV_PAR01,cAnoMes,.T.)
	
	dbSelectArea("ZB8")
	dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
	If !dbSeek(xFilial("ZB8")+MV_PAR01+cAnoMes+cUltRev,.F.)
		Aviso("Aviso","A tabela de rateio não tem vigencia para a data informada ou não tem itens preenchidos.",{"OK"},,"Atenção",,"BMPPERG")
		Return .F.
	Endif
	
	If Aviso("Aviso","A rotina irá recarregar a tabela com as informações de rateio da tabela selecionada.",;
		{"OK","Cancelar"},,"Atenção",,"BMPPERG")==2
		Return .F.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Limpa o aCols³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols 		:= oGetDados:aCols
	
	cNaturez	:= aCols[1,BuscaHeader(aHeader,"ZB2_NATURE")]
	cPedCom		:= aCols[1,BuscaHeader(aHeader,"ZB2_PEDCOM")]
	cNatDes		:= Posicione("SED",1,xFilial("SED")+cNaturez,"ED_DESCRIC")
	
	aCols := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera o aCols com os itens da tabela de rateio.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do While !EOF() .and. ZB8->(ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA)==xFilial("ZB8")+MV_PAR01+cAnoMes+cUltRev
		
		AdicCols()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.03.11                 ³
		//³Replica o primeiro item do aCols³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_PEDCOM")]	:= 	cPedCom
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_NATURE")]	:= 	cNaturez
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.03.18                        ³
		//³Incluir a descrição do centro de custo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_NATDES")]	:=	cNatDes
		
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_PERCEN")]	:= 	ZB8->ZB8_PERCEN
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_CCUSTO")]	:=	ZB8->ZB8_CCDBTO
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_ITEMCT")]	:=	ZB8->ZB8_ITDBTO
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_CLVL")]		:=	ZB8->ZB8_CLVLDB
		
		aCols[Len(aCols),BuscaHeader(aHeader,"ZB2_VALOR")]		:=	Round((M->ZB1_VALDOC*ZB8->ZB8_PERCEN)/100,2)
		
		dbSelectArea("ZB8")
		dbSkip()
	EndDo
	
	oGetDados:aCols	:= aCols
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³         Chama a Funcao que Atualiza o Campo do Valor Distribuido           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	RecValZB2()
	
	RestArea(aArea)
	Return lRetorno
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
	±±º             ³          ³ parâmetros fornecidos                                        º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±º Solicitante ³ 23.05.05 ³ Modelagem de Dados                                           º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±º Autor       ³ 28.04.04 ³ TI0607 - Almir Bandina                                       º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±º Parâmetros  ³ ExpA1 = array com o conteúdo do grupo de perguntas (SX1)                º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±º Retorno     ³ Nil                                                                     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±º Observações ³                                                                         º±±
	±±º             ³                                                                         º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
	±±º             ³                                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function CriaSx1(aRegs)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração de variáveis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aAreaAtu	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local nJ		:= 0
	Local nY		:= 0
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	For nY := 1 To Len(aRegs)
		If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
			RecLock("SX1",.T.)
			For nJ := 1 To FCount()
				If nJ <= Len(aRegs[nY])
					FieldPut(nJ,aRegs[nY,nJ])
				EndIf
			Next nJ
			MsUnlock()
		EndIf
	Next nY
	
	RestArea(aAreaSX1)
	RestArea(aAreaAtu)
	
	Return(Nil)
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³BuscaHeader³ Autor ³Jaime Wikanski        ³ Data ³            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Pesquisa a posicao do campo no aheader                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³                                                              ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function BuscaHeader(aArrayHeader,cCampo)
	
	Return(AScan(aArrayHeader,{|aDados| AllTrim(Upper(aDados[2])) == Alltrim(Upper(cCampo))}))
                                                                                                  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LimpaCam ³ Autor ³    Eduardo Dias       ³ Data ³ 22/11/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validação para limpar os campos referente a Provisao 	  ³±± 
±±³Descri‡…o ³ Requisito da OS 2965/16 									  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/      
User Function DesflegP

Local _cSenha := "" //ProvBlqSenha()      

If !Empty(ZB1->ZB1_DTLCTO) .Or. !Empty(ZB1->ZB1_DTESTO) .Or. !Empty(ZB1->ZB1_SLDEST) .Or. !Empty(ZB1->ZB1_SLDEST )
	If MsgYesNo("Confirma o Desflegue da Provisão: "+ZB1->ZB1_PROVIS)
	 
		_cSenha := ProvBlqSenha()
		
		If Alltrim(_cSenha) <> GetMv("MV_SENHPRO")
			Alert("Senha incorreta !!!!!!")
			Return 
		EndIf         
		//cTipBloq := Alltrim(GetMv("MV_PROVBLQ"))
		
		LimpaCam()
	Else
		MsgStop("Processo abortado")
		Return Nil
	EndIf
Else
	MsgAlert("A provisão "+ZB1->ZB1_PROVIS+" já encontra-se aberta!")
EndIf	

Return                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LimpaCam ³ Autor ³    Eduardo Dias       ³ Data ³ 22/11/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para limpar os campos referente a Provisao para   ³±± 
±±³			 ³ fazer o desflegue da Provisão - OS 2965/16				  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function LimpaCam()
Local aArea		:=	GetArea()
Local _NomeUser := substr(cUsuario,7,15)
Local _Usuario	:= ""
Local cMsg1		:= ""
Local _aRetUser	:= {}
                               
// Defino a ordem para posicionar no nome do usuario
PswOrder(2) // Ordem de nome
If PswSeek(_NomeUser,.T.)
	// Obtenho o resultado conforme vetor
	_aRetUser	:= PswRet(1)
	_Usuario	:= upper(alltrim(_aRetUser[1,4]))
Else
	_Usuario	:= UPPER(_NomeUser)
EndIf

Begin Transaction

Reclock("ZB1",.F.)  
	ZB1->ZB1_SALDO := ZB1->ZB1_VALDOC
	ZB1->ZB1_DTLCTO := CTOD(" ")
	ZB1->ZB1_DTESTO := CTOD(" ")
	ZB1->ZB1_SLDEST := 0
	ZB1->ZB1_VLESTO := 0	
MsUnlock() 
         
ZB2->(DbGoTop())                             
                      
If ZB2->(dbSeek(xFilial("ZB2")+ZB1->ZB1_PROVIS))
	While !ZB2->(EOF()) .And. ZB2->ZB2_PROVIS == ZB1->ZB1_PROVIS
		Reclock("ZB2",.F.)
			ZB2->ZB2_SALDO := ZB2->ZB2_VALOR
			ZB2->ZB2_SLDEST := 0
			ZB2->ZB2_VLESTO := 0
		MsUnlock()                           
		
		ZB2->(dbSkip())		
	EndDo	
Else
	cMsg1:="Não existe registro para a Provisão selecionada!"
	Aviso("Verifique as inconsistências.",cMsg1,{"Fechar"},3)
	Return()
EndIf
*/
//Incluir log de execução
cProvis	:= ZB1->ZB1_PROVIS
dData	:= Date()
cTime	:= TIME()
DbSelectArea("ZV4")
DbSetorder(1)
If !ZV4->(dbSeek(xFilial("ZV4")+Dtoc(dData)+cTime))
	RecLock("ZV4",.T.)
	ZV4_FILIAL	:= "03"
	ZV4_DATA	:= dData
	ZV4_HORA	:= cTime
	ZV4_USER	:= _Usuario
	ZV4_PROVIS  := cProvis
	MsUnlock()
EndIf

MsgAlert("Provisão "+ZB1->ZB1_PROVIS+" aberta!")
	
End Transaction 

RestArea(aArea)
return                          

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ScanSCPC ³ Autor ³    Eduardo Dias       ³ Data ³ 22/11/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Tela de senha para o Desflegue da Provisão - OS 2965/16	  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function ProvBlqSenha

Local oDlg_1,Passw,oSBtn5,oSay6   
Local cSenha := Space(20)
oDlg_1 := MSDIALOG():Create()
oDlg_1:cName := "oDlg_1"
oDlg_1:cCaption := "Digite a senha para Desflegar a Provisão"
oDlg_1:nLeft := 0
oDlg_1:nTop := 0
oDlg_1:nWidth := 284
oDlg_1:nHeight := 110
oDlg_1:lShowHint := .F.
oDlg_1:lCentered := .T.

Passw := TGET():Create(oDlg_1)
Passw:cName := "Passw"
Passw:cCaption := "Passw"
Passw:nLeft := 111
Passw:nTop := 22
Passw:nWidth := 121
Passw:nHeight := 21
Passw:lShowHint := .F.
Passw:lReadOnly := .F.
Passw:Align := 0
Passw:cVariable := "cSenha"
Passw:bSetGet := {|u| If(PCount()>0,cSenha:=u,cSenha) }
Passw:lVisibleControl := .T.
Passw:lPassword := .T.
Passw:lHasButton := .F.

oSBtn5 := SBUTTON():Create(oDlg_1)
oSBtn5:cName := "oSBtn5"
oSBtn5:cCaption := "Ok"
oSBtn5:nLeft := 209
oSBtn5:nTop := 52
oSBtn5:nWidth := 52
oSBtn5:nHeight := 22
oSBtn5:lShowHint := .F.
oSBtn5:lReadOnly := .F.
oSBtn5:Align := 0
oSBtn5:lVisibleControl := .T.
oSBtn5:nType := 1
oSBtn5:bAction := {|| oDlg_1:END()}

oSay6 := TSAY():Create(oDlg_1)
oSay6:cName := "oSay6"
oSay6:cCaption := "Senha:"
oSay6:nLeft := 33
oSay6:nTop := 23
oSay6:nWidth := 65
oSay6:nHeight := 17
oSay6:lShowHint := .F.
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .T.

oDlg_1:Activate()

Return cSenha


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuDci   ºAutor  ³   Eduardo Dias    º Data ³   24/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza dicionario para gravacao do LOG de Desfleg 		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuDci()
Local aEstrut	:= {}
Local aSX3		:= {}
Local aSX2		:= {}
Local aSIX		:= {}
Local j,i

aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER","X3_PYME"}


Aadd(aSX3,{"ZV4","01","ZV4_FILIAL","C",2,0,"Filial","Filial","Filial","Filial do Sistema","Sucursal del Sistema","System Branch","@!","","€€€€€€€€€€€€€€€","","",1,"‚€","","","","N","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV4","02","ZV4_DATA"  ,"D",8,0,"Data","Data","Data","Data da execucao","Data da execucao","Data da execucao","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV4","03","ZV4_HORA"  ,"C",8,0,"Hora","Hora","Hora","Hora","Hora","Hora","99:99","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV4","06","ZV4_USER"  ,"C",30,0,"Usuario","Usuario","Usuario","Usuario","Usuario","Usuario","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV4","07","ZV4_PROVIS","C",9,0,"Provisao","Provisao","Provisao","Numero da Provisao","Numero da Provisao","Numero da Provisao","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})


dbSelectArea("SX3")
dbSetOrder(2)
If !dbSeek("ZV4")
	
	For i:= 1 To Len(aSX3)
		If !Empty(aSX3[i][1])
			If !dbSeek(aSX3[i,3])
				RecLock("SX3",.T.)
				For j:=1 To Len(aSX3[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
	
	aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPAC","X2_NOMEENGC","X2_ROTINA","X2_MODO","X2_MODOUN","X2_MODOEMP","X2_DELET","X2_TSS","X2_UNICO","X2_PYME","X2_MODULO"}
	
	aAdd(aSX2,{"ZV4","\DADOSADV\","","Log de Desflegue Provisao","Log de Desflegue Provisao","Log de Desflegue Provisao","","E","E","E",0,"","ZV4_FILIAL+DTOS(ZV4_DATA)+ZV4_HORA","S",6})	 //EDU TESTE
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("ZV4")
	cPath := "\DADOSADV\" //SX2->X2_PATH
	cNome := "ZV4050" //Substr(SX2->X2_ARQUIVO,4,5)
	cModo	:= "E" //SX2->X2_MODO
	
	For i:= 1 To Len(aSX2)
		If !Empty(aSX2[i][1])
			If !dbSeek(aSX2[i,1])
				RecLock("SX2",.T.)
				For j:=1 To Len(aSX2[i])
					If FieldPos(aEstrut[j]) > 0
						FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
					EndIf
				Next j
				SX2->X2_PATH    := cPath
				SX2->X2_ARQUIVO := cNome
				SX2->X2_MODO    := cModo
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
	
	aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}
	
	Aadd(aSIX,{"ZV4","1","ZV4_FILIAL+DTOS(ZV4_DATA)+ZV4_HORA","FILIAL+DATA+HORA","FILIAL+DATA+HORA","FILIAL+DATA+HORA","S","",""})
	
	dbSelectArea("SIX")
	dbSetOrder(1)
	For i:= 1 To Len(aSIX)
		If !Empty(aSIX[i,1])
			If !dbSeek(aSIX[i,1]+aSIX[i,2])
				lNew:= .T.
			Else
				lNew:= .F.
			EndIf
			
			If lNew.Or.UPPER(Alltrim(aSIX[i,3]))!=UPPER(AllTrim(CHAVE))
				RecLock("SIX",lNew)
				For j:=1 To Len(aSIX[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
EndIf

dbSelectArea("ZV4")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LogDesf ºAutor  ³    Eduardo Dias    º Data ³   24/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Apresentar a tela de LOG de processamento anteriores.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LogDesf()

Local aItens	:= {}
local nRBachou	:= 0

dbselectarea("ZV4")
ZV4->(dbgotop())

Do While !ZV4->(eof())
	nRBachou := aScan(aItens, ZV4->ZV4_DATA)
	if nRBachou = 0
//		If Alltrim(ZV4->ZV4_ROTINA) == "CSUCTB12"
		AADD(aItens, {ZV4_PROVIS, ZV4_DATA, ZV4_HORA, ZV4_USER} )
//		endif
	endif
	ZV4->(dbskip())
enddo

ASORT(aItens, , , { | x,y | x[2] > y[2] } )

//DEFINE DIALOG oDlg TITLE "log de Processamento do Fechamento" FROM 200,200 TO (altura),(largura) PIXEL
DEFINE DIALOG oDlg TITLE "log de execução do Desflegue da Provisão" FROM 0,0 TO 480,1120 PIXEL

oBrowse := TWBrowse():New( 02 , 01,560,210,,{'Num. Provisão','       Data        ','       Hora       ','       Usuário que processou '},{20,30,30},;
oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
aBrowse := aClone(aItens)

oBrowse:SetArray(aItens)

oBrowse:bLine := {||{aBrowse[oBrowse:nAt,01],aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04] } }

If !Empty(aItens)
	//@ 221,010 SAY "ATENÇÃO: Ultimo processamento realizado dia " OF oDlg PIXEL
	@ 221,010 SAY "ATENÇÃO: Ultimo desflegue realizado dia " + Dtoc(aItens[oBrowse:nAt,02]) + " - Através do Usuário: " + aItens[oBrowse:nAt,04] COLOR CLR_RED OF oDlg PIXEL
	SButton():New( 220,510,01,{||oDlg:End()},oDlg,.T.,,)
	
	ACTIVATE DIALOG oDlg CENTERED
EndIf

Return                                                                                    
