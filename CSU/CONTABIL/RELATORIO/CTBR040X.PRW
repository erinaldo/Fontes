#Include "CTBR040X.Ch"
#Include "PROTHEUS.Ch"

#DEFINE COL_SEPARA1			1
#DEFINE COL_CONTA		        2
#DEFINE COL_SEPARA2			3
#DEFINE COL_DESCRICAO		        4
#DEFINE COL_SEPARA3			5
#DEFINE COL_SALDO_ANT                   6
#DEFINE COL_SEPARA4			7
#DEFINE COL_VLR_DEBITO                  8
#DEFINE COL_SEPARA5			9
#DEFINE COL_VLR_CREDITO                 10
#DEFINE COL_SEPARA6			11
#DEFINE COL_MOVIMENTO	                12
#DEFINE COL_SEPARA7			13
#DEFINE COL_SALDO_ATU	                14
#DEFINE COL_SEPARA8			15

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ctbr040X ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Analitico Sintetico Modelo 1                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr040()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso  ³ Generico                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtbR040X(wnRel)

Local aSetOfBook
Local aCtbMoeda	:= {}
LOCAL cDesc1	:= OemToAnsi(STR0001)	//"Este programa ira imprimir o Balancete de Verificacao Modelo 1 (80 Colunas), a"
LOCAL cDesc2	:= OemToansi(STR0002)   //"conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,"
LOCAL cDesc3		:= OemToansi(STR0016)   //"os valores impressao sao saldo anterior, debito, credito e saldo atual do periodo."
Local cNomeArq
LOCAL cString		:= "CT1"
Local titulo	:= OemToAnsi(STR0003)//"Balancete de Verificacao"
Local lRet			:= .T.
Local nDivide		:= 1
Local lExterno	:= wnRel <> Nil

PRIVATE Tamanho		:="M"
PRIVATE nLastKey:= 0
PRIVATE cPerg	:= PADR("CTR040",LEN(SX1->X1_GRUPO))
PRIVATE aReturn:= { OemToAnsi(STR0013), 1,OemToAnsi(STR0014), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg := "CTBR040X"
PRIVATE _eol		:= Chr(13)+chr(10)

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li	:= 80


CTR040SX1()

Private aQuadro := { "","","","","","","",""}

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next

CtbCarTxt()

Pergunte("CTR040",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                      ³
//³ mv_par01				// Data Inicial                       ³
//³ mv_par02				// Data Final                         ³
//³ mv_par03				// Conta Inicial                      ³
//³ mv_par04				// Conta Final                        ³
//³ mv_par05				// Imprime Contas: Sintet/Analit/Ambas³
//³ mv_par06				// Set Of Books                       ³
//³ mv_par07				// Saldos Zerados?                    ³
//³ mv_par08				// Moeda?                             ³
//³ mv_par09				// Pagina Inicial                     ³
//³ mv_par10				// Saldos? Reais /Orcados/Gerenciais  ³
//³ mv_par11				// Quebra por Grupo Contabil?		   ³
//³ mv_par12				// Filtra Segmento?					   ³
//³ mv_par13				// Conteudo Inicial Segmento?			  ³
//³ mv_par14				// Conteudo Final Segmento?		  ³
//³ mv_par15				// Conteudo Contido em?				   ³
//³ mv_par16				// Imprime Coluna Mov ?				   ³
//³ mv_par17				// Salta linha sintetica ?			   ³
//³ mv_par18				// Imprime valor 0.00    ?			   ³
//³ mv_par19				// Imprimir Codigo? Normal / Reduzido  ³
//³ mv_par20				// Divide por ?                ³
//³ mv_par21				// Imprimir Ate o segmento?				  ³
//³ mv_par22				// Posicao Ant. L/P? Sim / Nao       ³
//³ mv_par23				// Data Lucros/Perdas?               ³
//ª mv_par24				// Imprime Quadros Contábeis?						  ª
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ! lExterno
	wnrel	:= "CTBR040x"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !U_ct040Valid(mv_par06)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda := CtbMoeda(mv_par08,nDivide)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
	Endif
Endif

If !lRet
	Set Filter To
	Return
EndIf

If mv_par16 == 1 .And. ! lExterno	// Se imprime saldo movimento do periodo -> tamanho relatorio = 220
	tamanho := "G"
EndIf

If ! lExterno
	SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR040Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR040IMP ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete Verificacao Modelo 1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR040Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd       - A‡ao do Codeblock                             ³±±
±±³          ³ WnRel      - T¡tulo do relat¢rio                           ³±±
±±³          ³ cString    - Mensagem                                      ³±±
±±³          ³ aSetOfBook - Matriz ref. Config. Relatorio                 ³±±
±±³          ³ aCtbMoeda  - Matriz ref. a moeda                           ³±±
±±³          ³ nDivide    - Valor para divisao de valores                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR040Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno)

Local aColunas		:= {}
LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 132
Local cabec1:= ""
Local cabec2:= ""
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local dDataIni:= mv_par01
Local dDataFim:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par18==1,.T.,.F.)
Local lPula			:= Iif(mv_par17==1,.T.,.F.)
Local lNormal		:= Iif(mv_par19==1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)
Local l132			:= .T.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0
Local cSegAte:= mv_par21
Local nDigitAte	:= 0
Local lImpAntLP	:= Iif(mv_par22 == 1,.T.,.F.)
Local dDataLP		:= mv_par23

cDescMoeda:= Alltrim(aCtbMoeda[2])
nDecimais:= DecimalCTB(aSetOfBook,mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture	:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par05 == 1
	Titulo:=	OemToAnsi(STR0009)	//"BALANCETE DE VERIFICACAO SINTETICO DE "
ElseIf mv_par05 == 2
	Titulo:=	OemToAnsi(STR0006)	//"BALANCETE DE VERIFICACAO ANALITICO DE "
ElseIf mv_par05 == 3
	Titulo:=	OemToAnsi(STR0017)	//"BALANCETE DE VERIFICACAO DE "
EndIf

Titulo +=DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
OemToAnsi(STR0008) + cDescMoeda + CtbTitSaldo(mv_par10)

If nDivide > 1
	Titulo += " (" + OemToAnsi(STR0021) + Alltrim(Str(nDivide)) + ")"
EndIf

If mv_par16 == 1 .And. ! lExterno		// Se imprime saldo movimento do periodo
	cabec1 := OemToAnsi(STR0004)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |"
	tamanho := "G"
	limite	:= 220
	l132	:= .F.
Else
	cabec1 := OemToAnsi(STR0005)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
Endif

If l132
	aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
Else
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

If ! lExterno
	m_pag := mv_par09
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
l132,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado)},;
OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor rio..."
OemToAnsi(STR0003))		//"Balancete Verificacao"

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	For n := 1 to Val(cSegAte)
		nDigitAte += Val(Subs(cMascara,n,1))
	Next
EndIf


dbSelectArea("cArqTmp")
//dbSetOrder(1)
dbGoTop()

CTBR040G()
CTBR040W()

cGrupo := GRUPO

SetRegua(RecCount())

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
	
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	
	
	************************* ROTINA DE IMPRESSAO *************************
	
	If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			li			:= 60
			cGrupo	:= GRUPO
			nGrpDeb	:= 0
			nGrpCrd	:= 0
		EndIf
	Else
		If NIVEL1				// Sintetica de 1o. grupo
			li:= 60
		EndIf
	EndIf
	
	IF li > 58
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	End
	
	@ li,aColunas[COL_SEPARA1]	PSAY "|"
	If lNormal
		If TIPOCONTA == "2"	// Analitica -> Desloca 2 posicoes
			EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,21,.F.,cMascara,cSeparador)
		Else
			EntidadeCTB(CONTA,li,aColunas[COL_CONTA],23,.F.,cMascara,cSeparador)
		EndIf
	Else
		If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
			@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
		Else
			@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
		EndIf
	EndIf
	@ li,aColunas[COL_SEPARA2]	PSAY "|"
	@ li,aColunas[COL_DESCRICAO]PSAY DESCCTA
	@ li,aColunas[COL_SEPARA3]		PSAY "|"
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
	Endif
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA8] PSAY "|"
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
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
					nGrpDeb += SALDODEB
					nGrpCrd += SALDOCRD
				EndIf
			EndIf
		Endif
	EndIf
	
	dbSkip()
	If lPula .And. TIPOCONTA == "1"		// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
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
	If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				nTotMov := nTotMov + (nGrpCrd - nGrpDeb)
				If Round(NoRound(nTotMov,3),2) < 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
				ElseIf Round(NoRound(nTotMov,3),2) > 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
				EndIf
				@ li,aColunas[COL_SEPARA7] PSAY "|"
			Endif
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
		EndIf
	EndIf
	
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	@li,39 PSAY OemToAnsi(STR0011)//"T O T A I S  D O  M E S : "
	@li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		nTotMov := nTotMov + (nTotCrd - nTotDeb)
		If Round(NoRound(nTotMov,3),2) < 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nTotMov,3),2) > 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
		EndIf
		@li,aColunas[COL_SEPARA7] PSAY "|"
	EndIf
	@li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	If ! lExterno
		roda(cbcont,cbtxt,"M")
	Endif
	Set Filter To
EndIF

If mv_par24 ==1
	ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,nomeprog,(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par10)
EndIf

If aReturn[5] = 1 .And. ! lExterno
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

If ! lExterno
	MS_FLUSH()
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CT040Valid³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Perguntas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct040Valid(cSetOfBook)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Config. Relatorio                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function Ct040Valid(cSetOfBook)

Local aSaveArea:= GetArea()
Local lRet		:= .T.

If !Empty(cSetOfBook)
	dbSelectArea("CTN")
	dbSetOrder(1)
	If !dbSeek(xfilial()+cSetOfBook)
		aSetOfBook := ("","",0,"","")
		Help(" ",1,"NOSETOFB")
		lRet := .F.
	EndIf
EndIf

RestArea(aSaveArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTR040SX1    ³Autor ³  Lucimara Soares     ³Data³ 04/12/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as perguntas do relatório                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTR040SX1()

Local aArea:= GetArea()

//Grupo de perguntas do relatorio Balancete Modelo 1(CTR040)

aPergs	:= {}

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe se deseja imprimir os")
Aadd(aHelpPor,"Quadros contábeis, ao final do ")
Aadd(aHelpPor,"Relatorio")

Aadd(aHelpEng,"Inform if you wish to print")
Aadd(aHelpEng,"the Statement table at the end of")
Aadd(aHelpEng,"the report.")

Aadd(aHelpSpa,"Informe se desea imprimir los")
Aadd(aHelpSpa,"cuadros contabiles, después")
Aadd(aHelpspa,"del informe.")

Aadd(aPergs,{"Imp Quadros Contabeis?","Imp Cuadros Contabiles?","Print Statement?","mv_chp","N",1,0,0,"C","CTBOpQuad(mv_par24==1)","mv_par24","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","",""})

AjustaSx1("CTR040",aPergs)

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

Static function CTBR040W()

local oDlg , oQry , oOk , oCanc , oDst , oNomSt , oMBrowse
local cQuery:= ""
local cDst:= SPACE(255)
local cNomSt:= SPACE(255)
local lMBrowse	:= .F.

define msdialog oDlg from 0,0 to 150,400 title "Gera Balancete em Excel" pixel

@ 005,005 SAY"Diretorio Destino: "						size 150,7	pixel of oDlg
@ 015,005 MSGET	oDst		VAR cDst	  when .f.			size 150,7	pixel of oDlg
define sbutton		type 14 from 014, 160	enable of oDlg action (cDst:=DirAjuste(),oDst:Refresh())

@ 030,005 SAY"Nome do Arquivo Destino: "				size 100,7		pixel of oDlg
@ 040,005 MSGET	oNomSt		VAR cNomSt	  valid !Empty(cNomSt)size 100,7		pixel of oDlg

define sbutton oOk		type 1 from 055, 140	enable of oDlg action (Processa({|| ctbr040e(cQuery,cDst,cNomSt,lMBrowse) }),oDlg:End())
define sbutton oCanc	type 2 from 055, 170	enable of oDlg action oDlg:End()

activate msdialog oDlg centered

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ctbr040e  ºAutor  ³ Wagner Gomes       º Data ³  21/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ csu                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function ctbr040e(cQuery,cDst,cNomSt,lMBrowse)

Local nCnt		:= 0
local nHdl		:= 0
local cChar		:= ";"
local cEnter:= CHR(13)+CHR(10)
local cLinha	:= ""
local uCampo	:= ""
//local cExt		:= ".XLS"
local cExt		:= ".TXT"

cDst:= Alltrim(cDst)
cNomSt:= Alltrim(cNomSt)

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

Return .t.


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
±±ºPrograma  ³CTBR040g  ºAutor  ³Wagner Gomes Costa    Data ³  08/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o Arquivo temporário para criação da Planilha         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CSU                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ctbr040g()
Local aStrExc	:= {}
Local cArqTrab	:= ""
Local cDC1		:= ""
Local cDC2		:= ""
Local cDC3		:= ""
Local lAtivo	:= .f.
Local nFator	:= 0

aadd(aStrExc,{"CONTA"		,"C",TamSx3("CT1_CONTA")  [1],TamSx3("CT1_CONTA")  [2]})
aadd(aStrExc,{"DESCCTA"		,"C",TamSx3("CT1_DESC01") [1],TamSx3("CT1_DESC01") [2]})
aadd(aStrExc,{"SALDOANT"	,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC1"			,"C",1                       ,0                       })
aadd(aStrExc,{"SALDODEB"	,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"SALDOCRD"	,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"MOVIMENTO"	,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC2"			,"C",1                       ,0                       })
aadd(aStrExc,{"SALDOATU"	,"N",TamSx3("CT3_ATUDEB") [1],TamSx3("CT3_ATUDEB") [2]})
aadd(aStrExc,{"DC3"			,"C",1                       ,0                       })

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
	
	If cArqTmp->NORMAL == "1"
		
		If cArqTmp->SALDOANT < 0
			cDC1	:= "D"
		ElseIf cArqTmp->SALDOANT > 0
			cDC1	:= "C"
		EndIf
		
		If cArqTmp->MOVIMENTO < 0
			cDC2	:= "D"
		ElseIf cArqTmp->MOVIMENTO > 0
			cDC2	:= "C"
		EndIf
		
		If cArqTmp->SALDOATU < 0
			cDC3	:= "D"
		ElseIf cArqTmp->SALDOATU > 0
			cDC3	:= "C"
		EndIf
		
	ElseIf cArqTmp->NORMAL=="2"
		
		If cArqTmp->SALDOANT > 0
			cDC1	:= "C"
		ElseIf cArqTmp->SALDOANT < 0
			cDC1	:= "D"
		EndIf
		
		If cArqTmp->MOVIMENTO > 0
			cDC2	:= "C"
		ElseIf cArqTmp->MOVIMENTO < 0
			cDC2	:= "D"
		EndIf
		
		If cArqTmp->SALDOATU > 0
			cDC3	:= "C"
		ElseIf cArqTmp->SALDOATU < 0
			cDC3	:= "D"
		EndIf
		
	EndIf
	
	lAtivo := iif(Left(cArqTmp->CONTA,1)=="1",.t.,.f.)
	nFator := iif(lAtivo,-1,1)
	
	dbSelectArea("PLAN")
	RecLock("PLAN",.T.)
	
	PLAN->CONTA		:= cArqTmp->CONTA
	PLAN->DESCCTA	:= cArqTmp->DESCCTA
	PLAN->SALDOANT	:= cArqTmp->SALDOANT*nFator
	PLAN->DC1		:= cDC1
	PLAN->SALDODEB	:= cArqTmp->SALDODEB*iif(lAtivo,1,-1)
	PLAN->SALDOCRD	:= cArqTmp->SALDOCRD*nFator
	PLAN->MOVIMENTO	:= cArqTmp->MOVIMENTO*nFator
	PLAN->DC2		:= cDC2
	PLAN->SALDOATU	:= cArqTmp->SALDOATU*nFator
	PLAN->DC3		:= cDC3
	
	MsUnLock()
	
	dbSelectArea("cArqTmp")
	dbSkip()
	
EndDo

dbSelectArea("PLAN")
dbGotop()

Return()