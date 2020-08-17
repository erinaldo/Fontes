#INCLUDE "rwmake.ch"
#INCLUDE "common.ch"
#include "topconn.ch"                                                 
                                                                   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³RGPE009 º Autor ³Adriana Sarro/Adriano Dias º Data ³  24/08/2004º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ   ¹±±
±±ºDescricao ³Provisão de Férias Analitico e Sintetico                       º±±
±±º          ³Provisão de 13 Salario Analitico e Sintetico                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU CARDSYSTEM S/A                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RGPE009


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1          	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3       		:= "RELATORIO DE PRPVISÃO DE FÉRIAS E PROVISÃO DE 13º"
Local cPict     		:= ""
Local titulo 		    := "RELATORIO DE PROVISÃO"
Local nLin         		:= 80
Local Cabec2			:= ""
Local Cabec1       		:= ""
Local aOrd 				:= {}
Local aOld				:= getarea()
Private lEnd         	:= .F.
Private _cQuery
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "RGPE009" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 15
Private aReturn         := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private _CPERG       	:= "RGP009"
Private cbtxt			:= Space(10)
Private cbcont			:= 00
Private CONTFL			:= 01
Private m_pag			:= 01
Private cDet			:= ""
Private nTotSal			:= 0
Private nTotFunc		:= 0
Private nTotSalG		:= 0
Private nTotFuncG		:= 0
Private cFilAnt			:= ""
Private aInfo			:= {}
Private aStru			:= {}
Private cArqTrab		:= ""
Private cArqTrab1		:= ""
Private wnrel			:= "RGPE009" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SRT"
Private lImprime		:=""

fPerg()
pergunte(_CPERG,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,_CPERG,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

// Carrega os parametros
cFilde		:= mv_par01		//	Filial De
cFilAte		:= mv_par02		//	Filial Ate
cCCDe		:= mv_par03		//	Centro de Custos De
cCCAte		:= mv_par04 	//	Centro de Custos Ate
cMatDe		:= mv_par05		//	Matricula De
cMatAte		:= mv_par06 	//	Matricula Ate
DaData      := mv_par07		//	Situacoes a imprimir
lImprime	:= mv_par08   	//	Tipo de Saida



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca as informacoes a imprimir no relatorio de reajustes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|lEnd| fDet()}, 'Criando arquivo temporario...')

if 	lImprime==1 //Relatorio analitico Prov 13 Salario
	
	RptStatus({|| Sint13Sal(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
elseif lImprime==2  //Relatorio analitico Prov Ferias
	
	RptStatus({|| SintFer(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
elseif lImprime==3 //Relatorio Sintetico Prov Ferias
	
	RptStatus({|| Anal13Sal(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
elseif lImprime==4 //Relatorio Sintetico Prov 13 Salario
	
	RptStatus({|| Analfer(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
endif

//close TRB
dbCloseArea("TRB")
RESTAREA( aOld )

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o ³Anal13Sal º Autor ³ Adriana Sarro/Adriano Diasº Dt.³ 14/09/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ gera relatório de provisão de 13 Salario analit. p/ centro º±±
±±º          ³ custo                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Sint13Sal(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem


//Variaveis do total geral
Local n001bsaldo		:=0
Local n002bprovisao		:=0
Local n003binss			:=0
Local n004bfgts			:=0
Local n005bbaixas		:=0
Local n006bsaldoatu		:=0
Local n007bavos			:=0

//Variaveis do total do c.custo
Local n008bsaldo		:=0
Local n009bprovisao		:=0
Local n010binss			:=0
Local n011bfgts			:=0
Local n012bbaixas		:=0
Local n013bsaldoatu		:=0
Local n014bavos			:=0

//Variaveis do Total da filial
Local n015bsaldo		:=0
Local n016bprovisao		:=0
Local n017binss			:=0
Local n018bfgts			:=0
Local n019bbaixas		:=0
Local n020bsaldoatu		:=0
Local n021bavos			:=0

//Variavel do c.custo anterior
Local cCant				:=""

//Variavel da filial anterior
Local cFilAnt			:=""

//Variavel da descricao
Local cDesc				:=""

Cabec2			:= "                                                         Cod. C.Custo           Descricao C.Custo     13Sal SdoAnt  13Sal Provisao      13Sal INSS      13Sal FGTS    13Sal Baixas  13Sal SdoAtual      13Sal Avos"
titulo 		    := "S I N T É T I C O - Relatório de Provisão de 13 Salário"


dbSelectArea("TRB")
dbgotop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt		 := TRB->FILIAL
cCant		 :=TRB->CC
cDesc		 :=TRB->DESC
fInfo(@aInfo,TRB->FILIAL)
cabec1		 := padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
SetRegua(RecCount())

do while !eof()
	
	incregua()
	
	//grava nova filial
	cFilAnt:=TRB->FILIAL
	
	//zera valores para a nova filial
	n008bsaldo		:=	0
	n009bprovisao	:=	0
	n010binss		:=	0
	n011bfgts		:=	0
	n012bbaixas		:=	0
	n013bsaldoatu	:=	0
	n014bavos		:=	0
	
	
	do while !eof().and.cFilAnt== TRB->FILIAL
		cCant:=TRB->CC
		cDesc:=TRB->DESC
		
		//zera valores para o novo c.custo
		n015bsaldo 		:=0
		n016bprovisao	:=0
		n017binss		:=0
		n018bfgts		:=0
		n019bbaixas		:=0
		n020bsaldoatu	:=0
		n021bavos		:=0
		
		
		do while !eof().and.cFilAnt== TRB->FILIAL.and.cCant==TRB->CC
			
			//Acumula valores para o c.custo
			n015bsaldo 		:=	n015bsaldo+TRB->BSALDOANT
			n016bprovisao	:=	n016bprovisao+TRB->BPROVISAO
			n017binss		:=	n017binss+TRB->BINSS
			n018bfgts		:=	n018bfgts+TRB->BFGTS
			n019bbaixas		:=	n019bbaixas+TRB->BBAIXAS
			n020bsaldoatu	:=	n020bsaldoatu+TRB->BSALDOATU
			n021bavos		:=	n021bavos+TRB->BAVOS
			
			//Acumula valores para a filial
			n008bsaldo		:=	n008bsaldo+TRB->BSALDOANT
			n009bprovisao	:=	n009bprovisao+TRB->BPROVISAO
			n010binss		:=	n010binss+TRB->BINSS
			n011bfgts		:=	n011bfgts+TRB->BFGTS
			n012bbaixas		:=	n012bbaixas+TRB->BBAIXAS
			n013bsaldoatu	:=	n013bsaldoatu+TRB->BSALDOATU
			n014bavos		:=	n014bavos+TRB->BAVOS
			
			//Acumula valores para o total geral
			n001bsaldo		:=n001bsaldo+TRB->BSALDOANT
			n002bprovisao	:=n002bprovisao+TRB->BPROVISAO
			n003binss		:=n003binss+TRB->BINSS
			n004bfgts		:=n004bfgts+TRB->BFGTS
			n005bbaixas		:=n005bbaixas+TRB->BBAIXAS
			n006bsaldoatu	:=n006bsaldoatu+TRB->BSALDOATU
			n007bavos		:=n007bavos+TRB->BAVOS
			
			dbSkip()
		enddo
		
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
			nLin := 9
		Endif
		
		//imprime total do c.custo
		//@nLin,000 PSAY TRB->FILIAL
		@nLin,058 PSAY cCant
		@nLin,081 PSAY cDesc
		@nLin,102 PSAY transform(n015bsaldo,"@E 999,999,999.99")
		@nLin,118 PSAY transform(n016bprovisao,"@E 999,999,999.99")
		@nLin,134 PSAY transform(n017binss,"@E 999,999,999.99")
		@nLin,150 PSAY transform(n018bfgts,"@E 999,999,999.99")
		@nLin,166 PSAY transform(n019bbaixas,"@E 999,999,999.99")
		@nLin,182 PSAY transform(n020bsaldoatu,"@E 999,999,999.99")
		//@nLin,198 PSAY transform(n021bavos,"@E 999,999,999.99")
		nLin++
	enddo
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
		nLin := 9
	Endif
	
	//imprime o total da filial e zera valores
	nLin := nLin + 2 // Avanca a linha de impressao
	@nLin,010 PSAY "Total Filial -------->"
	@nLin,102 PSAY transform(n008bsaldo,"@E 999,999,999.99")
	@nLin,118 PSAY transform(n009bprovisao,"@E 999,999,999.99")
	@nLin,134 PSAY transform(n010binss,"@E 999,999,999.99")
	@nLin,150 PSAY transform(n011bfgts,"@E 999,999,999.99")
	@nLin,166 PSAY transform(n012bbaixas,"@E 999,999,999.99")
	@nLin,182 PSAY transform(n013bsaldoatu,"@E 999,999,999.99")
	nLin++
	//	@nLin,198 PSAY transform(n014bavos,"@E 999,999,999.99")
	
	nLin := 70
	fInfo(@aInfo,TRB->FILIAL)
	cFilAnt:= TRB->FILIAL
	cabec1:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
	
enddo
If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
	nLin := 9
Endif

// impressao do total geral
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,010 PSAY "Total Geral -------->"
@nLin,102 PSAY transform(n001bsaldo,"@E 999,999,999.99")
@nLin,118 PSAY transform(n002bprovisao,"@E 999,999,999.99")
@nLin,134 PSAY transform(n003binss,"@E 999,999,999.99")
@nLin,150 PSAY transform(n004bfgts,"@E 999,999,999.99")
@nLin,166 PSAY transform(n005bbaixas,"@E 999,999,999.99")
@nLin,182 PSAY transform(n006bsaldoatu,"@E 999,999,999.99")

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o ³AnalFer l º Autor ³ Adriana Sarro\Adriano Dias      º Data ³  14/09/04º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ gera relatório de provisão de Ferias     o analitico p/ c.        º±±
±±º          ³ custo                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SintFer(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem

//Variaveis do total geral
Local n001asaldo		:=0
Local n002aprovisao		:=0
Local n003ainss			:=0
Local n004afgts			:=0
Local n005abaixas		:=0
Local n006asaldoatu		:=0
Local n007aavos			:=0

//Variaveis do total do c.custo
Local n008asaldo		:=0
Local n009aprovisao		:=0
Local n010ainss			:=0
Local n011afgts			:=0
Local n012abaixas		:=0
Local n013asaldoatu		:=0
Local n014aavos			:=0

//Variaveis do Total da filial
Local n015asaldo		:=0
Local n016aprovisao		:=0
Local n017ainss			:=0
Local n018afgts			:=0
Local n019abaixas		:=0
Local n020asaldoatu		:=0
Local n021aavos			:=0

//Variavel do c.custo anterior
Local cCant				:=""

//Variavel da filial anterior
Local cFilAnt			:=""

//Variavel da descricao
Local cDesc				:=""

Cabec2			:= "                                                         Cod. C.Custo           Descricao C.Custo       Fer SdoAnt    Fer Provisao        Fer INSS        Fer FGTS      Fer Baixas    Fer SdoAtual        Fer Avos"
titulo 		    := "S I N T É T I C O - Relatório de Provisão de Férias"


dbSelectArea("TRB")
dbgotop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt		 := TRB->FILIAL
cCant		 :=TRB->CC
cDesc		 :=TRB->DESC
fInfo(@aInfo,TRB->FILIAL)
cabec1		 := padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
SetRegua(RecCount())

do while !eof()
	
	incregua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//grava nova filial
	cFilAnt:=TRB->FILIAL
	
	//zera valores para a nova filial
	n008asaldo		:=	0
	n009aprovisao	:=	0
	n010ainss		:=	0
	n011afgts		:=	0
	n012abaixas		:=	0
	n013asaldoatu	:=	0
	n014aavos		:=	0
	
	
	do while !eof( ) .and. cFilAnt == TRB ->Filial
		//grava codigo do novo c.custo
		cCant:=TRB->CC
		cDesc:=TRB->DESC
		
		//zera valores para o novo c.custo
		n015asaldo 		:=0
		n016aprovisao	:=0
		n017ainss		:=0
		n018afgts		:=0
		n019abaixas		:=0
		n020asaldoatu	:=0
		n021aavos		:=0
		
		do while !eof ( ) .and. cFilAnt== TRB->Filial.and.cCant==TRB->CC
			
			//Acumula valores para o total geral
			n001asaldo		:=n001asaldo+TRB->ASALDOANT
			n002aprovisao	:=n002aprovisao+TRB->APROVISAO
			n003ainss		:=n003ainss+TRB->AINSS
			n004afgts		:=n004afgts+TRB->AFGTS
			n005abaixas		:=n005abaixas+TRB->ABAIXAS
			n006asaldoatu	:=n006asaldoatu+TRB->ASALDOATU
			n007aavos		:=n007aavos+TRB->AAVOS
			
			//Acumula valores para a filial
			n008asaldo		:=	n008asaldo+TRB->ASALDOANT
			n009aprovisao	:=	n009aprovisao+TRB->APROVISAO
			n010ainss		:=	n010ainss+TRB->AINSS
			n011afgts		:=	n011afgts+TRB->AFGTS
			n012abaixas		:=	n012abaixas+TRB->ABAIXAS
			n013asaldoatu	:=	n013asaldoatu+TRB->ASALDOATU
			n014aavos		:=	n014aavos+TRB->AAVOS
			
			//Acumula valores para o c.custo
			n015asaldo 		:=	n015asaldo+TRB->ASALDOANT
			n016aprovisao	:=	n016aprovisao+TRB->APROVISAO
			n017ainss		:=	n017ainss+TRB->AINSS
			n018afgts		:=	n018afgts+TRB->AFGTS
			n019abaixas		:=	n019abaixas+TRB->ABAIXAS
			n020asaldoatu	:=	n020asaldoatu+TRB->ASALDOATU
			n021aavos		:=	n021aavos+TRB->BAVOS
			
			dbSkip() // Avanca o ponteiro do registro no arquivo
			
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
			nLin := 9
		Endif
		//imprime total do c. custo
		nlin:=nlin+1
		@nLin,058 PSAY cCant
		@nLin,081 PSAY cDesc
		@nLin,102 PSAY transform(n015asaldo,"@E 999,999,999.99")
		@nLin,118 PSAY transform(n016aprovisao,"@E 999,999,999.99")
		@nLin,134 PSAY transform(n017ainss,"@E 999,999,999.99")
		@nLin,150 PSAY transform(n018afgts,"@E 999,999,999.99")
		@nLin,166 PSAY transform(n019abaixas,"@E 999,999,999.99")
		@nLin,182 PSAY transform(n020asaldoatu,"@E 999,999,999.99")
		//	@nLin,198 PSAY transform(n021aavos,"@E 999,999,999.99")
	Enddo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
		nLin := 9
	Endif
	
	//imprime o total da filial e zera valores
	nLin := nLin + 2 // Avanca a linha de impressao
	@nLin,010 PSAY "Total Filial -------->"
	@nLin,102 PSAY transform(n008asaldo,"@E 999,999,999.99")
	@nLin,118 PSAY transform(n009aprovisao,"@E 999,999,999.99")
	@nLin,134 PSAY transform(n010ainss,"@E 999,999,999.99")
	@nLin,150 PSAY transform(n011afgts,"@E 999,999,999.99")
	@nLin,166 PSAY transform(n012abaixas,"@E 999,999,999.99")
	@nLin,182 PSAY transform(n013asaldoatu,"@E 999,999,999.99")
	//@nLin,198 PSAY transform(n014aavos,"@E 999,999,999.99")
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
		nLin := 9
	Endif
	// Impressao dos totais da filial
	nLin := nLin + 2 // Avanca a linha de impressao
	@nLin,010 PSAY "Total Filial -------->"
	@nLin,102 PSAY transform(n008asaldo,"@E 999,999,999.99")
	@nLin,118 PSAY transform(n009aprovisao,"@E 999,999,999.99")
	@nLin,134 PSAY transform(n010ainss,"@E 999,999,999.99")
	@nLin,150 PSAY transform(n011afgts,"@E 999,999,999.99")
	@nLin,166 PSAY transform(n012abaixas,"@E 999,999,999.99")
	@nLin,182 PSAY transform(n013asaldoatu,"@E 999,999,999.99")
	//@nLin,198 PSAY transform(n014aavos,"@E 999,999,999.99")
	
	nLin:= 80
	fInfo(@aInfo,TRB->FILIAL)
	cFilAnt		:= TRB->FILIAL
	cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
Enddo

If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
	nLin := 9
Endif
//Impressao dos total geral
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,010 PSAY "Total Geral -------->"
@nLin,102 PSAY transform(n001asaldo,"@E 999,999,999.99")
@nLin,118 PSAY transform(n002aprovisao,"@E 999,999,999.99")
@nLin,134 PSAY transform(n003ainss,"@E 999,999,999.99")
@nLin,150 PSAY transform(n004afgts,"@E 999,999,999.99")
@nLin,166 PSAY transform(n005abaixas,"@E 999,999,999.99")
@nLin,182 PSAY transform(n006asaldoatu,"@E 999,999,999.99")
//@nLin,198 PSAY transform(n007aavos,"@E 999,999,999.99")

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
±±ºFun‡„o³sint13sal º Autor ³ Adriana Sarro/ Adriano Dias º Dt. 14/09/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ gera relatório de provisão de 13 salarario sintetico       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Anal13Sal(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local n008bsaldoant	:=0
Local n009bprovisao	:=0
Local n010binss		:=0
Local n011bfgts		:=0
Local n012bbaixas	:=0
Local n013bsaldoatu	:=0
Local n014bavos		:=0

Local n001bsaldoant	:=0
Local n002bprovisao	:=0
Local n003binss		:=0
Local n004bfgts		:=0
Local n005bbaixas	:=0
Local n006bsaldoatu	:=0
Local n007bavos		:=0

Cabec2			:= "Fil Mat     Nome                                     Sit Cod. C.Custo           Descricao C.Custo     13Sal SdoAnt  13Sal Provisao      13Sal INSS      13Sal FGTS    13Sal Baixas  13Sal SdoAtual      13Sal Avos"
titulo 		    := "A N A L í T I C O - Relatório de Provisão de 13 Salário"

dbSelectArea("TRB")
dbgotop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := TRB->FILIAL
fInfo(@aInfo,TRB->FILIAL)
cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
SetRegua(RecCount())

do while !eof()
	
	incregua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If cFilAnt <> TRB->FILIAL
		nLin := nLin + 2
		@nLin,010 PSAY "Total Filial -------->"
		@nLin,102 PSAY transform(n008bsaldoant,"@E 999,999,999.99")
		@nLin,118 PSAY transform(n009bprovisao,"@E 999,999,999.99")
		@nLin,134 PSAY transform(n010binss,"@E 999,999,999.99")
		@nLin,150 PSAY transform(n011bfgts,"@E 999,999,999.99")
		@nLin,166 PSAY transform(n012bbaixas,"@E 999,999,999.99")
		@nLin,182 PSAY transform(n013bsaldoatu,"@E 999,999,999.99")
		//		@nLin,198 PSAY transform(n014bavos,"@E 999,999,999.99")
		
		nlin:=80
		fInfo(@aInfo,TRB->FILIAL)
		cFilAnt		:= TRB->FILIAL
		cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
		
		n008bsaldoant	:=0
		n009bprovisao	:=0
		n010binss		:=0
		n011bfgts		:=0
		n012bbaixas		:=0
		n013bsaldoatu	:=0
		n014bavos		:=0
		
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,000 PSAY TRB->FILIAL
	@nLin,004 PSAY TRB->MAT
	@nLin,014 PSAY TRB->NOME
	@nLin,055 PSAY TRB->SITUACAO
	@nLin,058 PSAY TRB->CC
	@nLin,081 PSAY TRB->DESC
	@nLin,102 PSAY transform(TRB->BSALDOANT,"@E 999,999,999.99")
	@nLin,118 PSAY transform(TRB->BPROVISAO,"@E 999,999,999.99")
	@nLin,134 PSAY transform(TRB->BINSS,"@E 999,999,999.99")
	@nLin,150 PSAY transform(TRB->BFGTS,"@E 999,999,999.99")
	@nLin,166 PSAY transform(TRB->BBAIXAS,"@E 999,999,999.99")
	@nLin,182 PSAY transform(TRB->BSALDOATU,"@E 999,999,999.99")
	@nLin,198 PSAY transform(TRB->BAVOS,"@E 999,999,999.99")
	
	
	n008bsaldoant	:=n008bsaldoant+TRB->BSALDOANT
	n009bprovisao	:=n009bprovisao+TRB->BPROVISAO
	n010binss		:=n010binss+TRB->BINSS
	n011bfgts		:=n011bfgts+TRB->BFGTS
	n012bbaixas		:=n012bbaixas+TRB->BBAIXAS
	n013bsaldoatu	:=n013bsaldoatu+TRB->BSALDOATU
	n014bavos		:=n014bavos+TRB->BAVOS
	
	
	n001bsaldoant	:=n001bsaldoant+TRB->BSALDOANT
	n002bprovisao	:=n002bprovisao+TRB->BPROVISAO
	n003binss		:=n003binss+TRB->BINSS
	n004bfgts		:=n004bfgts+TRB->BFGTS
	n005bbaixas		:=n005bbaixas+TRB->BBAIXAS
	n006bsaldoatu	:=n006bsaldoatu+TRB->BSALDOATU
	n007bavos		:=n007bavos+TRB->BAVOS
	
	// Impressao do documento
	nLin := nLin + 1 // Avanca a linha de impressao
	
	dbselectarea("TRB")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
	nLin := 9
Endif

// Impressao dos totais de funcionarios
nLin := nLin + 2
@nLin,010 PSAY "Total Filial -------->"
@nLin,102 PSAY transform(n008bsaldoant,"@E 999,999,999.99")
@nLin,118 PSAY transform(n009bprovisao,"@E 999,999,999.99")
@nLin,134 PSAY transform(n010binss,"@E 999,999,999.99")
@nLin,150 PSAY transform(n011bfgts,"@E 999,999,999.99")
@nLin,166 PSAY transform(n012bbaixas,"@E 999,999,999.99")
@nLin,182 PSAY transform(n013bsaldoatu,"@E 999,999,999.99")
//@nLin,198 PSAY transform(n014bavos,"@E 999,999,999.99")

nLin := nLin + 2 // Avanca a linha de impressao
@nLin,010 PSAY "Total Geral -------->"
@nLin,102 PSAY transform(n001bsaldoant,"@E 999,999,999.99")
@nLin,118 PSAY transform(n002bprovisao,"@E 999,999,999.99")
@nLin,134 PSAY transform(n003binss,"@E 999,999,999.99")
@nLin,150 PSAY transform(n004bfgts,"@E 999,999,999.99")
@nLin,166 PSAY transform(n005bbaixas,"@E 999,999,999.99")
@nLin,182 PSAY transform(n006bsaldoatu,"@E 999,999,999.99")
//@nLin,198 PSAY transform(n007bavos,"@E 999,999,999.99")

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


/*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³sintfer   ºAutor  ³Adriana Sarro       º Data ³  14/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ relatorio sintetico de provisão de ferias                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


static function Analfer(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local n008asaldoant	:=0
Local n009aprovisao	:=0
Local n010ainss		:=0
Local n011afgts		:=0
Local n012abaixas	:=0
Local n013asaldoatu	:=0
Local n014aavos		:=0

Local n001asaldoant	:=0
Local n002aprovisao	:=0
Local n003ainss		:=0
Local n004afgts		:=0
Local n005abaixas	:=0
Local n006asaldoatu	:=0
Local n007aavos		:=0

Cabec2			:= "Fil Mat     Nome                                     Sit Cod. C.Custo           Descricao C.Custo       Fer SdoAnt    Fer Provisao        Fer INSS        Fer FGTS      Fer Baixas    Fer SdoAtual        Fer Avos"
titulo 		    := "A N A L í T I C O - Relatório de Provisão de Férias"

dbSelectArea("TRB")
dbgotop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := TRB->FILIAL
fInfo(@aInfo,TRB->FILIAL)
cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
SetRegua(RecCount())

do while !eof()
	
	incregua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If cFilAnt <> TRB->FILIAL
		nLin := nLin + 2
		@nLin,010 PSAY "Total Filial -------->"
		@nLin,102 PSAY transform(n008asaldoant,"@E 999,999,999.99")
		@nLin,118 PSAY transform(n009aprovisao,"@E 999,999,999.99")
		@nLin,134 PSAY transform(n010ainss,"@E 999,999,999.99")
		@nLin,150 PSAY transform(n011afgts,"@E 999,999,999.99")
		@nLin,166 PSAY transform(n012abaixas,"@E 999,999,999.99")
		@nLin,182 PSAY transform(n013asaldoatu,"@E 999,999,999.99")
		//		@nLin,198 PSAY transform(n014aavos,"@E 999,999,999.99")
		
		//grava nova filial
		cFilAnt:=TRB->FILIAL
		
		nlin:=80
		fInfo(@aInfo,TRB->FILIAL)
		cFilAnt		:= TRB->FILIAL
		cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
		
		n008asaldoant	:=0
		n009aprovisao	:=0
		n010ainss		:=0
		n011afgts		:=0
		n012abaixas		:=0
		n013asaldoatu	:=0
		n014aavos		:=0
		
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,000 PSAY TRB->FILIAL
	@nLin,004 PSAY TRB->MAT
	@nLin,014 PSAY TRB->NOME
	@nLin,055 PSAY TRB->SITUACAO
	@nLin,058 PSAY TRB->CC
	@nLin,081 PSAY TRB->DESC
	@nLin,102 PSAY transform(TRB->ASALDOANT,"@E 999,999,999.99")
	@nLin,118 PSAY transform(TRB->APROVISAO,"@E 999,999,999.99")
	@nLin,134 PSAY transform(TRB->AINSS,"@E 999,999,999.99")
	@nLin,150 PSAY transform(TRB->AFGTS,"@E 999,999,999.99")
	@nLin,166 PSAY transform(TRB->ABAIXAS,"@E 999,999,999.99")
	@nLin,182 PSAY transform(TRB->ASALDOATU,"@E 999,999,999.99")
	@nLin,198 PSAY transform(TRB->AAVOS,"@E 999,999,999.99")
	
	
	n008asaldoant	:=n008asaldoant+TRB->ASALDOANT
	n009aprovisao	:=n009aprovisao+TRB->APROVISAO
	n010ainss		:=n010ainss+TRB->AINSS
	n011afgts		:=n011afgts+TRB->AFGTS
	n012abaixas		:=n012abaixas+TRB->ABAIXAS
	n013asaldoatu	:=n013asaldoatu+TRB->ASALDOATU
	n014aavos		:=n014aavos+TRB->AAVOS
	
	
	n001asaldoant	:=n001asaldoant+TRB->ASALDOANT
	n002aprovisao	:=n002aprovisao+TRB->APROVISAO
	n003ainss		:=n003ainss+TRB->AINSS
	n004afgts		:=n004afgts+TRB->AFGTS
	n005abaixas		:=n005abaixas+TRB->ABAIXAS
	n006asaldoatu	:=n006asaldoatu+TRB->ASALDOATU
	n007aavos		:=n007aavos+TRB->AAVOS
	
	// Impressao do documento
	nLin := nLin + 1 // Avanca a linha de impressao
	
	dbselectarea("TRB")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
	nLin := 9
Endif

// Impressao dos totais de funcionarios
nLin := nLin + 2
@nLin,010 PSAY "Total Filial -------->"
@nLin,102 PSAY transform(n008asaldoant,"@E 999,999,999.99")
@nLin,118 PSAY transform(n009aprovisao,"@E 999,999,999.99")
@nLin,134 PSAY transform(n010ainss,"@E 999,999,999.99")
@nLin,150 PSAY transform(n011afgts,"@E 999,999,999.99")
@nLin,166 PSAY transform(n012abaixas,"@E 999,999,999.99")
@nLin,182 PSAY transform(n013asaldoatu,"@E 999,999,999.99")
//@nLin,198 PSAY transform(n014aavos,"@E 999,999,999.99")

nLin := nLin + 2 // Avanca a linha de impressao
@nLin,010 PSAY "Total Geral -------->"
@nLin,102 PSAY transform(n001asaldoant,"@E 999,999,999.99")
@nLin,118 PSAY transform(n002aprovisao,"@E 999,999,999.99")
@nLin,134 PSAY transform(n003ainss,"@E 999,999,999.99")
@nLin,150 PSAY transform(n004afgts,"@E 999,999,999.99")
@nLin,166 PSAY transform(n005abaixas,"@E 999,999,999.99")
@nLin,182 PSAY transform(n006asaldoatu,"@E 999,999,999.99")
//@nLin,198 PSAY transform(n007aavos,"@E 999,999,999.99")

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

//Detalhe do relatório de provisão

Static function fDet()
Private _ddemissa,_dadmissa
Private _cfilial,_cmat,	_cNome,	_cSituacao,	_cSindicato, _cDescricao,_cCC	:=""
Private FRSdoAnt,AnteriorSdo,SProvant,FRProvant,FRINSSAnt,;
FRFGTSAnt,SINSSAnt,SFGTSAnt,FRSdoAtual,SAtual,FR_Baixas,;
SBaixas,SProvAtual,FRProvAtual,FRINSSAtual,FRFGTSAtual,;
SINSSAtual,SFGTSAtual,FRAvos,FRProvisao	,SProvisao,FeriasINSS,;
SINSS,FRFGTS,SFGTS,SAvos, BFGTSAtualFR,BINSSAtualFR,FRFGTSBA,FRINSSBA,SAtualBas,;
SdoAtualBFR,ProvAtualBFR,INSSAtualBFR,FGTSAtualBFR,BdoSAtualFR,SAtualFRB,ZZ:=0


aAdd(aStru,{"FILIAL"   		,"C",02,0})
aAdd(aStru,{"MAT"			,"C",06,0})
aAdd(aStru,{"NOME"			,"C",40,0})
aAdd(aStru,{"CC"  			,"C",20,0})
aAdd(aStru,{"DESC"  		,"C",20,0})
aAdd(aStru,{"SINDICATO"		,"C",02,0})
aAdd(aStru,{"SITUACAO"		,"C",01,0})
aAdd(aStru,{"ASALDOANT"		,"N",14,2})
aAdd(aStru,{"APROVISAO"		,"N",14,2})
aAdd(aStru,{"AINSS"			,"N",14,2})
aAdd(aStru,{"AFGTS"		   	,"N",14,2})
aAdd(aStru,{"ABAIXAS"		,"N",14,2})
aAdd(aStru,{"ASALDOATU"		,"N",14,2})
aAdd(aStru,{"AAVOS"			,"N",02,0})
aAdd(aStru,{"BSALDOANT"		,"N",14,2})
aAdd(aStru,{"BPROVISAO"		,"N",14,2})
aAdd(aStru,{"BINSS"			,"N",14,2})
aAdd(aStru,{"BFGTS"		   	,"N",14,2})
aAdd(aStru,{"BBAIXAS"		,"N",14,2})
aAdd(aStru,{"BSALDOATU"		,"N",14,2})
aAdd(aStru,{"BAVOS"			,"N",02,0})
aAdd(aStru,{"DDEMISSA"		,"D",08,0})
aAdd(aStru,{"DADMISSA"		,"D",08,0})

cArqTrab	:= CriaTrab(aStru,.t.)
use &cArqTrab ALIAS TRB NEW

Private MesAnterior:=MV_PAR07-day(mv_par07)

_cQuery := " SELECT "+RETSQLNAME('SRA')+".RA_NOME, "+RETSQLNAME('SRA')+".RA_SINDICA, "
_cQuery += " "+RETSQLNAME('SRA')+".RA_SITFOLH, "+RETSQLNAME('SRT')+".RT_FILIAL, "+RETSQLNAME('SRT')+".RT_MAT,"
_cQuery += " "+RETSQLNAME('SRT')+".RT_CC, "+RETSQLNAME('CTT')+".CTT_DESC01, "+RETSQLNAME('SRT')+".RT_DATACAL, "+RETSQLNAME('SRT')+".RT_DATABAS, "
_cQuery += " "+RETSQLNAME('SRT')+".RT_TIPPROV, "+RETSQLNAME('SRT')+".RT_VERBA, "+RETSQLNAME('SRT')+".RT_VALOR,"
_cQuery += " "+RETSQLNAME('SRT')+".RT_DFERVEN, "+RETSQLNAME('SRT')+".RT_DFERPRO, "+RETSQLNAME('SRT')+".RT_DFERANT,"
_cQuery += " "+RETSQLNAME('SRT')+".RT_DFALVEN, "+RETSQLNAME('SRT')+".RT_DFALPRO, "+RETSQLNAME('SRT')+".RT_AVOS13S, "
_cQuery += " "+RETSQLNAME('SRA')+".RA_DEMISSA, "+RETSQLNAME('SRA')+".RA_ADMISSA "
_cQuery += " FROM "
_cQuery += " "+RETSQLNAME('SRA')+", "+RETSQLNAME('CTT')+","+RETSQLNAME('SRT')+" "
_cQuery += " WHERE "
_cQuery += " "+RETSQLNAME('SRA')+".RA_FILIAL="+RETSQLNAME('SRT')+".RT_FILIAL AND "
_cQuery += " "+RETSQLNAME('SRA')+".RA_MAT="+RETSQLNAME('SRT')+".RT_MAT  AND "
_cQuery += " "+RETSQLNAME('CTT')+".CTT_CUSTO="+RETSQLNAME('SRT')+".RT_CC AND "
_cQuery += " "+RETSQLNAME('SRT')+".RT_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
_cQuery += " "+RETSQLNAME('SRT')+".RT_MAT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
_cQuery += " "+RETSQLNAME('SRT')+".RT_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
_cQuery += " "+RETSQLNAME('SRT')+".RT_DATACAL BETWEEN '"+DTOS(MesAnterior)+ "' AND '"+DTOS(MV_PAR07)+"' AND "
_cQuery += " "+RETSQLNAME('SRT')+".D_E_L_E_T_ <> '*' AND "
_cQuery += " "+RETSQLNAME('SRA')+".D_E_L_E_T_ <> '*' AND "
_cQuery += " "+RETSQLNAME('CTT')+".D_E_L_E_T_ <> '*' "
_cQuery += " ORDER BY "+RETSQLNAME('SRT')+".RT_FILIAL,"+RETSQLNAME('SRT')+".RT_CC,"+RETSQLNAME('SRT')+".RT_MAT "

If Select("TRDEXC")>0
	DBSelectArea("TRDEXC")
	DBCloseArea()
EndIf
IncProc("Buscando Dados")
TCQUERY _cQuery NEW ALIAS "TRDEXC" //executa a query e cria nova area TRDEXC

DBSelectArea("TRDEXC")
DBGotop()

WHILE !EOF()
	

	IncProc("AtualiZando" + "Filial "+TRDEXC->RT_FILIAL+"Matricula "+TRDEXC->RT_MAT)
	
	_cfilial	   		:= TRDEXC->RT_FILIAL
	_cmat   	   		:= TRDEXC->RT_MAT   
	_cNome		   		:= TRDEXC->RA_NOME
	_cSituacao  		:= TRDEXC->RA_SITFOLH
	_cSindicato			:= TRDEXC->RA_SINDICA
	_cDescricao	   		:= TRDEXC->CTT_DESC01
	_cCC	 	  		:= TRDEXC->RT_CC
	_DDEMISSA 	  		:= IF(TRDEXC->RA_SITFOLH='D',CTOD(SUBS(TRDEXC->RA_DEMISSA,7,2)+'/'+SUBS(TRDEXC->RA_DEMISSA,5,2)+'/'+SUBS(TRDEXC->RA_DEMISSA,3,2)),CTOD("00/00/00"))
	_DADMISSA 	  		:= CTOD(SUBS(TRDEXC->RA_ADMISSA,7,2)+'/'+SUBS(TRDEXC->RA_ADMISSA,5,2)+'/'+SUBS(TRDEXC->RA_ADMISSA,3,2))
	AnteriorSdo	   		:=0
	SProvant			:=0
	FRProvant			:=0
	FRINSSAnt			:=0
	FRFGTSAnt	   		:=0
	SINSSAnt	 		:=0
	SFGTSAnt	 		:=0
	FRSdoAtual 			:=0
	FRSdoAnt            :=0
	SAtual	  			:=0
	FRBaixas   			:=0
	SBaixas	   			:=0
	SProvAtual	  		:=0
	FRProvAtual			:=0
	FRINSSAtual			:=0
	FRFGTSAtual			:=0
	SINSSAtual	 		:=0
	SFGTSAtual	 		:=0
	BProvAtual          :=0
	BINSSAtual          :=0
	BFGTSAtual          :=0
	BDemAtual           :=0
	FRAvos				:=0
	FRProvisao	 		:=0
	SProvisao			:=0
	FRINSS				:=0
	SINSS				:=0
	FRFGTS				:=0
	SFGTS				:=0
	ZZ					:=0
	// Variaveis Baixas Ferias
	
	SdoAtualBFR         :=0
	ProvAtualBFR        :=0
	SAtualFRB           :=0
	BdoSAtualFR         :=0
	INSSAtualBFR        :=0
	BINSSAtualFR        :=0
	FRINSSBA            :=0
	FGTSAtualBFR        :=0
	BFGTSAtualFR        :=0
	FRFGTSBA            :=0
	SAtualBas           :=0
	
	While TRDEXC->(RT_FILIAL=_cfilial .AND. RT_MAT=_cmat.AND.!EOF())
		
		if TRDEXC->RT_DATACAL<>DTOS(MV_PAR07)
			//Mes anterior
			
			//Férias - Saldo Anterior
			if TRDEXC->RT_VERBA$'750*751*752*851*852'
				FRSdoAnt:=FRSdoAnt+TRDEXC->RT_VALOR
			Endif
			
			//13 Salario - Saldo Anterior
			if TRDEXC->RT_VERBA$'753*754*755*861'
				AnteriorSdo:=AnteriorSdo+TRDEXC->RT_VALOR
			Endif
			
			//13 Salario - Provisao do mes anterior
			if TRDEXC->RT_VERBA$'753*861'
				SProvant:=SProvant+TRDEXC->RT_VALOR
			Endif
			
			//FR - Provisao do mes anterior
			if TRDEXC->RT_VERBA$'750*851*852'
				FRProvant:=FRProvant+TRDEXC->RT_VALOR
			Endif
			
			// FR - INSS do mes anterior
			if TRDEXC->RT_VERBA$'751'
				FRINSSAnt:=FRINSSAnt+TRDEXC->RT_VALOR
			Endif
			
			//13 Salario - FGTS do mes anterior
			if TRDEXC->RT_VERBA$'755'
				SFGTSAnt:=SFGTSAnt+TRDEXC->RT_VALOR
			Endif
			
			// FR - FGTS do mes anterior
			if TRDEXC->RT_VERBA$'752'
				FRFGTSAnt:=FRFGTSAnt+TRDEXC->RT_VALOR
			Endif
			
			// 13 Salario - INSS do mes anterior
			if TRDEXC->RT_VERBA$'754'
				SINSSAnt:=SINSSAnt+TRDEXC->RT_VALOR
			Endif
			
		Else
			
			// FR - Saldo Atual
			if TRDEXC->RT_VERBA$'750*751*752*851*852'
				FRSdoAtual:=FRSdoAtual+TRDEXC->RT_VALOR
			Endif
			
			//FR - Saldo Baixas Atual
			if TRDEXC->RT_VERBA$'896*899*900*898*897'
				SdoAtualBFR:=SdoAtualBFR+TRDEXC->RT_VALOR
			Endif
			
			
			// FR - Saldo Baixas Atual
			if TRDEXC->RT_VERBA$'855*858*859*856*857'
				BdoSAtualFR:=BdoSAtualFR+TRDEXC->RT_VALOR
			Endif
			
			// FR - Saldo Baixas Atual
			if TRDEXC->RT_VERBA$'756*757*758*853*854'
				SAtualFRB:=SAtualFRB+TRDEXC->RT_VALOR
			Endif
			
			// FR - Saldo Baixas Atual
			if TRDEXC->RT_VERBA$'756*853*854'
				SAtualBas:=SAtualBas+TRDEXC->RT_VALOR
			Endif
			
			// 13 Salario - Saldo Atual
			if TRDEXC->RT_VERBA$'753*754*755*861'
				SAtual:=SAtual+TRDEXC->RT_VALOR
			Endif
			
			// FR - Baixas
			if TRDEXC->RT_VERBA$'756*757*758*853*854*855*856*857*858*859*896*897*898*899*900'
				FRBaixas  :=FRBaixas+TRDEXC->RT_VALOR
			Endif
			
			//13 Salario - Baixas
			if TRDEXC->RT_VERBA$'863*864*865*866*901*902*903*904'
				SBaixas:=SBaixas+TRDEXC->RT_VALOR
			Endif
			
			// 13 Salario - Provisao do mes atual
			if TRDEXC->RT_VERBA$'753*861'
				SProvAtual:=SProvAtual+	TRDEXC->RT_VALOR
			Endif
			
			// 13 Salario - Baixas do mes atual
			if TRDEXC->RT_VERBA$'901*902*863*864'
				BProvAtual:=BProvAtual+TRDEXC->RT_VALOR
			Endif
			
			// FR - Provisao do mes atual
			if TRDEXC->RT_VERBA$'750*851*852'
				FRProvAtual:=FRProvAtual+TRDEXC->RT_VALOR
			Endif
			
			// FR - Provisao Baixa do mes atual
			//if TRDEXC->RT_VERBA$'896*853*854'
			//ProvAtualBFR:=ProvAtualBFR+TRDEXC->RT_VALOR
			// Endif
			
			// FR - INSS do mes atual
			if TRDEXC->RT_VERBA$'751'
				FRINSSAtual:=FRINSSAtual+TRDEXC->RT_VALOR
			Endif
			
			// FR - INSS Baixa do mes atual
			if TRDEXC->RT_VERBA$'757'
				INSSAtualBFR:=INSSAtualBFR+TRDEXC->RT_VALOR
			Endif
			/*
			// FR - INSS Baixa do mes atual
			if TRDEXC->RT_VERBA$'858'
			BINSSAtualFR:=BINSSAtualFR+TRDEXC->RT_VALOR
			Endif
			*/
			// FR - INSS Baixa do mes atual
			if TRDEXC->RT_VERBA$'899'
				FRINSSBA:=FRINSSBA+TRDEXC->RT_VALOR
			Endif
			
			// FR - FGTS do mes atual
			if TRDEXC->RT_VERBA$'752'
				FRFGTSAtual:=FRFGTSAtual+TRDEXC->RT_VALOR
			Endif
			/*
			// FR - FGTS Baixa do mes atual
			if TRDEXC->RT_VERBA$'859'
			BFGTSAtualFR:=BFGTSAtualFR+TRDEXC->RT_VALOR
			Endif
			*/
			// FR - FGTS Baixa do mes atual
			if TRDEXC->RT_VERBA$'758'
				FGTSAtualBFR:=FGTSAtualBFR+TRDEXC->RT_VALOR
			Endif
			
			// FR - FGTS Baixa do mes atual
			if TRDEXC->RT_VERBA$'900'
				FRFGTSBA:=FRFGTSBA+TRDEXC->RT_VALOR
			Endif
			
			// 13 Salario - INSS do mes atual
			if TRDEXC->RT_VERBA$'754'
				SINSSAtual:=SINSSAtual+TRDEXC->RT_VALOR
			Endif
			
			// 13 Salario - INSS Baixa do mes atual
			if TRDEXC->RT_VERBA$'903*865'
				BINSSAtual:=BINSSAtual+TRDEXC->RT_VALOR
			Endif
			
			// 13 Sal - FGTS do mes atual
			if TRDEXC->RT_VERBA$'755'
				SFGTSAtual:=SFGTSAtual+TRDEXC->RT_VALOR
			Endif
			
			// 13 Sal - FGTS Baixa do mes atual
			if TRDEXC->RT_VERBA$'904*866'
				BFGTSAtual:=BFGTSAtual+TRDEXC->RT_VALOR
			Endif
	
/******************************** Calcula Avos de Provisão 13º/Ferias *********************************/	
			//FR - Avos
			//IF TRDEXC->RT_TIPPROV="1".AND.TRDEXC->RT_DATABAS<>CTOD("  /  /  ") 
						                           
			 if TRDEXC->RT_DATACAL=DTOS(MV_PAR07).and.TRDEXC->RT_DATABAS # "        "
				If TRDEXC->RT_TIPPROV $ "1/2" //=="3"
			        SAvos:=TRDEXC->RT_AVOS13S
			    			 
			      IF TRDEXC->RA_SINDICA='30'.and.TRDEXC->RT_DATACAL=DTOS(MV_PAR07).and.!empty(TRDEXC->RT_DATABAS)//<>"  "
				     FRAvos:=((TRDEXC->RT_DFERVEN+TRDEXC->RT_DFERPRO-TRDEXC->RT_DFERANT-TRDEXC->RT_DFALVEN-TRDEXC->RT_DFALPRO)/1.5)
			
			 		 If FRAvos < 0
			            FRAvos := 0
			   		 Else 
			   		    FrAvos := FrAvos	   			   		   	      
			         Endif
			      Else
			 	     FRAvos:=((TRDEXC->RT_DFERVEN+TRDEXC->RT_DFERPRO+TRDEXC->RT_DFERANT - TRDEXC->RT_DFALVEN-TRDEXC->RT_DFALPRO)/2.5)

			 		 If FRAvos < 0
			            FRAvos := 0
			   		 Else 
			   		    FrAvos := FrAvos	   			   		   	      
			         Endif
			 
			  	      
			  	  Endif
			  	Endif	  
			 Endif 
	    Endif	              
                         	    		
		dbselectarea("TRDEXC")
		dbskip()
		
	Enddo
	
	
	// 13 Salario - Zerar Verbas de Baixas
	IF FRBaixas<>0.and.SBaixas<>0
		SProvisao	:=(BProvAtual+BINSSAtual+BFGTSAtual)-(SProvant+SINSSAnt+SFGTSAnt)
		SINSS		:=BINSSAtual-SINSSAnt
		SFGTS		:=BFGTSAtual-SFGTSAnt
					
	// 13 Salario - Zerar Verbas de Baixas
	ELSE
	  IF SBaixas<>0
	     SProvisao	:=(BProvAtual+BINSSAtual+BFGTSAtual)-(SProvant+SINSSAnt+SFGTSAnt)
		 SINSS		:=BINSSAtual-SINSSAnt
    	 SFGTS		:=BFGTSAtual-SFGTSAnt
   	 
	//FR - Zerar Baixas Ferias
	ELSE
	  IF SAtualFRB<>0.and.SBaixas<>0
	     FRProvisao	:=(SAtualFRB+INSSAtualBFR+FGTSAtualBFR)-(FRSdoAnt+FRINSSAnt+FRFGTSAnt)
		 FRINSS		:=INSSAtualBFR-FRINSSAnt
		 FRFGTS	    :=FGTSAtualBFR-FRFGTSAnt
		 SProvisao	    :=SProvAtual-SProvant
		 SINSS		    :=SINSSAtual-SINSSAnt
		 SFGTS	        :=SFGTSAtual-SFGTSAnt
				
	//FR - Zerar Baixas Ferias
	  ELSE
		IF SAtualBas<>0.and.FRProvAtual<>0
	       FRProvisao	:=(FRProvAtual+SAtualBas)-FRProvant
		   FRINSS		:=(FRINSSAtual+INSSAtualBFR)-FRINSSAnt
		   FRFGTS	    :=(FRFGTSAtual+FGTSAtualBFR)-FRFGTSAnt
		   SProvisao	    :=SProvAtual-SProvant
		   SINSS		    :=SINSSAtual-SINSSAnt
		   SFGTS	        :=SFGTSAtual-SFGTSAnt
					
	//FR - Zerar Baixas Ferias
	   ELSE
		 IF SAtualFRB<>0
			FRProvisao	:=(SAtualFRB+INSSAtualBFR+FGTSAtualBFR)-(FRSdoAnt+FRINSSAnt+FRFGTSAnt)
			FRINSS		:=INSSAtualBFR-FRINSSAnt
			FRFGTS	    :=FGTSAtualBFR-FRFGTSAnt
						
	// FR - Zerar Baixas Ferias
		ELSE
		  IF SdoAtualBFR<>0
		     FRProvisao	    :=SdoAtualBFR-FRSdoAnt
		     FRINSS		    :=FRINSSBA-FRINSSAnt
		     FRFGTS	        :=FRFGTSBA-FRFGTSAnt
	
							
	// FR - Zerar Baixas Ferias
		ELSE
		  IF BdoSAtualFR<>0
		     FRProvisao     :=BdoSAtualFR-FRSdoAnt
		  							
		ELSE

	      IF Left(Dtos(MV_PAR07),6)>Left(Dtos(_dadmissa),6)
			 FRProvisao	:=FRProvAtual-FRProvant
			 SProvisao	:=SProvAtual-SProvant
			 FRINSS		:=FRINSSAtual-FRINSSAnt
			 SINSS		:=SINSSAtual-SINSSAnt
			 FRFGTS	    :=FRFGTSAtual-FRFGTSAnt
			 SFGTS		:=SFGTSAtual-SFGTSAnt
	 	ELSE
		    FRProvisao	:=FRProvAtual
			SProvisao	:=SProvAtual
			FRINSS		:=FRINSSAtual
			SINSS		:=SINSSAtual
			FRFGTS		:=FRFGTSAtual
			SFGTS		:=SFGTSAtual 
			
		       ENDIF																		
		    ENDIF
		  ENDIF
		ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDIF
	
	
	//	IF 	FRProvisao+SProvisao+FRINSS+SINSS+FRFGTS+SFGTS<>0 //Nao imprime saldo 0 (zero)
	
	RecLock("TRB",.T.)
	TRB->FILIAL			:= _cFilial
	TRB->MAT	   		:= _cMat
	TRB->NOME	   		:= _cNome
	TRB->SITUACAO  		:= _cSituacao
	TRB->SINDICATO		:= _cSindicato
	TRB->DESC	   		:= _cDescricao
	TRB->CC	 	  		:= _cCC
	TRB->ASALDOANT		:= FRSdoAnt
	TRB->APROVISAO   	:= FRProvisao
	TRB->AINSS       	:= FRINSS
	TRB->AFGTS    		:= FRFGTS
	TRB->ABAIXAS 		:= FRBaixas
	TRB->ASALDOATU   	:= FRSdoAtual
	TRB->AAVOS       	:= FRAvos
	TRB->BSALDOANT		:= AnteriorSdo
	TRB->BPROVISAO		:= SProvisao
	TRB->BINSS			:= SINSS
	TRB->BFGTS			:= SFGTS
	TRB->BBAIXAS  		:= SBaixas
	TRB->BSALDOATU		:= SAtual
	TRB->BAVOS			:= SAvos 
	    
		
       if _ddemissa<=STOD(TRDEXC->RT_DATACAL)
		   SAvos:=0	
	   Endif	    
	 
	MsUnlock()
	
	//	Endif
	
	dbselectarea("TRDEXC")
	
Enddo

return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fPerg ³ Autor ³Adriana Sarro/Adriano Dias   Data ³15/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Grava as Perguntas utilizadas no Programa no SX1            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fPerg()

Local aRegs     := {}

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³            Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         		DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03   		Def03    	DefSpa3    DefEng3  Cnt03  Var04  		Def04     	DefSpa4    	DefEng4  	Cnt04  		Var05  			Def05         DefSpa5	DefEng5   Cnt05  XF3 GrgSxg  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aAdd(aRegs,{_CPERG,'01' ,'Filial De          ?',''				 ,''			 ,'mv_ch1','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,'         ','           ' ,''   	 ,''   	  ,''	 ,'           ','       	',''  		 ,''  	  ,''       	 ,'' 			,''			  ,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{_CPERG,'02' ,'Filial Ate         ?',''				 ,''			 ,'mv_ch2','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,REPLICATE('9',02),''   ,'        	   ',''   	 ,''  	  ,''	 ,'         ','           ' ,''   	 ,''      ,''	 ,'           ','      		',''  		 ,'' 	  ,''       	 ,'' 			,''			  ,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{_CPERG,'03' ,'Centro de Custo De ?',''				 ,''			 ,'mv_ch3','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,'         ','           ' ,''  	 ,''      ,''	 ,'           ','       	',''  		 ,''  	  ,''       	 ,''			,''			  ,'' 	   ,''		 ,''	,'CTT',''})
aAdd(aRegs,{_CPERG,'04' ,'Centro de Custo Ate?',''				 ,''			 ,'mv_ch4','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par04','               '  ,''		 ,''	 ,REPLICATE('Z',09),''   ,'        	   ',''		 ,''  	  ,''	 ,'         ','           ' ,''   	 ,''      ,''	 ,'           ','    	   	',''  		 ,''  	  ,''       	 ,''			,''			  ,'' 	   ,''		 ,''	,'CTT',''})
aAdd(aRegs,{_CPERG,'05' ,'Matricula De       ?',''				 ,''			 ,'mv_ch5','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par05','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,'         ','           ' ,''   	 ,''      ,''	 ,'           ','       	',''  		 ,''  	  ,''       	 ,''			,''			  ,'' 	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{_CPERG,'06' ,'Matricula Ate      ?',''				 ,''			 ,'mv_ch6','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par06','               '  ,''		 ,''	 ,REPLICATE('Z',06),''   ,'        	   ',''    	 ,''  	  ,''	 ,'         ','           ' ,''   	 ,''      ,''	 ,'           ','       	','' 		 ,''  	  ,''       	 ,''			,''		   	  ,''  	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{_CPERG,'07' ,'Data do calculo    ?',''				 ,''			 ,'mv_ch7','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par07','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,'         ','           ' ,''   	 ,''      ,''	 ,'           ',' 		    ',''  		 ,''  	  ,''         	 ,''  			,''		   	  ,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'08' ,'Tipo de Saida      ?',''				 ,''			 ,'mv_ch8','C'  ,01     ,0      ,1     ,'C','                                ','mv_par08','13Sal-Sintético'  ,''		 ,''	 ,'                ',''   ,'Férias-Sintético',''   	 ,''   	  ,''	 ,'         ','13Sal-Analítico' ,''   	 ,''   	  ,''	 ,' 		  ','Férias-Analítico',''  		 ,''  	  ,''            ,'           '	,'           ',''  	   ,''		 ,''	,'   ',''})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as Perguntas no SX1                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg(aRegs,_CPERG)

Return NIL

//         1         2         3         4         5         6         7         8         9        100                110       120       130       140       150       160       170      180       190        200       210      220
//012345679012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123467890
//XX  XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  X  XXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX 999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99
//Fil Mat     Nome                                     Sit Cod. C.Custo           Descricao C.Custo       Fer SdoAnt    Fer Provisao        Fer INSS        Fer FGTS      Fer Baixas    Fer SdoAtual        Fer Avos


//         1         2         3         4         5         6         7         8         9        100                110       120       130       140       150       160       170      180       190        200       210      220
//012345679012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123467890
//XX  XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  X  XXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX 999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99
//Fil Mat     Nome                                     Sit Cod. C.Custo           Descricao C.Custo     13Sal SdoAnt  13Sal Provisao      13Sal INSS      13Sal FGTS    13Sal Baixas  13Sal SdoAtual      13Sal Avos



