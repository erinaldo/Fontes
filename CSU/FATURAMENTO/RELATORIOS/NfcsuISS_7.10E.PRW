/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  NFCSU   � Autor �   ARAUTO SANTANA      � Data � 17/01/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Nota Fiscal de Saida                                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para CSU - CARDSYSTEM                           ���
�������������������������������������������������������������������������Ĵ��
���Manutencoes efetuadas                                                  ���
�������������������������������������������������������������������������Ŀ��
���Analista       � Data   �                                              ���
�������������������������������������������������������������������������Ĵ��
���Marcelo Cardoso�21/02/02�Ajuste para regularizar o salto de impressao  ���
���               �        �de uma nota para outra. O cabecalho cuja im-  ���
���               �        �pressao era feita atraves de coordenadas fixas���
���               �        �passou a tratar as linhas de forma variavel.  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function NFCSUISS7()

//SetPrc(0,0)
/*
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Define Variaveis Ambientais                                  �
//����������������������������������������������������������������


tamanho     := "P"
limite      := 40
titulo      := PADC("Nota Fiscal - NFCSU",74)
cDesc1      := PADC("Este programa ira emitir a Nota Fiscal de Saida",74)
cDesc2      := ""
cDesc3      := PADC("Especifico CSU - CARDSYSTEM",74)
//cNatureza := ""
aReturn     := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog    := "NFCSU"
cPerg       := PADR("NFCSU",LEN(SX1->X1_GRUPO))
nLastKey    := 0
lContinua   := .T.
nLin        := 0
wnrel       := "NFCSU"
nQuantNF    := 0
_TotIRF     := 0
nTamNf      := 40  // Tamanho do Formulario de Nota Fiscal (em Linhas), apenas informativo.
cString     :="SF2"

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//���������������������������������������������������������������������������

//� mv_par01             // Da Nota Fiscal
//� mv_par02             // Ate a Nota Fiscal
//� mv_par03             // Da Serie

Pergunte(cPerg,.F.)      // Pergunta no SX1

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//��������������������������������������������������������������Ŀ
//�                                                              �
//� Inicio do Processamento da Nota Fiscal                       �
//�                                                              �
//����������������������������������������������������������������

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
	
          While SF2->(!eof().and.F2_FILIAL==XFILIAL().AND.F2_DOC<= mv_par02.AND.lContinua)
		
		// Verifica a serie da NF, se for diferente do MV_PAR03, n�o imprime e passa
		// para a pr�xima NF.
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
		
		// De acordo com Lei 10925 NFs menores que 5000 n�o geram impostos (PIS ,COFINS e CSLL)
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
		//Libera��o dos par�metros para impress�o das reten��es - PIS, COFINS, CSLL, IRRF.
		
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
		
		_nCalc135:=(xVAL_IRF+xVAL_COFI+xVAL_PIS+xVAL_CSLL) //Calcula valor total da Lei10833/03 + IRRF- RETIRAR APOS ATUALIZA��O DE RPO / BIN
		
		If xTOT_BRUT == 0
			xTOT_FAT := SF2->F2_VALMERC
		endif
		
		xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
		xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
		xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
		
		// Posiciona no cadastro referente ao cliente em quest�o.
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
		
		// Posiciona no 1o. item da NF de Sa�da para buscar o no. do
		// Pedido de Venda correspondente.
		dbSelectArea("SD2")
		dbSetOrder(3)
		// dbSeek(xFilial("SD2")+xNUM_NF+xSERIE) //aaj
		dbSeek(SF2->F2_FILIAL+xNUM_NF+xSERIE)    //aaj
		
		// Busca informa�oes restantes no cabecalho do Pedido referente a NF em questao.
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial("SC5")+SD2->D2_PEDIDO )
		
		xCOD_MENS    := SC5->C5_MENPAD             // Codigo da Mensagem Padrao
		xMENSAGEM    := AllTrim(SC5->C5_MENNOTA)   // Mensagem para a Nota Fiscal
		XMENSINSS    :="RETEN��O SEGURIDADE SOCIAL = R$ "
		xMENSAGEM2   := Alltrim(SC5->C5_MENNOT2)   // Mensagem para NF referente a IRF
		//                  XMENSIRF     :="RETER 1,5% DE IRF = R$ "
		XMENSMP135   :="T. RETENCAO:R$ " //MENSAGEM MP135 - MTdO
		XMENSIRFF    :="IRFF- "
		XMENSCOFI    :="COFINS- "
		XMENSPIS     :="PIS- "
		XMENSCSLL    :="CSLL- "
		xCOMPETENCIA := Alltrim(SC5->C5_COMPETE)   // Campo de Mensagem solicitado pelo Cliente
		xCONDPAG     := SC5->C5_CONDPAG            // Condicao de Pagamento
		xVECTO       := SC5->C5_DATA1            // DATA DE VENCIMENTO - MTDO
		
		// Busca a descri��o referente a condi��o de pagto. utilizada.
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
		_nCalcISS := 0
		_pAliqISS := 0
		
                    while SD2->(!eof().and.D2_FILIAL+D2_DOC+D2_SERIE==XFILIAL()+xNUM_NF+xSERIE)
			
			// Verifica a serie da NF, se for diferente do MV_PAR03, n�o imprime e passa
			// para a pr�xima NF.
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
		
		//��������������������������������������������������������������Ŀ
		//� Termino da Impressao da Nota Fiscal                          �
		//����������������������������������������������������������������
		
		IncRegua()                    // Termometro de Impressao
		
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
	
Endif

//��������������������������������������������������������������Ŀ
//�                                                              �
//�                      FIM DA IMPRESSAO                        �
//�                                                              �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Fechamento do Programa da Nota Fiscal                        �
//����������������������������������������������������������������


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

//��������������������������������������������������������������Ŀ
//� Fim do Programa                                              �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//�                                                              �
//�                   FUNCOES ESPECIFICAS                        �
//�                                                              �
//����������������������������������������������������������������


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � IMPDET   � Autor �   Marcos Simidu       � Data � 20/12/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao de Linhas de Detalhe da Nota Fiscal              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Nfiscal                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//���������������������Ŀ
//� Inicio da Funcao    �
//�����������������������


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
		cDescPro := Alltrim(xDESC_PRO[I])
		If Len(cDescPro) > 42
			@ nLin, 003  PSAY Substr(cDescPro,1,42)
			nLin += 1
			@ nLin, 003  PSAY Substr(cDescPro,43,len(cDescPro))
		Else
			@ nLin, 003  PSAY cDescPro
		EndIf
		
		@ nLin, 060  PSAY xVAL_MERC[I] Picture "@E 99,999,999.99"
		nLin += 1
		
		If alltrim(xDESC_COMP[I]) <> ""
			@ nLin, 003  PSAY CHR(15)
			If (Len(alltrim(xDESC_COMP[I]))) > 71
				
				@ nLin, 003 PSAY "(" + alltrim(Substr((xDESC_COMP[I]),1,70))
				nLin += 1
				
				if(Len(alltrim(xDESC_COMP[I]))) >71  .and. (Len(alltrim(xDESC_COMP[I]))) < 140
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),71,70))+ ")"
					nLin += 1
				Else
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),71,71))
					nLin += 1
				Endif
				
				if(Len(alltrim(xDESC_COMP[I]))) >140  .and. (Len(alltrim(xDESC_COMP[I]))) < 210
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),140,71))+ ")"
					nLin += 1
				Else
					@ nLin, 003  PSAY alltrim(Substr((xDESC_COMP[I]),140,71))
					nLin += 1
				Endif
				
				if(Len(alltrim(xDESC_COMP[I]))) >210  .and. (Len(alltrim(xDESC_COMP[I]))) <= 280
					@ nLin, 003 PSAY alltrim(Substr((xDESC_COMP[I]),210,Len(alltrim(xDESC_COMP[I])))) + ")"
				Endif
				
			Else
				@ nLin, 003 PSAY  "(" + alltrim(xDESC_COMP[I]) + ")"
			EndIf
			@ nLin, 003  PSAY CHR(18)  
			nLin += 1
		EndIf
		@ nLin, 003  PSAY CHR(18)
		J:=J+1
	Endif
	
	//        nLin += 1 //MTDO
	
Next
@ nLin, 003  PSAY CHR(18)
nLin += 2    //MTDO

If !Empty(xCOMPETENCIA)
	@ nLin, 002  PSAY " COMPET�NCIA :. " + ALLTRIM(xCOMPETENCIA)
	nLin += 1
EndIf

nCol    := 004

//INICIO MTDO
// IMPRIME A MENSAGEM E O VALOR DO INSS   NA NOTA FISCAL
If !Empty(xMensagem)
	@ nLin, 004 PSAY  alltrim(xMENSAGEM)
	nLin += 1
EndIf

If !Empty(xMensagem2)
	@ nLin, 004  PSAY  ALLTRIM(xMensagem2)
	nLin += 1
EndIf

If !Empty(_TotINSS)
	@ nLin, nCol PSAY  alltrim(xMENSINSS)     //+ CHR(18) + CHR(20)
	@ nLin, 034  PSAY  _TotINSS Picture "@E 99,999,999.99"
	nLin += 1
EndIf

//INICIO MTDO
@ nLin, 002 PSAY chr(15)+alltrim(XMENSMP135)     //+ CHR(18) + CHR(20)
@ nLin, 015 PSAY _nCalc135 Picture "@E 9,999,999.99"
@ nLin, 030 PSAY alltrim(XMENSIRFF)
@ nLin, 037 PSAY xVAL_IRF Picture "@E 9,999,999.99"
@ nLin, 050 PSAY alltrim(XMENSCSLL)
@ nLin, 054 PSAY xVAL_CSLL Picture "@E 9,999,999.99"
nLin += 1
@ nLin, 030 PSAY alltrim(XMENSCOFI)
@ nLin, 037 PSAY xVAL_COFI Picture "@E 9,999,999.99"
@ nLin, 050 PSAY alltrim(XMENSPIS)
@ nLin, 054 PSAY xVAL_PIS Picture "@E 9,999,999.99"+chr(18)

Return

Static Function Imprime()

//��������������������������������������������������������������Ŀ
//�                                                              �
//�              IMPRESSAO DA N.F. DA Nfiscal                    �
//�                                                              �
//����������������������������������������������������������������

//�������������������������������������Ŀ
//� Impressao do Cabecalho da N.F.      �
//���������������������������������������
//setprc(0,0)
//@ prow(),pcol() psay chr(27)+"@" // reinicia a impressora
nLin := 6
@ nLin, 040 PSAY xNATUREZA                  // Texto da Natureza de Operacao
@ nLin, 065 PSAY xSERIE                                                         // SERIE NA NF - IDENTIFICA O SITE
nLin += 1
@ nLin, 040 PSAY xPRETSER                   // Cod. de Servico utilizado pelo produto
nLin += 1
@ nLin, 040 PSAY xEMISSAO                   // Data da Emissao do Documento
If SF2->F2_SERIE= "02H" .OR. SF2->F2_SERIE= "03H" .OR. SF2->F2_SERIE= "04H" // Busca e imprime numero do documento caso a NF seja da unidade Recife (serie=0?H)
	// Alterado devido a mudan�a de serie de notas fiscais emitidas pela filial Recife em 02/09/2003 conf. solicita��o de usuario.
	//If SF2->F2_SERIE= "02D" .OR. SF2->F2_SERIE= "03D" .OR. SF2->F2_SERIE= "04D" // Busca e imprime numero do documento caso a NF seja da unidade Recife (serie=0?D)
	@ nLin, 065 PSAY xNUM_NF                   // Imprime numero da nota fiscal
ENDIF


//�������������������������������������Ŀ
//� Impressao dos Dados do Cliente      �
//���������������������������������������

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

//�������������������������������������Ŀ
//� Dados dos Produtos Vendidos         �
//���������������������������������������

nLin += 2

ImpDet()                 // Detalhe da NF

//�������������������������������������Ŀ
//� Calculo dos Impostos                �
//���������������������������������������

nLin := 35
If !Empty(_nCalcISS)
	@ nlin, 015  PSAY  _pAliqISS Picture "@E 999.99"
	@ nlin, 024  PSAY  _nCalcISS Picture "@E 99,999,999.99"
EndIf

If SF2->F2_DOC >= mv_par01 .AND. SF2->F2_DOC <= mv_paR02
	@ nlin,060  PSAY xTOT_BRUT  Picture "@E@Z 999,999,999.99"   // Valor Total NF - mtdo
	//        @ nLin,045  PSAY xTOT_BRUT  Picture "@E@Z 999,999,999.99"   // Valor Total NF
ENDIF

nLin += 13
@ nlin,000 PSAY " " // Ajusta a impressao para o proximo formulario       
@ prow(),pcol() psay chr(27)+"@" // reinicia a impressora
setprc(0,0) // zera o formulario

Return .T.
