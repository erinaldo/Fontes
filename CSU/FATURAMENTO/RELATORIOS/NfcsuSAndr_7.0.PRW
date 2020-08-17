/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  NFSANDR ³ Autor ³   ADALBERTO ALTHOFF   ³ Data ³ 23/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Saida                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para CSU - CARDSYSTEM                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencoes efetuadas                                                  ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista       ³ Data   ³                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function NFSANDR()

//SetPrc(0,0)
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
SetPrvt("XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,X_CLI,XINSC_CLI,NVEZES")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


tamanho     := "G"
limite      := 40
titulo      := PADC("Nota Fiscal - NFCSU",74)
cDesc1      := PADC("Este programa ira emitir a Nota Fiscal de Saida",74)
cDesc2      := ""
cDesc3      := PADC("Especifico CSU - CARDSYSTEM",74)
//cNatureza := ""
aReturn     := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog    := "NFSANDR"
cPerg       := PADR("NFCSU",LEN(SX1->X1_GRUPO))
nLastKey    := 0
lContinua   := .T.
nLin        := 0
wnrel       := "NFSANDR"
nQuantNF    := 0
_TotIRF     := 0
nTamNf      := 40  // Tamanho do Formulario de Nota Fiscal (em Linhas), apenas informativo.
cString     :="SF2"
nVezes      := 0-1

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

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",,Tamanho)

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
	
	//	While !eof() .and. SF2->F2_DOC <= mv_par02 .and. lContinua
	While !eof() .and. SF2->F2_FILIAL==xFILIAL("SF2") .and. SF2->F2_DOC <= mv_par02 .and. lContinua		// sea 03/2005 - erro de impressao.
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
		
		nLinIni := nLin                        // Linha Inicial da Impressao
		
		// Inicio do levantamento dos dados da NF a ser impressa.
		
		xNUM_NF   := SF2->F2_DOC             // Numero
		xSERIE    := SF2->F2_SERIE           // Serie
		xEMISSAO  := SF2->F2_EMISSAO         // Data de Emissao
		xCLIENTE  := SF2->F2_CLIENTE
		xLOJA     := SF2->F2_LOJA
		xTOT_FAT  := SF2->F2_VALFAT          // Valor Total da Fatura
		xVAL_IRF  := SF2->F2_VALIRRF         // Valor do IRF
		xTOT_BRUT := SF2->F2_VALBRUT         //Valor Bruto
		
		// De acordo com Lei 10925 NFs menores que 5000 não geram impostos (PIS ,COFINS e CSLL)
		// Adriano - 28/09/2005
		
		IF xTOT_BRUT <= 5000
			xVAL_CSLL := 0
		ELSE
			xVAL_CSLL := SF2->F2_VALCSLL		// Valor do CSLL
		ENDIF
		
		IF xTOT_BRUT <= 5000
			xVAL_COFI := 0
		ELSE
			xVAL_COFI := SF2->F2_VALCOFI		// Valor do COFINS
		ENDIF
		
		IF xTOT_BRUT <= 5000
			xVAL_PIS := 0
		ELSE
			xVAL_PIS := SF2->F2_VALPIS			// Valor do PIS
		ENDIF
		
		// Verificar se o valor esta de acordo com os parametros que controlam o minimo para retencao
		// Ricardo - 28/07/2004
		// Claudio Alves - 07/06/2005
		//Liberação dos parâmetros para impressão das retenções - PIS, COFINS, CSLL, IRRF.
		
		if xVAL_IRF <=getmv("MV_VLRETIR")
			xVAL_IRF :=0
		endif
		if xVal_csll<=getmv("MV_VRETCSL")
			XVal_Csll:=0
		endif
		if xVal_cofi<=getmv("MV_VRETCOF")
			XVal_Cofi:=0
		endif
		if xVal_csll<=getmv("MV_VRETPIS")
			XVal_Pis:=0
		endif
		
		//		_nCalc135:=(SF2->F2_VALPIS+SF2->F2_VALCOFI+SF2->F2_VALCSLL) //Calcula valor total da Lei10833/03 - VOLTAR APOS ATUALIZAÇÃO DE RPO / BIN
		_nCalc135:=(xVAL_IRF+xVAL_COFI+xVAL_PIS+xVAL_CSLL) //Calcula valor total da Lei10833/03 + IRRF- RETIRAR APOS ATUALIZAÇÃO DE RPO / BIN
		
		If xTOT_BRUT == 0
			xTOT_FAT := SF2->F2_VALMERC
		endif
		
		xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
		xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
		xTIPO       := SF2->F2_TIPO          // Tipo do Cliente
		
		// Posiciona no cadastro referente ao cliente em questão.
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial("SA1")+xCLIENTE+xLOJA )
		
		xNOME_CLI := SA1->A1_NOME              // Nome
		xCGC_CLI  := AllTrim(SA1->A1_CGC)      // CGC
		xINSC_CLI := SA1->A1_INSCR             // Inscricao estadual
		xCCM_CLI  := SA1->A1_INSCRM            //  Inscricao Municipal (CCM)
		xVECTO    := SC5->C5_DATA1             // Vencimento (NF)
		xTOT_FAT  := SF2->F2_VALFAT            // Valor Total da Fatura
		
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
		XMENSINSS    :="INSS = R$ "
		//		XMENSMP135   :="RETER PIS(0,65%)/COFINS(3%)/CSLL(1%)- LEI 10.833/03 = R$" //MENSAGEM MP135 - MTdO
		XMENSMP135   :="T. RETENCAO:R$ " //MENSAGEM MP135 - MTdO
		xMENSAGEM2   := Alltrim(SC5->C5_MENNOT2)   // Mensagem para NF referente a IRF
		XMENSIRFF    :="IRFF- "
		XMENSCOFI    :="COFINS- "
		XMENSPIS     :="PIS- "
		XMENSCSLL    :="CSLL- "
		//		XMENSIRF     :="RETER 1,5% DE IRF = R$ "
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
		nLin += 1 //MTDO
		@ nLin, 003  PSAY CHR(18)
		If Len(xDESC_PRO[I]) > 42
			@ nLin, 014  PSAY Substr((xDESC_PRO[I]),1,42)
			nLin += 1
			@ nLin, 014  PSAY Substr((xDESC_PRO[I]),43,len(xDESC_PRO[I]))
		Else
			@ nLin, 014  PSAY ALLTRIM(xDESC_PRO[I])
		EndIf                                                                                                        
		@ nLin, 050  PSAY CHR(15)
//		@ nLin, 056  PSAY xVAL_MERC[I] Picture "@E 99,999,999.99"
		@ nLin, 060  PSAY xVAL_MERC[I] Picture "@E 99,999,999.99"
		//		nLin += 1
		@ nLin, 008  PSAY CHR(18)
		
		If alltrim(xDESC_COMP[I]) <> ""
			@ nLin, 014  PSAY CHR(15)
			If (Len(alltrim(xDESC_COMP[I]))) > 71
				
				@ nLin, 014 PSAY "(" + alltrim(Substr((xDESC_COMP[I]),1,70))
				nLin += 1
				
				if(Len(alltrim(xDESC_COMP[I]))) >71  .and. (Len(alltrim(xDESC_COMP[I]))) < 140
					@ nLin, 014  PSAY alltrim(Substr((xDESC_COMP[I]),71,70))+ ")"
					nLin += 1
				Else
					@ nLin, 014  PSAY alltrim(Substr((xDESC_COMP[I]),71,71))
					nLin += 1
				Endif
				
				if(Len(alltrim(xDESC_COMP[I]))) >140  .and. (Len(alltrim(xDESC_COMP[I]))) < 210
					@ nLin, 014  PSAY alltrim(Substr((xDESC_COMP[I]),140,71))+ ")"
					nLin += 1
				Else
					@ nLin, 014  PSAY alltrim(Substr((xDESC_COMP[I]),140,71))
					nLin += 1
				Endif
				
				if(Len(alltrim(xDESC_COMP[I]))) >210  .and. (Len(alltrim(xDESC_COMP[I]))) <= 280
					@ nLin, 014 PSAY alltrim(Substr((xDESC_COMP[I]),210,Len(alltrim(xDESC_COMP[I])))) + ")"
				Endif
				
			Else
				@ nLin, 014 PSAY  "(" + alltrim(xDESC_COMP[I]) + ")"
			EndIf
			@ nLin, 003  PSAY CHR(18)
		EndIf
		@ nLin, 003  PSAY CHR(18)
		J:=J+1
	Endif
	
	//	nLin += 1 //MTDO
	
Next
@ nLin, 003  PSAY CHR(18)
nLin += 2    //MTDO

If !Empty(xCOMPETENCIA)
	@ nLin, 007  PSAY " COMPETÊNCIA :. " + ALLTRIM(xCOMPETENCIA)
	nLin += 1
EndIf

nCol    := 009

// IMPRIME A MENSAGEM E O VALOR DO INSS   NA NOTA FISCAL
//INICIO MTDO
@ nLin, pcol() PSAY CHR(15)
If !Empty(xMensagem)
	@ nLin, nCol PSAY  alltrim(xMENSAGEM)
	nLin += 1
EndIf

If !Empty(xMensagem2)
	@ nLin, nCol  PSAY  ALLTRIM(xMensagem2)
	nLin += 1
EndIf

If !Empty(_TotINSS)
	@ nLin, nCol PSAY  alltrim(xMENSINSS)+"  "+tran(_TotINSS,"@E 99,999,999.99")
	nLin ++
EndIf

@ nLin, nCol PSAY padr(alltrim(XMENSMP135),15)+tran(_nCalc135   ,"@E 9,999,999.99")+;
" "+padr(alltrim(XMENSIRFF),08)+tran(xVAL_IRF ,"@E 9,999,999.99")+;
" "+padr(alltrim(XMENSCSLL),08)+tran(xVAL_CSLL,"@E 9,999,999.99")
nLin += 1
@ nLin, nCol+28 PSAY padr(alltrim(XMENSCOFI),08)+tran(xVAL_COFI,"@E 9,999,999.99")+;
" "+padr(alltrim(XMENSPIS),08)+tran(xVAL_PIS,"@E 9,999,999.99")+CHR(18)

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
//setprc(0,0)
//@ prow(),pcol() psay chr(27)+"@" // reinicia a impressora
nLin:=8
nVezes++
@ nLin, 005 PSAY xEMISSAO // Data da Emissao do Documento
@ nLin, 026 PSAY chr(15)+alltrim(xNATUREZA)+chr(18)+""  // Texto da Natureza de Operacao
//@ nLin, 065 PSAY xSERIE						// SERIE NA NF - IDENTIFICA O SITE
//@ nLin, 040 PSAY xPRETSER                   // Cod. de Servico utilizado pelo produto

/*
If SF2->F2_SERIE= "02H" .OR. SF2->F2_SERIE= "03H" .OR. SF2->F2_SERIE= "04H" // Busca e imprime numero do documento caso a NF seja da unidade Recife (serie=0?H)
// Alterado devido a mudança de serie de notas fiscais emitidas pela filial Recife em 02/09/2003 conf. solicitação de usuario.
//If SF2->F2_SERIE= "02D" .OR. SF2->F2_SERIE= "03D" .OR. SF2->F2_SERIE= "04D" // Busca e imprime numero do documento caso a NF seja da unidade Recife (serie=0?D)
@ nLin, 065 PSAY xNUM_NF                   // Imprime numero da nota fiscal
ENDIF
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0ÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Dados do Cliente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//nLin += 1
nLin += 2
@ nLin, 006 PSAY AllTrim(xNOME_CLI)     //Nome do Cliente
//nLin += 2
nLin += 1
@ nLin, 006 PSAY xEND_CLI               // Endereco
//nLin += 1 
nLin += 2
@ nLin, 006 PSAY xMUN_CLI               // Municipio
@ nLin, 023 PSAY xEST_CLI               // U.F.

//nLin += 2
nLin += 1
If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ nLin, 006 PSAY Transform(xCGC_CLI, if(Len(xCGC_CLI) > 11,"@R 99.999.999/9999-99","@R 99.999.999.999-9"))
Endif

@ nLin, 029 PSAY xINSC_CLI              // Insc. Estadual
//nLin += 1
//@ nLin, 009 PSAY xDATAENT               // Data da Emissao do Documento
@ nLin, 052 PSAY xCCM_CLI               //  Inscricao Municipal (CCM)
nLin += 2         //3
@ nLin, 006 PSAY xNUM_NF                   // Imprime numero da nota fiscal
@ nLin, 017 PSAY xVECTO                  // Imprime numero dO vencimento
@ nLin, 027 PSAY xTOT_FAT                   // Imprime valor total nota fiscal

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados dos Produtos Vendidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//nLin += 3
nLin += 2

ImpDet()                 // Detalhe da NF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo dos Impostos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If SF2->F2_DOC >= mv_par01 .AND. SF2->F2_DOC <= mv_paR02
	//@ 039+46*nVezes,054  PSAY xTOT_BRUT  Picture "@E@Z 999,999,999.99"   // Valor Total NF - mtdo
	nLin:=35 // aki
	@ nLin,054 PSAY xTOT_BRUT  Picture "@E@Z 999,999,999.99"   // Valor Total NF
	//AKI
ENDIF
nLin += 13
@ nLin,000 PSAY " " // Ajusta a posicao para o proximo formulario
@ prow(),pcol() psay chr(27)+"@" // reinicia a impressora
setprc(0,0)

Return .T.
