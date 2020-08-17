#Include "CTBR260X.ch"
#Include "PROTHEUS.Ch"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_COLUNA1       	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_COLUNA2       	8
#DEFINE 	COL_SEPARA5			9 
#DEFINE 	COL_COLUNA3       	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_COLUNA4   		12
#DEFINE 	COL_SEPARA7			13                                                                                       
#DEFINE 	COL_COLUNA5   		14
#DEFINE 	COL_SEPARA8			15
#DEFINE 	COL_COLUNA6   		16
#DEFINE 	COL_SEPARA9			17
#DEFINE 	COL_TOTAL  			18
#DEFINE 	COL_SEPARA10		19               


//Tradução PTG


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr260	³ Autor ³ Simone Mie Sato   	³ Data ³ 02.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de Saldos de Contas 6 meses    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr260()                               			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctbr260x()                

Private Titulo		:= "" 
Private NomeProg	:= "CTBR260x"
Private _eol		:= Chr(13)+chr(10)

/*
If FindFunction("TRepInUse") .And. TRepInUse() 
	CTBR260R4()
Else
	CTBR260R3()
EndIf
*/
CTBR260R3()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR260R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 31/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de Saldos de Contas 6 meses - R4  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR260R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBR260R4() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()      

If !Empty( oReport:uParam )
	Pergunte( oReport:uParam, .F. )
EndIf	

oReport :PrintDialog()      

Return()                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 31/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef() 
local aArea	   		:= GetArea()   
Local cREPORT		:= "CTBR260"
Local cSayItem		:= CtbSayApro("CTD")
Local cTITULO		:= OemToAnsi(STR0003)//"Comparativo  de Contas Contabeis ate 6 meses"
Local cDESC			:= OemToAnsi(STR0001)+OemtoAnsi(STR0002)	//"Este programa ira imprimir o Comparativo de Contas Contabeis de 2 ate "
																//" 6 meses.  Os valores sao ref. a movimentacao do periodo solicitado. "
Local cPerg	   		:= PADR("CTR260",LEN(SX1->X1_GRUPO))
Local aTamConta		:= TAMSX3("CT1_CONTA")    
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aTamDesc		:= {30}  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport	:= TReport():New( cReport,cTITULO,cPERG, { |oReport| ReportPrint( oReport ) }, cDESC )
oReport:SetLandScape(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1  := TRSection():New( oReport, STR0029, {"cArqTmp","CT1"},, .F., .F. )	//	"Conta Contábil"
TRCell():New( oSection1, "CONTA"   , ,Substr(STR0004,002,10) /*Titulo*/,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "DESCCTA" , ,Substr(STR0004,032,30) /*Titulo*/,/*Picture*/,aTamDesc[1] /*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "COLUNA1" , ,                       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA2" , ,                       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA3" , ,                       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA4" , ,                       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA5" , ,                       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA6" , ,                       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNAT" , ,Substr(STR0028,006,015)/*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")

oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText(STR0011) //	"T O T A I S  D O  P E R I O D O: "

Return(oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 28/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )  

Local oSection1 	:= oReport:Section(1)    

Local oTotCol1, oTotCol2, oTotCol3, oTotCol4, oTotCol5, oTotCol6, oTotColTot
Local oTotGrp1,	oTotGrp2, oTotGrp3, oTotGrp4, oTotGrp5, oTotGrp6, oTotGrpTot, oBreakGrp

Local aCtbMoeda		:= {}
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda            
Local cTipoAnt      := ""
Local cString		:= "CT1"
Local lRet			:= .T.
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 		:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par17==1,.T.,.F.)
Local lPula			:= Iif(mv_par16==1,.T.,.F.) 
Local lNormal		:= Iif(mv_par18==1,.T.,.F.)
Local lQbGrupo		:= Iif(mv_par11==1 .and. Empty(mv_par06),.T.,.F.) // Não imprime grupo quando se utiliza livro
Local nDecimais
Local nDivide		:= 1
Local cSegmento		:= mv_par12
Local cSegAte   	:= mv_par20
Local cSegIni		:= mv_par13
Local cSegFim		:= mv_par14
Local cFiltSegm		:= mv_par15
Local nDigitAte		:= 0
Local lImpAntLP		:= Iif(mv_par21 == 1,.T.,.F.)
Local dDataLP		:= mv_par22
Local aMeses		:= {}          
Local aPeriodos
Local nMeses		:= 1
Local nCont			:= 0
Local nDigitos		:= 0
Local nVezes		:= 0
Local nPos			:= 0
Local lVlrZerado	:= Iif(mv_par07 == 1,.T.,.F.)
Local lImpSint		:= Iif(mv_par05 = 2,.F.,.T.)
Local lSinalMov		:= CtbSinalMov()
Local cHeader 		:= ""
Local cTpComp		:= If( mv_par23 == 1,"M","S" )	//	Comparativo : "M"ovimento ou "S"aldo Acumulado
Local cFilter		:= ""
Local nTotGer 		:= 0
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local cFilUser		:= ""
Local cEspaco
Local bCond
                                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par06)
	lRet := .F. 
	return(lRet)
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par19 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par19 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par19 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
	If Empty(aCtbMoeda[1])                       
    	Help(" ",1,"NOMOEDA")
    	lRet := .F.
    	Return(lRet)
	Endif
EndIf

cDescMoeda 	:= Alltrim(aCtbMoeda[2])

If !Empty(aCtbMoeda[6])
	cDescMoeda += OemToAnsi(STR0007) + aCtbMoeda[6]			// Indica o divisor
EndIf	

nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

aPeriodos := ctbPeriodos(mv_par08, mv_par01, mv_par02, .T., .F.)

For nCont := 1 to len(aPeriodos)       
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
		If nMeses <= 6
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
			nMeses += 1           					
		EndIf
	EndIf
Next                                                                   

If nMeses == 1
	cMensagem := OemToAnsi(STR0024)
	cMensagem += OemToAnsi(STR0025)
	MsgAlert(cMensagem)
	Return()
ElseIf nMeses > 7//Se o periodo solicitado for maior que 6 meses, eh exibido uma mensagem
	cMensagem := OemToAnsi(STR0022)+OemToAnsi(STR0023)//que sera impresso somente os 6 meses		
	MsgAlert(cMensagem)
EndIf                                                      

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
	cCodMasc	:= ""
Else
	cCodmasc	:= aSetOfBook[2]
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]


// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)                
    nDigitAte	:= CtbRelDig(cSegAte,cMascara) 	
EndIf

If !Empty(cSegmento)
	If Empty(mv_par06)
		Help("",1,"CTN_CODIGO")
		Return()
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cCodMasc)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(VAL(cSegmento),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	Else
		Help("",1,"CTM_CODIGO")
		Return()
	EndIf	
EndIf


// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 2
	cHeader := "SLD"			/// Indica que deverá obter o saldo na 1ª coluna (Comparativo de Saldo Acumulado)
Endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par05 == 1
	Titulo:=	OemToAnsi(STR0008)	//"COMPARATIVO SINTETICO DE "
ElseIf mv_par05 == 2
	Titulo:=	OemToAnsi(STR0005)	//"COMPARATIVO ANALITICO DE "
ElseIf mv_par05 == 3
	Titulo:=	OemToAnsi(STR0012)	//"COMPARATIVO DE "
EndIf

Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0006) + Dtoc(aMeses[Len(aMeses)][3]) + ;
				OemToAnsi(STR0007) + cDescMoeda

If mv_par10 > "1"			
	Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
Endif                     
                
// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 2
	Titulo += " - "+STR0026
Endif

oReport:SetPageNumber( mv_par09 )
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )

DbSelectArea("CT1")
cFilUser := oSection1:GetAdvplExp("CT1")

If Empty(cFilUser)
	cFilUser := ".T."
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerComp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
				.F.,.F.,mv_par11,cHeader,lImpAntLP,dDataLP,nDivide,cTpComp,.F.,,.T.,aMeses,lVlrZerado,,,lImpSint,cString,cFilUser)},;
				OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003))  				//"Comparativo de Contas Contabeis com Filiais"
If Select("cArqTmp") == 0
	Return()
EndIf		

oSection1:OnPrintLine( {|| ( IIf( lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")), oReport:skipLine(),NIL),;
								 cTipoAnt := cArqTmp->TIPOCONTA;
							)  })       
							           
If mv_par05 == 1					// So imprime Sinteticas
	cFilter := "cArqTmp->TIPOCONTA  <>  '2'  "
	If !lVlrZerado
		cFilter += " .AND. (cArqTmp->COLUNA1 <> 0 .OR.  cArqTmp->COLUNA2 <> 0 .OR.  cArqTmp->COLUNA3 <> 0"
		cFilter += " .OR.   cArqTmp->COLUNA4 <> 0 .OR.  cArqTmp->COLUNA5 <> 0 .OR.  cArqTmp->COLUNA6 <> 0)"
	EndIf
ElseIf mv_par05 == 2				// So imprime Analiticas
	cFilter := "cArqTmp->TIPOCONTA  <>  '1'  "
	If !lVlrZerado
		cFilter += " .AND. (cArqTmp->COLUNA1 <> 0 .OR. cArqTmp->COLUNA2 <> 0 .OR.  cArqTmp->COLUNA3 <> 0"
  		cFilter += " .OR.   cArqTmp->COLUNA4 <> 0 .OR. cArqTmp->COLUNA5 <> 0 .OR.  cArqTmp->COLUNA6 <> 0)"
	EndIf	
EndIf

If !lVlrZerado
	If Empty(cFilter)
		cFilter := "cArqTmp->COLUNA1 <> 0 .OR. cArqTmp->COLUNA2 <> 0 .OR. cArqTmp->COLUNA3 <> 0 .OR. "
		cFilter += "cArqTmp->COLUNA4 <> 0 .OR. cArqTmp->COLUNA5 <> 0 .OR. cArqTmp->COLUNA6 <> 0"
	Endif
EndIf

oSection1:SetFilter( cFilter )

For nCont := 1 to Len(aMeses)
	cColVal := "COLUNA"+Alltrim(Str(nCont))
	
	// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
	If mv_par23 == 2	/// SE FOR ACUMULADO É O SALDO ATE A DATA FINAL
		oSection1:Cell(cColVal):SetTitle(Substr(STR0004,68,14)+Alltrim(Str(nCont))+CRLF+STR0027+"-"+DTOC(aMeses[nCont][3]))
	Else
		oSection1:Cell(cColVal):SetTitle(Substr(STR0004,68,14)+Alltrim(Str(nCont))+CRLF+DTOC(aMeses[nCont][2])+"-"+DTOC(aMeses[nCont][3]))
	Endif
Next

For nCont:= Len(aMeses)+1 to 6
	cColVal := "COLUNA"+Alltrim(Str(nCont))
	oSection1:Cell(cColVal):SetTitle(	Substr(STR0004,68,14)+Alltrim(Str(nCont))	)
Next


oSection1:Cell("CONTA"  ):SetBlock( {|| IF( cArqTmp->TIPOCONTA == "2" .And. mv_par05 <> 2,cEspaco:=SPACE(02),cEspaco:="" ),	/*Fazer um recuo nas contas analíticas em relação à sintética*/;
                                        IF( lNormal,	cEspaco + EntidadeCTB(cArqTmp->CONTA,0,0,70,.F.,cMascara,,,,,,.F.),	/*Se Imprime Codigo Normal da Conta*/;
                                            			IF( cArqTmp->TIPOCONTA == "1",	AllTrim(cArqTmp->CONTA),	cEspaco + AllTrim(cArqTmp->CTARES) ) ) } )	//Conta Sintética
oSection1:Cell("DESCCTA"):SetBlock( { || (cArqTMp->DESCCTA) } )
oSection1:Cell("COLUNA1"):SetBlock( { || ValorCTB(cArqTmp->COLUNA1,,,aTamVal[1],nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero,.F.) } )
oSection1:Cell("COLUNA2"):SetBlock( { || ValorCTB(cArqTmp->COLUNA2,,,aTamVal[1],nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero,.F.) } )
oSection1:Cell("COLUNA3"):SetBlock( { || ValorCTB(cArqTmp->COLUNA3,,,aTamVal[1],nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero,.F.) } )
oSection1:Cell("COLUNA4"):SetBlock( { || ValorCTB(cArqTmp->COLUNA4,,,aTamVal[1],nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero,.F.) } )
oSection1:Cell("COLUNA5"):SetBlock( { || ValorCTB(cArqTmp->COLUNA5,,,aTamVal[1],nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero,.F.) } )
oSection1:Cell("COLUNA6"):SetBlock( { || ValorCTB(cArqTmp->COLUNA6,,,aTamVal[1],nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero,.F.) } )

// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 1
	oSection1:Cell("COLUNAT"):SetBlock( { || ValorCTB(cArqTmp->(COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6),,,aTamVal[1],nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero,.F.) } )
Else
	oSection1:Cell("COLUNAT"):Disable()
EndIf


bCond := {|| Iif( cArqTmp->TIPOCONTA="1"/*Conta Sintetica*/, IF( mv_par05 <> 1	/*Analiticas ou ambas*/,;
                                                                 .F.,;
                                                                 IF(cArqTmp->NIVEL1 /*Maior Conta superiora*/,.T.,.F.) ),;
                                                             .T. ) }

// Quebra por Grupo              
If lQbGrupo
   
	//Totais do Grupo
	oBreakGrp := TRBreak():New(oSection1, { || cArqTmp->GRUPO },{|| STR0016+" "+ RTrim( Upper(AllTrim(cGrupo) )) + " )" },,,.F.)	//	"T O T A I S  D O  G R U P O ("
	oBreakGrp:OnBreak( { |x| cGrupo := x } )
                                              
	oTotGrp1 := TRFunction():New(oSection1:Cell("COLUNA1"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA1, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp2 := TRFunction():New(oSection1:Cell("COLUNA2"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA2, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp3 := TRFunction():New(oSection1:Cell("COLUNA3"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA3, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp4 := TRFunction():New(oSection1:Cell("COLUNA4"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA4, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp5 := TRFunction():New(oSection1:Cell("COLUNA5"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA5, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp6 := TRFunction():New(oSection1:Cell("COLUNA6"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA6, 0 ) },.F.,.F.,.F.,oSection1)
	

	TRFunction():New(oSection1:Cell("COLUNA1"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp1:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA2"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp2:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA3"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp3:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA4"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp4:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA5"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp5:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA6"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp6:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )


	// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
	If mv_par23 == 1
		oTotGrpTot := TRFunction():New(oSection1:Cell("COLUNAT"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->(COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6), 0 ) },.F.,.F.,.F.,oSection1)

		TRFunction():New(oSection1:Cell("COLUNAT"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
    	{ || ValorCTB(oTotGrpTot:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

		oTotGrpTot:Disable()
	EndIf

	oTotGrp1:Disable()
	oTotGrp2:Disable()
	oTotGrp3:Disable()
	oTotGrp4:Disable()
	oTotGrp5:Disable()
	oTotGrp6:Disable()
EndIf


// Total
oTotCol1 := TRFunction():New(oSection1:Cell("COLUNA1"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA1, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol2 := TRFunction():New(oSection1:Cell("COLUNA2"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA2, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol3 := TRFunction():New(oSection1:Cell("COLUNA3"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA3, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol4 := TRFunction():New(oSection1:Cell("COLUNA4"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA4, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol5 := TRFunction():New(oSection1:Cell("COLUNA5"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA5, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol6 := TRFunction():New(oSection1:Cell("COLUNA6"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA6, 0 ) },.F.,.T.,.F.,oSection1)

// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 1
	oTotColTot := TRFunction():New(oSection1:Cell("COLUNAT"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                                   { || If( Eval(bCond), cArqTmp->(COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6), 0 ) },.F.,.T.,.F.,oSection1)
EndIf
                                                                      
TRFunction():New(oSection1:Cell("COLUNA1"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol1:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA2"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol2:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA3"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol3:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA4"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol4:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA5"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol5:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA6"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol6:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 1
	TRFunction():New(oSection1:Cell("COLUNAT"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
    { || ValorCTB(oTotColTot:GetValue(),,,aTamVal[1],nDecimais,lSinalMov,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )
EndIf

oTotCol1:Disable()
oTotCol2:Disable()
oTotCol3:Disable()
oTotCol4:Disable()
oTotCol5:Disable()
oTotCol6:Disable()

// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 1
	oTotColTot:Disable()
EndIf
                     
oReport:SetTotalInLine(.F.)	
oReport:SetTotalText(STR0011)	//	"T O T A I S  D O  P E R I O D O: "

oSection1:Print()

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	

Return()
/*
-------------------------------------------------------- RELEASE 3 -------------------------------------------------------------
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr260r3|Autor  ³ Simone Mie Sato   	³ Data ³ 02.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de Saldos de Contas 6 meses    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr260()                               			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctbr260R3()

Local aSetOfBook
Local aCtbMoeda		:= {}
LOCAL cDesc1 		:= OemToAnsi(STR0001)	//"Este programa ira imprimir o Comparativo de Contas Contabeis de 2 ate "
LOCAL cDesc2 		:= OemToansi(STR0002)  //" 6 meses.  Os valores sao ref. a movimentacao do periodo solicitado. "
Local cDesc3		:= ""

LOCAL wnrel
LOCAL cString		:= "CT1"
Local titulo 		:= OemToAnsi(STR0003) 	//"Comparativo  de Contas Contabeis ate 6 meses"
Local lRet			:= .T.
Local nDivide		:= 1
Local lAtSlBase		:= Iif(GETMV("MV_ATUSAL")== "S",.T.,.F.)

PRIVATE Tamanho		:="G"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= PADR("CTR260",LEN(SX1->X1_GRUPO))
PRIVATE aReturn 	:= { OemToAnsi(STR0013), 1,OemToAnsi(STR0014), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR260x"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return()
EndIf

li 		:= 80
m_pag	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra tela de aviso - processar exclusivo					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMensagem := OemToAnsi(STR0017)+chr(13)  		//"Caso nao atualize os saldos  basicos  na"
cMensagem += OemToAnsi(STR0018)+chr(13)  		//"digitacao dos lancamentos (MV_ATUSAL='N'),"
cMensagem += OemToAnsi(STR0019)+chr(13)  		//"rodar a rotina de atualizacao de saldos "
cMensagem += OemToAnsi(STR0020)+chr(13)  		//"para todas as filiais solicitadas nesse "
cMensagem += OemToAnsi(STR0021)+chr(13)  		//"relatorio."

IF !lAtSlBase
	IF !MsgYesNo(cMensagem,OemToAnsi(STR0009))	//"ATEN€ŽO"
		Return()
	Endif
EndIf

Pergunte("CTR260",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ mv_par01				// Data Inicial                  	  		  ³
//³ mv_par02				// Data Final                        		  ³
//³ mv_par03				// Conta Inicial                         	  ³
//³ mv_par04				// Conta Final  							  ³
//³ mv_par05				// Imprime Contas: Sintet/Analit/Ambas   	  ³
//³ mv_par06				// Set Of Books				    		      ³
//³ mv_par07				// Saldos Zerados?			     		      ³
//³ mv_par08				// Moeda?          			     		      ³
//³ mv_par09				// Pagina Inicial  		     		    	  ³
//³ mv_par10				// Saldos? Reais / Orcados	/Gerenciais   	  ³
//³ mv_par11				// Quebra por Grupo Contabil?		    	  ³
//³ mv_par12				// Filtra Segmento?					    	  ³
//³ mv_par13				// Conteudo Inicial Segmento?		   		  ³
//³ mv_par14				// Conteudo Final Segmento?		    		  ³
//³ mv_par15				// Conteudo Contido em?				    	  ³
//³ mv_par16				// Salta linha sintetica ?			    	  ³
//³ mv_par17				// Imprime valor 0.00    ?			    	  ³
//³ mv_par18				// Imprimir Codigo? Normal / Reduzido  		  ³
//³ mv_par19				// Divide por ?                   			  ³
//³ mv_par20				// Imprimir Ate o segmento?			   		  ³
//³ mv_par21				// Posicao Ant. L/P? Sim / Nao         		  ³
//³ mv_par22				// Data Lucros/Perdas?                 		  ³
//³ mv_par23				// Tipo de Comparativo?(Movimento/Acumulado)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel	:= "CTBR260x"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
titulo := alltrim(titulo)+" "
If nLastKey == 27
	Set Filter To
	Return()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par06)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par19 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par19 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par19 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif    

If !lRet
	Set Filter To
	Return()
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return()
Endif

RptStatus({|lEnd| CTR260Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide,titulo)})

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR260IMP ³ Autor ³ Simone Mie Sato       ³ Data ³ 02.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio  									      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR260Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpA1   - Matriz ref. Config. Relatorio                    ³±±
±±³          ³ ExpA2   - Matriz ref. a moeda                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR260Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide,titulo)

Local aColunas		:= {}
LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 220
Local cabec1   		:= ""
Local cabec2   		:= ""
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda

Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 		:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par17==1,.T.,.F.)
Local lPula			:= Iif(mv_par16==1,.T.,.F.) 
Local lNormal		:= Iif(mv_par18==1,.T.,.F.)
Local nDecimais
Local aTotCol		:= {0,0,0,0,0,0}
Local aTotGrp		:= {0,0,0,0,0,0}
Local cSegmento		:= mv_par12
Local cSegAte   	:= mv_par20
Local cSegIni		:= mv_par13
Local cSegFim		:= mv_par14
Local cFiltSegm		:= mv_par15
Local nDigitAte		:= 0
Local lImpAntLP		:= Iif(mv_par21 == 1,.T.,.F.)
Local dDataLP		:= mv_par22
Local aMeses		:= {}          
Local nTotLinha	:= 0
Local nTotGeral	:= 0
Local aPeriodos
Local nMeses		:= 1
Local nCont			:= 0
Local nDigitos		:= 0
Local nVezes		:= 0
Local nPos			:= 0
Local lVlrZerado	:= Iif(mv_par07 == 1,.T.,.F.)
Local lImpSint		:= Iif(mv_par05 = 2,.F.,.T.)
Local lSinalMov		:= CtbSinalMov()
Local cHeader 		:= ""
Local cTpComp		:= If( mv_par23 == 1,"M","S" )	//	Comparativo : "M"ovimento ou "S"aldo Acumulado

cDescMoeda 	:= Alltrim(aCtbMoeda[2])

If !Empty(aCtbMoeda[6])
	cDescMoeda += OemToAnsi(STR0007) + aCtbMoeda[6]			// Indica o divisor
EndIf	

nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

aPeriodos := ctbPeriodos(mv_par08, mv_par01, mv_par02, .T., .F.)

For nCont := 1 to len(aPeriodos)       
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
		If nMeses <= 6
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
			nMeses += 1           					
		EndIf
	EndIf
Next                                                                   

If nMeses == 1
	cMensagem := OemToAnsi(STR0024)
	cMensagem += OemToAnsi(STR0025)
	MsgAlert(cMensagem)
	Return()
ElseIf nMeses > 7//Se o periodo solicitado for maior que 6 meses, eh exibido uma mensagem
	cMensagem := OemToAnsi(STR0022)+OemToAnsi(STR0023)//que sera impresso somente os 6 meses		
	MsgAlert(cMensagem)
EndIf                                                      

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
	cCodMasc	:= ""
Else
	cCodmasc	:= aSetOfBook[2]
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aLLTRIM(Upper(titulo)) == alltrim(upper(STR0003))
	IF mv_par05 == 1
		Titulo:=	OemToAnsi(STR0008)	//"COMPARATIVO SINTETICO DE "
	ElseIf mv_par05 == 2
		Titulo:=	OemToAnsi(STR0005)	//"COMPARATIVO ANALITICO DE "
	ElseIf mv_par05 == 3
		Titulo:=	OemToAnsi(STR0012)	//"COMPARATIVO DE "
	EndIf
EndIf

Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0006) + Dtoc(aMeses[Len(aMeses)][3]) + ;
				OemToAnsi(STR0007) + cDescMoeda

If mv_par10 > "1"			
	Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
Endif                     

If mv_par23 == 2
	Titulo += " - "+STR0026
Endif

cabec1 := OemToAnsi(STR0004)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   MOV PERIODO 01   |   MOV PERIODO 02   |   MOV PERIODO 03   |   MOV PERIODO 04   |   MOV PERIODO 05   |   MOV PERIODO 06   |   TOTAL GERAL     |"
If mv_par23 <> 2
	cabec1 += OemToAnsi(STR0028)
Else
	cabec1	+= "                       |"	
Endif
cabec2 := "|                             |                                |" 
For nCont := 1 to Len(aMeses)
	If mv_par23 == 2	/// SE FOR ACUMULADO É O SALDO ATE A DATA FINAL
		If Len(DTOC(aMeses[nCont][2])) == 10  //Se utilizar o ano com 4 digitos		
			cabec2 += "   "+STR0027
			cabec2+="-"+DTOC(aMeses[nCont][3]) +SPACE(4)+"|"						
		Else
			cabec2 += "   "+STR0027
			cabec2+="-"+DTOC(aMeses[nCont][3]) +SPACE(6)+"|"								
		EndIf
	Else      
		If Len(DTOC(aMeses[nCont][2])) == 10  //Se utilizar o ano com 4 digitos	
			cabec2 += DTOC(aMeses[nCont][2])		
			cabec2+="-"+DTOC(aMeses[nCont][3]) +"|"			
		Else
			cabec2 += SPACE(2)+DTOC(aMeses[nCont][2])			
			cabec2+="-"+DTOC(aMeses[nCont][3]) +SPACE(2)+"|"				
		EndIf
	Endif
Next

For nCont:= Len(aMeses) to 6
	If nCont < 6
		cabec2+=SPACE(21)+"|"
	ElseIf nCont == 6
		cabec2 += SPACE(23)+"|"
	EndIf
Next         
                                                                                                    
aColunas := { 000, 001, 030, 032, 063, 065, 085, 087, 107, 109, 129, 131, 151, 153, 173, 175, 195, 197, 219}

m_pag := mv_par09
// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)                
    nDigitAte	:= CtbRelDig(cSegAte,cMascara) 	
EndIf

If !Empty(cSegmento)
	If Empty(mv_par06)
		Help("",1,"CTN_CODIGO")
		Return()
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cCodMasc)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(VAL(cSegmento),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	Else
		Help("",1,"CTM_CODIGO")
		Return()
	EndIf	
EndIf
        
If mv_par23 == 2
	cHeader := "SLD"			/// Indica que deverá obter o saldo na 1ª coluna (Comparativo de Saldo Acumulado)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerComp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
				.F.,.F.,mv_par11,cHeader,lImpAntLP,dDataLP,nDivide,cTpComp,.F.,,.T.,aMeses,lVlrZerado,,,lImpSint,cString,aReturn[7])},;
				OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003))  				//"Comparativo de Contas Contabeis com Filiais"
If Select("cArqTmp") == 0
	Return()
EndIf		
				
dbSelectArea("cArqTmp")
//dbSetOrder(1)
dbGoTop()        
//WWW

CTBR260G()
CTBR260W()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	Return()
Endif


SetRegua(RecCount())

cGrupo := GRUPO
dbSelectArea("cArqTmp")

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0010)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par05 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If (Abs(COLUNA1)+Abs(COLUNA2)+Abs(COLUNA3)+Abs(COLUNA4)+Abs(COLUNA5)+Abs(COLUNA6)) == 0
		If mv_par07 == 2						// Saldos Zerados nao serao impressos
			dbSkip()
			Loop	
		ElseIf  mv_par07 == 1		//Se imprime saldos zerados, verificar a data de existencia da entidade
			If CtbExDtFim("CT1") 
				dbSelectArea("CT1")
				dbSetOrder(1)
				If MsSeek(xFilial()+cArqTmp->CONTA)
					If !CtbVlDtFim("CT1",mv_par01) 
			     		dbSelectArea("cArqTmp")
			     		dbSkip()
			     		Loop		
					EndIf
				EndIf		
			EndIf
			dbSelectArea("cArqTmp")
		EndIf
	EndIf      	

	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf

	If !Empty(cSegmento)
		If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
			If  !(Substr(cArqTmp->CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
				dbSkip()
				Loop
			EndIf	
		Else
			If Substr(cArqTmp->CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
				Substr(cArqTmp->CONTA,nPos,nDigitos) > Alltrim(cSegFim)
				dbSkip()
				Loop
			EndIf	
		Endif
	EndIf
	************************* ROTINA DE IMPRESSAO *************************
    If Empty(MV_PAR06)
		If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
			If cGrupo != GRUPO
				@li,00 PSAY REPLICATE("-",limite)
				li++
				@li,aColunas[COL_SEPARA1] PSAY "|"
				@li,aColunas[COL_CONTA]  PSAY OemToAnsi(STR0016) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
				@ li,aColunas[COL_SEPARA3]		PSAY "|"
				ValorCTB(aTotGrp[1],li,aColunas[COL_COLUNA1],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA4]		PSAY "|"
				ValorCTB(aTotGrp[2],li,aColunas[COL_COLUNA2],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA5]		PSAY "|"
				ValorCTB(aTotGrp[3],li,aColunas[COL_COLUNA3],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA6]		PSAY "|"
				ValorCTB(aTotGrp[4],li,aColunas[COL_COLUNA4],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA7] PSAY "|"	
				ValorCTB(aTotGrp[5],li,aColunas[COL_COLUNA5],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA8] PSAY "|"
				ValorCTB(aTotGrp[6],li,aColunas[COL_COLUNA6],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA9] PSAY "|"                                                                       
				
				//TOTAL GERAL
				If mv_par23 <> 2
					nTotGeral	:= aTotGrp[1]+aTotGrp[2]+aTotGrp[3]+aTotGrp[4]+aTotGrp[5]+aTotGrp[6]
					ValorCTB(nTotGeral,li,aColunas[COL_TOTAL],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)	
					nTotGeral	:= 	0
					@ li,aColunas[COL_SEPARA10] PSAY "|"                                                                       							
				EndIf	
				li++
				li			:= 60
				cGrupo		:= GRUPO
				aTotGrp 	:= {0,0,0,0,0,0}
			EndIf		
		Else
			If NIVEL1				// Sintetica de 1o. grupo
				li 	:= 60
			EndIf
		EndIf
	EndIf
	
	IF li > 58 
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	End
 
	//Total da Linha
	nTotLinha	:= COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6
	
	@ li,aColunas[COL_SEPARA1] 		PSAY "|"
	If lNormal
		If TIPOCONTA == "2" 		// Analitica -> Desloca 2 posicoes
			EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,20,.F.,cMascara,cSeparador)
		Else	
			EntidadeCTB(CONTA,li,aColunas[COL_CONTA],20,.F.,cMascara,cSeparador)
		EndIf	
	Else
		If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
			@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
		Else
			@li,aColunas[COL_CONTA] PSAY Alltrim(CONTA)
		EndIf						
	EndIf	
	@ li,aColunas[COL_SEPARA2] 		PSAY "|"
	@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,31)
	@ li,aColunas[COL_SEPARA3]		PSAY "|"
	ValorCTB(COLUNA1,li,aColunas[COL_COLUNA1],17,nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(COLUNA2,li,aColunas[COL_COLUNA2],17,nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(COLUNA3,li,aColunas[COL_COLUNA3],17,nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(COLUNA4,li,aColunas[COL_COLUNA4],17,nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"	
	ValorCTB(COLUNA5,li,aColunas[COL_COLUNA5],17,nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(COLUNA6,li,aColunas[COL_COLUNA6],17,nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"
	If mv_par23 <> 2
		ValorCTB(nTotLinha,li,aColunas[COL_TOTAL],17,nDecimais,lSinalMov,cPicture, , , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA10] PSAY "|"
	EndIf
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"	
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		@ li,aColunas[COL_SEPARA7] PSAY "|"
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		@ li,aColunas[COL_SEPARA9] PSAY "|"
		If mv_par23 <> 2
			@ li,aColunas[COL_SEPARA10]PSAY "|"			
		EndIf
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf			

	************************* FIM   DA  IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"			
			If NIVEL1      
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] +=&("COLUNA"+Str(nVezes,1))				
					aTotGrp[nVezes] +=&("COLUNA"+Str(nVezes,1))
				Next	
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] +=&("COLUNA"+Str(nVezes,1))
					aTotGrp[nVezes] +=&("COLUNA"+Str(nVezes,1))									
				Next							
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					For nVezes := 1 to Len(aMeses)
						aTotCol[nVezes] +=&("COLUNA"+Str(nVezes,1))				
					Next							
				EndIf
			EndIf
    	Endif			
	EndIf

	dbSkip()       
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"             
			@ li,aColunas[COL_SEPARA9] PSAY "|"             			
			If mv_par23 <> 2
				@ li,aColunas[COL_SEPARA10] PSAY "|"             			
			EndIf
			li++
		EndIf	
	EndIf		
EndDO

IF li != 80 .And. !lEnd
	IF li > 58 
		@Prow()+1,00 PSAY	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
    If Empty(MV_PAR06)
		If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
			If cGrupo != GRUPO
				@li,00 PSAY REPLICATE("-",limite)
				li++
				@li,aColunas[COL_SEPARA1] PSAY "|"
				@li,aColunas[COL_CONTA] PSAY OemToAnsi(STR0016) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
				@ li,aColunas[COL_SEPARA3]		PSAY "|"
				ValorCTB(aTotGrp[1],li,aColunas[COL_COLUNA1],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA4]		PSAY "|"
				ValorCTB(aTotGrp[2],li,aColunas[COL_COLUNA2],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA5]		PSAY "|"
				ValorCTB(aTotGrp[3],li,aColunas[COL_COLUNA3],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA6]		PSAY "|"
				ValorCTB(aTotGrp[4],li,aColunas[COL_COLUNA4],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA7] PSAY "|"	
				ValorCTB(aTotGrp[5],li,aColunas[COL_COLUNA5],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA8] PSAY "|"
				ValorCTB(aTotGrp[6],li,aColunas[COL_COLUNA6],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA9] PSAY "|"                                                                       
				
				//TOTAL GERAL
				If mv_par23 <> 2
					nTotGeral	:= aTotGrp[1]+aTotGrp[2]+aTotGrp[3]+aTotGrp[4]+aTotGrp[5]+aTotGrp[6]
					ValorCTB(nTotGeral,li,aColunas[COL_TOTAL],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)	
					nTotGeral	:= 	0
					@ li,aColunas[COL_SEPARA10] PSAY "|"			
				EndIf
				li++
				cGrupo		:= GRUPO
				aTotGrp 	:= {0,0,0,0,0,0}
			EndIf		
		EndIf
	EndIf
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	@li,aColunas[COL_CONTA]   PSAY OemToAnsi(STR0011)  		//"T O T A I S  D O  P E R I O D O : "
	@ li,aColunas[COL_SEPARA3]		PSAY "|"
	ValorCTB(aTotCol[1],li,aColunas[COL_COLUNA1],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(aTotCol[2],li,aColunas[COL_COLUNA2],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(aTotCol[3],li,aColunas[COL_COLUNA3],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(aTotCol[4],li,aColunas[COL_COLUNA4],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"	
	ValorCTB(aTotCol[5],li,aColunas[COL_COLUNA5],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(aTotCol[6],li,aColunas[COL_COLUNA6],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"                                                                       
	
	//TOTAL GERAL
	If mv_par23 <> 2
		nTotGeral	:= aTotCol[1]+aTotCol[2]+aTotCol[3]+aTotCol[4]+aTotCol[5]+aTotCol[6]
		ValorCTB(nTotGeral,li,aColunas[COL_TOTAL],17,nDecimais,lSinalMov,cPicture,, , , , , ,lPrintZero)	
		nTotGeral	:= 0
		
		@ li,aColunas[COL_SEPARA10] PSAY "|"
	EndIf
	li++
	@li,00 PSAY REPLICATE("-",limite)	
	li++
	@li,0 PSAY " "	
	roda(cbcont,cbtxt,"M")
	Set Filter To	
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

MS_FLUSH()

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBR040W ºAutor  ³ Wagner Gomes Costa  º Data ³  25/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function CTBR260W()

local oDlg , oQry , oOk , oCanc , oDst , oNomSt , oMBrowse
local cQuery 	:= ""
local cDst   	:= SPACE(255)
local cNomSt 	:= SPACE(255)
local lMBrowse	:= .F.

define msdialog oDlg from 0,0 to 150,400 title "Gera Comparativo X 6 Meses CSU" pixel

@ 005,005 SAY 	"Diretorio Destino: " 							size 150,7 		pixel of oDlg
@ 015,005 MSGET	oDst		VAR cDst	  when .f. 				size 150,7 		pixel of oDlg
define sbutton 			type 14 from 014, 160	enable of oDlg action (cDst:=DirAjuste(),oDst:Refresh())

@ 030,005 SAY 	"Nome do Arquivo Destino: " 					size 100,7		pixel of oDlg
@ 040,005 MSGET	oNomSt		VAR cNomSt	  valid !Empty(cNomSt) 	size 100,7		pixel of oDlg

define sbutton oOk		type 1 from 055, 140	enable of oDlg action (Processa({|| ctbr260e(cQuery,cDst,cNomSt,lMBrowse) }),oDlg:End())
define sbutton oCanc	type 2 from 055, 170	enable of oDlg action oDlg:End()

activate msdialog oDlg centered

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ctbr260e  ºAutor  ³ Wagner Gomes       º Data ³  21/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ csu                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function ctbr260e(cQuery,cDst,cNomSt,lMBrowse)

Local nCnt		:= 0
local nHdl		:= 0
local cChar		:= ";"
local cEnter 	:= CHR(13)+CHR(10)
local cLinha	:= ""
local uCampo	:= ""
//local cExt		:= ".XLS"
local cExt		:= ".TXT"

cDst 	:= Alltrim(cDst)
cNomSt 	:= Alltrim(cNomSt)

if !empty(cDst)

	if !empty(cNomSt)
		
		dbSelectArea("PLAN")
		dbGotop()
		
		nHdl := Fcreate(cDst+cNomSt+cExt,0)
		
		if nHdl > 0
			
			//cLinha := "<html><table>"+cEnter
			//fWrite(nHdl,cLinha)
			
			//cLinha := "<tr><td>"
			cLinha := ""
			For nCnt := 1 TO FCOUNT()
//				cLinha += FieldName(nCnt)+"</td>"+IIF(nCnt<FCount(),"<td>","")
				cLinha += FieldName(nCnt)+";"
			Next nCnt

//			cLinha += "</tr>"+cEnter
			cLinha += _eol
			
			cLinha := StrTran(cLinha,"COLUNA","MOV.PERIODO ")
			
			fwrite(nHdl,cLinha)
            
			// ------------------ CABEC 2C-------------------
			
			cLinha := ";;"
			
			dIni	:= MV_PAR01
			dFim0	:= Mv_PAR02
			
			If dIni <> FirstDay(MV_PAR01)
				dIni := LastDay(MV_PAR01)+1
			EndIf

			If dFim0 <> LastDay(MV_PAR02)
				dFim0 := FirstDay(MV_PAR02)-1
			EndIf
			
            For ii := 1 to 6
	            dFim	:= LastDay(dIni)
	            If dFim >= dFim0
	            	EXIT
	            EndIf
	            cLinha	+= dToC(dIni)+" a "+dToC(dFim)+";;"
				dIni	:= dFim+1
			Next ii
			
			dFim := dFim0
            
            cLinha	+= dToC(dIni)+" a "+dToC(dFim)+_eol
			fwrite(nHdl,cLinha)
			dbgotop()
			
			nLenCta := 0
			
			while !eof()
				
				IncProc()
				
//				cLinha := "<tr><td>"
				If Len(ALLTRIM(FieldGet(1)))<>nLenCta
					cLinha := _eol
					fwrite(nHdl,cLinha)
				    nLenCta := Len(ALLTRIM(FieldGet(1)))
				EndIf
	
				cLinha := ""
				
				For nCnt := 1 TO FCOUNT()

					uCampo := FieldGet(nCnt)
					
					If valtype(uCampo) == "C"
					
						uCampo := strtran(uCampo," ","")
					
					ElseIf valtype(uCampo) == "D"
					
						uCampo := DTOC(uCampo)
						
					Elseif valtype(uCampo)="N"
						If uCampo > 0 .OR. uCampo < 0
							uCampo := Alltrim(Str(uCampo))
							If At(".",uCampo) > 0
								uCampo := STUFF(uCampo,AT(".",uCampo),1,",")
							EndIf
						Else
							uCampo := "0"
						Endif
						
					Elseif valtype(uCampo)="L"
						uCampo := IIF(uCampo,"VERDADEIRO","FALSO")
						
					Endif
					
//					cLinha += uCampo+"</td>"+IIF(nCnt<FCount(),"<td>","")
					cLinha += uCampo+";"
					
				Next nCnt
				
//				cLinha += "</tr>"+cEnter
				cLinha += _eol
				
				fwrite(nHdl,cLinha)
				
				dbskip()
				
			enddo
			
//			cLinha := "</table></html>"+cEnter
//			fWrite(nHdl,cLinha)
			
			Fclose(nHdl)
			
			If File(cDst+cNomSt+cExt)
				MsgAlerT("Arquivo "+cDst+cNomSt+cExt+ " foi gerado! ")
				//ShellExecute( "open", cNomSt+cExt,"",cDst, 1 )

			EndIF
			
		else
			MsgAlert("Não foi possivel criar o arquivo "+cDst+cNomSt+cExt+" !")
		endif

	else
		MsgAlert( "Nao foi especificado o nome do arquivo")
	endif
	
else
	MsgAlert(" Nao foi especificada a pasta de destino do arquivo")
endif

dbSelectArea("PLAN")
dbCloseArea()

dbSelectArea("cArqTmp")
dbGoTop()

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³dirAjuste ºAutor  ³Wagner Gomes        º Data ³  24/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function DirAjuste()

local cFile := Alltrim(cGetFile( "*.*",OemToAnsi("Selecione Diretorio"),,"C:\",.F.,GETF_LOCALHARD)) //Alltrim(cGetFile("","",,"C:\",.F.,GETF_LOCALHARD)) //( "Impressao Resultado da Pesquisa Salarial (.DOT) | ",OemToAnsi("Selecione Diretorio"),,"",.F.,GETF_RETDIRECTORY)

Return(LEFT(cFile,RAT("\",cFile)))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBR260g  ºAutor  ³Wagner Gomes Costa    Data ³  08/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o Arquivo temporário para criação da Planilha         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CSU                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ctbr260g()
Local aStrExc	:= {}
Local cArqTrab	:= ""
Local cDC1		:= ""
Local cDC2		:= ""
Local cDC3		:= ""
Local cDC4		:= ""
Local cDC5		:= ""
Local cDC6		:= ""
Local cDCt		:= ""
Local lAtivo	:= .f.
Local nFator	:= 0

aadd(aStrExc,{"CONTA"		,"C",TamSx3("CT1_CONTA")  [1],TamSx3("CT1_CONTA")  [2]})
aadd(aStrExc,{"DESCCTA"		,"C",TamSx3("CT1_DESC01") [1],TamSx3("CT1_DESC01") [2]})

aadd(aStrExc,{"COLUNA1"		,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC1"			,"C",1                       ,0                       })
aadd(aStrExc,{"COLUNA2"		,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC2"			,"C",1                       ,0                       })
aadd(aStrExc,{"COLUNA3"		,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC3"			,"C",1                       ,0                       })
aadd(aStrExc,{"COLUNA4"		,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC4"			,"C",1                       ,0                       })
aadd(aStrExc,{"COLUNA5"		,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC5"			,"C",1                       ,0                       })
aadd(aStrExc,{"COLUNA6"		,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC6"			,"C",1                       ,0                       })
aadd(aStrExc,{"TOTAL"		,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DCT"			,"C",1                       ,0                       })

cArqTrab := CriaTrab(aStrExc,.T.)
dbUseArea(.T.,,cArqTrab,"PLAN",.T.,.F.)
dbSelectArea("PLAN")
IndRegua("PLAN",cArqTrab,"CONTA",,,"Gerando Planilha...")

dbSelectArea("cArqTmp")
dbGoTop()

While !cArqTmp->(Eof())
	
	IncProc("Gerando Planilha")

	cDC1	:= " "
	cDC2	:= " "
	cDC3	:= " "
	cDC4	:= " "
	cDC5	:= " "
	cDC6	:= " "
	cDCT	:= " "
	
	nTotal := cArqTmp->COLUNA1+cArqTmp->COLUNA2+cArqTmp->COLUNA3+cArqTmp->COLUNA4+cArqTmp->COLUNA5+cArqTmp->COLUNA6

	If cArqTmp->NORMAL == "1"
		
		If cArqTmp->COLUNA1 < 0
			cDC1	:= "D"
		ElseIf cArqTmp->COLUNA1 > 0
			cDC1	:= "C"
		EndIf

		If cArqTmp->COLUNA2 < 0
			cDC2	:= "D"
		ElseIf cArqTmp->COLUNA2 > 0
			cDC2	:= "C"
		EndIf

		If cArqTmp->COLUNA3 < 0
			cDC3	:= "D"
		ElseIf cArqTmp->COLUNA3 > 0
			cDC3	:= "C"
		EndIf

		If cArqTmp->COLUNA4 < 0
			cDC4	:= "D"
		ElseIf cArqTmp->COLUNA4 > 0
			cDC4	:= "C"
		EndIf

		If cArqTmp->COLUNA5 < 0
			cDC5	:= "D"
		ElseIf cArqTmp->COLUNA5 > 0
			cDC5	:= "C"
		EndIf

		If cArqTmp->COLUNA6 < 0
			cDC6	:= "D"
		ElseIf cArqTmp->COLUNA6 > 0
			cDC6	:= "C"
		EndIf
	
		If nTotal < 0
			cDCT	:= "D"
		ElseIf nTotal > 0
			cDCT	:= "C"
		EndIf
	
	ElseIf cArqTmp->NORMAL=="2"
		
		If cArqTmp->COLUNA1 > 0
			cDC1	:= "C"
		ElseIf cArqTmp->COLUNA1 < 0
			cDC1	:= "D"
		EndIf
		
		If cArqTmp->COLUNA2 > 0
			cDC2	:= "C"
		ElseIf cArqTmp->COLUNA2 < 0
			cDC2	:= "D"
		EndIf
		
		If cArqTmp->COLUNA3 > 0
			cDC3	:= "C"
		ElseIf cArqTmp->COLUNA3 < 0
			cDC3	:= "D"
		EndIf
		
		If cArqTmp->COLUNA4 > 0
			cDC4	:= "C"
		ElseIf cArqTmp->COLUNA4 < 0
			cDC4	:= "D"
		EndIf
		
		If cArqTmp->COLUNA5 > 0
			cDC5	:= "C"
		ElseIf cArqTmp->COLUNA5 < 0
			cDC5	:= "D"
		EndIf
		
		If cArqTmp->COLUNA6 > 0
			cDC6	:= "C"
		ElseIf cArqTmp->COLUNA6 < 0
			cDC6	:= "D"
		EndIf
		
		If nTotal > 0
			cDCT	:= "C"
		ElseIf nTotal < 0
			cDCT	:= "D"
		EndIf
		
		
	EndIf
	
	lAtivo := iif(Left(cArqTmp->CONTA,1)=="1",.t.,.f.)
	nFator	:= 	iif(lAtivo,-1,1)
	
	dbSelectArea("PLAN")
	RecLock("PLAN",.T.)
	
	PLAN->CONTA		:= cArqTmp->CONTA
	PLAN->DESCCTA	:= GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+cArqTmp->CONTA,1,"SEM DESCRIÇÃO")

	PLAN->COLUNA1	:= cArqTmp->COLUNA1*nFator
	PLAN->DC1		:= cDC1

	PLAN->COLUNA2	:= cArqTmp->COLUNA2*nFator
	PLAN->DC2		:= cDC2

	PLAN->COLUNA3	:= cArqTmp->COLUNA3*nFator
	PLAN->DC3		:= cDC3

	PLAN->COLUNA4	:= cArqTmp->COLUNA4*nFator
	PLAN->DC4		:= cDC4

	PLAN->COLUNA5	:= cArqTmp->COLUNA5*nFator
	PLAN->DC5		:= cDC5

	PLAN->COLUNA6	:= cArqTmp->COLUNA6*nFator
	PLAN->DC6		:= cDC6

	PLAN->TOTAL		:= nTotal*nFator
	PLAN->DCT		:= cDCT
	
	MsUnLock()
	
	dbSelectArea("cArqTmp")
	dbSkip()
	
EndDo

dbSelectArea("PLAN")
dbGotop()

Return()