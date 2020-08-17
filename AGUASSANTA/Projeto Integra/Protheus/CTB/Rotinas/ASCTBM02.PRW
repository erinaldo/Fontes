#Include "PROTHEUS.Ch"
#DEFINE MAX_LINHA		999
Static aFormBatch:={}
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBM02
@Efetua a conversão do lançamento contábil na moeda informada
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2017                               '
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTBM02()
Local nOpca 	:= 0
Local aSays 	:= {}
Local aButtons 	:= {}
Local aConv  	:= {}
Local lCC		:= .F.
Local lIT		:= .F.
Local lCL		:= .F.
Local lMV		:= .F.
Local alPergs	:= {}  

Private cCadastro := "Calculo da Variacao Monetaria"
Private cPerg	  := "ASCTM02   "


AjustaSX1()

AjustaCT5()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Data de Apuracao                                 ³
//³ mv_par02 // Numero do Lote			                         ³
//³ mv_par03 // Numero do SubLote		                         ³
//³ mv_par04 // Numero do Documento                              ³
//³ mv_par05 // Cod. Historico Padrao                            ³
//³ mv_par06 // Da Conta  		        				         ³
//³ mv_par07 // Ate a Conta                             		 ³
//³ mv_par08 // Sequencia de Variação Ex.: (2-3,3-1) - 1-2       ³
//³ mv_par09 // Tipo de Saldo 				                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Pergunte("ASCTM02",.T.)

	AADD(aSays, "O programa objetiva apurar a diferenca cambial (Variacao Monetaria) das moedas fortes.")
	AADD(aSays, "O Criterio de conversao e informado no cadastro do Plano de Contas, podendo ser:")
	AADD(aSays, "Medio - a taxa simples entre as cotacoes diarias do periodo.")
	AADD(aSays, "Mensal - a taxa do ultimo dia do mes ou do periodo contabil.")
	AADD(aSays, "Informado - taxa a ser utilizada e informada.")   
	AADD(aSays, "As contabilizações poderão ser simples: ")   
	AADD(aSays, "2-1 --> Calcula variação na moeda 2 e contabiliza na moeda 1")   
	AADD(aSays, "2-3 --> Calcula variação na moeda 2 e contabiliza na moeda 3")   	
	AADD(aSays, "As contabilizações poderão ser combinadas: ")   	
	AADD(aSays, "2-3,3-1 --> Calcula variação na moeda 2 e contabiliza na moeda 3, em seguida da moeda 3 e ")
	AADD(aSays, "            contabiliza na moeda 1.")	
	AADD(aSays, "            Obs. No máximo 2 combinações simultâneas.")		

	AADD(aButtons, { 5,.T., 	{|| (Pergunte("ASCTM02",.T. ), .T.) } } )
	AADD(aButtons, { 1,.T., 	{|| nOpca:= 1, FechaBatch() }} )
	AADD(aButtons, { 2,.T., 	{|| nOpca:= 0, FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )

	lCC	:= IF(MV_PAR11 == 1,.T.,.F.)
	lIT	:= IF(MV_PAR12 == 1,.T.,.F.)
	lCL	:= IF(MV_PAR13 == 1,.T.,.F.)
              
    aConv := STRTOKARR(ALLTRIM(MV_PAR08),",") 

	If nOpca == 1
		If FindFunction("CTBSERIALI")
			If !CTBSerialI("CTBPROC","OFF")
				Return
			Endif
		EndIf
		Processa({|lEnd| CtProc(aConv,lCC,lIT,lCL)},"Efetuando conversão...")
		If FindFunction("CTBSERIALI")
			CtbSerialF("CTBPROC","OFF")
		EndIF
	EndIf
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CtProc    ³ Autor ³ Zema                  ³ Data ³ 28.09.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Recalculo valor lanc moeda forte                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtProc()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ASCTBM02                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtProc(aConv,lCC,lIT,lCl)

Local cAliasQry, lRet := .F.
Local cHistorico 	:= ""
Local bHistorico
Local cCriter, nTaxa := 0, aMedias := CtbMedias(FirstDay(mv_par01), LastDay(mv_par01))
Local nSldMoeda 	:= 0.00
Local nSldMoedForte := 0.00
Local aFormat 		:= {}
Local cDoc 			:= MV_PAR04
Local cLinha 		:= "001"
Local cSeqLan  		:= "000"
Local nValorLanc	:= 0                     
Local nValorGrv		:= 0
Local nValorAux		:= 0
Local cContaRed		:= "", cTipo
Local cContaVar		:= ""
Local cHistPad		:= ""
Local cCustoDeb     := ""
Local cCustoCrd     := ""                                                             
Local cItemDeb      := ""
Local cItemCrd      := ""
Local lAtSldBase	:= Iif(GetMv("MV_ATUSAL")== "S",.T.,.F.)
Local cEmpOri		:= cEmpAnt
Local cFilOri		:= cFilAnt
Local aCampos 		:= {}
Local nMoeda		:= 0
Local cCustoRed		:= ""
Local cCustoVM		:= ""
Local cItemRed		:= ""
Local cItemVM		:= ""
Local cClVlRed		:= ""
Local cClVLVM		:= ""
Local cFilCT1		:= ""
Local cFilCTT		:= ""
Local cFilCTD		:= ""
Local cFilCTH		:= ""
Local lTrueDoc
Local __lCusto		:= .F. 
Local __lItem	  	:= .F. 
Local __lCLVL	  	:= .F. 
Local cMoedaRef	:= ""
Local cMoedaVar	:= ""
Local nTaxaVar    := 0.00
Local aTravas		:= {}
Local nTamDec   := TamSX3("CT2_VALOR")[2]
Local aVlConta	:= {}
Local aVlCusto	:= {}
Local aVlItem	:= {} 
Local cConta :=""
Local cCusto :=""
Local cItem :=""
Local aCols := {}                                                          
Local cVar	:= ""
Local cParDE	:= GETNEWPAR("AS_PARM03","04") // Paridade Dolar Euro                                                                                  
Local cAtuVar	:= ""


CtMoedas(@aCols) 

__lCusto	:= CtbMovSaldo("CTT") .and. lCC
__lItem	  	:= CtbMovSaldo("CTD") .and. lIT
__lCLVL	  	:= CtbMovSaldo("CTH") .and. lCL

aCampos = {; 
{ "TRB_DATA"	,"D", TamSX3("CT2_DATA")[1]		,TamSX3("CT2_DATA")[2]		},;
{ "TRB_LOTE" 	,"C", TamSX3("CT2_LOTE")[1]		,TamSX3("CT2_LOTE")[2]		},;
{ "TRB_SBLOTE"	,"C", TamSX3("CT2_SBLOTE")[1]	,TamSX3("CT2_SBLOTE")[2]	},;
{ "TRB_DOC"		,"C", TamSX3("CT2_DOC")[1]		,TamSX3("CT2_DOC")[2]		},;
{ "TRB_LINHA"	,"C", TamSX3("CT2_LINHA")[1]	,TamSX3("CT2_LINHA")[2]		},;
{ "TRB_FILORI"	,"C", TamSX3("CT2_FILORI")[1]	,TamSX3("CT2_FILORI")[2]	},;
{ "TRB_EMPORI"	,"C", TamSX3("CT2_EMPORI")[1]	,TamSX3("CT2_EMPORI")[2]	},;
{ "TRB_DC"		,"C", TamSX3("CT2_DC")[1]		,TamSX3("CT2_DC")[2]		},;
{ "TRB_DEBITO"	,"C", TamSX3("CT2_DEBITO")[1]	,TamSX3("CT2_DEBITO")[2]	},;
{ "TRB_CREDIT"	,"C", TamSX3("CT2_CREDIT")[1]	,TamSX3("CT2_CREDIT")[2]	},;
{ "TRB_MOEDLC"	,"C", TamSX3("CT2_MOEDLC")[1]	,TamSX3("CT2_MOEDLC")[2]	},;
{ "TRB_VALOR"	,"N", TamSX3("CT2_VALOR")[1]	,TamSX3("CT2_VALOR")[2]		},;
{ "TRB_MOEDAS"	,"C", TamSX3("CT2_MOEDAS")[1]	,TamSX3("CT2_MOEDAS")[2]	},;
{ "TRB_HP"		,"C", TamSX3("CT2_HP")[1]		,TamSX3("CT2_HP")[2]		},;
{ "TRB_CCD"		,"C", TamSX3("CT2_CCD")[1]		,TamSX3("CT2_CCD")[2]		},;
{ "TRB_CCC"		,"C", TamSX3("CT2_CCC")[1]		,TamSX3("CT2_CCC")[2]		},;
{ "TRB_ITEMD"	,"C", TamSX3("CT2_ITEMD")[1]	,TamSX3("CT2_ITEMD")[2]		},;
{ "TRB_ITEMC"	,"C", TamSX3("CT2_ITEMC")[1]	,TamSX3("CT2_ITEMC")[2]		},;
{ "TRB_CLVLDB"	,"C", TamSX3("CT2_CLVLDB")[1]	,TamSX3("CT2_CLVLDB")[2]	},;
{ "TRB_CLVLCR"	,"C", TamSX3("CT2_CLVLCR")[1]	,TamSX3("CT2_CLVLCR")[2]	},;
{ "TRB_HIST"	,"C", TamSX3("CT2_HIST")[1]		,TamSX3("CT2_HIST")[2]		},;
{ "TRB_SEQHIS"	,"C", TamSX3("CT2_SEQHIS")[1]	,TamSX3("CT2_SEQHIS")[2]	},;
{ "TRB_TPSALD"	,"C", TamSX3("CT2_TPSALD")[1]	,TamSX3("CT2_TPSALD")[2]	},;
{ "TRB_SEQLAN"	,"C", TamSX3("CT2_SEQLAN")[1]	,TamSX3("CT2_SEQLAN")[2]	},;
{ "TRB_CRITER"	,"C", TamSX3("CT2_CRITER")[1]	,TamSX3("CT2_CRITER")[2]	},;
{ "TRB_ORIGEM"	,"C", TamSX3("CT2_ORIGEM")[1]	,TamSX3("CT2_ORIGEM")[2]	},;
{ "TRB_ROTINA"	,"C", TamSX3("CT2_ROTINA")[1]	,TamSX3("CT2_ROTINA")[2]	},;
{ "TRB_VLR01"	,"N", TamSX3("CT2_VLR01")[1]	,TamSX3("CT2_VLR01")[2]		},;
{ "TRB_VLR02"	,"N", TamSX3("CT2_VLR02")[1]	,TamSX3("CT2_VLR02")[2]		},;
{ "TRB_VLR03"	,"N", TamSX3("CT2_VLR03")[1]	,TamSX3("CT2_VLR03")[2]		},;
{ "TRB_VLR04"	,"N", TamSX3("CT2_VLR04")[1]	,TamSX3("CT2_VLR04")[2]		},;
{ "TRB_VLR05"	,"N", TamSX3("CT2_VLR05")[1]	,TamSX3("CT2_VLR05")[2]		} }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( "TRB" ) != 0
	TRB->( dbCloseArea() )
EndIf

cNomArq := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )


// Sub-Lote somente eh informado se estiver em branco
mv_par03 := If(Empty(GetMV("MV_SUBLOTE")), mv_par03, GetMV("MV_SUBLOTE"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Antes de iniciar o processamento, verifico os parametros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case Empty(mv_par01) // Data de referencia nao preenchida.
		Help(" ",1,"NOCTBDTLP")
	Case Empty(mv_par02)	// Lote nao preenchido
		Help(" ",1,"NOCT280LOT")
	Case Empty(mv_par03) // Sub Lote nao preenchido
		Help(" ",1,"NOCTSUBLOT")
	Case Empty(mv_par04) 
		Help(" ",1,"NOCT280DOC")
	Case Empty(mv_par05) // Historico Padrao nao preenchido
		Help(" ",1,"CTHPVAZIO")
	Case Empty(mv_par06) .And. Empty(mv_par07)// Rateio inicial e final nao preenchidos.
		Help(" ",1,"NOCT280RT")
	Case Empty(mv_par08)	//Se o codigo da moeda base estiver em branco
		Help(" ",1,"NOCTMOEDA")
	Case Empty(mv_par09) // Tipo de saldo nao preenchido
		Help(" ",1,"NO280TPSLD")
	OtherWise
		lRet := .T.
EndCase
                                        
If lRet	//Verificar se o calendario esta aberto
	lRet	:= CtbValiDt(1,mv_par01,,mv_par09)
EndIf

If lRet  
	IF LEN(aConv) > 2
		ApMsgAlert("As sequencias de conversão poderão ser no máximo 2.")
		lRet := .F.
	ENDIF
ENDIF

IF lRet	
	IF ASCAN(aConv,{|x| SUBSTR(x,1,1) == "1"}) > 0
		lRet  := .F.
		ApMsgAlert("Moeda de cálculo nao podera ser 1, pois não é possivel cadastrar cambio para moeda 1.")
	ENDIF	
EndIf


If lRet // Parametros validos, posiciona o CT8 (Historico padrao)
	dbSelectArea("CT8")
	dbSetOrder(1)
	If !dbSeek(xFilial("CT8")+mv_par05)
		//Historico Padrao nao existe no cadastro.
		Help(" ",1,"CT280NOHP")
		lRet := .F.
	Else
		cHistorico := ""
		If CT8->CT8_IDENT == 'C'
			cHistorico := CT8->CT8_DESC
			// Bloco para historico
			bHistorico := {	||	Alltrim(cHistorico) + " " + StrZero(Month(mv_par01),2)}
			//+"/"+;
			//StrZero(Year(mv_par01),4)+" Moeda: "+cMoedaVar+" Vlr. Moeda base: "+ALLTRIM(STR(nSldMoeda))+"  Saldo Moeda Conv: "+ALLTRIM(STR(nSldMoedForte))+" Taxa: "+STR(nTaxa,8,4) }
		Else
			aFormat := {}
			While !Eof() .And. CT8->CT8_HIST == mv_par05 .And. CT8->CT8_IDENT == 'I'
				Aadd(aFormat,CT8->CT8_DESC)
				dbSkip()
			Enddo
			cHistorico := MSHGetText(aFormat)
			bHistorico := {	||	Alltrim(cHistorico) + " " + StrZero(Month(mv_par01),2)}
			//bHistorico := {||AllTrim(cHistorico)+" Moeda: "+cMoedaVar+" Vlr. Moeda base: "+ALLTRIM(STR(nSldMoeda))+"  Saldo Moeda Conv: "+ALLTRIM(STR(nSldMoedForte))+" Taxa: "+STR(nTaxa,8,4) }
		Endif
	Endif
Endif

If ! lRet
	Return
EndIf

CTP->(DbSetOrder(1))

dbSelectArea("CT1")
dbSetOrder(1)

dbSelectArea("CTT")
dbSetOrder(1)

dbSelectArea("CTD")
dbSetOrder(1)

dbSelectArea("CTH")
dbSetOrder(1)

DbSelectArea("CTO")
dbSetOrder(1)


///////////////////////////////////////////////////////////////////////////////////////
cAlias	:= "QRYTMP"
cQuery := " SELECT CQ1_CONTA CONTA ,'' CUSTO,'' ITEM,'' CLVL, '4' ORDEM, 'CQ1' TABELA " 
cQuery += " FROM "+RetSqlName("CQ1")+" CQ1, "+RetSqlName("CT1")+" CT1 "
cQuery += " WHERE CQ1.CQ1_FILIAL = '"+xFilial("CQ1")+"' "
cQuery += " AND CQ1.CQ1_CONTA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
cQuery += " AND CQ1_DATA <= '"+DTOS(mv_par01)+"' "
cQuery += " AND CQ1_TPSALD = '"+mv_par09+"' "
cQuery += " AND CQ1.D_E_L_E_T_ = '' "
cQuery += " AND CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " AND CT1.CT1_CONTA = CQ1.CQ1_CONTA "
cQuery += " AND CT1.CT1_CLASSE = '2' AND CT1.CT1_CTAVM <> '' "
cQuery += " AND CT1.D_E_L_E_T_ = '' "
cQuery += " GROUP BY CQ1_CONTA"

If __lCusto
	cQuery += " UNION "
	cQuery += " SELECT CQ3_CONTA CONTA ,CQ3_CCUSTO CUSTO,'' ITEM,'' CLVL, '3' ORDEM, 'CQ3' TABELA "
	cQuery += " FROM "+RetSqlName("CQ3")+" CQ3, "+RetSqlName("CTT")+" CTT, "+RetSqlName("CT1")+" CT1 "
	cQuery += " WHERE CQ3.CQ3_FILIAL = '"+xFilial("CQ3")+"' "
	cQuery += " AND CQ3.CQ3_CONTA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
	cQuery += " AND CQ3_DATA <= '"+DTOS(mv_par01)+"' "
	cQuery += " AND CQ3_TPSALD = '"+mv_par09+"' "
	cQuery += " AND CQ3.D_E_L_E_T_ = '' "
	cQuery += " AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "
	cQuery += " AND CTT.CTT_CUSTO = CQ3.CQ3_CCUSTO "
	cQuery += " AND CTT.CTT_CLASSE = '2' "
	cQuery += " AND CTT.D_E_L_E_T_ = '' "
	cQuery += " AND CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
	cQuery += " AND CT1.CT1_CONTA = CQ3.CQ3_CONTA "
	cQuery += " AND CT1.CT1_CLASSE = '2' AND CT1.CT1_CTAVM <> '' "
	cQuery += " AND CT1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY CQ3_CONTA,CQ3_CCUSTO "   
EndIf


If __lItem                                      
	cQuery += " UNION "
	cQuery += " SELECT CQ5_CONTA CONTA ,CQ5_CCUSTO CUSTO,CQ5_ITEM ITEM,'' CLVL,'2' ORDEM, 'CQ5' TABELA " 
//	cQuery += " FROM "+RetSqlName("CQ5")+" CQ5, "+RetSqlName("CTD")+" CTD, "+RetSqlName("CTT")+" CTT, "+RetSqlName("CT1")+" CT1 "
	cQuery += " FROM "+RetSqlName("CQ5")+" CQ5, "+RetSqlName("CTD")+" CTD,"+RetSqlName("CT1")+" CT1 "
	cQuery += " WHERE CQ5.CQ5_FILIAL = '"+xFilial("CQ5")+"' "
	cQuery += " AND CQ5.CQ5_CONTA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
	cQuery += " AND CQ5_DATA <= '"+DTOS(mv_par01)+"' "
	cQuery += " AND CQ5_TPSALD = '"+mv_par09+"' "
	cQuery += " AND CQ5.D_E_L_E_T_ = '' "
	cQuery += " AND CTD.CTD_FILIAL = '"+xFilial("CTD")+"' "
	cQuery += " AND CTD.CTD_ITEM = CQ5.CQ5_ITEM "
	cQuery += " AND CTD.CTD_CLASSE = '2'  "
	cQuery += " AND CTD.D_E_L_E_T_ = '' "

/*	cQuery += " AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "
	cQuery += " AND CTT.CTT_CUSTO = CQ5.CQ5_CCUSTO "
	cQuery += " AND CTT.CTT_CLASSE = '2' "
	cQuery += " AND CTT.D_E_L_E_T_ = '' "
*/
	cQuery += " AND CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
	cQuery += " AND CT1.CT1_CONTA = CQ5.CQ5_CONTA "
	cQuery += " AND CT1.CT1_CLASSE = '2' AND CT1.CT1_CTAVM <> '' "
	cQuery += " AND CT1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY CQ5_CONTA,CQ5_CCUSTO,CQ5_ITEM" 

EndIf

cQuery += " ORDER BY CONTA,ORDEM, CUSTO,ITEM,CLVL "
	
	
cQuery := ChangeQuery(cQuery)
	
If Select(cAlias) > 0
	dbSelectArea(cAlias)
	dbCloseArea()
EndIf
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
cContaAtu := ""
cCustoAtu := ""
cItemAtu  := ""
cClvlAtu  := ""                                       
l2  := .F.
l3  := .F.
DbSelectArea(cAlias)
ProcRegua(Reccount())
dbGoTop()                     
ProcLogIni( {},"ASCTBM02")
ProcLogAtu("MENSAGEM",OemToAnsi("*** INICIO ***  da conversão"),"","ASCTBM02")
While (cAlias)->(!Eof())

	IncProc()
    aVlConta := {0,0}
    aVlCusto := {0,0}
    aVlItem  := {0,0}
    l2  := .F.
	l3  := .F.
	cConta := (cAlias)->CONTA
	CT1->(dbSeek(xFilial("CT1")+(cAlias)->CONTA))

	ProcLogAtu("MENSAGEM","Conta.: "+CT1->CT1_CONTA,"ASCTBM02")

	While (cAlias)->CONTA == cConta .AND.(cAlias)->(!Eof())
    
		cCusto := (cAlias)->CUSTO 
		CTT->(dbSeek(XFILIAL("CTT")+(cAlias)->CUSTO),.T.)
	    aVlCusto := {0,0}
   		aVlItem  := {0,0}

		ProcLogAtu("MENSAGEM","Valores da Conta.: "+ALLTRIM(STR(aVlConta[1]))+"-"+ALLTRIM(STR(aVlConta[2])),"ASCTBM02")

		While (cAlias)->CUSTO == cCusto .AND. (cAlias)->CONTA == cConta .AND.(cAlias)->(!Eof())
			cItem := (cAlias)->ITEM
			CTD->(dbSeek(XFILIAL("CTD")+(cAlias)->ITEM),.T.)
    		aVlItem  := {0,0}

			ProcLogAtu("MENSAGEM","Custo.: "+CTT->CTT_CUSTO,"ASCTBM02")
			ProcLogAtu("MENSAGEM","Valores da Conta.: "+ALLTRIM(STR(aVlConta[1]))+"-"+ALLTRIM(STR(aVlConta[2])),"ASCTBM02")
			ProcLogAtu("MENSAGEM","Valores Custo.: "+ALLTRIM(STR(aVlCusto[1]))+"-"+ALLTRIM(STR(aVlCusto[2])),"ASCTBM02")

			IF !EMPTY(cCusto)
				l3 := .T.
			ENDIF

			While (cAlias)->ITEM == cItem .AND. (cAlias)->CUSTO == cCusto .AND. (cAlias)->CONTA == cConta .AND. (cAlias)->(!Eof())

				ProcLogAtu("MENSAGEM","Item.: "+CTD->CTD_ITEM,"ASCTBM02")
				ProcLogAtu("MENSAGEM","Valores da Conta.: "+ALLTRIM(STR(aVlConta[1]))+"-"+ALLTRIM(STR(aVlConta[2])),"ASCTBM02")
				ProcLogAtu("MENSAGEM","Valores Custo.: "+ALLTRIM(STR(aVlCusto[1]))+"-"+ALLTRIM(STR(aVlCusto[2])),"ASCTBM02")
				ProcLogAtu("MENSAGEM","Valores Item.: "+ALLTRIM(STR(aVlItem[1]))+"-"+ALLTRIM(STR(aVlItem[2])),"ASCTBM02")				

            
				IF !EMPTY(cItem)
					l2 := .T.
				ENDIF

				For nMoeda := 1 to LEN(aConv)
				
					cMoedaVar := STRZERO(VAL(SUBSTR(ALLTRIM(aConv[nMoeda]),1,1)),2) // Moeda do cálculo da variação
					cMoedaRef := STRZERO(VAL(SUBSTR(ALLTRIM(aConv[nMoeda]),3,1)),2) // Moeda que sofre a variação
                	cVar	  := IF(cMoedaRef == "01",cMoedaVar,STRZERO(VAL(cParDE),2)) // Moeda para obter a taxa, se a moeda de vai sofrer a variação não o real, utiliza a taxa de paridade 

					// Taxa da Moeda de variação
					If mv_par14 == 2   // Critério informado no Plano de Contas
						cCriter := &("CT1->CT1_CVD" + cMoedaVar)
					Else	// Critério informado na moeda
						CTO->(dbSeek(xFilial()+cMoedaVar,.T.))
						cCriter := 	CTO->CTO_CRITER
					EndIf
	
					nTaxa := 0
							
					If cCriter == "1" .And. CTP->(DbSeek(xFilial()+DTOS(mv_par01)+cVar))  // Taxa da data do cálculo
						nTaxa := CTP->CTP_TAXA
					ElseIf cCriter == "2"    // Média mensal
						nTaxa := aMedias[VAL(cVar)]
					ElseIf cCriter == "3" .And. CTP->(DbSeek(xFilial()+DTOS(LastDay(mv_par01))+cVar)) // Taxa do último dia do mês do cálculo
						nTaxa := CTP->CTP_TAXA
					ElseIf cCriter == "4"  // Taxa informada no parâmetro
						nTaxa := mv_par10
					EndIf
						                                        
			        IF VALTYPE(nTaxa) <> "N"
						nTaxa := 0
					ENDIF				

					nSldMoeda := 0
					nSldMoedForte := 0				
					
			        IF CT1->CT1_XTPVAR == "S" // Conversão no Saldo Acumulado

				        IF lCC .AND. (cAlias)->TABELA == "CQ3" .AND. !l2
							nSldMoeda := SaldoCt3((cAlias)->CONTA,(cAlias)->CUSTO,mv_par01,cMoedaVar)[1]
						ELSEIF lIT .AND. (cAlias)->TABELA == "CQ5"
							nSldMoeda := SaldoCt4((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,mv_par01,cMoedaVar)[1]
						ELSEIF lCL .AND. (cAlias)->TABELA == "CQ7"
							nSldMoeda := SaldoCtI((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,(cAlias)->CLVL,mv_par01,cMoedaVar)[1]
						ELSEIF  !l2 .AND. !l3
							nSldMoeda := SaldoCt7((cAlias)->CONTA,mv_par01,cMoedaVar)[1]
						ENDIF        
						                          
						If nSldMoeda <> 0
							IF lCC .AND. (cAlias)->TABELA == "CQ3" .AND. !l2
								nSldMoedForte := SaldoCt3((cAlias)->CONTA,(cAlias)->CUSTO,mv_par01,cMoedaRef)[1]
							ELSEIF lIT .AND. (cAlias)->TABELA == "CQ5"
								nSldMoedForte := SaldoCt4((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,mv_par01,cMoedaRef)[1]
							ELSEIF lCL .AND. (cAlias)->TABELA == "CQ7"
								nSldMoedForte := SaldoCtI((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,(cAlias)->CLVL,mv_par01,cMoedaRef)[1]
							ELSEIF !l2 .AND. !l3
								nSldMoedForte := SaldoCt7((cAlias)->CONTA,mv_par01,cMoedaRef)[1]
							ENDIF
						ENDIF
						
					ELSE  // Conversão no Saldo do Movimento
						
				        IF lCC .AND. (cAlias)->TABELA == "CQ3" .AND. !l2     
				        	nSldMoeda := MovCusto((cAlias)->CONTA,(cAlias)->CUSTO,FirstDay(mv_par01),LastDay(mv_par01),cMoedaVar,mv_par09,3)
						ELSEIF lIT .AND. (cAlias)->TABELA == "CQ5"
							nSldMoeda := MovItem((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,FirstDay(mv_par01),LastDay(mv_par01),cMoedaVar,mv_par09,3)
						ELSEIF lCL .AND. (cAlias)->TABELA == "CQ7"    
							nSldMoeda := MovClass((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,(cAlias)->CLVL,FirstDay(mv_par01),LastDay(mv_par01),cMoedaVar,mv_par09,3)
						ELSEIF !l2 .AND. !l3
							nSldMoeda := MovConta((cAlias)->CONTA,FirstDay(mv_par01),LastDay(mv_par01),cMoedaVar,mv_par09,3)
						ENDIF        
					                          

						If nSldMoeda <> 0
		
							IF lCC .AND. (cAlias)->TABELA == "CQ3" .AND. !l2
					        	nSldMoedForte := MovCusto((cAlias)->CONTA,(cAlias)->CUSTO,FirstDay(mv_par01),LastDay(mv_par01),cMoedaRef,mv_par09,3)
							ELSEIF lIT .AND. (cAlias)->TABELA == "CQ5"
								nSldMoedForte := MovItem((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,FirstDay(mv_par01),LastDay(mv_par01),cMoedaRef,mv_par09,3)
							ELSEIF lCL .AND. (cAlias)->TABELA == "CQ7"
								nSldMoedForte := MovClass((cAlias)->CONTA,(cAlias)->CUSTO,(cAlias)->ITEM,(cAlias)->CLVL,FirstDay(mv_par01),LastDay(mv_par01),cMoedaRef,mv_par09,3)
							ELSEIF !l2 .AND. !l3                                                                           
								nSldMoedForte := MovConta((cAlias)->CONTA,FirstDay(mv_par01),LastDay(mv_par01),cMoedaRef,mv_par09,3)
							ENDIF

						ENDIF
					ENDIF

					ProcLogAtu("MENSAGEM","Saldos.: S"+ALLTRIM(STR(nSldMoeda))+"-F"+ALLTRIM(STR(nSldMoedForte))+"-T"+ALLTRIM(STR(nTaxa)),"ASCTBM02")				

					If nTaxa > 0 .AND. nSldMoeda <> 0          
							
						// Saldo na moeda que irá sofrer a variação                                                    
           
						IF cMoedaRef <> "01"	
							nValorLanc := nSldMoeda / nTaxa  // Na moeda de variação, calcula o valor na moeda que sofrerá a conversão de acordo com a taxa
							
							FOR nR := 7 TO 2 STEP -1
								nValorLanc := Round( nValorLanc,nR)								
							NEXT
								
							nValorGrv := Round(nValorLanc - nSldMoedForte,2)    // Valor a ser contabilizado, considerando o valor apurado - o saldo atual
							
	                        IF ABS(nValorGrv) > 0
								IF (cAlias)->TABELA == "CQ3" .AND. !l2
									nValorGrv := nValorGrv - aVlCusto[nMoeda] //aVlCusto[ASCAN(aVlCusto,{|x| ALLTRIM(x[1]) == ALLTRIM(cCusto)})][nMoeda+1]
								ELSEIF (cAlias)->TABELA == "CQ5"
									nValorGrv := nValorGrv - aVlItem[nMoeda] //aVlItem[ASCAN(aVlItem,{|x| ALLTRIM(x[1]) == ALLTRIM(cItem)})][nMoeda+1]
								ELSEIF (cAlias)->TABELA == "CQ1" .AND. !l2 .AND. !l3
									nValorGrv := nValorGrv - aVlConta[nMoeda] //aVlConta[ASCAN(aVlConta,{|x| ALLTRIM(x[1]) == ALLTRIM(cConta)})][nMoeda+1]
								ENDIF      
							ENDIF	
							
							// CARREGA O ACOLS COM CRITERIO E TAXA DA MOEDA BASE
							nMoedPos := Ascan(aCols,{|X|X[1] == cMoedaRef })
							IF nMoedPos > 0
								aCols[nMoedPos][2] := "4"
								aCols[nMoedPos][6] := nTaxa
								aCols[nMoedPos][3] := ABS(nValorGrv)
								aCols[nMoedPos][4] := "1"
							ELSE
								nValorLanc := 0
							ENDIF
														
						ELSE
							nValorLanc := Round(nSldMoeda * nTaxa,2)  // Na moeda de variação, calcula o valor na moeda que sofrerá a conversão de acordo com a taxa
							nValorGrv  := nValorLanc - nSldMoedForte    // Valor a ser contabilizado, considerando o valor apurado - o saldo atual
							
	                        IF ABS(nValorGrv) > 0
								IF (cAlias)->TABELA == "CQ3" .AND. !l2
									nValorGrv := nValorGrv - aVlCusto[nMoeda] //aVlCusto[ASCAN(aVlCusto,{|x| ALLTRIM(x[1]) == ALLTRIM(cCusto)})][nMoeda+1]
								ELSEIF (cAlias)->TABELA == "CQ5"
									nValorGrv := nValorGrv - aVlItem[nMoeda] //aVlItem[ASCAN(aVlItem,{|x| ALLTRIM(x[1]) == ALLTRIM(cItem)})][nMoeda+1]
								ELSEIF (cAlias)->TABELA == "CQ1" .AND. !l2 .AND. !l3
									nValorGrv := nValorGrv - aVlConta[nMoeda] //aVlConta[ASCAN(aVlConta,{|x| ALLTRIM(x[1]) == ALLTRIM(cConta)})][nMoeda+1]
								ENDIF      
							ENDIF	

							// CARREGA O ACOLS COM CRITERIO E TAXA DA MOEDA BASE
							nMoedPos := Ascan(aCols,{|x| x[1] == cMoedaRef })
							IF nMoedPos > 0
								aCols[nMoedPos][2] := "4"
								aCols[nMoedPos][6] := 1
								aCols[nMoedPos][3] := ABS(nValorGrv)
								aCols[nMoedPos][4] := "1"
							ENDIF
						ENDIF

					ENDIF


					ProcLogAtu("MENSAGEM","Contabilizar.: "+ALLTRIM(STR(nValorGrv)),"ASCTBM02")				

                    IF ABS(nValorGrv) > 0

						// Se não informada a conta de redução, considera a propria conta
						If !Empty(ALLTRIM(CT1->CT1_CTARED))
							cContaRed := CT1->CT1_CTARED
						Else
							cContaRed := (cAlias)->CONTA
						EndIf
						cContaVar := CT1->CT1_CTAVM //(cAlias)->CTAVM							
									
					   //Variação Monetaria Negativa
//						IF __lCusto .and. (cAlias)->TABELA == "CQ3"
							cCustoRed		:= CTT->CTT_CUSTO
							cCustoVM		:= ""
//						EndIf
					    //Variação Monetaria Negativa
//						IF __lItem .AND. (cAlias)->TABELA == "CQ5"
							cItemRed	:= CTD->CTD_ITEM
							cItemVM		:= ""
//						EndIf                                      
									
					    //Variação Monetaria Negativa
						IF __lClVl .AND. (cAlias)->TABELA == "CQ7"
							DbSelectArea("CTH")
							DbSeek(xFilial()+(cAlias)->CLVL)
							cClVlRed	:= CTH->CTH_CLVL
							cClVLVM		:= ""
						ENDIF 								
						// Início da proteção de gravação
						If Round(nValorGrv,nTamDec) <> 0.00 
							aTravas := {}
							IF !Empty(cContaVar)
							   AADD(aTravas,cContaVar)
							Endif
							IF !Empty(cContaRed)
							   AADD(aTravas,cContaRed)
							Endif
							
							/// VERIFICA SE O SEMAFORO DE CONTAS PERMITE GRAVAÇÃO DOS LANÇAMENTOS/SALDOS
							If CtbCanGrv(aTravas,@lAtSldBase) 	

 								BEGIN TRANSACTION 

					            CT2->(DbSetOrder(1))        
								CT2->(DbGoTop())
					            If CT2->(MsSeek( xFilial("CT2")+Dtos(mv_par01)+mv_par02+mv_par03+cDoc+cLinha+mv_par09+cEmpOri+cFilOri)) 
						           	lTrueDoc:=.T.
						           	lTrueCT2:=.T.
							 		While lTrueDoc
						               	cChave := xFilial("CT2")+Dtos(mv_par01)+mv_par02+mv_par03+cDoc+cLinha+mv_par09+cEmpOri+cFilOri
										While ! CT2->(Eof()) .and. lTrueCT2
											If CT2->CT2_FILIAL+Dtos(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC==xFilial("CT2")+Dtos(mv_par01)+mv_par02+mv_par03+cDoc .and. CT2->CT2_TPSALD+CT2->CT2_EMPORI+CT2->CT2_FILORI == mv_par09+cEmpOri+cFilOri
									  			CT2->(DbSkip())
									  		Else             
									  			lTrueCT2:=.F.
									  		Endif
										EndDo
							            cDoc := Soma1(cDoc)
							            cLinha := "001"
							           	If CT2->(MsSeek( xFilial("CT2")+Dtos(mv_par01)+mv_par02+mv_par03+cDoc+cLinha+mv_par09+cEmpOri+cFilOri))
								           	lTrueCT2:=.T.
								            Loop
								        Else
								          	lTrueDoc:=.F.   
								        Endif
								  	Enddo       
								EndIf 
	                                    
								cSeqLan  := Soma1(cSeqLan)
	
								// Saldo Credor e Variação positiva - credita a conta
								If 	nSldMoeda > 0 .AND. nValorGrv > 0                                  
									IF cMoedaRef <> "01"  
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01"/*cMoedaRef*/,mv_par05,cContaVar,cContaRed,cCustoVM,cCustoRed,cItemVM,cItemRed,cClVlVM,cClVlRed,0.00,Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF										
									IF cMoedaRef == "01"  
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01",mv_par05,cContaVar,cContaRed,cCustoVM,cCustoRed,cItemVM,cItemRed,cClVlVM,cClVlRed,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ELSE
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3",cMoedaRef,mv_par05,cContaVar,cContaRed,cCustoVM,cCustoRed,cItemVM,cItemRed,cClVlVM,cClVlRed,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF        
									
									//cAtuVar := "DEBITO VAR"								
					                 
								// Saldo Credor e Variação negativa - debita a conta
	   							ElseIf nSldMoeda > 0 .AND. nValorGrv < 0 
									IF cMoedaRef <> "01"   								
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01" /*cMoedaRef*/,mv_par05,cContaRed,cContaVar,cCustoRed,cCustoVM,cItemRed,cItemVM,cCLVLRed,cClVLVM,0.00,Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF
									IF cMoedaRef == "01"
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01",mv_par05,cContaRed,cContaVar,cCustoRed,cCustoVM,cItemRed,cItemVM,cCLVLRed,cClVLVM,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ELSE
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3",cMoedaRef,mv_par05,cContaRed,cContaVar,cCustoRed,cCustoVM,cItemRed,cItemVM,cCLVLRed,cClVLVM,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF
					                  				                                      
								// Saldo Devedor e Variação positiva - credita conta
								ElseIf 	nSldMoeda < 0 .AND. nValorGrv > 0 
									IF cMoedaRef <> "01"								
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01" /*cMoedaRef*/,mv_par05,cContaVar,cContaRed,cCustoVM,cCustoRed,cItemVM,cItemRed,cCLVLVM,cClVlRed,0.00,Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF
									IF cMoedaRef == "01"
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01",mv_par05,cContaVar,cContaRed,cCustoVM,cCustoRed,cItemVM,cItemRed,cCLVLVM,cClVlRed,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ELSE
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3",cMoedaRef,mv_par05,cContaVar,cContaRed,cCustoVM,cCustoRed,cItemVM,cItemRed,cCLVLVM,cClVlRed,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF
								// Saldo Devedor e Variação negativa - debita a conta
								ElseIf 	nSldMoeda < 0 .AND. nValorGrv < 0 
									IF cMoedaRef <> "01"									
						 				GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01" /*cMoedaRef*/,mv_par05,cContaRed,cContaVar,cCustoRed,cCustoVM,cItemRed,cItemVM,cClVlRed,cCLVLVM,0.00,Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF
									IF cMoedaRef == "01"					 						
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3","01",mv_par05,cContaRed,cContaVar,cCustoRed,cCustoVM,cItemRed,cItemVM,cClVlRed,cCLVLVM,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ELSE
										GravaLanc(mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3",cMoedaRef,mv_par05,cContaRed,cContaVar,cCustoRed,cCustoVM,cItemRed,cItemVM,cClVlRed,cCLVLVM,Abs(nValorGrv),Eval(bHistorico),mv_par09,@cSeqLan,3,lAtSldBase,aCols,cEmpOri,cFilOri,,,,,,"ASCTBM02")
									ENDIF
	
			  	            	EndIf
	
								RECLOCK("SZ3",.T.)
							    SZ3->Z3_FILIAL := XFILIAL("SZ3")
							    SZ3->Z3_DTBASE := mv_par01
							    SZ3->Z3_EMP	   := cEmpAnt+cFilAnt
							    SZ3->Z3_EMPPAR := cEmpAnt+cFilAnt
							    SZ3->Z3_EVENTO := ""                     
							    SZ3->Z3_CONTA  := cConta
							    SZ3->Z3_FORMULA:= STR(nTaxa,8,4)  // Taxa                               
							    SZ3->Z3_CTRESE := cMoedaRef       // Moeda destino
							    SZ3->Z3_MOEDA  := cMoedaVar       // Moeda origem
							    SZ3->Z3_VALOR  := nSldMoeda       // Saldo na moeda a ser convertida
							    SZ3->Z3_CTRESN := ALLTRIM(STR(nSldMoedForte)) // Saldo na Moeda forte			    			    			    
								SZ3->Z3_CTMEPRP:= ALLTRIM(STR(nValorLanc))		    
								SZ3->Z3_VALCTB := Abs(nValorGrv)  // Valor de Variação
							    SZ3->Z3_CT2    := CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC)
				           		MsUnlock()
								                                 
								cSeqLan  		:= CT2->CT2_SEQLAN								
                    

            					CtbGravSaldo(	CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,;
									CT2->CT2_DATA,"3",cMoedaRef,;
									CT2->CT2_DEBITO,CT2->CT2_CREDIT,;
									CT2->CT2_CCD,CT2->CT2_CCC,CT2->CT2_ITEMD,CT2->CT2_ITEMC,;
			 						CT2->CT2_CLVLDB,CT2->CT2_CLVLCR,CT2->CT2_VALOR,;
			 						CT2->CT2_TPSALD,3,"","","","","","","","",0," ",;
		 							" ", "  ",  __lCusto,__lItem,__lClVL, 0.00,,,,,,,,,,,,,"+"/*cOperacao*/)					

	                            END TRANSACTION
								
				            EndIf 
				            
						EndIf               		
						aVlConta[nMoeda] := aVlConta[nMoeda] + nValorGrv
						aVlCusto[nMoeda] := aVlCusto[nMoeda] + nValorGrv
						aVlItem[nMoeda]  := aVlItem[nMoeda] + nValorGrv

						nValorGrv  :=0
					ENDIF
				Next nMoeda
				cLinha	:= Soma1(cLinha)					
				(cAlias)->(DbSkip())
			EndDo	      	   	   
		EndDo	      	   
	EndDo	      	   
EndDo	   

If Select(cAlias) > 0
	dbSelectArea(cAlias)
	dbCloseArea()
EndIf            

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FormBatch³ Autor ³ Juan Jose Pereira	    ³ Data ³ 04/12/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta tela generica para processo batch					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FormBatch( cTitle, aSays, aButtons, lOk, bValid )		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ cTitle = Titulo da janela								  ³±±
±±³			 ³ aSays  = Array com Says 									  ³±±
±±³			 ³ aButtons = Array com bottoes								  ³±±
±±³			 ³ aButtons[i,1] = Tipo de botao 							  ³±±
±±³			 ³ aButtons[i,2] = Tipo de enabled							  ³±±
±±³			 ³ aButtons[i,3] = bAction 									  ³±±
±±³			 ³ aButtons[i,4] = Hint do Botao							  ³±±
±±³			 ³ bValid = Bloco de validacao do Form 						  ³±±
±±³			 ³ nAltura= Altura do Form em Pixel (Default 250)			  ³±±
±±³			 ³ nLargura = Largura do Form em Pixel (Default 520)		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#DEFINE LARGURA_DO_SBUTTON 32

Static Function FormBatch( cTitle, aSays, aButtons, bValid, nAltura, nLargura )

Local nButtons:= Len(aButtons),;
nSays:= Len(aSays),;
oSay,;
i,nTop, nType, lEnabled, oFormPai, oFont,;
nLarguraBox, nAlturaBox, nLarguraSay, cTextSay

DEFAULT aSays:={}, aButtons:={}
DEFAULT nAltura:= 250, nLargura:= 520

// Numero maximo de linhas //
If( nSays>7 )
	nSays:=7
EndIf

// Numero maximo de botoes //
If( nButtons>5 )
	nButtons:= 5
EndIf

oFormPai:= Atail(aFormBatch)
If( oFormPai==NIL )
	oFormPai:= oMainWnd
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -11

DEFINE MSDIALOG oDlg TITLE cTitle FROM 0,0 TO nAltura,nLargura OF oFormPai PIXEL

AADD(aFormBatch,oDlg)

nAlturaBox:= (nAltura-60)/2
nLarguraBox:= (nLargura-20)/2
@ 10,10 TO nAlturaBox,nLarguraBox OF oDlg PIXEL

//======================================================//
// monta says (bof)												 //
//======================================================//
nTop:=20

nLarguraSay:= nLarguraBox-30
For i:=1 to nSays
	cTextSay:= "{||'"+aSays[i]+"'}"
	oSay := TSay():New( nTop, 20, MontaBlock(cTextSay),oDlg,, oFont, .F., .F., .F., .T.,,, nLarguraSay, 10, .F., .F., .F., .F., .F. )
	nTop+= 10
Next

//======================================================//
// monta bottoes(bof) 											 //
//======================================================//
nPosIni:= ((nLargura-20)/2) - (nButtons* LARGURA_DO_SBUTTON )
nAlturaButton:= nAlturaBox+10

For i:=1 to nButtons
	nType:= aButtons[i,1]
	lEnabled:= aButtons[i,2]
	
	DEFAULT lEnabled:= .T.
	
	If lEnabled
		If Len(aButtons[i]) > 3 .And. ValType(aButtons[i,4]) == "C"
			SButton():New( nAlturaButton, nPosIni, nType,aButtons[i,3],oDlg,.T.,aButtons[i,4])
		Else
			SButton():New( nAlturaButton, nPosIni, nType,aButtons[i,3],oDlg,.T.,,)
		Endif
	Else
		SButton():New( nAlturaButton, nPosIni, nType,,oDlg,.F.,,)
	EndIf
	
	nPosIni+= LARGURA_DO_SBUTTON
Next
//======================================================//
// monta bottoes(bof) 											 //
//======================================================//
oDlg:Activate( ,,,.T.,bValid,,,, )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±Fun‡„o	 ³FechaBatch³ Autor ³ Juan Jose Pereira	    ³ Data ³ 04/12/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fecha Ultima tela de batch 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FechaBatch()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FechaBatch()

Local oDlg:= Atail( aFormBatch )

oDlg:End()

ASize( aFormBatch,Len(aFormBatch)-1 )

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaCT5    ³Autor ³  Lucas               ³Data³ 07/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajustar o arquivo de lanamentos padronizados para contabilização da rotina de variação monetária.            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaCT5()
Local aArea := GetArea()
Local aLactoCT5 :={}
Local nI

// Corregido error de sintaxis en la posicion 8 = If(mv_par11==1  .and. !Empty(TRB->TRB_DEBITO,TRB->TRB_VALOR,0) (Ariel 12/07/04)
// Corregido error de sintaxis en la posicion 17 = Debe ser character "Asiento XXX Secuencia... (Ariel 12/07/04)
AADD(aLactoCT5,{ "XXX","001","VARIACIÓN MONETARIA","1","TRB->TRB_DEBITO","                                   ", "123","If(mv_par10==1  .and. !Empty(TRB->TRB_DEBITO),TRB->TRB_VALOR,0)" ,"","","","","TRB->TRB_HIST","","","",'"CTBA381"',"2","","","","","","","1","01","001", ""}) //El campo CT5_DTVENC es Character eliminado CTOD (Ariel 09/07/04)
AADD(aLactoCT5,{ "XXX","002","VARIACIÓN MONETARIA","2","                                   ","TRB->TRB_CREDIT", "123","If(mv_par10==1  .and. !Empty(TRB->TRB_CREDIT),TRB->TRB_VALOR,0)","","","","","TRB->TRB_HIST","","","",'"CTBA381"',"2","","","","","","","1","01","002", ""}) //El campo CT5_DTVENC es Character eliminado CTOD (Ariel 09/07/04)
AADD(aLactoCT5,{ "XXX","003","VARIACIÓN MONETARIA","3","TRB->TRB_DEBITO","TRB->TRB_CREDIT", "123","If(mv_par10==2,TRB->TRB_VALOR,0)"                                                             ,"","","","","TRB->TRB_HIST","","","",'"CTBA381"',"2","","","","","","","1","01","003", ""}) //El campo CT5_DTVENC es Character eliminado CTOD (Ariel 09/07/04)

DbSelectArea("CT5")
For nI := 1 to Len(aLactoCT5)
	If ! DbSeek(xFilial("CT5")+aLactoCT5[nI][01]+aLactoCT5[nI][02])
		RecLock("CT5",.T.)
		Replace CT5_FILIAL		With xFilial("CT5")
		Replace CT5_LANPAD	With aLactoCT5[nI][01]
		Replace CT5_SEQUEN	With aLactoCT5[nI][02]
		Replace CT5_DESC			With aLactoCT5[nI][03]
		Replace CT5_DC				With aLactoCT5[nI][04]
		Replace CT5_DEBITO		With aLactoCT5[nI][05]
		Replace CT5_CREDIT		With aLactoCT5[nI][06]
		Replace CT5_MOEDAS	With aLactoCT5[nI][07]
		Replace CT5_VLR01		With aLactoCT5[nI][08]
		Replace CT5_VLR02		With aLactoCT5[nI][09]
		Replace CT5_VLR03		With aLactoCT5[nI][10]
		Replace CT5_VLR04		With aLactoCT5[nI][11]
		Replace CT5_VLR05		With aLactoCT5[nI][12]
		Replace CT5_HIST			With aLactoCT5[nI][13]
		Replace CT5_HAGLUT	With aLactoCT5[nI][14]
		Replace CT5_CCD			With aLactoCT5[nI][15]
		Replace CT5_CCC			With aLactoCT5[nI][16]
		Replace CT5_ORIGEM	With aLactoCT5[nI][17]
		Replace CT5_INTERC		With aLactoCT5[nI][18]
		Replace CT5_ITEMD		With aLactoCT5[nI][19]
		Replace CT5_ITEMC		With aLactoCT5[nI][20]
		Replace CT5_CLVLDB	With aLactoCT5[nI][21]
		Replace CT5_CLVLCR	With aLactoCT5[nI][22]
		Replace CT5_ATIVDE		With aLactoCT5[nI][23]
		Replace CT5_ATIVCR		With aLactoCT5[nI][24]
		Replace CT5_TPSALD		With aLactoCT5[nI][25]
		Replace CT5_MOEDLC	With aLactoCT5[nI][26]
		Replace CT5_SBLOTE		With aLactoCT5[nI][27]
		Replace CT5_DTVENC	With aLactoCT5[nI][28]
		MsUnLock()
	EndIf
Next nI
RestArea( aArea )
Return

Static Function AjustaSX1

IF SX1->(!DBSEEK(cPerg+"01"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "01"; SX1->X1_PERGUNT:= "Data de Apuracao"; SX1->X1_VARIAVL:= "mv_ch1"; SX1->X1_TIPO:= "D"; SX1->X1_TAMANHO:= 8
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR01";	SX1->X1_DEF01:= ""; SX1->X1_DEF02:= "";	SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"02"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "02"; SX1->X1_PERGUNT:= "Numero do Lote"; SX1->X1_VARIAVL:= "mv_ch2"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= 6
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G";	SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR02"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= "";	SX1->X1_DEF05:= ""; SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               
                                                                                               
IF SX1->(!DBSEEK(cPerg+"03"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "03"; SX1->X1_PERGUNT:= "Numero do SubLote"; SX1->X1_VARIAVL:= "mv_ch3"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= 3
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR03"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               
 	
IF SX1->(!DBSEEK(cPerg+"04"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "04"; SX1->X1_PERGUNT:= "Numero do Documento"; SX1->X1_VARIAVL:= "mv_ch4"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= 6
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR04"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               
    
IF SX1->(!DBSEEK(cPerg+"05"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "05"; SX1->X1_PERGUNT:= "Cod. Historico Padrao"; SX1->X1_VARIAVL:= "mv_ch5"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= 3
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR05"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= "CT8"
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"06"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "06"; SX1->X1_PERGUNT:= "Da Conta"; SX1->X1_VARIAVL:= "mv_ch6"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= TamSx3('CT1_CONTA')[1]
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR06"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= "CT1"
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"07"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "07"; SX1->X1_PERGUNT:= "Até a Conta"; SX1->X1_VARIAVL:= "mv_ch7"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= TamSx3('CT1_CONTA')[1]
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR07"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= "CT1"
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"08"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "08"; SX1->X1_PERGUNT:= "Sequencia de Variação:"; SX1->X1_VARIAVL:= "mv_ch8"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= 8
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR08"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"09"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "09"; SX1->X1_PERGUNT:= "Tipo de Saldo"; SX1->X1_VARIAVL:= "mv_ch9"; SX1->X1_TIPO:= "C"; SX1->X1_TAMANHO:= 1
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR09"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= "SLD"
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"10"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "10"; SX1->X1_PERGUNT:= "Taxa de conversao informada"; SX1->X1_VARIAVL:= "mv_cha"; SX1->X1_TIPO:= "N"; SX1->X1_TAMANHO:= 8
 	SX1->X1_DECIMAL:= 4; SX1->X1_GSC:= "G"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR10"; SX1->X1_DEF01:= ""; SX1->X1_DEF02:= ""; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"11"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "11"; SX1->X1_PERGUNT:= "Considera C. Custo?"; SX1->X1_VARIAVL:= "mv_chb"; SX1->X1_TIPO:= "N"; SX1->X1_TAMANHO:= 1
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "C"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR11"; SX1->X1_DEF01:= "Sim"; SX1->X1_DEF02:= "Nao"; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"12"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "12"; SX1->X1_PERGUNT:= "Considera Item?"; SX1->X1_VARIAVL:= "mv_chc"; SX1->X1_TIPO:= "N"; SX1->X1_TAMANHO:= 1
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "C"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR12"; SX1->X1_DEF01:= "Sim"; SX1->X1_DEF02:= "Nao"; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"13"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "13"; SX1->X1_PERGUNT:= "Considera Clvl?"; SX1->X1_VARIAVL:= "mv_chd"; SX1->X1_TIPO:= "N"; SX1->X1_TAMANHO:= 1
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "C"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR13"; SX1->X1_DEF01:= "Sim"; SX1->X1_DEF02:= "Nao"; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               

IF SX1->(!DBSEEK(cPerg+"14"))
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO:= cPerg; SX1->X1_ORDEM:= "14"; SX1->X1_PERGUNT:= "Considera Critério?"; SX1->X1_VARIAVL:= "mv_che"; SX1->X1_TIPO:= "N"; SX1->X1_TAMANHO:= 1
 	SX1->X1_DECIMAL:= 0; SX1->X1_GSC:= "C"; SX1->X1_VALID:= ""; SX1->X1_VAR01:= "MV_PAR14"; SX1->X1_DEF01:= "Moeda"; SX1->X1_DEF02:= "Plano de Contas"; SX1->X1_DEF03:= ""
 	SX1->X1_DEF04:= ""; SX1->X1_DEF05:= "";	SX1->X1_F3:= ""
	MsUnlock()
ENDIF 	               

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtMoedas    ³ Autor ³ Davi Torchio        ³ Data ³ 18.01.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega Array com as moedas para calculo de variacao       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtMoedas(aCols,cMoeda)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.					                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Ctba381    			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array a ser preenchida com moedas para calculo     ³±±
±±³          ³ ExpC1 = Moeda especifica a ser recarregado aCols           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CtMoedas(aCols, cMoeda)

Local aMedias := CtbMedias(mv_par01)
Local nTaxa, lAddCols := Len(aCols) = 0, cCriter
Local cBloq	:= ""

dbSelectArea("CTO")
dbSetOrder(1)
If cMoeda = Nil
	dbSeek(xFilial("CTO"))
Else
	dbSeek(xFilial("CTO")+cMoeda,.T.)
Endif
CTP->(DbSetOrder(1))

While !Eof() .And. CTO->CTO_FILIAL == XFILIAL("CTO")
	
	If CTO->CTO_MOEDA = "01"
		DbSkip()
		Loop
	Endif
	
	nTaxa 	:= 0.00
	cCriter := If(lAddCols, CTO->CTO_CRITER, aCols[Val(CTO->CTO_MOEDA) - 1][2])
	
	If cCriter = "1" .And. CTP->(DbSeek(xFilial()+DTOS(mv_par01)+CTO->CTO_MOEDA))
		nTaxa := CTP->CTP_TAXA
	ElseIf cCriter = "2"
		nTaxa := aMedias[Val(CTO->CTO_MOEDA)]
	ElseIf cCriter = "3"
		aDatas 	:= CTBPeriodos(CTO->CTO_MOEDA,mv_par01,,, .F. )		// Retorna data inicial e final
		dbSelectArea("CTP")
		dbSetOrder(1)
		If MsSeek(xFilial()+DTOS(aDatas[1][2])+CTO->CTO_MOEDA)
			cBloq := If(cBloq = Nil, CTP->CTP_BLOQ, cBloq)
			If  cBloq <> "1"	// Moeda não bloqueada
				nTaxa := CTP->CTP_TAXA
			EndIf
		EndIf
		dbSelectArea("CTO")
	ElseIf cCriter = "4"
		nTaxa := If(lAddCols, CTO->CTO_TXINF, aCols[Val(CTO->CTO_MOEDA) - 1][6])
	Endif
	
	If lAddCols
		AADD(aCols, { CTO->CTO_MOEDA, CTO->CTO_CRITER, 0.00, "2", CTO->CTO_BLOQ,;
		nTaxa, CTO->CTO_DESC, CTO->CTO_MOEDA <> "01" } )
	Else
		aCols[Val(CTO->CTO_MOEDA) - 1][6] := nTaxa
	Endif
	
	If cMoeda <> Nil
		Exit
	Endif
	
	DbSkip()
EndDo                                                                             

If cMoeda = Nil// .And. Len(aCols) = 0
	DbSelectArea("CTO")
	dbSeek(xFilial()+"01",.T.)
	AADD(aCols, { "01", " ", 0.00, "2", "1", 0.00, CTO->CTO_DESC, .F. } )
Endif
                                  
Return .T.            
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBTX
@Efetua a conversão do lançamento contábil na moeda informada
@param		pVal - Valor digitado
            pMoeda - Moeda a converter
            pData - Data de converão
@return		Nenhum
@author 	Zema
@since 		20/04/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTBTX(pVal, pMoeda1, pMoeda2, pData)
Local aArea		:= GetArea()
Local nValDig 	:= IF(VALTYPE(pVal)=="N",pVal,0)
Local cMoedaConv:= IF(VALTYPE(pMoeda1)=="C",pMoeda1,"")
Local cMoedaDes	:= IF(VALTYPE(pMoeda2)=="C",pMoeda2,"")
Local dDataConv	:= IF(VALTYPE(pData)=="D",pData,dDataBase)
Local nValConv	:= 0        
Local nTaxa		:= 0

CTP->(DBSETORDER(1))
IF CTP->(DbSeek(xFilial("CTP")+DTOS(dDataConv)+cMoedaConv))
	nTaxa := CTP->CTP_TAXA

	// Moeda de Conversão - Dolar Destino Euros
	IF cMoedaConv == "04" .AND. cMoedaDes == "03"
		CTE->(DBSETORDER(1))
		IF CTE->(DBSEEK(XFILIAL("CTE")+cMoedaDes))
			nValConv:= nValDig / nTaxa
			FOR nR := 7 TO 2 STEP -1
				nValConv := Round( nValConv,nR)								
			NEXT			
			nValConv:= Round(nValConv,2)
		ENDIF
	ENDIF
	
	// Moeda de Conversão - Euro Destino Reais
	IF cMoedaConv == "03" .AND. cMoedaDes == "01" 
		nValConv:= Round(nValDig * nTaxa,2)
	ENDIF	
	
	// Moeda de Conversão - Dolar Destino Reais
	IF cMoedaConv == "02" .AND. cMoedaDes == "01" .AND. EMPTY(M->CT2_VALR03)
		nValConv:= Round(nValDig * nTaxa,2)
	ENDIF

ENDIF
RestArea(aArea)

RETURN(nValConv)    