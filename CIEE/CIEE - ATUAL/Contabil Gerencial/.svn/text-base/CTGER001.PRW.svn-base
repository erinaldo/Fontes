#Include "CTGER001.Ch"
#Include "PROTHEUS.Ch"
#INCLUDE "FONT.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTGER001 ³ Autor ³ Claudio Barros        ³ Data ³ 09.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Diario Geral - Especifico CIEE                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTGER001(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTGER001()

Local WnRel
Local aCtbMoeda:={}
LOCAL cString	:= "CT2"
LOCAL cDesc1 	:= OemToAnsi(STR0001)  //"Este programa ir  imprimir o Di rio Geral Modelo 1, de acordo"
LOCAL cDesc2 	:= OemToAnsi(STR0002)  //"com os parƒmetros sugeridos pelo usuario. Este modelo e ideal"
LOCAL cDesc3	:= OemToAnsi(STR0003)  //"para Plano de Contas que possuam codigos nao muito extensos"
Local Titulo 	:= OemToAnsi(STR0006)				// Emissao do Diario Geral
Local lRet		:= .T.

PRIVATE Tamanho	:= "M"
PRIVATE aReturn 	:= { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog	:= "CTGER001"
PRIVATE aLinha  	:= { }
PRIVATE nLastKey	:= 0
PRIVATE cPerg   	:= "CTG110"
PRIVATE lCodImp		:= .F.
Private LTest :=  " "
PRIVATE oPrint    := NIL
PRIVATE oFont1  := NIL
Private nTotLotGeD := 0
Private nTotLotGeC :=0


//DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrint BOLD
oCouNew14	:= TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf



wnrel :="CTGER001"

lCodImp := AjCTGImpX1("CTG110","12",0,"mv_par12") // Ant. AjCodImpX1

CTG001SX1()  // Ant  CTR110SX1

Pergunte("CTG110    ",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01  	      	// Data Inicial                          ³
//³ mv_par02            // Data Final                            ³
//³ mv_par03            // Moeda?                                ³
//³ mv_par04			// Set Of Books				    	     ³
//³ mv_par05			// Tipo Lcto? Real / Orcad / Gerenc / Pre³
//³ mv_par06  	        // Pagina Inicial                        ³
//³ mv_par07            // Pagina Final                          ³
//³ mv_par08            // Pagina ao Reiniciar                   ³
//³ mv_par09            // So Livro/Livro e Termos/So Termos     ³
//³ mv_par10            // Imprime Balancete                     ³
//³ mv_par11            // Imprime Plano de contas               ³
//³ mv_par12            // Imprime Valor 0.00                    ³
//³ mv_par13            // Imprime Cod. Conta ?                  ³
//³ mv_par14            // No.Linhas p/ o Diario                 ³ 
//³ mv_par15            // Salta Linha Entre                     ³
//³ mv_par16            // Lote De    ?                          ³
//³ mv_par17            // Lote Ate   ?                          ³
//³ mv_par18            // Documento De  ?                       ³
//³ mv_par19            // Documento Ate ?                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

If mv_par10 = 1
	Pergunte("CTR040    ",.T.)   // Ver Perguntas CFB
	Pergunte("CTG001    ",.T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par04)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par04)
EndIf

If lRet
	aCtbMoeda	:= CtbMoeda(mv_par03)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
	EndIf
EndIf

If !lRet
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTG001Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda)}) // Ant  CTR110Imp
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTG001IMP ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 10/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Diario Geral                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ CTG001Imp(lEnd,wnRel,cString,aSetOfBook,aCebMoeda)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ±±
±±³Parametros ³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³           ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³           ³ ExpC2   - Mensagem                                         ³±±
±±³           ³ ExpA1   - Matriz ref. Config. Relatorio                    ³±±
±±³           ³ ExpA2   - Matriz ref. a moeda                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTG001Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt
Local Cbcont
Local Cabec1		:= OemToAnsi(STR0007)
Local Cabec2		:= Iif (cPaisLoc<>"MEX",OemToAnsi(STR0008),OemToAnsi(STR0020))
Local Titulo		:= ""

Local cPicture
Local cDescMoeda
Local cCodMasc
Local cSeparador	:= ""
Local cMascara
Local cGrupo
Local cLote			:= ""
Local cSubLote		:= ""
Local cDoc			:= ""
Local cCancel		:= OemToAnsi(STR0012)
Local dData			:= Ctod("")
Local dDataAnte 	:= Ctod("")
Local lData			:= .T.
Local lFirst		:= .T.
Local nQuebra		:= 0
Local nTotDiaD		:= 0
Local nTotDiaC		:= 0
Local nTotMesD		:= 0
Local nTotMesC		:= 0
Local nTotDeb		:= 0
Local nTotCred	 	:= 0
Local nDia
Local nMes

Local nTamDeb		:= 13			// Tamanho da coluna de DEBITO
Local nTamCrd		:= 13			// Tamanho da coluna de CREDITO
Local nRecCT2		:= 0

Local nColDeb		:= 104			// Coluna de impressao do DEBITO
Local nColCrd		:= 119			// Coluna de impressao do CREDITO
Local dDataFim		:= mv_par02
Local cFiltro		:= IIf(ALLTRIM(STR(MV_PAR05))$ "1/2",IIF(ALLTRIM(STR(MV_PAR05)) == "1","1","9"),"*")
//Local bPular		:= { || 	&('CT2->CT2_VLR'+cMoeda) == 0 .Or.(CT2->CT2_TPSALD # cFiltro .And. cFiltro # "*") }
Local bPular		:= { || 	&('CT2->CT2_VALOR') == 0 .Or.(CT2->CT2_TPSALD # cFiltro .And. cFiltro # "*") }
Local lImpLivro		:=.t., lImpTermos:=.f.
Local l1StQb	 	:= .T.
Local cFilCT1		:= xFilial("CT1")

Local nPagIni		:= mv_par06
Local nPagFim		:= mv_par07
Local nReinicia		:= mv_par08
Local nBloco		:= 0
Local nBlCount		:= 0
Local lEmissUnica	:= If(GetNewPar("MV_CTBQBPG","M") == "M",.T.,.F.)			/// U=Quebra única (.F.) ; M=Multiplas quebras (.T.)
Local lNewPAGFIM	:= If(nReinicia > nPagFim,.T.,.F.)
Local nMaxLin   	:= mv_par14  // Antigo MV_PAR13
Local _nValContD  := 0
Local _nValContC  := 0
Local nTotLotD    := 0
Local nTotLotC    := 0
Local _VlContD    := ""
Local _VlContC    := ""
If lEmissUnica
	m_pag    := 1
	CtgQbPg(.T.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
Else
	m_pag 	:= mv_par06
Endif

Private cMoeda
Private _cNome := " "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
cMoeda	:= mv_par03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando definicoes para impressao -> Decimais, Picture,   ³
//³ Mascara da Conta                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara := RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 	:= aSetOfBook[4]
aNomUser    := PswRet()

/*
nPos := aScan(aNomUser, {|x| ALLTRIM(x[13]) == ALLTRIM(MV_PAR16)}) // Antigo MV_PAR14
If nPos > 0
	_cNome := aNomUser[nPos][2]
Endif
*/

IF ALLTRIM(STR(MV_PAR05)) == "1"
   cTit1 :="-  EFETIVADO "
ELSEIF ALLTRIM(STR(MV_PAR05)) == "2"
 cTit1 :="-  PRE-LANCAMENTO " 
ELSE  
 cTit1 :="-  EFETIVADO / PRE-LANCAMENTO"
ENDIF 
   


//Titulo		:= 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) +;
//DTOC(mv_par02) + OemToAnsi(STR0011) + cDescMoeda + CtbTitSaldo(ALLTRIM(STR(mv_par05)))+" ("+Alltrim(_cNome)+")"

Titulo		:= 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) +;
DTOC(mv_par02) + OemToAnsi(STR0011) + cDescMoeda + OemToAnsi(cTit1)


dbSelectAre("CT2")
dbSetOrder(1)
SetRegua(Reccount())
dbSeek(xFilial("CT2")+Dtos(mv_par01),.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par09==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par09==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par09==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase

While 	lImpLivro .And. !Eof() .AND. CT2->CT2_FILIAL == xFilial() .And.;
	DTOS(CT2->CT2_DATA) <= DTOS(mv_par02)
	
	                    // Antigo MV_PAR16
	IF  CT2->CT2_LOTE > MV_PAR17 .OR. CT2->CT2_LOTE < MV_PAR16 // Antigo MV_PAR15
		dbSkip()
		Loop
	EndIf
	
	IF  CT2->CT2_DOC > MV_PAR19 .OR. CT2->CT2_DOC < MV_PAR18
		dbSkip()
		Loop
	EndIf
	
	IF CT2->CT2_DATA > MV_PAR02 .OR. CT2->CT2_DATA < MV_PAR01
		dbSkip()
		Loop
	EndIf
	
	
	IF lEnd
		@Prow()+1, 0 PSAY cCancel
		Exit
	EndIF
	
	If Eval(bPular)
		dbSkip()
		Loop
	EndIf

	nMes := Month(CT2->CT2_DATA)
	
	While ! Eof() .And. CT2->CT2_FILIAL == xFilial() .And. ;
		DTOS(CT2->CT2_DATA) <= DTOS(mv_par02) .And.Month(CT2->CT2_DATA) == nMes
		
		If Eval(bPular)
			dbSkip()
			Loop
		EndIf
                            // Antigo MV_PAR16
		IF  CT2->CT2_LOTE > MV_PAR17 .OR. CT2->CT2_LOTE < MV_PAR16 // Antigo MV_PAR15
			dbSkip()
			Loop
		EndIf
		
		IF  CT2->CT2_DOC > MV_PAR19 .OR. CT2->CT2_DOC < MV_PAR18
			dbSkip()
			Loop
		EndIf
		IF CT2->CT2_DATA > MV_PAR02 .OR. CT2->CT2_DATA < MV_PAR01
			dbSkip()
			Loop
		EndIf
		
		
		nDia := Day(CT2->CT2_DATA)
		lData:= .T.
		While !Eof() .And. CT2->CT2_FILIAL == xFilial() .And.;
			DTOS(CT2->CT2_DATA) <= DTOS(mv_par02) .And.;
			Month(CT2->CT2_DATA) == nMes .And. Day(CT2->CT2_DATA) == nDia
			
			IF lEnd
				@Prow()+1, 0 PSAY cCancel
				Exit
			EndIF
			
			IncRegua()

			If Eval(bPular)
				dbSkip()
				Loop
			EndIf

			IF  CT2->CT2_LOTE > MV_PAR17 .OR. CT2->CT2_LOTE < MV_PAR16 // Antigo MV_PAR15
				dbSkip()
				Loop
			EndIf
			
			IF  CT2->CT2_DOC > MV_PAR19 .OR. CT2->CT2_DOC < MV_PAR18
				dbSkip()
				Loop
			EndIf
			
			IF CT2->CT2_DATA > MV_PAR02 .OR. CT2->CT2_DATA < MV_PAR01
				dbSkip()
				Loop
			EndIf
			
			
			_nValContD  := 0
			_nValContC  := 0
			nTotLotD    := 0
			nTotLotC    := 0
			cDoc 		:= CT2->CT2_DOC
			cLote		:= CT2->CT2_LOTE
			cSubLote	:= CT2->CT2_SBLOTE
			
			// Loop para imprimir mesmo lote / documento / continuacao de historico
			While  CT2->CT2_FILIAL == xFilial("CT2") 		.And.;
				CT2->CT2_LOTE == cLote 			.And.;
				CT2->CT2_SBLOTE == cSubLote 		.And.;
				DTOS(CT2->CT2_DATA) <= DTOS(mv_par02) 
				
				cDoc 		:= CT2->CT2_DOC

				If Eval(bPular)
					dbSkip()
					Loop
  				EndIf

				IF  CT2->CT2_LOTE > MV_PAR17 .OR. CT2->CT2_LOTE < MV_PAR16  // Antigo MV_PAR15
					dbSkip()
					Loop
				EndIf
				
				IF  CT2->CT2_DOC > MV_PAR19 .OR. CT2->CT2_DOC < MV_PAR18
					dbSkip()
					Loop
				EndIf
			IF CT2->CT2_DATA > MV_PAR02 .OR. CT2->CT2_DATA < MV_PAR01
				dbSkip()
				Loop
			EndIf
				
				
				
				If li > nMaxLin
					li++
					//	Imprime "a transportar ----->" ao final da pagina
					If !lFirst .And. (nTotDiaD <> 0 .or. nTotDiaC <> 0)
						@li,055 PSAY OemToAnsi(STR0013)						// A transportar
						If nTotDiaD <> 0
							ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
						EndIf
						If nTotDiaC <> 0
							ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
						EndIf
						li++
					EndIF
					
					If lEmissUnica
						CtgQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.F. EFETUA QUEBRA
					Else
						// Reinicia numeracao de pagina
						If m_pag > mv_par07
							If lNewPAGFIM
								mv_par07	:= m_pag+mv_par07		//// ACUMULA A QTDE ATUAL NA NUMERACAO FINAL
								If l1StQb							//// SE FOR A 1ª QUEBRA
									m_pag		:= mv_par08			//// VOLTA A NUMERACAO COM O PARAMETRO
									l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
								Endif
							Else
								m_pag := nReinicia
							Endif
						Endif
					Endif
					CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
					// Imprime "de transporte -------->" no inicio da pagina
					If !lFirst .And. (nTotDiaD <> 0 .or. nTotDiaC <> 0)
						li++
						@ li, 000 PSAY DTOC(CT2->CT2_DATA)
						@li,055 PSAY OemToAnsi(STR0014)
						If nTotDiaD <> 0
							ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
						EndIf
						If nTotDiaC <> 0
							ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
						EndIf
						li+=2
					EndIF
					lFirst := .F.
				EndIF
				
				If lData
					li++
					@ li, 000 PSAY DTOC(CT2->CT2_DATA)
					li++
					lData := .F.
				EndIf
				
				If !Empty(CT2->CT2_DEBITO)					/// Se a Conta a Debito estiver preenchida
					dbSelectArea("CT1")
					dbSetOrder(1)
					If MsSeek(cFilCT1+CT2->CT2_DEBITO,.F.)	/// e existir no plano de contas
						If mv_par13 == 2  //Antigo MV_PAR12 Impressao do Codigo Reduzido
							EntidadeCTB(CT1->CT1_RES,li,00,6,.F.,cMascara,cSeparador)
							EntidadeCTB(CT2->CT2_CCD,li,08,6,.F.,cMascara,cSeparador,"CTT",1,.F.)  // Especifico CIEE - TI2055 CFB
						ElseIf mv_par13 == 3 .AND. lCodImp 	/// Impressao do Codigo de Impressao (se o campo existir)  //Antigo MV_PAR12
							EntidadeCTB(CT1->CT1_CODIMP,li,00,20,.F.,cMascara,cSeparador)
						Else										/// Impressao do Codigo Normal
							EntidadeCTB(CT2->CT2_DEBITO,li,00,20,.F.,cMascara,cSeparador)
						Endif
					Else
						EntidadeCTB(CT2->CT2_DEBITO,li,00,20,.F.,cMascara,cSeparador)
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Linha de detalhe especifica da CIEE - Impressao do Centro de Custo - TI 2055 - CFB³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				_nValContD += Val(Alltrim(CT2->CT2_ITEMD)+Alltrim(CT2->CT2_CCD))
				_nValContC += Val(Alltrim(CT2->CT2_ITEMC)+Alltrim(CT2->CT2_CCC))
				
				
				
				If !Empty(CT2->CT2_CREDIT)
					dbSelectArea("CT1")
					dbSetOrder(1)
					If MsSeek(cFilCT1+CT2->CT2_CREDIT,.F.)
						If mv_par13 == 2		//Antigo MV_PAR12					/// Impressao do Codigo Reduzido
							EntidadeCTB(CT1->CT1_RES,li,21,6,.F.,cMascara,cSeparador)
							EntidadeCTB(CT2->CT2_CCC,li,28,6,.F.,cMascara,cSeparador,"CTT",1,.F.)			// Especifico CIEE TI2055 - CFB
						ElseIf mv_par13 == 3 .AND. lCodImp	 //Antigo MV_PAR12		/// Impressao do Codigo de Impressao (se o campo existir)
							EntidadeCTB(CT1->CT1_CODIMP,li,21,20,.F.,cMascara,cSeparador)
						Else										/// Impressao do Codigo Normal
							EntidadeCTB(CT2->CT2_CREDIT,li,21,20,.F.,cMascara,cSeparador)
						Endif
					Else
						EntidadeCTB(CT2->CT2_CREDIT,li,21,20,.F.,cMascara,cSeparador)
					Endif
				Endif
				
				If cPaisLoc == "CHI"
					@ li, 042 PSAY Substr(CT2->CT2_HIST,1,40)
					@ li, 077 PSAY CT2->CT2_LOTE+CT2->CT2_SBLOTE+" "+CT2->CT2_SEGOFI+CT2->CT2_LINHA
				Else
					@ li, 045 PSAY Substr(CT2->CT2_ORIGEM,1,3)
					@ li, 050 PSAY Substr(CT2->CT2_HIST,1,40)
					//					@ li, 083 PSAY CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_LINHA
					@ li, 091 PSAY CT2->CT2_LOTE+"/"+CT2->CT2_DOC
				EndIf
				
//				nValor := &('CT2->CT2_VLR'+cMoeda)
				nValor := &('CT2->CT2_VALOR')
				If CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3"
					ValorCTB(nValor,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
				EndIf
				If CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3"
					ValorCTB(nValor,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
				EndIf
				
				If CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3"
					nTotDeb 	+= &('CT2->CT2_VALOR')
					nTotDiaD	+= &('CT2->CT2_VALOR')
					nTotMesD	+= &('CT2->CT2_VALOR')
					nTotLotD	+= &('CT2->CT2_VALOR')

				EndIf
				If CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3"
					
					nTotCred  += &('CT2->CT2_VALOR' )
					nTotdiaC  += &('CT2->CT2_VALOR' )
					nTotMesC  += &('CT2->CT2_VALOR' )
					nTotLotC  += &('CT2->CT2_VALOR' )
					
					
					
				EndIf
				
				// Procura pelo complemento de historico
				nRecCT2 := CT2->(Recno())
				dData	:= CT2->CT2_DATA
				cSeqLan := CT2->CT2_SEQLAN
				
				dbSelectArea("CT2")
				dbSetOrder(10)
//				If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeqLan)
				If dbSeek(xFilial("CT2")+DTOS(dData)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+cSeqLan)
					dbSkip()
					If CT2->CT2_DC == "4"
						While  CT2->CT2_FILIAL == xFilial() 	.And.;
							CT2->CT2_LOTE == cLote 		.And.;
							CT2->CT2_SBLOTE == cSubLote 	.And.;
							CT2->CT2_SEQLAN == cSeqLan 	.And.;
							CT2->CT2_DC == "4" 			.And.;
							CT2->CT2_DOC == cDoc 			.And.;
							Dtos(CT2->CT2_DATA) == DTOS(dData)
							
							
							li++
							
							If li >= nMaxLin
								//	Imprime "a transportar ----->" ao final da pagina
								If !lFirst .And. (nTotDiaD <> 0 .or. nTotDiaC <> 0)
									@li,055 PSAY OemToAnsi(STR0013)						// A transportar
									If nTotDiaD <> 0
										ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
									EndIf
									If nTotDiaC <> 0
										ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
									EndIf
									li++
								EndIF
								
								If lEmissUnica
									CtgQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.F. EFETUA QUEBRA
								Else
									// Reinicia numeracao de pagina
									If m_pag > mv_par07
										If lNewPAGFIM
											mv_par07	:= m_pag+mv_par07		//// ACUMULA A QTDE ATUAL NA NUMERACAO FINAL
											If l1StQb							//// SE FOR A 1ª QUEBRA
												m_pag		:= mv_par08			//// VOLTA A NUMERACAO COM O PARAMETRO
												l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
											Endif
										Else
											m_pag := nReinicia
										Endif
									Endif
								Endif
								CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
								// Imprime "de transporte -------->" no inicio da pagina
								If !lFirst .And. (nTotDiaD <> 0 .or. nTotDiaC <> 0)
									li++
									@ li, 000 PSAY DTOC(CT2->CT2_DATA)
									@li,055 PSAY OemToAnsi(STR0014)
									If nTotDiaD <> 0
										ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
									EndIf
									If nTotDiaC <> 0
										ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
									EndIf
									li+=2
								EndIF
								lFirst := .F.
							EndIF
							@ li, 045 PSAY Substr(CT2->CT2_ORIGEM,1,3)
							@ li, 050 PSAY Substr(CT2->CT2_HIST,1,40)
							cLinha := CT2->CT2_LINHA
							dbSkip()
						EndDo
					ElseIf dData <> CT2->CT2_DATA //Alteracao dia 02/06/08 pelo analista Emerson. Quebra de Datas.
						exit
					EndIf
				Else
					dbGoto(nRecCT2)
					dbSetOrder(1)
					dbSkip()
				EndIf
				dbSetOrder(1)
				li++
				
			EndDo
			
			IF MV_PAR13 == 2 //Antigo MV_PAR12
				li++
				/*        oPrint := TMSPrinter():New( LTest )
				oPrint:SetLandsCape()
				oPrint:StartPage()
				oCouNew14	:= TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)
				oPrint:Say(li+160,800,"TESTE",oCouNew14 )
				*/
				@ li ,00 PSAY ALLTRIM(STR(_nValContD,11))
				@ li ,21 PSAY ALLTRIM(STR(_nValContC,11))
				
				//        oPrint:EndPage()
				
				
				@ li ,102 PSAY nTotLotD Picture "@E 999,999,999.99"
				@ li ,118 PSAY nTotLotC Picture "@E 999,999,999.99"
				li:=li+2
			ENDIF
			nTotLotGeD+= _nValContD
			nTotLotGeC+= _nValContC
			
		EndDO
		If lEnd
			Exit
		Endif
	EndDO
	If lEnd
		Exit
	End
	/*	// Totais do Mes
	IF (nTotMesd+nTotMesc) > 0
	@li,055 PSAY OemToAnsi(STR0016)				// Totais do Mes
	ValorCTB(nTotMesD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
	ValorCTB(nTotMesC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
	nTotMesD := 0
	nTotMesC := 0
	li+=2
	EndIF
	*/
EndDO
/*
IF (nTotDiad+nTotDiac)>0 .And. !lEnd
// Totais do Dia - Ultimo impresso
li++
@li,055 PSAY OemToAnsi(STR0015)				// Totais do Dia
ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
li++

// Totais do Mes - Ultimo impresso
@li,055 PSAY OemToAnsi(STR0016)  			// Totais do Mes
ValorCTB(nTotMesD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
ValorCTB(nTotMesC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
li++
EndIF
*/
// Total Geral impresso


@ li ,00 PSAY ALLTRIM(STR(nTotLotGeD,11))
@ li ,21 PSAY ALLTRIM(STR(nTotLotGeC,11))


IF (nTotDeb + nTotCred) > 0 .And. !lEnd
	@li,055 PSAY OemToAnsi(STR0017)				// Total Geral
	ValorCTB(nTotDeb ,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
	ValorCTB(nTotCred,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
EndIF

dbSelectarea("CT2")
dbSetOrder(1)
Set Filter To

If mv_par10 == 1
	Ctbr040(wnRel)
	Pergunte( "CTG110    ", .T. )
EndIf
If mv_par11 == 1
	Ctbr010(wnRel,mv_par02,mv_par03)
Endif

If lImpTermos 							// Impressao dos Termos
	
	Pergunte( "CTG110    ", .T. )
	
	cArqAbert:=GetMv("MV_LDIARAB")
	cArqEncer:=GetMv("MV_LDIAREN")
	
	dbSelectArea("SM0")
	aVariaveis:={}
	
	For i:=1 to FCount()
		If FieldName(i)=="M0_CGC"
			AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
		Else
			If FieldName(i)=="M0_NOME"
				Loop
			EndIf
			AADD(aVariaveis,{FieldName(i),FieldGet(i)})
		Endif
	Next
	
	dbSelectArea("SX1")
	dbSeek("CTG110"+"01")
	
	While SX1->X1_GRUPO=="CTG110"
		AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
		dbSkip()
	End
	
	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,"Diario Geral.") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif
	
	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,"Diario Geral.") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif
	
	If cArqAbert#NIL
		ImpTerm(cArqAbert,aVariaveis,AvalImp(132))
	Endif
	
	If cArqEncer#NIL
		ImpTerm(cArqEncer,aVariaveis,AvalImp(132))
	Endif
Endif

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
End
MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjCTGImpX1ºAutor  ³Marcos S. Lobo      º Data ³  09/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua o ajuste no grupo de perguntas SX1 caso o campo      º±±
±±º          ³CT1_CODIMP esteja criado e em uso.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 - Relatórios SIGACTB                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ cPerg= Codigo do Grupo de Perguntas no SX1                 º±±
±±º          ³ cSeq = Codigo da Sequencia da Pergunta Imprime?(Normal/Red)º±±
±±º          ³ nX1Def=Numero da Seqüencia de DEFINE no ComboBox do SX1    º±±
±±º          ³ cMvPar=Codigo do mv_parXX que será utilizado.			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjCTGImpX1(cPerg,cSeq,nX1Def,cMvPar)
Local lUsaCodImp	:= .F.
Local aArea			:= GetArea()
Local cCHAR2CH		:= "123456789abcdefghijklmnopqrstuv"
Local cMVCH			:= cMvPar

If Empty(cPerg) .or. Empty(cSeq)
	Return(lUsaCodImp)
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek("CT1_CODIMP")	.and. X3Uso(SX3->X3_USADO)				//// SE ENCONTRAR O CODIGO DE IMPRESSAO NO SX3 E ESTIVER EM USO
	lUsaCodImp := .T.											//// USO DO CODIGO DE IMPRESSA ESTARÁ HABILITADO
Else
	lUsaCodImp := .F.											//// USO DO CODIGO DE IMPRESSAO ESTARA DESABILITADO
Endif

If nX1Def > 0										/// SE FOR SOMENTE MANUTENÇÃO DE COMBOBOX
	dbSelectArea("SX1")
	dbSetOrder(1)
	If MsSeek(cPerg+cSeq)
		If lUsaCodImp .and. Empty(&("SX1->X1_DEF"+STRZERO(nX1Def,2)))		/// SE USA E ESTA EM BRANCO
			RecLock("SX1",.F.)
			&("Field->X1_DEF"+STRZERO(nX1Def,2))  		:= SX3->X3_TITULO	/// PREENCHE PARA LIBERAR O USO
			&("Field->X1_DEFSPA"+ALLTRIM(STR(nX1Def)))	:= SX3->X3_TITSPA
			&("Field->X1_DEFENG"+ALLTRIM(STR(nX1Def)))	:= SX3->X3_TITENG
			SX1->(MsUnlock())
		ElseIf !lUsaCodImp .and. !Empty(&("SX1->X1_DEF"+STRZERO(nX1Def,2))) /// SE Ñ USA E NAO ESTÁ VAZIO
			RecLock("SX1",.F.)
			&("Field->X1_DEF"+STRZERO(nX1Def,2))  		:= " "			/// APAGA PARA NAO LIBERAR O USO DO COD.IMPRESSAO
			&("Field->X1_DEFSPA"+ALLTRIM(STR(nX1Def)))	:= " "
			&("Field->X1_DEFENG"+ALLTRIM(STR(nX1Def)))	:= " "
			Field->X1_PRESEL	:= 0
			SX1->(MsUnlock())
		Endif
	Endif
Else                    		/// SE FOR NOVA PERGUNTA NO SX1
	If Empty(cMvPar)
		RestArea(aArea)
		Return(.F.)
	Endif
	dbSelectArea("SX1")
	dbSetOrder(1)
	If !MsSeek(cPerg+cSeq)							/// SE A PERGUNTA NAO EXISTIR
		cMVCH := "mv_ch"+SubStr(cCHAR2CH,val(SubStr(cMvPar,7,Len(cMvPar)-6)),1)		/// DEFINE A SEQUENCIA DO X1_VARIAVL (MV_CHx) UTILIZADO
		RecLock("SX1",.T.)
		Field->X1_GRUPO		:= cPerg
		Field->X1_ORDEM		:= cSeq
		Field->X1_PERGUNT	:= "Impr Cod. Conta    ?"
		Field->X1_PERSPA	:= "¿Impr Cod Cuenta   ?"
		Field->X1_PERENG	:= "Print Account Code ?"
		Field->X1_VARIAVL	:= cMVCH
		Field->X1_TIPO		:= "N"
		Field->X1_TAMANHO	:= 1
		Field->X1_DECIMAL	:= 0
		Field->X1_PRESEL	:= 0
		Field->X1_GSC		:= "C"
		Field->X1_VAR01		:= cMvPar
		Field->X1_DEF01 	:= "Normal"
		Field->X1_DEFSPA1	:= "Normal"
		Field->X1_DEFENG1	:= "Normal"
		Field->X1_DEF02 	:= "Reduzido"
		Field->X1_DEFSPA2	:= "Reducido"
		Field->X1_DEFENG2	:= "Reduced"
		If lUsaCodImp												/// SE CODIGO DE IMPRESSAO ESTIVER EM USO
			Field->X1_DEF03 	:= SX3->X3_TITULO
			Field->X1_DEFSPA3	:= SX3->X3_TITSPA
			Field->X1_DEFENG3	:= SX3->X3_TITENG
		Endif
		SX1->(MsUnlock())
	Else
		If !lUsaCodImp .and. !Empty(SX1->X1_DEF03)	/// SE NÃO USAR O CODIGO DE IMPRESSAO E O MESMO NAO ESTIVER VAZIO
			RecLock("SX1",.F.)
			Field->X1_DEF03 	:= ""				/// LIMPA O DEFINE DO COD.IMPRESSAO PARA NAO UTILIZAR
			Field->X1_DEFSPA3	:= ""
			Field->X1_DEFENG3	:= ""
			Field->X1_PRESEL	:= 0
			SX1->(MsUnlock())
		ElseIf Empty(SX1->X1_DEF03)					/// SE USAR E O CODIGO DE IMPRESSAO ESTIVER VAZIO
			RecLock("SX1",.F.)
			Field->X1_DEF03 	:= SX3->X3_TITULO	/// ADICIONA O DEFINE DO COD. IMPRESSAO PARA UTILIZAR
			Field->X1_DEFSPA3	:= SX3->X3_TITSPA
			Field->X1_DEFENG3	:= SX3->X3_TITENG
			SX1->(MsUnlock())
		Endif
	Endif
Endif

RestArea(aArea)
Return(lUsaCodImp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtgQbPg   ºAutor  ³Marcos S. Lobo      º Data ³  12/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Controla a quebra de pagina dos relatorios SIGACTB          º±±
±±º          ³quando possuem os parametros de PAG.INICAL-FINAL-REINICIAR  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro1³ lNewVars  = (.T.=Inicializa variaveis/.F.=Trata Quebra)    º±±
±±º         2³ nPagIni 	 = Pagina Inicial do relatorio.               	  º±±
±±º         3³ nPagFim 	 = Pagina Final do relatorio               	 	  º±±
±±º         4³ nReinicia = Pagina ao Reiniciar do relatorio               º±±
±±º         5³ m_pag 	 = Numero da pagina usada na Cabec()              º±±
±±º         6³ nBloco    = Bloco de paginas (intervalo de quebra)		  º±±
±±º         7³ nBlCount  = Contador de páginas (zerado na qebra de bloco) º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtgQbPg(lNewVars,nPagIni,nPagFim,nReinicia,m_pag,nBloco,nBlCount)  // Ant. CtbQbPg

DEFAULT lNewVars := .F.

If lNewVars					/// INICIALIZA AS VARIAVEIS
	nBloco		:= (nPagFim+1) - nPagIni				/// (PAG. FIM + 1) - PAG. INICIAL - BLOCO DE PAG. PARA IMPRESSAO
	nBlCount	:= 0
	m_pag		:= nPagIni
Else						/// NAO INICIALIZA - TRATA A QUEBRA DE PAGINA
	nBlCount++
	If nBlCount > nBloco 							/// SE A QUANTIDADE DE PAGINAS IMPRESSAO FOR IGUAL AO BLOCO DEFINIDO
		If nReinicia > nPagFim						/// SE A PAG. DE REINICIO FOR MAIOR QUE A PAGINA FINAL (ATUAL)
			nUltPg	  := m_pag						/// GUARDA A ULTIMA PAG. IMPRESSA
			m_pag 	  := nReinicia					/// REINICIA A NUMERACAO DE PAG. (m_pag atual ainda não foi)
			nPagFim   := nReinicia+nBloco 			/// DEFINE O NOVO NUMERO DA PAGINA FIM
			nReinicia := nPagFim+(nReinicia-nUltPg)	/// DEFINE A PROX. PAG. AO REINICIAR PELA DIFERENCA COM  FINAL
		Else										/// SE A PAG. DE REINICIO FOR MENOR OU IGUAL A PAGINA FINAL
			m_pag := nReinicia						/// SO REINICIA A NUMERACAO DE PAG.
		Endif
		nBlCount := 1
	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTG001SX1    ³Autor ³  Simone Mie Sato     ³Data³ 05/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria nova pergunta para o relatorio.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTG001SX1()

Local aSaveArea 	:= GetArea()
Local aPergs		:= {}

Aadd(aPergs,{"No.linhas diario?","¨Num.lineas p/diario?","No.of rows daybook?","mv_chd","N",2,0,0,"G",,"mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","","S","",,,})  // Antigo MV_PAR13

AjustaSx1("CTG110",aPergs)

RestArea(aSaveArea)

Return
