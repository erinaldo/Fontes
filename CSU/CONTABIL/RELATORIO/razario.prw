#Include "CTBR400.Ch"
#Include "PROTHEUS.Ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR400  ³ Autor ³ Cicero J. Silva   	³ Data ³ 04.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Centro de Custo/Conta         			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR400()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//USER Function Razjp(cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,lClVl, cClvlIni, cClvlFim,lSaltLin,lNoMov)
USER Function Razario(cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,lClVl, cClvlIni, cClvlFim,lSaltLin,lNoMov)

Local oReport

Local aArea := GetArea()
Local aCtbMoeda		:= {}

Local cArqTmp		:= ""

Local lOk := .T.
Local lExterno	:= cContaIni <> Nil

DEFAULT lCusto		:= .F.
DEFAULT lItem		:= .F.
DEFAULT lCLVL		:= .F.
DEFAULT lSaltLin	:= .T.

PRIVATE cTipoAnt	:= ""
PRIVATE cPerg	 	:= PADR("CSURAZ",LEN(SX1->X1_GRUPO))
PRIVATE nomeProg  	:= "RAZARIO"


CTBR400R3(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
lClVl, cClvlIni, cClvlFim,lSaltLin,lNoMov )

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR400R3³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05.02.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Raz„o                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR400R3()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function CTBR400R3(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
lClVl, cClvlIni, cClvlFim,lSaltLin,lNoMov)

Local aCtbMoeda	    := {}
Local WnRel			:= "RAZARIO"
Local cDesc1		:= STR0001	//"Este programa ir  imprimir o Raz„o Contabil,"
Local cDesc2		:= STR0002	// "de acordo com os parametros solicitados pelo"
Local cDesc3		:= STR0003	// "usuario."
Local cString		:= "CT2"
Local titulo		:= STR0006 	//"Emissao do Razao Contabil"
Local lAnalitico 	:= .T.
Local lRet			:= .T.
Local nTamLinha	    := 220
Local nTamConta		:= Len(CriaVar ("CT1_CONTA"))
Local cSepara1		:= ""

DEFAULT lCusto		:= .F.
DEFAULT lItem		:= .F.
DEFAULT lCLVL		:= .F.
DEFAULT lSaltLin	:= .T.
DEFAULT lNoMov      := .F.

Private aStrZC      := {} // Sergio em Mai/2009: Mecanismo de deteccao de provisoes manuais
Private aReturn	:= { STR0004, 1,STR0005, 2, 2,"","", 1 }  //"Zebrado"###"Administracao"
Private nomeprog	:= "RAZARIO"
Private aLinha		:= {}
Private nLastKey	:= 0
Private Tamanho 	:= "G"
Private lSalLin		:= .T.
Private lExterno		:= cContaIni <> Nil

MontaZC()
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

CriaPerg()
If !lExterno
	Pergunte("CSURAZ", .F.)
Else
	Pergunte("CTR400", .F.)
EndIf

If ! lExterno
	If ! Pergunte("CSURAZ", .T.)
		Return
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // da conta                              ³
//³ mv_par02            // ate a conta                           ³
//³ mv_par03            // da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Moeda			                     ³ TIRA
//³ mv_par06            // Saldos		                         ³ TIRA
//³ mv_par07            // Set Of Books                          ³ TIRA
//³ mv_par08            // Analitico ou Resumido dia (resumo)    ³ TIRA
//³ mv_par09            // Imprime conta sem movimento?          ³
//³ mv_par10            // Junta Contas com mesmo C.Custo?       ³ TIRA
//³ mv_par11            // Impr Cod (Normal/Reduzida/Cod.Impress)³ TIRA       /// VER CT1_CODIMP
//³ mv_par12            // Imprime C.Custo?                      ³
//³ mv_par13            // Do Centro de Custo                    ³
//³ mv_par14            // At‚ o Centro de Custo                 ³
//³ mv_par15            // Imprime Item?	                     ³
//³ mv_par16            // Do Item                               ³
//³ mv_par17            // Ate Item                              ³
//³ mv_par18            // Imprime Classe de Valor?              ³
//³ mv_par19            // Da Classe de Valor                    ³
//³ mv_par20            // Ate a Classe de Valor                 ³
//³ mv_par21            // Salto de pagina                       ³TIRA
//³ mv_par22            // Pagina Inicial                        ³TIRA
//³ mv_par23            // Pagina Final                          ³TIRA
//³ mv_par24            // Numero da Pag p/ Reiniciar            ³TIRA
//³ mv_par25            // Imprime Cod C.Custo(Normal / Reduzido)³TIRA
//³ mv_par26            // Imprime Cod Item (Normal / Reduzido)  ³TIRA
//³ mv_par27            // Imprime Cod Cl.Valor(Normal /Reduzida)³TIRA
//³ mv_par28            // Imprime Total Geral (Sim/Nao)         ³TIRA
//³ mv_par29            // So Livro/Livro e Termos/So Termos     ³TIRA
//³ mv_par30		  		// Imprime valor 0.00    ?	         ³TIRA
//³ mv_par31		  		//"Salta linha entre contas?"        ³TIRA
//³ mv_par32            // Num.linhas p/ o Razao?				 ³TIRA
//³ mv_par33            // Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr	 ³TIRA
//³ mv_par34            // Descrição na moeda               	 ³TIRA
//³ mv_par35            // Cons.Tamanho Total das Entidade   	 ³TIRA
//³ mv_par36            // Seleciona Filiais?               	 ³TIRA
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aSetOfBook	:= {}

If !lRet
	Set Filter To
	Return
Endif

cNome := "Raz_"+Dtos(Date())
If !lExterno
	wnrel := SetPrint(cString,wnrel,If(! lExterno, cPerg,),@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Else
	aReturn:= { STR0004, 1,STR0005, 2, 2,cNome,"", 1 }  //"Zebrado"###"Administracao"
EndIf
//Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC400
If !lExterno
	mv_par20 := mv_par14
	mv_par19 := mv_par13
	mv_par18 := mv_par12
	mv_par17 := mv_par11
	mv_par16 := mv_par10
	mv_par15 := mv_par09
	mv_par14 := mv_par08
	mv_par13 := mv_par07
	mv_par12 := mv_par06
	mv_par09 := mv_par05
	
	mv_par05 := "01"
	mv_par06 := "1"
	mv_par07 := "   "
	mv_par08 := 1
	mv_par10 := 1
	mv_par11 := 1
	mv_par21 := 2
	mv_par22 := 1
	mv_par23 := 999999
	mv_par24 := 1
	mv_par25 := 1
	mv_par26 := 1
	mv_par27 := 1
	mv_par28 := 1
	mv_par29 := 1
	mv_par30 := 1
	mv_par31 := 2
	mv_par32 := 60
	mv_par33 := 1
	mv_par34 := "01"
	mv_par35 := 2
	mv_par36 := 2
	
	lCusto 	    := Iif(mv_par12 == 1,.T.,.F.)
	lItem		:= Iif(mv_par15 == 1,.T.,.F.)
	lCLVL		:= Iif(mv_par18 == 1,.T.,.F.)
Else  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.
	mv_par01 := cContaIni
	mv_par02 := cContaFim
	mv_par03 := dDataIni
	mv_par04 := dDataFim
	mv_par05 := cMoeda
	mv_par06 := cSaldos
	mv_par07 := cBook
	mv_par09 := If(lNoMov =.T.,1,2)
	mv_par12 := If(lCusto =.T.,1,2)
	mv_par13 := cCustoIni
	mv_par14 := cCustoFim
	mv_par15 := If(lItem =.T.,1,2)
	mv_par16 := cItemIni
	mv_par17 := cItemFim
	mv_par18 := If(lClVl =.T.,1,2)
	mv_par19 := cClVlIni
	mv_par20 := cClVlFim
	mv_par31 := If(lSaltLin==.T.,1,2)
Endif
lAnalitico	:= Iif(mv_par08 == 1,.T.,.F.)
nTamLinha	:= If( lAnalitico, 220, 132)

If !lExterno
	SetDefault(aReturn,cString)
EndIf

If nLastKey = 27
	Set Filter To
	Return
Endif

cPeti    := GetSrvProfString('StartPath','')
If !lExterno
	cArquivo := cGetFile("", "Informe o Diretorio e o nome do Arquivo para Exportação ",,,,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)
Else
	cArquivo := "\razarios\Razario-"+Dtos(Date())+".CSV"    //".XLS"
EndIf

// Testando o destino quando a validade do caminho e arquivo:

If !lExterno
	MemoWrite(cPeti+"teste.txt","teste")
Else
	MemoWrite("\razarios\teste.txt","teste")
EndIf

While .t.
	If !lExterno
		lSucesso := __CopyFile(cPeti+"teste.txt", cArquivo)
	Else
		lSucesso := .T.
	EndIf
	
	If !lSucesso
		If !lExterno
			Alert('O caminho selecionado é invalido => '+cArquivo)
			cArquivo := cGetFile("", "Informe o Diretorio e o nome do Arquivo para Exportação ",,,,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)
		Else
			ConOut("Nao Foi Possivel Copiar o Arquivo de Teste, Verificar a Pasta Razarios")
		EndIf
	Else
		Exit
	EndIf
EndDo

If !lExterno
	RptStatus({|lEnd| CTR400Imp(@lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,;
	lAnalitico,Titulo,nTamlinha,aCtbMoeda, nTamConta)})
Else
	lEnd := .F.
	CTR400Imp(@lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,lAnalitico,Titulo,nTamlinha,aCtbMoeda, nTamConta)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTR400Imp ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Razao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³Ctr400Imp(lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,;      ³±±
±±³           ³          lCLVL,Titulo,nTamLinha,aCtbMoeda)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd       - A‡ao do Codeblock                             ³±±
±±³           ³ wnRel      - Nome do Relatorio                             ³±±
±±³           ³ cString    - Mensagem                                      ³±±
±±³           ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³           ³ lCusto     - Imprime Centro de Custo?                      ³±±
±±³           ³ lItem      - Imprime Item Contabil?                        ³±±
±±³           ³ lCLVL      - Imprime Classe de Valor?                      ³±±
±±³           ³ Titulo     - Titulo do Relatorio                           ³±±
±±³           ³ nTamLinha  - Tamanho da linha a ser impressa               ³±±
±±³           ³ aCtbMoeda  - Moeda                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function CTR400Imp(lEnd,WnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,lAnalitico,Titulo,nTamlinha,;
aCtbMoeda,nTamConta)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSaldo		:= {}
Local aSaldoAnt		:= {}
Local aColunas

Local cArqTmp
Local cSayCusto	    := CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVl		:= CtbSayApro("CTH")

Local cDescMoeda
Local cMascara1
Local cMascara2
Local cMascara3
Local cMascara4
Local cPicture
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cSaldo		:= mv_par06
Local cContaIni	    := mv_par01
Local cContaFIm	    := mv_par02
Local cCustoIni	    := mv_par13
Local cCustoFim	    := mv_par14
Local cItemIni		:= mv_par16
Local cItemFim		:= mv_par17
Local cCLVLIni		:= mv_par19
Local cCLVLFim		:= mv_par20

Local cContaAnt	    := ""
Local cDescConta	:= ""
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cResCLVL		:= ""
Local cDescSint	    := ""
Local cMoeda		:= mv_par05
Local cContaSint	:= ""
Local cNormal 		:= ""

Local dDataAnt		:= CTOD("  /  /  ")
Local dDataIni		:= mv_par03
Local dDataFim		:= mv_par04

Local lNoMov		:= Iif(mv_par09==1,.T.,.F.)
Local lSldAnt		:= Iif(mv_par09==3,.T.,.F.)
Local lJunta		:= Iif(mv_par10==1,.T.,.F.)
Local lSalto		:= Iif(mv_par21==1,.T.,.F.)
Local lFirst		:= .T.
Local lImpLivro		:= .T.
Local lImpTermos	:= .f.
Local lPrintZero	:= Iif(mv_par30==1,.T.,.F.)

Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nPagIni		:= mv_par22
Local nReinicia 	:= mv_par24
Local nPagFim		:= mv_par23
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local nCont			:= 0
Local l1StQb 		:= .T.
Local lQbPg			:= .F.
Local lEmissUnica	:= If(GetNewPar("MV_CTBQBPG","M") == "M",.T.,.F.)			/// U=Quebra única (.F.) ; M=Multiplas quebras (.T.)
Local lNewPAGFIM	:= If(nReinicia > nPagFim,.T.,.F.)
Local LIMITE		:= If(TAMANHO=="G",220,If(TAMANHO=="M",132,80))
Local nInutLin		:= 1
Local nMaxLin   	:= mv_par32

Local nBloco		:= 0
Local nBlCount		:= 0

Local lSldAntCta	:= Iif(mv_par33 == 1, .T.,.F.)
Local lSldAntCC		:= Iif(mv_par33 == 2, .T.,.F.)
Local lSldAntIt  	:= Iif(mv_par33 == 3, .T.,.F.)
Local lSldAntCv  	:= Iif(mv_par33 == 4, .T.,.F.)

Local oMeter,oText,oDlg

Local nTotRegs := 0

lSalLin		:= If(mv_par31 ==1 ,.T.,.F.)
m_pag    := 1

If !lAnalitico							   	// Relatorio Analitico
	lCusto := .F.
	lItem  := .F.
	lCLVL  := .F.
EndIf

m_pag := mv_par22

If lImpLivro
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lExterno
		MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
		CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
		cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
		aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,aReturn[7],lSldAnt)},;
		"Gerando o arquivo de Razario",;		// "Criando Arquivo Tempor rio..."
		"Razario")		// "Emissao do Razao"
	Else
		CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
		cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
		aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,aReturn[7],lSldAnt)
	EndIf
	
	dbSelectArea("CT2")
	If !Empty(dbFilter())
		dbClearFilter()
	Endif
	dbSelectArea("cArqTmp")
	If !lExterno
		SetRegua(RecCount())
	EndIf
	dbGoTop()
Endif


// Sergio em Jun/2008: Obter a descricao da conta principal do razao:

Private cDirDocs := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt  := CriaTrab(Nil,.f.)
Private cCmd     := cDirDocs+"\"+cTmpTxt+".txt"
Private cPosic   := ""

cArqTmp->( DbGoTop() )

/*
dbSelectArea("cArqTmp")
cArqTmp->(dbGoTop())
cArqTmp->( dbEval( { || nTotRegs++ },,{ || !Eof() } ) )
cArqTmp->(dbGoTop())

If !lExterno
SetRegua(nTotRegs)
EndIf
While !cArqTmp->( Eof() )

If !lExterno
IncRegua()
EndIf
cArqTmp->( RecLock("cArqTmp",.f.) )


cArqTmp->( DbSkip() )

ENDDO

cArqTmp->( DbGoTop() )
DbSelectArea("cArqTmp")
*/
//----------------------------------
///////////////////GerarTXT( cCmd , cArquivo )  //Gerar arquivo .CSV
//----------------------------------

/*
COPY TO &(cCmd) VIA "DBFCDX"

lSucesso := __CopyFile( cCmd , cArquivo)

If !lExterno
If !lSucesso
Alert('Nao foi possivel copiar o arquivo '+cArquivo)
Else
Alert('Verificar o arquivo '+cArquivo)
EndIf
Else
If !lSucesso
ConOut("Nao foi possivel copiar o arquivo "+cArquivo)
Else
ConOut("Verificar o arquivo "+cArquivo)
EndIf
EndIf
*/

Ferase( cCmd )

If Select("cAliasCT2") > 0
	cAliasCT2->( DbCloseArea() )
EndIf

If lImpLivro
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIf
Endif

dbselectArea("CT2")

If !lExterno
	MS_FLUSH()
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGerRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria Arquivo Temporario para imprimir o Razao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim³±±
±±³			  ³cCustoIni,cCustoFim,cItemIni,cItemFim,cCLVLIni,cCLVLFim,    ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo,lAnalit)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ ExpL4 = Indica se imprime analitico ou sintetico           ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,lAnalit,c2Moeda,;
nTipo,cUFilter,lSldAnt)

Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO")
Local aTamVal	:= TAMSX3("CT2_VALOR")
Local aCtbMoeda	:= {}
Local aSaveArea := GetArea()
Local aCampos

Local cChave

Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamCLVL	:= Len(CriaVar("CTH_CLVL"))
Local nDecimais	:= 0
Local cMensagem		:= STR0030// O plano gerencial nao esta disponivel nesse relatorio.

DEFAULT c2Moeda := ""
DEFAULT nTipo	:= 1
DEFAULT cUFilter:= ""
DEFAULT lSldAnt		:= .F.
If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'Razario' .And. TCGetDb() $ "MSSQL7/MSSQL"
	DEFAULT cUFilter	:= ".T."
Else
	DEFAULT cUFilter	:= ""
Endif

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := 2  // //aCtbMoeda[5]
// Retirada das variavies CT2_EMPORI e CT2_SEQUHIS do array aCampos confore conteudo OS2505-11 Jose Maria 26/09/2011
//			{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
//			{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original

aCampos :={	{ "CONTA"		, "C", aTamConta[1], 0 },;  		// Codigo da Conta
{ "DESCCON"    	, "C", TamSX3("CT1_DESC01")[1] , 0 },;		// Descricao da Conta
{ "XPARTIDA"   	, "C", aTamConta[1] , 0 },;		// Contra Partida
{ "XPARTIDADS" 	, "C", TamSX3("CT1_DESC01")[1] , 0 },;		// Descricao da Conta XPARTIDA
{ "TIPO"       	, "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
{ "LANCDEB"		, "N", aTamVal[1]+2, nDecimais },; // Debito
{ "LANCCRD"		, "N", aTamVal[1]+2	, nDecimais },; // Credito
{ "SALDOSCR"	, "N", aTamVal[1]+2, nDecimais },; 			// Saldo
{ "TPSLDANT"	, "C", 01, 0 },; 					// Sinal do Saldo Anterior => Consulta Razao
{ "TPSLDATU"	, "C", 01, 0 },; 					// Sinal do Saldo Atual => Consulta Razao
{ "HISTORICO"	, "C", 160      	, 0 },;			// Historico             - Sergio em Jul/2008
{ "CCUSTO"		, "C", aTamCusto[1], 0 },;			// Centro de Custo
{ "ITEM"		, "C", nTamItem		, 0 },;			// Item Contabil
{ "CLVL"		, "C", nTamCLVL		, 0 },;			// Classe de Valor
{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
{ "LOTE" 		, "C", 06			, 0 },;			// Lote
{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
{ "DOC" 		, "C", 06			, 0 },;			// Documento
{ "LINHA"		, "C", 03			, 0 },;			// Linha
{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
{ "CODINVEST"	, "C", 10			, 0 },;			// Codigo Investimento      OS2505-11  Jose Maria 21/09/2011
{ "ITINVEST"	, "C", 04			, 0 },;			// Item Codigo Investimento OS2505-11  Jose Maria 21/09/2011
{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico         OS2725-11  Jose Maria 05/12/2011
{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original         OS2725-11  Jose Maria 05/12/2011
{ "FILORI"		, "C", 02			, 0 },;			// Filial Original
{ "ID_PROVIS"	, "C", 04      	    , 0 },;			// ID de Provisao Manual - Sergio em Mai/2009
{ "USERINC"     , "C", 30      	    , 0 },;			// Responsavel pela Inclusao  - Sergio em Set/2009
{ "DTINC"       , "D", 08      	    , 0 },;			// Data da Inclusao           - Sergio em Set/2009
{ "HRINC"       , "C", 08      	    , 0 },;			// Hora da Inclusao           - Sergio em Set/2009
{ "USERUPD"     , "C", 30      	    , 0 },;			// Responsavel pela Alteracao - Sergio em Set/2009
{ "DTUPD"       , "D", 08      	    , 0 },;			// Data da Alteracao          - Sergio em Set/2009
{ "HRUPD"       , "C", 08      	    , 0 },;			// Hora da Alteracao          - Sergio em Set/2009/* { "NOMOV"		, "L", 01			, 0 },;		Conta Sem Movimento */
{ "CC_GESTOR"   , "C", 20           , 0 },;        // CENTRO DE CUSTO GESTOR
{ "ULTLIN"      , "C", 200     	    , 0 },;			// Os campos abaixo esta totalizados nesse item, performance de relatorio
{ "NR_PED"      , "C", 06      	    , 0 },;			// Registro Origem
{ "NR_PROV"     , "C", 06      	    , 0 },;			// Registro Origem
{ "NR_DOC"      , "C", 09      	    , 0 },;			// Registro Origem
{ "NATUREZ"     , "C",TAMSX3('ED_CODIGO')[1], 0 },;			// Registro Origem
{ "COD_FOR"     , "C", 06      	    , 0 },;			// Registro Origem
{ "NOM_FOR"     , "C",TAMSX3('A2_NOME')[1], 0 },;			// Registro Origem
{ "COD_CLI"     , "C", 06      	    , 0 },;			// Registro Origem                                        // Tatiana
{ "NOM_CLI"     , "C", TAMSX3('A1_NOME')[1], 0 },;			// Registro Origem                        // Tatiana
{ "RECDES"      , "N", 10      	    , 0 },;			// Recno do Registro.
{ "RECORI"      , "N", 10      	    , 0 },;			// Registro Origem
{ "TABORI"      , "C", 03      	    , 0 },;			// Tabela Origem.
{ "ORIGEM"      , "C", 20      	    , 0 },;  		// Registro Origem
{ "FILIAL_ORI"  , "C", 02      	    , 0 },;		    // Filial Origem
{ "DESC_MAKRO"  , "C", 20      	    , 0 },;			// Descricao Makro
{ "DESC_LAN"    , "C", 40      	    , 0 }}			// Descricao Makro

If cPaisLoc = "CHI"
	Aadd(aCampos,{"SEGOFI","C",TamSx3("CT2_SEGOFI")[1],0})
EndIf
If ! Empty(c2Moeda)
	Aadd(aCampos, { "LANCDEB_1"	, "N", aTamVal[1]+2, nDecimais }) // Debito
	Aadd(aCampos, { "LANCCRD_1"	, "N", aTamVal[1]+2, nDecimais }) // Credito
	Aadd(aCampos, { "TXDEBITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Debito
	Aadd(aCampos, { "TXCREDITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Credito
Endif

cArqTmp := CriaTrab(aCampos, .T.)
If ( Select ( "cArqTmp" ) <> 0 )
	dbSelectArea ( "cArqTmp" )
	dbCloseArea ()
Endif

dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"			// Razao por Conta
	If FunName() <> "CTBC400"
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"  //OS2505-11 Jose Maria 26/09/2011
		//cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+FILORI"       //comentado OS 2725-11 Jose Maria 05/12/2011
	Else
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"  //OS2505-11 Jose Maria 26/09/2011
		//cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+FILORI+LINHA"       //comentado OS 2725-11 Jose Maria 05/12/2011
	EndIf
ElseIf cTipo == "2"		// Razao por Centro de Custo
	If lAnalit 				// Se o relatorio for analitico
		If FunName() <> "CTBC440"
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"  //OS2505-11 Jose Maria 26/09/2011			//cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+FILORI" //comentado OS 2725-11 Jose Maria 05/12/2011
		Else
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"	//OS2505-11 Jose Maria 26/09/2011
			//cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+FILORI+LINHA"	//comentado OS 2725-11 Jose Maria 05/12/2011
		EndIf
	Else
		cChave 	:= "CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"            //OS2505-11 Jose Maria 26/09/2011
		//cChave 	:= "CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+FILORI" //comentado OS 2725-11 Jose Maria 05/12/2011
	Endif
ElseIf cTipo == "3" 		//Razao por Item Contabil
	If lAnalit 				// Se o relatorio for analitico
		If FunName() <> "CTBC480"
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"   //OS2505-11 Jose Maria 26/09/2011
			//cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+FILORI" //comentado OS 2725-11 Jose Maria 05/12/2011
		Else
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"   //OS2505-11 Jose Maria 26/09/2011
			//cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+FILORI+LINHA" //comentado OS 2725-11 Jose Maria 05/12/2011
		Endif
	Else
		cChave 	:= "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"             //OS2505-11 Jose Maria 26/09/2011
		//cChave 	:= "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+FILORI" //comentado OS 2725-11 Jose Maria 05/12/2011
	Endif
ElseIf cTipo == "4"		//Razao por Classe de Valor
	If lAnalit 				// Se o relatorio for analitico
		If FunName() <> "CTBC490"
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"   //OS2505-11 Jose Maria 26/09/2011
			//cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+FILORI" //comentado OS 2725-11 Jose Maria 05/12/2011
		Else
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"   //OS2505-11 Jose Maria 26/09/2011
			//cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+FILORI+LINHA" //comentado OS 2725-11 Jose Maria 05/12/2011
		EndIf
	Else
		cChave 	:= "CLVL+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"   //OS2505-11 Jose Maria 26/09/2011
		//cChave 	:= "CLVL+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+FILORI" //comentado OS 2725-11 Jose Maria 05/12/2011
	Endif
EndIf

IndRegua("cArqTmp",cArqTmp,cChave,,,STR0017)  //"Selecionando Registros..."
dbSelectArea("cArqTmp")
dbSetIndex(cArqTmp+OrdBagExt())
dbSetOrder(1)

//If !Empty(aSetOfBook[5])
//	MsgAlert(cMensagem)
//	Return
//EndIf

CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
aSetOfBook,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt)

RestArea(aSaveArea)

Return cArqTmp


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbQryRaz ³ Autor ³ Simone Mie Sato       ³ Data ³ 22/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,	   ³±±
±±³			  ³	cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,  ³±±
±±³			  ³	cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,  ³±±
±±³			  ³	cTipo)                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
aSetOfBook,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt)

Local aSaveArea := GetArea()
Local nMeter	:= 0
Local cQuery	:= ""
Local aTamVlr	:= TAMSX3("CT2_VALOR")
Local lNoMovim	:= .F.
Local cContaAnt	:= ""
Local cCampUSU	:= ""
local aStrSTRU	:= {}
Local nStr		:= 0

Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
// se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.

DEFAULT lSldAnt := .F.

If !lExterno
	oMeter:SetTotal(CT2->(RecCount()))
	oMeter:Set(0)
EndIf

cQuery	:= " SELECT ISNULL(CT2_LP,'') ORIGEM, CT2_ORIGEM  ULTLIN, CT1_CONTA CONTA, ISNULL(CT2_CCD,'') CUSTO,ISNULL(CT2_ITEMD,'') ITEM, ISNULL(CT2_CLVLDB,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'') SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_CREDIT,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '1' TIPOLAN, "
////cQuery	+= " CT2_ORIGEM  ULTLIN, "
cQuery	+= " ISNULL(CT2_USERGA,'') LGA, ISNULL(CT2_X_USRI,'') USRI, ISNULL(CT2_X_DTIN,'') DTIN, ISNULL(CT2_X_HRIN,'') HRIN, ISNULL(CT2_X_HRUP,'') HRUP, ISNULL(CT2_X_USRA,'') USRA, ISNULL(CT2_X_DTAL,'') DTAL , CT2_ORIGEM CT2ORIGEM ,CT2_FILORI FILORI, CT2_ORIGEM CONTEUDO, ISNULL(CT2.R_E_C_N_O_,'')   RECNO2,  "
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"
If cPaisLoc == "CHI"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf
cQuery	+= " FROM "+ RetSqlName("CT1") + " CT1 JOIN " + RetSqlName("CT2") + " CT2 "
cQuery	+= " ON CT2.CT2_FILIAL = '"+xFilial("CT2")+"' "
cQuery	+= " AND CT2.CT2_DEBITO = CT1.CT1_CONTA"
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCD >= '" + cCustoIni + "' AND CT2.CT2_CCD <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMD >= '" + cItemIni + "' AND CT2.CT2_ITEMD <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_CLVLDB >= '" + cClvlIni + "' AND CT2.CT2_CLVLDB <= '" + cClVlFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '1' OR CT2.CT2_DC 	= '3' OR CT2.CT2_DC = '4') " // Serjin
//cQuery  += " AND CT2_VALOR <> 0 "                                              // Serjin
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = '' "
cQuery	+= " UNION "
cQuery	+= " SELECT ISNULL(CT2_LP,'') ORIGEM, CT2_ORIGEM  ULTLIN, CT1_CONTA CONTA, ISNULL(CT2_CCC,'') CUSTO, ISNULL(CT2_ITEMC,'') ITEM, ISNULL(CT2_CLVLCR,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'')SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_DEBITO,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '2' TIPOLAN, "
////cQuery	+= " CT2_ORIGEM ULTLIN, "
cQuery	+= " ISNULL(CT2_USERGA,'') LGA, ISNULL(CT2_X_USRI,'') USRI, ISNULL(CT2_X_DTIN,'') DTIN, ISNULL(CT2_X_HRIN,'') HRIN, ISNULL(CT2_X_HRUP,'') HRUP, ISNULL(CT2_X_USRA,'') USRA, ISNULL(CT2_X_DTAL,'') DTAL , CT2_ORIGEM CT2ORIGEM ,CT2_FILORI FILORI, CT2_ORIGEM CONTEUDO,  ISNULL(CT2.R_E_C_N_O_,'')  RECNO2,  "
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"
If cPaisLoc == "CHI"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf
cQuery	+= " FROM "+RetSqlName("CT1")+ ' CT1 JOIN '+ RetSqlName("CT2") + ' CT2 '
cQuery	+= " ON CT2.CT2_FILIAL = '"+xFilial("CT2")+"' "
cQuery	+= " AND CT2.CT2_CREDIT =  CT1.CT1_CONTA "
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCC >= '" + cCustoIni + "' AND CT2.CT2_CCC <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMC >= '" + cItemIni + "' AND CT2.CT2_ITEMC <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_CLVLCR >= '" + cClvlIni + "' AND CT2.CT2_CLVLCR <= '" + cClVlFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3' OR CT2.CT2_DC = '4' ) " // Serjin
//cQuery  += " AND CT2_VALOR <> 0 "                                            // Serjin
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = ''"
cQuery	+= " ORDER BY CONTA, DDATA, LOTE, DOC, LINHA "

cQuery := ChangeQuery(cQuery)

MemoWrite('C:\temp\qraz.sql', cQuery)

If Select("cArqCT2") > 0
	dbSelectArea("cArqCT2")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)
TcSetField("cArqCT2","CT2_VLR"+cMoeda,"N",aTamVlr[1],aTamVlr[2])
TcSetField("cArqCT2","DDATA","D",8,0)

If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
		If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
			TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
		EndIf
	Next
Endif

dbSelectarea("cArqCT2")
If Empty(cUFilter)
	cUFilter := ".T."
Endif

cStartPath := GetSrvProfString( "Startpath", "" )
cDirDocs := cPeti
cTmpTxt1 := CriaTrab(Nil,.f.)
cCmd     := cDirDocs+cTmpTxt1+".CSV"
_nPos    := at(".",CCMD)
cCmd     := SubStr( cCmd, 1 , IIF(_nPos>0,_nPos-1,Len(cCmd)) ) + ".CSV"
_nPos    := at(".",cArquivo)
cArquivo := SubStr( cArquivo, 1 , IIF(_nPos>0,_nPos-1,Len(cArquivo)) ) + ".CSV"

nhOut := fCreate( cCmd )

If nhOut == -1
	MsgStop("Erro ao criar arquivo ...")
Endif

DbSelectArea("cArqTmp")
aStruct := dBStruct()
cOutLine := ""

For _xy := 1 to Len(aStruct)
	
	If !aStruct[_xy][1] $ "SEQHIST/EMPORI/ULTLIN"              //Nao grava do .CSV esse campo conforme OS 2505-11,OS 2725-11  Jose Maria 05/12/2011
		cOutLine := cOutLine + aStruct[_xy][1] + If( _xy < Len(aStruct) , ";" ,"")
	Endif
	
Next _xy

cOutLine +=  Chr( 13 ) + Chr( 10 )  //CRLF

fWrite( nHOut,  cOutLine )

/////fClose( nhOut )

Dbselectarea("CT2")
nTotRegs := 0
cArqCT2->(dbGoTop())
cArqCT2->( dbEval( { || nTotRegs++ },,{ || !Eof() } ) )
cArqCT2->(dbGoTop())

If !lExterno
	SetRegua(nTotRegs)
EndIf

While !Eof()
	If !lExterno
		IncRegua()
	EndIf
	cOutLine := ""
	
	If Empty(cArqCT2->DDATA) //Se nao existe movimento
		cContaAnt	:= cArqCT2->CONTA
		dbSkip()
	Endif
	
	If &("cArqCT2->("+cUFilter+")")
		////		RecLock("cArqTmp",.T.)
		
		cOutLine += alltrim(cArqCT2->CONTA)+";"         /////////////   CONTA
		_DESCCON    := Posicione( "CT1", 1,xFilial("CT1")+cArqCt2->CONTA, "CT1_DESC01" )
		cOutLine +=ALLTRIM(_DESCCON)+";"                 ////////////  DESCCON
		////		cOutLine +=alltrim(cArqCT2->CONTA)+";"
		
		If lImpCPartida
			cOutLine +=alltrim(cArqCT2->XPARTIDA)+";"   /////  xpartida
		EndIf
		
		_XPARTIDADS := Posicione( "CT1", 1,xFilial("CT1")+cArqCt2->XPARTIDA, "CT1_DESC01" )
		cOutLine +=alltrim(_XPARTIDADS)+";"   /////  xpartidas
		cOutLine +=alltrim(cArqCT2->DC)+";"   /////  tipo
		
		If cArqCT2->TIPOLAN = '1'
			cOutLine +=			alltrim(Transform(cArqCT2->VALOR,"@E "+Replicate("9",aStruct[6][3])+"."+Replicate("9",aStruct[6][4]) ))+";"    /////ALLTRIM(str(cArqCT2->VALOR))+";"  //// lancdeb
		else
			cOutLine += ';'
		EndIf
		
		If cArqCT2->TIPOLAN = '2'
			cOutLine +=			alltrim(Transform(cArqCT2->VALOR,"@E "+Replicate("9",aStruct[6][3])+"."+Replicate("9",aStruct[6][4]) ))+";"  ///// LANCCRD
		else
			cOutLine += ';'
		EndIf
		
		cOutLine +=";"  ////////////  SALDOSCR
		cOutLine +=";"  ////////////  TPSLDANT
		cOutLine +=";"  //////////// TPSLDATU
		
		dbSelectArea("CT2")
		dbSetOrder(10)
		// Retirada das variavies CT2_EMPORI e CT2_SEQUHIS confore conteudo OS2505-11 Jose Maria 26/09/2011
		////	If msseek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)  //OS2505-11 Jose Maria 26/09/2011
		
		_HISTORICO	:=  cArqCT2->HIST
		If msseek(xFilial("CT2")+cArqCT2->(cArqCT2->(DTOS(DDATA)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI)),.F.)  //OS2505-11 Jose Maria 26/09/2011
			CT2->(dbSkip())
			
			If CT2->CT2_DC == "4"
				//CT2->CT2_EMPORI == cArqTmp->EMPORI	.And.; //OS2505-11 Jose Maria 26/09/2011
				While !CT2->(Eof()) .And. 	CT2->CT2_FILIAL == xFilial("CT2") 			.And.;
					CT2->CT2_LOTE == cArqCT2->LOTE 		.And.;
					CT2->CT2_SBLOTE == cArqCT2->SUBLOTE 	.And.;
					CT2->CT2_DOC == cArqCT2->DOC 			.And.;
					CT2->CT2_SEQLAN == cArqCT2->SEQLAN 	.And.;
					CT2->CT2_EMPORI == cArqCT2->EMPORI	.And.;
					CT2->CT2_FILORI == cArqCT2->FILORI	.And.;
					CT2->CT2_DC == "4" 					.And.;
					DTOS(CT2->CT2_DATA) == DTOS(cArqCT2->DDATA)
					
					_HISTORICO := _Historico+" "+AllTrim( Subs(CT2->CT2_HIST,1,40) )
					
					CT2->(dbSkip())
				EndDo
			EndIf
		EndIf
		
		aArq :=  {}
		_CODINVEST := ""
		_ITINVEST  := ""
		aArq := ULTLIN()   /////  pega informacoes do final do arquivo
		

		If	Empty(_CODINVEST) .and. alltrim(aArq[12]) == "ZF1"  // OS 2014/15 By Douglas David
			_CODINVEST := Alltrim(aArq[17])
		Endif  

		
		xCampo := StrTran(_historico, ";", "")
		cOutLine +=alltrim(xCampo)+";"            ///////  historico
		cOutLine +=alltrim(cArqCT2->CUSTO)+";"            /////// ccusto
		cOutLine +=alltrim(cArqCT2->ITEM)+";"            ///////  item
		cOutLine +=alltrim(cArqCT2->CLVL)+";"            ///////  clvl
		cOutLine += dtoc(cArqCT2->DDATA)+";"                 ///////  Datal
		cOutLine +=alltrim(cArqCT2->LOTE)+";"            ///////  Lote
		cOutLine +=alltrim(cArqCT2->SUBLOTE)+";"            ///////  sublote
		cOutLine +=alltrim(cArqCT2->DOC)+";"            ///////  doc
		cOutLine +=alltrim(cArqCT2->LINHA)+";"            ///////  linha
		cOutLine +=alltrim(cArqCT2->SEQLAN)+";"            ///////  seqlan
		cOutLine += alltrim(_CODINVEST)+";" //////////////////CODINVEST
		cOutLine += alltrim(_ITINVEST)+";" ////////////////// ITINVEST
		/////		cOutLine +=alltrim(cArqCT2->SEQHIS)+" ;" //OS2505-11 Jose Maria 21/09/2011  //// seqhist
		////		cOutLine +=alltrim(cArqCT2->EMPORI)+" ;"    //OS2505-11 Jose Maria 21/09/2011         //// empori
		cOutLine +=alltrim(cArqCT2->FILORI)+";"            ///////  filori
		
		// Sergio em Mai/2009: Gravacao do identificador de provisao e estorno de provisao para
		//                     a exportacao do Data WareHouse:
		// a-) Verificar se o LP em questao esta cadastrado na tabela ZC(prioridade);
		nAxoZC := Ascan( aStrZC, { |y| Trim(y[1]) == Trim( cArqCT2->LOTE )  } )
		If nAxoZC > 0
			cOutLine +=aStrZC[nAxoZC][2]+";"            ///////  ITPROVIS
		ELSE
			cOutLine += ";"
		EndIf
		
		If CT2->( FieldPos('CT2_X_USRI') ) > 0
			
			cOutLine +=alltrim(Carqct2->USRI)+";"  // Responsavel pela Inclusao    - Sergio em Set/2009  //// USER INC
			cOutLine +=SUBSTR(cArqCT2->DTIN,7,2)+"/"+SUBSTR(cArqCT2->DTIN,5,2)+"/"+SUBSTR(cArqCT2->DTIN,1,4)+";"   // Data da Inclusao       - Sergio em Set/2009 ///// DTINC
			cOutLine +=alltrim(carqct2->HRIN)+";"  // Hora da Inclusao             - Sergio em Set/2009 /////HRINC
			cOutLine +=alltrim(carqct2->USRA)+";"       // Responsavel pela Alteracao - Sergio em Set/2009 ////USERUPD
			cOutLine +=SUBSTR(cArqCT2->DTAL,7,2)+"/"+SUBSTR(cArqCT2->DTAL,5,2)+"/"+SUBSTR(cArqCT2->DTAL,1,4)+";" // Data da Alteracao - Sergio em Set/2009            ///////  historico ///// DTUPD
			cOutLine +=alltrim(carqct2->HRUP)+";" // Hora da Alteracao            - Sergio em Set/2009            ///////  HRUPD
			
			/////				cArqTmp->RECDES  := carqct2->RECNO2
			////				cArqTmp->ORIGEM  := carqct2->ORIGEM
			////				_nRegCT5:=PosCt5(ALLTRIM(carqct2->ORIGEM))
			
		ENDIF
		
		cOutLine +=  alltrim(aArq[1])+";"+alltrim(aArq[2])+";"+alltrim(aArq[3])+";"+alltrim(aArq[4])+";"+alltrim(aArq[5])+";"+alltrim(aArq[6])+";"+alltrim(aArq[7])+";"+alltrim(aArq[8])+";"+alltrim(aArq[9])+";"+alltrim(aArq[10])+";"+alltrim(aArq[11])+";"+alltrim(aArq[12])+";"
		
		///    	cOutLine += "CC GESTOR    NR_PED                 ;NR_PROV               ;NR_DOC;                NATUREZ;              COD_FOR;        NOM_FOR;              COD_CLI;               NOM_CLI;             RECDES          ;  RECORI ;             tabori     ;"  ///////////////FILIAL_ORI"
		
		///		_Ultlin := ALLTRIM(SUBSTR(Carqct2->ULTLIN,50,200))  ///// ULTLIN-  NRPED-     NRPROV-     NRDOC-    NATUREZ-     CODFOR-     NOMFOR-     CODCLI-     NOMCLI-    RECDES    -TABORI-                	                                 ORIGEM-FILIALORI-DESCMAKRO-DESCLAN
		/////		cOutLine += alltrim(aArq[2])+";"+alltrim(aArq[3])+";"+alltrim(aArq[4])+";"+alltrim(aArq[5])+";"+alltrim(aArq[6])+";"+alltrim(aArq[7])+";"+alltrim(aArq[8])+";"+alltrim(aArq[9])+";"+alltrim(aArq[10])+";"+alltrim(aArq[12])+";"+alltrim(aArq[11])+";"
		cOutline += alltrim(aArq[13])+";"     //////////////alltRIM(SUBSTR(carqct2->ORIGEM,1,20))+";"   ///// CT2_ORIGEM
		cOutline += alltrim(aArq[14])+";"   //////////// Filial_ORI
		if !Empty(alltrim(aArq[12])) .AND. alltrim(aArq[12]) <> "ZB8" .AND. alltrim(aArq[12]) <> "ZF1" .AND. alltrim(aArq[16]) != ";"
			cOutline += alltrim(aArq[15])+";"
			cOutline += alltrim(aArq[16])
		ElseIf alltrim(aArq[16]) == ";"
			//////////DESC_MAKRO
			//cOutline += alltrim(aArq[15])+";"     /////////DESC_LAN
			cOutline += alltrim(aArq[15])
			//cOutline += alltrim(aArq[15])     /////////DESC_LAN
			/////		cOutLine +=" F I M " ///////////// TIRAR
		Elseif alltrim(aArq[12]) == "ZF1"
			cOutline += alltrim(aArq[15])+";"
			cOutline += alltrim(aArq[16])
			
		Elseif Empty(alltrim(aArq[12])) .AND. alltrim(aArq[16]) != ";"
			cOutline += alltrim(aArq[15])+";"
			cOutline += alltrim(aArq[16])
		Else
			cOutline += alltrim(aArq[15])
		EndIf
		cOutLine += Chr( 13 ) + Chr( 10 )  //CRLF                                       z
		
		fWrite( nHOut,  cOutLine )
		
		/////		MsUnlock()
		
	EndIf
	lNoMovim	:= .F.
	dbSelectArea("cArqCT2")
	dbSkip()
	nMeter++
	If !lExterno
		oMeter:Set(nMeter)
	EndIf
	
Enddo

fClose( nhOut )

lSucesso := __CopyFile(cCmd, cArquivo)

Ferase( cCMD )

RestArea(aSaveArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ MontaZC  ºAutor  ³ Sergio Oliveira    º Data ³  Maio/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta o array aStrZC para preencher a coluna do identifica-º±±
±±º          ³ cao                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ xCtbr400.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaZC()

Local nConta := 1
Local cTxt

SX5->( DbSetOrder(1), msseek( xFilial('SX5')+"ZC",.t. ) )

While !SX5->( Eof() ) .And. SX5->(X5_FILIAL+X5_TABELA) == xFilial('SX5')+"ZC"
	
	If nConta == 2
		nConta := 1
		cTxt   := "EST"
	Else
		cTxt   := "PROV"
	EndIf
	
	Aadd( aStrZC, { SX5->X5_CHAVE, cTxt } )
	
	nConta ++
	
	SX5->( DbSkip() )
	
EndDo

Return

Static Function PosSd1(_cFilial,_cPedido,         _cFornece,      _cLoja,_cDoc,_cSerie)
Local _nRecno:=0
IF SELECT('TM1')>0
	DBSELECTAREA('TM1')
	DBCLOSEAREA()
ENDIF
_cQuery:= " SELECT R_E_C_N_O_ RECNO1 "
_cQuery+= " FROM "+RetSqlName('SD1')
_cQuery+= " WHERE  "
IF !EMPTY(_cfilial)
	_cQuery+= " D1_FILIAL = '"+_cFilial+"' AND "
ENDIF
IF !EMPTY(_cPedido)
	_cQuery+= " D1_PEDIDO = '"+_cPedido+"' AND "
ENDIF
IF !EMPTY(_cFornece)
	_cQuery+= " D1_FORNECE = '"+_cFornece+"' AND "
ENDIF
IF !EMPTY(_cLoja)
	_cQuery+= " D1_LOJA = '"+_cLoja+"' AND "
ENDIF
IF !EMPTY(_cDoc)
	_cQuery+= " D1_DOC = '"+_cDoc+"' AND "
ENDIF
IF !EMPTY(_cSerie)
	_cQuery+= " D1_SERIE = '"+_cSerie+"' AND "
ENDIF

_cQuery+= "D_E_L_E_T_ = ' ' "
//ALERT('QUERY: '+_cQuery)

TCQUERY _cQuery New Alias "TM1"
DBSELECTAREA('TM1')
DBGOTOP()
IF ! EOF()
	_nRecno:=TM1->RECNO1
ENDIF
Return(_nRecno)


Static Function PosCt5(_cOrigem)
Local _nRecno:=0
IF SELECT('TM1')>0
	DBSELECTAREA('TM1')
	DBCLOSEAREA()
ENDIF
_cQuery:= " SELECT R_E_C_N_O_ RECNO1 "
//_cQuery:= " SELECT CT5_X_DESC DESC1 "
_cQuery+= " FROM "+RetSqlName('CT5')
_cQuery+= " WHERE  "
_cQuery+= " CT5_ORIGEM LIKE '%"+ALLTRIM(_cOrigem)+"%' AND "
_cQuery+= "D_E_L_E_T_ = ' ' "
TCQUERY _cQuery New Alias "TM1"
DBSELECTAREA('TM1')
DBGOTOP()
IF ! EOF()
	_nRecno:=TM1->RECNO1
ENDIF
IF SELECT('TM1')>0
	DBSELECTAREA('TM1')
	DBCLOSEAREA()
ENDIF
Return(_nRecno)



Static Function GerarTXT( cCmd , cArquivo )

Local aCampos

Local cStartPath := GetSrvProfString( "Startpath", "" )

//cDirDocs := cPeti

//cCmd     := cArquivo //cDirDocs+cTmpTxt+".CSV"

//_nPos    := at(".",cArquivo)

//cArquivo := SubStr( cArquivo, 1 , IIF(_nPos>0,_nPos-1,Len(cArquivo)) ) + ".CSV"

nhOut := fCreate( cArquivo )

If nhOut == -1
	MsgStop("Erro ao criar arquivo ...")
Endif

DbSelectArea("cArqTmp")

aStruct := dBStruct()

cOutLine := ""

For _xy := 1 to Len(aStruct)
	
	If !aStruct[_xy][1] $ "SEQHIST/EMPORI/ULTLIN"              //Nao grava do .CSV esse campo conforme OS 2505-11,OS 2725-11  Jose Maria 05/12/2011
		cOutLine +=cOutLine + aStruct[_xy][1] + If( _xy < Len(aStruct) , ";" ,"")
	Endif
	
Next _xy

cOutLine += + Chr( 13 ) + Chr( 10 )  //CRLF

fWrite( nHOut,  cOutLine )

dBGoTop()

//ProcRegua(RecCount())
nTotRegs := 0
cArqTmp->( dbEval( { || nTotRegs++ },,{ || !Eof() } ) )
cArqTmp->(dbGoTop())

SetRegua(nTotRegs)

While !Eof()
	
	//IncProc()
	IncRegua()
	
	cOutLine :=""
	
	For _xy := 1 to Len(aStruct)
		
		If !aStruct[_xy][1] $ "SEQHIST/EMPORI" //Nao grava do .CSV esse campo conforme OS 2505-11,OS 2725-11  Jose Maria 05/12/2011
			
			_cCampo := "cArqTmp->"+aStruct[_xy][1]
			
			IF aStruct[_xy][2] == "C"
				cOutLine +=  &_cCampo
			ElseIf aStruct[_xy][2] == "N"
				If &_cCampo > 0
					cOutLine += Transform(&_cCampo,"@E "+Replicate("9",aStruct[_xy][3])+ IIF(aStruct[_xy][4]>0,"."+Replicate("9",aStruct[_xy][4]),"") )
				Else
					cOutLine += ""
				Endif
			ElseIf aStruct[_xy][2] == "D"
				cOutLine += dToc(  &_cCampo  )
			ElseIf aStruct[_xy][2] == "L"
				cOutLine += ""
			ElseIf aStruct[_xy][2] == "M"
				cOutLine += &_cCampo
			Endif
			
			cOutLine += If( _xy < Len(aStruct) , ";" , "")
			
		Endif
		
	Next _xy
	
	//
	cOutLine += Chr( 13 ) + Chr( 10 )  //CRLF
	fWrite( nHOut,  cOutLine )
	//
	
	dBSkip()
	
Enddo

//fecha TXT

fClose( nhOut )

//CpyS2T( cArquivo , "C:\", .F. )

//lSucesso := __CopyFile( cCmd , cArquivo)

If !lExterno
	If !lSucesso
		Alert('Nao foi possivel copiar o arquivo '+cArquivo)
	Else
		Alert('Verificar o arquivo '+cArquivo)
	EndIf
Else
	If !lSucesso
		ConOut("Nao foi possivel copiar o arquivo "+cArquivo)
	Else
		ConOut("Verificar o arquivo "+cArquivo)
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRIAPERG º Autor ³ Carlos Tagliaferri º Data ³  Jul/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria SX1                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CMDFIN06                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
aAdd(aRegs,{cPerg,"01","Da Conta            ?","","","mv_ch1","C",20,0,0,"G","","MV_PAR01",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CT1","S","003","",""})
aAdd(aRegs,{cPerg,"02","Ate Conta           ?","","","mv_ch2","C",20,0,0,"G","","MV_PAR02",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CT1","S","003","",""})
aAdd(aRegs,{cPerg,"03","Da Data             ?","","","mv_ch3","D",08,0,0,"G","","MV_PAR03",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","",""   ,"S",""   ,"",""})
aAdd(aRegs,{cPerg,"04","Ate a Data          ?","","","mv_ch4","D",08,0,0,"G","","MV_PAR04",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","",""   ,"S",""   ,"",""})
aAdd(aRegs,{cPerg,"05","Impr. Cta S/ Movim  ?","","","mv_ch5","N",01,0,2,"C","","MV_PAR05","Sim","Si","Yes","","","Nao","No","No","","","Nao c/ Sld.Ant.","No c/ Sld. Ant.","No w/Prev.Blnce","","","","","","","","","","","",""   ,"S",""   ,"",""})
aAdd(aRegs,{cPerg,"06","Imprime C.C. Extra  ?","","","mv_ch6","N",01,0,1,"C","","MV_PAR06","Sim","Si","Yes","","","Nao","No","No","","",""               ,""               ,""               ,"","","","","","","","","","","",""   ,"S",""   ,"",""})
aAdd(aRegs,{cPerg,"07","Do Centro de Custo  ?","","","mv_ch7","C",20,0,0,"G","","MV_PAR07",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CTT","S","004","",""})
aAdd(aRegs,{cPerg,"08","Ate Centro de Custo ?","","","mv_ch8","C",20,0,0,"G","","MV_PAR08",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CTT","S","004","",""})
aAdd(aRegs,{cPerg,"09","Imprime Item Contab ?","","","mv_ch9","N",01,0,2,"C","","MV_PAR09","Sim","Si","Yes","","","Nao","No","No","","",""               ,""               ,""               ,"","","","","","","","","","","",""   ,"S",""   ,"",""})
aAdd(aRegs,{cPerg,"10","Do Item Contabil    ?","","","mv_cha","C",09,0,0,"G","","MV_PAR10",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CTD","S","005","",""})
aAdd(aRegs,{cPerg,"11","Ate Item Contabil   ?","","","mv_chb","C",09,0,0,"G","","MV_PAR11",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CTD","S","005","",""})
aAdd(aRegs,{cPerg,"12","Imprime Classe Vlr  ?","","","mv_chc","N",01,0,2,"C","","MV_PAR12","Sim","Si","Yes","","","Nao","No","No","","",""               ,""               ,""               ,"","","","","","","","","","","",""   ,"S",""   ,"",""})
aAdd(aRegs,{cPerg,"13","Da Classe de Valor  ?","","","mv_chd","C",09,0,0,"G","","MV_PAR13",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CTH","S","006","",""})
aAdd(aRegs,{cPerg,"14","Ate Classe de Valor ?","","","mv_che","C",09,0,0,"G","","MV_PAR14",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","",""               ,""               ,""               ,"","","","","","","","","","","","CTH","S","006","",""})

For i:=1 to Len(aRegs)
	If !msseek(cPerg+aRegs[i,2])
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

Return()


///////////  FUNCAO PARA ENCONTRAR O RELACIONAMENTO CONTABIL

STATIC FUNCTION ULTLIN()
///		_Ultlin := ALLTRIM(SUBSTR(Carqct2->ULTLIN,50,200))  ///// ULTLIN-  NRPED-     NRPROV-     NRDOC-    NATUREZ-     CODFOR-     NOMFOR-     CODCLI-     NOMCLI-    RECDES    -TABORI-                	                                 ORIGEM-FILIALORI-DESCMAKRO-DESCLAN
_CODINVEST := ""
_ITINVEST  := ""
_FILIAL_ORI:=""

_nTam:=LEN(ALLTRIM(STR( cArqCT2->RECNO2,17 )))
CV3->(DBSETORDER(2))
IF CV3->(DBSEEK(cArqCT2->FILORI+ALLTRIM(STR(cArqct2->RECNO2,17))   +SPACE(17-_nTam)))
	_FILIAL_ORI:=""
	////	IF CV3->CV3_TABORI=='SE1'
	IF CV3->CV3_TABORI=='SE2'
		SE2->(DBGOTO(VAL(CV3->CV3_RECORI)))
		/*
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		*/
		_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SE2->E2_NATUREZ+SE2->E2_FORNECE+SE2->E2_LOJA,"SZH->ZH_CTTG")
		aadd(aArq,_CGESTOR)   /// CENTRO DE CUSTO GESTOR
		aadd(aArq, " "  )          /////////////NR_PED :=""
		aadd(aArq, ""  )          /////////////NR_PROV:=""
		aadd(aArq, SE2->E2_NUM  )          /////////////NR_DOC
		aadd(aArq, SE2->E2_NATUREZ  )          //////	NATUREZ
		aadd(aArq, SE2->E2_FORNECE )   //////// FORNECEDOR	// Tatiana Barbosa - OS 0844-10 - 06/2010
		aadd(aArq, SE2->E2_RSOCIAL)	   // NOME FORNECEDOR   Tatiana Barbosa - OS 0844-10 - 06/2010
		aadd(aArq, ""  )          ///////////// CLIENTE
		aadd(aArq, " "  )          ///////////// NOME CLIENTE
		_FILIAL_ORI:=""
	ELSEIF CV3->CV3_TABORI=='SE5'
		SE5->(DBGOTO(VAL(CV3->CV3_RECORI)))
		/*
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		*/
		_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SE5->E5_NATUREZ+SE5->E5_CLIFOR+SE5->E5_LOJA,"SZH->ZH_CTTG")
		aadd(aArq,_CGESTOR)   /// CENTRO DE CUSTO GESTOR
		aadd(aArq, ""  )          /////////////NR_PED :=""
		aadd(aArq, ""  )          /////////////NR_PROV:=""
		aadd(aArq, SE5->E5_NUMERO  )          /////////////NR_DOC
		aadd(aArq, SE5->E5_NATUREZ )    ///////////  NATUREZA
		_FILIAL_ORI:=""
		If SE5->E5_RECPAG == "P"        //Tatiana
			aadd(aArq, SE5->E5_CLIFOR )   //////// FORNECEDOR
			aadd(aArq, SE5->E5_BENEF )	   // NOME FORNECEDOR
			aadd(aArq, " " )   //////// CLIENTE
			aadd(aArq, " " )   //////// NOME CLIENTE
		Else
			aadd(aArq, " " )    //////// FORNECEDOR
			aadd(aArq, " " )   /// NOME FORNECEDOR
			aadd(aArq, SE5->E5_CLIFOR )   //////// CLIENTE
			aadd(aArq, SE5->E5_BENEF )   //////// NOME CLIENTE
		EndIf
	ELSEIF CV3->CV3_TABORI=='SEV'
		SEV->(DBGOTO(VAL(CV3->CV3_RECORI)))
		/*
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		*/
		_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SEV->EV_NATUREZ+SEV->EV_CLIFOR+SEV->EV_LOJA,"SZH->ZH_CTTG")
		aadd(aArq,_CGESTOR)   /// CENTRO DE CUSTO GESTOR
		aadd(aArq, ""  )          /////////////NR_PED :=""
		aadd(aArq, ""  )          /////////////NR_PROV:=""
		aadd(aArq, SEV->EV_NUM  )          /////////////NR_DOC
		aadd(aArq, SEV->EV_NATUREZ )  ///////// NATUREZA
		aadd(aArq, SEV->EV_CLIFOR )   //////// FORNECEDOR
		_NOM_FOR:=Posicione("SA2",1,xFilial("SA2")+SEV->EV_CLIFOR+SEV->EV_LOJA,"SA2->A2_NOME")
		aadd(aArq, _NOM_FOR )   /// NOME FORNECEDOR
		aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
		aadd(aArq, " "  )          ///////////// NOME CLIENTE
		_FILIAL_ORI:=""
	ELSEIF CV3->CV3_TABORI=='SEZ'
		SEZ->(DBGOTO(VAL(CV3->CV3_RECORI)))
		IF ! SEZ->(EOF())
			_nRecnoSD1:=PosSd1("","",SEZ->EZ_CLIFOR,SEZ->EZ_LOJA,SEZ->EZ_NUM,SUBSTR(SEZ->EZ_NOTA,7,3))
			IF _nRecnoSD1<>0
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SD1->D1_NATFULL+SD1->D1_FORNECE+SD1->D1_LOJA,"SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR)   /// CENTRO DE CUSTO GESTOR
				SD1->(DBGOTO(_nRecnoSD1))
				_FILIAL_ORI:=SD1->D1_FILIAL
				aadd(aArq, SD1->D1_PEDIDO  )          /////////////NR_PED :=""
				ZB2->(DBSETORDER(4))
				_NR_PROV:= ""
				_NATUREZ:= ""
				IF ZB2->(DBSEEK(XFILIAL('ZB2')+SD1->D1_PEDIDO))
					_NR_PROV:=ZB2->ZB2_PROVIS
				ENDIF
				aadd(aArq, _NR_PROV  )          /////////////NR_PROV:=""
				aadd(aArq, SD1->D1_DOC  )          /////////////NR_DOC
				aadd(aArq, SD1->D1_NATFULL	)  ////  NATUREZA	// Tatiana Barbosa - OS 0844-10 - 06/2010
				aadd(aArq, SD1->D1_FORNECE )   //////// FORNECEDOR
				_NOM_FOR:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"SA2->A2_NOME")
				aadd(aArq, _NOM_FOR )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
				
				//-------------- OS2505-11 Jose Maria 21/09/2011--------------------//
				_CODINVEST  := GETADVFVAL("SC7","C7_X_PRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
				_ITINVEST   := GETADVFVAL("SC7","C7_X_ITPRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
				//------------------------------------------------------------------//
				If	Empty(_CODINVEST) // OS 1979/15 By Douglas David
					_CODINVEST  := GETADVFVAL("AFN","AFN_PROJET",xFilial("AFN")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEMPC),2)
				Endif
				
			ELSE
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SEZ->EZ_NATUREZ+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA,"SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR) /// CENTRO DE CUSTO GESTOR
				aadd(aArq, ""  )          /////////////NR_PED :=""
				aadd(aArq, ""  )          /////////////NR_PROV:=""
				aadd(aArq, SEZ->EZ_NUM  )          /////////////NR_DOC
				aadd(aArq, SEZ->EZ_NATUREZ)  ////  NATUREZA
				aadd(aArq, SEZ->EZ_CLIFOR )   //////// FORNECEDOR
				_NOM_FOR:=Posicione("SA2",1,xFilial("SA2")+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA,"SA2->A2_NOME")
				aadd(aArq, _NOM_FOR )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
				
			ENDIF
		ENDIF
	ELSEIF CV3->CV3_TABORI=='SF1'
		SF1->(DBGOTO(VAL(CV3->CV3_RECORI)))
		IF ! SF1->(EOF())
			SD1->(DBSETORDER(1))
			IF SD1->(DBSEEK(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SD1->D1_NATFULL+SD1->D1_FORNECE+SD1->D1_LOJA,"SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
				aadd(aArq, SD1->D1_PEDIDO  )          /////////////NR_PED :=""
				ZB2->(DBSETORDER(4))
				_NR_PROV:= ""
				IF ZB2->(DBSEEK(XFILIAL('ZB2')+SD1->D1_PEDIDO))
					_NR_PROV:=ZB2->ZB2_PROVIS
					////					cArqTmp->NATUREZ:=ZB2->ZB2_NATURE
				ENDIF
				_FILIAL_ORI:= SF1->F1_FILIAL
				aadd(aArq, _NR_PROV  )          /////////////NR_PROV:=""
				aadd(aArq, SD1->D1_DOC  )          /////////////NR_DOC
				aadd(aArq, SD1->D1_NATFULL)
				aadd(aArq, SD1->D1_FORNECE )   //////// FORNECEDOR
				_NOM_FOR:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"SA2->A2_NOME")
				aadd(aArq, _NOM_FOR )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				
				//-------------- OS2505-11 Jose Maria 21/09/2011--------------------//
				_CODINVEST  := GETADVFVAL("SC7","C7_X_PRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
				_ITINVEST   := GETADVFVAL("SC7","C7_X_ITPRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
				//------------------------------------------------------------------//
				If	Empty(_CODINVEST) //OS 1979/15 By Douglas David
					_CODINVEST  := GETADVFVAL("AFN","AFN_PROJET",xFilial("AFN")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEMPC),2)
				Endif
				
			ELSE
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+SF1->F1_FORNECE+SF1->F1_LOJA,"SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
				///////////			cArqTmp->FILIAL_ORI:=SF1->F1_FILIAL
				aadd(aArq, " "  )          /////////////NR_PED :=""
				aadd(aArq, " "  )          /////////////NR_PROV:=""
				aadd(aArq, SF1->F1_DOC  )          /////////////NR_DOC
				aadd(aArq, " "  )          /////////////NATUREZA
				aadd(aArq, SF1->F1_FORNECE )   //////// FORNECEDOR
				_NOM_FOR:=Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA2->A2_NOME")
				aadd(aArq, _NOM_FOR )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				aadd(aArq, ""  )
				_FILIAL_ORI:= ""
			ENDIF
			
		ENDIF
	//05/12/17 - OS 0035/17 - Eduardo Dias
		ELSEIF CV3->CV3_TABORI=="SD1"
		SD1->(DBGOTO(VAL(CV3->CV3_RECORI)))
		IF ! SD1->(EOF())
			SD1->(DBSETORDER(1))
 			/*
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			*/
			_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SD1->D1_NATFULL+SD1->D1_FORNECE+SD1->D1_LOJA,"SZH->ZH_CTTG")
			aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
			aadd(aArq, SD1->D1_PEDIDO  )          /////////////NR_PED :=""
			ZB2->(DBSETORDER(4))
			_NR_PROV:= ""
			IF ZB2->(DBSEEK(XFILIAL('ZB2')+SD1->D1_PEDIDO))
				_NR_PROV:=ZB2->ZB2_PROVIS
				////					cArqTmp->NATUREZ:=ZB2->ZB2_NATURE
			ENDIF
			_FILIAL_ORI:= SF1->F1_FILIAL
			aadd(aArq, _NR_PROV  )          /////////////NR_PROV:=""
			aadd(aArq, SD1->D1_DOC  )          /////////////NR_DOC
			aadd(aArq, SD1->D1_NATFULL)
			aadd(aArq, SD1->D1_FORNECE )   //////// FORNECEDOR
			_NOM_FOR:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"SA2->A2_NOME")
			aadd(aArq, _NOM_FOR )   /// NOME FORNECEDOR
			aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
			aadd(aArq, " "  )          ///////////// NOME CLIENTE
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			aadd(aArq, ""  )
			
			//-------------- OS2505-11 Jose Maria 21/09/2011--------------------//
			_CODINVEST  := GETADVFVAL("SC7","C7_X_PRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
			_ITINVEST   := GETADVFVAL("SC7","C7_X_ITPRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
			//------------------------------------------------------------------//
			If	Empty(_CODINVEST) //OS 1979/15 By Douglas David
				_CODINVEST  := GETADVFVAL("AFN","AFN_PROJET",xFilial("AFN")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEMPC),2)
			Endif
			
		ENDIF
	
	ELSEIF CV3->CV3_TABORI=='SF2'
		SF2->(DBGOTO(VAL(CV3->CV3_RECORI)))
		IF ! SF2->(EOF())
			SD2->(DBSETORDER(3))
			IF SD2->(DBSEEK(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
				_FILIAL_ORI:= SF2->F2_FILIAL
				//	_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SEV->EV_NATUREZ+SEV->EV_CLIFOR+SEV->EV_LOJA,"SZH->ZH_CTTG")
				/*
				±±±±±±±±±±±±±±±±±±±±±ADMIN	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+SD2->D2_CLIENTE+SD2->D2_LOJA,"SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
				aadd(aArq, SD2->D2_PEDIDO  )          /////////////NR_PED :=""
				aadd(aArq, " "  )          /////////////NR_PROV:=""
				aadd(aArq, SD2->D2_DOC  )          /////////////NR_DOC
				aadd(aArq, " "  )          /////////////NATUREZA
				aadd(aArq, "" )   //////// FORNECEDOR
				_NOM_FOR:=Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"SA1->A1_NOME")
				aadd(aArq, " " )   /// NOME FORNECEDOR
				aadd(aArq, SD2->D2_CLIENTE  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, _NOM_FOR  )          ///////////// NOME CLIENTE
			ELSE
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+SF2->F2_CLIENTE+SF2->F2_LOJA,"SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
				aadd(aArq, " "  )          /////////////NR_PED :=""
				aadd(aArq, " "  )          /////////////NR_PROV:=""
				aadd(aArq, SF2->F2_DOC  )          /////////////NR_DOC
				aadd(aArq, " "  )          /////////////NATUREZA
				aadd(aArq, SF2->F2_CLIENTE )   //////// FORNECEDOR
				_NOM_FOR:=Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"SA1->A1_NOME")
				aadd(aArq, _NOM_FOR )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
			ENDIF
		ENDIF
		////	ELSEIF CV3->CV3_TABORI=='SM0'
	//05/12/17 - OS 0035/17 - Eduardo Dias
	ELSEIF CV3->CV3_TABORI=='SD2'
		SD2->(DBGOTO(VAL(CV3->CV3_RECORI)))
		IF ! SD2->(EOF())
			SD2->(DBSETORDER(3))
	//		IF SD2->(DBSEEK(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	  
			_FILIAL_ORI:= SF2->F2_FILIAL
			//	_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SEV->EV_NATUREZ+SEV->EV_CLIFOR+SEV->EV_LOJA,"SZH->ZH_CTTG")
			/*
			±±±±±±±±±±±±±±±±±±±±±ADMIN	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			*/
			_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+SD2->D2_CLIENTE+SD2->D2_LOJA,"SZH->ZH_CTTG")
			aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
			aadd(aArq, SD2->D2_PEDIDO  )          /////////////NR_PED :=""
			aadd(aArq, " "  )          /////////////NR_PROV:=""
			aadd(aArq, SD2->D2_DOC  )          /////////////NR_DOC
			aadd(aArq, " "  )          /////////////NATUREZA                            
			aadd(aArq, "" )   //////// FORNECEDOR
			_NOM_FOR:=Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"SA1->A1_NOME")
			aadd(aArq, " " )   /// NOME FORNECEDOR
			aadd(aArq, SD2->D2_CLIENTE  )          ///////////// CODIGO DO CLIENTE
			aadd(aArq, _NOM_FOR  )          ///////////// NOME CLIENTE
		EndIf		
	ELSEIF CV3->CV3_TABORI=='SN3'
		SN3->(DBGOTO(VAL(CV3->CV3_RECORI)))
		_FILIAL_ORI:= ""
		IF ! SN3->(EOF())
			SN1->(DBSETORDER(1))
			IF SN1->(DBSEEK(SN3->N3_FILIAL+SN3->N3_CBASE+SN3->N3_ITEM))
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+SN1->N1_NOMFORN+"","SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
				aadd(aArq, " "  )          /////////////NR_PED :=""
				aadd(aArq, " "  )          /////////////NR_PROV:=""
				aadd(aArq, SN1->N1_NFISCAL  )          /////////////NR_DOC
				aadd(aArq, " "  )          /////////////NATUREZA
				aadd(aArq, SN1->N1_FORNEC )   //////// FORNECEDOR
				aadd(aArq, SN1->N1_NOMFORN )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
				
			Else
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+""+"","SZH->ZH_CTTG")
				aadd(aArq," ")  /// CENTRO DE CUSTO GESTOR
				aadd(aArq, " "  )          /////////////NR_PED :=""
				aadd(aArq, " "  )          /////////////NR_PROV:=""
				aadd(aArq, ""  )          /////////////NR_DOC
				aadd(aArq, ""  )          /////////////NATUREZA
				aadd(aArq, "" )   //////// FORNECEDOR
				aadd(aArq, "" )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
			EndIf
		ENDIF
		///	ELSEIF CV3->CV3_TABORI=='SN4'
		///	ELSEIF CV3->CV3_TABORI=='SN5'
		///	ELSEIF CV3->CV3_TABORI=='SRZ'
		
	ELSEIF CV3->CV3_TABORI=='SN4'   // OS 0358/17 - By Douglas Coelho
		SN4->(DBGOTO(VAL(CV3->CV3_RECORI)))
		_FILIAL_ORI:= ""
		IF ! SN4->(EOF())
			SN1->(DBSETORDER(1))
			IF SN1->(DBSEEK(SN4->N4_FILIAL+SN4->N4_CBASE+SN4->N4_ITEM))
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+SN1->N1_NOMFORN+"","SZH->ZH_CTTG")
				aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
				aadd(aArq, " "  )          /////////////NR_PED :=""
				aadd(aArq, " "  )          /////////////NR_PROV:=""
				aadd(aArq, SN1->N1_NFISCAL  )          /////////////NR_DOC
				aadd(aArq, " "  )          /////////////NATUREZA
				aadd(aArq, SN1->N1_FORNEC )   //////// FORNECEDOR
				aadd(aArq, SN1->N1_NOMFORN )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
				
			Else
				/*
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				*/
				_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+""+"","SZH->ZH_CTTG")
				aadd(aArq," ")  /// CENTRO DE CUSTO GESTOR
				aadd(aArq, " "  )          /////////////NR_PED :=""
				aadd(aArq, " "  )          /////////////NR_PROV:=""
				aadd(aArq, ""  )          /////////////NR_DOC
				aadd(aArq, ""  )          /////////////NATUREZA
				aadd(aArq, "" )   //////// FORNECEDOR
				aadd(aArq, "" )   /// NOME FORNECEDOR
				aadd(aArq, ""  )          ///////////// CODIGO DO CLIENTE
				aadd(aArq, " "  )          ///////////// NOME CLIENTE
			EndIf
		ENDIF	
		
	ELSEIF CV3->CV3_TABORI=='ZB1'
		ZB1->(DBGOTO(VAL(CV3->CV3_RECORI)))
		/*
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		*/
		_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+SE2->E2_NATUREZ+SE2->E2_FORNECE+SE2->E2_LOJA,"SZH->ZH_CTTG")
		aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
		aadd(aArq, " "  )          /////////////NR_PED :=""
		aadd(aArq, " "  )          /////////////NR_PROV:=""
		aadd(aArq, SE2->E2_NUM  )          /////////////NR_DOC
		aadd(aArq, SE2->E2_NATUREZ  )          /////////////NATUREZA
		aadd(aArq, SE2->E2_FORNECE )   //////// FORNECEDOR
		aadd(aArq, SE2->E2_RSOCIAL )   /// NOME FORNECEDOR
		aadd(aArq, " "  )          ///////////// CLIENTE
		aadd(aArq, " "  )          ///////////// NOME CLIENTE
	ELSEIF CV3->CV3_TABORI=='ZB2'
		ZB2->(DBGOTO(VAL(CV3->CV3_RECORI)))
		/*
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		*/
		_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+ZB2->ZB2_NATURE+ZB2->ZB2_FORNEC+ZB2->ZB2_LOJA,"SZH->ZH_CTTG")
		aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
		aadd(aArq, ZB2->ZB2_PEDCOM  )          /////////////NR_PED :=""
		aadd(aArq, ZB2->ZB2_PROVIS  )          /////////////NR_PROV:=""
		
		_nRecnoSD1:=PosSd1("",ZB2->ZB2_PEDCOM,ZB2->ZB2_FORNEC,ZB2->ZB2_LOJA,"","")
		IF _nRecnoSD1<>0
			SD1->(DBGOTO(_nRecnoSD1))
			_FILIAL_ORI:= SD1->D1_FILIAL
			aadd(aArq, SD1->D1_DOC  )          /////////////NR_DOC
			////			cArqTmp->FILIAL_ORI:=SD1->D1_FILIAL
			//-------------- OS2505-11 Jose Maria 21/09/2011--------------------//
			_CODINVEST  := GETADVFVAL("SC7","C7_X_PRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
			_ITINVEST   := GETADVFVAL("SC7","C7_X_ITPRJ",xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEM),1)
			//------------------------------------------------------------------//
			If	Empty(_CODINVEST) //OS 1979/15 By Douglas David
				_CODINVEST  := GETADVFVAL("AFN","AFN_PROJET",xFilial("AFN")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEMPC),2)
			Endif
			
		ELSE
			aadd(aArq, " "  )          ///////////// DOC
		ENDIF
		aadd(aArq, ZB2->ZB2_NATURE)
		aadd(aArq, ZB2->ZB2_FORNEC )   //////// FORNECEDOR
		_NOMFOR:=Posicione("SA2",1,xFilial("SA2")+ZB2->ZB2_FORNEC+ZB2->ZB2_LOJA,"SA2->A2_NOME")
		aadd(aArq, _NOMFOR )   /// NOME FORNECEDOR
		aadd(aArq, " "  )          ///////////// CLIENTE
		aadd(aArq, " "  )          ///////////// NOME CLIENTE
		
	ELSEIF CV3->CV3_TABORI=='ZF1'
		ZF1->(DBSETORDER(1))
		IF ZF1->(DBSEEK(xFilial("ZF1")+Dtos(cArqct2->DDATA)+cArqCT2->(LOTE+SUBLOTE+DOC+LINHA)))
			/*
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			*/
			_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+ZF1->ZF1_CODFOR+"","SZH->ZH_CTTG")
			aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
			aadd(aArq, " "  )          /////////////NR_PED :=""
			aadd(aArq, " "  )          /////////////NR_PROV:=""
			aadd(aArq, " "  )          /////////////NR_DOC
			aadd(aArq, " "  )          /////////////NATUREZA
			aadd(aArq, ZF1->ZF1_CODFOR )   //////// FORNECEDOR
			_NOMFOR := Posicione("SA2",1,xFilial("SA2")+ZF1->ZF1_CODFOR,"A2_NOME")
			aadd(aArq, _NOMFOR )   /// NOME FORNECEDOR
			aadd(aArq, ZF1->ZF1_CODCLI )   //////// CLIENTE
			_NOMFOR := Posicione("SA1",1,xFilial("SA1")+ZF1->ZF1_CODCLI,"A1_NOME")
			aadd(aArq, _NOMFOR )   /// NOME CLIENTE
		ELSE
			/*
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			*/
			_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+ZF1->ZF1_CODFOR+"","SZH->ZH_CTTG")
			aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
			aadd(aArq, ""  )          /////////////NR_PED :=""
			aadd(aArq, ""  )          /////////////NR_PROV:=""
			aadd(aArq, ""  )          /////////////NR_DOC
			aadd(aArq, ""  )          /////////////NATUREZA
			aadd(aArq, ""  )   //////// FORNECEDOR
			aadd(aArq, "" )   /// NOME FORNECEDOR
			aadd(aArq," " )/// CENTRO DE CUSTO GESTOR
			aadd(aArq, "" )   //////// CLIENTE
			aadd(aArq, " " )   /// NOME CLIENTE
		ENDIF
	ELSEIF CV3->CV3_TABORI=='ZB8'
		SF1->(DBSETORDER(1))
		SF1->(DBSEEK(Right(AllTrim(carqct2->ULTLIN),23)))
		IF !SF1->(EOF())
			/*
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			*/
			_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+SF1->F1_FORNECE+SF1->F1_LOJA,"SZH->ZH_CTTG")
			aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
			aadd(aArq, " "  )          /////////////NR_PED :=""
			aadd(aArq, " "  )          /////////////NR_PROV:=""
			aadd(aArq, SF1->F1_DOC  )          /////////////NR_DOC
			aadd(aArq, ""  )          /////////////NATUREZA
			aadd(aArq, SF1->F1_FORNECE )   //////// FORNECEDOR
			_NOMFOR := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
			aadd(aArq, _NOMFOR )   /// NOME FORNECEDOR
			aadd(aArq, "" )   //////// CLIENTE
			aadd(aArq, " " )   /// NOME CLIENTE
		ELSE
			/*
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			*/
			_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+""+"","SZH->ZH_CTTG")
			aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
			aadd(aArq, ""  )          /////////////NR_PED :=""
			aadd(aArq, ""  )          /////////////NR_PROV:=""
			aadd(aArq, ""  )          /////////////NR_DOC
			aadd(aArq, ""  )          /////////////NATUREZA
			aadd(aArq, ""  )   //////// FORNECEDOR
			aadd(aArq, "" )   /// NOME FORNECEDOR
			aadd(aArq, "" )   //////// CLIENTE
			aadd(aArq, "" )   /// NOME CLIENTE
		ENDIF
	else
		FOR _A := 1 TO 9
			AADD(aArq,"")
		NEXT _A
		
	ENDIF
	
	
	aadd(aArq, STR( carqCT2->RECNO2,10) )  ///// RECDES
	aadd(aArq,  CV3->CV3_RECORI)   ///// RECORI
	aadd(aArq, CV3->CV3_TABORI)  //// TABORI
	xCampo := StrTran(cArqct2->ULTLIN, ";", "")
	aadd(aArq, xCampo)  //// ORIGEM
	aadd(aArq, _FILIAL_ORI)  //// FILIAL_ORI
	
	xCampo := StrTran(cArqct2->ULTLIN, ";", "")
	_nRegCT5:=PosCt5(ALLTRIM(xcampo))
	IF _nRegCT5<>0
		CT5->(DBGOTO(_nRegCT5))
		aadd(aArq, CT5->CT5_X_DESC) ///////////////////DESC_MAKRO
		aadd(aArq, CT5->CT5_DESC  )  /////////// DESC_LAN
		aadd(aArq, ZF1->ZF1_CODPRJ)  //// CODIGO PROJETO  // OS 0496/15 By Douglas David
	ELSE
		aadd(aArq, ";") ///////////////////DESC_MAKRO
		aadd(aArq, ";"  )  /////////// DESC_LAN
		aadd(aArq, ZF1->ZF1_CODPRJ)  //// CODIGO PROJETO  // OS 2063/15 By Douglas David
	ENDIF
	aadd(aArq, ""  )
	aadd(aArq, ""  )
	aadd(aArq, ""  )
	aadd(aArq, ""  )
	aadd(aArq, ""  )
	aadd(aArq, ""  )
	aadd(aArq, ""  )
	aadd(aArq, ""  )
Else
	//-- D'Leme, 28/06/2013, OS 1275/13	: quando estorno, não há CT3, mas há ZF1
	ZF1->(DBSETORDER(1))
	IF ZF1->(DBSEEK(xFilial("ZF1")+Dtos(cArqct2->DDATA)+cArqCT2->(LOTE+SUBLOTE+DOC+LINHA)))
		/*
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±  SELECIONA O CENTRO DE CUSTO GESTOR - OS-2009/12  ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		*/
		_CGESTOR:=Posicione("SZH",1,xFilial("SZH")+""+ZF1->ZF1_CODFOR+"","SZH->ZH_CTTG")
		aadd(aArq,_CGESTOR)  /// CENTRO DE CUSTO GESTOR
		aadd(aArq, " "  )          /////////////NR_PED :=""
		aadd(aArq, " "  )          /////////////NR_PROV:=""
		aadd(aArq, " "  )          /////////////NR_DOC
		aadd(aArq, " "  )          /////////////NATUREZA
		aadd(aArq, ZF1->ZF1_CODFOR )   //////// FORNECEDOR
		_NOMFOR := Posicione("SA2",1,xFilial("SA2")+ZF1->ZF1_CODFOR,"A2_NOME")
		aadd(aArq, _NOMFOR )   /// NOME FORNECEDOR
		aadd(aArq, ZF1->ZF1_CODCLI )   //////// CLIENTE
		_NOMFOR := Posicione("SA1",1,xFilial("SA1")+ZF1->ZF1_CODCLI,"A1_NOME")
		aadd(aArq, _NOMFOR )   /// NOME CLIENTE
		
		aadd(aArq, STR( carqCT2->RECNO2,10) )  ///// RECDES
		aadd(aArq, "" )   ///// RECORI
		aadd(aArq, "" )  //// TABORI
		xCampo := StrTran(cArqct2->ULTLIN, ";", "")
		aadd(aArq, xCampo)  //// ORIGEM
		aadd(aArq, _FILIAL_ORI)  //// FILIAL_ORI
		
		xCampo := StrTran(cArqct2->ULTLIN, ";", "")
		_nRegCT5:=PosCt5(ALLTRIM(xcampo))
		IF _nRegCT5<>0
			CT5->(DBGOTO(_nRegCT5))
			aadd(aArq, CT5->CT5_X_DESC) ///////////////////DESC_MAKRO
			aadd(aArq, CT5->CT5_DESC  )  /////////// DESC_LAN
		ELSE
			aadd(aArq, ";") ///////////////////DESC_MAKRO
			aadd(aArq, ";"  )  /////////// DESC_LAN
			aadd(aArq, ZF1->ZF1_CODPRJ)  //// CODIGO PROJETO  // OS 2063/15 By Douglas David
		EndIf
		
	Else
		FOR _A := 1 TO 13
			IF _A == 13
				xCampo := StrTran(cArqct2->ULTLIN, ";", "")
				AADD(aArq,ALLTRIM(xCampo))
			ELSEIF _A == 10
				AADD(aArq, STR( carqCT2->RECNO2,10) )
			ELSE
				AADD(aArq,"")
			ENDIF
		NEXT _A
		
		aadd(aArq, _FILIAL_ORI)  //// FILIAL_ORI
		
		xCampo := StrTran(cArqct2->ULTLIN, ";", "")
		_nRegCT5:=PosCt5(ALLTRIM(xcampo))
		
		IF _nRegCT5<>0
			CT5->(DBGOTO(_nRegCT5))
			aadd(aArq, CT5->CT5_X_DESC) ///////////////////DESC_MAKRO
			aadd(aArq, CT5->CT5_DESC  )  /////////// DESC_LAN
		ELSE
			aadd(aArq, ";") ///////////////////DESC_MAKRO
			aadd(aArq, ";"  )  /////////// DESC_LAN
			aadd(aArq, ZF1->ZF1_CODPRJ)  //// CODIGO PROJETO  // OS 2014/15 By Douglas David
		ENDIF
	ENDIF
	
ENDIF

//if len(aarq) < 12
//_aa := 1
//endif

RETURN(aARQ)
