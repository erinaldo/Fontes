//#Include "CTBR110.Ch"
#include "topconn.ch"
#include "rwmake.ch"
//#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR110  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 09.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Diario Geral                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR110(void)                                              ³±±
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
User Function CSUDIAR()

Local WnRel
Local aCtbMoeda:={}
LOCAL cString	:= "CT2"
LOCAL cDesc1 	:= ""  //OemToAnsi(STR0001)  //"Este programa ir  imprimir o Di rio Geral Modelo 1, de acordo"
LOCAL cDesc2 	:= ""  //OemToAnsi(STR0002)  //"com os parƒmetros sugeridos pelo usuario. Este modelo e ideal"
LOCAL cDesc3	:= ""  //OemToAnsi(STR0003)  //"para Plano de Contas que possuam codigos nao muito extensos"
Local Titulo 	:= "" //OemToAnsi(STR0006)	// Emissao do Diario Geral
Local lRet		:= .T.

PRIVATE Tamanho	:= "M"
PRIVATE aReturn 	:= {"", 1,, 2, 2, 1, "",1 }  // OemToAnsi(STR0004)  OemToAnsi(STR0005)  "Zebrado"###"Administracao"
PRIVATE nomeprog	:= "CTBR110"
PRIVATE aLinha  	:= { }
PRIVATE nLastKey	:= 0
PRIVATE cPerg   	:= PADR("CTR110",LEN(SX1->X1_GRUPO))
Private ntransp:=0


If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

wnrel :="CTBR110"

Pergunte("CTR110",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01  	      	// Data Inicial                          ³
//³ mv_par02            // Data Final                            ³
//³ mv_par03            // Moeda?                                ³
//³ mv_par04				// Set Of Books				    	     	  ³
//³ mv_par05				// Tipo Lcto? Real / Orcad / Gerenc / Pre³
//³ mv_par06  	        	// Pagina Inicial                        ³
//³ mv_par07            // Pagina Final                          ³
//³ mv_par08            // Pagina ao Reiniciar                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
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

RptStatus({|lEnd| CTR110Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTR110IMP ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 10/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Diario Geral                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ CTR110Imp(lEnd,wnRel,cString,aSetOfBook,aCebMoeda)         ³±±
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
Static Function CTR110Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt
Local Cbcont
Local Cabec1		:= ""//OemToAnsi(STR0007)
Local Cabec2		:= ""//OemToAnsi(STR0008)
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
Local cCancel		:= "" // OemToAnsi(STR0012)
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
Local nReg			:= 0
Local nTamDeb		:= 15			// Tamanho da coluna de DEBITO
Local nTamCrd		:= 14			// Tamanho da coluna de CREDITO

Local nColDeb		:= 102			// Coluna de impressao do DEBITO
Local nColCrd		:= 118			// Coluna de impressao do CREDITO
Local dDataFim		:= mv_par02
//Local bPular		:= { || &('TRD2->CT2_VLR'+cMoeda) == 0 .Or.;
  //	   					(TRD2->CT2_TPSALD # Str(mv_par05, 1) .And. mv_par05 # 5) }
PRIVATE _cDATA
Private cMoeda

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
cMoeda	:= mv_par03
m_pag 	:= mv_par06

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

ProcRegua(3)

_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM "+RETSQLNAME('CT2')+" "
_cQuery += " WHERE D_E_L_E_T_ <> '*' AND CT2_DATA >= '"+DTOS(MV_PAR01)+"'AND CT2_DATA <='"+DTOS(MV_PAR02)+"'"
_cQuery += " ORDER BY CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC"


If Select("TRD2") >0
	DBSelectArea("TRD2")
	DBCloseArea()
EndIf

IncProc("Obtendo Dados ")
TCQUERY _cQuery NEW ALIAS "TRD2"

DBSelectArea("TRD2")
dbGoTop()

Titulo		:= "DIARIO GERAL DE " + DTOC(mv_par01) + " ATE " +;
DTOC(mv_par02) + "EM " + cDescMoeda


dbSelectArea("TRD2")
SetRegua(Reccount())
While !Eof()  
	
	IF lEnd
		@Prow()+1, 0 PSAY cCancel
		Exit
	EndIF
	
//	If Eval(bPular)
//		dbSkip()
//		Loop
//	EndIf
	_cdata:= CTOD(SUBSTR(TRD2->CT2_DATA,7,2)+"/"+SUBSTR(TRD2->CT2_DATA,5,2)+"/"+SUBSTR(TRD2->CT2_DATA,3,2))
	nMes := Month(_cDATA)
	
	While ! Eof() .And. DTOS(_CDATA) <= DTOS(mv_par02) .And.;
		Month(_CDATA) == nMes
		
//		If Eval(bPular)
 //			dbSkip()
 //			Loop
 //		EndIf
		
		nDia := Day(_cDATA)
		lData:= .T.
		While !Eof() .And. DTOS(_CDATA) <= DTOS(mv_par02) .And.;
			Month(_CDATA) == nMes .And. Day(_CDATA) == nDia
			
			IF lEnd
				@Prow()+1, 0 PSAY cCancel
				Exit
			EndIF
			

			
//			If Eval(bPular)
 //				dbSkip()
  //				Loop
//			EndIf
			
			cDoc 		:= TRD2->CT2_DOC
			cLote		:= TRD2->CT2_LOTE
			cSubLote	:= TRD2->CT2_SBLOTE
			
			// Loop para imprimir mesmo lote / documento / continuacao de historico
			While !Eof() .And. 	TRD2->CT2_DOC == cDoc 				.And.;
				TRD2->CT2_LOTE == cLote 			.And.;
				TRD2->CT2_SBLOTE == cSubLote 		.And.;
				DTOS(_CDATA) <= DTOS(mv_par02) 	.And.;
				Month(_CDATA) == nMes 			.And.;
				Day(_CDATA) == nDia

				IncRegua()

  //				If Eval(bPular)
//					dbSkip()
  //					Loop
	//			EndIf
				
			//	nMes := Month(_cDATA)
			 //	nDia := Month(_cDATA)    
				
				If li > 55
					li++
					//	Imprime "a transportar ----->" ao final da pagina
					If !lFirst .And. (nTotDiaD <> 0 .or. nTotDiaC <> 0)
						@li,055 PSAY " a transportar -----> "	  //OemToAnsi(STR0014)				A transportar
						If nTotDiaD <> 0
							ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
						EndIf
						If nTotDiaC <> 0
							ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
						EndIf
						li++
					EndIF
					// Reinicia numeracao de pagina
					If m_pag > mv_par07
						m_pag := mv_par08
					EndIF
					CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
					li++
					@li,010 PSAY "C O N T A" 
					@li,042 PSAY "H I S T O R I C O" 
					@li,083 PSAY "N U M E R O"
					@li,118 PSAY "V A L O R"  
					li++
					@li,000 PSAY "DEBITO"
					@li,021 PSAY "CREDITO"					  
					@li,083 PSAY "LANCTO"
					@li,111 PSAY "DEBITO"
					@li,125 PSAY "CREDITO"					  
					li++
					@ li,000 PSAY REPLICATE("_",133)
					li++
					// Imprime "de transporte -------->" no inicio da pagina
					If !lFirst .And. (nTotDiaD <> 0 .or. nTotDiaC <> 0)
						li++
						@li,055 PSAY "de transporte --------> " //OemToAnsi(STR0014)
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
					@ li, 000 PSAY DTOC(_cDATA)
					li++
					lData := .F.
				EndIf
				
				EntidadeCTB(TRD2->CT2_DEBITO,li,00,20,.F.,cMascara,cSeparador)
				EntidadeCTB(TRD2->CT2_CREDIT,li,21,20,.F.,cMascara,cSeparador)
				
				@ li, 042 PSAY Substr(TRD2->CT2_HIST,1,40)
				@ li, 083 PSAY TRD2->CT2_LOTE+TRD2->CT2_SBLOTE+TRD2->CT2_DOC+;
				TRD2->CT2_LINHA
				nValor := TRD2->CT2_VALOR
				If TRD2->CT2_DC == "1" .Or. TRD2->CT2_DC == "3"
					ValorCTB(nValor,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
				EndIf
				If TRD2->CT2_DC == "2" .Or. TRD2->CT2_DC == "3"
					ValorCTB(nValor,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
				EndIf
				
				If TRD2->CT2_DC == "1" .Or. TRD2->CT2_DC == "3"
					nTotDeb 	+= TRD2->CT2_VALOR
					nTotDiaD	+= TRD2->CT2_VALOR
					nTotMesD	+= TRD2->CT2_VALOR
				EndIf
				If TRD2->CT2_DC == "2" .Or. TRD2->CT2_DC == "3"
					nTotCred += TRD2->CT2_VALOR
					nTotdiaC += TRD2->CT2_VALOR
					nTotMesC += TRD2->CT2_VALOR
				EndIf
				        
				Dbselectarea("TRD2")
				Dbskip()
				_cdata:= CTOD(SUBSTR(TRD2->CT2_DATA,7,2)+"/"+SUBSTR(TRD2->CT2_DATA,5,2)+"/"+SUBSTR(TRD2->CT2_DATA,3,2))
	
				If TRD2->CT2_DC == "4"
					dbSelectArea("TRD2")
					cSeqLan := TRD2->CT2_SEQLAN
					While !Eof() .AND.	TRD2->CT2_LOTE == cLote 		.And.;
						TRD2->CT2_SBLOTE == cSubLote 	.And.;
						TRD2->CT2_DOC == cDoc 			.And.;
						TRD2->CT2_SEQLAN == cSeqLan 	.And.;
						TRD2->CT2_DC == "4" 			.And.;
						Dtos(_cdata) == DTOS(mv_par02)
						li++
						@ li, 042 PSAY Substr(TRD2->CT2_HIST,1,40)
						cLinha := TRD2->CT2_LINHA
						dData  := _cdata
						dbSelectArea("TRD2")
						dbSkip() 
						_cdata:= CTOD(SUBSTR(TRD2->CT2_DATA,7,2)+"/"+SUBSTR(TRD2->CT2_DATA,5,2)+"/"+SUBSTR(TRD2->CT2_DATA,3,2))
					EndDo
					//					dbSetOrder(1)
				EndIf
				li++
			
			EndDo
		EndDO
		If lEnd
			Exit
		Endif
		IF (nTotDiad+nTotDiac)>0
			li++
		@li,055 PSAY "Total do Dia" //OemToAnsi(STR0015)			// Totais do Dia

			ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
			ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
			nTotDiaD	:= 0
			nTotDiaC	:= 0
			li+=2
		EndIF
	EndDO
	If lEnd
		Exit
	End
	// Totais do Mes
	IF (nTotMesd+nTotMesc) > 0
		@li,055 PSAY "Total do Mês "  //OemToAnsi(STR0016)				// Totais do Mes
		ValorCTB(nTotMesD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
		ValorCTB(nTotMesC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
		nTotMesD := 0
		nTotMesC := 0
		li+=2
	EndIF
EndDO

IF (nTotDiad+nTotDiac)>0 .And. !lEnd
	// Totais do Dia - Ultimo impresso
	li++
	@li,055 PSAY "Total do Dia "  //OemToAnsi(STR0015)				// Totais do Dia
	ValorCTB(nTotDiaD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
	ValorCTB(nTotDiaC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
	li++
	
	// Totais do Mes - Ultimo impresso
	@li,055 PSAY "Total do Mês " //OemToAnsi(STR0016)  			// Totais do Mes
	ValorCTB(nTotMesD,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
	ValorCTB(nTotMesC,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
	li++
EndIF

// Total Geral impresso
IF (nTotDeb + nTotCred) > 0 .And. !lEnd
	@li,055 PSAY "Total Geral " //OemToAnsi(STR0017)				// Total Geral
	ValorCTB(nTotDeb ,li,nColDeb,nTamDeb,nDecimais,.F.,cPicture,"1")
	ValorCTB(nTotCred,li,nColCrd,nTamCrd,nDecimais,.F.,cPicture,"2")
EndIF

//dbSelectarea("CT2")
//dbSetOrder(1)
//Set Filter To

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
End
MS_FLUSH()

Return           
