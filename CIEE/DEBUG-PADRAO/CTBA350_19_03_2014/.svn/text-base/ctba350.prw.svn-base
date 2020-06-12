#Include "CTBA350.Ch"
#Include "PROTHEUS.Ch"

#DEFINE D_PRELAN	"9"

// 17/08/2009 -- Filial com mais de 2 caracteres

// TRADUÇÃO RELEASE P10 1.2 - 21/07/08

STATIC __lBlind  := IsBlind()
STATIC __aRptLog := {}
STATIC __cTEMPOS := ""

STATIC lAtSldBase
STATIC lCusto
STATIC lItem
STATIC lClVl
STATIC lCtb350Ef
STATIC lEfeLanc
STATIC lCT350QRY
STATIC lCT350TRC
STATIC lCT350TSL
STATIC nQtdEntid

//AMARRACAO
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBA350  ³ Autor ³ Simone Mie Sato       ³ Data ³ 14/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetiva os pre-lancamentos                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBA350()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTBA350()

Local nOpca 	:= 0
Local aSays 	:= {}, aButtons := {}
Local aCampos	:= {{"DDATA","C",10,0},;
{"LOTE","C",Len(CriaVar("CT2_LOTE")),0},;
{"DOC","C",Len(CriaVar("CT2_DOC")),0},;
{"MOEDA","C",Len(CriaVar("CT2_MOEDLC")),0},;
{"VLRDEB","N",16,2},;
{"VLRCRD","N",16,2},;
{"DESCINC","C",80,0}}

Local cArqTrab  := ""
Local cChave 	:= ""
Local lRet		:= .T.
Local aPergs	:= {}
Local aHelpPor	:= {}
Local aHelpEsp	:= {}
Local aHelpEng	:= {}
Local nCont		:= 0
Local nX

Private cCadastro := OemToAnsi(OemtoAnsi(STR0001))  //"Efetivacao de Pre-Lancamentos"

PRIVATE wnrel
PRIVATE cString   	:= "CT2"
PRIVATE cDesc1    	:= OemToAnsi(STR0002)  //"Esta rotina ir  efetivar os Pre-lancamentos e emitir"
PRIVATE cDesc2    	:= OemToAnsi(STR0003)  //"o log da efetivacao. "
PRIVATE cDesc3    	:= ""
PRIVATE titulo    	:= OemToAnsi(STR0004)  //"Log Validacao Efetivacao"
PRIVATE cCancel   	:= OemToAnsi(STR0006)  //"***** CANCELADO PELO OPERADOR *****"
PRIVATE aReturn   	:= { OemToAnsi(STR0007), 1, OemToAnsi(STR0008), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog  	:= "CTBA170"
PRIVATE aLinha    	:= { },nLastKey := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do Cabecalho.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
PRIVATE cabec1    	:= OemToAnsi(STR0005)		  // DATA    LOTE     DOC      MOEDA         VALOR DEBITO      VALOR CREDITO  INCONSISTENCIA
PRIVATE cabec2    	:= " "

Private aCtbEntid
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

If nQtdEntid == NIL
	nQtdEntid := If(FindFunction("CtbQtdEntd"),CtbQtdEntd(),4) //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
EndIf

If aCtbEntid == NIL
	aCtbEntid := Array(2,nQtdEntid)  //posicao 1=debito  2=credito
EndIf

//DEBITO
aCtbEntid[1,1] := {|| TMP->CT2_DEBITO   }
aCtbEntid[1,2] := {|| TMP->CT2_CCD      }
aCtbEntid[1,3] := {|| TMP->CT2_ITEMD    }
aCtbEntid[1,4] := {|| TMP->CT2_CLVLDB   }
//CREDITO
aCtbEntid[2,1] := {|| TMP->CT2_CREDITO  }
aCtbEntid[2,2] := {|| TMP->CT2_CCC      }
aCtbEntid[2,3] := {|| TMP->CT2_ITEMC    }
aCtbEntid[2,4] := {|| TMP->CT2_CLVLCR   }

For nX := 5 TO nQtdEntid
	aCtbEntid[1, nX] := MontaBlock("{|| TMP->CT2_EC"+StrZero(nX,2)+"DB } ")  //debito
	aCtbEntid[2, nX] := MontaBlock("{|| TMP->CT2_EC"+StrZero(nX,2)+"CR } ")  //credito
Next

lAtSldBase	:= ( GetMv("MV_ATUSAL") == "S" )
lCusto		:= CtbMovSaldo("CTT")
lItem 		:= CtbMovSaldo("CTD")
lClVl		:= CtbMovSaldo("CTH")
lCtb350Ef	:= ExistBlock("CTB350EF")
lEfeLanc 	:= ExistBlock("EFELANC")
lCT350QRY	:= GetNewPar( "MV_CT350QY", .T.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)
lCT350TRC	:= GetNewPar( "MV_CT350TC", .F.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)
lCT350TSL	:= GetNewPar( "MV_CT350SL", .T.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)


CtAjustSx1( "CTB350" ) // ajusta as perguntas("CTB350", aPergs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Numero do Lote Inicial                           ³
//³ mv_par02 // Numero do Lote Final                             ³
//³ mv_par03 // Data Inicial									 ³
//³ mv_par04 // Data Final										 ³
//³ mv_par05 // Efetiva sem Bater Lote?   				         ³
//³ mv_par06 // Efetiva sem Bater Documento?                     ³
//³ mv_par07 // Efetiva para sald?Real/Gerencial/Orcado          ³
//³ mv_par08 // Verifica entidades contabeis?                    ³
//³ mv_par09 // SubLote Inicial?                                 ³
//³ mv_par10 // SubLote Final?                                   ³
//³ mv_par11 // Mostra Lancamento Contabil?  Sim/Nao				  ³
//³ mv_par12 // Modo Processamento							  	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( "CTB350" , .F. )

AADD(aSays,OemToAnsi( STR0002 ) )//"Transfere os lancamentos indicados com status pre-lancamento (que nao controla saldos)"
AADD(aSays,OemToAnsi( STR0003 ) )//"para o saldo informado, acompanhando relatorio de confirmacao do processamento."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o log de processamento                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( aButtons )

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB350",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( ConaOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

PcoIniLan("000082")

FormBatch( cCadastro, aSays, aButtons,, 160 )

If ( Select( "TRB" ) <> 0 )
	dbSelectArea ( "TRB" )
	dbCloseArea ()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio arq. de trab. p/ gravar as inconsistencias.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab		:= CriaTrab(aCampos,.t.)
cChave 			:= "TRB->DDATA+TRB->LOTE+TRB->DOC"

dbUseArea( .T. , , cArqTrab , "TRB" , .F. , .F. )

IndRegua("TRB",cArqTrab,cChave,,,STR0013)//"Selecionando Registros..."

dbSelectArea( "TRB" )
dbSetIndex(cArqTrab+OrdBagExt())
dbSetOrder(1)

IF nOpca == 1
	//Verificar se o calendario esta aberto para poder efetuar a efetivacao.
	//Somente verificar a data inicial.
	For nCont := 1 To __nQuantas
		If CtbExisCTE( StrZero(nCont,2),Year(mv_par03) )
			
			lRet := CtbStatus(StrZero(nCont,2),mv_par03,mv_par04, .F.)
			If !lRet
				nOpca	:= 0
				Exit
			EndIf
		Endif
	Next
	
	If ! lCT350TSL
		MsgInfo(STR0061,STR0062) //"Após as efetivações do periodo, para emissao de relatórios executar 'Reprocessamento de Saldos' do periodo/data.","ATENÇÃO ! At. de saldos desligada, MV_CT350SL (L) = F "
		lAtSldBase := .F.
	EndIf
	
EndIf

IF nOpca == 1
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("INICIO")
	lEnd := .F.
	Processa({|lEnd| Ctb350Proc(@lEnd)},cCadastro)
	
	If FindFunction("CTBSERIALI")
		CTBSerialF("CTBPROC","ON")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("FIM")
Endif

PcoFinLan("000082")

DbSelectArea( "TRB" )
DbCloseArea()
If Select("cArqTrab") = 0
	Ferase(cArqTrab+GetDBExtension())
	Ferase(cArqTrab+OrdBagExt())
EndIf

dbSelectArea("CT2")
dbSetOrder(1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb350Proc³ Autor ³ Simone Mie Sato       ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua os Lancamentos para efetivacao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb350Proc()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb350Proc(lEnd)

Local cTpSldAtu 	:= mv_par07	//Efetiva p/ que saldo?
Local nValor		:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local lLoteOk		:= .T.
Local lDocOk		:= .T.
Local lEfLote		:= Iif(mv_par05 == 1,.T.,.F.)//.T. ->Efetiva sem bater Lote / .F. ->Nao efetiva sem bater Lote
Local lEfDoc		:= Iif(mv_par06 == 1,.T.,.F.)//.T. ->Efetiva sem bater Doc / .F. ->Nao efetiva sem bater Doc
Local lProcessa		:= .F. 						//Indica se processou algum lote
Local cDescInc		:= ""
Local cLoteAnt		:= ""
Local cDocAnt		:= ""
Local dDataAnt		:= CTOD("  /  /  ")
Local aErro
Local aErroTexto 	:= {}
Local nCont

Local lMostraLct	:= ( mv_par11 == 1 )
Local lSimula		:= ( mv_par12 == 2 )
Local lTemIncons	:= .F.
Local nPriLinCT2    := 1
Local cLancAnt
Local nRecCT2
Local aLctProc
//Utilizados na CTBA105
PRIVATE INCLUI 		:= .F.
PRIVATE ALTERA 		:= .T.
PRIVATE DELETA 		:= .F.

// Variaveis utilizadas na função CT105LINOK()
PRIVATE __lCusto	:= CtbMovSaldo("CTT")
PRIVATE __lItem		:= CtbMovSaldo("CTD")
PRIVATE __lCLVL		:= CtbMovSaldo("CTH")

PRIVATE dDataLanc	:= {}
PRIVATE OPCAO	:= 3

__aRptLog := {}

lAtSldBase	:= ( GetMv("MV_ATUSAL") == "S" )
lCusto		:= CtbMovSaldo("CTT")
lItem 		:= CtbMovSaldo("CTD")
lClVl		:= CtbMovSaldo("CTH")
lCtb350Ef	:= ExistBlock("CTB350EF")
lEfeLanc 	:= ExistBlock("EFELANC")
lCT350QRY	:= GetNewPar( "MV_CT350QY", .T.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)
lCT350TRC	:= GetNewPar( "MV_CT350TC", .F.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)
lCT350TSL	:= GetNewPar( "MV_CT350SL", .T.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)

If lMostraLct .and. lSimula
	If !IsBlind()
		If MsgYesNo(STR0064,cCadastro)//"Nao é permitido modo 'Simulação' exibindo lançamentos, continua Simulação sem exibir lançamentos ?"
			lMostraLct	:= .F.
			mv_par11 	:= 2
		Else
			Return
		EndIf
	Else
		Return
	EndIf
EndIf

If lSimula
	If !IsBlind()
		If !MsgYesNo(STR0065,Alltrim(cCadastro)+ STR0066)//"Neste modo apenas serao listadas se houverem inconsistências, os lançamentos mesmo que válidos nao serao efetivados neste modo. Continua Simulação ?"##" Modo Simulação "
			Return
		EndIf
	EndIf
EndIf


xCONOUT("|INI CTB350PROC !")
If mv_par11 == 1
	//
	// Se mostra Lancamentos Contabeis, declarar variaveis utilizadas na rotina dos lancamentos
	//
	Private aRotina := {{},{},{},	{STR0004 ,"Ctba102Cal", 0 , 4} } // "Alterar"
	
	Private cLote
	Private cLoteSub := GetMv("MV_SUBLOTE")
	Private cSubLote := cLoteSub
	Private lSubLote := Empty(cSubLote)
	Private cDoc
	Private cSeqCorr
	Private aTotRdpe := {{0,0,0,0},{0,0,0,0}}
Endif

// Textos correspondentes aos erros retornados da função CT105LINOK()
Aadd( aErroTexto,STR0027 ) // "1 Erro no Tipo do Lancamento Contabil."											// 01 Help "FALTATPLAN"
Aadd( aErroTexto,STR0028 ) // "2 Ausencia do Valor do Lancamento Contabil."										// 02 Help "FALTAVALOR"
Aadd( aErroTexto,STR0029 ) // "3 O campo historico nao pode ficar em branco."									// 03 Help "CTB105HIST"
Aadd( aErroTexto,STR0030 ) // "4 Este registro nao pode conter valor, pois e um complemento de historico."		// 04 Help "CONTHIST"
Aadd( aErroTexto,STR0031 ) // "5 Lancamento de historico complementar nao pode conter entidade preenchida."	    // 05 Help "HISTNOENT"
Aadd( aErroTexto,STR0032 ) // "6 Lancamento a debito, porem conta debito nao digitada."							// 06 Help "FALTA DEB"
Aadd( aErroTexto,STR0033 ) // "7 Entidade bloqueada ou Data do lancto. menor/maior que a data da entidade."     // 07 ValidaBloq()
Aadd( aErroTexto,STR0034 ) // "8 Conta debito preenchida e seu respectivo digito verificador nao."				// 08 Help "DIG_DEBITO"
Aadd( aErroTexto,STR0035 ) // "9 Digito de Controle NAO confere com o Digito cadastrado no Plano de Contas."    // 09 Help "DIGITO"
Aadd( aErroTexto,STR0036 ) // "10 Amarracao entre as entidades nao permitida. Observe as regras de amarracao."  // 10 CtbAmarra()
Aadd( aErroTexto,STR0037 ) // "11 Entidade obrigatoria nao preenchida ou Entidade proibida preenchida."		    // 11 CtbObrig()
Aadd( aErroTexto,STR0038 ) // "12 Lancamento a credito, porem conta credito nao digitada."						// 12 Help "FALTA CRD"
Aadd( aErroTexto,STR0039 ) // "13 Conta credito preenchida e seu respectivo digito verificador nao."			// 13 Help "DIG-CREDIT"
Aadd( aErroTexto,STR0040 ) // "14 Deve-se informar o valor em outra moeda para validar o lancamento."			// 14 Help "SEMVALUS$"
Aadd( aErroTexto,STR0041 ) // "15 As entidades contabeis sao iguais no debito e credito."						// 15 Help "CTAEQUA123"
Aadd( aErroTexto,STR0042 ) // "16 C.Custo, Item e/ou Cl.Valor nao preenchidos conforme o tipo do lancamento."	// 16 Help ""NOCTADEB
Aadd( aErroTexto,STR0042 ) // "17 C.Custo, Item e/ou Cl.Valor nao preenchidos conforme o tipo do lancamento."	// 17 Help "NOCTACRD"
Aadd( aErroTexto,STR0043 ) // "18 Ponto de Entrada 'CT105LOK'" 													// 18 P.Entrada CT105LOK
Aadd( aErroTexto,STR0044 ) // "19 Moeda/Data bloqueada para lançamento"											// 19 Help "CT2_VLR0x"
Aadd( aErroTexto,STR0063) // "20 Problema com a(as) entidade(es) informada(as)

// Abrindo o CT2 com o alias "TMP" para sofrer as consistencias da função CT105LINOK()
If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf

ChkFile("CT2",.F.,"TMP")

dbSelectArea("CT6")
dbSetOrder(1)
cFilCT6 := xFilial("CT6")

dbSelectArea("CTC")
dbSetOrder(1)
cFilCTC := xFilial("CTC")

dbSelectArea("CT2")
cFilCT2 := xFilial("CT2")
dbSetOrder(1)

dbSeek(cFilCT2+Dtos(mv_par04)+mv_par02+(If(mv_par02==mv_par01,"Z","")),.T.)	// Localiza registro próximo ao último
nRecF := CT2->(Recno())						// Guara nº do registro final

dbSeek(cFilCT2+Dtos(mv_par03)+(If(!Empty(mv_par01),mv_par01,""))+(If(!Empty(mv_par09),mv_par09,"")),.T.) // Procuro por Filial+Data Inicial + Lote + SbLote
nRecI := CT2->(Recno()) 					// Guarda nº do registro inicial

ProcRegua(nRecF - nRecI)					// Seta regua contando intervalo de registro
dDataAnt := CT2->CT2_DATA
cLoteAnt := ""
cDocAnt	 := ""
cLancAnt := ""

aCT2DocOk := {}

#IFDEF TOP
If TcSrvType() <> "AS/400" .AND. lCT350QRY	/// SE FOR TOP <> AS/400 E DEVE EXECUTAR COM SQL.
	
	cQuery := " SELECT CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, MIN(R_E_C_N_O_) MINRECNO"
	cQuery += " FROM "+RetSqlName("CT2")
	cQuery += " WHERE CT2_FILIAL = '"+cFilCT2+"'
	
	If mv_par03 == mv_par04
		cQuery += " AND CT2_DATA = '" + DTOS(mv_par03) + "' "
	Else
		cQuery += " AND CT2_DATA >= '" + DTOS(mv_par03) + "' "
		cQuery += " AND CT2_DATA <= '" + DTOS(mv_par04) + "' "
	Endif
	
	If ! Empty( mv_par01 ) .Or. ! Empty( mv_par02 )
		If ( mv_par01 == mv_par02 )
			cQuery += " AND CT2_LOTE = '" + mv_par01 + "' "
		Else
			If ! Empty( mv_par01 )
				cQuery += " AND CT2_LOTE >= '" + mv_par01 + "' "
			Endif
			
			If ! Empty( mv_par02 )
				cQuery += " AND CT2_LOTE <= '" + mv_par02 + "' "
			Endif
		Endif
	Endif
	
	If ! Empty( mv_par09 ) .Or. ! Empty( mv_par10 )
		If ( mv_par09 == mv_par10 )
			cQuery += " AND CT2_SBLOTE = '" + mv_par09 + "' "
		Else
			If ! Empty( mv_par09 )
				cQuery += " AND CT2_SBLOTE >= '" + mv_par09 + "' "
			Endif
			
			If ! Empty( mv_par10 )
				cQuery += " AND CT2_SBLOTE <= '" + mv_par10 + "' "
			Endif
		Endif
	Endif
	
	If ! Empty( mv_par13 ) .Or. ! Empty( mv_par14 )
		If ( mv_par13 == mv_par14 )
			cQuery += " AND CT2_DOC = '" + mv_par13 + "' "
		Else
			If ! Empty( mv_par13 )
				cQuery += " AND CT2_DOC >= '" + mv_par13 + "' "
			Endif
			
			If ! Empty( mv_par14 )
				cQuery += " AND CT2_DOC <= '" + mv_par14 + "' "
			Endif
		Endif
	Endif
	cQuery += " AND CT2_TPSALD = '" + D_PRELAN + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE "
	cQuery += " ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE "
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TMP350") > 0
		dbSelectArea("TMP350")
		dbCloseArea()
	Endif
	
	xCONOUT("|INI QUERY !")
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP350",.T.,.F.)
	
	xCONOUT("|FIM QUERY !")
	
	TcSetField("TMP350","MINRECNO","N",17,0)
	TcSetField("TMP350","CT2_DATA","D",8,0)
	
	If lEnd
		Return
	Endif
	
	dbSelectArea( "TMP350" )
	dbGoTop()
	
	While !TMP350->(Eof())
		
		CT2->( dbGoTo(TMP350->MINRECNO) )
		
		IncProc( DTOC( CT2->CT2_DATA ) + "-" + CT2->CT2_LOTE + STR0056 + ALLTRIM( STR( CT2->( Recno() ) )))//" Lendo Lote... Reg.: "
		
		Processa({|lEnd| Ct350roda( @lEnd, @aErro, aErroTexto, cTpSldAtu, lEfLote, lEfDoc, lMostraLct, lSimula )} ,cCadastro )
		
		If lEnd
			Return
		EndIf
		
		lProcessa := .T.
		
		TMP350->( dbSkip() )
	EndDo
	
Else
#ENDIF

	dbSelectArea("CT2")
	dbSetOrder(1)			// Localiza próximo documento válido
	dbSeek(cFilCT2+Dtos(mv_par03), .T.)
	aLctProc := {}
	While CT2->(!Eof() .And. CT2_FILIAL == cFilCT2 .And. DTOS(CT2_DATA) <= DTOS(mv_par04) )
		
		IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+STR0056+ALLTRIM(STR(CT2->(Recno()))))//" Lendo Lote... Reg.: "
		
		nRecCT2 := CT2->(Recno())
		
		//os lotes processados sao armazenados no array aLctProc
		If Ascan(aLctProc, CT2->( CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_MOEDLC  ) ) == 0 //se nao processou ainda
			
			If CT2->( CT2_TPSALD == D_PRELAN	.And. ;    //regras normais
				CT2_LOTE >= mv_par01 .And. CT2_LOTE <= mv_par02  .And. ;
				CT2_SBLOTE >= mv_par09 .And. CT2_SBLOTE <= mv_par10 .And. ;
				CT2_DOC >= mv_par13 .And. CT2_DOC <= mv_par14 )
				
				aAdd(aLctProc, CT2->( CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_MOEDLC ) ) //armazena no array
				ct350roda(@lEnd,@aErro,aErroTexto,cTpSldAtu,lEfLote,lEfDoc,lMostraLct,lSimula)  //efetiva pre-lct
				
			EndIf
			
		EndIf
		
		If lEnd
			Return
		EndIf
		
		lProcessa := .T.
		
		CT2->( dbGoto(nRecCT2) )
		CT2->( dbSkip() )
		
	EndDo

#IFDEF TOP
EndIf
#ENDIF

xCONOUT("|FIM CTB350PROC !",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao tiver inconsistencias, imprime mensagem que esta ok.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPrintR := .T.
If lProcessa .And. Len(__aRptLog) <= 0
	If !__lBlind .and. MsgYesNo(STR0016+CRLF+STR0052,cCadastro)
		lPrintR := .T.
		cDescInc := OemToAnsi(STR0016)		//"Nao ha inconsistencias no lote e documento."
		CT350GrInc(,,,,,,cDescInc)		//Gravo no arquivo temporario as inconsistencias
	Else
		lPrintR := .F.
	EndIf
ElseIf !lProcessa
	If !__lBlind .and. MsgYesNo(STR0017+CRLF+STR0052,cCadastro)
		lPrintR := .T.
		cDescInc := OemToAnsi(STR0017)		//"Nao ha lote a ser efetivado."
		CT350GrInc(,,,,,,cDescInc)		//Gravo no arquivo temporario as inconsistencias
	Else
		lPrintR := .F.
	EndIf
ElseIf Len(__aRptLog) > 0 .and. !__lBlind
	MsgInfo(STR0053+CRLF+STR0054,STR0055)//"Houveram inconsistências na efetivação !"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime relatorio de consistencias ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPrintR
	If lSimula
		titulo+=" - " +STR0066 //" Modo Simulação."
	EndIf
	C350ImpRel()
Endif

If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf
xCONOUT("|AFTER RPT LOG !")

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct350GrInc³ Autor ³ Simone Mie Sato       ³ Data ³ 14.05.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava as Inconsistencias no Arq. de Trabalho.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ct350GrInc(dData,cLote,cDoc,cMoeda,nVlrDeb,nVlrCrd,cDescInc)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba350                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data                                                ³±±
±±³          ³ ExpC1 = Lote                                                ³±±
±±³          ³ ExpC2 = Documento                                           ³±±
±±³          ³ ExpC3 = Moeda                                               ³±±
±±³          ³ ExpN1 = Valor Debito                                        ³±±
±±³          ³ ExpN2 = Valor Credito                                       ³±±
±±³          ³ ExpC4 = Descricao da Inconsistentcia                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct350GrInc(dData,cLote,cDoc,cMoeda,nVlrDeb,nVlrCrd,cDescInc)

If aScan( __aRptLog , { |x| 	x[1] == dData .And. ;
	x[2] == cLote .And. ;
	x[3] == cDoc .And. ;
	x[4] == cMoeda .And. ;
	x[5] == nVlrDeb .And. ;
	x[6] == nVlrCrd .And. ;
	x[7] == cDescInc} ) == 0
	
	aAdd(__aRptLog,{dData,cLote,cDoc,cMoeda,nVlrDeb,nVlrCrd,cDescInc})
	
EndIf

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C350ImpRel³ Autor ³ Simone Mie Sato       ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime o Relatorio Final.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C350ImpRel()		  							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum       	  							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba350                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function C350ImpRel()

Local nRpt := 1

PRIVATE Tamanho		:="M"
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "CTBA350"

li 			:= 80
m_pag			:= 1

wnrel	:= "CTBA350"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,,,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

If aReturn[4] == 2 // Paisagem
	Tamanho := "G"
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

For nRpt := 1 to Len(__aRptLog)
	dbSelectArea("TRB")
	Reclock("TRB",.T.)
	TRB->DDATA		:= __aRptLog[nRpt][1]
	TRB->LOTE		:= __aRptLog[nRpt][2] //cLote
	TRB->DOC		:= __aRptLog[nRpt][3]//cDoc
	TRB->MOEDA		:= __aRptLog[nRpt][4]//cMoeda
	TRB->VLRDEB		:= __aRptLog[nRpt][5]//nVlrDeb
	TRB->VLRCRD		:= __aRptLog[nRpt][6]//nVlrCrd
	TRB->DESCINC	:= __aRptLog[nRpt][7]//cDescInc
	MsUnlock()
Next

RptStatus({|lEnd| CTR350Imp(@lEnd,wnRel,cString,Titulo)})

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctr350Imp ³Autor  ³ Simone Mie Sato       ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime o Relatorio Final.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctr350Imp()       							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum             							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba350                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Acao do CodeBlock                                  ³±±
±±³          ³ ExpC1 = Nome do relatorio                                  ³±±
±±³          ³ ExpC2 = Mensagem                                           ³±±
±±³          ³ ExpC3 = Titulo                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctr350Imp(lEnd,wnRel,cString,Titulo)

Local Li := 80

dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())
While !Eof()
	
	If Li > 55
		Cabec(titulo,cabec1,cabec2,NomeProg,Tamanho)
		Li := 10
	Endif
	IncRegua()
	If ! Empty(TRB->DDATA)
		@ Li,01 PSAY TRB->DDATA
		@ Li,12 PSAY TRB->LOTE
		@ Li,22 PSAY TRB->DOC
		@ Li,32 PSAY TRB->MOEDA
		@ Li,38 PSAY TRB->VLRDEB		Picture "@E 999,999,999,999.99"
		@ Li,57 PSAY TRB->VLRCRD		Picture "@E 999,999,999,999.99"
		@ Li,77 PSAY TRB->DESCINC
	Else
		@ Li,01 PSAY TRB->DESCINC
	Endif
	
	Li += 1
	dbSkip()
End

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

MS_FLUSH()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct350Valid³Autor  ³ Simone Mie Sato       ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica as entidades.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ct350Valid()      							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum             							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba350                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 				                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct350Valid()

Local aSaveArea	:= GetArea()
Local lRet		:= .T.
Local cDescInc	:= ""
Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVL		:= CtbSayApro("CTH")

dbSelectArea("CT2")
dbSetOrder(1)
MsSeek(xFilial("CT2")+Dtos(mv_par03)+mv_par01+mv_par13,.T.) // Procuro por Filial+Data Inicial + Lote + DOC inicial

ProcRegua(CT2->(RecCount()))
dDataAnt := CT2->CT2_DATA
cLoteAnt := ""
cDocAnt	 := ""

While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And. CT2->CT2_DATA <= mv_par04 .And. CT2->CT2_DOC <= mv_par14
	
	If CT2->CT2_TPSALD != D_PRELAN //Se o tipo de saldo for diferente de pre-lancamento
		dbSkip()
		Loop
	Endif
	
	If CT2->CT2_DATA < mv_par03 .Or. CT2->CT2_DATA > mv_par04
		dbSkip()
		Loop
	Endif
	
	If  CT2->CT2_LOTE < mv_par01 .Or. CT2->CT2_LOTE > mv_par02
		dbSkip()
		Loop
	EndIf
	
	If CT2->CT2_DC $ "13"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CONTA CONTABIL A DEBITO                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a conta foi preenchida                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( CT2->CT2_DEBITO )
			lRet := .F.
			If !lRet
				cDescInc := STR0023	+ STR0025 + CT2->CT2_LINHA //Conta nao preenchida.  	Linha:
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a conta existe e nao e sintetica                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CT1")
		lRet:= ValidaConta(CT2->CT2_DEBITO,"1",,,.T.,.F.)
		If !lRet
			cDescInc	:= STR0024 + Alltrim(CT2->CT2_DEBITO) + STR0025 + CT2->CT2_LINHA //Verificar conta: 	Linha:
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CENTRO DE CUSTO - DEBITO                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCusto
			lRet:= ValidaCusto(CT2->CT2_CCD,"1",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayCusto) + " : " + Alltrim(CT2->CT2_CCD)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ITEM - DEBITO 		                                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lItem
			lRet:= ValidItem(CT2->CT2_ITEMD,"1",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayItem) + " : " + Alltrim(CT2->CT2_ITEMD)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CLASSE VALOR - DEBITO 		                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lClVL
			lRet:= ValidaCLVL(CT2->CT2_CLVLDB,"1",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayClVl) + " : " + Alltrim(CT2->CT2_CLVLDB)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bloco de Valida‡oes Lancamentos a Credito                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If CT2->CT2_DC $ "23"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CONTA CONTABIL A CREDITO                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a conta foi preenchida                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( CT2->CT2_CREDIT )
			lRet := .F.
			If !lRet
				cDescInc 	:= STR0023	+ STR0025 + CT2->CT2_LINHA //Conta nao preenchida.  	Linha:
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a conta existe e nao e sintetica                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet := ValidaConta(CT2->CT2_CREDIT,"2",,,.T.,.F.)
		If !lRet
			cDescInc	:= STR0024 + Alltrim(CT2->CT2_CREDIT) + STR0025 + CT2->CT2_LINHA //Verificar conta: 	Linha:
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CENTRO DE CUSTO - CREDITO                                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCusto
			lRet:= ValidaCusto(CT2->CT2_CCC,"2",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayCusto) + " : " + Alltrim(CT2->CT2_CCC)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ITEM - CREDITO		                                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lItem
			lRet:= ValidItem(CT2->CT2_ITEMC,"2",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayItem) + " : " + Alltrim(CT2->CT2_ITEMC)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CLASSE VALOR - CREDITO		                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lClVL
			lRet:= ValidaCLVL(CT2->CT2_CLVLCR,"2",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayClVl) + " : " + Alltrim(CT2->CT2_CLVLCR)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
	EndIf
	dbSelectArea("CT2")
	dbSkip()
EndDo

RestArea(aSaveArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT350DigLaºAutor  ³Marcos S. Lobo      º Data ³  02/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua chamada da tela de lançamento contabil manual para   º±±
±±º          ³a efetivação quando configurada para Mostrar Lançamento.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ct350DigLan(nPriLinCT2)
Local cSubLote
Local nTotInf

CT2->( DbGoTo(nPriLinCT2) )	//	Posicionando no primeiro registro do lancamento

dDataLanc := CT2->CT2_DATA // "dDataLanc" é utilizada na funcao CT105LinOK()

// Buscando o total do documento
dbSelectArea("CTC")
dbSetOrder(1)

If MsSeek(cFilCTC+DtoS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_MOEDLC+CT2->CT2_TPSALD)
	nTotInf := CTC->CTC_INF
Else
	nTotInf := 0
Endif

// Fechando o Alias "TMP", pois na funcao CTBA102LAN(), esse Alias e usado para o temporario da GetDados
TMP->( DbCloseArea() )

cSubLote	:=	CT2->CT2_SBLOTE //variavel privada utilizada nas validacoes

Ctba102Lan(4,CT2->CT2_DATA,CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,"CT2",CT2->(Recno()),0,"",nTotInf)

// Abrindo novamente o CT2 com o alias "TMP"
If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf

ChkFile("CT2",.F.,"TMP")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA350   ºAutor  ³Microsiga           º Data ³  03/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ct350roda(lEnd,aErro,aErroTexto,cTpSldAtu,lEfLote,lEfDoc,lMostraLct,lSimula)

Local nCont		:= 0
Local nDocOk	:= 0
Local nPriLinCT2    := 1
Local nValor		:= 0
Local nCT6CRD		:= 0
Local nCT6DEB		:= 0
Local nCTCDEB 		:= 0
Local nCTCCRD 		:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local lTodas

Local lTemIncons  := .F.
Local lLoteOk		:= .T.
Local lDocOk		:= .T.

Local cLoteAtu	:= CT2->CT2_LOTE
Local dDataAtu	:= CT2->CT2_DATA
Local aOutrEntid := {}

ProcRegua(1000)

If !lEfLote	///Se só efetivar LOTE batido
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifico se o lote esta batendo	em todas as moedas   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CT6")
	dbSetOrder(1)
	If dbSeek(cFilCT6+CT2->(dtos(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_MOEDLC),.F.)
		nCT6DEB := 0
		nCT6CRD := 0
		While !CT6->(Eof()) .and. CT6->CT6_FILIAL == cFilCT6 .and. CT6->CT6_DATA == CT2->CT2_DATA .AND. CT6->CT6_LOTE == CT2->CT2_LOTE .AND.;
			CT6->CT6_SBLOTE == CT2->CT2_SBLOTE .and. CT6->CT6_MOEDA == CT2->CT2_MOEDLC
			
			nCT6DEB += CT6->CT6_DEBITO
			nCT6CRD += CT6->CT6_CREDIT
			
			CT6->(dbSkip())
		EndDo
		
		nCT6DEB := Round(nCT6DEB,2)
		nCT6CRD := Round(nCT6CRD,2)
		
		If nCT6DEB != nCT6CRD .or. (nCT6DEB == 0 .and. nCT6CRD == 0)//Se debito e credito nao baterem
			lTemIncons := .T.
			lLoteOk	:= .F.
			cDescInc := OemToAnsi(STR0014)		//"Debito e Credito do Lote nao estao batendo"
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,nCT6DEB,nCT6CRD,cDescInc) //Grava TMP com as inconsistencias
		EndIf
	Else
		lTemIncons	:= .T.
		lLoteOk		:= .F.
		//Gravo no arquivo temporario as inconsistencias
		cDescInc := OemToAnsi(STR0051)		//"Registro de Saldo Total do Lote/Doc. não encontrado. Reprocessar Pré-Lançamentos (9)."
		CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,,CT2->CT2_MOEDLC,0,0,cDescInc)
	Endif
	
	If !lLoteOk	//Se houve diferença no total Deb x Cred.
		///Ja localiza o proximo lote.
		lSkip := .F.
		#IFNDEF TOP
			lSkip := .T.
		#ELSE
			If TcSrvType() == "AS/400" .OR. !lCT350QRY ///Se não executa query, faz skip do while.
				lSkip := .T.
			EndIf
		#ENDIF
		
		If lSkip ///nas versoes sem query deve-se localizar o proximo registro de lote a ser validado no CT2.
			dbSelectArea("CT2")
			dbSetOrder(1)
			dbSeek(cFilCT2+DTOS(dDataAtu)+Soma1(cLoteAtu),.T.)
		EndIf
		Return
	EndIf
EndIf

If lEnd
	Return
EndIf

// Enquanto for o mesmo Lote
While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DATA == dDataAtu .and. CT2->CT2_LOTE == cLoteAtu .and. CT2->CT2_SBLOTE <= mv_par10 .And. CT2->CT2_DOC <= mv_par14
	
	IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+"/"+CT2->CT2_DOC+STR0058+ALLTRIM(STR(CT2->(Recno()))))///" Lendo Doc... Reg.: "
	
	If lEnd
		Return
	EndIf
	
	If CT2->CT2_LOTE < mv_par01 .or. CT2->CT2_SBLOTE < mv_par09
		CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+SOMA1(CT2_DOC)),.T.))
		Loop
	ElseIf CT2->CT2_TPSALD != D_PRELAN //Se o tipo de saldo for diferente de pre-lancamento
		CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+SOMA1(CT2_LINHA)),.T.))
		Loop
	EndIf
	
	cSubAtu := CT2->CT2_SBLOTE
	cDocAtu := CT2->CT2_DOC
	
	lTemIncons	:= .F.
	lDocOk		:= .T.
	
	If !lEfDoc			/// Se só efetivar DOCUMENTO batido.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifico se o documentos esta batendo em todas as moedas   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CTC")
		dbSetOrder(1)
		If dbSeek(cFilCTC+CT2->(dtos(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC),.F.)
			nCTCDEB := 0
			nCTCCRD := 0
			While !CTC->(Eof()) .and. CTC->CTC_FILIAL == cFilCTC .and. CTC->CTC_DATA == CT2->CT2_DATA .AND. CTC->CTC_LOTE == CT2->CT2_LOTE .AND.;
				CTC->CTC_SBLOTE == CT2->CT2_SBLOTE .and. CTC->CTC_DOC == CT2->CT2_DOC .and. CTC->CTC_MOEDA == CT2->CT2_MOEDLC
				
				nCTCDEB += CTC->CTC_DEBITO
				nCTCCRD += CTC->CTC_CREDIT
				
				CTC->(dbSkip())
			EndDo
			
			nCTCDEB := Round(nCTCDEB,2)
			nCTCCRD := Round(nCTCCRD,2)
			
			If nCTCDEB != nCTCCRD .or. (nCTCDEB == 0 .and. nCTCCRD == 0)//Se debito e credito nao baterem
				lTemIncons := .T.
				lDocOk	:= .F.
				nVlrDeb	:= CTC->CTC_DEBITO
				nVlrCrd := CTC->CTC_CREDIT
				//Gravo no arquivo temporario as inconsistencias
				cDescInc := OemToAnsi(STR0015)		//"Debito e Credito do Documento nao estao batendo"
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,nVlrDeb,nVlrCrd,cDescInc)
			Endif
		Else
			lTemIncons	:= .T.
			lDocOk		:= .F.
			//Gravo no arquivo temporario as inconsistencias
			cDescInc := OemToAnsi(STR0051)		//"Registro de Saldo Total do Lote/Doc. não encontrado. Reprocessar Pré-Lançamentos (9)."
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,0,0,cDescInc)
		Endif
	EndIf
	
	nPriLinCT2	:= CT2->( Recno() )		// Guarda a 1ª Linha do Documento
	dDataLanc	:= CT2->CT2_DATA
	
	If lEnd
		Return
	EndIf
	
	If !lEfDoc .and. lTemIncons .and. lMostraLct
		CT350DigLan( nPriLinCT2 )
	Else
		
		IF !lEfDoc .and. lTemIncons
			
			dbSelectArea("CT2")
			dbSetOrder(1)
			dbSeek(cFilCT2 + CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+Soma1(CT2_DOC)) )
			
		Else
			
			lTemIncons  := .F.
			aCT2DocOk	 := {}
			
			While CT2->(!Eof()) .and. 	CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DATA == dDataAtu .and. CT2->CT2_LOTE == cLoteAtu .and.;
				CT2->CT2_SBLOTE == cSubAtu .and. CT2->CT2_DOC == cDocAtu
				
				IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+"/"+CT2->CT2_DOC+STR0059+ALLTRIM(STR(CT2->(Recno()))))//" Validado...Reg.: "
				
				If CT2->CT2_LOTE < mv_par01 .or. CT2->CT2_SBLOTE < mv_par09
					CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+SOMA1(CT2_DOC)),.T.))
					Loop
				ElseIf CT2->CT2_TPSALD != D_PRELAN //Se o tipo de saldo for diferente de pre-lancamento
					CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+SOMA1(CT2_LINHA)),.T.))
					Loop
				EndIf
				
				TMP->( DbGoTo( CT2->(Recno()) ) )		/// Posiciona o mesmo registro do CT2 no alias TMP.
				
				dDataLanc	 := TMP->CT2_DATA // "dDataLanc" é utilizada na funcao CT105LinOK()
				aErro		 := {}
				lTodas	 	 := (mv_par11 == 2)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verificar se ha inconsistencia (se lTodas==.T., verificara todas as inconsistencias    ³
				//³ do documento, caso contrario, retornara apos a primeira inconsistencia encontrada)	   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !CT105LinOK("",.T.,@aErro,lTodas,OPCAO)
					lTemIncons := .T.
					For nCont := 1 to Len(aErro)
						cDescInc := aErroTexto[ aErro[nCont] ]
						nVlrDeb 	:= IF( CT2->CT2_DC $ "13", CT2->CT2_VALOR, 0 )
						nVlrCrd 	:= IF( CT2->CT2_DC $ "23", CT2->CT2_VALOR, 0 )
						If nVlrDeb == 0 .And. nVlrCrd == 0
							nVlrDeb := nVlrCrd := CT2->CT2_VALOR
						EndIf
						CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,nVlrDeb,nVlrCrd,cDescInc)
					Next
				Else		/// Se não teve inconsistência na Linha
					aAdd(aCT2DocOk,CT2->(Recno()) )
				EndIf
				
				nUltLinCT2 := CT2->( Recno()) // Guarda a última linha do Documento
				CT2->(dbSkip())
			EndDo
			
		EndIF
		
		/// Quando Terminar a leitura do documento.
		nNextCT2 := CT2->(Recno())      /// Guarda o posicionamento do próximo registro.
		
		/// Efetua gravação dos lançamentos ou mostra tela para correções e gravação
		If lTemIncons .And. lMostraLct 	// Se tem inconsistencias e deve mostrar lancamento na tela
			Ct350DigLan(nPriLinCT2)	//Mostra o lançamento para correções, grava CT2 e Saldos.
			
		ElseIf !lTemIncons .and. ( lLoteOk	.and. lDocOk )// Se não teve inconsistência e não mostra a tela
			
			If !lSimula
				
				FOR nDocOk := 1 TO Len( aCT2DocOk )
					
					CT2->( DbGoTo( aCT2DocOk[ nDocOk ] ) )
					
					If nDocOk == 1
						IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+"/"+CT2->CT2_DOC+STR0060+ALLTRIM(STR(CT2->(Recno()))))///" Gravando...Reg.: "
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Executa Ponto de Entrada antes de  ³
					//³ alterar o tipo de saldo no CT2     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lCtb350Ef
						ExecBlock("CTB350EF",.F.,.F.)
					Endif
					
					//Chamar a multlock
					aTravas := {}
					
					IF !Empty(CT2->CT2_DEBITO)
						AADD(aTravas,CT2->CT2_DEBITO)
					Endif
					IF !Empty(CT2->CT2_CREDIT)
						AADD(aTravas,CT2->CT2_CREDIT)
					Endif
					
					/// VERIFICA SE O SEMAFORO DE CONTAS PERMITE GRAVAÇÃO DOS LANÇAMENTOS/SALDOS
					If CtbCanGrv(aTravas,@lAtSldBase)
						
						BEGIN TRANSACTION
						
						// Utilizado para gerar o lancamento no PCO com o novo tipo de saldo
						PcoDetLan("000082","01","CTBA350",.T.)
						
						//Altero o tipo de saldo no lancamento contabil.
						Reclock("CT2",.F.)
						
						CT2->CT2_TPSALD := cTpSldAtu
						
						MsUnlock()
						
						If lEfeLanc
							ExecBlock("EFELANC",.F.,.F.)
						Endif
						
						If lAtSldBase
							nValor	:= CT2->CT2_VALOR
							//Os parametros lReproc e lAtSldBase estao sendo passados como .T.
							//porque sempre sera atualizado os saldos basicos na efetivacao
							aOutrEntid 	:= CtbOutrEnt(.F.)
							
							CtbGravSaldo(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,CT2->CT2_DATA,CT2->CT2_DC,CT2->CT2_MOEDLC,;
							CT2->CT2_DEBITO,CT2->CT2_CREDIT,CT2->CT2_CCD,CT2->CT2_CCC,CT2->CT2_ITEMD,CT2->CT2_ITEMC,;
							CT2->CT2_CLVLDB,CT2->CT2_CLVLCR,nValor,CT2->CT2_TPSALD,3,,,;
							,,,,,,,,,,lCusto,lItem,lClVL,,.T.,.F.,,,,,,,,,,,"+"/*cOperacao*/,aOutrEntid[1])
							
							//Desgravo o valor do arquivo CTC
							If CT2->CT2_DC == "3"
								GRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,'1',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,'2',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,'1',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,'2',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
							Else
								GRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,CT2->CT2_DC,CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DC,CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
							Endif
						EndIf
						
						// Utilizado para gerar o lancamento no PCO com o novo tipo de saldo
						PcoDetLan("000082","02","CTBA350")
						
						END TRANSACTION
						Ct1MUnLock()
						dbCommitAll()
						
					EndIf
				NEXT nDocOk
				
			EndIf
		Endif
		
		CT2->(dbSetOrder(1))
		CT2->(MsGoto(nNextCT2))	///Vai para o próximo registro a ser validado.
	EndIf
EndDo

Return

/////////////////////////////////////////////////////////////////////////////////
/// funcoes para testes
/////////////////////////////////////////////////////////////////////////////////
Static Function xCONOUT(cTexto,lResume)

Local cTxtLog := ""

DEFAULT lResume  := .F.

If !lCT350TRC
	Return
EndIf

cTxtLog := "TRACE|CTBA350|"+DTOC(Date())+"|"+Time()+"|"+ALLTRIM(STR(SECONDS()))

__cTEMPOS+= cTxtLog+cTexto+CRLF

CONOUT(cTxtLog+cTexto)

If lResume
	MsgInfo(__cTEMPOS,STR0067)//"Resumo de Tempos -> Efetivaçao CTB"
	__cTEMPOS := ""
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbExisCTEºAutor  ³CTB		         º Data ³  02/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbExisCTE( cMoeda, cAno )
Local aArea := GetArea()
Local lRet	:= .F.

DbSelectArea( 'CTE' )
DbSetOrder( 1 )
If MsSeek( xFilial( 'CTE' ) + cMoeda )
	DbSelectArea("CTG")
	DbSetOrder(1)
	If MsSeek(xFilial("CTG")+CTE->(CTE_CALEND)+Str(cAno))
		lRet := .T.
	EndIf
EndIf

RestArea( aArea )

Return lRet
