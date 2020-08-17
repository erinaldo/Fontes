#INCLUDE "Protheus.CH"
#INCLUDE "GPER460.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CSPER460    ³ Autor ³ R.H. - Mauro         ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Ficha Registro                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GpeR460(void)                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Natie       ³ 21/03/01 ³------³ Alter.Chave de busca Cod. Sindicato      ³±± 
±±³Ricardo     ³ 29/03/01 ³004167³ Incluir periodo de impressao.            ³±± 
±±³Emerson     ³ 24/04/01 ³------³ Acerto na montagem da Pict de impressao  ³±± 
±±³Natie       ³ 06/03/02 |Melhor³ Impr.Grafica da Ficha de Registro c/foto ³±± 
±±³Natie       ³ 22/03/02 |Melhor³ Impr.Cpo Logico e declara nChar          ³±± 
±±³Natie       ³ 03/05/02 |Melhor³ Inicializa cDescFol                      ³±± 
±±³Natie       ³ 06/05/02 |Melhor³ Quebra de pagina                         ³±± 
±±³Natie       ³ 21/06/02 |Melhor³ Passa usar GetArea() e RestArea()        ³±± 
±±³            ³ 21/06/02 |Melhor³ Alterar set epoch para 1910              ³±±
±±³            ³ 21/06/02 |Melhor³ Verifica Impres.esta presente-Imp.Grafica³±±
±±³Natie       ³ 18/07/02 |------³ Retirada Isprinter()                     ³±± 
±±|Emerson     ³ 17/08/02 ³Meta  ³ Buscar sindicato pelo novo Cadastro-RCE. ³±± 
±±³Mauro       ³ 13/11/02 |60555 ³ Nao respeitava filtro na Imp.Grafica     ³±±
±±|Mauro       ³ 27/09/03 ³066286³ Nao Listar C.Sindical de Outra Empresa   ³±±  
±±|            ³          ³      ³ quando transferencia.                    ³±±  
±±|Natie       ³ 07/04/04 ³FN1375³ Verifica se existem  cpos selecionados p/³±±  
±±|            ³          ³      ³ impressao/Acerto coordenadas da foto     ³±±  
±±|Pedro ELoy  ³ 29/04/04 ³070437| Tratamento da variavel "cFiltraRH" quando³±±  
±±|            ³          ³      ³ filtrada via TOP.                        ³±±  
±±|Natie       ³ 30/04/04 ³B70869³ Tamanho nome de dependente com  tam.30   ³±± 
±±|Natie       ³ 05/05/04 ³B70692³ Contr.Sindical-Lista a descr. dos Sindica|±±  
±±|            ³          ³      ³ tos de acordo c/as respectivas contrib.  ³±± 
±±|Natie       ³ 28/05/04 ³------³ Impressao Cpo de Funcao da Alt.Salarial  |±±  
±±|Natie       ³ 07/07/04 ³Q00543³ Transf.entre Empresas- Listava contr.Sind|±± 
±±|            ³          ³      ³ duas vezes na Empr. de origem            ³±±
±±|Emerson     ³ 28/11/04 ³076390³ Executar aSort() por ordem de Recno() na |±± 
±±|            ³          ³      ³ impressao do historico de salarios.      ³±± 
±±|Emerson     ³ 29/11/04 ³076390³ Incluir data do aumento no ASORT(). 	    ³±± 
±±|Natie       ³ 06/12/04 ³076507³ Descricao do Sindicato                   ³±± 
±±|            ³          ³075238³ Lista Verba id246  com  descricao        ³±± 
±±³Andreia     ³ 29/03/05 ³073985³Tratamento do campo R7_DESCCAR para impri-³±± 
±±³            ³          ³      ³mir a descricao do cargo caso exista este ³±±  
±±³            ³          ³      ³campo.                                    ³±±  
±±|Natie       ³ 16/05/05 ³078390³ Impr.Contr.Sindical da empresa anterior  ³±± 
±±|            ³          ³      ³ com  a descr. do ID246                   ³±± 
±±|            ³          ³      ³(no caso de Transferencias entre empresas)³±± 
±±|Pedro Eloy  ³ 20/06/05 ³082010³ Quando utilizava mais de 2 paginas de impr.± 
±±|            ³          ³      ³ o relatorio estava sobrepondo as demais  ³±± 
±±|            ³          ³      ³ paginas, ( feito quebra, ajuste devidos).³±± 
±±|Natie       | 04/07/05 ³082010³ Quebra de pagina qdo algum box (ex.trans-³±± 
±±|            ³          ³------³ ferencia) ultrapassa o tamanho de 1 pag. |±± 
±±|L.Trombini e³ 04/07/05 ³------| Descricao:raca, sexo,Estado Civil ,Tipo  ³±± 
±±|Natie       ³          ³------³ de Contrato, Def.Fisico (imp.Grafica)    ³±± 
±±|Natie       ³ 04/07/05 ³------³ Retirada Set Century OFF                 |±± 
±±|            ³          ³------³ Otimizacao da rotina                     |±± 
±±|Ricardo D.  ³ 26/08/05 ³085951³ Ajuste no espaco util da pagina de forma |±± 
±±|            ³          ³------³ a nao cortar o rodape do relatorio.      |±± 
±±|            ³          ³------³ Ajuste na impressao do sexo p/dependentes|±± 
±±|Natie       ³ 13/09/05 ³085433³ Espaco para assinaturas                  ³±± 
±±|            ³          ³------³ Imprime periodo utilizado como referenc. |±± 
±±|            ³          ³------³ Imprime No Ficha no cabecalho            |±± 
±±|Tania       ³20/12/2005³Proj. ³ Inclusao de pergunta "Processo?" para se-³±±
±±³            ³          ³Mexico³ lecao dos registros a imprimir.          ³±± 
±±|            ³          ³      ³ Acerto alinhamento do quadro dependentes.³±± 
±±|Mauricio T. ³23/11/2006³------³ Inicializacao da variavel aDicioT        ³±±
±±|Tatiane M.  ³09/05/2008³------³ Retirada a declaracao da variavel aDicioT³±±
±±|            ³          ³------³ Quando a impressao da ficha de registro  ³±±
±±|            ³          ³------³ eh chamada pelo fonte gpea260, esta varia³±±
±±|            ³          ³------³ vel vem carregada com os campos informa- ³±±
±±|            ³          ³------³ dos no menu "Definicoes" e eh utilizada  ³±±
±±|            ³          ³------³ quando o paramtro "Ficha Atualizada?" for³±±
±±|            ³          ³------³ sim. Por isso essa variavel só está sendo³±±
±±|            ³          ³------³ inicializa quando esta ainda nao existir.³±±
±±|Marcos Kato ³29/05/2008³------³ Impressao das categorias profissionais-PT³±±
±±|Mauricio T. ³10/06/2008³------³ Nao Imprimir para o Mexico IR Dependentes³±±
±±|            ³          ³------³ e Salario Familia.                       ³±± 
±±³Alex        ³08/01/2010³026193³ Adaptacao para a Gestao corporativa      ³±±
±±³            ³          ³ /2009³ Respeitar o grupo de campos de filiais.  ³±±
±±|Tiago Malta ³22/01/2009³29573/³ Ajustes para impressao de alguns campos  ³±±
±±|            ³          ³--2009³ virtuais.                                ³±± 
±±|Tiago Malta ³04/03/2010³04084/³ Alterado estrutura do relatorio e        ³±±
±±|Isamu       ³03/06/09  ³1494  ³ Inclusao de nota: Portaria 3626 e alterar ±± 
±±|            ³          ³      ³ o titulo.                                 ±± 
±±³Ademar Jr.  ³01/11/2012³00000006603/2012³-Incluido pra localizacao Colombia a execucao³±±
±±³            ³          ³Chamado: TERISZ ³ da funcao AjustaSX().                       ³±±
±±³Claudinei S.³22/04/2014³				   ³-Incluido pra localizacao Bolivia a execucao ³±±
±±³            ³          ³Chamado: TPDPON ³ da funcao AjustaSX().                       ³±±
±±|Isamu       ³07/03/2016³3651  ³ Impressão da descrição do centro de custo ±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CGPER460
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1	:=	STR0001						//"Ficha de Registro"
LOCAL cDesc2 	:=	STR0002						//"Ser  impresso de acordo com os parametros solicitados pelo"
LOCAL cDesc3 	:=	STR0003						//"usuario."
LOCAL cString	:=	"SRA"						// alias do arquivo principal (Base)
LOCAL aOrd 		:=	{STR0004,STR0005,STR0006}	//"Matricula"###"Centro de Custo"###"Nome"
LOCAL wnRel         
Local aArea		:= GetArea()
Local n
Local cRProc	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aHelpPor		:= {}
Local aHelpSpa		:= {}
Local aHelpEng		:= {}
Local aHelp			:= {}
Local aRegs			:= {}
Local cHelp			:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn := { STR0007, 1,STR0008, 2, 2, 1, "",1 }  //"Zebrado"###"Administra‡„o"
PRIVATE nomeprog:="GpeR460"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="GPR460"
Private nChar	:= 18
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Titulo  := STR0009  //"FICHA DE REGISTRO"
PRIVATE cCabec
PRIVATE AT_PRG  := "GPER460"
PRIVATE wCabec0 := 9
PRIVATE wCabec1:=""
PRIVATE wCabec2:=""
PRIVATE wCabec3:=""
PRIVATE wCabec4:=""
PRIVATE wCabec5:=""
PRIVATE wCabec6:=""
PRIVATE wCabec7:=""
PRIVATE wCabec8:=""
PRIVATE wCabec9:=""
PRIVATE CONTFL:=1
PRIVATE LI:=0
PRIVATE nTamanho:="P"
PRIVATE cPathPict	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cIndCond
PRIVATE cFor
PRIVATE nOrdem
PRIVATE aInfo		:= {}

Private oPrint , i:= 1
Private oFont07,oFont08,oFont08n, oFont10, oFont15, oFont10n, oFont21, oFont12,oFont12n,oFont16
Private nLin := nLinha:= 0, nColuna := 50
Private aCampo		:= {}
Private nlinMax		:= 2700
Private nColMax	 	:= 2350
Private nColBox 	:= 2200
Private lFirst		:= .T.
Private aFotos		:= {}			//armazena nome  foto 
Private cProcessos	:= "" 
                 
//Ajusta dicionario de dados
AjustaSX()
                 
If Type("aDicioT") == "U"
	aDicioT := {}
EndIf

//--Altera o Set Epch para 1910
nEpoca := SET( 5,1910)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("GPR460",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Centro de Custo De                       ³
//³ mv_par04        //  Centro de Custo Ate                      ³
//³ mv_par05        //  Matricula De                             ³
//³ mv_par06        //  Matricula Ate                            ³
//³ mv_par07        //  Nome De                                  ³
//³ mv_par08        //  Nome Ate                                 ³
//³ mv_par09        //  Situacao                                 ³
//³ mv_par10        //  Categoria                                ³
//³ mv_par11        //  Ficha Atualizada                         ³
//³ mv_par12        //  Alt. Salariais                           ³
//³ mv_par13        //  Afastamentos                             ³
//³ mv_par14        //  Dependentes                              ³
//³ mv_par15        //  Ferias                                   ³
//³ mv_par16        //  Alt. Cadastrais                          ³
//³ mv_par17        //  Contrib. Sindicais                       ³
//³ mv_par18        //  Transferencias                           ³
//³ mv_par19        //  Beneficiarios                            ³
//³ mv_par20        //  Impr.Desc. Filial                        ³
//³ mv_par21        //  Impressao Grafica                        ³
//³ mv_par22        //  Data inicio de impressao                 ³
//³ mv_par23        //  Data final de impressao                  ³
//³ mv_par24        //  Nome Responsavel Legal                   ³
//³ mv_par25        //  Processos para Impressao                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER460"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordem do Relatorio                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FilialDe	:= mv_par01
FilialAte	:= mv_par02
CcDe     	:= mv_par03
CcAte    	:= mv_par04
MatDe    	:= mv_par05
MatAte   	:= mv_par06
NomDe    	:= mv_par07
NomAte   	:= mv_par08
cSit     	:= mv_par09
cCat     	:= mv_par10
nFicha   	:= mv_par11
nSalar   	:= mv_par12
nAfast   	:= mv_par13
nDepen   	:= mv_par14
nFerias  	:= mv_par15
nAltcad	 	:= mv_par16
nConSin	 	:= mv_par17		
nTransf		:= mv_par18
nBenefic	:= mv_par19
nFilial		:= mv_par20
nGrafica	:= mv_par21
dDataIni	:= mv_par22
dDataFin	:= mv_par23
cResponsavel:= mv_par24
cProcessos	:= If( Empty(mv_par25),"", AllTrim(mv_par25) )	//	Processos para Impressao

If nLastKey = 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica preenchimento dos campos datas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( dDataIni )
	dDataIni := CTOD( "01/01/1900", "DDMMYYYY" )
Endif
If Empty( dDataFin )
	dDataFin := CTOD( "31/12/2099", "DDMMYYYY" )
Endif
dDataFin := Max( dDataFin, dDataIni )

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif
If nGrafica ==1
	oPrint:=TMSPrinter():New(STR0001) 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se ha impressora ativa conectada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! oPrint:IsPrinterActive() 
		oPrint:Setup()							//-- Escolhe a impressora	
		If ! oPrint:IsPrinterActive()	
			Help(" ",1,"NOPRINTGRA")			//-- Nao foi encontrada configuracao de impressora. ##Certifique-se de que as configurações da impressora estão corretas ou se há alguma impressora conectada.
			Return(Nil)
		Endif
	Endif
	oPrint:SetPortrait()		//Modo retrato 
	oPrint:StartPage() 			//Inicia uma nova pagina 

	oFont07	:= TFont():New("Courier New",07,07,,.F.,,,,.T.,.F.) 
	oFont08n:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)  
	oFont08c:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.) 
	oFont08 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.) 
	oFont10	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.) 
	oFont10n:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.) 
	oFont12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.) 
	oFont12n:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)			//Negrito
	oFont15	:= TFont():New("Courier New",15,15,,.F.,,,,.T.,.F.) 
	oFont21 := TFont():New("Courier New",21,21,,.F.,,,,.T.,.T.) 
	oFont16	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.) 
Endif 

Titulo := STR0009  //"FICHA DE REGISTRO"

RptStatus({|lEnd| GR460Imp(@lEnd,wnRel,cString)},Titulo)

If nGrafica == 1 
	oPrint:Preview()  		// Visualiza antes de imprimir

	//-- Apaga BMP Foto do Diretorio
	For n:=1 to Len(aFotos)
		IF File(aFotos[n])
			fErase( aFotos[n])
		Endif	
	next n	
Endif

//--Retornar Set Epoch Padrao
SET(5,nEpoca)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Restaura Area e Ordem de Entrada                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
RestArea( aArea)
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPR460Imp³ Autor ³ R.H. - Ze Maria       ³ Data ³ 03.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Folha de Pagamanto                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR460Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³          ³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GR460Imp(lEnd,WnRel,cString)

Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER460","SRA","2") + "}")
Local nLinhas		:= 0
Local X				:= 0 
Local lNUse 		:= cPaisLoc == "PER"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private 		lImpressao	:= .F.  				//-- Define se houve impressao da informacao 

dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder(1)
	dbSeek(FilialDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := FilialAte + MatAte
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek(FilialDe + CcDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := FilialAte + CcAte + MatAte
ElseIf nOrdem == 3
	dbSetOrder(3)
	dbSeek(FilialDe + NomDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := FilialAte + NomAte + MatAte
Endif

SetRegua(SRA->(RecCount()))

cFilAnterior 	:= Space(FwGetTamFilial)
cCcAnt       	:= Space(09)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a string de Processos para Impressao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(cProcessos) <> "*"
	cRProc := ""
	nTamCod := GetSx3Cache( "RCJ_CODIGO" , "X3_TAMANHO" )
	For X := 1 to Len(cProcessos) step 5
		If Len(Subs(cProcessos,X,5)) < nTamCod
			cAuxPrc := Subs(cProcessos,X,5) + Space(nTamCod - Len(Subs(cProcessos,X,5)))
		Else
			cAuxPrc := Subs(cProcessos,X,5)
		EndIf
		cRProc += cAuxPrc
		cRProc += "#"
	Next X
Else
	cRProc := cProcessos
EndIf

dbSelectArea( "SRA" )
While !EOF() .And. &cInicio <= cFim
	
	IncRegua()

    If lEnd
        @Prow()+1,0 PSAY cCancel
        Exit
    Endif
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Consiste Parametrizacao do Intervalo de Impressao            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If (SRA->RA_NOME < NomDe) .Or. (SRA->RA_NOME > NomAte) .Or. ;
        (SRA->RA_MAT < MatDe)  .Or. (SRA->RA_MAT > MatAte)  .Or. ;
        (SRA->RA_CC < CcDe)    .Or. (SRA->RA_CC > CcAte)
		dbSelectArea( "SRA" )
		dbSkip()
		Loop
    Endif

    If  !(Sra->Ra_SitFolh $ cSit) .Or. !(Sra->Ra_CatFunc $ cCat)
		dbSelectArea( "SRA" )
		dbSkip()
		Loop
    Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSelectArea( "SRA" )
		dbSkip()
		Loop
	EndIf
  
    IF  SRA->RA_FILIAL # cFilAnterior
        If ! fInfo(@aInfo,Sra->ra_Filial)
			Exit
		Endif
	Endif

	wCabec1 :=  aInfo[3]												//Razao Social
	wCabec2	:=  STR0011 + aInfo[1]  									//Filial
	wCabec3 :=  aInfo[4] + " - " + aInfo[13] 							// Endereco 
	If nGrafica  == 1 
		wCabec0	:= 9
		wCabec4 :=  aInfo[5] + " - " + aInfo[6] 		 					//Municipio / Estado
		wCabec5	:=  STR0031  + Transform(aInfo[7],"@R #####-###")          //CEP
		
		IF cPaisLoc == "ANG"
			wCabec6 :=  STR0113  + aInfo[8]                                  //NIF
		ELSE
		
			wCabec6 :=  STR0032  + Transform(aInfo[8],"@R ##.###.###/####-##") //CGC
			wCabec7	:=  STR0033  + aInfo[16]									//CNAE
		ENDIF
		
		wCabec8	:=  STR0034  + aInfo[19]	 								//Cod.Munic.:"

	Else           
		wCabec0	:= 6
		wCabec4 :=  aInfo[5] + " - " + aInfo[6] + space(3)+ STR0031 + Transform(aInfo[7],"@R #####-###") 					//Municipio / Estado 
		wCabec5 :=  STR0032  + Transform(aInfo[8],"@R 99.999.999/9999-99")+space(5) + STR0033  + aInfo[16]+space(5)+STR0034  + aInfo[19] //CGC
		WCabec6	:=  STR0004  + "  " + If(!lNUse,SRA->RA_FICHA," ") + " "+ SRA->RA_MAT + " - " + SRA->RA_NOME
	Endif

	nLin := 0	
	li	 := 0	
	lImpressao 	:= .F.  
	If nFicha == 1
		fImpFch()
	Endif
	
	If nSalar == 1
		fImpSal()
		If cPaisLoc=="PTG"
			fImpCat()//Alteracoes de Categorias
		Endif
	Endif       
	
	If nAfast == 1
		fImpAfas()
	Endif       
	
	If nferias == 1
		fImpFer()
	Endif
	
	If nAltcad == 1
		fImpCad()
	Endif

	If nDepen == 1
		fImpDep()
	Endif     
	
	If nBenefic == 1
		fImpBen()
	Endif     

	If nConSin == 1
		fImpSin()
	Endif    
    
	If nTransf == 1
		fImpTra()
	Endif  

	If lImpressao 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Periodo de impressao                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fImpPeriodo() 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Assinaturas                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fAssinaBox() 
	Endif	

	aCampo 	:= {}      	
	lFirst	:= .T. 
	dbSelectarea("SRA")
	dbSkip()
Enddo         
If(nGrafica ==2,IMPR("","F"),oPrint:EndPage())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRA")
If Type("cFiltraRH") == "U" .Or. Empty(cFiltraRH)
Set Filter to
EndIf
dbSetOrder(1)
dbGoTop()

Set Device To Screen
If aReturn[5] = 1  .and. nGrafica # 1 
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpFch  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Ficha Atualizada                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpFch()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpfch()

Local cCabCpo,cCampo,cFolder,cOrdem
Private	nPosT


cDet    := " "
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SRA")
While ( !Eof() .And. SX3->X3_ARQUIVO == "SRA" )

	uCampo := SX3->X3_CAMPO
	
	If Alltrim(uCampo) $ 'RA_FILIALxRA_MATxRA_NOMEXRA_BITMAP X RA_FICHA '
		dbSelectArea("SX3")
		dbSkip()
		Loop
	Endif	
	
	nPosT := Ascan(aDicioT,{|X| Subs(X,36,10) == uCampo })
	
	If nPosT <> 0 .And. Subs(aDicioT[nPosT],29,1) == 'X'
		IF ( SX3->X3_CONTEXT == "V"  ) 
			If     alltrim(uCampo) == "RA_DESCCC"
				cCampo :=  fDesc("SI3",SRA->RA_CC,"I3_DESC")
			ElseIf alltrim(uCampo) == "RA_DESCFUN"
				cCampo :=  fDesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC")
			ElseIf alltrim(uCampo) == "RA_DCARGO"
				cCampo :=  FDESC("SQ3",SRA->RA_CARGO,"Q3_DESCSUM")
			ElseIf alltrim(uCampo) == "RA_DDEPTO"
				cCampo :=  fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC')
			ElseIf alltrim(uCampo) == "RA_DESCTUR"
				cCampo := fDesc("SR6",SRA->RA_TNOTRAB,"R6_DESC")
			ElseIf alltrim(uCampo) == "RA_DESCNAC"
				cCampo := IF(!EMPTY(SRA->RA_TABELA),Tabela("34",SRA->RA_NACIONA),"")
			ElseIf alltrim(uCampo) == "RA_DESCHAB"
				cCampo := fDescRCC("S002",SRA->RA_HABESCO,1,2,3,30)
			ElseIf alltrim(uCampo) == "RA_DESCAT"
				cCampo := fDesc("RGG",SRA->RA_CODCAT+SRA->RA_CODIRCT,"RGG_DESCRI")
			ElseIf alltrim(uCampo) == "RA_DESCONT"
				cCampo := fDescRCC("S016",SRA->RA_TIPOCO,1,2,3,30)
			ElseIf alltrim(uCampo) == "RA_BIDESCE"
				cCampo := POSICIONE("SX5",1,XFILIAL("SX5")+"12"+SRA->RA_BIESTEM,"X5_DESCRI")  
			Else
				cCampo := CriaVar(SX3->X3_CAMPO)
			Endif
		Else                                      
			cCampo 	:= SRA->( FieldGet(FieldPos(uCampo)) )  
			If alltrim(ucampo) == "RA_SEXO"
				cCampo	:= fDescSexo( cCampo)
			ElseIf alltrim(ucampo) == "RA_TPCONTR"
				cCampo 	:= If(cCampo = "1",STR0066, STR0067)
 			ElseIf alltrim(ucampo) == "RA_RACACOR"
				If cCampo =="1"
					cCampo	:= STR0068			//-- Indigena 
				elseIf cCampo=="2"
					cCampo := STR0069 			//-- Branca
				elseif cCampo = "4"
					cCampo := STR0070			//-- Negra
				elseif cCampo = "6"
					cCampo := STR0071			//-- Amarela
				elseif cCampo = "8"
					cCampo := STR0072			//-- Parda 
				elseif cCampo = "9"
					cCampo := STR0073 			//-- Nao Informado
				Endif
			ElseIf alltrim(uCampo) == "RA_DEFIFIS"
				cCampo	:= If(cCampo == "1",STR0074, STR0075) 
			ElseIf alltrim(uCampo) == "RA_ESTCIVI" 
				cCampo := Substr(fDesc("SX5","33"+cCampo,"X5DESCRI()"),1,12)  
			//Else
			//	cCampo := SRA->( FieldGet(FieldPos(uCampo)) )
			EndIf
        Endif

		If ValType(cCampo) = "D"
			cCampo := Dtoc(cCampo)
		Elseif ValType(cCampo) = "N"
			cPict := "@E "+Replicate("9",Val(Subs(aDicioT[nPosT],49,3)) )
			If Val(Subs(aDicioT[nPosT],52,2)) > 0
				cPict += "."+Replicate("9",Val(Subs(aDicioT[nPosT],52,2)) )
			Endif
			cCampo := Transform(cCampo,cPict)
		ElseIf ValType(cCampo)="L"
			If cCampo	:= .F.
				cCampo 	:= "F"
			Else
				cCampo	:= "T"
			Endif
		Endif
		cCabCpo := fTacento(AllTrim(Subs(aDicioT[nPosT],1,12)))
		cFolder := subs(aDicioT[nPosT],54,2) 
		cOrdem  := subs(aDicioT[nPosT],56,3)
		aAdd(aCampo,{cCabCpo,cCampo,cFolder,cOrdem})
	Endif		
	dbSelectArea("SX3")
	dbSkip()
EndDo  
aSort( aCampo,,,{ |x,y| x[3]+x[4] < y[3]+y[4] } )	
                 
If Len(aCampo) > 0 
	If nGrafica == 1 
		fImpGraf(aCampo)
	Else
		fImpNorm(aCampo)
	Endif		
	lImpressao	:= .T.
Endif

//--SET CENTURY OFF
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpSal  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Alteracao Salarial                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpSal()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpSal()
Local aSal	     := {}
Local cChaveSort := ""

dbSelectArea("SR7")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SR7->R7_FILIAL+SR7->R7_MAT

	nVez := 0
    dbSelectArea("SR3")
    dBseek(SR7->R7_FILIAL+SR7->R7_MAT+DTOS(SR7->R7_DATA)+SR7->R7_TIPO)
    While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SR3->R3_FILIAL+SR3->R3_MAT .And. ;
                  SR3->R3_DATA = SR7->R7_DATA .And. SR7->R7_TIPO = SR3->R3_TIPO
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica periodo de impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SR3->R3_DATA < dDataIni .or. SR3->R3_DATA > dDataFin
			dbSkip()
			Loop
		Endif

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Cabecalho tabela               ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If Len(aSal) = 0
			If SR7->( Type("R7_DESCCAR") ) # "U"
				Aadd(aSal ,{STR0013,STR0014,STR0016,STR0053,STR0054,STR0055,STR0035,STR0063, "" }) 	//###"Desc.Cargo"
			Else
				Aadd(aSal ,{STR0013,STR0014,STR0016,STR0053,STR0054,STR0055,STR0035,"", "" })
			EndIf	
			//" Data        Desc.Aumento            Cat.   Pgto.      Verba                          Valor    Funcao" 
			//  99/99/9999  xxxxxxxxxxxxxxxxxxxx     x      x         xxxxxxxxxxxxxxxxxxxx   99.999.999,99    xxxxxxxxxxxxxx
		Endif
		
		dbSelectArea("SX5")
		dbSeek(xFilial("SX5")+"41"+SR7->R7_TIPO)
		If ! eof()
			cDescS := fTAcento(SUBS(X5Descri(),1,20))
		Else 
			cDescS := STR0017  //"Nao Cad. Tabela(41) "
		Endif
		dbSelectArea("SR3")
		cChaveSort := DTOS(SR7->R7_DATA)+StrZero(SR3->R3_VALOR,15)+StrZero(SR3->(Recno()),15)
		If nVez = 0
			If SR7->( Type("R7_DESCCAR") ) # "U"
				Aadd(aSal,{DTOC(SR7->R7_DATA),cDescS,SR7->R7_CATFUNC,SR7->R7_TIPOPGT,Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,SR7->R7_DESCCAR,cChaveSort })
			Else	
				Aadd(aSal,{DTOC(SR7->R7_DATA),cDescS,SR7->R7_CATFUNC,SR7->R7_TIPOPGT,Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,"",cChaveSort })
			EndIf
			nVez := 1
		Elseif nVez = 1
			nPosS := Len(aSal)
			If SR7->( Type("R7_DESCCAR") ) # "U"
				Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,SR7->R7_DESCCAR, cChaveSort })
			Else
				Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,"", cChaveSort })
			EndIf
			nVez := 2
		Else
			If SR7->( Type("R7_DESCCAR") ) # "U"
				Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"), SR7->R7_DESCFUN,SR7->R7_DESCCAR, cChaveSort })
			Else
				Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"), SR7->R7_DESCFUN,"", cChaveSort })
			EndIf
		Endif
		dbSkip()
	Enddo
	dbSelectArea("SR7")
	dbSkip()
Enddo 

If !empty(aSal) .and. Len(aSal) > 1

	aSort( aSal,,,{ |x,y| x[9] < y[9] } )
	If nGrafica == 1
		fImpSalG(aSal)
	Else              
		fImpSalN(aSal)	
	Endif
	lImpressao	:= .T. 
Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpCat  ³ Autor ³ R.H. - SSERVICE       ³ Data ³ 27.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Alteracao Categoria                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpCat()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpCat()
Local aCat	     := {}
Local cChaveSort := "", cDescCat:=Space(60)
Local cDadSra	 :=SRA->RA_FILIAL+SRA->RA_MAT
If ChkFile("RGH")
	dbSelectArea("RGH")                                   
	RGH->(DbSetOrder(RetOrder("RGH","RGH_FILIAL+RGH_MAT+RGH_DTINIC")))
	If dbSeek(cDadSra) 
		Do While RGH->(!Eof()) .And. SRA->RA_MAT==RGH->RGH_MAT
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Cabecalho tabela               ³ 
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			If Len(aCat) = 0
					Aadd(aCat ,{STR0108,STR0109})
							  //" Data         Desc.Categoria                                                            "
					          //  99/99/9999   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx->60 caractere    
			Endif              

			cDescCat:=Space(60)
			dbSelectArea("RGG")
			RGG->(DbSetOrder(RetOrder("RGG","RGG_FILIAL+RGH_CODIGO+RGG_CODIRC")))
			If dbSeek(xFilial("RGG")+RGH->RGH_CODCAT+RGH->RGH_CODIRC)
				cDescCat := Substr(Alltrim(RGG->RGG_DESCRI),1,60)
			Endif
			cChaveSort := DTOS(RGH->RGH_DTINIC)
			Aadd(aCat,{DTOC(RGH->RGH_DTINIC),cDescCat,cChaveSort })
			dbSelectArea("RGH")
			RGH->(dbSkip())
		Enddo 
		

		If !empty(aCat) .and. Len(aCat) > 1
			aSort( aCat,,,{ |x,y| x[1] < y[1] } )//Ordenando por Data
			If nGrafica == 1
				fImpCatG(aCat)
			Else              
				fImpCatN(aCat)	
			Endif
			lImpressao	:= .T. 
		Endif
	Endif
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpAfas ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de afastamentos                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpAfas()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpAfas()

Local aAfas := {}

dbSelectArea("SR8")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SR8->R8_FILIAL+SR8->R8_MAT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica periodo de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SR8->R8_DATAINI < dDataIni .or. SR8->R8_DATAINI > dDataFin
		dbSkip()
		Loop
	Endif

	If Len(aAfas) = 0
		Aadd(aAfas,{STR0013,STR0019,STR0020,STR0022})  //"|Data       Tipo                                   Data Inicio      Data Fim   "
	Endif
   	
	dbSelectArea("SX5")
	dbSeek(xFilial("SX5")+"30"+SR8->R8_TIPO)
	If ! eof()
       cDescA := fTacento(SUBS(X5Descri(),1,34))
	Else
       cDescA := STR0061
	Endif
	
	dbSelectArea("SR8")
	If SR8->R8_TIPO # "F"
		Aadd(aAfas,{DTOC(SR8->R8_DATA),cDescA,DTOC(SR8->R8_DATAINI),DTOC(SR8->R8_DATAFIM) })
	EndIf
	dbSkip()
Enddo
If !Empty(aAfas) .and. Len(aAfas) > 1                      
	 If nGrafica ==1 
	 	fImpAfasG(aAfas)
	 Else    
	 	fImpAfasN(aAfas)
	 Endif
     lImpressao	:= .T.
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpFer  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de Ferias                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpFer()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpFer()

Local aFerias := {}

dbSelectArea("SRH")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SRH->RH_FILIAL+SRH->RH_MAT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica periodo de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRH->RH_DATAINI < dDataIni .or. SRH->RH_DATAINI > dDataFin
		dbSkip()
		Loop
	Endif

	If Len(aFerias) = 0
		Aadd(aFerias,{ STR0023,STR0056,STR0057,STR0058,STR0079,STR0080} )  //"|Periodo Aquisitivo   Periodo de Ferias       Data do Aviso    Data Pagto. D.Ferias d.Abono"
	Endif
	Aadd(aFerias,{DTOC(SRH->RH_DATABAS)+ " a "+DTOC(SRH->RH_DBASEAT), ;
		          DTOC(SRH->RH_DATAINI) +" a " +DTOC(SRH->RH_DATAFIM), ;
        		  DTOC(SRH->RH_DTAVISO) , DTOC(SRH->RH_DTRECIB)      , ;
        		  STRZERO(SRH->RH_DFERIAS,2), STRZERO(SRH->RH_DABONPE,2) })
	dbSkip()
Enddo                         

If !Empty(aFerias) .and. Len(aFerias) > 1 
	If nGrafica==1    
		fImpFeriaG(aFerias)
	Else     
		fImpFeriaN(aFerias)
	Endif		
	lImpressao	:= .T.
Endif	
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpCad  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de Alt.Cadastrais                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpCad()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpCad()

Local aAltCad := {}
cDet    := ""


dbSelectArea("SR9")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SR9->R9_FILIAL+SR9->R9_MAT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica periodo de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SR9->R9_DATA < dDataIni .or. SR9->R9_DATA > dDataFin
		dbSkip()
		Loop
	Endif

	If Len(aAltCad) = 0
		Aadd(aAltCad,{ STR0013,STR0025,STR0059})  //"Data         Campo Alterado    Descricao"
	Endif
	nPos    := Ascan(aDicioT,{ |x| Subs(x,36,10)=SR9->R9_CAMPO })
	If nPos > 0
		cTitulo := fTAcento(Subs(aDicioT[nPos],1,12))
		Aadd(aAltCad,{DTOC(SR9->R9_DATA), cTitulo,SR9->R9_DESC	} )
	Endif
	dbSkip()
Enddo                                               
If !Empty(aAltCad) .and. Len(aAltCad) > 1
	If nGrafica ==1   
		fImpCadG(aAltCad)
	Else     
		fImpCadN(aAltCad)
	Endif		
	lImpressao	:= .T.
Endif
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpDep  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de Dependentes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpDep()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpDep()

Local aDep := {}
Local m_sexo		:= ""
Local m_graupar 	:= ""
Local m_TipIR		:= ""
Local m_TipSF		:= ""

dbSelectArea("SRB")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SRB->RB_FILIAL+SRB->RB_MAT
	If Len(aDep) = 0
		Aadd(aDep,{STR0027,STR0026,STR0037,STR0038,STR0040,STR0048,STR0050} )  //"|Cod|Dependente                     Dt.Nasc  Sexo Parent IR  S.F."
	Endif
    m_Sexo		:= fDescSexo(SRB->RB_SEXO)
	m_graupar	:= If(SRB->RB_GRAUPAR =="F",STR0076, ( If( SRB->RB_GRAUPAR =="C", STR0077, STR0078) )  ) 
    m_TipIR		:= If(SRB->RB_TIPIR =="4", STR0075, STR0074) 
    m_TipSF		:= If(SRB->RB_TIPSF =="3", STR0075, STR0074) 
	Aadd(aDep,{SRB->RB_COD,SRB->RB_NOME,Dtoc(SRB->RB_DTNASC),;
                        M_SEXO,M_GRAUPAR,M_TIPIR,M_TIPSF })
	dbSkip()
Enddo
If !Empty(aDep) .and. Len(aDep) > 1
	If nGrafica==1
		fImpDepG(aDep)
	Else
		fImpDepN(aDep)
	Endif
	lImpressao	:= .T.
Endif

Return 
			

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpBen  ³ Autor ³ R.H. - Natie          ³ Data ³ 22.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Beneficiarios                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpBen()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpBen()

Local aBenef := {}

dbSelectArea("SRQ")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SRQ->RQ_FILIAL+SRQ->RQ_MAT
	If Len(aBenef) = 0
		Aadd(aBenef,{STR0027,STR0060} )  //"|Cod|Beneficiario                   
	Endif 
	If SRQ->RQ_ORDEM =="01"
		Aadd(aBenef,{SRQ->RQ_ORDEM,SRQ->RQ_NOME })
	Endif
	dbSkip()
Enddo
If !Empty(aBenef) .and. Len(aBenef) > 1
	If nGrafica==1
		fImpBenG(aBenef)
	Else
		fImpBenN(aBenef)
	Endif
	lImpressao	:= .T.
Endif

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpSin  ³ Autor ³ R.H. - Marinaldo      ³ Data ³09/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Contribuicoes Sindicais                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpSin()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpSin()

Local aConSin	:=	{}
Local aCodFol	:=	{}
Local aChave	:=	{}
Local aSindica	:=	{}
Local cChave	:=	""
Local cSindica	:=	""
Local cDescSin	:=	""
Local cSindAnt	:= ""
Local cDescAnt	:= ""

Local cDet		:=	""
Local nPos		:=	0
Local x			:=	0
Local dDataAux	:=	SRA->RA_ADMISSA
Local cDescACodFol	:= ""
Local lClasOutEmp 	:= .F.

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega aCodFol                                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF !Fp_CodFol(@aCodFol,SRA->RA_FILIAL)
   Return(.F.)
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Seleciona o Arquivo de Transferencias e Retorna Todas as Trans³
³ferencias do Funcionario (Nao Gravara Filial + Matricula  Igua³
³is 7o. Parametro de fTransf).                                 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fTransf(@aChave,,,,,,.T.,.T.)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Grava em aChave  a Situacao Atual do Funcionario              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF aScan( aChave,{ |x| ( x[1] + x[2] ) == ( cEmpAnt + SRA->RA_FILIAL+SRA->RA_MAT ) } ) == 0
    	SRA->( aAdd(aChave,{									 ;
    						cEmpAnt								,; // 01 - Empresa Origem
    						RA_FILIAL+RA_MAT   					,; // 02 - Filial + Matricula Origem  
    						RA_CC								,; // 03 - Centro de Custo Origem
    						cEmpAnt								,; // 04 - Empresa Destino
    						RA_FILIAL+RA_MAT      				,; // 05 - Filial + Matricula Destino
    						RA_CC								,; // 06 - Centro de Custo Destino
							Nil									, ; // 07 - Data da Transferencia
    						}									 ;
    				)											 ;
    		  )
Endif

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verifica se Teve Alteracao de Sindicato                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF Len(aChave) > 0 
	For nPos := 1 To Len(aChave)
		cChave := aChave[nPos,2]
		IF SR9->( dbSeek( cChave + "RA_SINDICA" ,.T.) )
    		dbSelectArea('SR9')
			While SR9->( !Eof()  .and. R9_FILIAL+R9_MAT+R9_CAMPO == cChave + "RA_SINDICA" )
	        	/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Assume Sempre a Ultima Alteracao quando Feita no Mesmo Mes   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	        	IF ( x := aScan( aSindica , { |y| MesAno( y[1] ) == MesAno( SR9->R9_DATA ) } ) ) > 0
	        		aSindica[x,1] := SR9->R9_DATA
	        	 	aSindica[x,2] := Subst(R9_DESC,1,2) 
	        	 	aSindica[x,3] := AllTrim( fDesc("RCE",Subst(R9_DESC,1,2),"RCE_DESCRI",40) )
	        	Else
	        		SR9->( aAdd( aSindica ,{ R9_DATA , Subst(R9_DESC,1,2), AllTrim( fDesc("RCE",Subst(R9_DESC,1,2),"RCE_DESCRI",40) ) } ) )
  	   			EndIF
  	   			dbSelectArea('SR9')
  	   			dbSkip()
			EndDo
		EndIF
	Next nPos
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Acrescenta o Sindicato Atual do Funcionario                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF !Empty(aSindica)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³A Data Correspondente ao Sindicato Atual Deve ser Sempre Maior³
	³Que a ultima Alteracao de Sindicato.                          ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	aAdd( aSindica , { IF(  dDataBase > aSindica[ Len(aSindica) , 1 ] , dDataBase , ( aSindica[Len(aSindica),1] + 360 ) ) , SRA->RA_SINDICA, AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) )  } )
Else
	aSindica := { { dDataBase , SRA->RA_SINDICA, AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) ) } }
EndIF
cSindica := aSindica[ Len(aSindica) , 2 ]
cDescSin := AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40)) 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Ordena as Alteracoes de Sindicato Ordem Crescente de Data    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aSort( aSindica,,,{ |x,y| x[1] < y[1] } )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Preparando Dados Para a Impressao                            ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea("SRD")
For nPos := 1 To Len(aChave)
	cChave	:=	aChave[nPos, 2]
	dbSeek(cChave)
	While SRD->( !Eof() .and. cChave = RD_FILIAL + RD_MAT )
  		lClasOutEmp 	:= .F.
  	    /*
  	    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ So Imprime verba de Contribuicao Sindical                    ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
       	IF !( SRD->RD_PD $ (  aCodFol[068,1] + '_' + aCodFol[246,1] ) ) 
       		SRD->( dbSkip() ) 
			Loop
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Se a contrib.sindical foi efetuada em outra empresa, a descr. ³
		³do sindicato sera a mesma do ID 246                           ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		ElseIf SRD->RD_PD $ aCodFol[246,1] .or.  (! Empty(SRD->RD_EMPRESA) .And. SRD->RD_EMPRESA # cEmpAnt) 
			cDescACodFol	:= fDesc("SRV",aCodFol[246,1], "RV_DESC") 
			lClasOutEmp 	:= .T. 
   	    EndIF 
   	    /*
  	    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Verifica se a Verba pertence a empresa Atual                 ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If 	cEmpAnt # aChave[nPos,1]
       		SRD->( dbSkip() ) 
        	Loop
   	    EndIF	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica periodo de impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SRD->RD_DATARQ < MesAno(dDataIni) .or. SRD->RD_DATARQ > MesAno(dDataFin)
			SRD->(dbSkip())
			Loop
		Endif
   	    
        /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Cabecalho das Contribuicoes Sindicais                        ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		IF Len(aConSin) = 0
			Aadd(aConSin,{STR0013,STR0039 ,STR0055,STR0042} )	//"|Data        | Mes   | Valor            | Sindicato                     |"
        EndIF
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Verifica se a Alteracao de Sindicato esta dentro do Periodo a³ 
		³ Ser Listado.                                                 ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		For x := 1 To Len( aSindica )
			IF SRD->(   LEFT( RD_DATARQ  , 4 ) + Subst( RD_DATARQ , -2 )  ) >= MesAno( dDataAux ) .and. ; 
			   SRD->(   LEFT( RD_DATARQ  , 4 ) + Subst( RD_DATARQ , -2 )  ) <= MesAno( aSindica[x,1] ) 
				If x # 1 .and. SRD->(   LEFT( RD_DATARQ  , 4 ) + Subst( RD_DATARQ , -2 )  ) < MesAno( aSindica[x,1]) 
		    		cSindica := cSindAnt
					cDescSin := cDescAnt
				Else 
		    		cSindica := aSindica[x,2]
					cDescSin := aSindica[x,3]
				Endif
				Exit
		    EndIF 
	    	dDataAux := aSindica[x,1]
    		cSindAnt := aSindica[x,2]
	   	   	cDescAnt := aSindica[x,3]
		Next x 
		SRD->( Aadd(aConSin,{DTOC(RD_DATPGT),Subst( RD_DATARQ , -2 ) ,Transform(RD_VALOR,"@E 999,999,999.99"), If(lClasOutEmp,cDescACodFol, cDescSin ) } ))
		dbSelectArea("SRD")
		dbSkip()
	Enddo
Next nPos

If len(aConSin) > 1
	If nGrafica ==1
		fImpSindG(aConSin)
	Else     
		fImpSindN(aConSin)
	Endif
	lImpressao	:= .T.
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpTra  ³ Autor ³ R.H. - Marinaldo      ³ Data ³10/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Transferencias                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpTra()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpTra()

Local aTransf	:=	{}
Local aTraFE	:=	{}
Local cEmp		:=	""
Local cFil	 	:=	""
Local cCgc		:=	""
Local cDescEmp	:=	""
Local cDescFil	:=	""
Local cEndereco	:=	""
Local cBairro	:=	""
Local cCidade	:=	""
Local cEstado	:=	""
Local cTipEnd	:=	GetMv("MV_PAREND")
Local dDataTra	:=	Ctod('//')
Local nSvRecno	:=	SM0->( Recno () )
Local nTra		:=	0

nColuna	:= 050

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Seleciona o Arquivo de Transferencias e Retorna Todas as Trans³
³ferencias do Funcionario 									   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fTransf(@aTransf,,,,,,,.T.)

For nTra := 1 To Len(aTransf)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Carrega apenas as Transferencias Entre Filiais e Empresas     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If aTransf[nTra,7] >= dDataIni .and. aTransf[nTra,7] <= dDataFin
		//IF !( aTransf[nTra,1] == aTransf[nTra,4] ) .or. !(Subst(aTransf[nTra,2],1,FwGetTamFilial) == Subst(aTransf[nTra,5],1,FwGetTamFilial) )
			aAdd(aTraFE,{aTransf[nTra,1] ,; // Empresa De
						aTransf[nTra,2] ,; // Filial + Matricula De
						aTransf[nTra,3] ,; // Centro de Custo De
						aTransf[nTra,4] ,; // Empresa Para
						aTransf[nTra,5] ,; // Filial + Matricula Para
						aTransf[nTra,6] ,; // Centro de Custo Para
						aTransf[nTra,7] ,; // Data da Transferencia
					     } )
		//EndIF
	Endif
Next nTra

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Reinicializa aTransf                                          ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aTransf := {}


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Preparando Dados Para a Impressao                            ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
For nTra := 1 To Len(aTraFE)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Cabecalho das Transferencias                                 ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF Len(aTransf) = 0
		Aadd(aTransf,{ " "   ,STR0043,"" })	//"|            Empresa de Origem   "
		Aadd(aTransf,{STR0013,STR0045,"" })	//"|Data        Empresa de Destino  "
    EndIf
    /*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Dados da Empresa de Origem                                   ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
   	cEmp		:= aTraFE[nTra,1]
    cFil		:= Subst(aTraFE[nTra,2],1,FwGetTamFilial)
    SM0->( dbSeek(cEmp+cFil) )
    cDescEmp	:= SM0->M0_NOMECOM
    cDescFil	:= SM0->( IF(nFilial == 1 , M0_NOME , M0_FILIAL ) ) 
    cDescCC     := Posicione("CTT",1,xFilial("CTT")+aTraFE[nTra,3],"CTT_DESC01")  //os 3651/15
	
	aAdd(aTransf,{"" , cEmp + "-" + cDescEmp + "C.C.Origem: " + Alltrim(aTraFE[nTra,3]) + "-" + cDescCC  , cFil + " - " + cDescFil } )
	
	cCgc		:= SM0->(Transform(M0_CGC,'@R ##.###.###/####-##') )
	cEndereco	:= SM0->( IF( cTipEnd = "C", M0_ENDCOB , M0_ENDENT ) )
	
	aAdd(aTransf,{"" , IF(SM0->M0_TPINSC = 1 , STR0047 , STR0032 ) + cCgc + Space(01) + STR0049 + cEndereco," " } )//"CEI"###"CGC"###"End.: "

	cBairro		:=	SM0->( IF( cTipEnd = "C", M0_BAIRCOB, M0_BAIRENT ) )
	cCidade		:=	SM0->( IF( cTipEnd = "C", M0_CIDCOB	, M0_CIDENT  ) )
	cEstado		:=	SM0->( IF( cTipEnd = "C", M0_ESTCOB	, M0_ESTENT  ) )

	aAdd(aTransf,{"" ,STR0028 + cBairro + " -" + cCidade + Space(01) + STR0030 + cEstado," " } ) //"Bairro: "###"Cidade: "###"UF: "
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Dados da Empresa de Destino                                  ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cEmp		:= aTraFE[nTra,4]
	cFil		:= Subst(aTraFE[nTra,5],1,FwGetTamFilial)   
	dDataTra	:= aTraFE[nTra,7]
	SM0->( dbSeek(cEmp+cFil) )
	cDescEmp	:= SM0->M0_NOMECOM
	cDescFil	:= SM0->( IF(nFilial == 1 , M0_NOME , M0_FILIAL ) )
    cDescCC     := Posicione("CTT",1,xFilial("CTT")+aTraFE[nTra,6],"CTT_DESC01")    //os 3651/15
	
	aAdd(aTransf,{DTOC(dDataTra), cEmp + " - " + cDescEmp +  "C.C.Destino: " + Alltrim(aTraFE[nTra,6]) + "-" + cDescCC , cFil + " - " + cDescFil } )

	cCgc		:= SM0->(Transform(M0_CGC,'@R ##.###.###/####-##') )  
	cEndereco	:= SM0->( IF( cTipEnd = "C", M0_ENDCOB , M0_ENDENT ) )
	
	aAdd(aTransf,{"" , IF(SM0->M0_TPINSC = 1 , STR0047 , STR0032 ) + cCgc + Space(01) + STR0049 + cEndereco," " })//"CEI"###"CGC"###"End.: "

	cBairro		:=	SM0->( IF( cTipEnd = "C", M0_BAIRCOB, M0_BAIRENT ) )
	cCidade		:=	SM0->( IF( cTipEnd = "C", M0_CIDCOB	, M0_CIDENT  ) )
	cEstado		:=	SM0->( IF( cTipEnd = "C", M0_ESTCOB	, M0_ESTENT  ) )

	aAdd(aTransf, {"" ,STR0028 + cBairro + " - " + cCidade + Space(01) + STR0030 + cEstado," " }) //"Bairro: "###"Cidade: "###"UF: "

	SM0->( dbGoto( nSvRecno ) )
Next nTra

If !Empty(aTransf) .and. Len(aTransf) > 2
	If  nGrafica==1
		fImpTraG(aTransf)
	Else     
		fImpTraN(aTransf)
	Endif
	lImpressao	:= .T.	
Endif
SM0->( dbGoto( nSvRecno ) )
Return


/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpGraf  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico - Ficha  Funcion.º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpGraf(aCampo)
Local cDet 		:= " ",Ix	:= 1
Local nTaman	:= nTam1	:=	nTam2	:= nTamTot	:= 0 
Local cDescFol	:= " "
Local nPosF
Local nCol		:= 0
nLin 	:= 0 
nColuna	:= 050

ImprG(" " ,"C",,,nColuna,,nLin)

nAcampo 	:= Len(aCampo)
nColuna 	:= 050
While  .T.
	cFolder := aCampo[Ix,3]
	nPosF	:= Ascan(aAgrup,{|X| substr(x,10,2) = cFolder })
	cDescFol:= ""		
	cDescFol:=If(nPosF>0, substr(aAgrup[nPosF],12,20) , cDescFol )
	
	//-- Quebra do Agrupamento 
	If nlin >= nLinMax .or. (nLin + 150) > nLinMax
		nLin  := 0
		oPrint:EndPage() 		// Finaliza a pagina
		ImprG(" ","C",,,nColuna,,nLin,oFont10)
	Endif                                          
	
	nLin += 40
	nCol	:= int( ( nColBox - ( Len(cDescFol) * 100 / 7) )) /2
	oPrint:Line(nLin,nColuna-20 ,nLin, nColMax)
	nLin += 25
	oPrint:say(nlin,nCol,cDescFol,oFont10n)
	nLin  += 40
	oPrint:Line(nLin,nColuna-20 ,nLin, nColMax)
	nLin += 40
	While Ix <= nACampo .and. cFolder = aCampo[Ix,3]
     
		nTam1	:= ( Len(aCampo[ix,1]) * 100)/ 8
		nTam2 	:= ( Len(aCampo[ix,2]) * 100)/ 5
		nTaman	:= If( nTam1 > nTam2,nTam1,nTam2)+ 120
    
		IF (nColuna+nTaman) >= nColMax
			nLin 	+= 100
			nColuna := 50
		Endif	
	
		If nlin >= nLinMax .or. (nLin  + 90) >= nLinMax
			nLin  := 0
			oPrint:EndPage() 		// Finaliza a pagina
			ImprG(" ","C",,,nColuna,,nLin,oFont10)
		Endif
	
	    nTamTot	:= nColuna + nTaman 
	    If nTamTot > nColMax 
	    	nTamTot	:= nColMax - 10
	    Endif	
	    
		oPrint:Line(nLin+20,nColuna ,nLin+090 ,nColuna)		//1a vertical
		oPrint:Line(nLin+20,nTamTot ,nLin + 090,nTamTot) 	 	//2a vertical
		oPrint:Line(nLin+090,nColuna,nlin + 090,nTamTot)		//horizontal

		ImprG(aCampo[ix,1],"C",,,nColuna +10,.f.,nlin,oFont08n)					//Cabecalho campo
		ImprG(aCampo[ix,2],"C",,,nColuna +10,.f.,nLin+40,oFont10)					//Detalhe campo
		nLin 	-= 40
		nColuna	+= Int(nTaman)+ 40

		Ix ++
		If Ix > len(aCampo)
			nLin += 150
			oPrint:Line(nLin,050,nlin,nColMax)									//horizontal
			nLin += 050
			If nlin > nLinMax
				nLin  := 0
				oPrint:EndPage() 		// Finaliza a pagina
				ImprG(" ","C",,,nColuna,,nLin,oFont10)
			Endif
			Return
		Endif	
	Enddo
	nLin  	+= 100 
	nColuna	:= 050

	If nlin > nLinMax
		nLin  := 0
		oPrint:EndPage() 		// Finaliza a pagina
		ImprG(" ","C",,,nColuna,,nLin,oFont10)
	Endif
Enddo
Return                

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpNorm  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/

Static Function  fImpNorm(aCampo)
Local cDet 		:= " ",Ix	:= 1
Local nTaman	:= nTam1	:=	nTam2	:= 0 
Local cDescFol	:= " "
Local nPosF

nAcampo 	:= Len(aCampo)
Li 			:= 0 
Impr("","C")


While  .T.
	cFolder := aCampo[Ix,3]
	nPosF	:= Ascan(aAgrup,{|X| substr(x,10,2) = cFolder })
	cDescFol:= ""	
	cDescFol:=If(nPosF>0, substr(aAgrup[nPosF],12,20) , cDescFol )
	
	//-- Quebra do Agrupamento 
	If li >= 60 .or. (Li + 10) > 60
		Impr(" ","P")
	Endif 
	//- Cabecalho Agrupamento    
	cDet	:= repl("-",78)
	nDet	:= (78-Len(alltrim(cDescFol)) ) /2
	Impr( cDet,"C",,,01)
	Impr( "|" ,"C",,,00,.f.)	     
	Impr(cDescFol ,"C",,,nDet,.f.)
	Impr( "|" ,"C",,,79)	     	
	Impr(cDet,"C",,,01)	
	cDet	:= ""		
	While cFolder = aCampo[Ix,3]
		If li >= 60 
			Impr(REPL("-",78),"C")
			Impr(" ","P")
		Endif
					
		If Len(cDet)+Len(aCampo[ix,2])+16 < 78
			cCabCpo := aCampo[ix,1]
			cDet 	+= cCabCpo+Replicate(".",12-Len(cCabCpo))+" :["+aCampo[ix,2]+']'
			cDet 	+= Space(If (Len(cDet)+5 > 78,78-Len(cDet),5))
		Else
			Impr("|"+cDet+Space(78-Len(cDet))+"|","C")
			cCabCpo := aCampo[ix,1]
			cDet 	:= cCabCpo+Replicate(".",12-Len(cCabCpo))+" :["+aCampo[ix,2]+']'
			cDet 	+= Space(If (Len(cDet)+5 > 78,78-Len(cDet),5))
		Endif
		Ix ++
		If Ix > len(aCampo)
			Impr("|"+cDet+Space(78-Len(cDet))+"|","C")
			cDet	:= repl("-",78)
			Impr(cDet,"C")
			Return nil 
		Endif	
	Enddo
Enddo        
cDet	:= repl("-",78)
Impr(cDet,"C")

Li ++
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpSalG  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico                  º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/

Static Function fImpSalG(aSal)
Local N     	:= 0
Local nLinhas	:= 0     
           
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aSal,@nLinhas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fSalBox(nLinhas)
	For N:=1 To Len(aSal)
 		If nLin + 100 > nLinMax
 		
 			fFimPag(aSal,N,@nLinhas) 
 			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fSalBox(nLinhas)
			ImprG(aSal[01,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aSal[01,2],"C",,,0250,.f.,nLin,oFont08)			//-- Cabecalho 			
			ImprG(aSal[01,3],"C",,,0680,.f.,nLin,oFont08)			//-- Cabecalho 	
			ImprG(aSal[01,4],"C",,,0760,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aSal[01,5],"C",,,0830,.f.,nLin,oFont08)			//-- Cabecalho 			
			ImprG(aSal[01,6],"C",,,1250,.f.,nLin,oFont08)			//-- Cabecalho 	
			ImprG(aSal[01,7],"C",,,1450,.f.,nLin,oFont08)			//-- Cabecalho 
			If SR7->( Type("R7_DESCCAR") ) # "U"
				ImprG(aSal[01,8],"C",,,1840,.f.,nLin,oFont08)	// Detalhe campo ( cargo )
			EndIf
			nLin+=50 
		Endif
		ImprG(aSal[n,1],"C",,, 060,.f.,nLin,oFont08)	// Detalhe campo ( Data )
		ImprG(aSal[n,2],"C",,, 250,.f.,nLin,oFont08)	// Detalhe campo ( Desc. Aumento )
		ImprG(aSal[n,3],"C",,, 680,.f.,nLin,oFont08)	// Detalhe campo ( Categoria )
		ImprG(aSal[n,4],"C",,, 760,.f.,nLin,oFont08)	// Detalhe campo ( Pagamento )
		ImprG(aSal[n,5],"C",,, 830,.f.,nLin,oFont08)	// Detalhe campo ( Verba )
		ImprG(aSal[n,6],"C",,,1250,.f.,nLin,oFont08)	// Detalhe campo ( Valor )
		ImprG(aSal[n,7],"C",,,1450,.f.,nLin,oFont08)	// Detalhe campo ( Funcao )
		If SR7->( Type("R7_DESCCAR") ) # "U"
			ImprG(aSal[n,8],"C",,,1840,.f.,nLin,oFont08)	// Detalhe campo ( cargo )
		EndIf
		nLin += 50 
	Next N
	ImprG("","C",,,,,nLinhas)              
Return  

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpSalN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function fImpSalN(aSal)

Local N,M, nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")

//-- Box Detalhe 
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|          |                    |     |     |                    |             |")
aAdd(aDetalhe,"|          |                    |     |     |                    |             |")
aAdd(aDetalhe,"|          |                    |     |     |                    |             |")
aAdd(aDetalhe,"|----------+--------------------+-----+-----+--------------------+-------------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //          10        20        30        40        50        60        70       
             // 99/99/9999                                                       99,999,999.99
nDet	:= (78 - Len(STR0015)) / 2 
aDetalhe[2]	:= sTuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0015)) , oEmtoAnsi(STR0015) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aSal[1,1]),aSal[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],14,len(aSal[1,2]),aSal[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],35,len(aSal[1,3]),aSal[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],41,len(aSal[1,4]),aSal[1,4])
aDetalhe[4]	:= Stuff(aDetalhe[4],47,len(aSal[1,5]),aSal[1,5])
aDetalhe[4]	:= Stuff(aDetalhe[4],68,len(aSal[1,6]),aSal[1,6])
aDetalhe[5]	:= Stuff(aDetalhe[5],13,len(aSal[1,7]),aSal[1,7])
aDetalhe[6]	:= Stuff(aDetalhe[6],13,len(aSal[1,8]),aSal[1,8])

If (LI +  Len(aDetalhe) + Len(aSal) + 04 ) >= 60
	Impr("","P")
Endif

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	
	                                    
For N:=2 To Len(aSal)
	Impr("|"+ aSal[n,1]					,"C",,,00,.F. )		//-- Data Alteracao
	Impr("|"+ aSal[n,2]					,"C",,,11,.F. )		//-- Descricao 
	Impr("|"+ aSal[n,3]					,"C",,,32,.F. )		//-- Categoria 
	Impr("|"+ aSal[n,4]					,"C",,,38,.F. )		//-- pgto
	Impr("|"+ aSal[n,5]					,"C",,,44,.F. )		//-- Verba
	Impr("|"+ aSal[n,6]					,"C",,,65,.F. )		//-- Valor 
	Impr("|"           					,"C",,,79,.T. )
	Impr("|"            				,"C",,,00,.F. ) 
	Impr("|"+ aSal[n,7]					,"C",,,11,.F. )
	Impr("|"            				,"C",,,32,.F. )
	Impr("|"            				,"C",,,38,.F. )
	Impr("|"            				,"C",,,44,.F. )
	Impr("|"            				,"C",,,65,.F. )
	Impr("|"            				,"C",,,79,.T. )
	Impr("|"            				,"C",,,00,.F. ) 
	Impr("|"+ Substr(aSal[n,8],1,20)	,"C",,,11,.F. )
	Impr("|"            				,"C",,,32,.F. )
	Impr("|"            				,"C",,,38,.F. )
	Impr("|"            				,"C",,,44,.F. )
	Impr("|"            				,"C",,,65,.F. )
	Impr("|"           					,"C",,,79,.T. )
Next n
Impr("","C") 
Impr(aDetalhe[1],"C")
Return  
/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpCatG  ºAutor  ³Desenv - SSERVICE   º Data ³  27/05/08   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpCatG(aCat)
Local nLinhas	:= 0
Local N 		:= 0 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aCat,@nLinhas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fCatBox(nLinhas) 
	
	For N:=1 To Len(aCat)
 		If nLin + 100 > nLinMax
 			
 			fFimPag(aCat,N,@nLinhas) 
 			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fCatBox(nLinhas)
			ImprG(aCat[01,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aCat[01,2],"C",,,0260,.f.,nLin,oFont08)			//-- Cabecalho 			
			nLin+=50 
		Endif
		ImprG(aCat[n,1],"C",,, 060,.f.,nLin,oFont08)				// Detalhe campo 
		ImprG(aCat[n,2],"C",,, 260,.f.,nLin,oFont08)				// Detalhe campo
		nLin += 50
	Next N
	ImprG("","C",,,,,nLinhas)                      
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpCatN  ºAutor  ³Desenv - SSERVICE   º Data ³  27/05/08   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpCatN(aCat)
Local N ,M , nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")

//-- Box Detalhe 
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|             |                                                                |")
aAdd(aDetalhe,"|-------------+--------------------------------------------------+-------------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - len("Alteracao de Categoria") ) /2
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi("Alteracao de Categoria")) , oEmtoAnsi("Alteracao e Categoria") )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aCat[1,1]),aCat[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],17,len(aCat[1,2]),aCat[1,2]) 

If (li + Len(aDetalhe) + Len(aCat)+ 04  ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	
	
For N:=2 To Len(aCat)
	Impr("|"+ aCat[n,1],"C",,,00,.F. )
	Impr("|"+ aCat[n,2],"C",,,14,.F. )
	Impr("|","C",,,79 )
Next n
Impr(aDetalhe[1],"C")
Return  

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpAfasG ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpAfasG(aAfas)
Local nLinhas	:= 0
Local N 		:= 0 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aAfas,@nLinhas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fAfastBox(nLinhas) 
	
	For N:=1 To Len(aAfas)
 		If nLin + 100 > nLinMax
 			
 			fFimPag(aAfas,N,@nLinhas) 
 			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fAfastBox(nLinhas)
			ImprG(aAfas[01,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aAfas[01,2],"C",,,0260,.f.,nLin,oFont08)			//-- Cabecalho 			
			ImprG(aAfas[01,3],"C",,,1250,.f.,nLin,oFont08)			//-- Cabecalho 	
			ImprG(aAfas[01,4],"C",,,1550,.f.,nLin,oFont08)			//-- Cabecalho 
			nLin+=50 
		Endif
		ImprG(aAfas[n,1],"C",,, 060,.f.,nLin,oFont08)				// Detalhe campo 
		ImprG(aAfas[n,2],"C",,, 260,.f.,nLin,oFont08)				// Detalhe campo
		ImprG(aAfas[n,3],"C",,,1250,.f.,nLin,oFont08)				// Detalhe campo
		ImprG(aAfas[n,4],"C",,,1550,.f.,nLin,oFont08)				// Detalhe campo
		nLin += 50
	Next N
	ImprG("","C",,,,,nLinhas)                      
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpAfasN ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpAfasN(aAfas)
Local N ,M , nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")

//-- Box Detalhe 
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|             |                                    |             |             |")
aAdd(aDetalhe,"|-------------+------------------------------------+-------------+-------------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - len(STR0018) ) /2
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0018)) , oEmtoAnsi(STR0018) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aAfas[1,1]),aAfas[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],17,len(aAfas[1,2]),aAfas[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],54,len(aAfas[1,3]),aAfas[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],68,len(aAfas[1,4]),aAfas[1,4])

If (li + Len(aDetalhe) + Len(aAfas)+ 04  ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	
	
For N:=2 To Len(aAfas)
	Impr("|"+ aAfas[n,1],"C",,,00,.F. )
	Impr("|"+ aAfas[n,2],"C",,,14,.F. )
	Impr("|"+ aAfas[n,3],"C",,,51,.F. )
	Impr("|"+ aAfas[n,4],"C",,,65,.F. )
	Impr("|","C",,,79 )
Next n
Impr(aDetalhe[1],"C")
Return  

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpFeriaGºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico                  º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpFeriaG(aFerias)
Local nLinhas	:= 0
Local N 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aFerias,@nLinhas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fFerBox(nLinhas) 
	For N:=1 To Len(aFerias)
		If nLin + 100 > nLinMax

 			fFimPag(aFerias,N,@nLinhas) 
 			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fFerBox(nLinhas)
			ImprG(aFerias[01,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aFerias[01,2],"C",,,0410,.f.,nLin,oFont08)			//-- Cabecalho 			
			ImprG(aFerias[01,3],"C",,,0810,.f.,nLin,oFont08)			//-- Cabecalho 	
			ImprG(aFerias[01,4],"C",,,1160,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aFerias[01,5],"C",,,1510,.f.,nLin,oFont08)			//-- Cabecalho 			
			ImprG(aFerias[01,6],"C",,,1910,.f.,nLin,oFont08)			//-- Cabecalho 			
			nLin+=50 
		Endif
		ImprG(aFerias[n,1],"C",,, 060,.f.,nLin,oFont08)				// Detalhe campo
		ImprG(aFerias[n,2],"C",,, 410,.f.,nLin,oFont08)               // Detalhe campo
        ImprG(aFerias[n,3],"C",,, 810,.f.,nLin,oFont08)               // Detalhe campo
        ImprG(aFerias[n,4],"C",,,1160,.f.,nLin,oFont08)               // Detalhe campo
        ImprG(aFerias[n,5],"C",,,1510,.f.,nLin,oFont08)               // Detalhe campo
        ImprG(aFerias[n,6],"C",,,1910,.f.,nLin,oFont08)               // Detalhe campo
		nLin += 50 
	Next
	ImprG("","C",,,,,nLinhas)                  
Return


/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpFeriaNºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpFeriaN(aFerias)
Local N ,M , nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")

//-- Box Detalhe 
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|                       |                         |              |             |")
aAdd(aDetalhe,"|-----------------------+-------------------------+--------------+-------------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0021)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0021)) , oEmtoAnsi(STR0021) )
aDetalhe[4]	:= Stuff(aDetalhe[4],03,len(aFerias[1,1]),aFerias[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],27,len(aFerias[1,2]),aFerias[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],53,len(aFerias[1,3]),aFerias[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],68,len(aFerias[1,4]),aFerias[1,4])

If (li + Len(aDetalhe) + Len(aFerias)+ 04 ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	
	
For N:=2 To Len(aFerias)
	Impr("|"+aFerias[n,1],"C",,,00,.F.)
	Impr("|"+aFerias[n,2],"C",,,24,.F.)
	Impr("|"+aFerias[n,3],"C",,,50,.F.)
	Impr("|"+aFerias[n,4],"C",,,65,.F.)
	Impr("|","C",,,79 )
Next N
Impr(aDetalhe[1],"C")
Return 


/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpCadG  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico                  º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpCadG(aAltCad)
Local nLinhas	:= 0
Local N 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aAltCad,@nLinhas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fAltCadBox(nlinhas)
	
	For N:=1 To Len(aAltCad)
		If nLin + 100 > nLinMax

			fFimPag(aAltCad,N,@nLinhas) 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fAltCadBox(nLinhas)
			ImprG(aAltCad[01,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aAltCad[01,2],"C",,,0360,.f.,nLin,oFont08)			//-- Cabecalho 			
			ImprG(aAltCad[01,3],"C",,,0810,.f.,nLin,oFont08)			//-- Cabecalho 	
			nLin+=50 
		Endif	
		ImprG(aAltCad[n,1],"C",,, 060,.f.,nLin,oFont08)				// Detalhe campo  Data
		ImprG(aAltCad[n,2],"C",,, 360,.f.,nLin,oFont08)				// Detalhe campo  Campo Alt
		ImprG(aAltCad[n,3],"C",,, 810,.f.,nLin,oFont08)				// Detalhe campo  Descricao
		nLin += 50 
	Next N
	ImprG("","C",,,,,nLinhas)
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpCadN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpCadN(aAltCad)
Local N , M, nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")
       
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|             |                   |                                            |")
aAdd(aDetalhe,"|-------------+-------------------+--------------------------------------------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       

nDet	:= (78 - Len(STR0024)) / 2  
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0024)) , oEmtoAnsi(STR0024) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aAltCad[1,1]),aAltCad[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],17,len(aAltCad[1,2]),aAltCad[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],37,len(aAltCad[1,3]),aAltCad[1,3]) 


If ( Li + Len(aDetalhe) + Len(aAltCad) + 04 ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	

For n:= 2 to Len(aAltCad)
	Impr("|"+aAltCad[n,1],"C",,,00,.F.)
	Impr("|"+aAltCad[n,2],"C",,,14,.F.)
	Impr("|"+aAltCad[n,3],"C",,,34,.F.)
	Impr("|","C",,,79 )
Next n 

Impr(aDetalhe[1],"C")
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpDepG  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico                  º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpDepG(aDep)
Local nLinhas	:= 0
Local N 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aDep,@nLinhas)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fDepBox(nLinhas)
	For N:=1 To Len(aDep)
	
		If nLin + 100 > nLinMax

			fFimPag(aDep,N,@nLinhas)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fDepBox(nLinhas)
			ImprG(aDep[01,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 
			ImprG(aDep[01,2],"C",,,0210,.f.,nLin,oFont08)			//-- Cabecalho 			
			ImprG(aDep[01,3],"C",,,0900,.f.,nLin,oFont08)			//-- Cabecalho 	
			ImprG(aDep[01,4],"C",,,0120,.f.,nLin,oFont08)			//-- Cabecalho 	
			ImprG(aDep[01,5],"C",,,1410,.f.,nLin,oFont08)			//-- Cabecalho
			ImprG(aDep[01,6],"C",,,1710,.f.,nLin,oFont08)			//-- Cabecalho
			ImprG(aDep[01,7],"C",,,1910,.f.,nLin,oFont08)			//-- Cabecalho
			nLin+=50 
		Endif	
	
		ImprG(aDep[n,1],"C",,, 060,.f.,nLin,oFont08)				// Detalhe campo Cod		    
		ImprG(aDep[n,2],"C",,, 210,.f.,nLin,oFont08)				// Detalhe campo Nome
		ImprG(aDep[n,3],"C",,, 900,.f.,nLin,oFont08)				// Detalhe campo Dt nasc
		ImprG(aDep[n,4],"C",,,1200,.f.,nLin,oFont08)				// Detalhe campo Sexo
		ImprG(aDep[n,5],"C",,,1410,.f.,nLin,oFont08)				// Detalhe campo Parentesco
		If cPaisLoc <> "MEX"
			// Mexico nao possui IR Dependentes e Salario Familia
			ImprG(aDep[n,6],"C",,,1710,.f.,nLin,oFont08)				// Detalhe campo Dep IR		
			ImprG(aDep[n,7],"C",,,1910,.f.,nLin,oFont08)				// Detalhe campo Dep S.Fam.
		EndIf
		nLin += 50 
	Next            
	ImprG("","C",,,,,nLinhas)
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpDepN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpDepN(aDEp)
Local N , M , nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
// Mexico nao possui IR Dependentes e Salario Familia
If cPaisLoc == "MEX"
	aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
	aAdd(aDetalhe,"|   |                              |          |    |                           |")
	aAdd(aDetalhe,"|---+------------------------------+----------+----+---------------------------|")
Else
	aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
	aAdd(aDetalhe,"|   |                              |          |    |         |      |          |")
	aAdd(aDetalhe,"|---+------------------------------+----------+----+---------+------+----------|")
EndIf
             //|99 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/9999| X       X       X        X    |
             //|Cod|Nome                           Dt.Nasc.   Sexo Parent  |Dp.IR.|Dp.S.Fam. |"  
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0026)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0026)) , oEmtoAnsi(STR0026) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,(len(Trim(aDep[1,1]))+1),aDep[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],06,len(aDep[1,2]),aDep[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],37,len(aDep[1,3]),aDep[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],48,len(aDep[1,4]),aDep[1,4]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],53,len(aDep[1,5]),aDep[1,5]) 
If cPaisLoc <> "MEX"
	aDetalhe[4]	:= Stuff(aDetalhe[4],63,len(aDep[1,6]),aDep[1,6])
	aDetalhe[4]	:= Stuff(aDetalhe[4],70,len(aDep[1,7]),aDep[1,7]) 
Endif

If (Li + Len(aDetalhe) + Len(aDep)+ 04 ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	

For N:=2  to Len(aDep)
	Impr("|"+aDep[n,1],"C",,,00,.F.)		//--Codigo
	Impr("|"+aDep[n,2],"C",,,04,.F.)		//--Dependente
	Impr("|"+aDep[n,3],"C",,,35,.F.)		//--Dt.Nasc.
	Impr("|"+substr(aDep[n,4],1,4),"C",,,46,.F.)		//--Sexo
	Impr("|"+aDep[n,5],"C",,,51,.F.)	//--Parent
	If cPaisLoc <> "MEX"
		Impr("|"+aDep[n,6],"C",,,61,.F.)	//--Dp.Ir.
		Impr("|"+aDep[n,7],"C",,,68,.F.)	//--Dp.S.Fam.
	EndIf
	Impr("|","C",,,79 )
Next N

Impr(aDetalhe[1],"C")
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpBenG  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico                  º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpBenG(aBenef)
Local nLinhas	:= 0
Local N 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aBenef,@nLinhas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fBenefBox(nlinhas)
	
	For N:=1 To Len(aBenef)
		If nLin + 100 > nLinMax      
		
			fFimPag(aBenef,N,@nLinhas) 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fBenefBox(nLinhas)
			ImprG(aBenef[01,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 				
			ImprG(aBenef[01,2],"C",,,0210,.f.,nLin,oFont08)			//-- Cabecalho 				
			nLin+=50
		Endif	
		ImprG(aBenef[n,1],"C",,, 060,.f.,nLin,oFont08)				// Detalhe campo		    
		ImprG(aBenef[n,2],"C",,, 210,.f.,nLin,oFont08)				// Detalhe campo
		nLin += 50 
	Next            
	ImprG("","C",,,,,nLinhas)
Return              


/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpBenN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpBenN(aBenef)
Local N , M , nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|    |                                                                         |") 
aAdd(aDetalhe,"|----+-------------------------------------------------------------------------|")
             //|Cod |Beneficiario 
             //  99
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0060)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0060)) , oEmtoAnsi(STR0060) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aBenef[1,1]),aBenef[1,1])
aDetalhe[4]	:= Stuff(aDetalhe[4],07,len(aBenef[1,2]),aBenef[1,2])

If (Li + Len(aDetalhe) + Len(aBenef) + 04 ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	

For N:=2  to Len(aBenef)
	Impr("|"+aBenef[n,1],"C",,,00,.F.)
	Impr("|"+aBenef[n,2],"C",,,05,.F.)
	Impr("|","C",,,79 )
Next N

Impr(aDetalhe[1],"C")
Return

       
/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpSindG ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico                  º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpSindG(aConSin)

Local nLinhas	:= 0
Local nPos		:= 0 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aConSin,@nLinhas)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fContSindBox(nLinhas)

	For nPos:=1 To Len(aConSin)
		If nLin + 100 > nLinMax      
		
			fFimPag(aConSin,nPos,@nLinhas)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fContSindBox(nLinhas)	
			ImprG(aConSin[01,1]           ,"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 				
			ImprG(aConSin[01,2]           ,"C",,,0310,.f.,nLin,oFont08)			//-- Cabecalho 				
			ImprG(aConSin[01,3]           ,"C",,,0700,.f.,nLin,oFont08)			//-- Cabecalho 				
			ImprG(left(aConSin[nPos,4],50),"C",,,1140,.f.,nLin,oFont10)			//-- Detalhe campo
			nLin+=50                                                                   
		Endif	
		ImprG(aConSin[nPos,1],"C",,, 060,.f.,nLin,oFont08)				// Detalhe campo		    
		ImprG(aConSin[nPos,2],"C",,, 310,.f.,nLin,oFont08)				// Detalhe campo
		ImprG(aConSin[nPos,3],"C",,, 700,.f.,nLin,oFont08)				// Detalhe campo
		ImprG(left(aConSin[nPos,4],50),"C",,,1140,.f.,nLin,oFont10)	// Detalhe campo
		nLin += 50 
	Next nPos
	ImprG("","C",,,,,nLinhas)
Return
       
/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpSindN ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpSindN(aConSin)
Local N , M , nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|           |       |               |                                          |")
aAdd(aDetalhe,"|-----------+-------+---------------+------------------------------------------|")
            //"|Data       | Mes   |          Valor| Sindicato                                |"
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0036)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0036)) , oEmtoAnsi(STR0036) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aConSin[1,1]),aConSin[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],14,len(aConSin[1,2]),aConSin[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],22,len(aConSin[1,3]),aConSin[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],38,len(aConSin[1,4]),aConSin[1,4]) 
                                
If ( LI + Len(aDetalhe) + Len(aConSin)+ 04 ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	

For N:=2  to Len(aConSin)
	Impr("|"+aConSin[n,1],"C",,,00,.F.)
	Impr("|"+aConSin[n,2],"C",,,12,.F.)
	Impr("|"+aConSin[n,3],"C",,,20,.F.)
	Impr("|"+left(aConSin[n,4],40), "C",,,36,.F.)
	Impr("|","C",,,79 )	
Next N

Impr(aDetalhe[1],"C")
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpTraG  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Grafico                  º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpTraG(aTransf)
Local nLinhas	:= 0
Local nTra
Local nY 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Quebra de Pagina                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTestaQuebra(aTransf,@nLinhas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box Detalhe                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTranBox(nLinhas)
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Imprimindo Transferencias                                    ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	For nTra=1 To Len(aTransf)
 		
 		If nLin + 100 > nLinMax
 		
			fFimPag(aTransf,NTra,@nLinhas) 

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box Detalhe                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fTranBox(nLinhas)
			For nY = 1 to 2
				ImprG(aTransf[nY,1],"C",,,0060,.f.,nLin,oFont08)			//-- Cabecalho 
				ImprG(aTransf[nY,2],"C",,,0260,.f.,nLin,oFont08)			//-- Cabecalho 			
				ImprG(aTransf[nY,3],"C",,,1080,.f.,nLin,oFont08)			//-- Cabecalho 	
				nLin+=50 
			Next nY 
		Endif

		If !Empty(aTransf[nTra,1])
			ImprG(aTransf[nTra,1],"C",,,060,.f.,nLin,oFont08)				//Detalhe campo	
		Endif	
		ImprG(aTransf[nTra,2],"C",,, 260,.f.,nLin,oFont08)					//Detalhe campo
		ImprG(aTransf[nTra,3],"C",,,1800,.f.,nLin,oFont08)					//Detalhe campo			
		nLin += 50 
	Next nTra
	ImprG("","C",,,,,nLinhas)
Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpTraN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
*/
Static Function  fImpTraN(aTransf)
Local N , M , nDet
Local aDetalhe	:= {}

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|           |                                                                  |")
aAdd(aDetalhe,"|           |                                                                  |")
aAdd(aDetalhe,"|-----------+------------------------------------------------------------------|")
            //"|           | Empresa de Origem                                                | "
            //"|Data       | Empresa de Destino                                               | "
            // 12345678901234567890123456789012345678901234567890123456789012345678901234567890
            //          10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0041)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0041)) , oEmtoAnsi(STR0041) )
aDetalhe[4]	:= Stuff(aDetalhe[4],14,len(aTransf[1,2]),aTransf[1,2])
aDetalhe[4]	:= Stuff(aDetalhe[4],65,len(aTransf[1,3]),aTransf[1,3])
aDetalhe[5]	:= Stuff(aDetalhe[5],02,len(aTransf[2,1]),aTransf[2,1])
aDetalhe[5]	:= Stuff(aDetalhe[5],14,len(aTransf[2,2]),aTransf[2,2])
aDetalhe[5]	:= Stuff(aDetalhe[5],65,len(aTransf[2,3]),aTransf[2,3])

If ( Li + Len(aDetalhe) + Len(aTransf)+ 04  ) >= 60
	Impr("","P")
Endif	

For m:= 1 to Len(aDetalhe)
	Impr(aDetalhe[m],"C")
Next m	

For N:=3  to Len(aTransf)
	Impr("|","C",,,00,.F.)
	If !empty(aTransf[n,3])
		Impr("|"+aTransf[n,3],"C",,,12,.F.)
		Impr("|","C",,,79 )	
	Endif
	If !empty(aTransf[n,1] )
		Impr("|"+aTransf[n,1],"C",,,00,.F.)
	endif	
	Impr("|"+aTransf[n,2],"C",,,12,.F.)
	Impr("|","C",,,79 )	
Next N
Impr(aDetalhe[1],"C")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabecGraf ºAutor  ³Microsiga - Natie   º Data ³  12/18/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION cabecGraf(cTitulo,cCabec1,cCabec2,cNomPrg,nTamanho,aCustomText,lPerg)

Local nLargura
Local nLin	:=0
Local lNUse := cPaisLoc == "PER"

Default aCustomText := Nil // Parâmetro que se passado suprime o texto padrao desta função por outro customizado

nlargura:= IF(nTamanho=="P",2250,IF(nTamanho=="G",2300,2500))
cTitulo :=Iif(TYPE("NewHead")!="U",NewHead,cTitulo)
cNomPrg := Alltrim(cNomPrg)

	
//Box Itens
oPrint:Box( 330, 30, nLinMax, 2350 )
                  
nLin 	:= 410
nColuna	:= 100

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Imprime box com foto funcionario                             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If lFirst
   	//-- Verifica foto do funcionario
	fFoto()
	
	nColuna	:= 600
	If  Len(aCustomText) >0
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Imprime texto de outro cabecalho passado no array            ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		//-- Desenha Cabecalho 
		oPrint:Line(nlin,nColuna-10  ,nlin+60, nColuna-10)			//1a linha
		oPrint:Line(nlin,nColuna+1180,nlin+60, nColuna+1180)		//1a linha
		oPrint:Line(nlin+60,nColuna-10  ,nlin+60, nColuna+1180)		// Horizontal
		oPrint:say(nLin,ncoluna,aCustomText[1],oFont10)				//Empresa	
		
		oPrint:Line(nlin,nColuna+1190,nlin+60, nColuna+1190)		//1a linha
		oPrint:Line(nlin,nColuna+1700,nlin+60, nColuna+1700)		//1a linha
		oPrint:Line(nlin+60,nColuna+1190,nlin+60, nColuna+1700)		//Horizontal
		oPrint:say(nLin,ncoluna+1200,aCustomText[2],oFont10)			//Filial  
		nLin +=90	                 
		
		oPrint:Line(nlin,nColuna-10  ,nlin+60, nColuna-10)			//2a Linha
		oPrint:Line(nlin,nColuna+1700,nLin+60, nColuna+1700)		//2a Linha
		oPrint:Line(nlin+60,nColuna-10  ,nlin+60, nColuna+1700)		//Horizontal
		oPrint:say(nLin,ncoluna,aCustomText[3],oFont10)                //Endereco
		nLin +=90			
		oPrint:Line(nlin,nColuna-10  ,nlin+60 , nColuna-10)			//3a Linha
		oPrint:Line(nlin,nColuna+1180,nlin+60 , nColuna+1180)		//3a Linha
		oPrint:Line(nlin+60,nColuna-10  ,nlin+60 , nColuna+1180)		// Horizontal
		oPrint:say(nLin,ncoluna,aCustomText[4],oFont10)                //Municipio
		
		oPrint:Line(nlin,nColuna+1190,nlin+60, nColuna+1190)		//3a Linha
		oPrint:Line(nlin,nColuna+1700,nlin+60, nColuna+1700)		//3a Linha
		oPrint:Line(nlin+60,nColuna+1190,nlin+60, nColuna+1700)		// Horizontal
		oPrint:say(nLin,ncoluna+1200,aCustomText[5],oFont10)           //Cep
		nLin +=90
	
		oPrint:Line(nlin,nColuna-10 ,nlin+60, nColuna-10)			//4a Linha
		oPrint:Line(nlin,nColuna+600,nLin+60, nColuna+600)			//4a Linha
		oPrint:Line(nlin+60,nColuna-10 ,nlin+60, nColuna+600)			// Horizontal
		oPrint:say(nLin,ncoluna,aCustomText[6],oFont10)            	//CGC
				
		IF cPaisLoc <> "ANG"
			oPrint:Line(nlin,nColuna+620 ,nlin+60, nColuna+620)			//4a Linha
			oPrint:Line(nlin,nColuna+1180,nlin+60, nColuna+1180)		//4a Linha
			oPrint:Line(nlin+60,nColuna+620 ,nlin+60, nColuna+1180)		// Horizontal       
			oPrint:say(nLin,ncoluna+630,aCustomText[7],oFont10)   		    //CNAE
			oPrint:Line(nlin,nColuna+1190,nlin+60, nColuna+1190)		//4a Linha
			oPrint:Line(nlin,nColuna+1700,nlin+60, nColuna+1700)		//4a Linha
			oPrint:Line(nlin+60,nColuna+1190,nlin+60, nColuna+1700)		//Cod.Municipio
			oPrint:say(nLin,ncoluna+1200,aCustomText[8],oFont10)
		Else
			oPrint:Line(nlin,nColuna+620 ,nlin+60, nColuna+620)			//4a Linha
			oPrint:Line(nlin,nColuna+1180,nlin+60, nColuna+1180)		//4a Linha
			oPrint:Line(nlin+60,nColuna+620 ,nlin+60, nColuna+1180)		// Horizontal       		
			oPrint:say(nLin,ncoluna+630,aCustomText[8],oFont10)
		Endif
	Endif
	lfirst	:= .F. 
	nLin 	+= 100
Endif

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Imprime Funcionario                                          ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 

oPrint:Line(nLin+15 ,nColuna-10  ,nLin+090 , nColuna-10  )		//1a vertical 
oPrint:Line(nLin+15 ,nColuna+300 ,nLin+090 , nColuna+300 )		//2a vertical 
oPrint:Line(nLin+90 ,nColuna-10  ,nlin+090 , nColuna+300 )		//horizontal 
oPrint:say(nLin     ,nColuna,"No Ficha"   ,oFont08n ) 			//Ficha 
oPrint:say(nLin+40  ,nColuna,If(!lNUse,SRA->RA_FICHA,""),oFont12n) 

oPrint:Line(nLin+15 ,nColuna+310 ,nLin+090 , nColuna+310)		//1a vertical
oPrint:Line(nLin+15 ,nColuna+700 ,nLin+090 , nColuna+700)		//2a vertical 
oPrint:Line(nLin+90 ,nColuna+310 ,nlin+090 , nColuna+700)		//horizontal
oPrint:say(nLin     ,nColuna+320,STR0004,oFont08n) 
oPrint:say(nLin+40  ,nColuna+320,SRA->RA_MAT,oFont12n)

oPrint:Line(nLin+15 ,nColuna+710  ,nLin+090  , nColuna+710)	//1a vertical
oPrint:Line(nLin+15 ,nColMax-10   ,nLin+090  , nColMax-10 )	//2a vertical 
oPrint:Line(nLin+090,nColuna+710  ,nlin+090  , nColMax-10 )	//horizontal
oPrint:say(nLin     , nColuna+720 ,STR0006   , oFont08n)
oPrint:Say(nLin+40  , nColuna+720 ,SRA->RA_NOME,oFont12n)

nLin 	+= 150
nColuna := 50

If LEN(Trim(cCabec1)) != 0
	ImprG(cCabec1,"C",,,nColuna,.T. ,nLin,oFont12)
	If LEN(Trim(cCabec2)) != 0
		ImprG(cCabec2,"C",,,nColuna,.T. ,nLin,oFont12)
	EndIf 
	oPrint:Line(nLin,nColuna-20,nLin,nColMax)
	nLin 	+=40
Else	
	oPrint:Line(nLin,nColuna-20,nLin,nColMax)
EndIf

m_pag++

nLin+= 40

Return nLin

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER460   ºAutor  ³Microsiga           º Data ³  02/19/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Rodape Grafico                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRodaPe(wcbcont,wcbtxt,roda_tam)
Local cFileLogo	:= ""

//-- Carrega Logotipo para impressao 
fCarLogo(@cFileLogo) 

oPrint:Line(nLinMax+020,050,nLinMax+020,nColMax)			      	// Linha horizontal 
IF File(cFilelogo)
	oPrint:SayBitmap(nLinMax + 040,50, cFileLogo,300,080) 			// Tem que estar abaixo do RootPath
Endif	
oPrint:say(nLinMax +060,2000, RptEnd+" "+Time(),oFont08)
oPrint:Line(nLinMax+100,050,nLinMax+100,nColMax)			      	// Linha horizontal 
oPrint:EndPage()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImprG     ºAutor  ³Microsiga           º Data ³  18/02/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprG( cDetalhe , cFimFolha , nReg , cRoda , nColun , lSalta , nLinha,oFont)

Local aCabec := {}
Local cDetCab:= ""
Local cWCabec:= ""
Local nCb	 := 0
Local nLargura := IF(nTamanho=="P",2250,IF(nTamanho=="G",2300,2500))

Static lPerg 

m_pag		:= ContFl
cFimFolha	:= IF( cFimFolha		== NIL							  		, ""		, cFimFolha	)
cDetalhe	:= IF( cDetalhe			== NIL							  		, ""		, cDetalhe	)
wCabec0 	:= IF( Type("wCabec0")	== "U"							  		, 0			, wCabec0	)
wCabec1 	:= IF( Type("wCabec1")	== "U"							  		, ""		, wCabec1	)
wCabec2 	:= IF( Type("wCabec2")	== "U"							  		, ""		, wCabec2	)
nReg		:= IF( nReg				== NIL							  		, 0.00		, nReg		)
wnRel		:= IF( Type("wnRel")	== "U" .and. Type("nomeprog") != "U"	, nomeprog	, wnRel		)
nColun 		:= IF( nColun			== NIL							  		, 0			, nColun	)
nLinha		:= IF( nLinha			== NIL							  		, 0			, nLinha	)
lSalta		:= IF( lSalta 			== NIL							  		, .T. 		, lSalta	)


IF Upper(cFimFolha) $ "FP" .or. nLinha >= nLinMax
	IF nLinha != 0.00
		IF Upper(cFimFolha) $ "F" .or. cRoda != NIL
			IF nReg == 0.00 .or. cRoda == NIL
				fRodaPe( 0.00 , ""    , nTamanho)
			Else
				fRodaPe( nReg , cRoda , nTamanho)
			EndIF
		EndIF
		nLinha := 0.00
	EndIF
	IF Upper(cFimFolha) $ "FP"
		Return( NIL )
	EndIF
EndIF

IF nLinha == 0.00
	oPrint:StartPage() 			//Inicia uma nova pagina
	SendCab1(nLargura,nLinha, nColun)
	For nCb := 1 to wCabec0-1
		IF Type((cWCabec := "wCabec"+Alltrim(Str(nCb)))) != "U"
			cDetCab := &(cWCabec)
			aAdd(aCabec,cDetCab)
		EndIF
	Next nCb
	nlinha:=  CabecGraf( Titulo , "" , "" , wnrel , nTamanho ,aCabec, lPerg )
	ContFl++
EndIF                         

//-- Imprime linha de detalhe 
oPrint:say(nLinha,nColun,cDetalhe,oFont)

IF lSalta
	nLinha += 40
Endif

nLin	:= nLinha
nColuna	:= nColun

Return nlin


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SendCab1  ºAutor  ³Microsiga           º Data ³  18/02/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SendCab1(nSpace,nLinha, nColun)

Local cDetCab 	:= ""
Local nEspaco 	:= 0
Local cFileLogo	:= ""

//-- Carrega Logotipo para impressao 
  fCarLogo(@cFileLogo) 

// Nome da Empresa / Pagina  / Logotipo
oPrint:Line(020,nColun-20,020,nColMax)
If File(cFilelogo)
	oPrint:SayBitmap(045,50, cFileLogo,400,090) // Tem que estar abaixo do RootPath
Endif	
cDetCab 	:=  STR0120 +" " + TRANSFORM(m_pag,'999999')
oPrint:say(100, 1950  ,cDetCab,oFont10)

// Versão     
cDetCab := "SIGA /"+wnrel+"/v."+cVersao+"  "
oPrint:say(150,nColun -10 ,cDetCab,oFont10)

//-- Titulo 
cDetCab := Trim(Titulo)
nEspaco	:= (nColMax - Len(AllTrim(Titulo)) *100 / 6 ) / 2
oPrint:say(150, nEspaco , cDetCab, oFont12n)

cDetCab :=  STR0122 +" "+ DTOC(dDataBase)
oPrint:say(150,1950,cDetCab,oFont10)


// Hora da emissão / Data Emissao
cDetCab := STR0121+" "+time()
oPrint:say(200,nColun-10,cDetCab,oFont10)

cDetCab := STR0124+" "+DToC(MsDate())
oPrint:say(200,1950,cDetCab,oFont10)

oPrint:Line(280,nColun-20,280,nColMax)

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fcarLogo  ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fCarLogo(cLogo)
Local  cStartPath:= GetSrvProfString("Startpath","")

cLogo	:= cStartPath + "LGRL"+FwCodEmp("SM0")+FwCodFil("SM0")+".BMP" // Empresa+Filial
//-- Logotipo da Empresa
If !File( cLogo )
	cLogo := cStartPath + "LGRL"+FwCodEmp("SM0")+".BMP" // Empresa
Endif

Return cLogo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fFoto     ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fFoto()

Local lFile		
Local cBmpPict	:= ""
Local cPath		:= GetSrvProfString("Startpath","")
Local oDlg8
Local oBmp
Local cSAlias := Alias()
Local nSRecno := RecNo()
Local nSOrdem := IndexOrd()

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega a Foto do Funcionario								   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cBmpPict := Upper( AllTrim( SRA->RA_BITMAP)) 
cPathPict 	:= ( cPath + cBmpPict+".BMP" ) 

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Para impressao da foto eh necessario abrir um dialogo para   ³
³ extracao da foto do repositorio.No entanto na impressao,nao  |
³ ha a necessidade de visualiza-lo( o dialogo).Por esta razao  ³
³ ele sera montado nestas coordenadas fora da Tela             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
DEFINE MSDIALOG oDlg8   FROM -1000000,-4000000 TO -10000000,-8000000  PIXEL 
@ -10000000, -1000000000000 REPOSITORY oBmp SIZE -6000000000, -7000000000 OF oDlg8  
	oBmp:LoadBmp(cBmpPict)
	
	//-- Box com  Foto 
	oPrint:Box( 380,60,900, 460 )
	IF !Empty( cBmpPict := Upper( AllTrim( SRA->RA_BITMAP ) ) )
		IF !File( cPathPict)
			lFile:=oBmp:Extract(cBmpPict  ,cPathPict,.F.)
			If lFile 
				oPrint:SayBitmap(400,75,cPathPict,370,480)
			Endif	
		Else
			oPrint:SayBitmap(400,75,cPathPict,370,480)
		EndIF
	EndIF
	aAdd(aFotos,cPathPict)
ACTIVATE MSDIALOG oDlg8 ON INIT (oBmp:lStretch := .T., oDlg8:End())

dbselectarea(cSAlias)
dbsetorder(nSOrdem)
dbgoto(nSRecno)

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTranBox  ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box -Transferencias                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTranBox(nLinhas)
Local ncol 	:= int( ( nColBox - ( Len(STR0041) * 100 / 7) )) /2 

oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  ) 	// linha vertical ( box )
oPrint:Line(nLin + 050 , 050,nLin + 050 ,nColBox +10)
oPrint:Line(nLin + 150 , 050,nLin + 150 ,nColBox +10)
oPrint:Line(nLin + 50  , 250,nLinhas , 250)			// linha vertical
oPrint:Line(nLin + 50  , 1790,nLinhas ,1790)		// linha vertical
oPrint:say(nLin, nCol,STR0041,oFont10n )   			//-- Transferencias 
nLin += 50

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSalBox   ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box-Alteracao Salarial                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSalBox(nLinhas)

Local nCol  := int( ( nColBox - ( Len(STR0015) * 100 / 7) )) /2
Local nColFim := 	If( SR7->( Type("R7_DESCCAR") ) # "U",130,50)

	oPrint:box(nLin, nColuna ,nlinhas, nColBox + nColFim ) 
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +nColFim)	
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +nColFim)	
	oPrint:Line(nLin + 50  , 240,nLinhas , 240) // Desc aumento
	oPrint:Line(nLin + 50  , 670,nLinhas , 670) //750 Categoria
	oPrint:Line(nLin + 50  , 750,nLinhas , 750) //850 Pagamento
	oPrint:Line(nLin + 50  , 820,nLinhas , 820) //1000 Verba 
	oPrint:Line(nLin + 50  ,1210,nLinhas ,1210) //1400 Valor
	oPrint:Line(nLin + 50  ,1440,nLinhas ,1440)	 //1695 Funcao
	If SR7->( Type("R7_DESCCAR") ) # "U"
		oPrint:Line(nLin + 50  ,1780,nLinhas ,1780)	 //1695 Cargo
	EndIf
	oPrint:say(nLin, nCol,STR0015,oFont10n)
	nLin += 50

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCatBox   ºAutor  ³RH - SSERVICE       º Data ³  27/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Box- Categoria                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCatBox(nLinhas)

Local nCol	:= int( ( nColBox - ( Len("Alteracao Categoria") * 100 / 7) )) /2
	oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  ) 		
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +10)	
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +10)	
	oPrint:Line(nLin + 50  , 250,nLinhas , 250)
	oPrint:say(nLin, nCol,"Alteracao Categoria",oFont10n)
	nLin += 50
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAfastBox ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Box- Afastamentos                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAfastBox(nLinhas)

Local nCol	:= int( ( nColBox - ( Len(STR0018) * 100 / 7) )) /2

	oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  ) 		
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +10)	
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +10)	
	oPrint:Line(nLin + 50  , 250,nLinhas , 250)
	oPrint:Line(nLin + 50  ,1240,nLinhas ,1240)
	oPrint:Line(nLin + 50  ,1540,nLinhas ,1540)
	oPrint:say(nLin, nCol,STR0018,oFont10n)
	nLin += 50
	
Return 
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fFerBox   ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box - Ferias                                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function fFerBox(nLinhas)
Local nCol	:= int( ( nColBox - ( Len(STR0021) * 100 / 7) )) /2

	oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  )
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +10)
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +10)
    oPrint:Line(nLin + 50  , 400,nLinhas , 400)
    oPrint:Line(nLin + 50  , 800,nLinhas , 800)
    oPrint:Line(nLin + 50  ,1150,nLinhas ,1150)
    oPrint:Line(nLin + 50  ,1500,nLinhas ,1500)
    oPrint:Line(nLin + 50  ,1900,nLinhas ,1900)
	oPrint:say(nLin, nCol,STR0021,oFont10n )
	nLin += 50

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAltCadBoxºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box-Alteracao Cadastrais                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAltCadBox(nLinhas)
Local nCol	:= int( ( nColBox - ( Len(STR0024) * 100 / 7) )) /2

	oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10 ) 	
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +10)
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +10)
	oPrint:Line(nLin + 50  , 350,nLinhas , 350)
	oPrint:Line(nLin + 50  , 800,nLinhas , 800)
	oPrint:say(nLin, nCol,STR0024,oFont10n )
	nLin += 50
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fcarLogo  ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box Dependentes                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fDepBox(nLinhas)
Local nCol	:= Int( ( nColBox - ( Len(STR0026) * 100 / 7) )) /2 

	oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  ) 
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +10)	
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +10)	
	oPrint:Line(nLin + 50  , 200,nLinhas , 200) 
	oPrint:Line(nLin + 50  , 890,nLinhas , 890) 
	oPrint:Line(nLin + 50  ,1190,nLinhas ,1190) 
	oPrint:Line(nLin + 50  ,1400,nLinhas ,1400)

	// Mexico nao possui IR Dependentes e Salario Familia
	If cPaisLoc <> "MEX"
		oPrint:Line(nLin + 50  ,1700,nLinhas ,1700)
		oPrint:Line(nLin + 50  ,1900,nLinhas ,1900)	
	EndIf
	oPrint:say(nLin, nCol,STR0026,oFont10n )  
	nLin += 50 

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fBenefBox ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box-Dependentes                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fBenefBox(nLinhas)
Local nCol	:= int( ( nColBox - ( Len(STR0060) * 100 / 7) )) /2

	oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  ) 		
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +10)	
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +10)	
	oPrint:Line(nLin + 50  , 200,nLinhas , 200)
	oPrint:say(nLin, nCol,STR0060,oFont10n )
	nLin += 50

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fContSind ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box-Contribuiceos sindicais                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fContSindBox(nlinhas)
Local nCol	:= int( ( nColBox - ( Len(STR0036) * 100 / 7) )) /2

	oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  ) 		
	oPrint:Line(nLin + 50  , 050,nLin + 50  ,nColBox +10)	
	oPrint:Line(nLin + 100 , 050,nLin + 100 ,nColBox +10)	
	oPrint:Line(nLin + 50  , 300,nLinhas , 300)
	oPrint:Line(nLin + 50  , 690,nLinhas , 690)
	oPrint:Line(nLin + 50  ,1090,nLinhas ,1090)
	oPrint:say(nLin, nCol,STR0036,oFont10n )
	nLin += 50
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAssinatBox ºAutor  ³RH - Natie          º Data ³  12/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box-Assinatura Empregado e responsavel pela Empresa           º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fAssinaBox()
Local nLinhas 	:= 0 
Local nCol		:= int( ( nColBox - ( Len(STR0082) * 100 / 7) )) /2		// Assinaturas 
Local M 		:= 0 
Local aDetalhe 	:= {}

If nGrafica ==1 

	//-- Verifica quebra de pagina 
	If (nLin + 450) > nLinMax 
		nLin  := 0
		oPrint:EndPage() 		// Finaliza a pagina
		ImprG(" ","C",,,nColuna,,nLin,oFont10)
	Endif  
	
		nLinhas 	:= nLin + 450 
	
		nColuna		:= 050 
		
		oPrint:box(nLin, nColuna ,nlinhas, nColBox + 10  )
		oPrint:Line(nLin + 50  , 050 ,nLin + 50  ,nColBox +10)			//-- linha horizontal 
		oPrint:say(nLin        , nCol,STR0082,oFont10n )				//-- Assinaturas 
		oPrint:Line(nLin + 50  , 400 ,nLinhas    , 400)					//-- Vertical apos Polegar 
		oPrint:Line(nLin + 50  ,1300 ,nLinhas    ,1300)					//-- Vertical apos Assin.Func. 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³                                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                
		oPrint:say(nLin+50    , nColuna+10, oemtoAnsi(STR0085),oFont08n )				//-- Polegar Direito 
		oPrint:say(nLIn+50    , 0410      , oEmToAnsi(STR0083),oFont08n)				//-- Assinat.Funciona 
		oPrint:say(nLIn+50    , 1310      , oEmToAnsi(STR0084),oFont08n)				//-- Assinat.Responsavel 
		oPrint:Line(nLin + 370 , 0420 ,nLin +370  ,1300)
		oPrint:Line(nLin + 370 , 1320 ,nLin +370 , 2200)
		//-- Assinatura do Funcionario 
		oPrint:say( nLin+380  , 0410   ,SRA->RA_NOME  ,oFont10n) 
		//-- Responsavel Legal 
		oPrint:say( nLin+380  , 1320   ,cResponsavel  ,oFont10n) 
        oPrint:say(nLin+490,nColuna,OemToAnsi("NOTA: Estes dados refletem a Ficha de Registro do Empregado, devendo substituir as anotacoes em Carteira"),oFont10n)
	    oPrint:say(nLin+540,nColuna,OemToAnsi("de Trabalho, bem como toda e qualquer declaracao a ser eventualmente solicitada a Empresa, conf.disposto"),oFont10n)
        oPrint:say(nLin+590,nColuna,OemToAnsi("na Portaria no. 3626, de 13/11/1991, complementada pela Portaria no. 628 do MTE de 10/08/2000."),oFont10n)
		nLin +=50 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Finaliza impressao Grafica                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                
		ImprG(" " ,"F",0,,0,,nLin)	
		ContFl	:= 1						//-- Inicia nova numeracao da ficha  p/cada funcionario 
		oPrint:EndPage()
Else 
	If li  + 14 >= 60 
		Impr(" ","P")
	Endif
	Impr("","C")
					
	aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
	aAdd(aDetalhe,"|                                                                              |")
	aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
	aAdd(aDetalhe,"|          |                                  |                                |")
	aAdd(aDetalhe,"|----------+----------------------------------+--------------------------------|")
	aAdd(aDetalhe,"|          |                                  |                                |")
	aAdd(aDetalhe,"|          |                                  |                                |")
	aAdd(aDetalhe,"|          |                                  |                                |")	
	aAdd(aDetalhe,"|          |                                  |                                |")	
	aAdd(aDetalhe,"|          | -------------------------------- | ------------------------------ |")
	aAdd(aDetalhe,"|          |                                  |                                |")
	aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
	             //|Polegar   | Assinatura Funcionario             Responsavel Legal              |"  
	             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
	             //         10        20        30        40        50        60        70       
	nDet			:= (78 - Len(STR0082)) / 2 
	aDetalhe[02]	:= stuff(aDetalhe[02],nDet,len(oemtoAnsi(STR0082)) ,oEmtoAnsi(STR0082) )
	aDetalhe[04]	:= Stuff(aDetalhe[04],02,len(oemtoAnsi(STR0085))   ,oemtoAnsi(STR0085) ) 
	aDetalhe[04]	:= Stuff(aDetalhe[04],13,len(oemtoAnsi(STR0083))   ,oemtoAnsi(STR0083) ) 
	aDetalhe[04]	:= Stuff(aDetalhe[04],49,len(oemtoAnsi(STR0084))   ,oemtoAnsi(STR0084) ) 
	aDetalhe[11]	:= Stuff(aDetalhe[11],13,len(SRA->RA_NOME )        ,SRA->RA_NOME  ) 
	aDetalhe[11]	:= Stuff(aDetalhe[11],49,len(cResponsavel)         ,left(cResponsavel,30)   ) 
	
	For m:= 1 to Len(aDetalhe)
		Impr(aDetalhe[m],"C")
	Next m	
		
Endif
		
Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTestaQuebºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua Quebra de Pagina qdo Box de detalhe nao couber      º±±
±±º          ³ na folha atual                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTestaQuebra(aArray, nLinhas) 

If nLin > nLinMax 
	oPrint:EndPage() 		// Finaliza a pagina
	ImprG(" " ,"P",,,nColuna,,0,)
Endif
ImprG(" " ,"C",,,nColuna,,nLin)

nLinhas	:= Int(nLin    + ( (Len(aArray)+1)   * 50 ) ) +50 
nColuna	:= 050 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Se Array nao couber em  uma pagina, efetua a quebra          |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If  nLinhas >= nLinMax
	oPrint:EndPage() 		// Finaliza a pagina
	ImprG(" ","C",,,nColuna,,0,oFont10)
	nLinhas	:= Int(nLin    + (( Len(aArray)+1)   * 50 ) ) + 50
	If nLinhas >= nLinMax
		nLinhas:= nLinMax-50
	Endif
Endif	
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fFimPag   ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Quebra da  pagina quando box de detalhe  for maior que a    º±±
±±º          ³pagina                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fFimPag(aArray,nX,nLinhas)

oPrint:EndPage() 											// Finaliza a pagina

ImprG(" " ,"C", ,,050,,0,) 
nLinhas	:= Int(nLin    + ( (  (Len(aArray)+1) - NX ) * 50 ) ) + 150
If nLinhas >= nLinMax
	nLinhas:= nLinMax-50
Endif 
Return
			
Static Function fDescSexo(cCod)
Return(If(cCod =="F", STR0065, STR0064 ))	//"Feminino"###"Masculino"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER460   ºAutor  ³Microsiga           º Data ³  09/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fImpPeriodo() 

nColuna	:= 050

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Periodo de Impressao                                         ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nGrafica ==1 
	If (nLin + 200) > nLinMax 
		nLin  := 0
		oPrint:EndPage() 		// Finaliza a pagina
		ImprG(" ","C",,,nColuna,,nLin,oFont10)
	Endif 
	ImprG(" ","C",,,nColuna,,nLin,oFont10)
	oPrint:Line(nLin,nColuna ,nLin, nColMax) 
	nLin  += 40 
	
	IF cPaisLoc <> "ANG"
		ImprG(OemToAnsi(STR0081) + DTOc(dDataIni) + " - " + dtoc(dDataFin)  ,"C",,,nColuna,,nLin,oFont10n)
	ENDIF
	
	nLin  += 40 
	oPrint:Line(nLin,nColuna  ,nLin, nColMax) 
	nLin  += 40 
Else
	If Li + 3 >= 60 
		Impr(" ","P")
	Endif

	Impr( repl("-",78),"C",,,01)
	IF cPaisLoc <> "ANG"
		Impr( OemToAnsi(STR0081) + DTOc(dDataIni) + " - " + dtoc(dDataFin),"C",,,01)	
	ENDIF
	Impr( repl("-",78),"C",,,01)
	
Endif	
Return 


/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³AjustaSX		 ³ Autor ³Marcelo Silveira ³ Data ³01/04/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Ajusta o dicionario de dados								 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³NIL                                                 	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³Generico													 ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function AjustaSX()

Local aArea		:= GetArea()
Local aSX1Area  := SX1->( GetArea() )
Local cGrupo	:= "GPR460    "
Local cKey		:= ""
Local aRegs		:= {}

SX1->(DbSetOrder(1))

If cPaisLoc $ "PER/COL/BOL"    
	
	//Exclui pergunta 26
	cKey := cGrupo+"26"
	If SX1->( dbSeek(cKey) )
		FDelSX1(cGrupo,"","26","26",.T.)
	EndIf
	
	//Exclui pergunta 27
	cKey := cGrupo+"27"
	If SX1->( dbSeek(cKey) )
		FDelSX1(cGrupo,"","27","27",.T.)
	EndIf
    
	If cPaisLoc == "BOL"
		//Cria a pergunta 25 - Selecao de Processos
		//		    "X1_GRUPO",	"X1_ORDEM",	"X1_PERGUNT",				"X1_PERSPA",				"X1_PERENG",				"X1_VARIAVL",	"X1_TIPO",	"X1_TAMANHO",	"X1_DECIMAL",	"X1_PRESEL",	"X1_GSC",	"X1_VALID",		"X1_VAR01",	"14 X1_DEF01",	"X1_DEFSPA1",	"X1_DEFENG1",	"X1_CNT01",	"X1_VAR02",	"X1_DEF02",	"X1_DEFSPA2",	"X1_DEFENG2",	"X1_CNT02",	"X1_VAR03",	"X1_DEF03",	"X1_DEFSPA3",	"X1_DEFENG3",	"X1_CNT03",	"X1_VAR04",	"X1_DEF04",	"X1_DEFSPA4",	"X1_DEFENG4",	"X1_CNT04",	"X1_VAR05",	"X1_DEF05",	"X1_DEFSPA5",	"X1_DEFENG5",	"X1_CNT05",	"X1_F3",	X1_GRPSXG 	"X1_PYME",	"AHELPPOR"	"AHELPENG"	"AHELPSPA"	"CHELP"
		Aadd(aRegs,{cGrupo,		"25",		"Selecao de Processos ?",	"¿Seleccion de procesos?",	"Selection of processes?", 	"MV_CHP",		"C",		50,				0,				0,				"G",		"fListProc()",	"MV_PAR25",	"",				"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"S",		{},			{},			{},			".RHPROCES." })
		ValidPerg(aRegs,cGrupo)
	Else
		//Recria a pergunta 25 - Selecao de Processos
		cKey := cGrupo+"25"
		If SX1->( dbSeek(cKey) ) 
			If !AllTrim( SX1->X1_PERGUNT ) == "Selecao de Processos ?"
				FDelSX1(cGrupo,"","25","25",.T.)
				//		    "X1_GRUPO",	"X1_ORDEM",	"X1_PERGUNT",				"X1_PERSPA",				"X1_PERENG",				"X1_VARIAVL",	"X1_TIPO",	"X1_TAMANHO",	"X1_DECIMAL",	"X1_PRESEL",	"X1_GSC",	"X1_VALID",		"X1_VAR01",	"14 X1_DEF01",	"X1_DEFSPA1",	"X1_DEFENG1",	"X1_CNT01",	"X1_VAR02",	"X1_DEF02",	"X1_DEFSPA2",	"X1_DEFENG2",	"X1_CNT02",	"X1_VAR03",	"X1_DEF03",	"X1_DEFSPA3",	"X1_DEFENG3",	"X1_CNT03",	"X1_VAR04",	"X1_DEF04",	"X1_DEFSPA4",	"X1_DEFENG4",	"X1_CNT04",	"X1_VAR05",	"X1_DEF05",	"X1_DEFSPA5",	"X1_DEFENG5",	"X1_CNT05",	"X1_F3",	X1_GRPSXG 	"X1_PYME",	"AHELPPOR"	"AHELPENG"	"AHELPSPA"	"CHELP"
				Aadd(aRegs,{cGrupo,		"25",		"Selecao de Processos ?",	"¿Seleccion de procesos?",	"Selection of processes?", 	"MV_CHP",		"C",		50,				0,				0,				"G",		"fListProc()",	"MV_PAR25",	"",				"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"",				"",				"",			"",			"",			"S",		{},			{},			{},			".RHPROCES." })
				ValidPerg(aRegs,cGrupo)
			EndIf
		EndIf
	Endif
Endif
RestArea(aSX1Area)
RestArea(aArea)

Return (Nil)