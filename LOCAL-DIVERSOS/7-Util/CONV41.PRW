#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FILEIO.CH"                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Converte  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Programa de Conversao de Base                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data     ³              Alteracao                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³03.12.04  ³ Inclusao do DePara - Versao 2.0                            ³±±
±±³19.12.04  ³ Alteracao para tratar arquivo com delimitador Versao 3.0   ³±±
±±³20.04.07  ³ Inclusão Controle de Conversão Reinicia onde parou Ver 3.1 ³±±
±±³02.12.09  ³ Alteracao de telas, le arquivo maior 1024 colunas Ver 4.0  ³±±
±±³12.01.10  ³ Objeto TGET, TSAY e TBUTTON nas telas Ver 4.1              ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Conv41()
//User Function Converte()

//Inicia Variaveis
Local oDlg			:= Nil
Local oBt1			:= Nil
Local oBt2			:= Nil
Local oBt3			:= Nil
Local oBt4			:= Nil

Private lOpen		:= .T.
Private lEnd		:= .F.
Private lContinua	:= .T.
Private lAbortPrint	:= .F.
Private cArq		:= ''
Private cArqTxt		:= ''
Private cYesNo		:= ''
Private cTexto		:= ''
Private cSTexto 	:= ''
Private cDelim1		:= ''
Private cDelim2		:= ''
Private cArqIn1		:= ''
Private cArqIn2		:= ''
Private cArqIn3		:= ''
Private nOpcao		:= 0
Private nOpc		:= 0
Private nMaxCol		:= 1000
Private nSavePos	:= 0
Private nHdl		:= 0
Private aCols		:= {}
Private aHeader 	:= {}	
Private aCampo		:= {}
Private aRotina 	:= {}
Private aDados		:= {}

//Abre Arquivos
AbreArq()

//Montagem da tela  (Alterado pelo Anderson Shibao)
oDlg := tDialog():New(0,0,150,300,"Conversao de Tabelas Ver. 4.1",,,,,,,,,.T.)

oBt1 := tButton():New(15,30,"&Conversao"	,oDlg,{|| ContProc()},40,16,,advfont,,.T.)
oBt2 := tButton():New(40,30,"&De/Para"	  	,oDlg,{|| ConvDe()  },40,16,,advfont,,.T.)
oBt3 := tButton():New(15,80,"Co&nfigura"	,oDlg,{|| ConvConf()},40,16,,advfont,,.T.)
oBt4 := tButton():New(40,80,"&Sair"			,oDlg,{|| oDlg:End()},40,16,,advfont,,.T.)

oDlg:Activate(,,,.T.,,, )

//Fecha Arquivos e Deleta Indices
If Select('CONV') > 0     
	dbSelectArea('CONV')
	dbCloseArea('CONV')
	
	If File(cArqIn1 + OrdBagExt())     	
		Ferase (cArqIn1+OrdBagExt())
	Endif
Endif

If Select('DEPA') > 0		
	dbSelectArea('DEPA')
	dbCloseArea('DEPA')
	
	If File(cArqIn2 + OrdBagExt())     	
		Ferase (cArqIn2+OrdBagExt())
	Endif
Endif

If Select('CCNV') > 0
	dbSelectArea('CCNV')
	dbCloseArea('CCNV')
	
	If File(cArqIn3 + OrdBagExt())     
		Ferase (cArqIn3+OrdBagExt())	
	Endif
Endif

Return 

//Fim da Rotina 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ AbreArq  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AbreArq()

If lOpen

	//Verificar se Existe Arquivo
	If !File("\CONVERTE.DTC")
		CriaTabe("A")
	Endif
	
	//Abertura de arquivo Configuracao
	dbUseArea(.T.,,"\CONVERTE","CONV")

	//Cria Indice Temporario
	//Nome do Indice
	cArqIn1 := CriaTrab(Nil,.F.)

	//Chave do Indice
	cInd := "CNV_ARQ + CNV_CAMPO"

	//Criacao do Indice
	IndRegua("CONV",cArqIn1,cInd,,,"Selecionando Registros")	

	//Verificar se Existe Arquivo
	If !File("\DEPARA.DTC")
		CriaTabe("B")
	Endif

	//Abertura de arquivo DePara
	dbUseArea(.T.,,"\DEPARA","DEPA")

	//Cria Indice Temporario
	//Nome do Indice
	cArqIn2 := CriaTrab(Nil,.F.)

	//Chave do Indice
	cInd := "DE_GRP + DE_DE"

	//Criacao do Indice
	IndRegua("DEPA",cArqIn2,cInd,,,"Selecionando Registros")
	
	//Verificar se Existe Arquivo
	If !File("\CTRCNV.DTC")
		CriaTabe("C")
	Endif

	//Abertura de arquivo de Controle 
	dbUseArea(.T.,,"\CTRCNV","CCNV")

	//Cria Indice Temporario
	//Nome do Indice
	cArqIn3 := CriaTrab(Nil,.F.)

	//Chave do Indice
	cInd := "CTR_TABE"

	//Criacao do Indice
	IndRegua("CCNV",cArqIn3,cInd,,,"Selecionando Registros")	
	
	lOpen := .F.

Endif	

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ ContProc ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ContProc()

//Inicia variaveis
Local cInd	 	:= ''
Local cArqInd  	:= ''
Local oDlg1     := Nil
Local oGet1		:= Nil
Local oGet2		:= Nil
Local oGet3		:= Nil
Local oSay		:= Nil

cArq			:= Space(3)
cArqTxt 		:= Space(24)
cYesNo			:= 'N'

//Montagem de Tela
oDlg1 := tDialog():New(0,0,190,250,"Conversao de Tabelas",,,,,,,,,.T.)
oSay:= TSay():New(15,12,{||"Nome do Arquivo Fonte"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 13,74 MSGET oGet1 VAR cArqTxt PIXEL FONT AdvFont SIZE 050,09 OF oDlg1 PICTURE "@!" VALID fGetPath(cArqTxt) NO BORDER COLOR CLR_WHITE,CLR_BLACK
oSay:= TSay():New(28,12,{||"Nome da Tabela Destino"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 26,74 MSGET oGet2 VAR cArq PIXEL FONT AdvFont SIZE 002,09 OF oDlg1 PICTURE "@!" VALID ! Empty(cArq) WHEN ! Empty(cArqTxt) NO BORDER COLOR CLR_WHITE,CLR_BLACK
oSay:= TSay():New(41,12,{||"Arquivo Delimitado ?"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 41,74 MSGET oGet3 VAR cYesNo PIXEL FONT AdvFont SIZE 001,09 OF oDlg1 PICTURE "@!" VALID fVerDelim() WHEN ! Empty(cArq) NO BORDER COLOR CLR_WHITE,CLR_BLACK

SButton():New( 60,18,01,{||OkDelim(),oDlg1:End()},oDlg1,.T.,,)
SButton():New( 60,65,02,{||oDlg1:End()},oDlg1,.T.,,)

oDlg1:Activate(,,,.T.,,, )

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ ConvConf ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Configuracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ConvConf()

Local oDlg1			:= Nil
Local oSay			:= Nil
Local oGet1			:= Nil
Local oGet2			:= Nil

//Inicia Variaveis
cArq			:= Space(3)
cYesNo 			:= "N"

//Montagem de Tela
oDlg1 := tDialog():New(0,0,150,250,"Configuracao da Conversao",,,,,,,,,.T.)

oSay:= TSay():New(15,12,{||"Nome da Tabela"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 13,74 MSGET oGet1 VAR cArq PIXEL FONT AdvFont SIZE 003,09 OF oDlg1 PICTURE "@!" VALID ! Empty(cArq) NO BORDER COLOR CLR_WHITE,CLR_BLACK
oSay:= TSay():New(28,12,{||"Arquivo Delimitado"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 26,74 MSGET oGet2 VAR cYesNo PIXEL FONT AdvFont SIZE 001,09 OF oDlg1 PICTURE "@!" VALID cYesNo $ "SN" NO BORDER COLOR CLR_WHITE,CLR_BLACK

SButton():New( 58,18,01,{||OkConv(),oDlg1:End()},oDlg1,.T.,,)
SButton():New( 58,65,02,{||oDlg1:End()},oDlg1,.T.,,)

oDlg1:Activate(,,,.T.,,, )

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³fVerDelim ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 19.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Verificacao do Delimitador                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVerDelim()

Local oDlg1			:= Nil
Local oSay			:= Nil
Local oGet1			:= Nil
Local oGet2			:= Nil


cDelim1	:= ' '
cDelim2	:= ' '

If !cYesNo $ "SN"
	Return(.F.)
Endif 

If cYesNo == "S"

	//Montagem de Tela
	oDlg1 := tDialog():New(0,0,150,250,"Delimitador de Arquivo",,,,,,,,,.T.)

	oSay:= TSay():New(15,12,{||"Delimitador de Campo"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	@ 13,74 MSGET oGet1 VAR cDelim1 PIXEL FONT AdvFont SIZE 001,09 OF oDlg1 PICTURE "@!" VALID ! Empty(cDelim1) NO BORDER COLOR CLR_WHITE,CLR_BLACK
	oSay:= TSay():New(28,12,{||"Delimitador de Dados"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	@ 26,74 MSGET oGet2 VAR cDelim2 PIXEL FONT AdvFont SIZE 001,09 OF oDlg1 PICTURE "@!" NO BORDER COLOR CLR_WHITE,CLR_BLACK
	
	SButton():New( 58,18,01,{||oDlg1:End()},oDlg1,.T.,,)
	
	oDlg1:Activate(,,,.T.,,, )

Endif		

Return(.T.)

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³  ConvDe  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Configuracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ConvDe()

Local cGrp	:= Space(4)
Local oDlg1	:= Nil
Local oSay	:= Nil
Local oGet1	:= Nil

//Montagem de Tela
oDlg1 := tDialog():New(0,0,150,250,"Configuracao do Depara",,,,,,,,,.T.)

oSay:= TSay():New(28,12,{||"Nome do Grupo"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 26,74 MSGET oGet1 VAR cGrp PIXEL FONT AdvFont SIZE 003,09 OF oDlg1 PICTURE "@!" VALID ! Empty(cGrp) NO BORDER COLOR CLR_WHITE,CLR_BLACK
	
SButton():New( 58,18,01,{||OkDe(cGrp),oDlg1:End()},oDlg1,.T.,,)
SButton():New( 58,65,02,{||oDlg1:End()},oDlg1,.T.,,)

oDlg1:Activate(,,,.T.,,, )
	
Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³   OKDe   ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Configuracao do DEPARA           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OKDe(cGrp)
		
//Inicia Variaveis
Local cCadastro := ''
Local nI 		:= 0
Local oDlg1		:= Nil
Local oSay		:= Nil
Local oGet		:= Nil
Local oGet1		:= Nil

nOpc	 := 3
aHeader	 := {}
aCols	 := {}
aRotina	 := {{	"", ""	, 0 , 1},;
			{	"", ""	, 0 , 2},;
			{	"", ""	, 0 , 3},;
			{	"", ""	, 0 , 4},;
			{	"", ""	, 0 , 5}  }

aAdd(aHeader,{ "De","DE_DE","@!",10,0,,,"C","DEPA",} )             
aAdd(aHeader,{ "Para","DE_PARA","@!",10,0,,,"C","DEPA",} )
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
DEPA->(dbSeek(cGrp))
	
While DEPA->(!Eof()) .And. (DEPA->DE_GRP == cGrp)

	nI += 1 
	aAdd(aCols,{})
	aAdd(aCOLS[nI],DEPA->DE_DE)
	aAdd(aCOLS[nI],DEPA->DE_PARA)
	aAdd(aCOLS[nI], .F.)
		
	DEPA->(dbSkip())
		
End

oDlg1 := tDialog():New(44,5,310,645,cCadastro,,,,,,,,,.T.)

// Monta Cabecalho
oSay:= TSay():New(12,15,{||"Nome do Grupo"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 23,12 MSGET oGet1 VAR cGrp PIXEL FONT AdvFont SIZE 003,09 OF oDlg1 WHEN .F. NO BORDER COLOR CLR_WHITE,CLR_BLACK

oGet := MSGetDados():New(44,5,128,315,nOpc,"u_fLOK()","u_fTOK()","",.T.,,,,1000)
ACTIVATE DIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{||nOpcao:=1,If(u_fTOK(),oDlg1:End(),nOpcao:=0)},{||oDlg1:End()})
  
If nOpcao == 1
    //Grava Registro
	fGravaDe(cGrp)
Endif

Return
//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³  OKDelim ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 19.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Verificacao do Delimitador                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OKDelim()

If cYesNo =="S"
	OkProcDelim()
Else
	OkProc()
Endif

Return

//Fim da Rotina		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³  OKConv  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Configuracao da Conversao        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OKConv()
		
//Inicia Variaveis
Local cCadastro	:= ''
Local nI 	:= 0
Local nJ 	:= 0
Local oDlg1	:= Nil
Local oSay	:= Nil
Local oGet	:= Nil
Local oGet1	:= Nil

nOpc	 := 3
aCols	 := {}
aHeader	 := {} 
aRotina	 :=	{{	"", ""	, 0 , 1},;
			 {	"", ""	, 0 , 2},;
			 {	"", ""	, 0 , 3},;
			 {	"", ""	, 0 , 4},;
			 {	"", ""	, 0 , 5}  }

CONV->(dbSeek(cArq))

//Se Nao Localizado, Carrega Tabela do SX3
If !CONV->(Found())
    
	//Pesquisa SX3
	If SX3->(dbSeek(cArq))

		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cArq 
			If	SX3->X3_CONTEXT != "V"
				aAdd(aCampo,{SX3->X3_ARQUIVO,SX3->X3_CAMPO,SX3->X3_TITULO,SX3->X3_TIPO})
			Endif
			
			SX3->(dbSkip())
				
		EndDo
		
		For nI:=1 to Len(aCampo)
		
			If RecLock("CONV",.T.)
		
				For nJ:=1 to 4
					CONV->(FieldPut(nJ,aCampo[nI,nJ]))
				Next nJ
		
				MsUnlock("CONV")
				
			Endif	
		
		Next nI         
	
	Else

		//Se Nao Localizou Tabela no SX3
		Help("",1,"","HELP","Tabela Nao Localizada no SX3",1,0)
		Return
		
	Endif
		
Endif 

If cYesNo == "S"

	aAdd(aHeader,{ "Campo","CNV_CAMPO","@!",10,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Nome","CNV_NOME","@!",12,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Tipo","CNV_TIPO","@!",1,0,,,"C","CONV",} ) 
	aAdd(aHeader,{ "Ordem","CNV_ORDEM","999",3,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Formula","CNV_FORM","@!",300,0,,,"C","CONV",} )
	
Else

	aAdd(aHeader,{ "Campo","CNV_CAMPO","@!",10,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Nome","CNV_NOME","@!",12,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Tipo","CNV_TIPO","@!",1,0,,,"C","CONV",} )
	aAdd(aHeader,{ "De","CNV_DE","9999",4,0,,,"N","CONV",} )
	aAdd(aHeader,{ "Ate","CNV_ATE","9999",4,0,,,"N","CONV",} )
	aAdd(aHeader,{ "Tamanho","CNV_TAM","9999",4,0,,,"N","CONV",} )
	aAdd(aHeader,{ "Formula","CNV_FORM","@!",300,0,,,"C","CONV",} )
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
CONV->(dbSeek(cArq))
nI := 0
	
While CONV->(!Eof()) .And. (CONV->CNV_ARQ == cArq)

	nI += 1 
	aAdd(aCols,{})

	If cYesNo == "S"

		aAdd(aCOLS[nI],CONV->CNV_CAMPO)
		aAdd(aCOLS[nI],CONV->CNV_NOME)	
		aAdd(aCOLS[nI],CONV->CNV_TIPO)
		aAdd(aCOLS[nI],CONV->CNV_ORDEM)
		aAdd(aCOLS[nI],CONV->CNV_FORM)
		aAdd(aCOLS[nI], .F.)

	Else
		
		aAdd(aCOLS[nI],CONV->CNV_CAMPO)
		aAdd(aCOLS[nI],CONV->CNV_NOME)	
		aAdd(aCOLS[nI],CONV->CNV_TIPO)
		aAdd(aCOLS[nI],CONV->CNV_DE)
		aAdd(aCOLS[nI],CONV->CNV_ATE)
		aAdd(aCOLS[nI],CONV->CNV_TAM)
		aAdd(aCOLS[nI],CONV->CNV_FORM)
		aAdd(aCOLS[nI], .F.)
		
	Endif
		
	CONV->(dbSkip())
		
End

oDlg1 := tDialog():New(44,5,310,645,cCadastro,,,,,,,,,.T.)

// Monta Cabecalho
oSay:= TSay():New(12,15,{||"Nome da Tabela"},oDlg1,,advfont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
@ 23,12 MSGET oGet1 VAR cArq PIXEL FONT AdvFont SIZE 003,09 OF oDlg1 WHEN .F. NO BORDER COLOR CLR_WHITE,CLR_BLACK

oGet := MSGetDados():New(44,5,128,315,nOpc,"u_fLOK()","u_fTOK","",.T.,,,,1000)
ACTIVATE DIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{||nOpcao:=1,If(u_fTOK(),oDlg1:End(),nOpcao:=0)},{||oDlg1:End()})
   
If nOpcao == 1
    //Grava Registro
	fGravaCon()
Endif

Return
//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³  OKProc  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Conversao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OKProc()

//Inicia Variaveis
Local lRead	:= .T.
Local oProc	:= Nil

lEnd		:= .F.
	
//Abertura de Arquivo Texto
nHdl	:= fOpen(cArqTxt)

//Erro de Abertura
If nHdl == -1
	MsgStop("Erro Na Abertura do Arquivo " + cArqTxt)
	lRead := .F.
	Return
Endif

//Verifica se Ultima conversão foi completa
If CCNV->(dbSeek(cArq),Found())
    
	//Posiciona onde Parou
	If (nAvs := Aviso('AVISO','Ultima Conversao Nao Concluida. Continua de Onde Parou?', {'Sim','N„o'})) == 1
		FSeek(nHdl,CCNV->CTR_REC,FS_SET)
	EndIf
			
Else 
	
	//Acrescenta Registro
	If RecLock('CCNV',.T.)
		CCNV->CTR_TABE := cArq
	Endif	  				
	
	MsUnlock()
	
Endif	
	
//Processamento da Conversáo 
oProc := MsNewProcess():New({|lEnd| ConvProc(oProc,lRead)},"Lendo","Processando...",.T.)

oProc:Activate()

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄ-ÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³OKProcDelim³ Autor ³ Jose Carlos Gouveia  ³ Data ³ 19.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄ-ÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Conversao com Delimitador        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OKProcDelim()

//Inicia Variaveis
Local lRead	:= .T.
Local oProc	:= Nil
	  
lEnd		:= .F.
//Abertura de Arquivo Texto
nHdl	:= fOpen(cArqTxt)

//Erro de Abertura
If nHdl == -1
	MsgStop("Erro Na Abertura do Arquivo " + cArqTxt)
	Return
Endif

//Verifica se Ultima conversão foi completa
If CCNV->(dbSeek(cArq),Found())
    
	//Posiciona onde Parou
	If (nAvs := Aviso('AVISO','Ultima Conversao Nao Concluida. Continua de Onde Parou?', {'Sim','N„o'})) == 1
		FSeek(nHdl,CCNV->CTR_REC,FS_SET)
	EndIf
			
Else 
	
	//Acrescenta Registro
	If RecLock('CCNV',.T.)
		CCNV->CTR_TABE := cArq
	Endif	  				
	
	MsUnlock()
	
Endif	

//Processamento da Conversáo 
oProc := MsNewProcess():New({|lEnd| DelimProc(oProc,lRead)},"Lendo","Processando...",.T.)

oProc:Activate()

Return
//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ ConvProc ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Conversao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ConvProc(oObj,lRead)

Local aCampo
Local nX
Local cForm
Local cTipo
Local cCampo
Local nDe
Local nTam
Local nAte

lContinua 	:= .T.
aCampo		:= {}
nX			:= 0
nDe			:= 0
nAte		:= 0
nTam		:= 0
cCampo		:= ''
cForm		:= ''
cTipo		:= ''

//Set Regua 1 
oObj:SetRegua1(0)

//Carrega Array com Dados da Conversão
CONV->(dbGotop())

If CONV->(dbSeek(cArq),!Found())
	MsgBox (cArq + " Nao Localizado. Selecionar Configuracao","Erro","STOP")
	Return
Else
	While CONV->CNV_ARQ == cArq
		If CONV->CNV_DE != 0 .Or. !Empty(CONV->CNV_FORM)
			aAdd(aCampo,{CONV->CNV_CAMPO,CONV->CNV_TIPO,CONV->CNV_DE,CONV->CNV_ATE,CONV->CNV_TAM,CONV->CNV_FORM})
		Endif
		CONV->(dbSkip())
	Enddo
Endif

While lContinua .And. lRead

	//Inicia Variavel
	cSTexto	:= ''
	cTexto	:= ''

	//Set Regua 2
	oObj:SetRegua2(len(aCampo))

	//Le Linha do Arquivo Texto	
	lRead := FREADLIN(nHdl,@cSTexto)

	If RecLock(cArq,.T.)		
        
		For nX := 1 to Len(aCampo)
	    	
			If lAbortPrint .Or. lEnd
				If Aviso('ATEN€AO','Deseja abandonar a Conversao arquivo ' + AllTrim(cArq) + ' ?',{'Sim','N„o'}) == 1
					lContinua := .F.
					Exit
				EndIf	
			Endif
            
			cCampo := cArq + "->" + AllTrim(aCampo[nX,1])
			cTipo  := aCampo[nX,2]
			nDe	   := aCampo[nX,3]
			nAte   := aCampo[nX,4]
			nTam   := aCampo[nX,5]
			cForm  := AllTrim(aCampo[nX,6])
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa a regua 2                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oObj:IncRegua2("Processando Campo : " + cCampo)
	
	   		//Se Converte Campo
			If nDe > 0
			
				If nTam = 0
					nTam := (nAte - nDe + 1)
				Endif

				//Gravando Registro	 
	    		If cTipo == "C"
   					If !Empty(cForm)
   						cTexto  := Subst(cSTexto,nDe,nTam)
   						cForm	:= AllTrim(aCampo[nX,6])
						&cCampo := &cForm
					Else	    						
	    				&cCampo := Subst(cSTexto,nDe,nTam)
	    			Endif	
			    ElseIf cTipo == "D"
   					If !Empty(cForm)
   						cTexto  := Subst(cSTexto,nDe,nTam)
						&cCampo := cTod(&cForm)
					Else	    						
	    				&cCampo := cTod(Subst(cSTexto,nDe,nTam))
	    			Endif	
			    ElseIf cTipo == "N"	
   					If !Empty(cForm)
   						cTexto  := Subst(cSTexto,nDe,nTam)
						&cCampo := Val(&cForm)
					Else	    						
	    				&cCampo := Val(Subst(cSTexto,nDe,nTam))
	    			Endif	
			    Endif	         
	        
	    	//Se Somente o Campo Formula esta Preenchido
			ElseIf !Empty(cForm)
				
				If cTipo == "C"
    				If RecLock(cArq,.F.)
						&cCampo := &cForm
		    		Endif	
			    ElseIf cTipo == "D"
    				If RecLock(cArq,.F.)
						&cCampo := cTod(&cForm)
		    		Endif	
			    ElseIf cTipo == "N"	
    				If RecLock(cArq,.F.)
						&cCampo := Val(&cForm)
		    		Endif	  				
			    Endif	         			
			
			Endif
		Next
		
		MsUnlock(cArq)
	
	Endif	
	
	//Grava Controle de Conversão 
	If RecLock('CCNV',.F.)
		CCNV->CTR_REC	:= nSavePos
	Endif	  				

	MsUnlock()	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua 1                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oObj:IncRegua1("Processando " + cArqTxt)
		
Enddo

//Fechamento do Arquivo Texto
fClose(nHdl)

//Deleta Controle de Conversão 
If RecLock('CCNV',.F.)
	CCNV->(dbDelete())
Endif	  				

MsUnlock()	

Return
//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³DelimProc ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 26.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento da Conversao com Delimitador        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DelimProc(oObj,lRead)

Local aCampo
Local nOrdem
Local nX
Local cCampo
Local cTipo
Local cForm

lContinua 	:= .T.
aCampo		:= {}
aDados 		:= {}
nOrdem		:= 0
nX			:= 0
cCampo		:= ''
cTipo		:= ''
cForm		:= ''

//Set Regua 1 
oObj:SetRegua1(0)

//Localizar Ordem
CONV->(dbGotop())
If CONV->(dbSeek(cArq),!Found())
	MsgBox (cArq + " Nao Localizado. Selecionar Configuracao","Erro","STOP")
	Return              
Else 
	While CONV->CNV_ARQ == cArq			
		If Val(CONV->CNV_ORDEM) != 0 .Or. !Empty(CONV->CNV_FORM)
			aAdd(aCampo,{CONV->CNV_CAMPO,CONV->CNV_TIPO,CONV->CNV_ORDEM,CONV->CNV_FORM})
		Endif           
		
		CONV->(dbSkip())				

    Enddo
Endif


While lContinua .And. lRead	
	
	//Inicia Variavel
	cSTexto	:= ''
	cTexto  := ''
	
	//Set Regua 2
	oObj:SetRegua2(Len(aCampo))
   
	//Le Linha do Arquivo Texto	
	lRead := FREADLIN(nHdl,@cSTexto)
	
	//Se Nao Localiza delimitador
	If At(cDelim1,cSTexto) == 0
		lContinua := .F.
		Loop
	Endif 
	
	aDados := fSepara(cStexto)	

	If RecLock(cArq,.T.)		

		For nX := 1 to Len(aCampo)
			    	
			If lAbortPrint .Or. lEnd
				If Aviso('ATEN€AO','Deseja abandonar a Conversao arquivo ' + AllTrim(cArq) + ' ?',{'Sim','N„o'}) == 1
					lContinua := .F.
					Exit
				EndIf	
			Endif

			//Carrega Variaveis			
			cCampo := cArq + "->" + aCampo[nX,1]
			cTipo  := aCampo[nX,2]
			nOrdem := Val(aCampo[nX,3])
			cForm  := aCampo[nX,4]
	        
			//Verifica se Ordem maior que Array		
			If nOrdem > Len(aDados)
				Loop
			Endif	

			//Carrega Texto
			If nOrdem > 0
				cTexto := aDados[nOrdem]
			Else
				cTexto := ''
			Endif
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa a regua 2                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oObj:IncRegua2("Processando Campo : " + cCampo)
		   
			//Gravando Registro				
			If cTipo == "C"
				If !Empty(cForm)
					&cCampo := &cForm
				Else	    						
    				&cCampo := cTexto
    			Endif	
		    ElseIf cTipo == "D"
				If !Empty(cForm)
					&cCampo := cTod(&cForm)
				Else	    						
    				&cCampo := cTod(cTexto)
    			Endif	
		    ElseIf cTipo == "N"	
				If !Empty(cForm)
		   			&cCampo := Val(&cForm)
				Else	    						
	    			&cCampo := Val(cTexto)
	    		Endif	
		    Endif	          
					   
		Next
		
		MsUnlock(cArq)

		//Reinicia aDados
		aDados := {}
	
	Endif
		
	//Grava Controle de Conversão 
	If RecLock('CCNV',.F.)
		CCNV->CTR_REC	:= nSavePos
	Endif	  				

	MsUnlock()	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua 1                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oObj:IncRegua1("Processando " + cArqTxt)
		
Enddo

//Fechamento do Arquivo Texto
fClose(nHdl)

//Deleta Controle de Conversão 
If RecLock('CCNV',.F.)
	CCNV->(dbDelete())
Endif	  				

MsUnlock()	

Return
//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  fLOk    ºAutor  ³Jose Carlos Gouveia º Data ³  08/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao das Linhas do aCols.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVERTE													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
User Function fLOK()

Local lRet := .T.
Local nLin := n
Local nI   := Len(aCols)
                     
If Empty(aCols[nLin,1]) .And. !aCols[nLin,(Len(aCols[nLin]))]
	MsgStop("Coluna Campo em Branco !!!")
	lRet := .F.
Else
	If Empty(aCols[nLin,2]) .And. !aCols[nLin,(Len(aCols[nLin]))]
		MsgStop("Coluna Tipo em Branco !!!")
		lRet := .F.
	Endif	
Endif

//Acrescenta Zero no Campo Ordem
If cYesNo == "S"
	If Val(aCols[nLin,4]) > 0 .And. lRet
		aCols[nLin,4] := Right('00' + AllTrim(aCols[nLin,4]),3)
	Endif		
Endif

Return(lRet)	
//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  fTOk    ºAutor  ³Jose Carlos Gouveia º Data ³  08/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do MsGetDados                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVERTE													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
User Function fTOk()

lRet  := u_fLOK()

Return(lRet)
//Fim da Rotina
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ CriaTabe ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaTabe(cFlag)
                          
//Verificar se Existe Arquivo
If cFlag == "A"

	aCampo := {}
	
	//Criacao do Array 
	aAdd(aCampo,{ "CNV_ARQ"  ,"C",  3,0} )
	aAdd(aCampo,{ "CNV_CAMPO","C", 10,0} )
	aAdd(aCampo,{ "CNV_NOME ","C", 12,0} )
	aAdd(aCampo,{ "CNV_TIPO" ,"C",  1,0} )
	aAdd(aCampo,{ "CNV_ORDEM","C", 3,0} )              		
	aAdd(aCampo,{ "CNV_DE"   ,"N",  4,0} )
	aAdd(aCampo,{ "CNV_ATE"  ,"N",  4,0} )
	aAdd(aCampo,{ "CNV_TAM"  ,"N",  4,0} )
	aAdd(aCampo,{ "CNV_FORM" ,"C",300,0} )

	//Criacao do Arquivo
	dBCreate("\CONVERTE",aCampo)

ElseIf cFlag == "B"

	aCampo := {}
	
	//Criacao do Array 
	aAdd(aCampo,{ "DE_GRP" ,"C", 4,0} )
	aAdd(aCampo,{ "DE_DE"  ,"C", 10,0} )              
	aAdd(aCampo,{ "DE_PARA","C", 10,0} )

	//Criacao do Arquivo
	dBCreate("\DEPARA",aCampo)

Else

	aCampo := {}
	
	//Criacao do Array 
	aAdd(aCampo,{ "CTR_TABE" ,"C", 3,0} )
	aAdd(aCampo,{ "CTR_REC"  ,"N", 12,0} )              


	//Criacao do Arquivo
	dBCreate("\CTRCNV",aCampo)
Endif

Return

//Fim da Rotina 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FGETPATH ³ Autor ³ Kleber Dias Gomes     ³ Data ³ 26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Permite que o usuario decida onde sera criado o arquivo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CONVERTE													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGetPath(cPath)

Local cRet	:= Alltrim(ReadVar())

If ! Empty(cPath)
	Return .T.
EndIf

oWnd := GetWndDefault()

cPath := cGetFile( "Arquivos Texto de Importacao | *.TXT ",OemToAnsi("Selecione Arquivo"))

If Empty(cPath)
	Return(.F.)
Else	
	&cRet := cPath
Endif

If oWnd != Nil
	GetdRefresh()
EndIf

cArqTxt	:= cPath

Return .T.

//Fim da Rotina 
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fGravaCon ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 10/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Registro do Acols                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CONVERTE													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGravaCon()

Local nI, nJ, nT, aCampo

aCampo := {}

If cYesNo == "S"

	aAdd(aCampo,"CNV_CAMPO")
	aAdd(aCampo,"CNV_NOME")
	aAdd(aCampo,"CNV_TIPO") 
	aAdd(aCampo,"CNV_ORDEM")
	aAdd(aCampo,"CNV_FORM")

	nT := Len(aCampo) + 1
		
Else

	aAdd(aCampo,"CNV_CAMPO")
	aAdd(aCampo,"CNV_NOME")
	aAdd(aCampo,"CNV_TIPO")
	aAdd(aCampo,"CNV_DE")
	aAdd(aCampo,"CNV_ATE")
	aAdd(aCampo,"CNV_TAM")
	aAdd(aCampo,"CNV_FORM")

	nT := Len(aCampo) + 1
			
Endif

For nI := 1 to Len(aCols)

	CONV->(dbSeek(cArq + aCols[nI,1]))
	
	If CONV->(! Eof()) //Gravacao em Registro Existente
		
		If aCols[nI,nT] //Elemento Deletado
		
			If RecLock("CONV",.F.)
				CONV->(dbDelete())
			Endif
			
		Else
		
			If RecLock("CONV",.F.) .And. !aCols[nI,nT]
				//Grava Registro
				For nJ := 2 to Len(aCampo)
					CONV->(FieldPut(FieldPos(aCampo[nJ]),aCols[nI,nJ]))
				Next nJ
				
			Endif
			
		Endif

	Else //Incluindo no Registro

		If RecLock("CONV",.T.) .And. !aCols[nI,nT]
			
			//Grava Registro
			CONV->(FieldPut(FieldPos(aCampo[1]),cArq))
		
			For nJ := 2 to Len(aCampo)
				CONV->(FieldPut(FieldPos(aCampo[nJ]),aCols[nI,nJ]))
			Next nJ
				
		Endif
	
	Endif

Next nI

Return

//Fim da Rotina

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fGravaDe ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 10/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Registro do Acols De Para                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CONVERTE													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGravaDe(cGrp)

Local nI, nJ

For nI := 1 to Len(aCols)

	DEPA->(dbSeek(cGrp + aCols[nI,1]))
	
	If DEPA->(!Eof()) //Gravacao em Registro Existente
		
		If aCols[nI,3] //Elemento Deletado
		
			If RecLock("DEPA",.F.)
				DEPA->(dbDelete())
			Endif
			
		Else
		
			If RecLock("DEPA",.F.)
				//Grava Registro
				For nJ := 1 to 2
					DEPA->(FieldPut(nJ + 1,aCols[nI,nJ]))
				Next nJ
				
			Endif
			
		Endif

	Else //Incluindo no Registro

		If RecLock("DEPA",.T.) .And. !aCols[nI,3]
			//Grava Registro
			DEPA->(FieldPut(1,cGrp))
			For nJ := 1 to 2
				DEPA->(FieldPut(nJ + 1,aCols[nI,nJ]))
			Next nJ
				
		Endif
	
	Endif

Next nI

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ fDePara  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 03.12.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de processamento do DePara                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fDePara(cGrp,cDpr)
    
Local cDePara := ''

If Empty(cGrp)
	Return(cDePara)
Endif

//Acrescenta Espaco a Direita
If Len(cGrp) < 4
   cGrp :=	Left((cGrp + Space(4)),4)
Endif	     

If DEPA->(dbSeek(cGrp + cDpr))
	cDePara := DEPA->DE_PARA
Else
	cDePara := ''
Endif		
	
Return(cDePara)

//Fim da Rotina

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FSepara  ³ Autor ³ Jose Carlos Gouveia   ³ Data ³ 04/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Separa Dados delimitados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CONVERTE													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSepara(cTxt)

Local aData   := {}
Local cTxtAux := ""

//Se Delimitador de Dados Nao Existe 
If Empty(cDelim2)

	While At(cDelim1,cTxt) > 0
		
		aAdd(aData,Subst(cTxt,1,At(cDelim1,cTxt) - 1))
		
		cTxt := Subst(cTxt,At(cDelim1,cTxt) + 1)
		
		If At(cDelim1,cTxt) = 0
			aAdd(aData,cTxt)
		Endif
		
	Enddo
	
Else //Delimitador de Dados Existe
                                  
	While At(cDelim1,cTxt) > 0

		//Primeiro Campo Não é Delimitador de Dados
		If At(cDelim2,cTxt) != 1
		        
			aAdd(aData,Subst(cTxt,1,At(cDelim1,cTxt) - 1))
		
			cTxt := Subst(cTxt,At(cDelim1,cTxt) + 1)		
		Else
			     
			cTxtAux := Subst(cTxt,At(cDelim2,cTxt) + 1)
			cTxtAux := Subst(cTxtAux,1,At(cDelim2,cTxtAux) - 1)
			 
			aAdd(aData,cTxtAux)

			cTxt := Subst(cTxt,At(cDelim1,cTxt) + 1)
			
		Endif
		
		//Fim dos Delimitadores
		If At(cDelim1,cTxt) = 0
			
			//Primeiro Campo Não é Delimitador de Dados
			If At(cDelim2,cTxt) != 1
				aAdd(aData,cTxt)
			Else
				cTxtAux := Subst(cTxt,At(cDelim2,cTxt) + 1)
				cTxtAux := Subst(cTxtAux,1,At(cDelim2,cTxtAux) - 1)
			 
				aAdd(aData,cTxtAux)

			Endif
				
		Endif
	Enddo	
Endif								

Return(aData)

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fReadLin  ºAutor  ³J.Carlos/Trombini  º Data ³   10/08     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Leitura de Arquivo Texto Não Limitado a 1024 Colunas        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/
Static FUNCTION FReadLin(fHandle, cBuffer)

Local cLine		:= ''
Local nEol		:= 0
Local nNumRead	:= 0
Local nSavePos	:= 0

cLine   	:= Space(nMaxCol)
cBuffer 	:= ''

// Salva posi‡ao corrente do arquivo para reposicionar posteriormente
nSavePos := fSeek(fHandle,0,FS_RELATIVE)
nNumRead := FRead(fHandle, @cLine, nMaxCol)
                    
While At(CHR(10), SubStr(cLine, 1, nNumRead)) == 0 .And. nNumRead > 1
	nMaxCol		+= 1000
	cLine		:= Space(nMaxCol)
	
	//Posiciona Arquivo
	FSeek(fHandle, nSavePos, FS_SET)
	
	//Le Arquivo	
	nNumRead 	:= FRead(fHandle, @cLine, nMaxCol)
Enddo

If (nEol := At(CHR(13)+CHR(10), SubStr(cLine, 1, nNumRead))) == 0

	IF (nEol := At(CHR(10), SubStr(cLine, 1, nNumRead))) == 0

   		cBuffer 	:= cLine                     // Fim da linha lida ou EOF
    		
   	Else
   		cBuffer 	:= SubStr(cLine, 1, nEol - 1)  // Copia ate o EOL
 	
		// Posiciona na proxima linha (skip) ...
		nSavePos += nEol
		FSeek(fHandle, nSavePos, FS_SET)
	Endif
Else
	cBuffer := SubStr(cLine, 1, nEol - 1)  // Copia ate o EOL
	
	// Posiciona na proxima linha (skip) ...
	FSeek(fHandle, nSavePos + nEol + 1, FS_SET)
	
Endif

Return nNumRead != 0        // Se a ultima leitura nao teve sucesso ou eof

//Fim da Rotina		

//Fim do Programa