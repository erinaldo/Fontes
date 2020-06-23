#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATA920.CH"
#INCLUDE "TBICONN.CH"                       


#DEFINE VALMERC		1 // Valor total do mercadoria liquido
#DEFINE VALDESC		2 // Valor total do desconto
#DEFINE FRETE   	3 // Valor total do Frete
#DEFINE VALDESP 	4 // Valor total da despesa
#DEFINE TOTF1		5 // Total de Despesas Folder 1
#DEFINE TOTPED     	6 // Total do Pedido
#DEFINE SEGURO  	7 // Valor total do seguro
#DEFINE TOTF3		8 // Total utilizado no Folder 3
#DEFINE VALMERCB	9 // Valor total do mercadoria bruto
#DEFINE NTRIB 		10// Valor das despesas nao tributadas - Portugal
#DEFINE TARA		11// Valor da Tara - Portugal

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Mata920  ³ Autor ³ Andreia dos Santos    ³ Data ³ 02/02/00   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ SAIDA de Notas Fiscais de Venda Manual                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Andre Veiga   ³21/01/06³091814³- Alteracao para considerar os titulos    ³±±
±±³              ³        ³      ³  gerados atraves do SIGALOJA.            ³±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Mata920(xAutoCab,xAutoItens,nOpcAuto)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo os campos do arquivo que sempre deverao³
//³ aparecer no browse. (funcao mBrouse)                         ³
//³ ----------- Elementos contidos por dimensao ---------------- ³
//³ 1. Titulo do campo (Este nao pode ter mais de 12 caracteres) ³
//³ 2. Nome do campo a ser editado                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lSped := .F.
LOCAL aFixe:={	{ STR0050,"D2_DOC    " },; //"Numero da NF"
	{ STR0051,"D2_SERIE  " },; //"Serie da NF "
	{ STR0052,"D2_CLIENTE" } } //"Cliente     "
                                                             
Local aCores    := {	{'D2_TIPO=="N"'		,'DISABLE'   	},;	// NF Normal
						{'D2_TIPO=="P"'		,'BR_AZUL'   	},;	// NF de Compl. IPI
						{'D2_TIPO=="I"'		,'BR_MARROM' 	},;	// NF de Compl. ICMS
						{'D2_TIPO=="C"'		,'BR_PINK'   	},;	// NF de Compl. Preco/Frete
						{'D2_TIPO=="B"'		,'BR_CINZA'  	},;	// NF de Beneficiamento
						{'D2_TIPO=="D"'		,'BR_AMARELO'	} }	// NF de Devolucao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializando variaveis para processo de rotina automatica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE l920Auto     := ValType(xAutoCab) == "A" .and. ValType(xAutoItens) == "A"
PRIVATE aAutoItens   := {}
PRIVATE aAutoCab     := {}
Default nOpcAuto     := 3

PRIVATE aRotina := MenuDef()

lSped 	:=	AliasIndic("SFU") .And. AliasIndic("SFX") .And. AliasIndic("CD3") .And. AliasIndic("CD4") .And. ;
			AliasIndic("CD5") .And. AliasIndic("CD6") .And. AliasIndic("CD7") .And. AliasIndic("CD8") .And. ;
			AliasIndic("CD9") .And. AliasIndic("CDB") .And. AliasIndic("CDC") .And. AliasIndic("CDD") .And. ;
			AliasIndic("CDE") .And. AliasIndic("CDF") .And. AliasIndic("CDG") .And. cPaisLoc == "BRA"

If lSped
	aAdd(aRotina,{ STR0085 ,"a920Compl", 0 , 4 , 0 , NIL}) //"Complementos"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis da funcao pergunte                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par01	:=	2
mv_par02	:=	2
mv_par03	:=	2

PRIVATE cCadastro	:= OemToAnsi(STR0053) //"Notas Fiscais de Sa¡da"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta dicionario de dados:                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//³ Obs.: O parametro aFixe nao e' obrigatorio e pode ser omitido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l920Auto
	aAutoCab   := xAutoCab
	aAutoItens := xAutoItens
	DEFAULT nOpcAuto := 3
	MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"SF2")
Else
	mBrowse( 6, 1,22,75,"SD2",aFixe,"D2_TES",,,,aCores)
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a920NFSAI ³ Autor ³ Andreia dos Santos    ³ Data ³02/02/00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de inclusao de notas fiscai de SAIDA.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ a920NFSAI(ExpC1,ExpN1,ExpN2)                  	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Mauro Sano    ³20/02/06³092271³- Alteracao para mostrar as duplicatas  ³±±
±±³              ³        ³      ³  caso a NF utilize as condicoes:       ³±±
±±³              ³        ³      ³   CC/CD/FI/VA/CO                       ³±±
±±³Marcio Lopes  ³19/05/06³095009|- Permite visualizar as duplicataas     ³±±
±±³              ³        ³      ³  geradas pelo SIGALOJA, apartir de     ³±±
±±³              ³        ³      ³  qualquer modulo. (versao TOP)         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Function A920NFSAI(cAlias,nReg,nOpcx)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define variaveis                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lMA920AQISS := IIf(ExistBlock( "MA920AQISS"),ExecBlock("MA920AQISS",.f.,.f.),.F.)
Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local aAuxCombo1:= {"N","D","B","I","P","C"}
Local aPages	:= {"HEADER"}
Local aSizeAut	:= {}
Local aCombo1	:= {STR0041,;	//"Normal"
	STR0042,;	//"Devoluçao"
	STR0043,;	//"Beneficiamento"
	STR0044,;	//"Compl.  ICMS"
	STR0045,;	//"Compl.  IPI"
	STR0046}	//"Compl. Preço"

Local aCombo2	:= { STR0047 }  //"Sim"
Local aTitles	:= {	OemToAnsi(STR0006),; //"Totais"
	OemToAnsi(STR0007),; //"Inf. Cliente"
	OemToAnsi(STR0008),; //"Descontos/Frete/Despesas"
	OemToAnsi(STR0009),; //"Impostos"
	OemToAnsi(STR0010)}  //"Livros Fiscais"
Local aInfclie	:= {"","",CTOD("  /  /  "),CTOD("  /  /  "),"",""}
Local a920Var	:= Iif(cPaisLoc<>"PTG",{0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0})
Local aUsButtons:= {}
Local aRecSF3	:= {}
Local aRecSE1	:= {}
Local aRecSE2	:= {}
Local aPedidos	:= {}
Local aObj		:= Iif(cPaisLoc <> "PTG",Array(19),Array(22))
Local aObj1		:= Array(10) 
Local aButton   := {{"RELATORIO",{|| oGetDados:oBrowse:lDisablePaint:=.T.,;
	A920Pedido(1,aPedidos,SF2->F2_SERIE+"/"+SF2->F2_DOC),;
	oGetDados:oBrowse:lDisablePaint:=.F. },STR0054,STR0072 }} //"Visualiza Pedido" //"Visualiza Pedido"
Local aNFEletr	:= {}
Local aDANFE	:= {} 

Local c920Tipo	:= ""
Local cCombo2	:= ""
Local c920SClie

Local nOpc		:= 0

Local dDtDigit  := dDataBase

Local lGravaOk	:= .T.
Local l920Visual:= .F.
Local l920Inclui:= .F.
Local l920Deleta:= .F.
Local l920Altera:= .F.
Local lContinua	:= .T.
Local lPyme     := Iif(Type("__lPyme") <> "U",__lPyme,.F.)

Local oDlg
Local oGetDados
Local oc920SClie
Local oc920GClie
Local oc920Loj
Local oCond
Local ocNota
Local ocSerie
Local ocEspec
Local ocModal
Local ocVend
Local ocMoeda
Local ocTxMoeda
Local o920Tipo
Local od920Emis
Local oCombo1
Local oNFIni
Local oNFFim

Local xButton 	:= {}
Local nI		:= 0
Local nNFe		:= 0    
Local nObj		:= 0
Local nObjD		:= 0  
Local nLancAp	:=	0 
Local nDANFE    := 0 
Local nHoras  := 0
Local nSpedExc:= GetNewPar("MV_SPEDEXC",24)

Local aHeadCDA	:=	{}
Local aColsCDA	:=	{}
Local lMvAtuComp    := SuperGetMV("MV_ATUCOMP",,.F.)
Local aHeadAGH	:= {}
Local aColsAGH  := {}
Local nLinSay   := 0
Local cChave    := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
Case nOpcX == 0
	nOpcX := 2
	PRIVATE aRotina := {{ STR0002 	,"a920NFSAI"	, 0 	, 2,0,NIL},;
						{ STR0002 	,"a920NFSAI"	, 0 	, 2,0,NIL}}
    PRIVATE cCadastro := STR0053 + STR0096 //"Notas Fiscais de Sa¡da - VISUALIZAR"
	l920Visual 	:= .T.			
Case aRotina[nOpcx][4] == 2
	l920Visual 	:= .T.	
Case aRotina[nOpcx][4] == 3
	l920Inclui	:= .T.	
Case aRotina[nOpcx][4] == 5
	l920Deleta	:= .T.
	l920Visual	:= .T.
EndCase
cCadastro := IIf( Type("cCadastro") == "U" , STR0053 , cCadastro )
              
lInclui := l920Inclui
lLote   := (nOpcx == 5)

If l920Visual .And. !l920Deleta
	AAdd(aButton,{ "ORDEM", {|| A920Track() }, STR0070, STR0071 } ) //"System Tracker"
EndIf

If l920Visual .And. AliasInDic("AGH")
	Aadd(aButton , {'S4WB013N' ,{|| a920RatCC(@aHeadAGH,@aColsAGH,N) },STR0089,STR0090} )//"Rateio por Item do pedido de venda"##"Rateio"
EndIf 

If l920Visual
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajusta dicionario de dados:                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX3()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Avalia botoes do usuario                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MA920BUT" )
	If ValType( aUsButtons := ExecBlock( "MA920BUT", .F., .F. ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButton, x ) } ) 	 	
	EndIf 	
EndIf 	

PRIVATE aGetCpo := {"D2_COD"		,"D2_UM"		,"D2_QUANT"		,"D2_PRCVEN"	,;
	"D2_TOTAL"	,"D2_VALIPI","D2_VALICM"	,"D2_TES"		,;
	"D2_CF"		,"D2_PICM"	,"D2_IPI"		,"D2_PESO"		,;
	"D2_CONTA"	,"D2_DESC"	,"D2_NFORI"		,"D2_SERIORI"	,;
	"D2_BASEICM","D2_LOCAL"	,"D2_DESCON"	,"D2_ICMSRET"	,;
	"D2_BRICMS"	,"D2_SEGUM" ,"D2_DTVALID"	,"D2_QTSEGUM"   ,;
	"D2_ITEM"   ,"D2_CLASFIS","D2_CODISS"   ,"D2_LOTECTL"   ,;
	"D2_NUMLOTE","D2_PRUNIT","D2_BASEIPI"   ,"D2_PROJPMS"   ,;
	"D2_EDTPMS" ,"D2_TASKPMS","D2_CUSTO1","D2_CUSTO2"       ,;
	"D2_CUSTO3" ,"D2_CUSTO4" ,"D2_CUSTO5","D2_CCUSTO","D2_ITEMORI",;
	"D2_ITEMCC" , "D2_CLVL" }

Private bFolderRefresh	:= {|| (A920FRefresh(aObj))}
Private bGDRefresh		:= If (Type("l920Auto") != "L" .or. !l920Auto,{|| (oGetDados:oBrowse:Refresh()) },{|| nil })
Private bRefresh			:= {|| (A920Refresh(@a920Var,l920Inclui)),(Eval(bFolderRefresh))}
Private bListRefresh		:= {|| (A920FisToaCols()),Eval(bRefresh),Eval(bGdRefresh)}
Private aRemito			:=	{}	//Array com os remitos de cada item do acols

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o campo de codigo de lancamento cat 83 ³
//³deve estar visivel no acols                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SD2->(FieldPos("D2_CODLAN"))>0 .and. SuperGetMV("MV_CAT8309",,.F.)
	aAdd(aGetCpo,"D2_CODLAN")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PE para habilitar D2_ALIQISS na inclusao da NF     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l920Inclui .And. lMA920AQISS
	aAdd(aGetCpo,"D2_ALIQISS")	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica parametro MV_DATAFIS pela data de digitacao.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !aRotina[nOpcx][4] == 2 .And. !FisChkDt(dDatabase)
	Return
EndIf

If Type("l920Auto") != "L" .or. !l920Auto 
	dbSelectArea("SF2")
	dbSetOrder(1)
	MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
Else
	dbSelectArea("SD2")
	dbSetOrder(3)
	MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
Endif	

Private	cTipo  		:= If(l920Inclui,CriaVar("F2_TIPO")	,SF2->F2_TIPO)		,;
	    c920Nota 	:= If(l920Inclui,CriaVar("F2_DOC")		,SF2->F2_DOC)		,;
	    c920Serie	:= If(l920Inclui,CriaVar("F2_SERIE")	,SF2->F2_SERIE)	,;
	    d920Emis	:= If(l920Inclui,CriaVar("F2_EMISSAO")	,SF2->F2_EMISSAO)	,;
	    c920Client	:= If(l920Inclui,CriaVar("F2_CLIENTE")	,SF2->F2_CLIENTE)	,;
	    c920Loja	:= If(l920Inclui,CriaVar("F2_LOJA")	,SF2->F2_LOJA)		,;
	    c920Especi	:= If(l920Inclui,CriaVar("F2_ESPECIE")	,SF2->F2_ESPECIE)	,;
	    c920NFIni	:= If(l920Inclui,CriaVar("F2_DOC")		,SF2->F2_DOC)		,;
	    c920Vend	:= If(l920Inclui,CriaVar("F2_VEND1")	,SF2->F2_VEND1)		,;
	    c920DecExp	:= Iif(cPaisLoc=="PTG",If(l920Inclui,CriaVar("F2_DECLEXP")	,SF2->F2_DECLEXP),"")

Private c920Moeda	:= If( SF2->(FieldPos("F2_MOEDA"))>0,  If(l920Inclui,CriaVar("F2_MOEDA"),SF2->F2_MOEDA),1),; // Jeniffer 19/03 - Moeda
	    c920Taxa	:= If( SF2->(FieldPos("F2_TXMOEDA"))>0,If(l920Inclui,CriaVar("F2_TXMOEDA"),SF2->F2_TXMOEDA),0 ),; // Jeniffer 19/03 - Taxa Moeda
	    c920Modal	:= If( SF2->(FieldPos("F2_NATUREZ"))>0,If(l920Inclui,CriaVar("F2_NATUREZ"),SF2->F2_NATUREZ),""),; // Jeniffer 19/03 - Modalidade
	    c920NFFim	:= If(l920Inclui,CriaVar("F2_DOC"),SF2->F2_NFORI)		

PRIVATE aCols		:= {},;
	    aHeader 	:= {},;
	    N 			:= 1
PRIVATE oLancApICMS
PRIVATE aColsD2		:=	aCols
PRIVATE aHeadD2		:=	aHeader

c920SClie := If(cTipo$"DB",OemToAnsi(STR0035),OemToAnsi(STR0011)) //"Fornecedor"###"Cliente"
dDtdigit  := IIf(SF2->(FieldPos('F2_DTDIGIT'))>0 .And. !Empty(SF2->F2_DTDIGIT),SF2->F2_DTDIGIT,SF2->F2_EMISSAO)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica valores da Nota Fiscal Eletronica no SF2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "BRA"
	If l920Inclui
		aNFEletr := {CriaVar("F2_NFELETR"),CriaVar("F2_CODNFE"),CriaVar("F2_EMINFE"),CriaVar("F2_HORNFE"),CriaVar("F2_CREDNFE")} 
		aDANFE := {Iif(SF2->(FieldPos("F2_CHVNFE")) > 0,CriaVar("F2_CHVNFE"),Nil)} 
	Else 
		aNFEletr := {SF2->F2_NFELETR,SF2->F2_CODNFE,SF2->F2_EMINFE,SF2->F2_HORNFE,SF2->F2_CREDNFE} 	
		aDANFE := {Iif(SF2->(FieldPos("F2_CHVNFE")) > 0,SF2->F2_CHVNFE,Nil)} 	
	Endif
Endif

If SD2->(FieldPos("D2_VLIMPOR"))>0 
	aAdd(aGetCpo,"D2_VLIMPOR")
EndIf	

If !l920Inclui
	lLote := (SF2->F2_LOTE == "S")
	If l920Deleta      
		If !FisChkExc(SD2->D2_SERIE,SD2->D2_DOC,SD2->D2_CLIENTE,SD2->D2_LOJA)
			RestArea(aAreaSE1)
			RestArea(aArea)
			Return(.T.)
		Endif
		If SD2->D2_ORIGLAN != "LF"
			HELP("  ",1,"NAOLIV")
			RestArea(aAreaSE1)
			RestArea(aArea)
			Return .T.
		EndIf                           
		If AllTrim(c920Especi) == "NFFA" 
			dbSelectArea("CD4")
			CD4->(dbSetOrder(1))
			cChave := xFilial("CD4")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE
	    	//Avisa para excluir complemento de agua
			If CD4->(dbSeek(cChave))
				MsgAlert(STR0097)
				RestArea(aAreaSE1)
				RestArea(aArea)	
				Return .T.										
	        EndIf		
		EndIf
		If AllTrim(c920Especi) == "SPED" .And. (SF2->F2_FIMP$"TS") ////verificacao apenas da especie como SPED e notas que foram transmitidas ou impressos o DANFE
			nHoras := SubtHoras(IIF(SF2->(FieldPos("F2_DAUTNFE")) <> 0 .And. !Empty(SF2->F2_DAUTNFE),SF2->F2_DAUTNFE,dDtdigit),IIF(SF2->(FieldPos("F2_HAUTNFE")) <> 0 .And. !Empty(SF2->F2_HAUTNFE),SF2->F2_HAUTNFE,SF2->F2_HORA), dDataBase, substr(Time(),1,2)+":"+substr(Time(),4,2) )
			If nHoras > nSpedExc
				MsgAlert("Não foi possivel excluir a(s) nota(s), pois o prazo para o cancelamento da(s) NF-e é de " + Alltrim(STR(nSpedExc)) +" horas")
				Return .T.
		    EndIf
		EndIf
	    //Avisa para excluir complemento fiscal
		dbSelectArea("CDT")
		CDT->(dbSetOrder(1))
		cChave := xFilial("CDT")+"S"+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA			
		If CDT->(dbSeek(cChave))
			MsgAlert(STR0098)
			RestArea(aAreaSE1)
			RestArea(aArea)	
			Return .T.										
		EndIf	
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa as variaveis utilizadas na exibicao da NF         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A920Client(SF2->F2_CLIENTE,SF2->F2_LOJA,@aInfClie,cTipo,l920Inclui)
	If Type("l920Auto") != "L" .or. !l920Auto
		If !lLote
			A920CabOk(@oCombo1,@ocNota,@od920Emis,@oc920GClie,@oc920Loj)
		Else
			A920CbLot(@oNFIni,@oNFFim,@od920Emis,@oc920GClie,@oc920Loj)
		EndIf
		c920Tipo	:= If(!Empty(cTipo).And.cTipo!="L",aCombo1[aScan(aAuxCombo1,cTipo)],Space(6))
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclusao dos campos referente ao desconto para Zona Franca de Manaus apenas na visualizacao da nota fiscal  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd( aGetCpo,"D2_DESCZFR")
	Aadd( aGetCpo,"D2_DESCZFP")
	Aadd( aGetCpo,"D2_DESCZFC")

   //Incentivo a producao e industrializacao do leite
	If SD2->(FieldPos("D2_PRINCMG"))>0 
		aAdd(aGetCpo,"D2_PRINCMG")
	EndIf
	If SD2->(FieldPos("D2_VLINCMG"))>0 
		aAdd(aGetCpo,"D2_VLINCMG")
	EndIf		   
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader e aCols                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sintaxe da FillGetDados(nOpcx,cAlias,nOrder,cSeekKey,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry,bCriaVar,lUserFields) |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FillGetDados(nOpcx,"SD2",1,/*cSeek*/,/*cWhile*/,/*uSeekFor*/,/*aNoFields*/,aGetCpo,/*lOnlyYes*/,/*cQuery*/,{|| MaCols920(l920Inclui,l920Altera,l920Deleta,@lContinua,@aPedidos,@aRecSE1,@aRecSE2,@aRecSF3,@a920Var,@aTitles) },l920Inclui,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bbeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,/*bCriaVar*/,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega os dados do rateio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasInDic("AGH")
    A920FRat(@aHeadAGH,@aColsAGH)	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se for processo de rotina automatica, nao monta tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("l920Auto") != "L" .or. !l920Auto
	aSizeAut := MsAdvSize(,.F.,345)
	aObjects := {}
	AAdd( aObjects, { 0,    41, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    75, .T., .F. } )

	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }

	aPosObj := MsObjSize( aInfo, aObjects )

	If cPaisLoc == "BRA"			
		aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
			{{8,23,78,128,163,200,250,270},;
			{8,32,95,130,170,204,260},;
			{7,32,68,95,135,165,227,250},;
			{8,32,75,200,250},;
			{5,70,160,205,295},;
			{6,34,200,215},;
			{6,34,106,139},;
			{6,34,245,268,220},;
			{5,50,150,190},;
			{277,130,190,293,205}})
	Else
		aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
			{Iif(cPaisLoc<>"PTG",{6,26,78,112,125,183,205,276,290},{6,26,78,102,115,157,177,226,240,258,286}),;
			Iif(cPaisLoc<>"PTG",{6,38,71,91,140,160,201,220,273,284},{6,36,86,106,140,160,201,220,273,284}),;
			{7,32,68,95,135,165,227,250},;
			{8,32,75,200,290},;
			Iif(cPaisLoc<>"PTG",{5,70,160,205,295},{5,50,120,140,200,245,295}),;
			{6,34,200,215},;
			{6,34,106,139},;
			{6,34,245,268,220},;
			Iif(cPaisLoc<>"PTG",{5,50,150,190},{5,50,115,140,200,245,295}),;
			{277,130,190,293,205}})						
	Endif
	If !lLote							
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define os botoes que serao exibidos ne enchoicebar ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xButton := If( Empty(aPedidos),If( Empty( aUsButtons ) .Or. ValType( aUsButtons )<> "A", Nil, aUsButtons ), aButton )		
		
		If l920Visual .And. !l920Deleta .And. !lPyme 
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona chamada ao banco de conhecimento          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ValType( xButton ) <> "A" 
				xButton := {} 
			EndIf	
			AAdd(xButton,{ "CLIPS", {|| A920Conhec() }, STR0073, STR0074 } ) // "Banco de Conhecimento", "Conhecim."

		EndIf
		
		DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro Of oMainWnd PIXEL

		If cPaisloc == "BRA"
			@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3],aPosObj[1][4] LABEL '' OF oDlg PIXEL
			
			nLinSay	:=	aPosObj[1][1]+6 
			
			@ nLinSay  ,aPosget[1,1] SAY OemToAnsi(STR0012) Of oDlg PIXEL SIZE 26 ,9 //'Tipo'
			@ nLinSay-2,aPosget[1,2]  MSCOMBOBOX oCombo1 	VAR 	c920Tipo ITEMS aCombo1 SIZE 50 ,90 ;
													WHEN 	VisualSX3('F1_TIPO').and. !l920Visual ;
													VALID 	A920Combo(@cTipo,aCombo1,c920Tipo,aAuxCombo1).And.;
													A920Tipo(cTipo,@oc920SClie,@c920SClie,@oc920GClie,@c920Client,@c920Loja,@oc920Loj) ;
													OF oDlg PIXEL

			@ nLinSay  ,aPosget[1,3]	SAY OemToAnsi(STR0049) Of oDlg PIXEL SIZE 52 ,9 //'Formulario Proprio'
			@ nLinSay-2,aPosget[1,4] MSCOMBOBOX oCombo2 	VAR cCombo2 ITEMS aCombo2 SIZE 25 ,50 ;
													WHEN .F. OF oDlg PIXEL

			@ nLinSay  ,aPosget[1,5] SAY OemToAnsi(STR0013) Of oDlg PIXEL SIZE 45 ,9 //'Nota Fiscal'
			@ nLinSay-2,aPosget[1,6] MSGET ocNota 	VAR c920Nota Picture PesqPict('SF2','F2_DOC') ;
												When VisualSX3('F2_DOC') .and. !l920Visual ;
												Valid  A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui);
												OF oDlg PIXEL SIZE 34 ,9

			@ nLinSay  ,aPosget[1,7] SAY OemToAnsi(STR0014) Of oDlg PIXEL SIZE 23 ,9 //'Serie'
			@ nLinSay-2,aPosget[1,8] MSGET ocSerie 	VAR c920Serie  Picture PesqPict('SF2','F2_SERIE') ;
												When VisualSX3('F2_SERIE').and. !l920Visual ;
												Valid A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui);
														.And. A920NOTA(c920Nota,c920Serie) ;
												OF oDlg PIXEL SIZE 18 ,9

			nLinSay	+=	20

			@ nLinSay  ,aPosget[2,1] SAY OemToAnsi(STR0015) Of oDlg PIXEL SIZE 16 ,9 //'Data'
			@ nLinSay-2,aPosget[2,2] MSGET od920Emis VAR d920Emis Picture PesqPict('SF2','F2_EMISSAO') ;
												When VisualSX3('F2_EMISSAO').and. !l920Visual ;
												Valid  A920Emissao(d920Emis) .And. CheckSX3('F2_EMISSAO')  ;
												OF oDlg PIXEL SIZE 49 ,9

			@ nLinSay  ,aPosget[2,3] SAY oc920SClie VAR c920SClie Of oDlg PIXEL SIZE 43 ,9  //Cliente
			@ nLinSay-2,aPosget[2,4] MSGET oc920GClie 	VAR c920Client  Picture PesqPict('SF2','F2_CLIENTE') ;
													F3 CpoRetF3('F2_CLIENTE');
													When VisualSX3('F2_CLIENTE').and. !l920Visual ;
													Valid  A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui) .And.;
															CheckSX3('F2_CLIENTE',c920Client);
															.And. A920VFold("NF_CODCLIFOR",c920Client);
													OF oDlg PIXEL SIZE 41 ,9

			@ nLinSay-2,aPosget[2,5] MSGET oc920Loj 	VAR c920Loja  Picture PesqPict('SF2','F2_LOJA') ;
												F3 CpoRetF3('F2_LOJA');	//Filial
												When VisualSX3('F2_LOJA').and. !l920Visual ;
												Valid CheckSX3('F2_LOJA',c920Loja).and. A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui) ;
												.And.A920VFold("NF_LOJA",c920Loja) ;
												OF oDlg PIXEL SIZE 15 ,9

			@ nLinSay  ,aPosget[2,6] SAY OemToAnsi(STR0016) Of oDlg PIXEL SIZE 63 ,9 //'Tipo de Documento'
			@ nLinSay-2,aPosget[2,7] MSGET c920Especi  Picture PesqPict('SF2','F2_ESPECIE') ;
													F3 CpoRetF3('F2_ESPECIE');
													When VisualSX3('F2_ESPECIE').and. !l920Visual ;
													Valid CheckSX3('F2_ESPECIE',c920Especi) .And. MaFisRef("NF_ESPECIE","MT100",c920Especi) ;
													OF oDlg PIXEL SIZE 30 ,9

			oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,'A920LinOk','A920TudOk','+D2_ITEM', (!l920Visual) ,,,,300,'A920FieldOk',,,'A920Del')
			oGetDados:oBrowse:bGotFocus	:= {||A920CabOk(@oCombo1,@ocNota,@od920Emis,@oc920GClie,@oc920Loj) }
		Else

			If cPaisLoc <> "PTG"
			
				nLinSay	:=	aPosObj[1][1]+6 
			 
				@ nLinSay,aPosget[1,1] SAY oc920SClie VAR c920SClie Of oDlg PIXEL SIZE 43 ,9  //Cliente
				@ nLinSay,aPosget[1,2] MSGET oc920GClie VAR c920Client  Picture PesqPict('SF2','F2_CLIENTE') ;
													F3 CpoRetF3('F2_CLIENTE');
													When VisualSX3('F2_CLIENTE').AND. !l920Visual ;
													Valid  A920Client(c920Client,c920Loja,@aInfClie,cTipo).AND.CheckSX3('F2_CLIENTE',c920Client,l920Inclui);
															.AND.A920VFold("NF_CODCLIFOR",c920Client) ;
													OF oDlg PIXEL SIZE 80 ,9
	
				@ nLinSay,aPosget[1,3] MSGET oc920Loj 	VAR c920Loja  Picture PesqPict('SF2','F2_LOJA') ;
													F3 CpoRetF3('F2_LOJA');	//Filial
													When VisualSX3('F2_LOJA').AND. !l920Visual ;
													Valid CheckSX3('F2_LOJA',c920Loja).AND. A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui) ;
															.AND.A920VFold("NF_LOJA",c920Loja) ;
													OF oDlg PIXEL SIZE 15 ,9	
	
				@ nLinSay,aPosget[1,4] SAY  (STR0015) Of oDlg PIXEL SIZE 16 ,9 //'Data'
				@ nLinSay,aPosget[1,5] MSGET od920Emis 	VAR d920Emis Picture PesqPict('SF2','F2_EMISSAO') ;
													When VisualSX3('F2_EMISSAO').AND. !l920Visual ;
													Valid  A920Emissao(d920Emis) .AND. CheckSX3('F2_EMISSAO') ;
													OF oDlg PIXEL SIZE 49 ,9				
	
				@ nLinSay,aPosget[1,6] SAY  (STR0013) Of oDlg PIXEL SIZE 45 ,9 	//'Factura'
				@ nLinSay,aPosget[1,7] MSGET ocNota VAR c920Nota Picture PesqPict('SF2','F2_DOC') ;
												When VisualSX3('F2_DOC') .AND. !l920Visual ;
												Valid  A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui);
												OF oDlg PIXEL SIZE 65 ,9
	
				@ nLinSay,aPosget[1,8] SAY  (STR0014) Of oDlg PIXEL SIZE 23 ,9 //'Serie'
				@ nLinSay,aPosget[1,9] MSGET ocSerie 	VAR c920Serie  Picture PesqPict('SF2','F2_SERIE') ;
													When VisualSX3('F2_SERIE').AND. !l920Visual ;
													Valid A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui);
															.AND. A920NOTA(c920Nota,c920Serie) ;
													OF oDlg PIXEL SIZE 18 ,9

				nLinSay	+=	20
	
				@ nLinSay,aPosget[2,1] SAY  (STR0016) Of oDlg PIXEL SIZE 63 ,9 //'Tipo de Documento'
				@ nLinSay,aPosget[2,2] MSGET c920Especi Picture PesqPict('SF2','F2_ESPECIE') ;
													F3 CpoRetF3('F2_ESPECIE');
													When VisualSX3('F2_ESPECIE').AND. !l920Visual ;
													Valid CheckSX3('F2_ESPECIE',c920Especi) ;
													OF oDlg PIXEL SIZE 10,9
	
				@ nLinSay,aPosget[2,3] SAY  (STR0058) Of oDlg PIXEL SIZE 63 ,9 //'Modalidad'
				@ nLinSay,aPosget[2,4] MSGET c920Modal Picture PesqPict('SF2','F2_NATUREZ') ;
													When .F. ;
													OF oDlg PIXEL SIZE 30 ,9			
	
				@ nLinSay,aPosget[2,5] SAY  (STR0068) Of oDlg PIXEL SIZE 63 ,9 //'vendedor'
				@ nLinSay,aPosget[2,6] MSGET c920Vend Picture PesqPict('SF2','F2_VEND1') ;
													When .F. ;
													OF oDlg PIXEL SIZE 35 ,9
	
				@ nLinSay,aPosget[2,7] SAY  (STR0059) Of oDlg PIXEL SIZE 63 ,9 //'Moneda'
				@ nLinSay,aPosget[2,8] MSGET c920Moeda Picture "99" ;
													When .F. ;
													OF oDlg PIXEL SIZE 50 ,9
	
				@ nLinSay,aPosget[2,9] SAY  (STR0069) Of oDlg PIXEL SIZE 63 ,9 //'Tasa'
				@ nLinSay,aPosget[2,10] MSGET c920Taxa Picture PesqPict('SF2','F2_TXMOEDA') ;
													When .F. ;
													OF oDlg PIXEL SIZE 35,9			
				
			Else
			
				nLinSay	:=	aPosObj[1][1]+6 
				
				@ nLinSay,aPosget[1,1] SAY oc920SClie VAR c920SClie Of oDlg PIXEL SIZE 43 ,9  //Cliente
				@ nLinSay,aPosget[1,2] MSGET oc920GClie VAR c920Client  Picture PesqPict('SF2','F2_CLIENTE') ;
													F3 CpoRetF3('F2_CLIENTE');
													When VisualSX3('F2_CLIENTE').and. !l920Visual ;
													Valid  A920Client(c920Client,c920Loja,@aInfClie,cTipo).And.CheckSX3('F2_CLIENTE',c920Client,l920Inclui);
															.And.A920VFold("NF_CODCLIFOR",c920Client) ;
													OF oDlg PIXEL SIZE 80 ,9
	
				@ nLinSay,aPosget[1,3] MSGET oc920Loj 	VAR c920Loja  Picture PesqPict('SF2','F2_LOJA') ;
													F3 CpoRetF3('F2_LOJA');	//Filial
													When VisualSX3('F2_LOJA').and. !l920Visual ;
													Valid CheckSX3('F2_LOJA',c920Loja).and. A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui) ;
															.And.A920VFold("NF_LOJA",c920Loja) ;
													OF oDlg PIXEL SIZE 15 ,9	
	
				@ nLinSay,aPosget[1,4] SAY OemToAnsi(STR0015) Of oDlg PIXEL SIZE 16 ,9 //'Data'
				@ nLinSay,aPosget[1,5] MSGET od920Emis 	VAR d920Emis Picture PesqPict('SF2','F2_EMISSAO') ;
													When VisualSX3('F2_EMISSAO').and. !l920Visual ;
													Valid  A920Emissao(d920Emis) .And. CheckSX3('F2_EMISSAO') ;
													OF oDlg PIXEL SIZE 49 ,9				
	
				@ nLinSay,aPosget[1,6] SAY OemToAnsi(STR0013) Of oDlg PIXEL SIZE 45 ,9 	//'Factura'
				@ nLinSay,aPosget[1,7] MSGET ocNota VAR c920Nota Picture PesqPict('SF2','F2_DOC') ;
												When VisualSX3('F2_DOC') .and. !l920Visual ;
												Valid  A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui);
												OF oDlg PIXEL SIZE 65 ,9
	
				@ nLinSay,aPosget[1,8] SAY OemToAnsi(STR0014) Of oDlg PIXEL SIZE 23 ,9 //'Serie'
				@ nLinSay,aPosget[1,9] MSGET ocSerie 	VAR c920Serie  Picture PesqPict('SF2','F2_SERIE') ;
													When VisualSX3('F2_SERIE').and. !l920Visual ;
													Valid A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui);
															.And. A920NOTA(c920Nota,c920Serie) ;
													OF oDlg PIXEL SIZE 18 ,9
	
				@ nLinSay,aPosget[1,10] SAY OemToAnsi(STR0016) Of oDlg PIXEL SIZE 63 ,9 //'Tipo de Documento'
				@ nLinSay,aPosget[1,11] MSGET c920Especi Picture PesqPict('SF2','F2_ESPECIE') ;
													F3 CpoRetF3('F2_ESPECIE');
													When VisualSX3('F2_ESPECIE').and. !l920Visual ;
													Valid CheckSX3('F2_ESPECIE',c920Especi) ;
													OF oDlg PIXEL SIZE 10,9
	             
				nLinSay	+=	20
	
				@ nLinSay,aPosget[2,1] SAY OemToAnsi(STR0088) Of oDlg PIXEL SIZE 63 ,9 //'Decl. Export.'
				@ nLinSay,aPosget[2,2] MSGET c920DecExp Picture PesqPict('SF2','F2_DECLEXP') ;
													When .F. ;
													OF oDlg PIXEL SIZE 65 ,9			

				@ nLinSay,aPosget[2,3] SAY OemToAnsi(STR0058) Of oDlg PIXEL SIZE 63 ,9 //'Modalidad'
				@ nLinSay,aPosget[2,4] MSGET c920Modal Picture PesqPict('SF2','F2_NATUREZ') ;
													When .F. ;
													OF oDlg PIXEL SIZE 30 ,9			
	
				@ nLinSay,aPosget[2,5] SAY OemToAnsi(STR0068) Of oDlg PIXEL SIZE 63 ,9 //'vendedor'
				@ nLinSay,aPosget[2,6] MSGET c920Vend Picture PesqPict('SF2','F2_VEND1') ;
													When .F. ;
													OF oDlg PIXEL SIZE 35 ,9
	
				@ nLinSay,aPosget[2,7] SAY OemToAnsi(STR0059) Of oDlg PIXEL SIZE 63 ,9 //'Moneda'
				@ nLinSay,aPosget[2,8] MSGET c920Moeda Picture "99" ;
													When .F. ;
													OF oDlg PIXEL SIZE 50 ,9
	
				@ nLinSay,aPosget[2,9] SAY OemToAnsi(STR0069) Of oDlg PIXEL SIZE 63 ,9 //'Tasa'
				@ nLinSay,aPosget[2,10] MSGET c920Taxa Picture PesqPict('SF2','F2_TXMOEDA') ;
													When .F. ;
													OF oDlg PIXEL SIZE 35,9		 
			Endif	

			oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,'A920LinOk','A920TudOk','+D2_ITEM',.T.,,,,300,'A920FieldOk',,,'A920Del')
			oGetDados:oBrowse:bGotFocus	:= {||A920CabOk(@oCombo1,@ocNota,@od920Emis,@oc920GClie,@oc920Loj) }

		Endif
	else
		DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(STR0040) Of oMainWnd PIXEL //"Nota de Sa¡da em Lote"

		@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3],aPosObj[1][4] LABEL '' OF oDlg PIXEL

		nLinSay	:=	aPosObj[1][1]+6
		
		@ nLinSay,aPosGet[3,1] SAY OemToAnsi(STR0014)  OF oDlg PIXEL SIZE 23, 9//"S‚rie"
		@ nLinSay,aPosGet[3,2] MSGET ocSerie VAR c920Serie PICTURE PesqPict('SF2','F2_SERIE');
			When VisualSX3('F2_SERIE').and. !l920Visual Valid CheckSX3('F2_SERIE');
			OF oDlg PIXEL 	SIZE 18, 9

		@ nLinSay,aPosGet[3,3] SAY OemToAnsi(STR0038)   SIZE 29, 7 OF oDlg PIXEL //"NF.Inicial"
		@ nLinSay,aPosGet[3,4] MSGET oNFIni VAR c920NFIni Picture PesqPict('SF2','F2_DOC');
			When !l920Visual VALID NaoVazio().and.A920VlNfLote(c920Serie,c920NFIni);
			OF oDlg PIXEL SIZE 25, 10

		@ nLinSay,aPosGet[3,5] SAY OemToAnsi(STR0039)     SIZE 25, 9 OF oDlg PIXEL //"NF.Final"
		@ nLinSay,aPosGet[3,6] MSGET oNFFim VAR c920NFFim  Picture PesqPict('SF2','F2_DOC') ;
			When !l920Visual VALID (Val(c920NFFim)>=Val(c920NFIni).AND.A920VlNfLote(c920Serie,c920NFIni,c920NFFim));
			OF oDlg PIXEL 	SIZE 25, 10

		@ nLinSay,aPosGet[3,7] SAY OemToAnsi(STR0037) OF oDlg PIXEL  SIZE 25, 7  //"Emiss„o"
		@ nLinSay,aPosGet[3,8] MSGET od920Emis VAR d920Emis	Picture PesqPict('SF2','F2_EMISSAO') ;
			When VisualSX3('F2_EMISSAO').and. !l920Visual VALID A920Emissao(d920Emis) .And. CheckSX3('F2_EMISSAO')  ;
			OF oDlg PIXEL	SIZE 43, 10

		nLinSay	+=	20
		
		@ nLinSay,aPosGet[4,1] SAY OemToAnsi(STR0011)  OF oDlg PIXEL SIZE 20, 7  //"Cliente"
		@ nLinSay,aPosGet[4,2] MSGET oc920GClie VAR c920Client  Picture PesqPict('SF2','F2_CLIENTE') F3 CpoRetF3('F2_CLIENTE');
			When VisualSX3('F2_CLIENTE').and. !l920Visual Valid  A920Client(c920Client,c920Loja,@aInfClie,cTipo).And.CheckSX3('F2_CLIENTE',c920Client,l920Inclui);
			OF oDlg PIXEL	SIZE 30, 10

		@ nLinSay,aPosGet[4,3] MSGET oc920Loj VAR c920Loja  Picture PesqPict('SF2','F2_LOJA') F3 CpoRetF3('F2_LOJA');
			When VisualSX3('F2_LOJA').and. !l920Visual Valid CheckSX3('F2_LOJA',c920Loja).and. A920Client(c920Client,c920Loja,@aInfClie,cTipo,l920Inclui) ;
			OF oDlg PIXEL	SIZE 14, 10

		@ nLinSay,aPosGet[4,4] SAY OemtoAnsi(STR0016) OF oDlg PIXEL SIZE 50,7  //"Tipo de Documento"
		@ nLinSay,aPosGet[4,5] MSGET c920Especi  Picture PesqPict('SF2','F2_ESPECIE') F3 CpoRetF3('F2_ESPECIE');
			When VisualSX3('F2_ESPECIE').and. !l920Visual Valid CheckSX3('F2_ESPECIE',c920Especi) ;
			OF oDlg PIXEL SIZE 17,10

		oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,'A920LinOk','A920TudOk','+D2_ITEM',.T.,,,,300,'A920FieldOk',,,'A920Del')
		oGetDados:oBrowse:bGotFocus	:= {||A920CbLot(@oNFIni,@oNFFim,@od920Emis,@oc920GClie,@oc920Loj)	 }
	EndIf		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nota fiscal em lote nao gera NF-e. Sera sempre um RPS para uma NF-e. ³
	//³Na NF em lote, seriam varios RPS para uma mesma NF-e                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc == "BRA" .And. !lLote
		aAdd(aTitles,STR0082)
		nNFe 	:= 	Len(aTitles)

		If AliasIndic("CDA")
			aAdd(aTitles,STR0084)	//"Lançamentos da Apuração de ICMS"
			nLancAp	:=	Len(aTitles)
		EndIf
	
		aAdd(aTitles,STR0094)       
		nDANFE 	:= 	Len(aTitles)	     
	Endif
		
	oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,aPages,oDlg,,,,.T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
	
	For ni := 1 to Len(oFolder:aDialogs)
		DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[ni]
	Next	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tela de Totalizadores.  					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFolder:aDialogs[1]:oFont := oDlg:oFont

	If cPaisLoc <> "PTG"
		@ 06,aPosGet[5,1]   SAY OemToAnsi(STR0017) Of oFolder:aDialogs[1] PIXEL SIZE 90,9 // "Valor da Mercadoria (Liquido)"
		@ 05,aPosGet[5,2]   MSGET aObj[19] VAR a920Var[VALMERC] Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 06,aPosGet[5,3] SAY OemToAnsi(STR0018) Of oFolder:aDialogs[1] PIXEL SIZE 49 ,9 // "Descontos"
		@ 05,aPosGet[5,4] MSGET aObj[2] VAR a920Var[VALDESC]  Picture PesqPict('SD2','D2_DESCON') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
		
		@ 20,aPosGet[5,1]   SAY OemToAnsi(STR0076) Of oFolder:aDialogs[1] PIXEL SIZE 90 ,9 // "Valor da Mercadoria (Bruto)"
		@ 19,aPosGet[5,2]   MSGET aObj[1] VAR a920Var[VALMERCB] Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 34,aPosGet[5,1]  SAY OemToAnsi(STR0019) Of oFolder:aDialogs[1] PIXEL SIZE 45 ,9 // "Valor do Frete"
		@ 33,aPosGet[5,2]  MSGET aObj[3] VAR a920Var[FRETE]  Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 20,aPosGet[5,3]  SAY OemToAnsi(STR0020) Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9 // "Valor do Seguro"
		@ 19,aPosGet[5,4]  MSGET aObj[4] VAR a920Var[SEGURO]  Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 34,aPosGet[5,3]  SAY OemToAnsi(STR0021) Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9  // "Gastos"
		@ 33,aPosGet[5,4]  MSGET aObj[5] VAR a920Var[VALDESP]  Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F.  SIZE 80 ,9
	
		@ 51,aPosGet[5,3] SAY OemToAnsi(STR0022) Of oFolder:aDialogs[1] PIXEL SIZE 58 ,9 // "Total da Factura"
		@ 49,aPosGet[5,4] MSGET aObj[6] VAR a920Var[TOTPED]  Picture PesqPict('SF2','F2_VALBRUT') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 43,03 TO 46 ,aPosGet[5,5] LABEL '' OF oFolder:aDialogs[1] PIXEL
	Else
		@ 06,aPosGet[5,1]   SAY OemToAnsi(STR0017) Of oFolder:aDialogs[1] PIXEL SIZE 90,9 // "Valor da Mercadoria (Liquido)"
		@ 05,aPosGet[5,2]   MSGET aObj[19] VAR a920Var[VALMERC] Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 06,aPosGet[5,3] SAY OemToAnsi(STR0018) Of oFolder:aDialogs[1] PIXEL SIZE 49 ,9 // "Descontos"
		@ 05,aPosGet[5,4] MSGET aObj[2] VAR a920Var[VALDESC]  Picture PesqPict('SD2','D2_DESCON') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
		
		@ 06,aPosGet[5,5]   SAY OemToAnsi(STR0076) Of oFolder:aDialogs[1] PIXEL SIZE 90 ,9 // "Valor da Mercadoria (Bruto)"
		@ 05,aPosGet[5,6]   MSGET aObj[1] VAR a920Var[VALMERCB] Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 20,aPosGet[5,1]  SAY OemToAnsi(STR0019) Of oFolder:aDialogs[1] PIXEL SIZE 45 ,9 // "Valor do Frete"
		@ 19,aPosGet[5,2]  MSGET aObj[3] VAR a920Var[FRETE]  Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 20,aPosGet[5,3]  SAY OemToAnsi(STR0020) Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9 // "Valor do Seguro"
		@ 19,aPosGet[5,4]  MSGET aObj[4] VAR a920Var[SEGURO]  Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 20,aPosGet[5,5]  SAY OemToAnsi(STR0021) Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9  // "Gastos"
		@ 19,aPosGet[5,6]  MSGET aObj[5] VAR a920Var[VALDESP]  Picture PesqPict('SD2','D2_TOTAL') OF oFolder:aDialogs[1] PIXEL When .F.  SIZE 80 ,9
		
		@ 34,aPosGet[5,1]  SAY OemToAnsi(STR0086) Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9  // "Desp. nao Tib."
		@ 33,aPosGet[5,2]  MSGET aObj[19] VAR a920Var[NTRIB]  Picture PesqPict('SD2','D2_DESNTRB') OF oFolder:aDialogs[1] PIXEL When .F.  SIZE 80 ,9
		
		@ 34,aPosGet[5,3]  SAY OemToAnsi(STR0087) Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9  // "Tara"
		@ 33,aPosGet[5,4]  MSGET aObj[20] VAR a920Var[TARA]  Picture PesqPict('SD2','D2_TARA') OF oFolder:aDialogs[1] PIXEL When .F.  SIZE 80 ,9
	
		@ 51,aPosGet[5,5] SAY OemToAnsi(STR0022) Of oFolder:aDialogs[1] PIXEL SIZE 58 ,9 // "Total da Factura"
		@ 49,aPosGet[5,6] MSGET aObj[6] VAR a920Var[TOTPED]  Picture PesqPict('SF2','F2_VALBRUT') OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
	
		@ 46,03 TO 47 ,aPosGet[5,7] LABEL '' OF oFolder:aDialogs[1] PIXEL
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informacoes do Cliente  			        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oFolder:aDialogs[2]:oFont := oDlg:oFont
	@ 6  ,aPosGet[6,1] SAY OemToAnsi(STR0023) Of oFolder:aDialogs[2] PIXEL SIZE 37 ,9 // "Nome"
	@ 5  ,aPosGet[6,2] MSGET aObj[7] VAR aInfClie[1] Picture PesqPict('SA1','A1_NOME');
		When .F. OF oFolder:aDialogs[2] PIXEL SIZE 159,9

	@ 6  ,aPosGet[6,3] SAY OemToAnsi(STR0024) Of oFolder:aDialogs[2] PIXEL SIZE 23 ,9 // "Tel."
	@ 5  ,aPosGet[6,4] MSGET aObj[8] VAR aInfClie[2] Picture PesqPict('SA1','A1_TEL');
		When .F. OF oFolder:aDialogs[2] PIXEL SIZE 74 ,9

	@ 43 ,aPosGet[7,1] SAY OemToAnsi(STR0025) Of oFolder:aDialogs[2] PIXEL SIZE 32 ,9 // "1a Compra"
	@ 42 ,aPosGet[7,2] MSGET aObj[9] VAR aInfClie[3] Picture PesqPict('SA1','A1_PRICOM') ;
		When .F. OF oFolder:aDialogs[2] PIXEL SIZE 56 ,9

	@ 43 ,aPosGet[7,3] SAY OemToAnsi(STR0026) Of oFolder:aDialogs[2] PIXEL SIZE 36 ,9 // "Ult. Compra"
	@ 42 ,aPosGet[7,4] MSGET aObj[10] VAR aInfClie[4] Picture PesqPict('SA1','A1_ULTCOM');
		When .F. OF oFolder:aDialogs[2] PIXEL SIZE 56 ,9

	@ 24 ,aPosGet[8,1]  SAY OemToAnsi(STR0027) Of oFolder:aDialogs[2] PIXEL SIZE 49 ,9 // "Endereco"
	@ 23 ,aPosGet[8,2]  MSGET aObj[11] VAR aInfClie[5]  Picture PesqPict('SA1','A1_END');
		When .F. OF oFolder:aDialogs[2] PIXEL SIZE 205,9

	@ 24 ,aPosGet[8,3] SAY OemToAnsi(STR0028) Of oFolder:aDialogs[2] PIXEL SIZE 32 ,9 // "Estado"
	@ 23 ,aPosGet[8,4] MSGET aObj[12] VAR aInfClie[6]  Picture PesqPict('SA1','A1_EST');
		When .F. OF oFolder:aDialogs[2] PIXEL SIZE 21 ,9

	@42 ,aPosGet[8,5] BUTTON OemToAnsi(STR0029) SIZE 40 ,11  FONT oDlg:oFont ACTION A103ToFC030("S")  OF oFolder:aDialogs[2] PIXEL // "Mais Inf."

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Frete/Despesas/Descontos							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oFolder:aDialogs[3]:oFont := oDlg:oFont
	
	If cPaisLoc <> "PTG"

		@ 9 ,aPosGet[9,1] SAY OemToAnsi(STR0030) Of oFolder:aDialogs[3] PIXEL SIZE 58 ,12 //"Valor do Desconto"
		@ 8 ,aPosGet[9,2] MSGET aObj[13] VAR a920Var[VALDESC]  Picture PesqPict('SD2','D2_DESCON') OF oFolder:aDialogs[3] PIXEL When !l920Visual  VALID A920VFold("NF_DESCONTO",a920Var[VALDESC]) SIZE 80 ,9
	
		@ 9,aPosGet[9,3] SAY OemToAnsi(STR0031) Of oFolder:aDialogs[3] PIXEL SIZE 58 ,9 //"Valor do Frete"
		@ 8,aPosGet[9,4] MSGET aObj[14] VAR a920Var[FRETE]  Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_FRETE",a920Var[FRETE]) SIZE 80,9
	
		@ 26 ,aPosGet[9,1] SAY OemToAnsi(STR0032) Of oFolder:aDialogs[3] PIXEL SIZE 42 ,9 // "Despesas"
		@ 25 ,aPosGet[9,2] MSGET aObj[15] VAR a920Var[VALDESP] Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_DESPESA",a920Var[VALDESP]) SIZE 80,9
	
		@ 26 ,aPosGet[9,3] SAY OemToAnsi(STR0033) Of oFolder:aDialogs[3] PIXEL SIZE 35 ,9 // "Seguro"
		@ 25 ,aPosGet[9,4] MSGET aObj[16] VAR a920Var[SEGURO]  Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_SEGURO",a920Var[SEGURO]) SIZE 80,9
	
		@ 38 ,05  TO 40 ,aPosGet[10,1] LABEL '' OF oFolder:aDialogs[3] PIXEL
	
		@ 48 ,aPosGet[10,2] SAY OemToAnsi(STR0034) Of oFolder:aDialogs[3] PIXEL SIZE 90 ,9 // "Total ( Frete+Despesas)"
		@ 47 ,aPosGet[10,3] MSGET a920Var[TOTF3]  Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN .F. SIZE 80,9
	Else
		@ 9 ,aPosGet[9,1] SAY OemToAnsi(STR0030) Of oFolder:aDialogs[3] PIXEL SIZE 58 ,12 //"Valor do Desconto"
		@ 8 ,aPosGet[9,2] MSGET aObj[13] VAR a920Var[VALDESC]  Picture PesqPict('SD2','D2_DESCON') OF oFolder:aDialogs[3] PIXEL When !l920Visual  VALID A920VFold("NF_DESCONTO",a920Var[VALDESC]) SIZE 80 ,9
	
		@ 9, aPosGet[9,3] SAY OemToAnsi(STR0031) Of oFolder:aDialogs[3] PIXEL SIZE 58 ,9 //"Valor do Frete"
		@ 8, aPosGet[9,4] MSGET aObj[14] VAR a920Var[FRETE]  Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_FRETE",a920Var[FRETE]) SIZE 80,9
	
		@ 9 ,aPosGet[9,5] SAY OemToAnsi(STR0033) Of oFolder:aDialogs[3] PIXEL SIZE 35 ,9 // "Seguro"
		@ 8 ,aPosGet[9,6] MSGET aObj[16] VAR a920Var[SEGURO]  Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_SEGURO",a920Var[SEGURO]) SIZE 80,9

		@ 26 ,aPosGet[9,1] SAY OemToAnsi(STR0032) Of oFolder:aDialogs[3] PIXEL SIZE 42 ,9 // "Despesas"
		@ 25 ,aPosGet[9,2] MSGET aObj[15] VAR a920Var[VALDESP] Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_DESPESA",a920Var[VALDESP]) SIZE 80,9

		@ 26, aPosGet[9,3] SAY OemToAnsi(STR0086) Of oFolder:aDialogs[3] PIXEL SIZE 58 ,9 //"Desp. não Trib."
		@ 25, aPosGet[9,4] MSGET aObj[21] VAR a920Var[NTRIB]  Picture PesqPict('SC7','C7_DESNTRB') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_DESNTRB",a920Var[NTRIB]) SIZE 80,9

		@ 26, aPosGet[9,5] SAY OemToAnsi(STR0087) Of oFolder:aDialogs[3] PIXEL SIZE 35 ,9 //"Tara"
		@ 25, aPosGet[9,6] MSGET aObj[22] VAR a920Var[TARA]  Picture PesqPict('SC7','C7_TARA') OF oFolder:aDialogs[3] PIXEL WHEN !l920Visual VALID A920VFold("NF_TARA",a920Var[TARA]) SIZE 80,9
	
		@ 38 ,05  TO 38 ,aPosGet[9,7] LABEL '' OF oFolder:aDialogs[3] PIXEL
	
		@ 48 ,aPosGet[9,5] SAY OemToAnsi(STR0034) Of oFolder:aDialogs[3] PIXEL SIZE 90 ,9 // "Total ( Frete+Despesas)"
		@ 47 ,aPosGet[9,6] MSGET a920Var[TOTF3]  Picture PesqPict('SC7','C7_FRETE') OF oFolder:aDialogs[3] PIXEL WHEN .F. SIZE 80,9
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impostos	   		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFolder:aDialogs[4]:oFont := oDlg:oFont

	aObj[17] := MaFisRodape(1,oFolder:aDialogs[4],,{5,3, ( aPosObj[3,4]-aPosObj[3,2]-9 ),53},bListRefresh,l920Visual)

	oFolder:aDialogs[5]:oFont := oDlg:oFont

	aObj[18] := MaFisBrwLivro(oFolder:aDialogs[5],{5,3,( aPosObj[3,4]-aPosObj[3,2]-9 ),53},.T.,aRecSF3,l920Visual)

	If !Empty(aRecSE1) .Or. !Empty(aRecSE2)
		oFolder:aDialogs[6]:oFont := oDlg:oFont
		aAdd(aObj,Nil)            
		aObj[19] := A920Financ(SF2->F2_COND,oFolder:aDialogs[6],aRecSE1,aRecSE2,( aPosObj[3,4]-aPosObj[3,2] - 95 ) )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nota Fiscal Eletronica³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lLote
	
		If cPaisLoc == "BRA"
			// Objeto Get, de acordo com a exibicao ou nao do folder financeiro
			aAdd(aObj,Nil)            	
			nObj := Len(aObj)

			oFolder:aDialogs[nNFe]:oFont := oDlg:oFont
			
			@ 9 ,aPosGet[9,1] SAY OemToAnsi(STR0077) Of oFolder:aDialogs[nNFe] PIXEL SIZE 48 ,12 //"Número"
			@ 8 ,aPosGet[9,2] MSGET aObj[nObj] VAR aNFEletr[01];
			Picture PesqPict('SF2','F2_NFELETR');
			OF oFolder:aDialogs[nNFe] PIXEL;
			When VisualSX3('F2_NFELETR') .And. !l920Visual;
			VALID CheckSX3("F2_NFELETR",aNFEletr[01]);
			SIZE 80 ,9
			aObj[nObj]:cSX1Hlp := "F2_NFELETR"
		
			@ 9 ,aPosGet[9,3] SAY OemToAnsi(STR0080) Of oFolder:aDialogs[nNFe] PIXEL SIZE 48 ,12 //"Cód. verificação"
			@ 8 ,aPosGet[9,4] MSGET aObj[nObj] VAR aNFEletr[02];
			Picture PesqPict('SF2','F2_CODNFE') OF;
			oFolder:aDialogs[nNFe] PIXEL;
			When VisualSX3('F2_CODNFE') .And. !l920Visual;
			VALID CheckSX3("F2_CODNFE",aNFEletr[02]);
			SIZE 80 ,9 
			aObj[nObj]:cSX1Hlp := "F2_CODNFE"
	
			@ 26 ,aPosGet[9,1] SAY OemToAnsi(STR0078) Of oFolder:aDialogs[nNFe] PIXEL SIZE 48 ,12 //"Emissão"
			@ 25 ,aPosGet[9,2] MSGET aObj[nObj] VAR aNFEletr[03];
			Picture PesqPict('SF2','F2_EMINFE');
			OF oFolder:aDialogs[nNFe] PIXEL;
			When VisualSX3('F2_EMINFE') .And. !l920Visual;
			VALID A920NFe('EMINFE',aNFEletr) .And. CheckSX3("F2_EMINFE",aNFEletr[03]);
			SIZE 80 ,9
			aObj[nObj]:cSX1Hlp := "F2_EMINFE"
	
			@ 26 ,aPosGet[9,3] SAY OemToAnsi(STR0079) Of oFolder:aDialogs[nNFe] PIXEL SIZE 48 ,12 //"Hora da emissão"
			@ 25 ,aPosGet[9,4] MSGET aObj[nObj] VAR aNFEletr[04];
			Picture PesqPict('SF2','F2_HORNFE');
			OF oFolder:aDialogs[nNFe] PIXEL;
			When VisualSX3('F2_HORNFE') .And. !l920Visual;     
			VALID CheckSX3("F2_HORNFE",aNFEletr[04]);
			SIZE 80 ,9 
			aObj[nObj]:cSX1Hlp := "F2_HORNFE"
	                                                         
			@ 43 ,aPosGet[9,1] SAY OemToAnsi(STR0081) Of oFolder:aDialogs[nNFe] PIXEL SIZE 48 ,12 //"Valor Crédito"
			@ 42 ,aPosGet[9,2] MSGET aObj[nObj] VAR aNFEletr[05];
			Picture PesqPict('SF2','F2_CREDNFE');
			OF oFolder:aDialogs[nNFe] PIXEL;
			When VisualSX3('F2_CREDNFE') .And. !l920Visual;
			VALID A920NFe('CREDNFE',aNFEletr) .And. CheckSX3("F2_CREDNFE",aNFEletr[05]);
			SIZE 80 ,9 
			aObj[nObj]:cSX1Hlp := "F2_CREDNFE"  
			
			If AliasIndic("CDA") .And. nLancAp>0
				oFolder:aDialogs[nLancAp]:oFont := oDlg:oFont
				oLancApICMS := a920LAICMS(oFolder:aDialogs[nLancAp],{5,4,( aPosObj[3,4]-aPosObj[3,2] )-10,53},@aHeadCDA,@aColsCDA,l920Visual,l920Inclui)
			EndIf
	
            //Informacoes DANFE	 
			// Objeto Get, de acordo com a exibicao ou nao do folder financeiro
			aAdd(aObj1,Nil)            	
			nObjD := Len(aObj1)

			oFolder:aDialogs[nDANFE]:oFont := oDlg:oFont
			              
			If SF2->(FieldPos("F2_CHVNFE")) > 0
				@ 9 ,aPosGet[9,1] SAY OemToAnsi(STR0095) Of oFolder:aDialogs[nDANFE] PIXEL SIZE 48 ,12 //"Chave NFE"
				@ 8 ,aPosGet[9,2] MSGET aObj1[nObjD] VAR aDANFE[01];
				Picture PesqPict('SF2','F2_CHVNFE');
				OF oFolder:aDialogs[nDANFE] PIXEL;
				When VisualSX3('F2_CHVNFE') .And. !l920Visual;
				VALID CheckSX3("F2_CHVNFE",aDANFE[01]);
				SIZE 150 ,9
				aObj1[nObjD]:cSX1Hlp := "F2_CHVNFE"

            EndIf
		
		Endif
	Endif

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||If(oGetDados:TudoOk().And.a920LOk(),(nOpc:=1,oDlg:End()),nOpc:=0)},{||oDlg:End()},, xButton )
Else

	nOpc := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente se for inclusao executa as validacoes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l920Inclui
		aValidGet := {}
		aInfCliAut:= aClone(aInfClie)
		cTipo     := aAutoCab[ProcH("F2_TIPO"),2]
		a920VarAut:= aClone(a920Var)
		aNFeAut	  := aClone(aNFEletr)
		aDANAut	  := aClone(aDANFE)                             
		
		Aadd(aValidGet,{"c920Tipo"  ,aAutoCab[ProcH("F2_TIPO"),2]   ,"A920Tipo(cTipo,,,,@c920Client,@c920Loja,)",.t.})
		Aadd(aValidGet,{"c920Nota"  ,aAutoCab[ProcH("F2_DOC") ,2]   ,"A920Client(c920Client,c920Loja,@aInfCliAut,cTipo,.T.)" ,.f.})
		Aadd(aValidGet,{"c920Serie" ,aAutoCab[ProcH("F2_SERIE"),2]  ,"A920Client(c920Client,c920Loja,@aInfCliAut,cTipo,.T.) .And. A920NOTA(c920Nota,c920Serie)",.t.})
		Aadd(aValidGet,{"d920Emis"  ,aAutoCab[ProcH("F2_EMISSAO"),2],"A920Emissao(d920Emis) .And. CheckSX3('F2_EMISSAO')",.t.})
		Aadd(aValidGet,{"c920Client",aAutoCab[ProcH("F2_CLIENTE"),2],"A920Client(c920Client,c920Loja,@aInfCliAut,cTipo,.T.).And.CheckSX3('F2_CLIENTE',c920Client) .And.A920VFold('NF_CODCLIFOR',c920Client)",.t.})
		Aadd(aValidGet,{"c920Loja"  ,aAutoCab[ProcH("F2_LOJA"),2]   ,"CheckSX3('F2_LOJA',c920Loja).and. A920Client(c920Client,c920Loja,@aInfCliAut,cTipo,.T.)	.And.A920VFold('NF_LOJA',c920Loja)",.t.})
		Aadd(aValidGet,{"c920Especi",aAutoCab[ProcH("F2_ESPECIE"),2],"CheckSX3('F2_ESPECIE',c920Especi)",.f.}) 	 	
		
		If cPaisLoc == "PTG"		
			Aadd(aValidGet,{"c920DecExp",aAutoCab[ProcH("F2_DECLEXP"),2],"CheckSX3('F2_DECLEXP',c920DecExp)",.f.}) 	 	
		Endif

		If ! SF2->(MsVldGAuto(aValidGet)) // consiste os gets
			nOpc:= 0
		EndIf
		If !MaFisFound("NF")
			MaFisIni(c920Client,c920Loja,IIf(cTipo$'DB',"F","C"),cTipo, IIf(cTipo$'DB', Nil ,SA1->A1_TIPO ) , MaFisRelImp("MT100",{"SF2","SD2"}),,.T.)
		EndIf		
		aInfClie := aClone(aInfCliAut)
		a920Var  := aClone(a920VarAut)		
		If !MsGetDAuto(aAutoItens,"A920LinOk",{|| A920TudOk()},aAutoCab,aRotina[nOpcx][4])
			nOpc := 0
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida os Folders³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aValidGet := {}
		Aadd(aValidGet,{"a920VarAut["+str(VALDESC)+"]"  ,aAutoCab[ProcH("F2_DESCONT"),2] ,"A920VFold('NF_DESCONTO',a920VarAut["+str(VALDESC)+"])",.f.}) 
		Aadd(aValidGet,{"a920VarAut["+str(FRETE  )+"]"  ,aAutoCab[ProcH("F2_FRETE"  ),2] ,"A920VFold('NF_FRETE',a920VarAut["+str(FRETE)+"])",.f.}) 	 	
		Aadd(aValidGet,{"a920VarAut["+str(VALDESP)+"]"  ,aAutoCab[ProcH("F2_DESPESA"),2] ,"A920VFold('NF_DESPESA',a920VarAut["+str(VALDESP)+"])",.f.}) 	 	
		Aadd(aValidGet,{"a920VarAut["+str(SEGURO )+"]"  ,aAutoCab[ProcH("F2_SEGURO" ),2] ,"A920VFold('NF_SEGURO',a920VarAut["+str(SEGURO)+"])",.f.}) 	 	
		If cPaisLoc == "PTG"
			Aadd(aValidGet,{"a920VarAut["+str(NTRIB)+"]"  ,aAutoCab[ProcH("F2_NTRIB" ),2] ,"A920VFold('NF_NTRIB',a920VarAut["+str(NTRIB)+"])",.f.}) 	 	
			Aadd(aValidGet,{"a920VarAut["+str(TARA)+"]"  ,aAutoCab[ProcH("F2_TARA" ),2] ,"A920VFold('NF_TARA',a920VarAut["+str(TARA)+"])",.f.}) 	 				
		Endif
		If cPaisLoc == "BRA"
			If ProcH("F2_NFELETR") > 0
				Aadd(aValidGet,{"aNFeAut[01]",aAutoCab[ProcH("F2_NFELETR"),2],"CheckSX3('F2_NFELETR',aNFeAut[01])",.f.}) 	 	
				aNFEletr[01] := aAutoCab[ProcH("F2_NFELETR"),2]
			Endif
			If ProcH("F2_CODNFE") > 0
				Aadd(aValidGet,{"aNFeAut[02]",aAutoCab[ProcH("F2_CODNFE"),2],"CheckSX3('F2_CODNFE',aNFeAut[02])",.f.}) 	 	
				aNFEletr[02] := aAutoCab[ProcH("F2_CODNFE"),2]
			Endif
			If ProcH("F2_EMINFE") > 0
				Aadd(aValidGet,{"aNFeAut[03]",aAutoCab[ProcH("F2_EMINFE"),2],"A920NFe('EMINFE',aNFeAut) .And. CheckSX3('F2_EMINFE',aNFeAut[03])",.f.}) 	 	
				aNFEletr[03] := aAutoCab[ProcH("F2_EMINFE"),2]
			Endif
			If ProcH("F2_HORNFE") > 0
				Aadd(aValidGet,{"aNFeAut[04]",aAutoCab[ProcH("F2_HORNFE"),2],"CheckSX3('F2_HORNFE',aNFeAut[04])",.f.}) 	 	
				aNFEletr[04] := aAutoCab[ProcH("F2_HORNFE"),2]
			Endif
			If ProcH("F2_CREDNFE") > 0
				Aadd(aValidGet,{"aNFeAut[05]",aAutoCab[ProcH("F2_CREDNFE"),2],"A920NFe('CREDNFE',aNFeAut) .And. CheckSX3('F2_CREDNFE',aNFeAut[05])",.f.}) 	 	
				aNFEletr[05] := aAutoCab[ProcH("F2_CREDNFE"),2]
			Endif  

			If ProcH("F2_CHVNFE") > 0
				Aadd(aValidGet,{"aDANAut[01]",aAutoCab[ProcH("F2_CHVNFE"),2],"CheckSX3('F2_CHVNFE',aDANAut[01])",.f.}) 	 	
				aDANFE[01] := aAutoCab[ProcH("F2_CHVNFE"),2]
			Endif

		Endif
		If ! SF2->(MsVldGAuto(aValidGet)) // consiste os gets
			nOpc:= 0
		EndIf		
		a920Var  := aClone(a920VarAut)		
	EndIf
EndIf

If nOpc == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada na Exclusao.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l920Deleta .And. ExistBlock("MTA920E")
		ExecBlock("MTA920E",.f.,.f.)
	Endif
	
	If l920Deleta .And. ExistBlock("MT920TOK")
		l920Deleta := ExecBlock("MT920TOK",.f.,.f.)
	Endif
	
	Begin Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua a gravacao da Nota Fiscal (Inclusao/Alteracao/Exclusao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l920Inclui .Or. l920Altera .Or. l920Deleta
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa a gravacao atraves das funcoes MATXFIS         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisWrite()
			If Type("l920Auto") != "L" .or. !l920Auto
				Processa({||A920Grava(l920Deleta,aNFEletr,aDANFE)},cCadastro)
			Else
				A920Grava(l920Deleta,aNFEletr,aDANFE)
			EndIf
			a103GrvCDA(l920Deleta,"S",c920Especi,"S",c920Nota,c920Serie,c920Client,c920Loja)
            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//Atualiza dados dos complementos SPED automaticamente
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			If lMvAtuComp .And. l920Inclui
				AtuComp(c920Nota,c920Serie,c920Especi,c920Client,c920Loja,"S",cTipo)
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa os gatilhos                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			EvalTrigger()

		EndIf
	End Transaction
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Destrava os registros na altEracao e exclusao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnlockAll()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o uso das funcoes MATXFIS                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MaFisEnd()
RestArea(aAreaSE1)
RestArea(aArea)
Return nOpc
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920FRefre³ Autor ³ Andreia dos Santos    ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa o refresh nos objetos do array.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Array contendo os Objetos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatA920                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920FRefresh(aObj)
Local nx
If Type("l920Auto") !="L" .or. !l920Auto
	For nx := 1 to Len(aObj)
		aObj[nx]:Refresh()
	Next
EndIf
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920Refresh³ Autor ³ Andreia dos Santos   ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa o Refresh do Folder.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Objeto a ser verificado.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatA920                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Refresh(a920Var,l920Inclui) 
Local aArea		:= GetArea()			// Guarda a area do SF2
Local aAreaSD2	:= SD2->(GetArea())	// Guarda a area do SD2
Local aAreaSF4	:= SF4->(GetArea())
Local lLoja		:= .F.					// Indica se a nota fiscal foi gerada no sigaloja
Local cChaveSD2	:= ""					// Chave de localizacao do SD2
Local lAgregSol := .F.					// Agrega Solidario ao Total da Nota

SD2->(DbSetOrder(3))
If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a nota/cupom fiscal foi gerado no Sigaloja ou pelo Venda Direta do Faturamento  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(SD2->D2_ORIGLAN) == "LO" .Or. AllTrim(SD2->D2_ORIGLAN) == "VD"
		lLoja := .T.
		DbSelectArea("SF4")
		DbSetOrder(1)
		DbSeek(xFilial("SF4")+SD2->D2_TES)
		lAgregSol := (SF4->F4_INCSOL == 'S')
	EndIf
EndIf

If lLoja   
	// O LOJA grava o valor do acrescimo separado do valor da mercadoria
	// Deve-se somar o acrescimo para a correta exebicao dos totais
	a920Var[VALMERCB]	:= MaFisRet(,"NF_VALMERC") + SF2->F2_VALACRS								// Valor da Mercadoria (Bruto)
	cChaveSD2 			:= xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	a920Var[VALDESC]	:= MaFisRet(,"NF_DESCONTO")						// Descontos
	//Incluído o valor do ICMS Solidário, ao Valor Total da Nota
	a920Var[TOTPED]		:= MaFisRet(,"NF_VALMERC") - a920Var[VALDESC] + SF2->F2_VALACRS	// Total da Nota
	If lAgregSol
   		a920Var[TOTPED] += MaFisRet(,"NF_VALSOL")	// Total da Nota
 	EndIf
	a920Var[VALMERC]	:= MaFisRet(,"NF_VALMERC") - a920Var[VALDESC] + SF2->F2_VALACRS 				// Valor da Mercadoria (Liquido)
Else
	a920Var[VALMERCB]	:= MaFisRet(,"NF_VALMERC") + Iif(l920Inclui,0,MaFisRet(,"NF_DESCONTO"))					// Valor da Mercadoria (Bruto)
	a920Var[VALDESC]	:= MaFisRet(,"NF_DESCONTO") 								// Descontos
	a920Var[TOTPED]		:= MaFisRet(,"NF_TOTAL") 									// Total da Nota
	a920Var[VALMERC]	:= MaFisRet(,"NF_VALMERC") - Iif(l920Inclui,MaFisRet(,"NF_DESCONTO"),0)		// Valor da Mercadoria (Liquido)
EndIf

a920Var[FRETE]		:= MaFisRet(,"NF_FRETE")
a920Var[SEGURO]		:= MaFisRet(,"NF_SEGURO")
a920Var[VALDESP]	:= MaFisRet(,"NF_DESPESA")

If cPaisLoc == "PTG"                          
	a920Var[NTRIB] 		:= MaFisRet(,"NF_DESNTRB")
	a920Var[TARA]		:= MaFisRet(,"NF_TARA")
Endif

a920Var[TOTF1]		:= a920Var[VALDESP]	+ a920Var[SEGURO] + Iif(cPaisLoc=="PTG",a920Var[NTRIB] + a920Var[TARA],0)
a920Var[TOTF3]		:= a920Var[FRETE] + a920Var[SEGURO] + a920Var[VALDESP] + Iif(cPaisLoc=="PTG",a920Var[NTRIB] + a920Var[TARA],0)

RestArea(aAreaSF4)
RestArea(aAreaSD2)
RestArea(aArea)

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920CabOk ³ Autor ³ Andreia dos Santos    ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa  as validacoes dos Gets.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Objeto a ser verificado.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatA920                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920CabOk(oTipo,oNota,oEmis,oClie,oLoja)
Local lRet 	:= .F.

Do Case
Case Empty(cTipo)
	oTipo:SetFocus()
Case Empty(c920Nota)
	oNota:SetFocus()
Case Empty(d920Emis)
	oEmis:SetFocus()
Case Empty(c920Client)
	oClie:SetFocus()
Case Empty(c920Loja)
	oLoja:SetFocus()
OtherWise
	If !MaFisFound("NF")
		MaFisIni(c920Client,c920Loja,If(cTipo$'DB',"F","C"),cTipo,IIf(cTipo$'DB', Nil ,SA1->A1_TIPO ),MaFisRelImp("MT100",{"SF2","SD2"}),,.T.,,,,,,,,,,,,,,,,,d920Emis)
	Else
		MaFisAlt("NF_DTEMISS",d920Emis)
	EndIf
	lRet := .T.
EndCase

Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920VFold ³ Autor ³ Andreia dos Santos    ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exucuta o calculo de valores para campos Totalizadores.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Referencia ( vide MATXFIS)                         ³±±
±±³          ³ ExpC2 = Valor da Referencia                                ³±±
±±³          ³ ExpL3 = .T./.F.- Executa o Refresh do folder               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Campos Totalizadores do MATA920                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920VFold(cReferencia,xValor,lRefre)
Local aArea	:= GetArea()

If lRefre==Nil
	lRefre := .T.
EndIf

If MaFisFound("NF").And.!(MaFisRet(,cReferencia)==xValor)
	MaFisAlt(cReferencia,xValor)
	a920FisToaCols()
	If lRefre
		Eval(bRefresh)
		Eval(bGDRefresh)
	EndIf
EndIf

RestArea(aArea)
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920FieldOk ³Autor³ Andreia dos Santos    ³ Data ³02.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validade de campo da GateDados.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA920                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920FieldOk()
Eval(bRefresh)
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A920Del  ³ Autor ³ Andreia dos Santos    ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica a delecao da linha                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Objeto a ser verificado.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatA920                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Del(o)
Local nPosItD2	:= 	aScan(aHeader,{|aX| aX[2]==PadR("D2_ITEM",Len(SX3->X3_CAMPO))})
Local nI		:=	0
Local nPosCalc	:=	0
Local nPosIt	:=	0

MaFisDel(n,aCols[n][Len(aCols[n])])
Eval(bRefresh)

If Type("oLancApICMS")<>"U" .And. oLancApICMS<>Nil .And. nPosItD2>0
	nPosCalc:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_CALPRO"})
	nPosIt	:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_NUMITE"})
	For nI := 1 To Len(oLancApICMS:aCols)
		If aCols[n,nPosItD2]==AllTrim(oLancApICMS:aCols[nI,nPosIt])
			oLancApICMS:aCols[nI,Len(oLancApICMS:aCols[nI])]	:=	aCols[n,Len(aCols[n])]
		EndIf
	Next nI
	oLancApICMS:Refresh()
EndIf

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920LinOk³Autor³ Andreia dos Santos       ³ Data ³02.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validade da linha da GatDados.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA920                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920LinOk()
Local lRet 		:= .T.
Local nPosCod	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_COD" })
Local nPosQuant:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_QUANT"})
Local nPosUnit	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_PRCVEN"})
Local nPosTotal:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_TOTAL"})
Local nPosTES	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_TES"})
Local nPosCF	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_CF"})
Local nPosOri	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_NFORI"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a linha nao esta em branco e os itens nao Deletados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CheckCols(n,aCols) .And. !aCols[n][Len(aHeader)+1]
	Do Case
	Case 	Empty(aCols[n][nPosCod]) 	.Or. ;
			(	Empty(aCols[n][nPosQuant]).And.cTipo$"NDB").Or. ;
			Empty(aCols[n][nPosUnit]) .Or. ;
			Empty(aCols[n][nPosTotal]).Or. ;
			Empty(aCols[n][nPosCF]) 	.Or. ;
			Empty(aCols[n][nPosTES])
		Help("  ",1,"A100VZ")			 	
		lRet := .F.
	Case cTipo $"CPI" .And. Empty(aCols[n][nPosOri])
		HELP(" ",1,"A910COMPIP")
		lRet := .F.
	Case cTipo=="D" .And.Empty(aCols[n][nPosOri])
		HELP(" ",1,"A910NFORI")
		lRet := .F.
	Case cTipo$'NDB' .And. (aCols[n][nPosTotal]>(aCols[n][nPosUnit]*aCols[n][nPosQuant]+0.09);
			.Or. aCols[n][nPosTotal]<(aCols[n][nPosUnit]*aCols[n][nPosQuant]-0.09))
		Help("  ",1,'A12003')
		lRet := .F.
	EndCase
ElseIf !CheckCols(n,aCols)		
	lRet := .F.
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pontos de Entrada 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MT920LOK"))
	lRet := ExecBlock("MT920LOK",.F.,.F.,{lRet})
EndIf
            

Return lRet 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920TudOk³Autor³ Andreia dos Santos       ³ Data ³02.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validade TudOk da GetDados.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA920                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Tudok()
Local lRet   := .T.
Local nItens := 0
Local nx     := 0

If Empty(c920Client) .Or. Empty(d920Emis) .Or.if(!lLote, Empty(cTipo),.F.) .Or. (Empty(c920Nota) .AND.!lLote)
	Help(" ",1,"A100FALTA")
	lRet := .F.
EndIf	          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impede a inclusao de documentos sem nenhum item ativo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to len(aCols)
	If !aCols[nx][Len(aCols[nx])]
		nItens ++
	Endif
Next

If nItens == 0
	Help("  ",1,"A100VZ")
	lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
//³             MV_SIGAGSP - 0-Nao / 1-Integra                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
If GetNewPar("MV_SIGAGSP","0") == "1"
	lRet:= GSPF030()
EndIf

If nModulo == 72
	lRet := KEXF870(lRet)
EndIf

If (ExistBlock("MT100TOK"))
	lRet := ExecBlock("MT100TOK",.F.,.F.,{lRet})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Registro esta Bloqueado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If cTipo$"DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		If MsSeek(xFilial("SA2")+c920Client+c920Loja)
			If !RegistroOk("SA2")
				lRet := .F.
			EndIf
		Endif		
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		If MsSeek(xFilial("SA1")+c920Client+c920Loja)
			If !RegistroOk("SA1")
				lRet := .F.
			EndIf
		Endif
	Endif
Endif

Return lRet
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a920FisToaCols³ Autor ³ Andreia dos Santos³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o aCols com os valores da funcao fiscal.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA920                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920FisToaCols()

Local nx
Local ny
Local cValid
Local nPosRef

For ny := 1 to Len(aCols)
	For nx	:= 1 to Len(aHeader)
		cValid	:= AllTrim(UPPER(aHeader[nx][6]))
		If "MAFISREF"$cValid
			nPosRef := 	AT('MAFISREF("',cValid) + 10
			cRefCols:=	Substr(cValid,nPosRef,AT('","MT100",',cValid)-nPosRef )
			If MaFisFound("IT",ny)
				aCols[ny][nx]:= MaFisRet(ny,cRefCols)
			EndIf
		EndIf
	Next
Next

Return .T.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a920Tipo³ Autor ³ Andreia dos Santos      ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Tipo de Nota.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA920 : Campo F2_TIPO                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Tipo(cTipo,oSClie,cSClie,oGClie,cCliente,cLoja,oLoja)
Local nPosTES	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D2_TES"})
Local nx
Local nY

If cTipo$'DB'
	If Type("l920Auto") != "L" .or. !l920Auto
		oGClie:cF3 	:= 'FOR'
	EndIf
	cSClie		:= OemToAnsi(STR0035) //Fornecedor
	If MaFisFound("NF").And.MaFisRet(,"NF_TIPONF") != cTipo
		cCliente		:= CriaVar("F2_CLIENTE")
		cLoja			:= CriaVar("F2_LOJA")
	EndIf
Else
	If Type("l920Auto") != "L" .or. !l920Auto
		oGClie:cF3 	:= 'SA1'
	EndIf
	cSClie		:= OemToAnsi(STR0011)     //Cliente
	If MaFisFound("NF").And.MaFisRet(,"NF_TIPONF") != cTipo
		cCliente		:= CriaVar("F2_CLIENTE")
		cLoja			:= CriaVar("F2_LOJA")
	EndIf
EndIf

If MaFisFound("NF") .And. cTipo!= MafisRet(,"NF_TIPONF")
	aCols			:= {}
	aADD(aCols,Array(Len(aHeader)+1))
	For ny := 1 to Len(aHeader)
		If Trim(aHeader[ny][2]) == "D1_ITEM"
			aCols[1][ny] 	:= "01"
		ElseIf ( aHeader[ny][10] != "V")
			aCols[1][ny] := CriaVar(aHeader[ny][2])
		EndIf
		aCols[1][Len(aHeader)+1] := .F.
	Next ny
	MaFisAlt("NF_CLIFOR",If(cTipo$"DB","F","C"))
	MaFisAlt("NF_TIPONF",cTipo)
	MaFisClear()
	If oSClie <> Nil
		oSClie:Refresh()
	EndIf
	If oGClie <> Nil
		oGClie:Refresh()
	EndIf
	If oLoja <> Nil
		oLoja:Refresh()
	EndIf
	Eval(bGDRefresh)
	Eval(bRefresh)
EndIf


Return .T.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a920Nota³ Autor ³ Andreia dos Santos      ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida o Numero da Nota Fiscal Digitado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA920 : Campo F2_DOC                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Nota(cNota,cSerie)
Local lRet := .T.

If Empty(cNota)
	lRet	:= .F.
	HELP("  ",1,"F2_DOC")
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste duplicidade de digitacao de Nota Fiscal           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF2->( MsSeek(xFilial()+cNota+cSerie) )
		lRet := .F.
		HELP(" ",1,"A920EXIST")
	Endif

EndIf

Return lRet
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a920Emissao³ Autor ³ Andreia dos Santos   ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Tipo de Nota.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA920 : Campo F2_EMISSAO                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Emissao(dEmissao)
Local lRet	:= .T.

If dEmissao > dDataBase
	lRet := .F.
	HELP("  ",1,"A100DATAM")
Else
	lRet := FisChkDt(dEmissao)
EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³A920ClientºAutor  ³Andreia dos Santos  º Data ³  02/02/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega os dados do Fornecedor/Cliente                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mata920 Campo: Cliente   		                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A920Client(cCliente,cLoja,aInfClie,cTipo,l920Inclui)
Local lRet   := .T.
Local cAlias := ""

IF !Empty(cCliente)
    cAlias := "SF2"
	If cTipo$"DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		IF !Empty(cLoja)
			lRet := SA2->(MsSeek(xFilial("SA2")+cCliente+cLoja))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o array que contem os dados do Fornecedor      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				aInfClie[1]	:= SA2->A2_NOME						// Nome
				aInfClie[2]	:= SA2->A2_TEL 						// Telefone
				aInfClie[3]	:= SA2->A2_PRICOM	    				//Primeira Compra do Cliente
				aInfClie[4]	:= SA2->A2_ULTCOM      				//Ultima Compra do Cliente
				aInfClie[5]	:= SA2->A2_END+" - "+SA2->A2_MUN		//Endereco
				aInfClie[6]	:= SA2->A2_EST         				//Estado			
			EndIf
		Else
			lRet 	:= SA2->(MsSeek(xFilial("SA2")+cCliente))
			If lRet
				c920Loja := SA2->A2_LOJA
			Endif				
		EndIf
	Else
        cAlias := "SF1"
		dbSelectArea("SA1")
		dbSetOrder(1)
		IF !Empty(cLoja)
			lRet := SA1->(MsSeek(xFilial("SA1")+cCliente+cLoja))
			If lRet
				aInfClie[1]	:= SA1->A1_NOME						// Nome
				aInfClie[2]	:= SA1->A1_TEL 						// Telefone
				aInfClie[3]	:= SA1->A1_PRICOM	    				//Primeira Compra
				aInfClie[4]	:= SA1->A1_ULTCOM      				//Ultima Compra
//				If Empty(SA1->A1_ENDCOB)
					aInfClie[5]	:= SA1->A1_END+" - "+SA1->A1_MUN //Endereco
					aInfClie[6]	:= SA1->A1_EST         			  //Estado
//				Else
//					aInfClie[5]	:= SA1->A1_ENDCOB+" - "+SA1->A1_MUNC //Endereco de Cobranca
//					aInfClie[6]	:= SA1->A1_ESTC        				  //Estado de Cobranca
//				EndIf
			EndIf
		Else			
			lRet := SA1->(MsSeek(xFilial("SA1")+cCliente))
			If lRet
				c920Loja := SA1->A1_LOJA
			Endif				
		Endif
	EndIf
    
    //PE para verificar se a NF foi cancelada
    if l920Inclui
       if ExistBlock("MTVALNF") 
          if !ExecBlock("MTVALNF",.F.,.F.,{cAlias,xFilial(cAlias),c920Nota,c920Serie,cCliente,c920Loja})
             lRet := .F.
          endif   
       endif
    endif
   
EndIF

Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a920Grava ³ Autor ³ Andreia dos Santos       ³ Data ³02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava a Nota Fiscal                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mata920                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A920Grava(lDeleta,aNFEletr,aDANFE)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definine variaveis                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nx
LOCAL ny
LOCAL nMaxArray
LOCAL cLocal
LOCAL nVlrTotal:= 0
LOCAL nUPRC 	:= 0
LOCAL aLivro
LOCAL aFixos  
LOCAL nDedICMS  := 0

Default aNfEletr := {}
Default aDANFE   := {}                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no fornecedor escolhido                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo$"DB"
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial()+c920Client+c920Loja)
Else
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial()+c920Client+c920Loja)
EndIf

If Type("l920Auto") != "L" .or. !l920Auto
	ProcRegua(Len(aCols)+1)
EndIf

If !lDeleta
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza dados padroes do cabecalho da NF de entrada.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(1)
	RecLock("SF2",.T.)
	SF2->F2_TIPO		:= if(lLote,"L",cTipo)
	SF2->F2_DOC			:= if(lLote,c920NfIni,c920Nota)
	SF2->F2_SERIE		:= c920Serie
	SF2->F2_EMISSAO	:= d920Emis
	SF2->F2_LOJA   	:= c920Loja
	SF2->F2_CLIENTE	:= c920Client
	SF2->F2_EST    	:= IIF(cTipo$"DB",SA2->A2_EST,SA1->A1_EST)
	SF2->F2_DESCONT	:= MaFisRet(,"NF_DESCONTO")
	SF2->F2_VALMERC	:= MaFisRet(,"NF_VALMERC")-MaFisRet(,"NF_DESCONTO")
	SF2->F2_VALICM 	:= MaFisRet(,"NF_VALICM")
	SF2->F2_VALIPI 	:= MaFisRet(,"NF_VALIPI")
	SF2->F2_VALBRUT	:= MaFisRet(,"NF_TOTAL")
	SF2->F2_FRETE  	:= MaFisRet(,"NF_FRETE")
	SF2->F2_BASEIPI	:= MaFisRet(,"NF_BASEIPI")
	SF2->F2_BASEICM	:= MaFisRet(,"NF_BASEICM")
	SF2->F2_DESPESA	:= MaFisRet(,"NF_DESPESA")
	SF2->F2_FILIAL 	:= xFilial("SF2")
	SF2->F2_BRICMS 	:= MaFisRet(,"NF_BASESOL")
	SF2->F2_ICMSRET	:= MaFisRet(,"NF_VALSOL")
	SF2->F2_ESPECIE	:= c920Especi
	SF2->F2_NFORI		:= if(lLote, c920NFFim,"")
	SF2->F2_LOTE		:= if(lLote,"S","")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nota Fiscal Eletronica³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc == "BRA"
		SF2->F2_NFELETR	:= aNFEletr[01] 
		SF2->F2_CODNFE	:= aNFEletr[02]      
		SF2->F2_EMINFE	:= aNFEletr[03] 
		SF2->F2_HORNFE 	:= aNFEletr[04] 
		SF2->F2_CREDNFE	:= aNFEletr[05] 
		SF2->F2_CHVNFE  := aDANFE[01]
	Endif

	If cPaisLoc == "PTG"                      
		SF2->F2_DECLEXP := c920DecExp
		SF2->F2_DESNTRB	:= MaFisRet(,"NF_DESNTRB")
		SF2->F2_TARA	:= MaFisRet(,"NF_TARA")
	Endif                                    
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para atualizar o cabecalho da NF        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If ExistBlock("MTA920C")
		ExecBlock("MTA920C",.f.,.f.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a gravacao dos campos referentes ao imposto   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisWrite(2,"SF2",Nil)

	SF2->(FKCommit())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza dados padroes dos itens da NF de entrada.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(1)
	If Type("l920Auto") != "L" .or. !l920Auto
		IncProc()
	EndIf
	For nx := 1 to Len(aCols)
		If !aCols[nx][Len(aCols[nx])]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza dados do corpo da nota selecionados pelo cliente   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SD2",.T.)
			For ny := 1 to Len(aHeader)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ verifica se e' o codigo para dar seek no SB1 e pegar grupo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Trim(aHeader[ny][2]) == "D2_COD"
					SB1->(dbSetOrder(1))
					SB1->(MsSeek(xFilial()+aCols[nx][ny]))
					SD2->D2_GRUPO 	:= SB1->B1_GRUPO
					SD2->D2_TP 	  	:= SB1->B1_TIPO
				Endif
				If aHeader[ny][10] # "V"
					Var := Trim(aHeader[ny][2])
					Replace &Var. With aCols[nx][ny]
				Endif
			Next ny
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza dados padroes do corpo da nota fiscal de entrada    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SD2->D2_LOJA		:= c920Loja
			SD2->D2_CLIENTE	:= c920Client
			SD2->D2_DOC    	:= if(lLote,c920NFIni,c920Nota)
			SD2->D2_EMISSAO	:= d920Emis
			SD2->D2_SERIE  	:= c920Serie
			SD2->D2_TIPO   	:= cTipo
			SD2->D2_FILIAL 	:= xFilial("SD2")
			SD2->D2_NUMSEQ 	:= ProxNum()
			SD2->D2_VALIPI 	:= MaFisRet(nx,"IT_VALIPI")
			SD2->D2_VALICM 	:= MaFisRet(nx,"IT_VALICM")
			SD2->D2_PICM 		:= MaFisRet(nx,"IT_ALIQICM")
			SD2->D2_ORIGLAN	:= "LF"
			SD2->D2_EST			:= SF2->F2_EST
			If SD2->(FieldPos("D2_DESCZFR"))>0
				SD2->D2_DESCZFR		:= MaFisRet(nX,"IT_DESCZF")
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada para atualizar os itens da NF           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MT920IT")
				ExecBlock("MT920IT",.f.,.f.)
			ENDIF		

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetua a gravacao dos campos referentes ao imposto   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisWrite(2,"SD2",nx)
			If !(cTipo$"CPI")
				SD2->D2_TOTAL 		:= SD2->D2_TOTAL - SD2->D2_DESCON
  				
				If GetNewPar ("MV_ARREFAT", "XXX")<>"XXX" .And. ( SuperGetMv("MV_ARREFAT") == "S" )
					SD2->D2_PRCVEN		:= Round(((SD2->D2_PRCVEN*SD2->D2_QUANT)/SD2->D2_QUANT)-(SD2->D2_DESCON/SD2->D2_QUANT),TamSX3("D2_PRCVEN")[2])
				Else
   					SD2->D2_PRCVEN		:= NoRound(((SD2->D2_PRCVEN*SD2->D2_QUANT)/SD2->D2_QUANT)-(SD2->D2_DESCON/SD2->D2_QUANT),TamSX3("D2_PRCVEN")[2])
				EndIf

			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconta o Valor do ICMS DESONERADO do valor do Item D2_PRCVEN         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SF4->(dbSetOrder(1))
		SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES))
		If SF4->F4_AGREG$"R"
			nDedICMS += MaFisRet(nX,"IT_DEDICM")
			SD2->D2_TOTAL  -= MaFisRet(nX,"IT_DEDICM")
			SD2->D2_PRCVEN := A410Arred(SD2->D2_TOTAL/IIf(SD2->D2_QUANT==0,1,SD2->D2_QUANT),"D2_PRCVEN")
		EndIf

		If Type("l920Auto") != "L" .or. !l920Auto
			IncProc()
		EndIf

	Next nx

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desconta o Valor do ICMS DESONERADO do valor do Item D2_PRCVEN         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nDedICMS > 0
		SF2->F2_VALMERC -= nDedICMS
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava arquivo de Livros Fiscais (SF3)                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAtuSF3(1,"S",SF2->(RecNo()))

	If ExistBlock("MTA920I")
		ExecBlock("MTA920I",.F.,.F.)
	Endif

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Itens das NF's de Saida.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(3)
	MsSeek(xFilial()+c920Nota+c920Serie+c920Client+c920Loja)

	While !Eof() .And. D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == ;
			xFilial()+c920Nota+c920Serie+c920Client+c920Loja
		RecLock("SD2",.F.,.T.)
		dbDelete()
		dbSkip()
		If Type("l920Auto") != "L" .or. !l920Auto
			IncProc()
		EndIf
	End	
	SD2->(FKCommit())
	
	dbSelectArea("SF2")
	dbSetOrder(1)
	MsSeek(xFilial()+c920Nota+c920Serie+c920Client+c920Loja)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga arquivo de Livros Fiscais (SF3)                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAtuSF3(2,"S",SF2->(RecNo()))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui a amarracao com os conhecimentos                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsDocument( "SF2", SF2->( RecNo() ), 2, , 3 ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabecalho das notas de entrada.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	RecLock("SF2",.F.,.T.)
	dbDelete()

	If Type("l920Auto") != "L" .or. !l920Auto
		IncProc()
	EndIf
EndIf	

Return .T.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A920VlNfLote ³ Autor ³ Andreia dos Santos³ Data ³ 15/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a Digitacao do numero da Nota Fiscal de Lote        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA920 (Nf Lote)                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
FUNCTION A920VlNfLote(cSerie,cNtIni,cNtFim)

Local lRet		:=	.t.
Local cSavAlias:=	Alias()
Local nSavOrd	:=	IndexOrd()
Local nSavRec	:=	Recno()
Local cNFiscal	:=	''
Local nNota
Local cNotaSeek

cNfiscal	:=	IIf(Empty(cNtFim),cNtIni,cNtFim)

dbSelectArea('SF3')
dbSetOrder(5)
Set Filter to substr(F3_CFO,1,1)>='5'
MsSeek(xFilial()+cSerie+cNFiscal,.T.)

While lRet
	If xFilial()+cSerie+cNFiscal==F3_FILIAL+F3_SERIE+F3_NFISCAL .And. Empty(F3_DTCANC)
		HELP(" ",1,"A920NFLOTE")
		lRet:=.f.
		Loop
	Endif
	If F3_TIPO=='L' .and. F3_SERIE==cSerie .and. ;
			Val(F3_NFISCAL)<=Val(cNfiscal) .and. Val(F3_DOCOR)>=Val(cNfiscal)  .And. Empty(F3_DTCANC)
		HELP(" ",1,"A920NFLOTE")		
		lRet:=.f.
		Loop
	Endif
	dbSkip(-1)
	If F3_TIPO=='L' .and. F3_SERIE==cSerie .and. ;
			Val(F3_NFISCAL)<=Val(cNfiscal) .and. Val(F3_DOCOR)>=Val(cNfiscal)  .And. Empty(F3_DTCANC)
		HELP(" ",1,"A920NFLOTE")
		lRet:=.f.
		Loop
	Endif
	If !Empty(cNtFim)
		cNotaSeek:=cNFiscal
		For nNota:=Val(cNtIni) to Val(cNtFim)
			cNotaSeek:=StrTran(cNFiscal,Alltrim(Str(Val(cNFiscal))),Alltrim(Str(nNota)))
			cNotaSeek:=Padr(cNotaSeek,6)
			If MsSeek(xFilial()+cSerie+cNotaSeek,.F.)
				If Empty(F3_DTCANC)
					HELP(" ",1,"A920NFLOTE")
					lRet:=.f.
					Exit
				Endif	
			Endif
		Next
	Endif
	Exit
End

dbClearFilter()
dbSelectArea(cSavAlias)
dbSetOrder(nSavOrd)
dbGoto(nSavRec)

Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATA920   ºAutor  ³Andreia dos Santos  º Data ³  15/02/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao dos gets do cabecalho da nota fiscal em lote     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mata920                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A920CbLot(oNFIni,oNFFim,oEmis,oClie,oLoja)
Local lRet 	:= .F.

Do Case
Case Empty(c920NFIni)
	oNFIni:SetFocus()
Case Empty(c920NFFim)
	oNFFim:SetFocus()
Case Empty(d920Emis)
	oEmis:SetFocus()
Case Empty(c920Client)
	oClie:SetFocus()
Case Empty(c920Loja)
	oLoja:SetFocus()
OtherWise
	If !MaFisFound("NF")
		MaFisIni(c920Client,c920Loja,"C","N",SA1->A1_TIPO,MaFisRelImp("MT100",{"SF2","SD2"}),,.T.)
	EndIf
	lRet := .T.

EndCase

Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920Total³ Autor ³ Andreia dos Santos    ³ Data ³16.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do valor total digitado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Dicionario de Dados - Campo:D2_TOTAL                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Total(nTotal)

Local aArea		:= GetArea()
Local nQuant	:= aCols[n][aScan(aHeader,{|x|x[2] = "D2_QUANT"})]
Local nPreco	:= aCols[n][aScan(aHeader,{|x|x[2] = "D2_PRCVEN"})]
Local cTes		:= aCols[n][aScan(aHeader,{|x|x[2] = "D2_TES"})]
Local nDesc		:= aScan(aHeader,{|x| Alltrim(x[2]) = "D2_DESC"})
Local lRet 		:= .T.
Local nDif		:= NoRound(nQuant*nPreco,2)-nTotal
Local cReadVar  := ReadVar()
Local nx

If MaTesSel(cTes)	.And.	nQuant == 0
	If nPreco <> nTotal
		Help(" ",1,"A12003")
		lRet := .F.
	Endif
Else
	If nDif < 0
		nDif := -(nDif)
	EndIf
    
	If cPaisLoc=="BRA"
		If cTipo$'NDB' .And.nDif > 0.09
			Help(" ",1,"A12003")
			lRet := .F.
		EndIf
	Else
		If "D2_TOTAL"$cReadVar
			If nTotal <> a410Arred(nQuant*nPreco,"D2_TOTAL")
				Help(" ",1,"TOTAL")
				lRet := .F.
			EndIf			
		EndIf
	Endif 
Endif

If lRet .And. cPaisLoc<>"BRA"
	If nDesc>0
		aCols[n][nDesc]:=0
		MaFisAlt("IT_DESCONTO",0,n)
	Endif
Endif

RestArea(aArea)
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920Combo³Autor³ Edson Maricate           ³ Data ³06.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida o Combo Box e inicializa a variavel correspondente.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1	: Variavel a ser atualizada                          ³±±
±±³          ³ExpA2	: Array contendo as opcoes do Combo                  ³±±
±±³          ³ExpC3	: Opcao selecionada no Combo                         ³±±
±±³          ³ExpA4	: Array contendo as referencias das opcoes do combo  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A920Combo(cVariavel,aCombo,cCombo,aReferencia)

Local nPos	:= aScan(aCombo,cCombo)

If nPos > 0
	cVariavel	:= aReferencia[nPos]
EndIf


Return (nPos>0)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920IniCpo³ Autor ³ Edson Maricate        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa campos com informacoes do produto               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA920 : Validacao do Campo D2_COD                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A920IniCpo()

Local lExistCpo		:= ( SF2->(FieldPos("F2_TABELA")) > 0 )
Local aArea		:= GetArea()
Local nPosCod 		:= aScan(aHeader,{|x| Trim(x[2])=='D2_COD'} )
Local nPosUM		:= aScan(aHeader,{|x| Trim(x[2])=='D2_UM'} )
Local nPosSegUM		:= aScan(aHeader,{|x| Trim(x[2])=='D2_SEGUM'} )
Local nPosQTSegum	:= aScan(aHeader,{|x| Trim(x[2])=='D2_QTSEGUM'} )
Local nPosConta 	:= aScan(aHeader,{|x| Trim(x[2])=='D2_CONTA'} )
Local nPosDtValid	:= aScan(aHeader,{|x| Trim(x[2])=='D2_DTVALID'} )
Local nPosLocal		:= aScan(aHeader,{|x| Trim(x[2])=='D2_LOCAL'} )
Local nPosTes		:= aScan(aHeader,{|x| Trim(x[2])=='D2_TES'} )
Local nPCodISS		:= aScan(aHeader,{|x| Trim(x[2])=='D2_CODISS'} )
Local nPPrcVen		:= aScan(aHeader,{|x| Trim(x[2])=='D2_PRCVEN' } )
Local nPPrcTab		:= aScan(aHeader,{|x| Trim(x[2])=='D2_PRUNIT' } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

If MaFisFound("IT",n)
	If ( cPaisLoc <> "BRA" ) .And. ( lExistCpo ) .And. FunName() == "MATA467N" .And. ( !Empty(M->F2_TABELA) )
    	dbSelectArea("SB1")
		dbSetOrder(1)		
		MsSeek(xFilial()+aCols[n][nPosCod])
	
		aCols[n][nPosUM]		:= SB1->B1_UM
		aCols[n][nPosSegUM]		:= SB1->B1_SEGUM
		aCols[n][nPosConta]		:= SB1->B1_CONTA
		aCols[n][nPosLocal]		:= RetFldProd(SB1->B1_COD,"B1_LOCPAD")
		aCols[n][nPosQtSegum]	:= 0
		If ( nPosTes > 0 )
			aCols[n][nPosTes]	:= If(!Empty(RetFldProd(SB1->B1_COD,"B1_TS")),RetFldProd(SB1->B1_COD,"B1_TS"),aCols[n][nPosTes])
			MaFisAlt("IT_TES",aCols[n][nPosTes],n)
			Eval(bListRefresh)
		EndIf
		If Rastro(aCols[n][nPosCod]) .And. ( nPosDtValid > 0 )
			aCols[n][nPosDtValid]	:= dDataBase + SB1->B1_PRVALID
		EndIf
    	
    	dbSelectArea("DA1")
		dbSetOrder(1)
		If ( MsSeek(xFilial("DA1")+M->F2_TABELA+aCols[n][nPosCod]) )
	        If ( nPPrcVen > 0 )
				aCols[n][nPPrcVen]	:= xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,M->F2_MOEDA,dDataBase,,,M->F2_TXMOEDA)
		    Endif
		    If ( nPPrcTab > 0 )
		    	aCols[n][nPPrcTab]	:= xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,M->F2_MOEDA,dDataBase,,,M->F2_TXMOEDA)
		    Endif
		Endif
	Else
		dbSelectArea("SB1") 
		
		dbSetOrder(1)
		MsSeek(xFilial()+aCols[n][nPosCod])	
	
		aCols[n][nPosUM]	:= SB1->B1_UM
		
 		If nPosSegUM <> 0
		aCols[n][nPosSegUM]	:= SB1->B1_SEGUM
		EndIF             
		
		If nPosConta <> 0
		aCols[n][nPosConta]	:= SB1->B1_CONTA    
		EndIF           
			
		aCols[n][nPosLocal]	:= RetFldProd(SB1->B1_COD,"B1_LOCPAD")
		aCols[n][nPosQtSegum]	:= 0
		aCols[n][nPPrcTab] := SB1->B1_PRV1
		If nPCodISS <> 0
			aCols[n][nPCodISS] :=  MaSBCampo("CODISS") 
			MaFisAlt("IT_CODISS", MaSBCampo("CODISS"),N)
		EndIf
		a100SegUM()

		If nPosTes > 0
			aCols[n][nPosTes]	:= If(!Empty(RetFldProd(SB1->B1_COD,"B1_TS")),RetFldProd(SB1->B1_COD,"B1_TS"),aCols[n][nPosTes])
			MaFisAlt("IT_TES",aCols[n][nPosTes],n)
			Eval(bListRefresh)
		EndIf
		If Rastro(aCols[n][nPosCod])
			aCols[n][nPosDtValid]	:= dDataBase + SB1->B1_PRVALID
		EndIf
	Endif	
EndIf	

If ( cPaisLoc <> "BRA" )
	If ( Type("oGetDados")<>"U" )
		oGetDados:oBrowse:NAT := N
		oGetDados:oBrowse:Refresh()
	Endif
	MaColsToFis(aHeader,aCols,n,"MT100",.T.,.F.,.T.)
	Eval(bDoRefresh)
Endif

RestArea(aArea)

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A920ITDEV³ Autor ³ Edson Maricate         ³ Data ³07.04.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consiste a Nota Fiscal Origem Digitada                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA920                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A920ItDev(cItemOri)


Local nx
Local cCampo
Local nPosCod	:= 0
Local nPosNfOri	:= 0
Local nPosSerOri:= 0
Local nPosQtd	:= 0
Local nPosPreco	:= 0
Local nPosValor	:= 0
Local lRet		:= .T.
Local aArea		:= GetArea()
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())

For nx := 1 to Len(aHeader)
	cCampo:=Trim(aHeader[nx,2])
	Do Case
	Case cCampo=="D2_COD"
		nPosCod		:= nX
	Case cCampo=="D2_NFORI"
		nPosNfOri	:= nX
	Case cCampo=="D2_SERIORI"
		nPosSerOri	:= nX
	Case cCampo=="D2_QUANT"
		nPosQtd		:= nX
	Case cCampo=="D2_PRCVEN"
		nPosPreco	:= nX
	Case cCampo=="D2_TOTAL"
		nPosValor	:= nX
	EndCase
Next nx

If !Empty(cItemOri)
	If cTipo$"CPI"
		dbSelectArea("SD2")
		dbSetOrder(3)
		If !MsSeek(xFilial('SD2')+aCols[n][nPosNfOri]+aCols[n][nPosSerOri]+cA100For+cLoja+aCols[n][nPosCod]+cItemOri)
			HELP(" ",1,"A100ITDEV")
			lRet := .F.
		Else
			A103SD2toaCols(SD2->(RecNo()),n)
		EndIf
	ElseIf cTipo == "D"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Notas de Credito e Debito...                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		dbSetOrder(1)
		If !MsSeek(xFilial('SD1')+aCols[n][nPosNfOri]+aCols[n][nPosSerOri]+cA100For+cLoja+aCols[n][nPosCod]+cItemOri)
			HELP(" ",1,"A100ITDEV")
			lRet := .F.
		Else
			If Empty(Acols[n][nPosPreco])   .And.;
					Empty(Acols[n][nPosQtd])    .And.;
					Empty(aCols[n][nPosValor])
				Acols[n][nPosQtd]    := SD1->D1_QUANT
				Acols[n][nPosPreco]  := SD1->D1_VUNIT
				ACols[n][nPosValor]  := SD1->D1_TOTAL
			Endif
			A103SD1toaCols(SD1->(RecNo()),n)
		EndIf
	EndIf
EndIf


RestArea(aAreaSD1)
RestArea(aAreaSD2)
RestArea(aArea)

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920Financ³ Autor ³  Edson Maricate       ³ Data ³18.03.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a tela de dados contabeis/financeiros.               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatA920                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A920Financ(cCondicao,oDlg,aRecSE1,aRecSE2,nPosX)

Local aMoeda	 := {}
Local aTemp		 := {{"","","",CTOD("  /  /  "),0}} 
Local cMoeda     := ""
Local cDescri 	 := CriaVar("E4_DESCRI")
Local cNatureza	 := CriaVar("E1_NATUREZ")
Local dDatCont	 := dDataBase
Local nX         := 0
Local nBaseDup   := 0
Local nMoedaCor  := 0
Local oList
Local oMoeda
Local oNatu
Local oDescri
Local oCond
Local lDoVisual	 := .F.
Local A920SE1ADC := ExistBlock("A920SE1ADC") //Ponto de Entrada para incluir campos na consulta de duplicatas
Local aA920SE1ADC    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o array com as duplicatas qdo. for visual      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE4")
dbSetOrder(1)
If MsSeek(xFilial()+cCondicao)
	cDescri := SE4->E4_DESCRI
EndIf
dbSelectArea("SE1")
If !Empty(aRecSE1)
	aTemp := {}
	For nx := 1 to Len(aRecSE1)
		dbGoto(aRecSE1[nx])          
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera os titulos tambem quando forem do SIGALOJA:	³
		//³ LOJA701 - LOJA010 - FATA701 						 	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE1->E1_TIPO $ MVNOTAFIS .OR. "LOJA" $ E1_ORIGEM .OR. "FATA701" $ E1_ORIGEM
			cNatureza := SE1->E1_NATUREZA
			nMoedaCor := SE1->E1_MOEDA                                         
            If A920SE1ADC
   			   aA920SE1ADC := AClone(ExecBlock("A920SE1ADC",.F.,.F.,{"SE1"})) 
   			   aAdd(aTemp,aA920SE1ADC[3]) 
   			Else   
  			   aAdd(aTemp,{E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCTO,E1_VALOR}) 
            Endif							
		EndIf
	Next nX
	If Empty(aTemp)
		aTemp := {{"","","",CTOD("  /  /  "),0}}
	EndIf
EndIf
dbSelectArea("SE2")
If !Empty(aRecSE2)
	aTemp := {}
	For nx	:= 1 to Len(aRecSE2)
		dbGoto(aRecSE2[nx])          
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera os titulos tambem quando forem do SIGALOJA ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE2->E2_TIPO $ MV_CPNEG
			cNatureza	:= SE2->E2_NATUREZA
			nMoedaCor	:= SE2->E2_MOEDA
			aAdd(aTemp,{E2_NUM,E2_PREFIXO,E2_PARCELA,E2_VENCTO,E2_VALOR})
		EndIf
	Next nX
	If Empty(aTemp)
		aTemp	:= {{"","","",CTOD("  /  /  "),0}}
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Array contendo as moedas do sistema          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx := 1 to ContaMoeda()
	aADD(aMoeda,Alltrim(STR(nx,3))+":"+GetMv("MV_MOEDA"+Alltrim(STR(nx,3))))
	If nx == nMoedaCor
		cMoeda	:= aMoeda[nMoedaCor]
	EndIf
Next

@ 5,4     SAY STR0056 Of oDlg PIXEL SIZE 39 ,9 //"Condicao"
@ 4,31    MSGET oCond VAR cCondicao  Picture PesqPict('SF2','F2_COND') When .F.	OF oDlg PIXEL SIZE 22 ,9

@ 19 ,4   SAY STR0057 Of oDlg PIXEL SIZE 19 ,9  //"Descr."
@ 18 ,31  MSGET oDescri VAR cDescri  Picture PesqPict('SE4','E4_DESCRI') When .F. OF oDlg PIXEL SIZE 54 ,9

@ 33 ,4   SAY STR0058 Of oDlg PIXEL SIZE 41 ,9 //"Natureza"
@ 33 ,31  MSGET oNatu VAR cNatureza  Picture PesqPict('SE2','E2_NATUREZ') When .F. OF oDlg PIXEL SIZE 54,9

@ 48 ,4   SAY STR0059 Of oDlg PIXEL SIZE 30 ,9  //"Moeda"
@ 47 ,31  MSCOMBOBOX oMoeda VAR cMoeda ITEMS aMoeda  When .F. SIZE 54 ,50 OF oDlg PIXEL

If A920SE1ADC
   oList:= TWBrowse():New( 5,89,nPosX,53,,aA920SE1ADC[1],aA920SE1ADC[2],oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,) 
   oList:SetArray(aTemp)
   oList:bLine := {|| A920Line(oList,aTemp,aA920SE1ADC[4])}
Else
   oList:= TWBrowse():New( 5,89,nPosX,53,,{STR0060,STR0061,STR0062,STR0063,STR0064},{35,35,20,35,60},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,) //"Numero"###"Prefixo"###"Parc."###"Vencto"###"Valor"
   oList:SetArray(aTemp)
   oList:bLine := {|| A920Line(oList,aTemp,{"E1_NUM","E1_PREFIXO","E1_PARCELA","E1_VENCTO","E1_VALOR"})}
Endif

Return oList

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A920Line³ Autor ³  Edson Maricate         ³ Data ³18.03.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza a linha de tela de dados Financeiros              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA920                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A920Line(oList,aTemp,aCpos)
Local i    := 1
Local aRet := {}
for i:=1 to len(aTemp[1])
    aadd(aRet,TransForm(aTemp[oList:nAt][i],PesqPict("SE1",aCpos[i])))
end   
Return aRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A920Pedido³ Autor ³ Edson Maricate        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Programa para consulta ao anexos da Nota Fiscal             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³Void A920Pedido(ExpN1,ExpA2)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Tipo de Consulta                                   ³±±
±±³          ³         [1] Pedido de Venda                                ³±±
±±³          ³ ExpA2 = Array com os Pedidos de Venda                      ³±±
±±³          ³ ExpC3 = Texto a ser exibido em tela                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A920Pedido(nTipo,aPedido,cTexto)

Local aArea      := GetArea()
Local aSavHead   := aClone(aHeader)
Local aSavCols   := aClone(aCols)
Local aRecNo     := {}
Local nSavN      := N
Local nUsado     := 0
Local nX         := 0
Local nY         := 0
Local oDlg
Local oGetDad
Local oBtn

Private aHeader := {}
Private aCols   := {}
Private N		:= 1

Do Case
Case ( nTipo == 1 )
	If ( Len(aPedido) > 1 )
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC5")
		While ( !Eof() .And. SX3->X3_ARQUIVO=="SC5" )
			If ( SX3->X3_BROWSE=="S" )
				Aadd(aHeader,{ AllTrim(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT} )
				nUsado++
			EndIf
			dbSelectArea("SX3")		
			dbSkip()
		End
		For nX := 1 To Len(aPedido)
			dbSelectArea("SC5")
			dbSetOrder(1)
			MsSeek(xFilial("SC5")+aPedido[nX])
			aadd(aRecNo,RecNo())
			aadd(aCols,Array(nUsado))
			For nY := 1 To Len(aHeader)
				If ( aHeader[nY][10] != "V" )
					aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
				Else
					aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2],.T.)
				EndIf
			Next nY
		Next nX
		DEFINE MSDIALOG oDlg FROM	09,0 TO 28,80 TITLE STR0065 OF oMainWnd  //"Pedidos"
		@ 001,002 TO 031,267 OF oDlg	PIXEL
		@ 015,005 SAY STR0066 SIZE 020,009 OF oDlg PIXEL  //"N.Fiscal :"
		@ 015,030 SAY cTexto             SIZE 150,009 OF oDlg PIXEL
		oGetDad := MsGetDados():New(035,002,135,315,2)
		DEFINE SBUTTON 		FROM 005,280 TYPE 1  ENABLE OF oDlg ACTION ( oDlg:End() )
		DEFINE SBUTTON oBtn FROM 020,280 TYPE 15 ENABLE OF oDlg ACTION ( oGetDad:oBrowse:lDisablePaint:=.T.,A920Mostra(1,aRecNo[N]),oGetDad:oBrowse:lDisablePaint:=.F. )
		oBtn:lAutDisable := .F.
		ACTIVATE MSDIALOG oDlg
	Else
		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(xFilial("SC5")+aPedido[1])
		A920Mostra(1,RecNo())
	EndIf
Otherwise
	Alert(STR0067)	 //"Opcao nao disponivel"
EndCase

N       := nSavN
aCols   := aClone(aSavCols)
aHeader := aClone(aSavHead)

RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A920Mostra³ Autor ³ Edson Maricate       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de detalhamento da consulta aos anexos da NFS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void  A920Mostra(ExpN1)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Tipo de Consulta                                   ³±±
±±³          ³         [1] Pedido de Venda                                ³±±
±±³          ³ ExpN2 = Nr do Registro                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A920Mostra(nTipo,nRecNo)

Local aArea := GetArea()
Local aSavHead   := aClone(aHeader)
Local aSavCols   := aClone(aCols)
Local nSavN      := N
Private N        := 1
Do Case
Case ( nTipo == 1 )
	dbSelectArea("SC5")
	dbSetOrder(1)
	MsGoto(nRecNo)	
	A410Visual("SC5",nRecNo,2)
EndCase
N       := nSavN
aCols   := aClone(aSavCols)
aHeader := aClone(aSavHead)
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A920Track ³ Autor ³ Sergio Silveira       ³ Data ³03/01/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A920Track()

Local aEnt     := {}
Local cKey     := c920Nota + c920Serie + c920Client + c920Loja
Local nPosItem := GDFieldPos( "D2_ITEM" )
Local nPosCod  := GDFieldPos( "D2_COD"  )
Local nLoop    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aCols )
	If !Empty(aRemito[nLoop][1])
		AAdd( aEnt, { "SD2", aRemito[nLoop][1]+aRemito[nLoop][2]+ c920Client + c920Loja + aCols[ nLoop, nPosCod ] + aRemito[ nLoop, 3 ] } )
	Else
		AAdd( aEnt, { "SD2", cKey + aCols[ nLoop, nPosCod ] + aCols[ nLoop, nPosItem ] } )
	Endif
Next nLoop

MaTrkShow( aEnt )

Return( .T. )
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MyMata920 ³ Autor ³ Eduardo Riera         ³ Data ³17.12.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de teste da rotina automatica do programa MATA920     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar testes na rotina de    ³±±
±±³          ³documento de entrada                                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
main Function MyMata920()

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.
PRIVATE lMsErroAuto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ConOut(Repl("-",80))
ConOut(PadC("Teste de Inclusao de 10 documentos de entrada com 30 itens cada",80))
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FIS" TABLES "SF2","SD2","SA1","SA2","SB1","SB2","SF4"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verificacao do ambiente para teste                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
If !SB1->(MsSeek(xFilial("SB1")+"PA001"))
	lOk := .F.
	ConOut("Cadastrar produto: PA001")
EndIf
dbSelectArea("SF4")
dbSetOrder(1)
If !SF4->(MsSeek(xFilial("SF4")+"501"))
	lOk := .F.
	ConOut("Cadastrar TES: 501")
EndIf
dbSelectArea("SE4")
dbSetOrder(1)
If !SE4->(MsSeek(xFilial("SE4")+"001"))
	lOk := .F.
	ConOut("Cadastrar condicao de pagamento: 001")
EndIf
dbSelectArea("SA1")
dbSetOrder(1)
If !SA1->(MsSeek(xFilial("SA1")+"CL000101"))
	lOk := .F.
	ConOut("Cadastrar cliente: CL000101")
EndIf
If lOk
	ConOut("Inicio: "+Time())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Verifica o ultimo documento valido para um fornecedor        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(2)
	MsSeek(xFilial("SF2")+"CL000101z",.T.)
	dbSkip(-1)
	cDoc := SF2->F2_DOC
	For nY := 1 To 10
		aCabec := {}
		aItens := {}

		If Empty(cDoc)
			cDoc := StrZero(1,Len(SD2->D2_DOC))
		Else
			cDoc := Soma1(cDoc)
		EndIf
		aadd(aCabec,{"F2_TIPO"   ,"N"})
		aadd(aCabec,{"F2_FORMUL" ,"N"})
		aadd(aCabec,{"F2_DOC"    ,(cDoc)})
		aadd(aCabec,{"F2_SERIE"  ,"UNI"})
		aadd(aCabec,{"F2_EMISSAO",dDataBase})
		aadd(aCabec,{"F2_CLIENTE","CL0001"})
		aadd(aCabec,{"F2_LOJA"   ,"01"})
		aadd(aCabec,{"F2_ESPECIE","NF"})
		aadd(aCabec,{"F2_COND","001"})
		aadd(aCabec,{"F2_DESCONT",0})
		aadd(aCabec,{"F2_FRETE",0})
		aadd(aCabec,{"F2_SEGURO",0})
		aadd(aCabec,{"F2_DESPESA",0})
		If cPaisLoc == "PTG"         
			aadd(aCabec,{"F2_DESNTRB",0})
			aadd(aCabec,{"F2_TARA",0})
		Endif
		For nX := 1 To 30
			aLinha := {}
			aadd(aLinha,{"D2_COD"  ,"PA001",Nil})
			aadd(aLinha,{"D2_QUANT",1,Nil})
			aadd(aLinha,{"D2_PRCVEN",100,Nil})
			aadd(aLinha,{"D2_TOTAL",100,Nil})
			aadd(aLinha,{"D2_TES","501",Nil})
			aadd(aItens,aLinha)
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Teste de Inclusao                                            |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MATA920(aCabec,aItens)
		If !lMsErroAuto
			ConOut("Incluido com sucesso! "+cDoc)	
		Else
			ConOut("Erro na inclusao!")
		EndIf
	Next nY
	ConOut("Fim  : "+Time())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de exclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCabec := {}
	aItens := {}
	aadd(aCabec,{"F2_TIPO"   ,"N"})
	aadd(aCabec,{"F2_FORMUL" ,"N"})
	aadd(aCabec,{"F2_DOC"    ,(cDoc)})
	aadd(aCabec,{"F2_SERIE"  ,"UNI"})
	aadd(aCabec,{"F2_EMISSAO",dDataBase})
	aadd(aCabec,{"F2_FORNECE","F00001"})
	aadd(aCabec,{"F2_LOJA"   ,"01"})
	aadd(aCabec,{"F2_ESPECIE","NFE"})
	aadd(aCabec,{"F2_DESCONT",0})
	aadd(aCabec,{"F2_FRETE",10})
	aadd(aCabec,{"F2_SEGURO",20})
	aadd(aCabec,{"F2_DESPESA",30})
	If cPaisLoc == "PTG"          
		aadd(aCabec,{"F2_DESNTRB",40})
		aadd(aCabec,{"F2_TARA",50})
	Endif
	For nX := 1 To 30
		aLinha := {}
		aadd(aLinha,{"D2_ITEM",StrZero(nX,Len(SD1->D1_ITEM)),Nil})
		aadd(aLinha,{"D2_COD","PA002",Nil})
		aadd(aLinha,{"D2_QUANT",2,Nil})
		aadd(aLinha,{"D2_PRCVEN",100,Nil})
		aadd(aLinha,{"D2_TOTAL",200,Nil})
		aadd(aItens,aLinha)
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Exclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ConOut(PadC("Teste de exclusao",80))
	ConOut("Inicio: "+Time())
	MATA920(aCabec,aItens,5)
	If !lMsErroAuto
		ConOut("Exclusao com sucesso! "+cDoc)	
	Else
		ConOut("Erro na exclusao!")
	EndIf
	ConOut("Fim  : "+Time())
	ConOut(Repl("-",80))
EndIf
RESET ENVIRONMENT
Return(.T.)

Static Function ProcH(cCampo)
Return aScan(aAutoCab,{|x|Trim(x[1])== cCampo })  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A920Conhec³ Autor ³Sergio Silveira        ³ Data ³15/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada da visualizacao do banco de conhecimento            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A920Conhec()                                                ³±±
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

Static Function A920Conhec() 

Local aRotBack := AClone( aRotina ) 
Local nBack    := N

Private aRotina := {}

Aadd(aRotina,{STR0073,"MsDocument", 0 , 2,0,NIL}) //"Banco de Conhecimento"

MsDocument( "SF2", SF2->( Recno() ), 1 ) 

aRotina := AClone( aRotBack ) 
N := nBack 

Return( .t. ) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A920Docume³ Autor ³Sergio Silveira        ³ Data ³15/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada da rotina de amarracao do banco de conhecimento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpX1 := A920Docume()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpX1 -> Retorno da funcao MsDocument                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function A920Docume( cAlias, nRec, nOpc ) 

Local aArea    := GetArea() 
Local xRet   

SD2->( MsGoto( nRec ) ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Posiciona no SF2 a partir do SD2                             |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2->( dbSetOrder( 1 ) )    

If SF2->( MsSeek( xFilial( "SF2" ) + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_FORMUL ) ) 
	xRet := MsDocument( "SF2", SF2->( Recno() ), nOpc ) 
EndIf	             

RestArea( aArea )
	
Return( xRet ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A920NFe   ³ Autor ³Mary C. Hergert        ³ Data ³29/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida campos da Nota Fiscal Eletronica de Sao Paulo        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A920NFe(cExp01,aExp01)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cExp01: Campo a ser validado                                ³±±
±±³          ³aExp01: Array com as variaveis de memoria                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A920NFe(cCampo,aNFEletr)

Local lRet := .T.

If cPaisLoc == "BRA"
	If cCampo == "EMINFE"    
		If !Empty(aNFEletr[03]) .And. aNFEletr[03] < d920Emis
			Help("",1,"A100NFEDT")	
			lRet := .F.
		Endif
	ElseIf cCampo == "CREDNFE"
		If aNFEletr[05] < 0
			Help("",1,"A100NFECR")	
			lRet := .F.
		Endif
	Endif
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
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
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
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

Local lPyme		:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)
     
Private aRotina := {	{ STR0001	,"AxPesqui"	, 0 , 1 , 0 ,.F.},;	//"Pesquisar"
							{ STR0002 	,"a920NFSAI", 0 , 2 , 0 ,NIL},;	//"Visualizar"
							{ STR0003	,"a920NFSAI", 0 , 3 , 0 ,NIL},;	//"Incluir"
							{ STR0004   ,"a920NFSAI", 0 , 5 , 0 ,NIL},; //"Excluir"
							{ STR0036   ,"a920NFSAI", 0 , 3 , 0 ,NIL} }	//"NF Lote"         
	
If !lPyme
	Aadd(aRotina,{STR0075,"a920Docume", 0 , 4 , 0 , NIL}) //"Conhecimento"
EndIf	

aAdd(aRotina,{ STR0083 ,"ANFMLegenda", 0 , 2, 0, .F.}) // Legenda

If ExistBlock("MA920MNU")
	ExecBlock("MA920MNU",.F.,.F.)
EndIf

Return(aRotina)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MaCols920 ³ Autor ³ Liber De Esteban      ³ Data ³ 22/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Montagem do aCols para GetDados.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MaCols920()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³-l920Inclui -> Identifica se operacao e inclusao.           ³±±
±±³          ³-l920Altera -> Identifica se operacao e Alteracao.          ³±±
±±³          ³-l920Deleta -> Identifica se operacao e delecao.            ³±±
±±³          ³-lContinua -> Flag que identifica se deve continuar proc.   ³±±
±±³          ³-aPedidos -> Array com os pedidos relacionados ao doc.      ³±±
±±³          ³-aRecSE1 -> Array com os Recno's de SE1 relacionados ao doc.³±±
±±³          ³-aRecSE2 -> Array com os Recno's de SE2 relacionados ao doc.³±±
±±³          ³-aRecSF3 -> Array com os Recno's de SF3 relacionados ao doc.³±±
±±³          ³-a920Var -> Array com os valores de impostos                ³±±
±±³          ³-aTitles -> Array com os titulos das telas                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA920 - SIGAFIS                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function MaCols920(l920Inclui,l920Altera,l920Deleta,lContinua,aPedidos,aRecSE1,aRecSE2,aRecSF3,a920Var,aTitles)

Local nY, nX, nD2
Local nPosUni := 0
Local nPosDes := 0
Local nPosTot := 0
Local nPosQtd := 0

Local lQuery    := .F.  
Local lMA920SD2 := .F.
Local l920ZFM   := .F.

Local cQuery    := ""
Local cRemito   := "SD2"
Local cSerie
Local cAliasSD2 := "SD2"
Local cAliasSE1 := "SE1"
Local cAliasSE2 := "SE2"
Local cAliasSF3 := "SF3"
Local cFilialTMS:= ""

Local aStruSE1  := {}
Local aStruSE2  := {}
Local aStruSD2  := {}
Local aStruSF3  := {}                        
Local aAreaSD2	:= {}
Local aCpoSD2	:= {}

If l920Inclui
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem de uma linha em branco no aCols.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)
		If Trim(aHeader[nY][2]) == "D2_ITEM"
			aCols[1][nY] 	:= StrZero(1,Len((cAliasSD2)->D2_ITEM))
		Else
			If AllTrim(aHeader[nY,2]) == "D2_ALI_WT"
				aCOLS[Len(aCols)][nY] := "SD2"
			ElseIf AllTrim(aHeader[nY,2]) == "D2_REC_WT"
				aCOLS[Len(aCols)][nY] := 0
			Else
				aCols[1][nY] := CriaVar(aHeader[nY][2])
			EndIf
		EndIf
		aCols[1][Len(aHeader)+1] := .F.
	Next nY
	
Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trava os registros na alteracao e  exclusao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l920Altera .Or. l920Deleta
		If !SoftLock("SF2")
			lContinua := .F.
		Endif
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aCols com os dados do SD2                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	#IFDEF TOP

		If TcSrvType() <> "AS/400" .And. Empty( AScan( aHeader, { |x| x[8] == "M" } ) )		

			lQuery    := .T.
			cRemito   := GetNextAlias()
			ChkFile("SD2",.F.,cRemito)
			aStruSD2  := SD2->(dbStruct())

			cQuery := "SELECT SD2.R_E_C_N_O_ SD2RECNO,SD2.* "
			cQuery += "FROM "+RetSqlName("SD2") + " SD2 "
			cQuery += " WHERE "
			cQuery += " D2_FILIAL = '"+xFilial("SD2")+"' AND "
			cQuery += " D2_DOC = '"+c920Nota+"' AND "
			cQuery += " D2_SERIE = '"+c920Serie+"' AND "
			cQuery += " D2_CLIENTE = '"+c920Client+"' AND "
			cQuery += " D2_LOJA = '"+c920Loja+"' AND "
			cQuery += " SD2.D_E_L_E_T_ = ' '"
			cQuery += "ORDER BY SD2.R_E_C_N_O_"

			cQuery := ChangeQuery(cQuery)
			
			SD2->(dbCloseArea())
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.F.,.T.)

			For nX := 1 To Len(aStruSD2)
				If aStruSD2[nX][2]!="C"
					TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
				EndIf
			Next nX

		Else
	#ENDIF

		cAliasSD2 := "SD2"

		dbSelectArea("SD2")
		dbSetOrder(3)
		MsSeek(xFilial("SD2")+c920Nota+c920Serie+c920Client+c920Loja)
		#IFDEF TOP
		Endif
		#ENDIF						

	nPosUni:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_PRCVEN"})
	nPosDes:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_DESCON"})
	nPosTot:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_TOTAL" })
	nPosQtd:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_QUANT" })
	
	While !Eof() .And. (cAliasSD2)->D2_FILIAL == xFilial("SD2") .And. ;
			(cAliasSD2)->D2_DOC == c920Nota .And.;
			(cAliasSD2)->D2_SERIE == c920Serie .And.;
			(cAliasSD2)->D2_CLIENTE ==c920Client .And.;
			(cAliasSD2)->D2_LOJA == c920Loja

		If !Empty((cAliasSD2)->D2_PEDIDO) .And. ( aScan(aPedidos,(cAliasSD2)->D2_PEDIDO)==0 )
			Aadd(aPedidos,(cAliasSD2)->D2_PEDIDO)
		ElseIf cPaisLoc <> "BRA"
	  		If !Empty((cAliasSD2)->D2_REMITO)  
	  		
 				// Salva Area do SD2 pois cRemito e cAliasSD2 possuem o mesmo Alias SD2.
 				If !lQuery
		  			aAreaSD2	:= SD2->(GetArea())
		  		EndIf	
	  		
  	   			dbSelectArea(cRemito)
  	   			dbSetOrder(3)
	  			If MsSeek(xFilial("SD2")+(cAliasSD2)->D2_REMITO+(cAliasSD2)->D2_SERIREM +(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMREM)
	   	  			If !Empty((cRemito)->D2_PEDIDO) .And. Ascan(aPedidos,(cRemito)->D2_PEDIDO) == 0
		   	  			aadd(aPedidos,(cRemito)->D2_PEDIDO)
		   	  		EndIf
	  			EndIf
	  			
 				If !lQuery
		  			RestArea(aAreaSD2)
		  		EndIf	
				DbSelectArea(cAliasSD2)
  	   		EndIf	
	  	EndIf	
        
        If ExistBlock("MA920SD2") .and. !lMA920SD2
    	   aCpoSD2 := ExecBlock("MA920SD2",.F.,.F.) 
   	       for nD2:=1 to len(aCpoSD2)
  		      aadd(aHeader,Aclone(aHeader[len(aHeader)])) 
              aHeader[Len(aHeader)][1] := aCpoSD2[nD2][1]
              aHeader[Len(aHeader)][2] := aCpoSD2[nD2][2]
              aHeader[Len(aHeader)][3] := aCpoSD2[nD2][3]
   	       next                                   
   	       lMA920SD2 := .T.
        Endif
        
		aadd(aCols,Array(Len(aHeader)+1))
  		Aadd(aRemito,{(cAliasSD2)->D2_REMITO,(cAliasSD2)->D2_SERIREM,(cAliasSD2)->D2_ITEMREM})
		For ny := 1 to Len(aHeader)
			If ( aHeader[ny][10] != "V")
				aCols[Len(aCols)][ny] := FieldGet(FieldPos(aHeader[ny][2]))
			Else
				If AllTrim(aHeader[nY,2]) == "D2_ALI_WT"
					aCOLS[Len(aCols)][nY] := "SD2"
				ElseIf AllTrim(aHeader[nY,2]) == "D2_REC_WT"
					aCOLS[Len(aCols)][nY] := If(lQuery,(cAliasSD2)->SD2RECNO,(cAliasSD2)->(RecNo()))
				Else
					If lQuery
						dbSelectArea("SD2")
						SD2->(MsGoto((cAliasSD2)->SD2RECNO))
					EndIf
					aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
				EndIf
			EndIf
		Next ny

		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		
		If cPaisLoc<>"BRA" .And. GetNewPar('MV_DESCSAI','1') =='2'
			If (nPosTot * nPosUni * nPosDes * nPosQtd) > 0
				If aCols[Len(aCols)][nPosDes]>0
					aCols[Len(aCols)][nPosTot] += aCols[Len(aCols)][nPosDes]
					aCols[Len(aCols)][nPosUni] := aCols[Len(aCols)][nPosTot] / aCols[Len(aCols)][nPosQtd]
				Endif
			Endif
		Endif

		dbSelectArea(cAliasSD2)
		dbSkip()
	End 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o arquivo da query e reabre o SD2                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lQuery 
		( cAliasSD2 )->( dbCloseArea() ) 
		( cRemito )-> ( dbCloseArea() ) 
		ChkFile("SD2",.F.)
		dbSelectArea( "SD2" ) 		
	EndIf 

	MaFisIniNF(2,SF2->(RecNo()),,,.f.)
	MaFisLoad("NF_VALMERC",SF2->F2_VALMERC)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carega o Array contendo as Duplicatas a Receber (SE1)   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSerie := If(Empty(SF2->F2_PREFIXO),&(GETMV("MV_1DUPREF")),SF2->F2_PREFIXO)
	cSerie += Space(Len(SE1->E1_PREFIXO) - Len(cSerie))
	If !SF2->F2_TIPO $ "DB"
		#IFDEF TOP
	
			If TcSrvType() <> "AS/400"
	
				lQuery    := .T.
				cAliasSE1 := "QRYSE1"
				aStruSE1  := SE1->(dbStruct())
	
				cQuery := "SELECT SE1.*,SE1.R_E_C_N_O_ RECSE1 FROM "
				cQuery += RetSqlName("SE1") 	+ " SE1 "
				cQuery += " WHERE "
				cQuery += "E1_FILIAL = '"		+ xFilial("SE1")	+ "' AND "
				cQuery += "E1_PREFIXO = '"		+ cSerie			+ "' AND "
				cQuery += "E1_NUM = '"			+ SF2->F2_DOC		+ "' AND "
				cQuery += "((E1_CLIENTE = '"		+ SF2->F2_CLIENTE	+ "' AND "
				cQuery += "E1_LOJA = '"			+ SF2->F2_LOJA		+ "' AND "
				cQuery += "E1_TIPO = '"+MVNOTAFIS+"' ) OR "
				cQuery += "(E1_ORIGEM Like 'LOJA%' AND E1_TIPO IN ('CC', 'CD', 'FI', 'VA', 'CO', 'R$')) "
				cQuery += " OR E1_ORIGEM = 'FATA701')"
				cQuery += " AND "
				cQuery += "SE1.D_E_L_E_T_ = ' '"
	
				cQuery := ChangeQuery(cQuery)
	
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.F.,.T.)
	
				For nX := 1 To Len(aStruSE1)
					If aStruSE1[nX][2]!="C"
						TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
					EndIf
				Next nX
			Else
	
		#ENDIF
	
			cAliasSE1 := "SE1"
	
			dbSelectArea("SE1")
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alterado o indice de busca, pois no SIGALOJA ao utilizar CC/CD/FI/VA/CO o cliente pode ser diferente da NF.³
		//³ A validacao do cliente continua sendo feita atraves do Iif (se nao for SIGALOJA).                          ³                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			dbSetOrder(1)                                                 
			MsSeek(xFilial()+cSerie+SF2->F2_DOC)
	
			#IFDEF TOP
			Endif
			#ENDIF
	
		While !Eof() .And. 	(cAliasSE1)->E1_FILIAL == xFilial("SE1") .AND.;
				(cAliasSE1)->E1_PREFIXO == cSerie .AND. ;
				(cAliasSE1)->E1_NUM == SF2->F2_DOC
	
	            If IIf((SubStr((cAliasSE1)->E1_ORIGEM, 1, 4) == "LOJA" .AND. AllTrim((cAliasSE1)->E1_TIPO) $ "CC|CD|FI|VA|CO|R$"),.T.,;
	                   (cAliasSE1)->E1_CLIENTE == SF2->F2_CLIENTE .And. (cAliasSE1)->E1_LOJA == SF2->F2_LOJA)
				   aAdd( aRecSE1,Iif( lQuery, (cAliasSE1)->RECSE1 , SE1->(RecNo() ) ) )					   
	            EndIf
	            dbSkip()  
		EndDo
	Else
		#IFDEF TOP
	
			If TcSrvType() <> "AS/400"
	
				lQuery    := .T.
				cAliasSE2 := "QRYSE2"
				aStruSE2  := SE2->(dbStruct())
	
				cQuery := "SELECT SE2.*,SE2.R_E_C_N_O_ RECSE2 FROM "
				cQuery += RetSqlName("SE2") 	+ " SE2 "
				cQuery += " WHERE "
				cQuery += "E2_FILIAL = '"		+ xFilial("SE2")	+ "' AND "
				cQuery += "E2_PREFIXO = '"		+ cSerie			+ "' AND "
				cQuery += "E2_NUM = '"			+ SF2->F2_DOC		+ "' AND "
				cQuery += "E2_FORNECE = '"		+ SF2->F2_CLIENTE	+ "' AND "
				cQuery += "E2_LOJA = '"			+ SF2->F2_LOJA		+ "' AND "
				cQuery += "E2_TIPO = '"+MV_CPNEG+"' AND "
				cQuery += "SE2.D_E_L_E_T_ = ' '"
	
				cQuery := ChangeQuery(cQuery)
	
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.F.,.T.)
	
				For nX := 1 To Len(aStruSE2)
					If aStruSE2[nX][2]!="C"
						TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
					EndIf
				Next nX
			Else
	
		#ENDIF	
			cAliasSE2 := "SE2"	
			dbSelectArea("SE2")	
			dbSetOrder(6)
			MsSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA+cSerie+SF2->F2_DOC)
	
			#IFDEF TOP
			Endif
			#ENDIF
	
		While !Eof() .And. 	(cAliasSE2)->E2_FILIAL == xFilial("SE2") .AND.;
				(cAliasSE2)->E2_FORNECE == SF2->F2_CLIENTE .AND. ;
				(cAliasSE2)->E2_LOJA == SF2->F2_LOJA .AND. ;
				(cAliasSE2)->E2_PREFIXO == cSerie .AND. ;
				(cAliasSE2)->E2_NUM == SF2->F2_DOC                                                              
	
				If (cAliasSE2)->E2_TIPO == MV_CPNEG
				   aAdd( aRecSE2,Iif( lQuery, (cAliasSE2)->RECSE2 , SE2->(RecNo() ) ) )					   
	            EndIf
	            dbSkip()  
		EndDo	
	EndIf
	aAdd(aTitles,STR0055) //"Duplicatas"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carega o Array contendo os Registros Fiscais.(SF3)      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//-- Caso seja TMS trata a FILIAL com a filial da nota de saída
	If(IsInCallStack("TMSA500") .And. IntTms())
		cFilialTMS := SF2->F2_FILIAL
	Else
		cFilialTMS := xFilial("SF3")
	EndIf
	
	#IFDEF TOP
		If TcSrvType() <> "AS/400"

			cAliasSF3 := "QRYSF3"
			aStruSF3  := SF3->(dbStruct())

			cQuery := "SELECT SF3.*,SF3.R_E_C_N_O_ RECSF3 FROM "
			cQuery += RetSqlName("SF3") + " SF3 "
			cQuery += " WHERE "
			cQuery += "F3_FILIAL = '"+cFilialTMS+"' AND "
			cQuery += "F3_CLIEFOR = '"+SF2->F2_CLIENTE+"' AND "
			cQuery += "F3_LOJA = '"+SF2->F2_LOJA+"' AND "
			cQuery += "F3_NFISCAL = '"+SF2->F2_DOC+"' AND "
			cQuery += "F3_SERIE = '"+SF2->F2_SERIE+"' AND "
			cQuery += "SF3.D_E_L_E_T_ = ' ' "			
			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.F.,.T.)

			For nX := 1 To Len(aStruSF3)
				If aStruSF3[nX][2]!="C"
					TcSetField(cAliasSF3,aStruSF3[nX][1],aStruSF3[nX][2],aStruSF3[nX][3],aStruSF3[nX][4])
				EndIf
			Next nX			

		Else

	#ENDIF

		cAliasSF3 := "SF3"

		dbSelectArea("SF3")
		dbSetOrder(4)
		MsSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)

		#IFDEF TOP
		Endif	
		#ENDIF

	While !Eof().And.lContinua.And. (cAliasSF3)->F3_FILIAL == cFilialTMS .And.;
			(cAliasSF3)->F3_CLIEFOR == SF2->F2_CLIENTE .And. ;
			(cAliasSF3)->F3_LOJA == SF2->F2_LOJA .And. ;
			(cAliasSF3)->F3_NFISCAL == SF2->F2_DOC .And. ;
			(cAliasSF3)->F3_SERIE == SF2->F2_SERIE

		If Substr((cAliasSF3)->F3_CFO,1,1) >= "5" .And. Empty((cAliasSF3)->F3_DTCANC)


			aAdd(aRecSF3,Iif(lQuery,(cAliasSF3)->RECSF3,RecNo() ) )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se for Top posiciona no registro correspondente      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lQuery
				SF3->(MsGoto((cAliasSF3)->RECSF3))
			Endif				

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trava os registros do SF3 - exclusao                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l920Deleta
				If !SoftLock("SF3")
					lContinua := .F.
				Endif
			EndIf
		EndIf
		dbSelectArea(cAliasSF3)
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa o Refresh nos valores de impostos.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A920Refresh(@a920Var,l920Inclui)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o arquivo da query                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery

	dbSelectArea(cAliasSE1)
	dbCloseArea()
	
	dbSelectArea(cAliasSE2)
	dbCloseArea()

	dbSelectArea(cAliasSF3)
	dbCloseArea()

	dbSelectArea("SD2")
	dbSetOrder(1)
Endif	

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³a920LAICMS³ Autor ³ Gustavo G. Rueda      ³ Data ³05/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para montagem do GETDADOS do folder de lancamentos   ³±±
±±³          ³ fiscais.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³oLancApICMS -> Objeto criado pelo MSNEWGETDADOS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oDlg -> Objeto pai onde o GETDADOS serah criado.            ³±±
±±³          ³aPos -> posicoes de criacao do objeto.                      ³±±
±±³          ³aHeadCDA -> array com o HEADER da tabela CDA                ³±±
±±³          ³aColsCDA -> array com o ACOLS da tabela CDA                 ³±±
±±³          ³lVisual -> Flag de visualizacao                             ³±±
±±³          ³lInclui -> Flag de inclusao                                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function a920LAICMS(oDlg,aPos,aHeadCDA,aColsCDA,lVisual,lInclui)
Local	oLancApICMS
Local	bCond		:=	{||.T.}
Local	bSkip		:=	IIF(CDA->(FieldPos("CDA_TPREG")) > 0,{|| CDA->CDA_TPREG == "NA" },NIL)
Local	cVisual		:=	Iif(lVisual,"'1'","'2'")

aMHead("CDA","CDA_TPMOVI/CDA_ESPECI/CDA_FORMUL/CDA_NUMERO/CDA_SERIE/CDA_CLIFOR/CDA_LOJA/",@aHeadCDA)
If lVisual
	dbSelectArea("CDA")
	CDA->(dbSetOrder(1))
	CDA->(MsSeek(xFilial("CDA")+"S"+c920Especi+"S"+c920Nota+c920Serie+c920Client+c920Loja))
	bCond	:=	{||xFilial("CDA")+"S"+c920Especi+"S"+c920Nota+c920Serie+c920Client+c920Loja==CDA->(CDA_FILIAL+CDA_TPMOVI+CDA_ESPECI+CDA_FORMUL+CDA_NUMERO+CDA_SERIE+CDA_CLIFOR+CDA_LOJA)}
EndIf
aMAcols(lVisual,"CDA",@aColsCDA,aHeadCDA,bCond,bSkip)

oLancApICMS	:=	MsNewGetDados():New(aPos[1],aPos[2],aPos[4],aPos[3],Iif(lVisual,0,GD_UPDATE+GD_INSERT+GD_DELETE),"a920LOk","a920LOk","+CDA_SEQ",{"CDA_NUMITE","CDA_CODLAN","CDA_BASE","CDA_ALIQ","CDA_VALOR","CDA_IFCOMP"},/*freeze*/,990,/*fieldok*/,/*superdel*/,"a920LDel("+cVisual+")",oDlg,@aHeadCDA,@aColsCDA)

Return oLancApICMS
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³aMHead    ³ Autor ³ Gustavo G. Rueda      ³ Data ³05/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para montagem do HEADER do GETDADOS                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias da tabela base para montagem do HEADER      ³±±
±±³          ³cNCmps -> Campos que nao serao considerados no HEADER       ³±±
±±³          ³aH -> array no qual o HEADER serah montado                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function aMHead(cAlias,cNCmps,aH)
Local	lRet	:=	.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos campos de Bancos de Dados            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
While !Eof() .And. (X3_ARQUIVO==cAlias)
	IF X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .and. !(AllTrim(X3_CAMPO)+"/"$cNCmps)
		AADD(aH,{ Trim(X3Titulo()), ;
			AllTrim(X3_CAMPO),;
			X3_PICTURE,;
			X3_TAMANHO,;
			X3_DECIMAL,;
			Iif(AllTrim(X3_CAMPO)=="CDA_NUMITE","a920LCpIt().And.","")+"a920LCps()",;
			X3_USADO,;
			X3_TIPO,;
			X3_F3,;
			X3_CONTEXT,;
			X3_CBOX,;
			X3_RELACAO})
	Endif
	dbSkip()
Enddo
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³aMAcols   ³ Autor ³ Gustavo G. Rueda      ³ Data ³05/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para montagem do ACOLS do GETDADOS                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nOpc -> Opcao do AROTINA                                    ³±±
±±³          ³cAlias -> Alias da tabela base para montagem do HEADER      ³±±
±±³          ³aC -> array no qual o ACOLS serah montado                   ³±±
±±³          ³aH -> array no qual o HEADER serah montado                  ³±±
±±³          ³bCond -> Condicao de loop do while                          ³±±
±±³          ³bSkip -> Condicao para ignorar um registro isolado          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function aMAcols(lVisual,cAlias,aC,aH,bCond,bSkip)
Local	lRet	:=	.T.
Local	nI		:=	0

DEFAULT bSkip 	:= {|| .F. }

dbSelectArea(cAlias)
dbSetOrder(1)
If lVisual 
	If !Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o array aCols com os itens                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aC	:=	{}
		While !Eof() .And. Eval(bCond)
			IF Eval(bSkip)
				dbSkip()
				Loop
			EndIf
			aAdd(aC,Array(Len(aH)+1))
			For nI := 1 To Len(aH)
				aC[Len(aC),nI] := FieldGet(FieldPos(aH[nI,2]))
			Next
			aC[Len(aC),Len(aH)+1] := .F.
			dbSkip()
		End	
	ElseIf  Len(aColsD2)>1
		For nI := 1 To Len(aColsD2)
			
		Next nI
	EndIf
Else
	aC				:=	{Array(Len(aH)+1)}
	aC[1,Len(aH)+1]	:=	.F.
	For nI := 1 To Len(aH)
		If aH[nI,10]#"V"
			aC[1,nI]	:=	CriaVar(aH[nI,2])
		EndIf

		If "_SEQ"$aH[nI,2]
			aC[1,nI]	:=	StrZero(1,aH[nI,4])
		EndIf
	Next	
EndIf
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³a920LDel  ³ Autor ³ Gustavo G. Rueda      ³ Data ³13/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para validar a delecao do lancamento fiscal do docu- ³±±
±±³          ³ mento criado pelo sistema.                                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. ou .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cVisual -> indica se a nota esta sendo visualizada. 1=Sim,  ³±±
±±³          ³ 2=Nao                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function a920LDel(cVisual)
Local	lRet	:=	.T.
Local	nPosCalc:=	0
Local	nPosIt	:=	0
Local 	nPosItD2:= 	0
Local	nPos	:=	0

If Type("oLancApICMS")=="O" .And. cVisual=="2"
	nPosCalc:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_CALPRO"})
	nPosIt	:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_NUMITE"})
	
	If nPosCalc>0 .And. oLancApICMS:aCols[oLancApICMS:nAT,nPosCalc]=="1"
		//Registros calculados pelo sistema não poderão ser excluídos, pois serão utilizados como log da rotina.
		//Caso seja necessário alterar este cálculo, basta inserir novos itens nesta opção de ajuste ou utitlizar a funcionalidade de Gerenciamento dos Lançamentos Fiscais de ICMS. Vale ressaltar que na Apuração de ICMS será considerada a sequência maior de cada lançamento fiscal do documento.
		Help("  ",1,"LAICMSDEL1")	
		lRet	:=	.F.
	
	ElseIf nPosCalc>0 .And. oLancApICMS:aCols[oLancApICMS:nAT,nPosCalc]=="2" .And. Type("aColsD2")=="A" .And. Type("aHeadD2")="A"
		nPosItD2:= 	aScan(aHeadD2,{|aX| aX[2]==PadR("D2_ITEM",Len(SX3->X3_CAMPO))})

		If nPosItD2>0 .And. nPosIt>0
			nPos	:=	aScan(aColsD2,{|aX|PadR(aX[nPosItD2],TamSx3("CDA_NUMITE")[1])==oLancApICMS:aCols[oLancApICMS:nAT,nPosIt].And.!aX[Len(aColsD2[1])]})
			If nPos==0 .And. !Empty(oLancApICMS:aCols[oLancApICMS:nAT,nPosIt])
				//Este registro não pode ser recuperado, pois o mesmo encontra-se excluído juntamente com seu respectivo item do documento fiscal.
				//Para se recuperar este registro é necessário que se tenha o respectivo item deste documento fiscal ativado.
				Help("  ",1,"LAICMSDEL2")
				lRet	:=	.F.
			EndIf
		EndIf
	EndIf
EndIf
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³a920LCpIt ³ Autor ³ Gustavo G. Rueda      ³ Data ³13/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para validar o item digitado no lancamento fiscal com³±±
±±³          ³ os itens do documento fiscal.                              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. ou .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function a920LCpIt()
Local	lRet	:=	.T.
Local	nPosCalc:=	0
Local	nPosItD2:=	0

If Type("oLancApICMS")=="O"

	nPosCalc:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_CALPRO"})

	If nPosCalc>0 .And. oLancApICMS:aCols[oLancApICMS:nAT,nPosCalc]=="2" .And. Type("aColsD2")=="A" .And. Type("aHeadD2")="A"
		nPosItD2:= 	aScan(aHeadD2,{|aX| aX[2]==PadR("D2_ITEM",Len(SX3->X3_CAMPO))})
		If nPosItD2>0
			nPos	:=	aScan(aColsD2,{|aX|aX[nPosItD2]==AllTrim(M->CDA_NUMITE).And.!aX[Len(aColsD2[1])]})
			If nPos==0
				//Número do item é inválido para este lançamento fiscal.
				//Deve-se informar um número de item existente no respectivo documento fiscal.
				Help("  ",1,"LAICMSCMP1")
				lRet	:=	.F.
			EndIf
		EndIf
	EndIf
EndIf
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³a920LCps  ³ Autor ³ Gustavo G. Rueda      ³ Data ³13/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para validar os campos alimentados pelo sistema que  ³±±
±±³          ³ nao poderao ser alterados.                                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. ou .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function a920LCps()
Local	lRet	:=	.T.
Local	nPosCalc:=	0

If Type("oLancApICMS")=="O"
	nPosCalc:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_CALPRO"})
	If nPosCalc>0 .And. oLancApICMS:aCols[oLancApICMS:nAT,nPosCalc]=="1"
		//Registros calculados pelo sistema não poderão ser alterados, pois serão utilizados como log da rotina.
		//Caso seja necessário alterar este cálculo, basta inserir novos itens nesta opção de ajuste ou utitlizar a funcionalidade de Gerenciamento dos Lançamentos Fiscais de ICMS. Vale ressaltar que na Apuração de ICMS será considerada a sequência maior de cada lançamento fiscal do documento.
		Help("  ",1,"LAICMSCMP2")
		lRet	:=	.F.
	EndIf
EndIf

Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³a920LOk   ³ Autor ³ Gustavo G. Rueda      ³ Data ³13/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para validar a linha do acols de lancamentos         ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. ou .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function a920LOk()
Local	lRet	:=	.T.
Local	nPosLanc:=	0
Local	nPosVlr	:=	0
Local	nNumIte	:=	0

If Type("oLancApICMS")=="O"
	nPosLanc:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_CODLAN"})
	nPosVlr:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_VALOR"})
	nNumIte:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_NUMITE"})

	If !oLancApICMS:aCols[oLancApICMS:nAT,Len(oLancApICMS:aCols[oLancApICMS:nAT])] .And.;
		!Empty(oLancApICMS:aCols[oLancApICMS:nAT,nNumIte])
		
		If nPosLanc>0 .And. Empty(oLancApICMS:aCols[oLancApICMS:nAT,nPosLanc])
			Help(1," ","OBRIGAT",,"CDA_CODLAN"+Space(30),3,0)
			lRet	:=	.F.
		EndIf
	
		If lRet .And. nPosLanc>0 .And. Empty(oLancApICMS:aCols[oLancApICMS:nAT,nPosVlr])
			Help(1," ","OBRIGAT",,"CDA_VALOR"+Space(30),3,0)
			lRet	:=	.F.
		EndIf
	EndIf
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a920Compl ºAutor  ³Mary C. Hergert     º Data ³  05/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa a rotina de complementos do documento fiscal        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Mata920                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a920Compl()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a especie do documento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2->(dbSetOrder(1)) 
SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))

Mata926(SD2->D2_DOC,SD2->D2_SERIE,SF2->F2_ESPECIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"S",SD2->D2_TIPO)

Return .T. 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a920RatCC  ºAutor  ³Microsiga           º Data ³  06/18/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a920RatCC(aHeadAGH,aColsAGH,nAt)

Local aArea       := GetArea()
Local aSavaRotina := aClone(aRotina)
Local aColsCC     := {}
Local aButtons	  := {}
Local aButtonUsr  := {}
Local aHeadSC7    := {}
Local aColsSC7    := {}
Local aNoFields   := {"AGH_CUSTO1","AGH_CUSTO2","AGH_CUSTO3","AGH_CUSTO4","AGH_CUSTO5"}
Local bSavKeyF4   := SetKey(VK_F4 ,Nil)
Local bSavKeyF5   := SetKey(VK_F5 ,Nil)
Local bSavKeyF6   := SetKey(VK_F6 ,Nil)
Local bSavKeyF7   := SetKey(VK_F7 ,Nil)
Local bSavKeyF8   := SetKey(VK_F8 ,Nil)
Local bSavKeyF9   := SetKey(VK_F9 ,Nil)
Local bSavKeyF10  := SetKey(VK_F10,Nil)
Local bSavKeyF11  := SetKey(VK_F11,Nil)
Local nPItemNF	  := aScan(aHeader,{|x| AllTrim(x[2]) == "D2_ITEM"} )
Local nPCC	      := aScan(aHeader,{|x| AllTrim(x[2]) == "D2_CC"} )
Local nPConta	  := aScan(aHeader,{|x| AllTrim(x[2]) == "D2_CONTA"} )
Local nPItemCta   := aScan(aHeader,{|x| AllTrim(x[2]) == "D2_ITEMCTA"} )
Local nPCLVL	  := Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_CLVL"} )
Local nPDECC	  := 0
Local nPDEConta	  := 0
Local nPDEItemCta := 0
Local nPDECLVL	  := 0
Local nColTotal   := aScan(aHeader,{|x| AllTrim(x[2]) == "D2_TOTAL"} )
Local nItem  	   := aScan(aColsAGH,{|x| Alltrim(x[1]) == Alltrim(aCols[n][nPItemNF])})
Local nX          := 0
Local nSavN       := nAT
Local nPPercAGH   := 0
Local nTotPerc    := 0
Local nOpcA       := 0
Local nNewTam     := 0
Local lContinua   := .T.
Local lRet        := .T.
Local oDlg
Local cCampo      := ReadVar()
Local nAviso      := 0
Local ca920Num    := SF2->F2_DOC

DEFAULT aHeadAGH  := {}
DEFAULT aColsAGH  := {}

Private aOrigHeader := aClone(aHeader)
Private aOrigAcols  := aClone(aCols)
Private oGetMan
Private nOrigN      := nAT
Private nPercRat    := 0
Private nPercARat	:= 100
Private oPercRat
Private oPercARat
Private oGetDad
Private N := nAT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L" 
	lContinua := !InConPad
EndIf

If nSavN == 0 
	lContinua := .F.
EndIf

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader do AGH                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(aHeadAGH)
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("AGH")
		While !EOF() .And. (SX3->X3_ARQUIVO == "AGH")
			IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"AGH_CUSTO"$SX3->X3_CAMPO
				AADD(aHeadAGH,{ TRIM(x3Titulo()),;
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
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aCols do AGH                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nItem > 0
		aColsCC := aClone(aColsAGH[nItem][2])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Totaliza o % ja Rateado ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPercRat := 0
		For nX   := 1  To  Len(aColsCC)
			nPercRat += aColsCC[nX][aScan(aHeadAGH,{|x| AllTrim(x[2])=="AGH_PERC"})]
		Next nX
		
		nPercARat := 100 - nPercRat
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ aHeader e aCols do SC7 devem ser salvos pois a FillGetDados destroe ³
		//³ ambos por serem PRIVATE, independente da construcao do aColsCC.     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aHeadSC7 := aClone(aHeader)
		aColsSC7 := aClone(aCols)
		aHeadAGH := {}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Sintaxe da FillGetDados(nOpcX,Alias,nOrdem,cSeek,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FillGetDados(2,"AGH",1,,,,aNoFields,,,,,.T.,aHeadAGH,aColsCC,,,)
		aColsCC[1][aScan(aHeadAGH,{|x| Trim(x[2])=="AGH_ITEM"})] := StrZero(1,Len(AGH->AGH_ITEM))
		
		aHeader := aHeadSC7
		aCols   := aColsSC7
		
	EndIf
	If !(Type('l920Auto') <> 'U' .And. l920Auto)
		aHeadSC7 := aClone(aHeader)
		aColsSC7 := aClone(aCols)
		DEFINE MSDIALOG oDlg FROM 100,100 TO 350,600 TITLE STR0091 Of oMainWnd PIXEL //"Rateio por Centro de Custo"
		@ 018,003 SAY RetTitle("F2_DOC")  OF oDlg PIXEL SIZE 20,09
		@ 018,026 SAY ca920Num            OF oDlg PIXEL SIZE 50,09
		@ 018,096 SAY RetTitle("F2_ITEM") OF oDlg PIXEL SIZE 20,09
		@ 018,120 SAY aCols[N][nPItemNF]  OF oDlg PIXEL SIZE 20,09
		oGetDad := MsNewGetDados():New(030,005,105,245,0 ,"a920RatLOk","a920RatTOk","+AGH_ITEM",,,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aHeadAGH,aColsCC)
		oGetMan := oGetDad
		@ 110,005 Say OemToAnsi(STR0092) FONT oDlg:oFont OF oDlg PIXEL	 // "% Rateada: "
		@ 110,035 Say oPercRat VAR nPercRat Picture PesqPict("AGH","AGH_PERC") FONT oDlg:oFont COLOR CLR_HBLUE OF oDlg PIXEL
		@ 110,184 Say OemToAnsi(STR0093) FONT oDlg:oFont OF oDlg PIXEL	 // "% A Ratear: "
		@ 110,217 Say oPercARat VAR nPercARat Picture PesqPict("AGH","AGH_PERC") FONT oDlg:oFont COLOR CLR_HBLUE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||IIF(oGetDad:TudoOk(),(nOpcA:=1,oDlg:End()),(nOpcA:=0))},{||oDlg:End()},,aButtons)

		aHeader := aHeadSC7
		aCols   := aColsSC7

	Else
		nOpcA := 1
	EndIf
	nPPercAGH := aScan(aHeadAGH,{|x| AllTrim(x[2])=="AGH_PERC"})
	nTotPerc := 0
	
	aColsPar :={}
	AEval( aColsCC, { |x| If( !x[ Len(aHeadAGH) + 1], AAdd( aColsPar, x ), ) } )
	aColsCC := aClone( aColsPar )
	
	For nX := 1 To Len(aColsCC)
		nTotPerc += aColsCC[nX][nPPercAGH]
	Next nX
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina	:= aClone(aSavaRotina)
N := nSavN
SetKey(VK_F4 ,bSavKeyF4)
SetKey(VK_F5 ,bSavKeyF5)
SetKey(VK_F6 ,bSavKeyF6)
SetKey(VK_F7 ,bSavKeyF7)
SetKey(VK_F8 ,bSavKeyF8)
SetKey(VK_F9 ,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
RestArea(aArea)
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³a920RatLok ³ Autor ³ Eduardo Riera         ³ Data ³15.10.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Validacao da linhaok dos itens do rateio dos itens do documen³±±
±±³          ³to de entrada                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a linha esta valida                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo validar a linhaok do rateio dos³±±
±±³          ³itens do documento de entrada                                ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function a920RatLOk()

Local nPPerc    := aScan(aHeader,{|x| AllTrim(x[2]) == "AGH_PERC"} )
Local lRetorno  := .T.
Local nX        := 0

If !aCols[N][Len(aCols[N])]
	If aCols[N][nPPerc] == 0
		Help(" ",1,"A103PERC")
		lRetorno := .F.
	EndIf
EndIf

If lRetorno
	nPercRat := 0
	nPercARat:= 0
	For nX	:= 1 To Len(aCols)
		If !aCols[nX][Len(aCols[nX])]
			nPercRat += aCols[nX][nPPerc]
		EndIf
	Next
	nPercARat := 100 - nPercRat
	If Type("oPercRat")=="O"
		oPercRat:Refresh()
		oPercARat:Refresh()
	Endif
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³a920RatLok ³ Autor ³ Eduardo Riera         ³ Data ³15.10.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Validacao da TudoOk dos itens do rateio dos itens do documen-³±±
±±³          ³to de entrada                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a todas as linhas estao validas             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo validar a tudook do rateio dos ³±±
±±³          ³itens do documento de entrada                                ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function a920RatTok()

Local nPPerc   := aScan(aHeader,{|x| AllTrim(x[2]) == "AGH_PERC"} )
Local nTotal   := 0
Local nX       := 0
Local lRetorno := .T.
Local n_SaveLin

For nX	:= 1 To Len(aCols)
	If !aCols[nX][Len(aCols[nX])]
		nTotal += aCols[nX][nPPerc]
	EndIf
Next
If nTotal > 0 .And. nTotal <> 100
	Help(" ",1,"A103TOTRAT")
	lRetorno := .F.
EndIf

Return(lRetorno) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a920FRat   ºAutor  ³Microsiga           º Data ³  06/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega o vetor dos rateios do pedido                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a920FRat(aHeadAGH,aColsAGH)
Local lQuery    := .T.
Local aStruAGH  := AGH->(dbStruct())
Local cAliasAGH := "AGH" 
Local nX		:= 0
Local nY		:= 0  
Local aBackAGH    := {}
Local cItemAGH  := ""
Local nItemAGH	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Array contendo as registros do AGH           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("AGH")
DbSetOrder(1) // AGH_FILIAL+AGH_NUM+AGH_SERIE+AGH_FORNEC+AGH_LOJA+AGH_ITEMPD+AGH_ITEM
cAliasAGH := "AGH"		

#IFDEF TOP
	If TcSrvType()<>"AS/400"
		lQuery    := .T.
		aStruAGH  := AGH->(dbStruct())
		cAliasAGH := "A120NFISCAL"
		cQuery    := "SELECT AGH.*,AGH.R_E_C_N_O_ AGHRECNO "
		cQuery    += "FROM "+RetSqlName("AGH")+" AGH "
		cQuery    += "WHERE AGH.AGH_FILIAL='"+xFilial("AGH")+"' AND "
		cQuery    += "AGH.AGH_NUM='"+SF2->F2_DOC+"' AND "
		cQuery    += "AGH.AGH_SERIE='"+SF2->F2_SERIE+"' AND "
		cQuery    += "AGH.AGH_FORNEC='"+SF2->F2_CLIENTE+"' AND "
		cQuery    += "AGH.AGH_LOJA='"+SF2->F2_LOJA+"' AND "
		cQuery    += "AGH.D_E_L_E_T_=' ' "
		cQuery    += "ORDER BY "+SqlOrder(AGH->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAGH,.T.,.T.)
		For nX := 1 To Len(aStruAGH)
			If aStruAGH[nX,2]<>"C"
				TcSetField(cAliasAGH,aStruAGH[nX,1],aStruAGH[nX,2],aStruAGH[nX,3],aStruAGH[nX,4])
			EndIf
		Next nX
		
	Else
#ENDIF
		MsSeek(xFilial("AGH")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
#IFDEF TOP
	EndIf
#ENDIF

dbSelectArea(cAliasAGH)
While ( !Eof() .And. ;
		xFilial('AGH') == (cAliasAGH)->AGH_FILIAL .And.;
		SF2->F2_DOC == (cAliasAGH)->AGH_NUM .And.;
		SF2->F2_SERIE == (cAliasAGH)->AGH_SERIE .And.;
		SF2->F2_CLIENTE == (cAliasAGH)->AGH_FORNEC .And.;
		SF2->F2_LOJA == (cAliasAGH)->AGH_LOJA )
	If Empty(aBackAGH)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do aHeader                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SX3")
		DbSetOrder(1)
		MsSeek("AGH")
		While ( !EOF() .And. SX3->X3_ARQUIVO == "AGH" )
			If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"AGH_CUSTO"$SX3->X3_CAMPO
				aadd(aBackAGH,{ TRIM(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_F3,;
					SX3->X3_CONTEXT })
			EndIf
			DbSelectArea("SX3")
			dbSkip()
		EndDo
	EndIf
	aHeadAGH  := aBackAGH
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ADHeadRec("AGH",aHeadAGH)    

	If cItemAGH <> 	(cAliasAGH)->AGH_ITEMPD
		cItemAGH	:= (cAliasAGH)->AGH_ITEMPD
		aadd(aColsAGH,{cItemAGH,{}})
		nItemAGH++
	EndIf

	aadd(aColsAGH[nItemAGH][2],Array(Len(aHeadAGH)+1))
	For nY := 1 to Len(aHeadAGH)
		If IsHeadRec(aHeadAGH[nY][2])
			aColsAGH[nItemAGH][2][Len(aColsAGH[nItemAGH][2])][nY] := IIf(lQuery , (cAliasAGH)->AGHRECNO , AGH->(Recno())  )
		ElseIf IsHeadAlias(aHeadAGH[nY][2])
			aColsAGH[nItemAGH][2][Len(aColsAGH[nItemAGH][2])][nY] := "AGH"
		ElseIf ( aHeadAGH[nY][10] <> "V")
			aColsAGH[nItemAGH][2][Len(aColsAGH[nItemAGH][2])][nY] := (cAliasAGH)->(FieldGet(FieldPos(aHeadAGH[nY][2])))
		Else
			aColsAGH[nItemAGH][2][Len(aColsAGH[nItemAGH][2])][nY] := (cAliasAGH)->(CriaVar(aHeadAGH[nY][2]))
		EndIf
		aColsAGH[nItemAGH][2][Len(aColsAGH[nItemAGH][2])][Len(aHeadAGH)+1] := .F.
	Next nY

	DbSelectArea(cAliasAGH)
	dbSkip()
EndDo

If lQuery
	DbSelectArea(cAliasAGH)
	dbCloseArea()
	DbSelectArea("AGH")
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX3 ºAutor  ³V.Raspa             º Data ³   20.Jul.10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ajusta dicionario de dados ao carregar a rotina             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX3()
Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local cSX3_USADO:= ""

SX3->(DbSetOrder(2))
If SX3->(DbSeek("F3_TIPO")) .And. ;
	AllTrim(SX3->X3_CBOX) <> "L=Nota Em Lote;S=Nota com ISS;B=Beneficiamento;D=Devolucao;C=Complemento;P=Comp. IPI;I=Comp. ICMS"
	RecLock("SX3", .F. )
	SX3->X3_CBOX    := "L=Nota Em Lote;S=Nota com ISS;B=Beneficiamento;D=Devolucao;C=Complemento;P=Comp. IPI;I=Comp. ICMS"
	SX3->X3_CBOXSPA := "L=Nota Em Lote;S=Nota com ISS;B=Beneficiamento;D=Devolucao;C=Complemento;P=Comp. IPI;I=Comp. ICMS"
	SX3->X3_CBOXENG := "L=Nota Em Lote;S=Nota com ISS;B=Beneficiamento;D=Devolucao;C=Complemento;P=Comp. IPI;I=Comp. ICMS"
	SX3->(MsUnLock())
EndIf

If SX3->(DbSeek("D2_DESCZFR")) 
	RecLock("SX3", .F. )
	SX3->X3_PICTURE := "@E 99,999,999,999.99"
	SX3->X3_VALID   := 'MaFisRef("IT_DESCZF","MT100",M->D2_DESCZFR)'
    cSX3_USADO      := X3_USADO
	SX3->(MsUnLock())
EndIf

If SX3->(DbSeek("D2_DESCZFP")) 
	RecLock("SX3", .F. )
	SX3->X3_PICTURE := "@E 99,999,999,999.99"
	SX3->X3_VALID   := 'MaFisRef("IT_DESCZFPIS","MT100",M->D2_DESCZFP)'
    SX3->X3_USADO   := cSX3_USADO
	SX3->(MsUnLock())
EndIf

If SX3->(DbSeek("D2_DESCZFC")) 
	RecLock("SX3", .F. )
	SX3->X3_PICTURE := "@E 99,999,999,999.99"
    SX3->X3_USADO   := cSX3_USADO
	SX3->(MsUnLock())
EndIf

RestArea(aArea)
RestArea(aAreaSX3)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³SF3Canc ºAutor  ³Mauro Gonçalves       º Data ³   20.Jul.10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Verifica se a NF está cancelada. Usada no PE MTVALNF        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SF3Canc(cCodFil,cNroDoc,cSerDoc,cCliFor,cCodLoj)
Local aArea    := GetArea()
local cSF3Canc := "QRYSF3CANC"
local cQuery   := ""    
local lCanc    := ""    

if empty(cCodFil) .or. empty(cNroDoc) .or. empty(cSerDoc) .or. empty(cCliFor) .or. empty(cCodLoj)
   return .f.
endif
   
#IFDEF TOP
	If TcSrvType() <> "AS/400"
		cQuery := "SELECT SF3.* FROM "
		cQuery += RetSqlName("SF3") + " SF3 "
		cQuery += " WHERE "
		cQuery += "F3_FILIAL = '"+cCodFil+"' AND "
		cQuery += "F3_CLIEFOR = '"+cCliFor+"' AND "
		cQuery += "F3_LOJA = '"+cCodLoj+"' AND "
		cQuery += "F3_NFISCAL = '"+cNroDoc+"' AND "
		cQuery += "F3_SERIE = '"+cSerDoc+"' AND "
		cQuery += "F3_DTCANC <> '        '"			
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cSF3Canc,.F.,.T.)
	Else
#ENDIF
 		cSF3Canc := "SF3"
		dbSelectArea("SF3")
		dbSetOrder(4)
		MsSeek(xFilial()+cCliFor+cCodLoj+cNroDoc+cSerDoc)
		#IFDEF TOP
	Endif	
		#ENDIF

lCanc := !(cSF3Canc)->(EOF())
DbSelectArea("QRYSF3CANC")
dbCloseArea()
RestArea(aArea)

return lCanc
