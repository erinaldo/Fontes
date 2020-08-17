/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  NFCSU   ³ Autor ³   ARAUTO SANTANA      ³ Data ³ 17/01/02 ³±±           
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Saida                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para CSU - CARDSYSTEM                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencoes efetuadas                                                  ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Analista       ³ Data   ³                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Cardoso³21/02/02³Ajuste para regularizar o salto de impressao  ³±±
±±³               ³        ³de uma nota para outra. O cabecalho cuja im-  ³±±
±±³               ³        ³pressao era feita atraves de coordenadas fixas³±±
±±³               ³        ³passou a tratar as linhas de forma variavel.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function NFISS7()

SetPrc(0,0)
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI,XNUM_NF")
SetPrvt("XSERIE,XEMISSAO,XTOT_FAT,XVALOR_MERC,XCOD_PRO,XPRE_UNI")
SetPrvt("XCOND_PAG,XPBRUTO,XTIPO,XDESC,XVAL_MERC,XTES")
SetPrvt("CPEDATU,CITEMATU,XPED_VEND,XITEM_PED,XTOT_PROD,_AAREAANT")
SetPrvt("XPESO_PRO,XUNID_PRO,I,XPED,XCLIENTE,XMENSMP135")
SetPrvt("XCOD_MENS,XCOD_MENS2,XMENSAGEM,XCONDPAG,NQUANTNF")
SetPrvt("XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI,XDESC_PRO")
SetPrvt("J,XNOME_CLI,XEND_CLI,XNATUREZA,NTAMDET,NCOL,NTAMOBS")
SetPrvt("XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI,XINSC_CLI,XCCM_CLI")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


tamanho     := "P"
limite      := 40
titulo      := PADC("Nota Fiscal - NFCSU",74)
cDesc1      := PADC("Este programa ira emitir a Nota Fiscal de Saida",74)
cDesc2      := ""
cDesc3      := PADC("Especifico CSU - CARDSYSTEM",74)
//cNatureza := ""
aReturn     := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog    := "NFCSU"
cPerg       := "NFCSU"
nLastKey    := 0
lContinua   := .T.
nLin        := 0
wnrel       := "NFCSU"
nQuantNF    := 0
_TotIRF     := 0
nTamNf      := 40  // Tamanho do Formulario de Nota Fiscal (em Linhas), apenas informativo.
cString     :="SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//³ mv_par01             // Da Nota Fiscal
//³ mv_par02             // Ate a Nota Fiscal
//³ mv_par03             // Da Serie

Pergunte(cPerg,.F.)      // Pergunta no SX1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento da Nota Fiscal                       ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP6 IDE em 13/01/02 ==>    RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP6 IDE em 13/01/02 ==>    Function RptDetail
	Static Function RptDetail()
#ENDIF

// Inicia regua de impressao.
SetRegua(Val(mv_par02)-Val(mv_par01))

// Posiciona na primeira NF a ser impressa.
dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial("SF2")+mv_par01+mv_par03 )

If SF2->F2_DOC >= mv_par01 .AND. SF2->F2_DOC <= mv_par02
	
	While !eof() .and. SF2->F2_DOC <= mv_par02 .and. lContinua
		
		// Verifica a serie da NF, se for diferente do MV_PAR03, não imprime e passa
		// para a próxima NF.
		If SF2->F2_SERIE <> mv_par03
			DbSkip()
			Loop
		Endif
		
		#IFNDEF WINDOWS
			
			IF LastKey()==286
				@ nLin, 01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
				
			Endif
			
		#ELSE
			
			IF lAbortPrint
				@ nLin, 01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
			
		#ENDIF
		
		nLinIni := nLin                         // Linha Inicial da Impressao
		
		// Inicio do levantamento dos dados da NF a ser impressa.
		
		xNUM_NF   := SF2->F2_DOC             // Numero
		xSERIE    := SF2->F2_SERIE           // Serie
		xEMISSAO  := SF2->F2_EMISSAO         // Data de Emissao
		xCLIENTE  := SF2->F2_CLIENTE
		xLOJA     := SF2->F2_LOJA
		xTOT_FAT  := SF2->F2_VALFAT          // Valor Total da Fatura
		xVAL_IRF  := SF2->F2_VALIRRF         // Valor do IRF
		xTOT_BRUT := SF2->F2_VALBRUT         //Valor Bruto
// Analisa os campos de impostos da lei 10.833/03 (PIS / COFINS / CSLL) para impressão em nota fiscal
		If SF2->F2_VALCSLL<=0
			xVAL_CSLL := (SF2->F2_VALBRUT*1)/100 //Calcula valor total da Lei10833/03 caso o campo F2_VALCSLL menor ou igual a zero
		Else 
			xVAL_CSLL := SF2->F2_VALCSLL         // Valor da CSLL              
		EndIf			

		If SF2->F2_VALCOFI<=0
			xVAL_COFI := (SF2->F2_VALBRUT*3)/100 //Calcula valor do Cofins (Lei10833/03) caso o campo F2_VALCOFI menor ou igual a zero
		Else 
			xVAL_COFI := SF2->F2_VALCOFI         // Valor do Cofins
		EndIf			

		If SF2->F2_VALPIS<=0
			xVAL_PIS := (SF2->F2_VALBRUT*0,0065) //Calcula valor do PIS (Lei10833/03) caso o campo F2_VALCSLL menor ou igual a zero
		Else 
			xVAL_PIS  := SF2->F2_VALPIS          // Valor do PIS
		EndIf					


		_nCalc135:=(xVAL_IRF+xVAL_COFI+xVAL_PIS+xVAL_CSLL) //Calcula valor total da Lei10833/03 + IRRF- RETIRAR APOS ATUALIZAÇÃO DE RPO / BIN

		If xTOT_BRUT == 0
			xTOT_FAT := SF2->F2_VALMERC
		endif
		
		xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
		xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
		xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
		
		// Posiciona no cadastro referente ao cliente em questão.
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial("SA1")+xCLIENTE+xLOJA )
		
		xNOME_CLI := SA1->A1_NOME               // Nome
		xCGC_CLI  := AllTrim(SA1->A1_CGC)       // CGC
		xINSC_CLI := SA1->A1_INSCR              // Inscricao estadual
		xCCM_CLI  := SA1->A1_INSCRM            //  Inscricao Municipal (CCM)		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		dbSeek( xFilial("SZ2")+xCLIENTE+xLOJA )
		
		xEND_CLI  := SZ2->Z2_ENDENTR                // Endereco
		xMUN_CLI  := SZ2->Z2_CIDENTR                // Municipio
		xEST_CLI  := SZ2->Z2_ESTENTR                // Estado
		
		// Posiciona no 1o. item da NF de Saída para buscar o no. do
		// Pedido de Venda correspondente.
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
		
		// Busca informaçoes restantes no cabecalho do Pedido referente a NF em questao.
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial("SC5")+SD2->D2_PEDIDO )
		
		xCOD_MENS    := SC5->C5_MENPAD             // Codigo da Mensagem Padrao
		xMENSAGEM    := AllTrim(SC5->C5_MENNOTA)   // Mensagem para a Nota Fiscal
		XMENSINSS    :="RETENÇÃO SEGURIDADE SOCIAL = R$ "
		xMENSAGEM2   := Alltrim(SC5->C5_MENNOT2)   // Mensagem para NF referente a IRF
//		XMENSIRF     :="RETER 1,5% DE IRF = R$ "
		XMENSIRFF    :="IRFF- "
		XMENSCOFI    :="COFINS- "
		XMENSPIS     :="PIS- "
		XMENSCSLL    :="CSLL- "
		xCOMPETENCIA := Alltrim(SC5->C5_COMPETE)   // Campo de Mensagem solicitado pelo Cliente
		xCONDPAG     := SC5->C5_CONDPAG            // Condicao de Pagamento
		xVECTO       := SC5->C5_DATA1            // DATA DE VENCIMENTO - MTDO

		// Busca a descrição referente a condição de pagto. utilizada.
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		
		xDESC_PAG := SE4->E4_DESCRI
		
		// Volta para o arquivo de itens da NF.
		dbSelectArea("SD2")
		//dbSetOrder(3)
		//dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
		
		// Inicializa matrizes de controle das informacoes.
		xPED_VEND   := {}  // Numero do Pedido de Venda
		xITEM_PED   := {}  // Numero do Item do Pedido de Venda
		xCOD_PRO    := {}  // Codigo  do Produto
		xPRE_UNI    := {}  // Preco Unitario de Venda
		xVAL_MERC   := {}  // Valor da Mercadoria
		xTES        := {}  // TES
		xPED_CLI    := {}  // Numero de Pedido
		xDESC_PRO   := {}  // Descricao aux do produto
		xDESC_COMP  := {}  // Descricao Complementar do Produto
		
		xTOT_PROD   := 0
		_TotIRF     := 0
		_TotINSS    := 0                                       
		_nCalcISS	:= 0
		_pAliqISS	:= 0
				
		while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			
			// Verifica a serie da NF, se for diferente do MV_PAR03, não imprime e passa
			// para a próxima NF.
			If SD2->D2_SERIE <> mv_par03
				DbSkip()
				Loop
			Endif
			
			AADD( xPED_VEND ,SD2->D2_PEDIDO )
			AADD( xITEM_PED ,SD2->D2_ITEMPV )
			AADD( xCOD_PRO  ,SD2->D2_COD )
			AADD( xPRE_UNI  ,SD2->D2_PRCVEN )
			AADD( xVAL_MERC ,SD2->D2_TOTAL )
			AADD( xTES      ,SD2->D2_TES )
			
			xTOT_PROD := xTOT_PROD + SD2->D2_TOTAL
			
			// Posiciona no cadastro do produto em questao.
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek( xFilial("SB1")+SD2->D2_COD )
			
			AADD( xDESC_PRO , SB1->B1_DESC )
			xPRETSER := SB1->B1_PRETSER
			
			// Posiciona no item do Pedido referente ao item da NF em questao.
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek( xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV )
			
			AADD( xPED_CLI  , SC6->C6_PEDCLI )
			AADD( xDESC_COMP, SC6->C6_DESCOMP )
			
			xDATAENT := SC6->C6_ENTREG // data de entrega que aparece na NF
			
			// Calcula o IRF caso exista.
			IF SC6->C6_CALCIRF == "S"                                     
				_TotIRF := (_TotIRF + (INT(SD2->D2_TOTAL*SB1->B1_PERCIRF)/100))
			EndIf
			
			//novo acerto Roberto 260402 por telefone
			
			If SC6->C6_CALINSS == "S"
				
				IF!Empty(SC6->C6_BASINSS)
					_TotINSS := (_TotINSS + (SC6->C6_BASINSS*(INT(SD2->D2_TOTAL*SB1->B1_PERINSS)/100)/100))
				else
					_TotINSS := (_TotINSS + INT(SB1->B1_PERINSS*(SD2->D2_TOTAL)/100))
				endif
				
			EndIf        

			//Calcula ISS
			IF SB1->B1_ALIQISS>0
				_nCalcISS:=INT(SB1->B1_ALIQISS*SF2->F2_VALBRUT)/100
				_pAliqISS:=SB1->B1_ALIQISS
			Else
				If Found() .and. !Empty(GetMV("MV_ALIQISS"))   
			   		_pAliqISS := GetMV("MV_ALIQISS")
					_nCalcISS := INT(SF2->F2_VALBRUT*_pAliqISS)/100
				EndIf
		
			Endif
			
			dbSelectArea("SD2")
			dbskip()
			
		EndDo
		
		// Posiciona no Tipo de Saida em questao para pegar a descricao da
		// natureza da operacao.
		dbSelectArea("SF4")
		DbSetOrder(1)
		dbSeek(xFilial("SF4")+xTES[1])
		
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		
		Imprime()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Termino da Impressao da Nota Fiscal                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IncRegua()                    // Termometro de Impressao
		
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                      FIM DA IMPRESSAO                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa da Nota Fiscal                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If SF2->F2_DOC >= mv_par01 .AND. SF2->F2_DOC <= mv_par02
	dbSelectArea("SF2")
	Retindex("SF2")
	dbSelectArea("SD2")
	Retindex("SD2")
	dbSelectArea("SC5")
	Retindex("SC5")
	dbSelectArea("SC6")
	Retindex("SC6")
	dbSelectArea("SA1")
	Retindex("SA1")
	dbSelectArea("SB1")
	Retindex("SB1")
ENDIF

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Programa                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                   FUNCOES ESPECIFICAS                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPDET   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe da Nota Fiscal              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function IMPDET()

Local nImpDetLin := 0
Local nNewLin    := 0


nTamDet    := 10       // Tamanho da Area de Detalhe
nImpDetLin := nLin

I:=1
J:=1

For I:=1 to nTamDet
	
	If I<= Len(xCOD_PRO)
		
		If Len(xDESC_PRO[I]) > 42
			@ nLin, 003  PSAY Substr((xDESC_PRO[I]),1,42)
			nLin += 1
			@ nLin, 003  PSAY Substr((xDESC_PRO[I]),43,len(xDESC_PRO[I]))
		Else
			@ nLin, 003  PSAY ALLTRIM(xDESC_PRO[I])
		EndIf
		
		@ nLin, 060  PSAY xVAL_MERC[I] Picture "@E 99,999,999.99"
		nLin += 1
		
		If alltrim(xDESC_COMP[I]) <> ""
			
			If (Len(alltrim(xDESC_COMP[I]))) > 42
				
				@ nLin, 003 PSAY "(" + alltrim(Substr((xDESC_COMP[I]),1,41))
				nLin += 1  
				                    
				if(Len(alltrim(xDESC_COMP[I]))) >42  .and. (Len(alltrim(xDESC_COMP[I]))) < 83 
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),42,42))+ ")"
					nLin += 1                        
				Else
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),42,42))
					nLin += 1                        
				Endif
								
				if(Len(alltrim(xDESC_COMP[I]))) >84  .and. (Len(alltrim(xDESC_COMP[I]))) < 126 
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),84,42))+ ")"
					nLin += 1
				Else         
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),84,42))
					nLin += 1                                      
				Endif
				
				if(Len(alltrim(xDESC_COMP[I]))) >127  .and. (Len(alltrim(xDESC_COMP[I]))) <= 150
					@ nLin, 003 PSAY alltrim(Substr((xDESC_COMP[I]),126,Len(alltrim(xDESC_COMP[I])))) + ")"
				Endif			
				
			Else
				@ nLin, 003 PSAY  "(" + alltrim(xDESC_COMP[I]) + ")"
			EndIf
			         
		EndIf
		
		J:=J+1
	Endif
	
	nLin += 1
	
Next

nLin += 3    //MTDO
//nNewLin := ( 10 - ( nLin - nImpDetLin ) )+ nLin   //MTDO
//nLin    := nNewLin   //MTDO

If !Empty(xCOMPETENCIA)
	@ nLin, 002  PSAY " COMPETÊNCIA :. " + ALLTRIM(xCOMPETENCIA)
Else
EndIf
nCol    := 004

//nLin += 2
nLin += 1

// IMPRIME A MENSAGEM E O VALOR DO INSS   NA NOTA FISCAL
@ nLin, 004 PSAY  alltrim(xMENSAGEM)
nLin += 1
//INICIO MTDO
If !Empty(xMensagem2)
	@ nLin, 004  PSAY  ALLTRIM(xMensagem2)
	nLin += 1
EndIf
//FIM MTDO
//@ nLin, 004  PSAY  ALLTRIM(xMensagem2)
//nLin += 1

If !Empty(_TotINSS)
	
	@ nLin, nCol PSAY  alltrim(xMENSINSS)     //+ CHR(18) + CHR(20)
	@ nLin, 034  PSAY  _TotINSS Picture "@E 99,999,999.99"
	
EndIf
nLin += 1
//INICIO MTDO
@ nLin, 002 PSAY alltrim(XMENSMP135)     //+ CHR(18) + CHR(20)
@ nLin, 015 PSAY _nCalc135 Picture "@E 9,999,999.99"
@ nLin, 030 PSAY alltrim(XMENSIRFF) 
@ nLin, 037 PSAY xVAL_IRF Picture "@E 9,999,999.99"
@ nLin, 050 PSAY alltrim(XMENSCSLL)
@ nLin, 054 PSAY xVAL_CSLL Picture "@E 9,999,999.99"
nLin += 1
@ nLin, 030 PSAY alltrim(XMENSCOFI)
@ nLin, 036 PSAY xVAL_COFI Picture "@E 9,999,999.99"
@ nLin, 049 PSAY alltrim(XMENSPIS)
@ nLin, 054 PSAY xVAL_PIS Picture "@E 9,999,999.99"
//EndIf

/*If xVECTO > ctod("31/01/2004") 
	@ nLin, nCol PSAY  alltrim(XMENSMP135)     //+ CHR(18) + CHR(20)
	@ nLin, 060  PSAY  _nCalc135 Picture "@E 99,999,999.99"
EndIf
nLin += 1
//FIM MTDO

If !Empty(xVAL_IRF)
	@ nLin, 004  PSAY  ALLTRIM(xMENSIRF)
	@ nLin, 060  PSAY  xVAL_IRF Picture "@E 99,999,999.99"
Else
	@ nLin, 004  PSAY  ALLTRIM(xMENSIRF)
	@ nLin, 060  PSAY  _TotIRF Picture "@E 99,999,999.99"
//	@ nLin, 030  PSAY  _TotIRF Picture "@E 99,999,999.99"
EndIf
*/

/*
If !Empty(_TotIRF)
	@ nLin, 004  PSAY  ALLTRIM(xMENSIRF)
	@ nLin, 030  PSAY  _TotIRF Picture "@E 99,999,999.99"
	
EndIf                                                        
*/

Return

Static Function Imprime()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³              IMPRESSAO DA N.F. DA Nfiscal                    ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho da N.F.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin += 7
@ nLin, 040 PSAY xNATUREZA                  // Texto da Natureza de Operacao
nLin += 1
@ nLin, 040 PSAY xPRETSER                   // Cod. de Servico utilizado pelo produto
nLin += 1
@ nLin, 040 PSAY xEMISSAO                   // Data da Emissao do Documento
If SF2->F2_SERIE= "02H" .OR. SF2->F2_SERIE= "03H" .OR. SF2->F2_SERIE= "04H" // Busca e imprime numero do documento caso a NF seja da unidade Recife (serie=0?H)  
// Alterado devido a mudança de serie de notas fiscais emitidas pela filial Recife em 02/09/2003 conf. solicitação de usuario.
//If SF2->F2_SERIE= "02D" .OR. SF2->F2_SERIE= "03D" .OR. SF2->F2_SERIE= "04D" // Busca e imprime numero do documento caso a NF seja da unidade Recife (serie=0?D)
	@ nLin, 065 PSAY xNUM_NF                   // Imprime numero da nota fiscal
ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Dados do Cliente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin += 3
@ nLin, 009 PSAY AllTrim(xNOME_CLI)     //Nome do Cliente
nLin += 1
@ nLin, 009 PSAY xEND_CLI               // Endereco
nLin += 1
@ nLin, 009 PSAY xMUN_CLI               // Municipio
@ nLin, 025 PSAY xEST_CLI               // U.F.

nLin += 1
If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ nLin, 009 PSAY Transform(xCGC_CLI, if(Len(xCGC_CLI) > 11,"@R 99.999.999/9999-99","@R 99.999.999.999-9"))
Endif

@ nLin, 035 PSAY xINSC_CLI              // Insc. Estadual
nLin += 1
@ nLin, 009 PSAY xDATAENT               // Data da Emissao do Documento
@ nLin, 039 PSAY xCCM_CLI               //  Inscricao Municipal (CCM)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados dos Produtos Vendidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin += 3

ImpDet()                 // Detalhe da NF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo dos Impostos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin += 2 
                         
If !Empty(_nCalcISS)
	@ nLin, 015  PSAY  _pAliqISS Picture "@E 999.99"
	@ nLin, 024  PSAY  _nCalcISS Picture "@E 99,999,999.99"
EndIf  

If SF2->F2_DOC >= mv_par01 .AND. SF2->F2_DOC <= mv_paR02
	@ nLin,060  PSAY xTOT_BRUT  Picture "@E@Z 999,999,999.99"   // Valor Total NF - mtdo
//	@ nLin,045  PSAY xTOT_BRUT  Picture "@E@Z 999,999,999.99"   // Valor Total NF
ENDIF

nLin += 12

@ nLin,000 PSAY " "

Return .T.
