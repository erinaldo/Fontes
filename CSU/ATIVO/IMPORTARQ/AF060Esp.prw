#define STR0001 "Pesquisar"
#define STR0002 "Visualizar"
#define STR0003 "Transferir"
#define STR0004 "Automatico"
#define STR0005 "Transferencia de Ativos"
#define STR0006 "Confirma"
#define STR0007 "Redigita"
#define STR0008 "Abandona"
#define STR0009 "Quanto a transferencia ? "
#define STR0010 "Dados do Bem"
#define STR0011 "Dados Contabeis"
#define STR0012 "Origem"
#define STR0013 "Destino"
#define STR0014 "Codigo"
#define STR0015 "Item"
#define STR0016 "Tipo"
#define STR0017 "Descricao"
#define STR0018 "Quant.Atual"
#define STR0019 "Custo Atualizado"
#define STR0020 "Valor Residual"
#define STR0021 "Data"
#define STR0022 "Bem"
#define STR0023 "Correcao Monetaria"
#define STR0024 "Desp.Deprec."
#define STR0025 "Depr.Acumul."
#define STR0026 "Corr.Mon.Depr."
#define STR0027 "Centro Custo"
#define STR0028 "Endereco"
#define STR0029 "Transferir para"
#define STR0030 "Do Codigo:"
#define STR0031 "Ao Codigo:"
#define STR0032 "Conta"
#define STR0033 "Destino"
#define STR0034 "Bem"
#define STR0035 "Correcao Monetaria"
#define STR0036 "Despesa Depreciacao"
#define STR0037 "Depreciacao Acum."
#define STR0038 "Correcao Mon. Depr."
#define STR0039 "Centro de Custo"
#define STR0040 "Endereco"
#define STR0041 "Selecionando Registros..."
#define STR0042 "Transferencia Automatica"
#define STR0043 "Total de Bens...."
#define STR0044 "Atualizando"
#define STR0045 "Filial Destino"
#define STR0046 "trans. Resp."
#define STR0047 "Filtrar Origem"
#define STR0048 "(*) Destino = Origem"
#define STR0049 "A Database do sistema deve ter o mês igual ao parâmetro MV_ULTDEPR = "
#define STR0050 "A Data do último cálculo de depreciação da Filial Origem está diferente da Filial Destino "
#define STR0051 "Filial Origem = "
#define STR0052 "Filial Destino = "
#define STR0053 "A transferência não poderá ser realizada para esta Filial"
#define STR0054 "Nota Fiscal"
#define STR0055 "Série"
#define STR0056 "Fornecedor"
#define STR0057 "Grupo"

#Include "FiveWin.ch"
#Include "protheus.ch"

#Define CONFIRMA 1
#Define REDIGITA 2
#Define ABANDONA 3
Static lAF060GSN4 := ExistBlock("AF060GSN4")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AF060Trans ³ Autor ³ Wagner Xavier		    ³ Data ³ 03/08/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Transferˆncia de ativos 					 	       			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 													             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AF060Esp(	cAlias,nReg,nOpc,cExpFiltro,ParDtTrans,ParTxDepr,ParFilDest,ParCCDest,ParEndDest,ParCtBemDest,ParCtCMDest,ParCtDspDest,ParCtDeprDest,ParCtCMDDest,ParCcBemDest,ParCcCMDest,ParCcDspDest,ParCcDeprDest,ParCcCMDDest,;
								ParSUBCCON,ParSUBCCOR,ParSUBCDEP,ParSUBCCDE,ParSUBCDES,ParCLVLCON,ParCLVLCOR,ParCLVLDEP,ParCLVLCDE,ParCLVLDES,ParCLVL,ParSubCTA)
Local oDlg
Local nOpt				:= 1
Local cBase 			:= CriaVar( "N1_CBASE" , .f. )
Local cItem 			:= Space(4)
Local dDataTrans		:= dDataBase
Local oBaseI
Local oBaseF      	
Local lGspInUseM 		:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local nCustAtu 		:= 0, nValResid := 0
//Local cLoteAtf 		:= LoteCont("ATF")
Local cLoteAtf 		:= "500000"
Local nHdlPrv			:= 0
Local cArquivo			:= ""
Local lCtb      		:= CtbInUse(), cAliasCta, cAliasCus, cAliasIt, cAliasCl
Local aCtb			// Variavel para contabilizacao entre filiais
Local aTitFolder 		:= { "Conta contabil" }
Local aPages	 		:= {}
Local oPai
Local nLin				:= nPanelBem := 0
Local lCC				:= (lGspInUseM .Or. CtbMovSaldo("CTT"))
Local lItem				:= (! lGspInUseM .And. CtbMovSaldo("CTD"))
Local lClVl				:= (! lGspInUseM .And. CtbMovSaldo("CTH"))
Local lFolder     	:= .F.
Local bConta			:= { |cConta| 	Left(If(lCtb, (CT1->(MsSeek(xFilial("CT1") + cConta)), CT1->CT1_DESC01),;
												  If(lGspInUseM, (NI1->(MsSeek(xFilial("NI1") + cConta)), NI1->NI1_DESC),;
												 		     (SI1->(MsSeek(xFilial("SI1") + cConta)), SI1->I1_DESC))), 16) }
Local bCC    			:= { |cCc   | 	Left(If(lCtb, (CTT->(MsSeek(xFilial("CTT") + cCc)), CTT->CTT_DESC01),;
												  If(lGspInUseM, (NI3->(MsSeek(xFilial("NI3") + cCc)), NI3->NI3_DESC),;	
															  (SI3->(MsSeek(xFilial("SI3") + cCc)), SI3->I3_DESC))), 16) }
Local bItem  			:= { |cItem | 	Left(If(lCtb, (CTD->(MsSeek(xFilial("CTD") + cItem)),;
									CTD->CTD_DESC01),;
									(SID->(MsSeek(xFilial("SID") + cItem)),;
									SID->ID_DESC)), 16) }
Local bClVl  			:= { |cClvl | 	Left(If(lCtb, (CTH->(MsSeek(xFilial("CTH") + cClVl)),;
									CTH->CTH_DESC01), (Space(1))), 16) }
Local aObjetos			:= { { ,,,,, 	If(lGspInUseM, "NI1","CT1"), bConta } }, nTamObjs := 8, nEntidade, nGets

Local aVar     		:= { { "", "", "", "", "" } }		// Somente inicializo
Local aCpDigit			:= { { "N3_CCONTAB", "N3_CCORREC", "N3_CDEPREC", "N3_CCDEPR", "N3_CDESP", "N3_CCUSTO", "SN1->N1_LOCAL" } }
Local oLocal, oCCusto
Local ni
Local cN1TipoNeg 		:= Alltrim(SuperGetMv("MV_N1TPNEG",.F.,"")) // Tipos de N1_PATRIM que aceitam Valor originais negativos
Local cN3TipoNeg 		:= Alltrim(SuperGetMv("MV_N3TPNEG",.F.,"")) // Tipos de N3_TIPO que aceitam Valor originais negativos
Local oDataTrans 
Local cNota  			:= Space(Len(SN1->N1_NFISCAL))
Local cSerie 			:= Space(Len(SN1->N1_NSERIE))
Local cGrupo 			:= Space(Len(SN1->N1_GRUPO))
Local oGetGrupo

// Classificacoes 	1 - Classificacao do bem
//					2 - Correcao monetaria
//					3 - Despesa depreciacao
//					4 - Depreciacao acumulada
//					5 - Correcao Despesa Depreciacao

Private nTotal 		:= 0 , nTotal2:= 0
Private lPrim 			:= .T., lPrim2 := .T.

Private cPicture1, cPicture2, cPicture3, cPicture4, cPicture5, cPictQtd
Private cLocAtivo

Private cMoedaAtf 	:= GetMV("MV_ATFMOEDA")
Private cMoeda
Private aTELA[0]
Private aGETS[0]                                             
Private nNewTxDepr	:= ParTxDepr
Private nNewCLVL		:= ParCLVL
Private nNewSubCTA	:= ParSubCTA
Private dDtTrans		:= ParDtTrans
Private aSubCta		:= {ParSUBCCON,ParSUBCCOR,ParSUBCDEP,ParSUBCCDE,ParSUBCDES}
Private aCLVL  		:= {ParCLVLCON,ParCLVLCOR,ParCLVLDEP,ParCLVLCDE,ParCLVLDES}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa 	  		       ³
//³ ----------- Elementos contidos por dimensao ------------				    ³
//³ 1. Nome a aparecer no cabecalho 										          ³
//³ 2. Nome da Rotina associada												          ³
//³ 3. Usado pela rotina													             ³
//³ 4. Tipo de Transa‡„o a ser efetuada										       ³
//³	 1 - Pesquisa e Posiciona em um Banco de Dados							    ³
//³	 2 - Simplesmente Mostra os Campos										       ³
//³	 3 - Inclui registros no Bancos de Dados								       ³
//³	 4 - Altera o registro corrente											       ³
//³	 5 - Remove o registro corrente do Banco de Dados						    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina 	:= menudef()
//{	{ STR0001, "AxPesqui"  , 0 , 0},; // "Pesquisar"
//							{ STR0002, "ATFVISUAL" , 0 , 0},; // "Visualizar"
//							{ STR0003, "AF060Trans", 0 , 4},; // "Transferir"
 //							{ STR0004, "AF060Auto" , 0 , 5},; // "Automatico"
 //							{ STR0046, "AF190Trans(1)", 0 , 4}}  // "Transf.Resp."

PRIVATE cMarca   	:= GetMark()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes								       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := ""
PRivate lAuto		:= .F.
aPos:= {  8,  4, 11, 74 }


//Ponto de entrada para inclusao de botao no arotina
/*
If ExistBlock("AF060BUT")
	aRotNew := ExecBlock("AF060BUT",.F.,.F.,{aRotina})
	For nX := 1 to len(aRotNew)		
 		aAdd(aRotina,aRotNew[nX])
 	Next
Endif
*/

// VARIAVEIS PARA CONTABILIZACAO CONTA

CTABEM		:= ""
DESPDEPR		:= ""
DEPREACUM	:= ""
CORREDEPR	:= ""
CORREBEM		:= ""

// Variaveis para contabilizacao Centro de custo, item e classe de valor

Custo 		:= ""	

CUSTBEMCTB	:= ""
CCCORRCTB	:= ""
CCDESPCTB	:= ""
CCCDESCTB	:= ""
CCCDEPCTB	:= ""

SUBCCONCTB	:= ""
SUBCCORCTB	:= ""
SUBCDESCTB	:= ""
SUBCDEPCTB	:= ""
SUBCCDECTB	:= ""

CLVLCONCTB	:= ""
CLVLCORCTB	:= ""
CLVLDESCTB	:= ""
CLVLDEPCTB	:= ""
CLVLCDECTB	:= ""

cFilDest 	:= cFilAnt
cFilOrig 	:= cFilAnt

// Posicionamento dos campos da tela para facilitar manutencao

#DEFINE 	P_LABEL			9
#DEFINE 	P_ORIGEM			75
#DEFINE 	P_DESTINO		150
#DEFINE 	P_ESPACO_OBJ	14

//Tipo Depreciacao diferente 02-Mes Subsequente
If GetMv("MV_TIPDEPR") == "2" .And. dDatabase < (FirstDay(GetMv("MV_ULTDEPR")))
	MsgAlert(STR0049+DTOC(SuperGetMv("MV_ULTDEPR")))
	Return		
Endif		
For nGets := 1 To Len(aCpDigit[1]) - 2
	nTamObjs += P_ESPACO_OBJ
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se CTB estiver em uso CT1 e CTT respectiva/e ao inves de SI1 e SI3        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtb .And. ! lGspInUseM
	cAliasCta := "CT1"
	cAliasCus := "CTT"
	cAliasIt  := "CTD"
	cAliasCl  := "CTH"	
Else
	If lGspInUseM
		cAliasCta := "NI1"
		cAliasCus := "NI3"
		cAliasIt  := ""
		cAliasCl  := ""
	Else
		cAliasCta := "SI1"
		cAliasCus := "SI3"
		cAliasIt  := "SID"
		cAliasCl  := ""
	Endif
EndIf

If lCc
	Aadd(aTitFolder, If(lGspInUseM,"Centro de Custo",CtbSayApro("CTT")))
	Aadd(aObjetos, { ,,,,,If(lGspInUseM,"NI3","CTT"), bCC })
	Aadd(aVar, AClone(aVar[1]))
	Aadd(aCpDigit, { "N3_CUSTBEM", "N3_CCCORR", "N3_CCDESP", "N3_CCCDEP", "N3_CCCDES" })
Endif

If lItem
	Aadd(aTitFolder, CtbSayApro("CTD"))
	Aadd(aObjetos, { ,,,,, "CTD", bItem })
	Aadd(aVar, AClone(aVar[1]))
	Aadd(aCpDigit, { "N3_SUBCCON", "N3_SUBCCOR", "N3_SUBCDEP", "N3_SUBCCDE", "N3_SUBCDES" })
Endif

If lClVl
	Aadd(aTitFolder, CtbSayApro("CTH"))
	Aadd(aObjetos, { ,,,,, "CTH", bClVl })
	Aadd(aVar, AClone(aVar[1]))
	Aadd(aCpDigit, { "N3_CLVLCON", "N3_CLVLCOR", "N3_CLVLDEP", "N3_CLVLCDE", "N3_CLVLDES" })
Endif

lFolder   := Len(aTitFolder) > 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa picture para valores do ativo									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPictQtd  := PesqPict("SN1","N1_QUANTD", 12)
cPicture1 := PesqPict("SN3","N3_VORIG1", 18)
cPicture2 := PesqPict("SN3","N3_VORIG2", 18)
cPicture3 := PesqPict("SN3","N3_VORIG3", 18)
cPicture4 := PesqPict("SN3","N3_VORIG4", 18)
cPicture5 := PesqPict("SN3","N3_VORIG5", 18)
Pergunte("AFA060", .F.)
MV_PAR01 == 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas:                            ³
//³ mv_par01 - 1 Contabiliza                                      ³
//³            2 NAO Contabiliza                                  ³
//³ mv_par02 - 1 Mostra Lancto Cont bil                           ³
//³            2 Nao Mostra Lancto Cont bil                       ³
//³ mv_par03 - 1 Aglutina Lancto                                  ³
//³          - 2 Nao Aglutina Lancto                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o registro n„o est  em uso por outra esta‡„o. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea( cAlias )

If ! lAuto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebe codigo do ativo												 				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBase := SN3->N3_CBASE
	cItem := SN3->N3_ITEM

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica existencia do Ativo                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SN1")
	dbSetOrder(1)
	dbSeek(cFilial+cBase+cItem)
	IF !Found()
		Help(" ",1,"020ATIVO")
		Return
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ativo nao esta' baixado                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Val( SN3->N3_BAIXA ) # 0
		Help(" ",1,"020BAIXADO")
		Return
	End

	If ! SoftLock("SN3")
		 Return .t.
	Endif
Endif

Aadd(aVar[1], SN3->N3_CCUSTO)
Aadd(aVar[1], SN1->N1_LOCAL)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza as variaveis de acordo com o passado pelo parametro        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ParFilDest <> Nil
	cFilDest 	:= ParFilDest
Endif               
If ParCCDest <> Nil
	aVar[1][6]	:= ParCCDest
Endif
If ParEndDest <> Nil
	aVar[1][7] := ParEndDest
Endif
If ParDtTrans <> Nil
	dDataTrans := ParDtTrans
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	 No caso de contas de Capital, nÆo vai a corre‡Æo monet ria.		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPatrim  	:= SN1->N1_PATRIM
nValor	 	:= Iif( cPatrim # "C" , SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1, SN3->N3_VORIG1+SN3->N3_AMPLIA1 )

nQtdeSn  	:= IIF(SN1->N1_QUANTD == 0, 1, SN1->N1_QUANTD)
nQtdOrig 	:= nQtdeSn
nQuant	 	:= nQtdeSn
nCustAtu 	:= nValor
If SN3->N3_TIPO = "05" .Or. (SN1->N1_PATRIM $ cN1TipoNeg) .Or. (SN3->N3_TIPO $ cN3TipoNeg)
	nValResid:= nValor + Abs( (SN3->N3_VRDACM1 + SN3->N3_VRCDA1) )
Else
	nValResid:= nValor - ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 )
Endif

nOpt 	 	:= 0
nLin 		:= 14
	
If lAuto
	//DEFINE 	MSDIALOG oDlg FROM  0,0 TO 0,0;
	//		TITLE cCadastro PIXEL

	//@ 004, 004 	TO 040, (oDlg:nRight / 2) - 9 LABEL "Filtrar Origem" OF oDlg  PIXEL // "Filtrar Origem"

	//@ nLin - 0,009 	SAY STR0030		SIZE 34, 7 OF oDlg PIXEL // "Do C¢digo:"
	//@ nLin - 2,045	MSGET oBasei VAR cBasei   	F3 "SN1"	Valid Af060Base(cBasei)   SIZE 60, 10 OF oDlg PIXEL
	//@ nLin - 2,110	MSGET cItemi   	SIZE 30, 10 OF oDlg PIXEL
	//oBasei:bChange := {|| cBasef := cBasei , oBasef:Refresh() }
	
	nLin += 14    

	//@ nLin - 0,009 	SAY STR0031		SIZE 34, 7 OF oDlg PIXEL // "Ao C¢digo:"
	//@ nLin - 2,045 	MSGET oBasef VAR cBasef   	F3 "SN1"	Valid Af060Base(cBasef)   SIZE 60, 10 OF oDlg PIXEL
	//@ nLin - 2,110	MSGET cItemf   	SIZE 30, 10 Valid !Empty(cItemF) OF oDlg PIXEL

	nLin += 14    
	  
	//@ nLin, 004 	TO 094, (oDlg:nRight / 2) - 9 LABEL STR0029 OF oDlg  PIXEL // "Transferir para"
	
	nLin += 10    

	//@ nLin - 0,009 	SAY STR0045  	SIZE 34, 7 OF oDlg PIXEL // "Filial Destino"
	//@ nLin - 1,45  	MSGET cFilDest	Valid AfA060Fil(cFilDest);
	//					 When !Empty(xFilial("SN3")) F3 "XM0" SIZE 40, 10 OF oDlg PIXEL

Else
	cGrupo := SN1->N1_GRUPO
	SA2->(DbSetOrder(1))
	SA2->(MsSeek(xFilial("SA2")+SN1->(N1_FORNEC+N1_LOJA)))
	//DEFINE 	MSDIALOG oDlg FROM  -10,-10 TO -10,-10;
	//		TITLE cCadastro PIXEL
	//oDlg:Hide()				
	//DEFINE 	MSDIALOG oDlg FROM  0,0 TO 400,400;
   
	/*
	@ 004, 004 	TO 101, 322 LABEL STR0010 OF oDlg  PIXEL // "Dados do Bem"

	@ nLin - 0,009	SAY STR0014 			SIZE 28, 07 OF oDlg PIXEL // "C¢digo"
	@ nLin - 2,045 	MSGET SN3->N3_CBASE		SIZE 38, 10 OF oDlg PIXEL When .f.
	@ nLin - 0,092 	SAY STR0015 				SIZE 15, 07 OF oDlg PIXEL // "Item"
	@ nLin - 2,104 	MSGET SN3->N3_ITEM		SIZE 23, 10 OF oDlg PIXEL READONLY F3 "ATFRDO"
	@ nLin - 0,135 	SAY STR0016  				SIZE 14, 07 OF oDlg PIXEL // "Tipo"
	@ nLin - 2,148 	MSGET SN3->N3_TIPO		SIZE 14, 10 OF oDlg PIXEL When .f.
	@ nLin - 0,167 	SAY STR0017					SIZE 32, 07 OF oDlg PIXEL // "Descri‡„o" 
	@ nLin - 2,194 	MSGET SN1->N1_DESCRIC 	SIZE 123,10 OF oDlg PIXEL When .f.
	*/
	nLin += 14
	/*	
	@ nLin - 0,009 	SAY STR0018  			SIZE 36, 07 OF oDlg PIXEL // "Quant.Atual"   
	@ nLin - 1,045 	MSGET nQtdOrig          SIZE 52, 10 OF oDlg PIXEL When .f. Picture cPictQtd
	@ nLin - 0,104 	SAY STR0019  			SIZE 53, 07 OF oDlg PIXEL // "Custo Atualizado"
	@ nLin - 2,149 	MSGET nCustAtu          SIZE 52, 10 OF oDlg PIXEL When .f. Picture cPicture1
	@ nLin - 0,203 	SAY STR0020				SIZE 43, 07 OF oDlg PIXEL // "Valor Residual" 
	@ nLin - 2,243 	MSGET nValResid         SIZE 50, 10 OF oDlg PIXEL When .f. Picture cPicture1
	*/
	nLin += 14
	/*
	@ nLin - 0,009 	SAY STR0021  			SIZE 17, 07 OF oDlg PIXEL // "Data"
	@ nLin - 2,045 	MSGET oDataTrans VAR dDataTrans        SIZE 31, 10 OF oDlg PIXEL;
					Valid af060data( dDataTrans )

	@ nLin - 0,100 	SAY STR0045   			SIZE 53, 07 OF oDlg PIXEL // "Filial Destino"
	@ nLin - 2,148 	MSGET cFilDest          SIZE 42, 10 OF oDlg PIXEL F3 "XM0";
					 When !Empty(xFilial("SN3"));
					Valid AfA060Fil(cFilDest) .And. AF060Codigo(cFilDest,SN3->N3_CBASE,SN3->N3_ITEM)
					
	@ nLin - 0,200 	SAY STR0057	OF oDlg PIXEL // "Grupo"
	@ nLin - 2,230 	MSGET oGetGrupo VAR cGrupo SIZE 42, 10 OF oDlg PIXEL F3 "SNG" VALID Af060Grupo(cGrupo,aCpDigit, aVar)
	oGetGrupo:cReadVar := "N1_GRUPO" // Para associar o Help do campo
	*/
	nLin += 14	
	/*
	@ nLin - 0,009		SAY STR0054 		SIZE 28, 07 OF oDlg PIXEL  // "Nota Fiscal"
	@ nLin - 2,045 	MSGET cNota	OF oDlg PIXEL 
	@ nLin - 0,084 	SAY STR0055			SIZE 15, 07 OF oDlg PIXEL  // "Série" 
	@ nLin - 2,098 	MSGET cSerie		OF oDlg PIXEL 
   */
Endif

nLin += 14

//@ nLin - 0,009		SAY STR0027				SIZE 53, 07 OF oPai PIXEL // "Centro Custo" 
/*
If ! lAuto
	@ nLin - 2,045	MSGET SN3->N3_CCUSTO 	SIZE 69, 10 OF oPai PIXEL When .f.
	@ nLin - 2,125 	SAY STR0033 			SIZE 53, 07 OF oDlg PIXEL	//"Destino"
	@ nLin - 2,148	MSGET oCCusto VAR aVar[1][6]		SIZE 69, 10 OF oPai PIXEL  Picture "@!";
					F3 cAliasCus Valid AF060CCusto( @aVar[1][6], cAliasCus )
	@ nLin - 2,218	SAY oCusto        		PROMPT Eval(bCc, aVar[1][6]);
					OF oPai PIXEL FONT oDlg:oFont COLOR CLR_HBLUE
Else
	@ nLin - 2,045	MSGET oCCusto VAR aVar[1][6]		SIZE 69, 10 OF oPai PIXEL  Picture "@!";
					F3 cAliasCus Valid AF060CCusto( @aVar[1][6], cAliasCus )
	@ nLin - 2,115	SAY oCusto        		PROMPT Eval(bCc, aVar[1][6]);
					OF oPai PIXEL FONT oDlg:oFont COLOR CLR_HBLUE
Endif
oCCusto:cReadVar := "N3_CCUSTO"
*/
nLin += 14
/*
@ nLin - 0,009    	SAY STR0028				SIZE 53, 07 OF oPai PIXEL // "Localiza‡„o"
If ! lAuto
	@ nLin - 2,045	MSGET SN1->N1_LOCAL		SIZE 69, 10 OF oPai PIXEL  When .f.
	@ nLin - 2,125 	SAY STR0033 			SIZE 53, 07 OF oDlg PIXEL //"Destino"
	@ nLin - 2,148 	MSGET oLocal VAR aVar[1][7]			SIZE 69, 10 OF oPai PIXEL;
					Picture "@!" F3 CpoRetF3("N1_LOCAL");
					Valid CheckSx3("N1_LOCAL", aVar[1][7])
	
Else
	@ nLin - 2,045 	MSGET oLocal VAR aVar[1][7]			SIZE 69, 10 OF oPai PIXEL;
					Picture "@!" F3 CpoRetF3("N1_LOCAL");
					Valid CheckSx3("N1_LOCAL", aVar[1][7])
Endif
oLocal:cReadVar := "N1_LOCAL"
*/
nLin += 18
/*
If lFolder

	oFolder := TFolder():New(	nLin,04,aTitFolder,aPages,oDlg,,,,;
							   .T., .F.,  (oDlg:nRight / 2) - 10,nTamObjs + 20,)

	For ni := 1 to Len(oFolder:aDialogs)
		DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[ni]
	Next
	
	oPai := oFolder:aDialogs[1]
Else
	oPai := oDlg
Endif
*/
dbSelectArea("SN3")

If lAuto
	nLin += 23
Endif

nPanelBem := nLin

For nEntidade := 1 To Len(aTitFolder)
    If lFolder
		nLin 	:= 2
		nColFim := 310
	Else
		nColFim := 320
		nLin 	:= nPanelBem
	Endif
  /*  
	If nEntidade > 1
		oPai := oFolder:aDialogs[nEntidade]
	Endif

	@ nLin, 004 TO nLin + nTamObjs - 1,070 LABEL STR0011 OF oPai  PIXEL // "Dados Contabeis"
	
	If lAuto
		@ nLin-3, 072 TO nLin + nTamObjs - 1,(oDlg:nRight / 2) - 14 LABEL STR0013 OF oPai PIXEL // "Destino"
		@ nLin-2, 160 SAY STR0047 SIZE 53, 07 OF oPai PIXEL // "(*) Destino = Origem"
	Else
		@ nLin, 072 TO nLin + nTamObjs - 1,145 LABEL STR0012 OF oPai  PIXEL // "Origem"
		@ nLin, 147 TO nLin + nTamObjs - 1,nColFim LABEL STR0013 OF oPai PIXEL // "Destino"
	Endif
	*/
	nLin += 8

// Identificacao do bem
	IF aObjetos[nEntidade][6] $ "CT1#NI1" 
		U_Af060Get(	aVar[nEntidade], aCpDigit[1][1], cAliasCta, @nLin, oPai, bConta,;
					aObjetos[nEntidade], 1)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		U_Af060Get(	aVar[nEntidade], aCpDigit[2][1], cAliasCus, @nLin, oPai, bCc,;
					aObjetos[nEntidade], 1)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		U_Af060Get(	aVar[nEntidade], aCpDigit[3][1], cAliasIt, @nLin, oPai, bItem,;
					aObjetos[nEntidade], 1)
	Else
		U_Af060Get(	aVar[nEntidade], aCpDigit[4][1], cAliasCl, @nLin, oPai, bClVl,;
					aObjetos[nEntidade], 1)
	Endif

// Correcao monetaria

	IF aObjetos[nEntidade][6] $ "CT1#NI1"
		U_Af060Get(	aVar[nEntidade], aCpDigit[1][2], cAliasCta, @nLin, oPai, bConta,;
					aObjetos[nEntidade], 2)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		U_Af060Get(	aVar[nEntidade], aCpDigit[2][2], cAliasCus, @nLin, oPai, bCc,;
					aObjetos[nEntidade], 2)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		U_Af060Get(	aVar[nEntidade], aCpDigit[3][2], cAliasIt, @nLin, oPai, bItem,;
					aObjetos[nEntidade], 2)
	Else
		U_Af060Get(	aVar[nEntidade], aCpDigit[4][2], cAliasCl, @nLin, oPai, bClVl,;
					aObjetos[nEntidade], 2)
	Endif

// Despesa depreciacao

	IF aObjetos[nEntidade][6] $ "CT1#NI1"
		U_Af060Get(	aVar[nEntidade], aCpDigit[1][3], cAliasCta, @nLin, oPai, bConta,;
					aObjetos[nEntidade], 3)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		U_Af060Get(	aVar[nEntidade], aCpDigit[2][3], cAliasCus, @nLin, oPai, bCc,;
					aObjetos[nEntidade], 3)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		U_Af060Get(	aVar[nEntidade], aCpDigit[3][3], cAliasIt, @nLin, oPai, bItem,;
					aObjetos[nEntidade], 3)
	Else
		U_Af060Get(	aVar[nEntidade], aCpDigit[4][3], cAliasCl, @nLin, oPai, bClVl,;
					aObjetos[nEntidade], 3)
	Endif

// Depreciacao acumulada

	IF aObjetos[nEntidade][6] $ "CT1$NI1"
		U_Af060Get(	aVar[nEntidade], aCpDigit[1][4], cAliasCta, @nLin, oPai, bConta,;
					aObjetos[nEntidade], 4)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		U_Af060Get(	aVar[nEntidade], aCpDigit[2][4], cAliasCus, @nLin, oPai, bCc,;
					aObjetos[nEntidade], 4)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		U_Af060Get(	aVar[nEntidade], aCpDigit[3][4], cAliasIt, @nLin, oPai, bItem,;
		 			aObjetos[nEntidade], 4)
	Else
		U_Af060Get(	aVar[nEntidade], aCpDigit[4][4], cAliasCl, @nLin, oPai, bClVl,;
					aObjetos[nEntidade], 4)
	Endif

// Correcao monetaria depreciacao

	IF aObjetos[nEntidade][6] $ "CT1#NI1"
		U_Af060Get(	aVar[nEntidade], aCpDigit[1][5], cAliasCta, @nLin, oPai, bConta,;
					aObjetos[nEntidade], 5)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		U_Af060Get(	aVar[nEntidade], aCpDigit[2][5], cAliasCus, @nLin, oPai, bCc,;
					aObjetos[nEntidade], 5)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		U_Af060Get(	aVar[nEntidade], aCpDigit[3][5], cAliasIt, @nLin, oPai, bItem,;
		 			aObjetos[nEntidade], 5)
	Else
		U_Af060Get(	aVar[nEntidade], aCpDigit[4][5], cAliasCl, @nLin, oPai, bClVl,;
					aObjetos[nEntidade], 5)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza as variaveis de acordo com o passado pelo parametro        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aObjetos[nEntidade][6] $ "CT1#NI1"    // Conta Contabil
		If ParCtBemDest <> Nil
			aVar[nEntidade,1]	:= ParCtBemDest          
		Endif               
		If ParCtCMDest <> Nil
			aVar[nEntidade,2]	:= ParCtCMDest
		Endif
		If ParCtDspDest <> Nil
			aVar[nEntidade,3]	:= ParCtDspDest
		Endif
		If ParCtDeprDest <> Nil
			aVar[nEntidade,4]	:= ParCtDeprDest
		Endif
		If ParCtCMDDest <> Nil
			aVar[nEntidade,5]	:= ParCtCMDDest
		Endif
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		If ParCcBemDest <> Nil
			aVar[nEntidade,1]	:= ParCcBemDest
		Endif               
		If ParCcCMDest <> Nil
			aVar[nEntidade,2]	:= ParCcCMDest
		Endif
		If ParCcDspDest <> Nil
			aVar[nEntidade,3]	:= ParCcDspDest
		Endif
		If ParCcDeprDest <> Nil
			aVar[nEntidade,4]	:= ParCcDeprDest
		Endif
		If ParCcCMDDest <> Nil
			aVar[nEntidade,5]	:= ParCcCMDDest
		Endif
	ElseIf aObjetos[nEntidade][6] = "CTD"    // Item Contabil
		If ParSUBCCON <> Nil
			aVar[nEntidade,1]	:= ParSUBCCON
		Endif               
		If ParSUBCCOR <> Nil
			aVar[nEntidade,2]	:= ParSUBCCOR
		Endif
		If ParSUBCDEP <> Nil
			aVar[nEntidade,3]	:= ParSUBCDEP
		Endif
		If ParSUBCCDE <> Nil
			aVar[nEntidade,4]	:= ParSUBCCDE
		Endif
		If ParSUBCDES <> Nil
			aVar[nEntidade,5]	:= ParSUBCDES
		Endif
	Else		// Classe Valor
		If ParCLVLCON <> Nil
			aVar[nEntidade,1]	:= ParCLVLCON
		Endif               
		If ParCLVLCOR <> Nil
			aVar[nEntidade,2]	:= ParCLVLCOR
		Endif
		If ParCLVLDEP <> Nil
			aVar[nEntidade,3]	:= ParCLVLDEP
		Endif
		If ParCLVLCDE <> Nil
			aVar[nEntidade,4]	:= ParCLVLCDE
		Endif
		If ParCLVLDES <> Nil
			aVar[nEntidade,5]	:= ParCLVLDES
		Endif
	Endif
			

Next
				
/*						
If ExistBlock("AF060CHA")
	Execblock("AF060CHA",.F.,.F.)
Endif
*/
If nOpc == 4 ///Somente para transferencia automatica (Expressão de filtro)
	//DEFINE SBUTTON 	FROM /*nPanelBem - */P_ESPACO_OBJ + 65, (oDlg:nRight / 2) - 100 TYPE 17;
	//			ENABLE OF oDlg ACTION SN3->(cExpFiltro := BuildExpr("SN3",oDlg) )
Endif

//DEFINE SBUTTON 	FROM /*nPanelBem - */P_ESPACO_OBJ + 65, (oDlg:nRight / 2) - 70 TYPE 1;
//				ENABLE OF oDlg ACTION (nOpt:=1,oDlg:End())
//DEFINE SBUTTON 	FROM /*nPanelBem - */P_ESPACO_OBJ + 65, (oDlg:nRight / 2) - 40 TYPE 2;
//				ENABLE OF oDlg ACTION (nOpt:=0,oDlg:End())
//oDlg:Hide()				
//ACTIVATE MSDIALOG oDlg ON INIT (nOpt		:= 1,oDlg:Hide(),oDlg:End())
//ACTIVATE MSDIALOG oDlg CENTERED
nOpt		:= 1
cFilAnt 	:= cFilOrig		// Garanto que a filial atual seja a original

If lAuto
	Return { aVar, aCpDigit, nOpt }
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se houve alguma mudan‡a.								 			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nNewTxDepr <> SN3->N3_TXDEPR1 .or. nNewCLVL <> SN3->N3_CLVL .or. nNewSubCTA <> SN3->N3_SUBCTA
	nOpt := 1
Else
	DbSelectArea("SN3")
	If nOpt = 1 .And. cFilDest == cFilOrig
		nOpt := 0
		For nEntidade := 1 To Len(aTitFolder)
			For nGets := 1 To Len(aVar[nEntidade])
				If aVar[nEntidade][nGets] <> &(aCpDigit[nEntidade][nGets])
					nOpt := 1
				Endif
			Next
		Next
	Endif            
Endif	
/*
If ExistBlock("AF060TOK") .And. nOpt == 1
	If ! ExecBlock("AF060TOK",.F., .F., {cFilDest, cFilOrig, aTitFolder, aVar, aCpDigit})
		nOpt := 0
	Endif
Endif
*/
If nOpt = 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Gravacao de dados com as mesmas filiais Origem e Destino ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cFilDest == cFilOrig
		U_Af060Grava(cAlias, aVar, aCpDigit, .T.,dDataTrans,@nHdlPrv,@cArquivo,,,,cGrupo,cNota,cSerie)
		//If nHdlPrv > 0 .And. nTotal > 0
		//	RodaProva(nHdlPrv,nTotal)
		//	cA100Incl(cArquivo,nHdlPrv,2,cLoteAtf,Iif(mv_par02==1,.T.,.F.),Iif(mv_par03==1,.T.,.F.))
		//Endif
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se contas transferidas existem na filial destino³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If AF060ExiFil(	aVar[1][1], aVar[1][2], aVar[1][3],aVar[1][4],aVar[1][5],;
		//				aVar[1][6], cFilDest,cFilOrig, aCpDigit, aVar)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravacao de dados com diferentes filiais Origem e Destino ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCtb := U_Af060GFil(cAlias, aVar, aCpDigit, .F.,dDataTrans,;
								cFilDest,cFilOrig,,@nHdlPrv,@cArquivo,cGrupo,cNota,cSerie,,,,.F.)
			//Af060CtbFil(aCtb, aCpDigit, cLoteAtf, cFilDest,cFilOrig,@nHdlPrv,@cArquivo,dDataTrans)
		//Endif
	Endif       
	/*
	If ExistBlock ("ATF060GRV")
		ExecBlock("ATF060GRV",.F.,.F.)
	EndIf	
	*/
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Libera o softlock instalado acima do while.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SN3")
MsUnlock()

Return(nOpt = 1)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Af060Grava ³ Autor ³ Alice Yaeko Yamamoto  ³ Data ³ 14.02.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fun‡„o de gravacao de transferencia na propria filial 	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1  = cAlias     - Alias                                 ³±±
±±³          ³ ExpA1  = aVar       - Array com variaveis da tela transfere ³±±
±±³          ³ ExpA2  = aCpDigit   - Array com campos da variaveis da tela ³±±
±±³          ³ ExpL1  = lContab    - Contabiliza ?                         ³±±
±±³          ³ ExpD1  = dDataTrans - Data da Transferˆncia                 ³±±
±±³          ³ ExpN1  = nHdlPrv    - Handle de contabilizacao              ³±±
±±³          ³ ExpC2  = cArquivo   - Nome do arquivo da contabilizacao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ATFA060													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function af060Grava(	cAlias, aVar, aCpDigit, lContab, dDataTrans, nHdlPrv, cArquivo, dUltDepr,;
						 	nTaxaMedia, lNgaTfMnt, cGrupo, cNota, cSerie)

Local nValor 		:= 0
Local cOcorren
Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local cBase    		:= ""
Local cItem    		:= ""
Local cTipo    		:= ""
Local lProcura 		:= .F.
Local cChave   		:= ""
Local lAchou   		:= .F.
Local cLocOrig 		:= SN1->N1_LOCAL
Local nPosSN3
Local nOrder
Local nX
Local nEntidade
Local nGets

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	No caso de contas de Capital, nÆo vai a corre‡Æo monet ria. 		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPatrim	:= SN1->N1_PATRIM

Local lBem := .F., lCorrecao:= .F., lDepAcum:= .F., lCorMDep:= .F., lDespDep := .F.
Local lLocal := .F.

Default lNgaTfMnt		:= FindFunction("NGATFMNT")
Default dUltDepr 		:= GetMV("MV_ULTDEPR")
Default nTaxaMedia 	:= Af060moeda(If(lGspInUseM,MsSomaMes(dUltDepr,-1,.T.),dUltDepr))
Default cGrupo		 	:= ""
Default cNota 			:= ""
Default cSerie			:= ""

cCContab	:= aVar[1][1]
cCCorrec	:= aVar[1][2]
cCDeprec	:= aVar[1][3]
cCCDepr		:= aVar[1][4]
cCDesp		:= aVar[1][5]
cCusto		:= aVar[1][6]
cLocAtivo	:= aVar[1][7]

Af060VarCtb(aVar, aCpDigit)

nValor		:= Iif( cPatrim # "C" , SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1, SN3->N3_VORIG1+SN3->N3_AMPLIA1 )
cCContab 	:= IIF(cCContab == SN3->N3_CCONTAB, " " , cCContab)
cCCorrec 	:= IIF(cCCorrec == SN3->N3_CCORREC, " " , cCCorrec)
cCDeprec 	:= IIF(cCDeprec == SN3->N3_CDEPREC, " " , cCDeprec)
cCDesp		:= IIF(cCDesp	== SN3->N3_CDESP  , " " , cCDesp  )
cCCDepr		:= IIF(cCCDepr  == SN3->N3_CCDEPR , " " , cCCDepr )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Qdo da transf de local verifico se existem os tipos 02 ou 04. O lo-	³
//³ cal ‚ gravado no SN1 e nao posso atualizar na transf desses tipos. 	³
//³ O local deve ser o mesmo para todos os tipos ( 01 02 04 ).         	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cLocAtivo)
	nPosSN3 := SN3->(RECNO())
	nOrder  := SN3->(IndexOrd())
	cBase   := SN3->N3_CBASE
	cItem   := SN3->N3_ITEM
	cTipo   := SN3->N3_TIPO
	dbSelectArea("SN3")
	dbSetorder(1)
	If cTipo == "01"
		If (MsSeek(xFilial("SN3")+cBase+cItem+"02")) .Or. (MsSeek(xFilial("SN3")+cBase+cItem+"04"))
			lProcura := .T.
		Endif
	ElseIf ctipo == "02"
		If (MsSeek(xFilial("SN3")+cBase+cItem+"01")) .Or. (MsSeek(xFilial("SN3")+cBase+cItem+"04"))
			lProcura := .T.
		Endif
	ElseIf ctipo == "04"
		If (MsSeek(xFilial("SN3")+cBase+cItem+"01")) .Or. (MsSeek(xFilial("SN3")+cBase+cItem+"01"))
			lProcura := .T.
		Endif
	Endif

	If lProcura
		dbSelectArea("SN4")
		dbSetOrder(1)
		If (MsSeek(xFilial("SN4")+cBase+cItem))
			cChave     := xFilial("SN4")+cBase+cItem
			While !Eof() .And. SN4->N4_FILIAL+SN4->N4_CBASE+SN4->N4_ITEM == cChave
				If SN4->N4_OCORR != "03"
					dbSkip()
					Loop
				Endif

				If SN4->N4_DATA != dDataTrans
					dbSkip()
					Loop
				Endif

				If SN4->N4_DATA == dDataTrans .And. SN4->N4_OCORR == "03"
					lAchou   := .T.
					Exit
				Endif
			EndDo
		Endif
	Endif

	dbSelectArea("SN3")
	dbSetorder(nOrder)
	dbGoto(nPosSN3)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ cOcorrencia 03 - transferˆncia de              ³
//³             04 - transferˆncia para            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOcorren := "03"
//BEGIN TRANSACTION
For nX := 1 To 2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ocorreu alteracao na conta do bem						³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SN3")
	lBem 	 := nX = 2 .And. lBem
	lLocal := nX = 2 .And. lLocal
	
	lCorrecao := nX = 2 .And. lCorrecao
	lDepAcum := nX = 2 .And. lDepAcum
	lCorMDep := nX = 2 .And. lCorMDep
	lDespDep := nX = 2 .And. lDespDep
	If !lLocal .And. (aVar[1][7] <> &(aCpDigit[1][7]) .Or. (Len(aVar[1]) >= 7 .And. Len(aCpDigit[1]) >= 7 .And. aVar[1][7] <> &(aCpDigit[1][7])))
		lLocal := .T.
	Endif
	For nEntidade := 1 To If(nX = 1, Len(aCpDigit), 0)
		If !lBem .And. (aVar[nEntidade][1] <> &(aCpDigit[nEntidade][1]) .Or. (Len(aVar[nEntidade]) >= 6 .And. Len(aCpDigit[nEntidade]) >= 6 .And. aVar[nEntidade][6] <> &(aCpDigit[nEntidade][6])))
			lBem := .T.
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ocorreu alteracao na conta da correcao monetaria		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aVar[nEntidade][2] <> &(aCpDigit[nEntidade][2])
			lCorrecao := .T.
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ocorreu alteracao na conta da depreciacao acumulada		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Depreciacao acumulada
		If aVar[nEntidade][4] <> &(aCpDigit[nEntidade][4])
			lDepAcum := .T.
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ocorreu alteracao na conta da corr. monet. da deprec.	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aVar[nEntidade][5] <> &(aCpDigit[nEntidade][5])
			lCorMDep := .T.
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ocorreu alteracao na conta da Despesa Depreciacao    	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aVar[nEntidade][3] <> &(aCpDigit[nEntidade][3])
			lDespDep := .T.
		Endif
	Next

	U_Af060GrvMov(aVar, aCpDigit, nX, dDataTrans, cOcorren, nTaxaMedia, cLocOrig, { lBem, lCorrecao, lDepAcum, lCorMDep, lDespDep, lLocal },;
					@nHdlPrv, @cArquivo,,,,cNota,cSerie)
					
	If NX = 1
		DbSelectArea("SN3")
		RecLock("SN3")
		For nEntidade := 1 To Len(aCpDigit)
			For nGets := 1 To Len(aVar[nEntidade])
				If ! "SN1" $ aCpDigit[nEntidade][nGets] 
					If nEntidade == 1 .and. !Empty(aVar[nEntidade][nGets])
						If ALLTRIM(aVar[nEntidade][nGets]) <> "*"								/// SE O CAMPO CONTIVER * DESTINO = ORIGEM
							&(aCpDigit[nEntidade][nGets]) := aVar[nEntidade][nGets]
						EndIf
					ElseIf nEntidade > 1 .or. !(aCpDigit[nEntidade][nGets] $ "N3_CCONTAB#N3_CCDEPR")
						If ALLTRIM(aVar[nEntidade][nGets]) <> "*"								/// SE O CAMPO CONTIVER * DESTINO = ORIGEM
							&(aCpDigit[nEntidade][nGets]) := aVar[nEntidade][nGets]					
						EndIf
					EndIf
				Endif
			Next
		Next
		MsUnlock()
		
		If !Empty(aVar[1][7]) .And. SN1->N1_LOCAL != aVar[1][7]
			Reclock( "SN1" )
			SN1->N1_LOCAL := aVar[1][7]
			msUnlock()
		Endif
		If SN1->N1_GRUPO != cGrupo
			Reclock( "SN1" )
			SN1->N1_GRUPO 	:= cGrupo
			msUnlock()
		Endif
		
		// Aquisicao, atualiza MNT, caso o parametro MV_NGMNTAT for igual a 1 ou 3.
		If SN3->N3_TIPO == "01" .And. GetMv("MV_NGMNTAT") $ "1#3"
			AfGrvIntMnt(AfCposIntMnt(), SN1->(N1_CBASE+N1_ITEM))
		Endif
		
		If lNgaTfMnt
			NGATFMNT(SN1->(N1_CBASE+N1_ITEM),SN1->N1_QUANTD)
			//  cCODIM - Codigo do imobilizado + item (N1_CBASE + N1_ITEM) 
			// nQTDN1 - Quantidade do bem (N1_QUANTD)
		EndIF

	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta parametros para a segunda passagem			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cOcorren := "04"
Next
//END TRANSACTION

dbSelectArea("SN3")
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³af060GFil³ Autor ³ Alice Yaeko Yamamoto   ³ Data ³ 14.02.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fun‡„o de gravacao dos dados com cFilDest <> cFilOrig 	   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1  = cAlias     - Alias                                 	³±±
±±³          ³ ExpA1  = aVar       - Array com variaveis da tela transfere 	³±±
±±³          ³ ExpA2  = aCpDigit   - Array com campos da variaveis da tela 	³±±
±±³          ³ ExpL1  = lContab    - Contabiliza ?                         	³±±
±±³          ³ ExpD1  = dDataTrans - Data da Transferˆncia                 	³±±
±±³          ³ ExpC2  = cFilDest   - Filial Destino                        	³±±
±±³          ³ ExpC3  = cFilOrig   - Filial Origem                         	³±±
±±³          ³ ExpA3  = aCtb       - Variavel para  preenchimento  conteudo	³±±
±±³          ³ 						 contabilizacao multi-filial		   	³±±
±±³          ³ nHdlPrv    - Handle de contabilizacao              			³±±
±±³          ³ cArquivo   - Nome do arquivo da contabilizacao     			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ATFA060													    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function af060GFil(cAlias,aVar,aCpDigit,lContab,dDataTrans,cFilDest,cFilOrig,aCtb,;
					 nHdlPrv,cArquivo,cGrupo,cNota,cSerie,lAutomatico)

Local nValor 		:= 0
Local cOcorren
Local dUltDepr := GETMV("MV_ULTDEPR")
Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local nTaxaMedia 	:= Af060moeda(If(lGspInUseM,MsSomaMes(dUltDepr,-1,.T.),dUltDepr))
Local cBase    		:= ""
Local cItem    		:= ""
Local cTipo    		:= ""
Local lProcura 		:= .F.
Local cChave   		:= ""
Local lAchou   		:= .F.
Local cLocOrig 		:= SN1->N1_LOCAL
Local nPosSN3, nPosSN1
Local nOrder
Local cPatrim
Local nX
Local nY
Local cSet
Local nEntidade
Local nGets
//Local cLoteAtf := LoteCont("ATF")
Local cLoteAtf := "500000"
Local cFilSn2 := xFilial("SN2")

Local lBem      := .F.
Local lLocal    := .F.
Local lCorrecao := .F.
Local lDepAcum  := .F.
Local lCorMDep  := .F.
Local lDespDep  := .F.
Local aRecSn2   := {}
Local cSN3Atu   := ""
Local nPrxSN3   := 0
Local l1StSN3   := .F.

DEFAULT aCtb	 := { { }, { } }		// Retorno para contabilizacao
										// 1 posicao filial origem - 2 Destino
DEFAULT cGrupo  := ""
DEFAULT cNota	 := ""
DEFAULT cSerie	 := ""
DEFAULT lAutomatico := .F.				//Transferencia Automatica

dbSelectArea("SN1")
dbSetOrder(1)
// Se nao encontrar o Ativo na filial atual, pesquisa na filial destino
If !(MsSeek(xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM)) 
	MsSeek(cFilDest+SN3->N3_CBASE+SN3->N3_ITEM)
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	No caso de contas de Capital, nÆo vai a corre‡Æo monet ria. 		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPatrim	:= SN1->N1_PATRIM
nValor	:= Iif( cPatrim # "C" , SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1, SN3->N3_VORIG1+SN3->N3_AMPLIA1 )

cCContab	:= aVar[1][1]
cCCorrec	:= aVar[1][2]
cCDeprec	:= aVar[1][3]
cCCDepr		:= aVar[1][4]
cCDesp		:= aVar[1][5]
cCusto		:= aVar[1][6]
cLocAtivo	:= aVar[1][7]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trata contas patrimoniais 											³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Qdo da transf de local verifico se existem os tipos 02 ou 04. O lo-	³
//³ cal ‚ gravado no SN1 e nao posso atualizar na transf desses tipos. 	³
//³ O local deve ser o mesmo para todos os tipos ( 01 02 04 ).         	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosSN3 := SN3->(RECNO())
nPosSN1 := SN1->(RECNO())
If !Empty(cLocAtivo)
	nPosSN3 := SN3->(RECNO())
	nOrder  := SN3->(IndexOrd())
	cBase   := SN3->N3_CBASE
	cItem   := SN3->N3_ITEM
	cTipo   := SN3->N3_TIPO
	dbSelectArea("SN3")
	dbSetorder(1)
	If cTipo == "01"
		If (dbSeek(xFilial("SN3")+cBase+cItem+"02")) .Or. (dbSeek(xFilial("SN3")+cBase+cItem+"04"))
			lProcura := .T.
		Endif
	ElseIf ctipo == "02"
		If (dbSeek(xFilial("SN3")+cBase+cItem+"01")) .Or. (dbSeek(xFilial("SN3")+cBase+cItem+"04"))
			lProcura := .T.
		Endif
	ElseIf ctipo == "04"
		If (dbSeek(xFilial("SN3")+cBase+cItem+"01")) .Or. (dbSeek(xFilial("SN3")+cBase+cItem+"01"))
			lProcura := .T.
		Endif
	Endif

	If lProcura
		dbSelectArea("SN4")
		dbSetOrder(1)
		If (dbSeek(xFilial("SN4")+cBase+cItem))
			cChave     := xFilial("SN4")+cBase+cItem
			While !Eof() .And. SN4->N4_FILIAL+SN4->N4_CBASE+SN4->N4_ITEM == cChave
				If SN4->N4_OCORR != "03"
					dbSkip()
					cChave :=SN4->N4_FILIAL+SN4->N4_CBASE+SN4->N4_ITEM
					Loop
				Endif

				If SN4->N4_DATA != dDataTrans
					dbSkip()
					cChave :=SN4->N4_FILIAL+SN4->N4_CBASE+SN4->N4_ITEM
					Loop
				Endif

				If SN4->N4_DATA == dDataTrans .And. SN4->N4_OCORR == "03"
					lAchou    := .T.
					Exit
				Endif
			EndDo
		Endif
	Endif

	dbSelectArea("SN3")
	dbSetorder(nOrder)
	dbGoto(nPosSN3)
Endif

dbSelectArea("SN3")
dbSetOrder(1)
cSN3Atu := SN3->(N3_FILIAL+N3_CBASE+N3_ITEM)			/// TRANSFERE TODOS AS LINHAS DO BEM+ITEM (REAVALIAÇÕES/ETC.)
dbSeek(cSN3ATU,.T.)										/// CASO NÃO ESTEJA NA PRIMEIRA SEQUENCIA POSICIONA
l1StSN3 := .T.
//BEGIN TRANSACTION
While SN3->(!Eof()) .and. SN3->(N3_FILIAL+N3_CBASE+N3_ITEM) == cSN3Atu
	dbSkip()
	nPrxSN3 := SN3->(Recno())			// GUARDA O RECNO DO PROXIMO SN3 (O POSICIONADO PODE MUDAR DE FILIAL)
	dbSkip(-1)

	If !lAutomatico
		If nPosSN3 != SN3->(Recno())
			l1StSN3 := .F.
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ cOcorrencia 03 - transferˆncia de              ³
	//³             04 - transferˆncia para            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cOcorren := "03"
	For nX := 1 To 2
	
		If l1StSN3
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ocorreu alteracao na conta do bem						³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SN3")
			lBem 	:= nX = 2 .And. lBem
			lLocal := (AllTrim(aVar[1][7]) != "*" .And. aVar[1][7] <> &(aCpDigit[1][7]))
			For nEntidade := 1 To If(nX = 1, Len(aCpDigit), 0)
				If AllTrim(aVar[nEntidade][1]) != "*" .And. aVar[nEntidade][1] <> &(aCpDigit[nEntidade][1])
					lBem := .T.
				Endif
			Next

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ocorreu alteracao na conta da correcao monetaria		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SN3")
			lCorrecao := nX = 2 .And. lCorrecao
			For nEntidade := 1 To If(nX = 1, Len(aCpDigit), 0)
				If AllTrim(aVar[nEntidade][2]) != "*" .And. aVar[nEntidade][2] <> &(aCpDigit[nEntidade][2])
					lCorrecao := .T.
				Endif
			Next
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ocorreu alteracao na conta da depreciacao acumulada		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Depreciacao acumulada
			DbSelectArea("SN3")
			lDepAcum := nX = 2 .And. lDepAcum
			For nEntidade := 1 To If(nX = 1, Len(aCpDigit), 0)
				If AllTrim(aVar[nEntidade][4]) != "*" .And. aVar[nEntidade][4]  <> &(aCpDigit[nEntidade][4])
					lDepAcum := .T.
				Endif
			Next
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ocorreu alteracao na conta da corr. monet. da deprec.	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SN3")
			lCorMDep := nX = 2 .And. lCorMDep
			For nEntidade := 1 To If(nX = 1, Len(aCpDigit), 0)
				If AllTrim(aVar[nEntidade][5]) != "*" .And. aVar[nEntidade][5] <> &(aCpDigit[nEntidade][5])
					lCorMDep := .T.
				Endif
			Next
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ocorreu alteracao na conta da Despesa Depreciacao    	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SN3")
			lDespDep := nX = 2 .And. lDespDep
			For nEntidade := 1 To If(nX = 1, Len(aCpDigit), 0)
				If AllTrim(aVar[nEntidade][3]) != "*" .And. aVar[nEntidade][3]<> &(aCpDigit[nEntidade][3])
					lDespDep := .T.
				Endif
			Next
		EndIf			
		
		U_Af060GrvMov(aVar, aCpDigit, nX, dDataTrans, cOcorren, nTaxaMedia,;
					cLocOrig,;
					{ lBem, lCorrecao, lDepAcum, lCorMDep, lDespDep, lLocal },;
					@nHdlPrv, @cArquivo, cFilDest, cFilOrig, aCtb,cNota,cSerie)
	
		If mv_par01 == 1
			If nX ==1 .And. !VerPadrao("830") .And. ! CtbInUse()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua contabiliza‡„o caso alguma conta tenha sido transferida.		³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aLancam := Array(20)
				If !Empty(cCcontab) .or. !Empty(cCcorrec) .or. !Empty(cCDeprec) .or.;
					!Empty(CcDesp) .or. !Empty(cCcdepr)
					If lPrim
						nHdlPrv	 := HeadProva(cLoteAtf,"ATFA060",Substr(cUsuario,7,6),@cArquivo, .t.)
						lPrim := .f.
					End
					dbSelectArea("SX3")
	
					If !Empty( cCcontab )
						aLancam[ 1] := "C"
						aLancam[ 2] := Iif(SN1->N1_PATRIM $" NP" , cCcontab, SN3->N3_CCONTAB )
						aLancam[ 3] := Iif(SN1->N1_PATRIM $" NP" , SN3->N3_CCONTAB, cCcontab )
						aLancam[ 4] := SN3->N3_VORIG1 //+ SN3->N3_VRCACM1
						aLancam[ 5] := "SSSSS"
						aLancam[ 6] := Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)+Space(40-Len(Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)))
						aLancam[ 7] := SN3->N3_VORIG2
						aLancam[ 8] := SN3->N3_VORIG3
						aLancam[ 9] := SN3->N3_VORIG4
						aLancam[10] := SN3->N3_VORIG5
						aLancam[11] := Space( 9 )
						aLancam[12] := Space( 9 )
						aLancam[13] := Space( 5 )
						cSet := Set(_SET_DATEFORMAT)
						Set(_SET_DATEFORMAT,"dd/mm/yyyy")
						aLancam[14]:= "  /  /    "
						Set(_SET_DATEFORMAT,cSet)
						aLancam[15] := Space(40 )
						aLancam[16]:= Space( 1 )
						aLancam[17]:= Space(10 )
						aLancam[18]:= Space( 9 )
						aLancam[19]:= Space( 9 )
						aLancam[20]:= Space(17 )
						nTotal += af050Detalhe( @nHdlPrv,"ATFA060",cLoteAtf, aLancam )
					End
	
					If !Empty(cCcorrec)
						aLancam[ 1] := "X"
						aLancam[ 2] := Iif(SN1->N1_PATRIM $ " NP",cCcorrec, SN3->N3_CCORREC )
						aLancam[ 3] := Iif(SN1->N1_PATRIM $ " NP",SN3->N3_CCORREC, cCcorrec )
						aLancam[ 4] := SN3->N3_VRCMES1
						aLancam[ 5] := "SNNNN"
						aLancam[ 6] := Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)+Space(40-Len(Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)))
						aLancam[ 7] := 0
						aLancam[ 8] := 0
						aLancam[ 9] := 0
						aLancam[10] := 0
						aLancam[11] := Space( 9 )
						aLancam[12] := Space( 9 )
						aLancam[13] := Space( 5 )
						cSet := Set(_SET_DATEFORMAT)
						Set(_SET_DATEFORMAT,"dd/mm/yyyy")
						aLancam[14]:= "  /  /    "
						Set(_SET_DATEFORMAT,cSet)
						aLancam[15] := Space(40 )
						aLancam[16]:= Space( 1 )
						aLancam[17]:= Space(10 )
						aLancam[18]:= Space( 9 )
						aLancam[19]:= Space( 9 )
						aLancam[20]:= Space(17 )
						nTotal += af050Detalhe( @nHdlPrv,"ATFA060",cLoteAtf, aLancam )
					End
	
					If !Empty(cCDeprec)
						aLancam[ 1] := "X"
						aLancam[ 2] := Iif(SN1->N1_PATRIM $ " NP", cCDeprec, SN3->N3_CDEPREC)
						aLancam[ 3] := Iif(SN1->N1_PATRIM $ " NP", SN3->N3_CDEPREC, cCDeprec )
						aLancam[ 4] := SN3->N3_VRDMES1 + SN3->N3_VRCDM1
						aLancam[ 5] := "SSSSS"
						aLancam[ 6] := Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)+Space(40-Len(Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)))
						aLancam[ 7] := SN3->N3_VRDMES2
						aLancam[ 8] := SN3->N3_VRDMES3
						aLancam[ 9] := SN3->N3_VRDMES4
						aLancam[10] := SN3->N3_VRDMES5
						aLancam[11] := Space( 9 )
						aLancam[12] := Space( 9 )
						SX3->(DbSetOrder(2))
						If SX3->(DbSeek(cFilial+"I2_CCD")) .and. X3USO(SX3->X3_USADO)
							aLancam[11] := SubStr(SN3->N3_CCUSTO+Space(9),1,9)
							aLancam[12] := SubStr(SN3->N3_CCUSTO+Space(9),1,9)
						End
						SX3->(DbSetOrder(1))
						aLancam[13] := Space( 5 )
						cSet := Set(_SET_DATEFORMAT)
						Set(_SET_DATEFORMAT,"dd/mm/yyyy")
						aLancam[14]:= "  /  /    "
						Set(_SET_DATEFORMAT,cSet)
						aLancam[15] := Space(40 )
						aLancam[16]:= Space( 1 )
						aLancam[17]:= Space(10 )
						aLancam[18]:= Space( 9 )
						aLancam[19]:= Space( 9 )
						aLancam[20]:= Space(17 )
						nTotal += af050Detalhe( @nHdlPrv,"ATFA060",cLoteAtf, aLancam )
					End
	
					If !Empty(cCDesp)
					   	aLancam[ 1] := "X"
					   	aLancam[ 2] := Iif(SN1->N1_PATRIM $ " NP", cCdesp, SN3->N3_CDESP )
					   	aLancam[ 3] := Iif(SN1->N1_PATRIM $ " NP", SN3->N3_CDESP, cCdesp )
					   	aLancam[ 4] := SN3->N3_VRCDM1
					   	aLancam[ 5] := "SNNNN"
					   	aLancam[ 6] := Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)+Space(40-Len(Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)))
					   	aLancam[ 7] := 0
					   	aLancam[ 8] := 0
					   	aLancam[ 9] := 0
	 				   	aLancam[10] := 0
					   	aLancam[11] := Space( 9 )
					   	aLancam[12] := Space( 9 )
					   	aLancam[13] := Space( 5 )
						cSet := Set(_SET_DATEFORMAT)
						Set(_SET_DATEFORMAT,"dd/mm/yyyy")
						aLancam[14]:= "  /  /    "
						Set(_SET_DATEFORMAT,cSet)
					   	aLancam[15] := Space(40 )
					   	aLancam[16]:= Space( 1 )
					   	aLancam[17]:= Space(10 )
						aLancam[18]:= Space( 9 )
						aLancam[19]:= Space( 9 )
						aLancam[20]:= Space(17 )
					  	nTotal += af050Detalhe( @nHdlPrv,"ATFA060",cLoteAtf, aLancam )
					End
	
					If !Empty(cCcDepr)
						aLancam[ 1] := "X"
						aLancam[ 2] := Iif(SN1->N1_PATRIM $ " NP", SN3->N3_CCDEPR, cCcdepr )
						aLancam[ 3] := Iif(SN1->N1_PATRIM $ " NP", cCcdepr , SN3->N3_CCDEPR)
						aLancam[ 4] := SN3->N3_VRDACM1 //+ SN3->N3_VRCDA1
						aLancam[ 5] := "SSSSS"
						aLancam[ 6] := Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)+Space(40-Len(Trim("TRANSF.BEM "+SN1->N1_CBASE+SN1->N1_ITEM)))
						aLancam[ 7] := SN3->N3_VRDACM2
						aLancam[ 8] := SN3->N3_VRDACM3
						aLancam[ 9] := SN3->N3_VRDACM4
						aLancam[10] := SN3->N3_VRDACM5
						aLancam[11] := Space( 9 )
						aLancam[12] := Space( 9 )
						aLancam[13] := Space( 5 )
						cSet := Set(_SET_DATEFORMAT)
						Set(_SET_DATEFORMAT,"dd/mm/yyyy")
						aLancam[14]:= "  /  /    "
						Set(_SET_DATEFORMAT,cSet)
						aLancam[15] := Space(40 )
						aLancam[16]:= Space( 1 )
						aLancam[17]:= Space(10 )
						aLancam[18]:= Space( 9 )
						aLancam[19]:= Space( 9 )
						aLancam[20]:= Space(17 )
						nTotal += af050Detalhe( @nHdlPrv,"ATFA060",cLoteAtf, aLancam )
					 End
				EndIf
			Endif
		EndIf
	
		If nX == 1 
			cFilAnt := cFilDest
			DbSelectArea("SN3")
			RecLock("SN3")
			SN3->N3_FILIAL := cFilDest
			If l1StSN3
				For nEntidade := 1 To Len(aCpDigit)
					For nGets := 1 To Len(aVar[nEntidade])
						If ! "SN1" $ aCpDigit[nEntidade][nGets]
							If allTrim(aVar[nEntidade][nGets]) != "*"
							&(aCpDigit[nEntidade][nGets]) := aVar[nEntidade][nGets]
							Endif
						Endif
					Next
				Next
	 		EndIf
			SN3->N3_OK      	:= ""
			SN3->N3_FILORIG 	:= cFilOrig
			MsUnlock()

			If l1StSN3		/// Transfere O SN1 e SN2 e apenas 1 vez.
		     	dbSelectArea("SN1")
				dbGoto(nPosSN1)
				Reclock( "SN1" )
				SN1->N1_FILIAL	:= cFilDest
				
				If !Empty(aVar[1][7]) .And. SN1->N1_LOCAL != aVar[1][7]
					SN1->N1_LOCAL 	:= aVar[1][7]
				Endif
				If SN1->N1_GRUPO != cGrupo
					SN1->N1_GRUPO 	:= cGrupo
				Endif
				msUnlock()
				// Transfere descricao estendida.
				dbSelectArea("SN2")
				MsSeek(cFilSn2+SN3->(N3_CBASE+N3_ITEM+N3_TIPO))
				While SN2->(!Eof()) .And. SN2->(N2_FILIAL+N2_CBASE+N2_ITEM+N2_TIPO)==cFilSn2+SN3->(N3_CBASE+N3_ITEM+N3_TIPO)
					If SN2->N2_SEQ = SN3->N3_SEQ
						// Adiciono em uma matriz pois a alteracao da filial fara com que o 
						// registro seja desposicionado, quebrando o laco antecipadamente.
						Aadd(aRecSn2, SN2->(Recno()))
					Endif
					dbSkip()
				EndDo
				For nY := 1 To Len(aRecSn2)
					MsGoto(aRecSn2[nY])
					Reclock( "SN2",.F. )
					SN2->N2_FILIAL  := cFilDest
					msUnlock()			
				Next
			EndIf
			cFilAnt := cFilOrig
		Endif
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ajusta parametros para a segunda passagem			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cOcorren := "04"
	Next
	l1StSN3 := .T.
	SN3->(dbGoTo(nPrxSN3))
EndDo
//END TRANSACTION

dbSelectArea("SN3")

Return aCtb

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Af060GrvMov³ Autor ³ Wagner Mobile Costa    ³ Data ³ 02.06.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava movimentacao de transferencia de acordo com o tipo de  |±±
±±³          ³ mudancas efetuadas                                           |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aVar       - Array com variaveis da tela transfere 			³±±
±±³          ³ aCpDigit   - Array com campos da variaveis da tela 			³±±
±±³          ³ nX		  - Idenfifica o tipo de registro a gravar de/para	³±±
±±³          ³ dDataTrans - Data para gravacao da movimentacao transferencia³±±
±±³          ³ cOcorren   - Codigo de ocorrencia para gravacao no SN4       ³±±
±±³          ³ nTaxaMedia - Taxa media para calculo de depreciacao          ³±±
±±³          ³ cLocOrig   - Local atual onde se encontra o ativo            ³±±
±±³          ³ aGrava     - Array com logicos indicando tipos de transfere- ³±±
±±³          ³              ncias efetuadas                                 ³±±
±±³          ³ nHdlPrv    - Handle de contabilizacao              			³±±
±±³          ³ cArquivo   - Nome do arquivo da contabilizacao     			³±±
±±³          ³ cFilDest   - Filial Destino                        			³±±
±±³          ³ cFilOrig   - Filial Origem                         			³±±
±±³          ³ aCtb       - Variavel para contabilizao multi-filial			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ATFA060													    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Af060GrvMov(aVar, aCpDigit, nX, dDataTrans, cOcorren, nTaxaMedia,;
							cLocOrig, aGrava, nHdlPrv, cArquivo, cFilDest, cFilOrig,;
							aCtb,cNota,cSerie)

Local cTipoTrDe, cTipoTrPara
//Local cLoteAtf 	:= LoteCont("ATF")
Local cLoteAtf := "500000"
Local lFilDif		:= .F.
Local cFilSN4		:= ""
Local aAreaSv		:= GetArea()
Local VALORIG		:= SN3->N3_VRDACM1
Local nLoopMoeda	:= 0
Local nTxMoeda		:= 0
Local aMeses		:= {}
Local nLoopDia		:= 0
Local lAltTaxa		:= .F.
Local nOldCLVL		:= SN3->N3_CLVL
Local nOldSubCTA 	:= SN3->N3_SUBCTA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acerta os campos especificos do SN3                    			      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nX == 1 .and. Iif(nNewCLVL == Nil,.F.,nNewCLVL <> SN3->N3_CLVL)
	RecLock("SN3",.F.)
	SN3->N3_CLVL := nNewCLVL
	MsUnlock()
Endif
If nX == 1 .and. Iif(nNewSubCTA == Nil,.F.,nNewSubCTA <> SN3->N3_SUBCTA)
	RecLock("SN3",.F.)
	SN3->N3_SUBCTA := nNewSubCTA
	MsUnlock()
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recalculo o SN3 para mudanca de taxa de depreciacao			         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nX == 1 .and. Iif(nNewTxDepr == Nil,.F.,nNewTxDepr <> SN3->N3_TXDEPR1)
	lAltTaxa			:= .T.
Endif
If nX == 2 .and. Iif(nNewTxDepr == Nil,.F.,nNewTxDepr <> SN3->N3_TXDEPR1)
	For nLoopMoeda := 1 to 5                                      
		/*
		nTxMoeda := 0		
		If nLoopMoeda := 1
			nTxMoeda := 1
		Else
			DbSelectArea("SM2")
			DbSetOrder(1)
			If DbSeek(SN3->N3_DINDEPR)
				nTxMoeda := &("SM2->M2_MOEDA"+Alltrim(Str(nLoopMoeda)))
			Endif
		Endif
		*/		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valores do Bem                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nValor   	:= &("SN3->N3_VORIG"+Alltrim(Str(nLoopMoeda)))
		nTxDepre 	:= nNewTxDepr
		nVlrDepMes 	:= nValor / ((12 / nTxDepre) * 100)
		nVlrDepDia 	:= nVlrDepMes / 30
		dFimDepr		:= Ctod("")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula os valores da depreciacao acumulada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aMeses 	:= {}   
		dDataIni := LastDay(SN3->N3_DINDEPR)+1   
		dDataFim := FirstDay(dDtTrans)-1
		
		For nLoopDia := dDataIni to dDataFim
			If aScan(aMeses, Left(Dtos(nLoopDia),6)) == 0
				Aadd(aMeses, Left(Dtos(nLoopDia),6))
			Endif
		Next nLoopDia                             
		nDias    	:= (30 - Day(SN3->N3_DINDEPR))+1
		
		If Len(aMeses) >= ((12 / nTxDepre) * 100)
			nMeses 	:= ((12 / nTxDepre) * 100)
			For nLoopMes := 1 to Len(aMeses)
				If nLoopMes <= ((12 / nTxDepre) * 100)
					dFimDepr := Stod(aMeses[nLoopMes]+StrZero(Day(SN3->N3_DINDEPR),2))
				Endif
			Next nLoopNes
		   nDepAcum 	:= &("SN3->N3_VORIG"+Alltrim(Str(nLoopMoeda)))
		Else
			nMeses   	:= Len(aMeses)
	   	nDepAcum 	:= (nVlrDepMes * nMeses) + (nVlrDepDia * nDias)
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula os valores da depreciacao do balanco³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(dFimDepr) .or. dFimDepr <= Ctod("31/12/08")
			nDepBal	:= 0
		Else
			aMeses 	:= {}                 
			If Year(SN3->N3_DINDEPR) < Year(dDtTrans)
				dDataIni := Stod(StrZero(Year(dDtTrans),4)+"0101")
			Else
				dDataIni := SN3->N3_DINDEPR
			Endif
				                          
			If dFimDepr <= FirstDay(dDtTrans)-1
				dDataFim := dFimDepr
			Else
				dDataFim := FirstDay(dDtTrans)-1
			Endif
			For nLoopDia := dDataIni to dDataFim
				If aScan(aMeses, Left(Dtos(nLoopDia),6)) == 0
					Aadd(aMeses, Left(Dtos(nLoopDia),6))
				Endif
			Next nLoopDia
			nDias    	:= (30 - Day(dDataIni))+1
			nMeses   	:= Len(aMeses)
		   nDepBal 		:= (nVlrDepMes * nMeses) + (nVlrDepDia * nDias)
		Endif
			   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Determina a depreciacao do mes              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dDataIni < Ctod("01/06/09")                          
			nDepMes  	:= nVlrDepMes
		Else
			nDias    	:= (30 - Day(SN3->N3_DINDEPR))+1
		   nDepMes  	:= nVlrDepDia * nDias
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o SN3                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SN3",.F.)
		&("SN3->N3_TXDEPR"+Alltrim(Str(nLoopMoeda)))	:= nTxDepre
		&("SN3->N3_VRDACM"+Alltrim(Str(nLoopMoeda)))	:= nDepAcum
		&("SN3->N3_VRDBAL"+Alltrim(Str(nLoopMoeda)))	:= nDepBal
		&("SN3->N3_VRDMES"+Alltrim(Str(nLoopMoeda)))	:= nDepMes
		MsUnlock()
	Next nLoopMoeda
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trata contas patrimoniais 											         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SN1->N1_PATRIM $ "N "
	cTipoTrDe  := "8"
	cTipoTrPara:= "9"
Elseif SN1->N1_PATRIM $ "CAS"
	cTipoTrDe  := "G"
	cTipoTrPara:= "I"
Else
	cTipotrDe  := "H"
	cTipotrPara:= "J"
Endif

If ValType(cFilDest) <> "U" .and. !Empty(cFilDest)
	If cFilDest <> cFilOrig
		lFilDif := .T.
	EndIf
EndIf

lBem			:= aGrava[1] .Or. lFilDif
lLocal		:= aGrava[6] 
lCorrecao	:= aGrava[2] .Or. lFilDif
lDepAcum		:= aGrava[3] .Or. lFilDif
lCorMDep		:= aGrava[4] .Or. lFilDif
lDespDep		:= aGrava[5] .Or. lFilDif

dbSelectArea("SN4")
cFilSN4	:= xFilial("SN4")
If lFilDif .And. nX = 2		// Mudo a filial atual para gravacao
	cFilAnt := cFilDest						// na filial de destino
	If !Empty(cFilDest) .and. !Empty(xFilial("SN4"))
		cFilSN4	:= cFilDest
	EndIf
Endif

If lBem .Or. lLocal
	Reclock ( "SN4",.T. )
	SN4 -> N4_FILIAL := cFilSN4
	SN4 -> N4_CBASE  := SN3->N3_CBASE
	SN4 -> N4_ITEM   := SN3->N3_ITEM
	SN4 -> N4_TIPO   := SN3->N3_TIPO
	SN4 -> N4_OCORR  := cOcorren
	SN4 -> N4_VLROC1 := SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1
	SN4 -> N4_VLROC2 := SN3->N3_VORIG2+SN3->N3_AMPLIA2
	SN4 -> N4_VLROC3 := SN3->N3_VORIG3+SN3->N3_AMPLIA3
	SN4 -> N4_VLROC4 := SN3->N3_VORIG4+SN3->N3_AMPLIA4
	SN4 -> N4_VLROC5 := SN3->N3_VORIG5+SN3->N3_AMPLIA5
	SN4 -> N4_DATA   := dDataTrans
	SN4 -> N4_CONTA  := SN3->N3_CCONTAB
	SN4 -> N4_TIPOCNT:= "1"
	SN4 -> N4_LOCAL  := Iif(nX == 1, cLocOrig, cLocAtivo)
	SN4 -> N4_TXMEDIA:= nTaxaMedia
	SN4 -> N4_NOTA   := cNota      
	SN4 -> N4_SERIE  := cSerie

// Utilizo as variaveis de contabilizacao pois caso nao seja alterada o conteudo
// estara em branco

	If cOcorren == "03" // Origem
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := &("SN3->"+aCpDigit[2][1])
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := &("SN3->"+aCpDigit[3][1])
		Endif	
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := &("SN3->"+aCpDigit[4][1])
		Endif	
//				 { { "N3_CCONTAB", "N3_CCORREC", "N3_CDEPREC", "N3_CCDEPR", "N3_CDESP", "N3_CCUSTO", "SN1->N1_LOCAL" } }
//	Aadd(aCpDigit, { "N3_CUSTBEM", "N3_CCCORR", "N3_CCDESP", "N3_CCCDEP", "N3_CCCDES" })
//	Aadd(aCpDigit, { "N3_SUBCCON", "N3_SUBCCOR", "N3_SUBCDEP", "N3_SUBCCDE", "N3_SUBCDES" })
//	Aadd(aCpDigit, { "N3_CLVLCON", "N3_CLVLCOR", "N3_CLVLDEP", "N3_CLVLCDE", "N3_CLVLDES" })
	Else // Destino
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := If(ALLTRIM(aVar[2][1]) == "*", &("SN3->"+aCpDigit[2][1]), CUSTBEMCTB ) /// SE DESTINO = * DESTINO=ORIGEM
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := If(ALLTRIM(aVar[3][1]) == "*", &("SN3->"+aCpDigit[3][1]), SUBCCONCTB ) /// SE DESTINO = * DESTINO=ORIGEM
		EndIf
		If Len(aCpDigit) >= 4		
			SN4 -> N4_CLVL   := If(ALLTRIM(aVar[4][1]) == "*", &("SN3->"+aCpDigit[4][1]), CLVLCONCTB ) /// SE DESTINO = * DESTINO=ORIGEM
		EndIf
	Endif	
	
	SN4 -> N4_SEQ    := SN3->N3_SEQ
	SN4 -> N4_SEQREAV:= SN3->N3_SEQREAV
	If cFilOrig <> Nil
		If nX == 1 .and. cFilDest <> Nil
			SN4->N4_FILORIG := cFilDest
		Else
			SN4->N4_FILORIG := cFilOrig		
		EndIf
	Endif
	MsUnlock()

	If .F. // Habilitar caso utilizar contabilizacao baseada SN4 mv_par01 == 1   //Contabiliza
		If cFilDest = Nil .And. cFilOrig = Nil
			If NX = 1 .And. VerPadrao("830")
				Af060VarCtb(aVar, aCpDigit)

				//If lPrim
				//	nHdlPrv := HeadProva(cLoteAtf,"ATFA060",Substr(cUsuario,7,6),@cArquivo)
				//	lPrim := .f.
				//Endif
				//nTotal += DetProva( nHdlPrv,"830","ATFA060",cLoteAtf)
				RecLock("CTBTRF",.T.)
				CTBTRF->NCPADRAO		:= Iif(lAltTaxa,"930","830")
				CTBTRF->NCTABEM			:= CTABEM
				CTBTRF->NDESPDEPR		:= DESPDEPR
				CTBTRF->NDEPREACUM		:= DEPREACUM
				CTBTRF->NCORREDEPR		:= CORREDEPR
				CTBTRF->NCORREBEM		:= CORREBEM
				CTBTRF->NCUSTO			:= CUSTO
				CTBTRF->NVALORIG		:= VALORIG
				CTBTRF->N3_SUBCCON	:= SN3->N3_SUBCCON
				CTBTRF->N3_CLVLCON	:= SN3->N3_CLVLCON
				CTBTRF->RECSN3			:= SN3->(Recno())
				MsUnlock()
				/*												
				Aadd(aContabTrf,{	Iif(lAltTaxa,"930","830"),;
										CTABEM,;
										DESPDEPR,;
										DEPREACUM,;
										CORREDEPR,;
										CORREBEM,;
										CUSTO,;
										VALORIG,;
										SN3->N3_SUBCCON,;
										SN3->N3_CLVLCON,;
										SN3->(Recno())})
				*/
			Endif
		Else
			If VerPadrao("831")
				Af060VarCtb(aVar, aCpDigit, aCtb[1], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif

			cFilAnt := cFilDest		
			If VerPadrao("832")  // FIL DESTINO
				Af060VarCtb(aVar, aCpDigit, aCtb[2], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif
			cFilAnt := cFilOrig
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizar contas na transf de contas.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ATFSaldo(	SN3->N3_CCONTAB, dDataTrans, If(nX = 1, cTipoTrDe, cTipoTrPara),;
				SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1,;
				SN3->N3_VORIG2+SN3->N3_AMPLIA2,;
				SN3->N3_VORIG3+SN3->N3_AMPLIA3,;
				SN3->N3_VORIG4+SN3->N3_AMPLIA4,;
				SN3->N3_VORIG5+SN3->N3_AMPLIA5, "+", nTaxaMedia,;
				SN3->N3_SUBCCON,,SN3->N3_CLVLCON,SN3->N3_CUSTBEM,"1")
Endif

If lCorrecao
	Reclock ( "SN4",.T. )
	SN4 -> N4_FILIAL := cFilSN4
	SN4 -> N4_CBASE  := SN3->N3_CBASE
	SN4 -> N4_ITEM   := SN3->N3_ITEM
	SN4 -> N4_TIPO   := SN3->N3_TIPO
	SN4 -> N4_OCORR  := cOcorren
	SN4 -> N4_VLROC1 := SN3->N3_VRCACM1
	SN4 -> N4_DATA   := dDataTrans
	SN4 -> N4_CONTA  := SN3->N3_CCORREC
	SN4 -> N4_TIPOCNT:= "2"
	SN4 -> N4_LOCAL  := Iif(nX == 1, cLocOrig, cLocAtivo)
	SN4 -> N4_TXMEDIA:= nTaxaMedia
	SN4 -> N4_NOTA   := cNota      
	SN4 -> N4_SERIE  := cSerie
// Utilizo as variaveis de contabilizacao pois caso nao seja alterada o conteudo
// estara em branco

	If cOcorren == "03" // Origem
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := &("SN3->"+aCpDigit[2][2])
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := &("SN3->"+aCpDigit[3][2])
		Endif	
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := &("SN3->"+aCpDigit[4][2])
		Endif	
//				 { { "N3_CCONTAB", "N3_CCORREC", "N3_CDEPREC", "N3_CCDEPR", "N3_CDESP", "N3_CCUSTO", "SN1->N1_LOCAL" } }
//	Aadd(aCpDigit, { "N3_CUSTBEM", "N3_CCCORR", "N3_CCDESP", "N3_CCCDEP", "N3_CCCDES" })
//	Aadd(aCpDigit, { "N3_SUBCCON", "N3_SUBCCOR", "N3_SUBCDEP", "N3_SUBCCDE", "N3_SUBCDES" })
//	Aadd(aCpDigit, { "N3_CLVLCON", "N3_CLVLCOR", "N3_CLVLDEP", "N3_CLVLCDE", "N3_CLVLDES" })

	Else // Destino
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := If(ALLTRIM(aVar[2][2]) == "*", &("SN3->"+aCpDigit[2][2]), CCCORRCTB ) // SE DESTINO = * DESTINO = ORIGEM
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := If(ALLTRIM(aVar[3][2]) == "*", &("SN3->"+aCpDigit[3][2]), SUBCCORCTB) // SE DESTINO = * DESTINO = ORIGEM
		EndIf
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := If(ALLTRIM(aVar[4][2]) == "*", &("SN3->"+aCpDigit[4][2]), CLVLCORCTB) // SE DESTINO = * DESTINO = ORIGEM
		EndIf
	Endif	
	SN4 -> N4_SEQ    := SN3->N3_SEQ
	SN4 -> N4_SEQREAV:= SN3->N3_SEQREAV
	If cFilOrig <> Nil
		If nX == 1 .and. cFilDest <> Nil
			SN4->N4_FILORIG := cFilDest
		Else
			SN4->N4_FILORIG := cFilOrig		
		EndIf
	Endif
	MsUnlock()

	If .F. // Habilitar caso utilizar contabilizacao baseada SN4 mv_par01 == 1   //Contabiliza
		If cFilDest = Nil .And. cFilOrig = Nil
			If NX = 1 .And. VerPadrao("830")
				Af060VarCtb(aVar, aCpDigit)

				//If lPrim
				//	nHdlPrv := HeadProva(cLoteAtf,"ATFA060",Substr(cUsuario,7,6),@cArquivo)
				//	lPrim := .f.
				//Endif
				//nTotal += DetProva( nHdlPrv,"830","ATFA060",cLoteAtf)
				RecLock("CTBTRF",.T.)
				CTBTRF->NCPADRAO		:= Iif(lAltTaxa,"930","830")
				CTBTRF->NCTABEM			:= CTABEM
				CTBTRF->NDESPDEPR		:= DESPDEPR
				CTBTRF->NDEPREACUM		:= DEPREACUM
				CTBTRF->NCORREDEPR		:= CORREDEPR
				CTBTRF->NCORREBEM		:= CORREBEM
				CTBTRF->NCUSTO			:= CUSTO
				CTBTRF->NVALORIG		:= VALORIG
				CTBTRF->N3_SUBCCON	:= SN3->N3_SUBCCON
				CTBTRF->N3_CLVLCON	:= SN3->N3_CLVLCON
				CTBTRF->RECSN3			:= SN3->(Recno())
				MsUnlock()
				/*				
				Aadd(aContabTrf,{	Iif(lAltTaxa,"930","830"),;
										CTABEM,;
										DESPDEPR,;
										DEPREACUM,;
										CORREDEPR,;
										CORREBEM,;
										CUSTO,;
										VALORIG,;
										SN3->N3_SUBCCON,;
										SN3->N3_CLVLCON,;
										SN3->(Recno())})
										*/
			Endif
		Else
			If VerPadrao("831")
				Af060VarCtb(aVar, aCpDigit, aCtb[1], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif

			cFilAnt := cFilDest		
			If VerPadrao("832")  // FIL DESTINO
				Af060VarCtb(aVar, aCpDigit, aCtb[2], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif
			cFilAnt := cFilOrig
		Endif
	Endif

	ATFSaldo(SN3->N3_CCORREC, dDataTrans, If(nX = 1, cTipoTrDe, cTipoTrPara),;
			 SN3->N3_VRCACM1, 0 , 0 , 0 , 0  , "+", nTaxaMedia,;
			 SN3->N3_SUBCCOR,,SN3->N3_CLVLCOR,SN3->N3_CCCORR,"2")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transferencia da conta de despesa de depreciacao. Nao transfiro o va³
//³ lor,mas registro no SN4 a transf. da conta para que apare‡a no rela-³
//³ t¢rio de transferencia do conta de despesa de deprecia‡Æo.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lDespDep
	Reclock ( "SN4",.T. )
	SN4 -> N4_FILIAL := cFilSN4
	SN4 -> N4_CBASE  := SN3->N3_CBASE
	SN4 -> N4_ITEM   := SN3->N3_ITEM
	SN4 -> N4_TIPO   := SN3->N3_TIPO
	SN4 -> N4_OCORR  := cOcorren
	SN4 -> N4_DATA   := dDataTrans
	SN4 -> N4_CONTA  := SN3->N3_CDEPREC
	SN4 -> N4_TIPOCNT:= "3"
	SN4 -> N4_LOCAL  := Iif(nX == 1, cLocOrig, cLocAtivo)
	SN4 -> N4_TXMEDIA:= nTaxaMedia
	SN4 -> N4_NOTA   := cNota      
	SN4 -> N4_SERIE  := cSerie
// Utilizo as variaveis de contabilizacao pois caso nao seja alterada o conteudo
// estara em branco

	If cOcorren == "03" // Origem
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := &("SN3->"+aCpDigit[2][3])
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := &("SN3->"+aCpDigit[3][3])
		Endif	
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := &("SN3->"+aCpDigit[4][3])
		Endif	
//				 { { "N3_CCONTAB", "N3_CCORREC", "N3_CDEPREC", "N3_CCDEPR",  "N3_CDESP", "N3_CCUSTO", "SN1->N1_LOCAL" } }
//	Aadd(aCpDigit, { "N3_CUSTBEM", "N3_CCCORR" , "N3_CCDESP" , "N3_CCCDEP",  "N3_CCCDES" })
//	Aadd(aCpDigit, { "N3_SUBCCON", "N3_SUBCCOR", "N3_SUBCDEP", "N3_SUBCCDE", "N3_SUBCDES" })
//	Aadd(aCpDigit, { "N3_CLVLCON", "N3_CLVLCOR", "N3_CLVLDEP", "N3_CLVLCDE", "N3_CLVLDES" })

	Else // Destino
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := If(ALLTRIM(aVar[2][3]) == "*", &("SN3->"+aCpDigit[2][3]), CCDESPCTB ) 
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := If(ALLTRIM(aVar[3][3]) == "*", &("SN3->"+aCpDigit[3][3]), SUBCDEPCTB)
		EndIf
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := If(ALLTRIM(aVar[4][3]) == "*", &("SN3->"+aCpDigit[4][3]), CLVLDEPCTB)
		EndIf
	Endif	

	SN4 -> N4_SEQ    := SN3->N3_SEQ
	SN4 -> N4_SEQREAV:= SN3->N3_SEQREAV
	If cFilOrig <> Nil
		If nX == 1 .and. cFilDest <> Nil
			SN4->N4_FILORIG := cFilDest
		Else
			SN4->N4_FILORIG := cFilOrig		
		EndIf
	Endif
	MsUnlock()
EndIf
If lDepAcum
	Reclock ( "SN4",.T. )
	SN4 -> N4_FILIAL := cFilSN4
	SN4 -> N4_CBASE  := SN3->N3_CBASE
	SN4 -> N4_ITEM   := SN3->N3_ITEM
	SN4 -> N4_TIPO   := SN3->N3_TIPO
	SN4 -> N4_OCORR  := cOcorren
	SN4 -> N4_VLROC1 := SN3->N3_VRDACM1+SN3->N3_VRCDA1
	SN4 -> N4_VLROC2 := SN3->N3_VRDACM2
	SN4 -> N4_VLROC3 := SN3->N3_VRDACM3
	SN4 -> N4_VLROC4 := SN3->N3_VRDACM4
	SN4 -> N4_VLROC5 := SN3->N3_VRDACM5
	SN4 -> N4_DATA   := dDataTrans
	SN4 -> N4_CONTA  := SN3->N3_CCDEPR
	SN4 -> N4_TIPOCNT:= "4"
	SN4 -> N4_LOCAL  := Iif(nX == 1, cLocOrig, cLocAtivo)
	SN4 -> N4_TXMEDIA:= nTaxaMedia
	SN4 -> N4_NOTA   := cNota      
	SN4 -> N4_SERIE  := cSerie
// Utilizo as variaveis de contabilizacao pois caso nao seja alterada o conteudo
// estara em branco

	If cOcorren == "03" // Origem
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := &("SN3->"+aCpDigit[2][4])
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := &("SN3->"+aCpDigit[3][4])
		Endif	
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := &("SN3->"+aCpDigit[4][4])
		Endif	
//				 { { "N3_CCONTAB", "N3_CCORREC", "N3_CDEPREC", "N3_CCDEPR" , "N3_CDESP", "N3_CCUSTO", "SN1->N1_LOCAL" } }
//	Aadd(aCpDigit, { "N3_CUSTBEM", "N3_CCCORR",  "N3_CCDESP" , "N3_CCCDEP" , "N3_CCCDES" })
//	Aadd(aCpDigit, { "N3_SUBCCON", "N3_SUBCCOR", "N3_SUBCDEP", "N3_SUBCCDE", "N3_SUBCDES" })
//	Aadd(aCpDigit, { "N3_CLVLCON", "N3_CLVLCOR", "N3_CLVLDEP", "N3_CLVLCDE", "N3_CLVLDES" })

	Else // Destino
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := If(ALLTRIM(aVar[2][4]) == "*", &("SN3->"+aCpDigit[2][4]),CCCDEPCTB )
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := If(ALLTRIM(aVar[3][4]) == "*", &("SN3->"+aCpDigit[3][4]),SUBCCDECTB)
		EndIf
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := If(ALLTRIM(aVar[4][4]) == "*", &("SN3->"+aCpDigit[4][4]),CLVLCDECTB)
		EndIf
	Endif	

	SN4 -> N4_SEQ    := SN3->N3_SEQ
	SN4 -> N4_SEQREAV:= SN3->N3_SEQREAV
	If cFilOrig <> Nil
		If nX == 1 .and. cFilDest <> Nil
			SN4->N4_FILORIG := cFilDest
		Else
			SN4->N4_FILORIG := cFilOrig		
		EndIf
	Endif
	MsUnlock()

	If .F. // Habilitar caso utilizar contabilizacao baseada SN4 mv_par01 == 1   //Contabiliza
		If cFilDest = Nil .And. cFilOrig = Nil
			If NX = 1 .And. VerPadrao("830")
				Af060VarCtb(aVar, aCpDigit)

				//If lPrim
				//	nHdlPrv := HeadProva(cLoteAtf,"ATFA060",Substr(cUsuario,7,6),@cArquivo)
				//	lPrim := .f.
				//Endif
				//nTotal += DetProva( nHdlPrv,"830","ATFA060",cLoteAtf)
				RecLock("CTBTRF",.T.)
				CTBTRF->NCPADRAO		:= Iif(lAltTaxa,"930","830")
				CTBTRF->NCTABEM			:= CTABEM
				CTBTRF->NDESPDEPR		:= DESPDEPR
				CTBTRF->NDEPREACUM		:= DEPREACUM
				CTBTRF->NCORREDEPR		:= CORREDEPR
				CTBTRF->NCORREBEM		:= CORREBEM
				CTBTRF->NCUSTO			:= CUSTO
				CTBTRF->NVALORIG		:= VALORIG
				CTBTRF->N3_SUBCCON	:= SN3->N3_SUBCCON
				CTBTRF->N3_CLVLCON	:= SN3->N3_CLVLCON
				CTBTRF->RECSN3			:= SN3->(Recno())
				MsUnlock()
				/*
				Aadd(aContabTrf,{	Iif(lAltTaxa,"930","830"),;
										CTABEM,;
										DESPDEPR,;
										DEPREACUM,;
										CORREDEPR,;
										CORREBEM,;
										CUSTO,;
										VALORIG,;
										SN3->N3_SUBCCON,;
										SN3->N3_CLVLCON,;
										SN3->(Recno())})
										*/
			Endif
		Else
			If VerPadrao("831")
				Af060VarCtb(aVar, aCpDigit, aCtb[1], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif

			cFilAnt := cFilDest		
			If VerPadrao("832")  // FIL DESTINO
				Af060VarCtb(aVar, aCpDigit, aCtb[2], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif
			cFilAnt := cFilOrig
		Endif
	Endif

	ATFSaldo(	SN3->N3_CCDEPR , dDataTrans, If(nX = 1, cTipoTrDe, cTipoTrPara),;
			 	SN3->N3_VRDACM1+SN3->N3_VRCDA1, SN3->N3_VRDACM2,;
			 	SN3->N3_VRDACM3, SN3->N3_VRDACM4, SN3->N3_VRDACM5,;
			 	"+", nTaxaMedia,SN3->N3_SUBCCDE,,SN3->N3_CLVLCDE,SN3->N3_CCCDEP,"4")
EndIf
	
If lCorMDep
	Reclock ( "SN4",.T. )
	SN4 -> N4_FILIAL := cFilSN4
	SN4 -> N4_CBASE  := SN3->N3_CBASE
	SN4 -> N4_ITEM   := SN3->N3_ITEM
	SN4 -> N4_TIPO   := SN3->N3_TIPO
	SN4 -> N4_OCORR  := cOcorren
	SN4 -> N4_VLROC1 := SN3->N3_VRCDA1
	SN4 -> N4_DATA   := dDataTrans
	SN4 -> N4_CONTA  := SN3->N3_CDESP
	SN4 -> N4_TIPOCNT:= "5"
	SN4 -> N4_LOCAL  := Iif(nX == 1, cLocOrig, cLocAtivo)
	SN4 -> N4_TXMEDIA:= nTaxaMedia
	SN4 -> N4_NOTA   := cNota      
	SN4 -> N4_SERIE  := cSerie
// Utilizo as variaveis de contabilizacao pois caso nao seja alterada o conteudo
// estara em branco

	If cOcorren == "03" // Origem
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := &("SN3->"+aCpDigit[2][5])
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := &("SN3->"+aCpDigit[3][5])
		Endif	
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := &("SN3->"+aCpDigit[4][5])
		Endif	

//				 { { "N3_CCONTAB", "N3_CCORREC", "N3_CDEPREC", "N3_CCDEPR" , "N3_CDESP", "N3_CCUSTO", "SN1->N1_LOCAL" } }
//	Aadd(aCpDigit, { "N3_CUSTBEM", "N3_CCCORR" , "N3_CCDESP" , "N3_CCCDEP" , "N3_CCCDES" })
//	Aadd(aCpDigit, { "N3_SUBCCON", "N3_SUBCCOR", "N3_SUBCDEP", "N3_SUBCCDE", "N3_SUBCDES" })
//	Aadd(aCpDigit, { "N3_CLVLCON", "N3_CLVLCOR", "N3_CLVLDEP", "N3_CLVLCDE", "N3_CLVLDES" })

	Else // Destino
		If Len(aCpDigit) >= 2
		SN4 -> N4_CCUSTO := If(ALLTRIM(aVar[2][5]) == "*", &("SN3->"+aCpDigit[2][5]),CCCDESCTB )
		EndIf
		If Len(aCpDigit) >= 3
			SN4 -> N4_SUBCTA := If(ALLTRIM(aVar[3][5]) == "*", &("SN3->"+aCpDigit[3][5]),SUBCDESCTB)
		EndIf
		If Len(aCpDigit) >= 4
			SN4 -> N4_CLVL   := If(ALLTRIM(aVar[4][5]) == "*", &("SN3->"+aCpDigit[4][5]),CLVLDESCTB)
		EndIf
	Endif	
	
	SN4 -> N4_SEQ    := SN3->N3_SEQ
	SN4 -> N4_SEQREAV:= SN3->N3_SEQREAV
	If cFilOrig <> Nil
		If nX == 1 .and. cFilDest <> Nil
			SN4->N4_FILORIG := cFilDest
		Else
			SN4->N4_FILORIG := cFilOrig		
		EndIf
	Endif
	MsUnlock()

	If .F. // Habilitar caso utilizar contabilizacao baseada SN4 mv_par01 == 1   //Contabiliza
		If cFilDest = Nil .And. cFilOrig = Nil
			If NX = 1 .And. VerPadrao("830")
				Af060VarCtb(aVar, aCpDigit)

				//If lPrim
				//	nHdlPrv := HeadProva(cLoteAtf,"ATFA060",Substr(cUsuario,7,6),@cArquivo)
				//	lPrim := .f.
				//Endif
				//nTotal += DetProva( nHdlPrv,"830","ATFA060",cLoteAtf)
				RecLock("CTBTRF",.T.)
				CTBTRF->NCPADRAO		:= Iif(lAltTaxa,"930","830")
				CTBTRF->NCTABEM			:= CTABEM
				CTBTRF->NDESPDEPR		:= DESPDEPR
				CTBTRF->NDEPREACUM		:= DEPREACUM
				CTBTRF->NCORREDEPR		:= CORREDEPR
				CTBTRF->NCORREBEM		:= CORREBEM
				CTBTRF->NCUSTO			:= CUSTO
				CTBTRF->NVALORIG		:= VALORIG
				CTBTRF->N3_SUBCCON	:= SN3->N3_SUBCCON
				CTBTRF->N3_CLVLCON	:= SN3->N3_CLVLCON
				CTBTRF->RECSN3			:= SN3->(Recno())
				MsUnlock()
				/*
				Aadd(aContabTrf,{	Iif(lAltTaxa,"930","830"),;
										CTABEM,;
										DESPDEPR,;
										DEPREACUM,;
										CORREDEPR,;
										CORREBEM,;
										CUSTO,;
										VALORIG,;
										SN3->N3_SUBCCON,;
										SN3->N3_CLVLCON,;
										SN3->(Recno())})*/
			Endif
		Else
			If VerPadrao("831")
				Af060VarCtb(aVar, aCpDigit, aCtb[1], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif

			cFilAnt := cFilDest		
			If VerPadrao("832")  // FIL DESTINO
				Af060VarCtb(aVar, aCpDigit, aCtb[2], 	SN1->(Recno()),;
							SN3->(Recno()), SN4->(Recno()), cFilDest, cFilOrig)
			Endif
			cFilAnt := cFilOrig
		Endif
	Endif

	ATFSaldo(	SN3->N3_CDESP  , dDataTrans, If(nX = 1, cTipoTrDe, cTipoTrPara),;
				SN3->N3_VRCDA1 , 0 , 0 , 0 , 0 , "+",nTaxaMedia,;
				SN3->N3_SUBCDES,,SN3->N3_CLVLDES,SN3->N3_CCCDES,"5")
EndIf

If cFilDest <> cFilOrig
	cFilAnt := cFilOrig
Endif

//If mv_par01 == 1   //Contabiliza
	//If cFilDest = Nil .And. cFilOrig = Nil
		If NX = 1 .or. lAltTaxa//.And. VerPadrao("830")
			Af060VarCtb(aVar, aCpDigit)
			//If lPrim
			//	nHdlPrv := HeadProva(cLoteAtf,"ATFA060",Substr(cUsuario,7,6),@cArquivo)
			//	lPrim := .f.
			//Endif
			//nTotal += DetProva( nHdlPrv,"830","ATFA060",cLoteAtf)
			cPadrao := Iif(lAltTaxa,"930","830")
			nRecSN3 := SN3->(Recno())
			RecLock("CTBTRF",.T.)
			CTBTRF->NCPADRAO		:= cPadrao
			CTBTRF->NCTABEM			:= SN3->N3_CCONTAB
			CTBTRF->NDESPDEPR		:= SN3->N3_CDEPREC
			CTBTRF->NDEPREACUM		:= SN3->N3_CCDEPR
			CTBTRF->NCORREDEPR		:= SN3->N3_CDESP
			CTBTRF->NCORREBEM		:= SN3->N3_CCORREC
			CTBTRF->NCUSTO			:= SN3->N3_CCUSTO
			CTBTRF->NVALORIG		:= VALORIG
			CTBTRF->N3_SUBCCON	:= nOldSubCTA
			CTBTRF->N3_CLVLCON	:= nOldCLVL
			CTBTRF->RECSN3			:= nRecSN3
			CTBTRF->RECSN1			:= SN1->(Recno())
			MsUnlock()
			/*
			Aadd(aContabTrf,{	cPadrao,;
									SN3->N3_CCONTAB,;
									SN3->N3_CDEPREC,;
									SN3->N3_CCDEPR,;
									SN3->N3_CDESP,;
									SN3->N3_CCORREC,;
									SN3->N3_CCUSTO,;
									VALORIG,;               
									SN3->N3_SUBCTA,;
									SN3->N3_CLVL,;
									nRecSN3,;
									SN1->(Recno())})*/
		Endif
		/*
	ElseIf nX = 1
		If VerPadrao("831")
			Af060VarCtb(aVar, aCpDigit, aCtb[1], 	SN1->(Recno()), SN3->(Recno()),;
						SN4->(Recno()), cFilDest, cFilOrig)
		Endif

		cFilAnt := cFilDest		
		If VerPadrao("832")  // FIL DESTINO
			Af060VarCtb(aVar, aCpDigit, aCtb[2], 	SN1->(Recno()), SN3->(Recno()),;
						SN4->(Recno()))
		Endif
		cFilAnt := cFilOrig
	Endif*/
//Endif
/*	
If lAF060GSN4
	ExecBlock("AF060GSN4",.F.,.F.)
EndIf
*/
RestArea(aAreaSv)
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Af060Grupo³ Autor ³ Claudio Donizete   	  ³ Data ³19/10/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Perenche as entidades contabeis de acordo com o grupo		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ATFA060  																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Af060Grupo(cGrupo,aCpDigit, aVar)
Local nX, nY

If !Empty(cGrupo)
	SNG->(MsSeek(xFilial("SNG")+cGrupo))
	For nX := 1 To Len(aVar)
		For nY := 1 To Len(aVar[nX])
			// Se o campo da entidade contabil existir no SNG, associa a variavel de memoria exibida na tela
			If SNG->(FieldPos("NG"+SubStr(aCpDigit[nX][nY],At("_",aCpDigit[nX][nY])))) > 0 .And.;
				!Empty(SNG->&("NG"+SubStr(aCpDigit[nX][nY],At("_",aCpDigit[nX][nY]))))
				aVar[nX][nY] := SNG->&("NG"+SubStr(aCpDigit[nX][nY],At("_",aCpDigit[nX][nY])))
			Endif	
		Next
	Next
Endif

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Af060Get  ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 22.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta get de acordo com a entidade contabil atual           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ParA1  = Array com variaveis da entidade atual              ³±±
±±³          ³ ParC1  = Campo para apresentacao da coluna origem           ³±±
±±³          ³ ParC2  = Alias para apresentacao F3                         ³±±
±±³          ³ ParN1  = Linha atual da montagem da tela                    ³±±
±±³          ³ ParO1  = Dialog em que os objetos serao criados             ³±±
±±³          ³ ParB1  = Bloco de codigo para apresentar descricao          ³±±
±±³          ³ ParA2  = Array com os objetos da tela                       ³±±
±±³          ³ ParN1  = Posicao da variavel de objetos de tela             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ATFA060													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Af060Get(	aVar, cCampo, cAliasF3, nLin, oPai, bDescricao, aObjeto, nObjeto)

Local cLabel, oGet
/*
If nObjeto = 1
	cLabel := STR0022
ElseIf nObjeto = 2	
	cLabel := STR0023
ElseIf nObjeto = 3
	cLabel := STR0024
ElseIf nObjeto = 4
	cLabel := STR0025
ElseIf nObjeto = 5
	cLabel := STR0026
Endif
*/
If lAuto
	aVar[nObjeto] := If(Type(cCampo)="C","*"+Space(Len(&cCampo)-1),CriaVar(cCampo))
Else
	aVar[nObjeto] := &cCampo
Endif
Eval(bDescricao, aVar[nObjeto])
/*
@ nLin-0,P_LABEL	SAY cLabel				SIZE 53, 07 OF oPai PIXEL
If ! lAuto
	@ nLin-1,P_ORIGEM 	MSGET &cCampo        	SIZE 69, 10 OF oPai PIXEL  When .f.
	@ nLin-1,P_DESTINO	MSGET oGet VAR aVar[nObjeto]		SIZE 69, 10 OF oPai PIXEL Picture "@!";
						WHEN ((cFilAnt := cFilDest), .T.) 	F3 cAliasF3;
						Valid AF060Conta( @aVar[nObjeto],cAliasF3,aObjeto,nObjeto) .And.;
						((cFilAnt := cFilOrig), .T.)
	@ nLin-0,P_DESTINO + 70 SAY aObjeto[nObjeto]	PROMPT Eval(bDescricao, aVar[nObjeto]);
						Of oPai PIXEL FONT oPai:oFont COLOR CLR_HBLUE
Else
	@ nLin-1,P_ORIGEM 	MSGET oGet VAR aVar[nObjeto]		SIZE 69, 10 OF oPai PIXEL Picture "@!";
						WHEN ((cFilAnt := cFilDest), .T.) 	F3 cAliasF3;
						Valid (Alltrim(aVar[nObjeto]) == "*" .or. AF060Conta( @aVar[nObjeto],cAliasF3,aObjeto,nObjeto)) .And.;
						((cFilAnt := cFilOrig), .T.)
	@ nLin-0,P_ORIGEM + 70 SAY aObjeto[nObjeto]	PROMPT Eval(bDescricao, aVar[nObjeto]);
						Of oPai PIXEL FONT oPai:oFont COLOR CLR_HBLUE
Endif                          
*/
nLin += P_ESPACO_OBJ
//oGet:cReadVar := cCampo
	
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDEF  º Autor ³Eduardo de Souza    º Data ³12/Jan/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Implementa menu funcional                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menus                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    3 - Duplica o registro corrente do Banco de Dados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MenuDef()
Local aRotina 	:= {	{ STR0001, "AxPesqui"  , 0 , 0},; // "Pesquisar"
							{ STR0002, "ATFVISUAL" , 0 , 0},; // "Visualizar"
							{ STR0003, "AF060Trans", 0 , 4},; // "Transferir"
							{ STR0004, "AF060Auto" , 0 , 5},; // "Automatico"
							{ STR0046, "AF190Trans(1)", 0 , 4}}  // "Transf.Resp."
Return aRotina
