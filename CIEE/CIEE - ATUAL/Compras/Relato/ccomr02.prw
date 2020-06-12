#INCLUDE "rwmake.ch"
#INCLUDE "ccomr02.ch"
#INCLUDE "_FixSX.ch" // "AddSX1.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCOMR02   ºAutor  ³ Felipe Raposo      º Data ³  20/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio especifico de relacao de ped. de compras.        º±±
±±º          ³ A coluna grupo foi substituida pela coluna centro de custo.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR120  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da Rela‡„o de Pedidos de Compras                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rogerio F.G.  ³05/12/97³08197A³Inclusao do Telefone do Fornecedor       ³±±
±±³Rogerio F.G.  ³05/12/97³10426A³Alteracao da Picture Cpo C7_PRECO        ³±±
±±³Edson   M.    ³25/02/98³XXXXXX³Acerto da impressao dos Totais.          ³±±
±±³Bruno         ³10/12/98³Melhor³Acerto da impressao das A.E.(Argentina) .³±±
±±³Viviani       ³29/12/98³19074 ³Acerto do calculo total geral c/ desconto³±±
±±³Viviani       ³29/12/98³10634 ³Inclusao de fax e contato na ordem 3     ³±±
±±³Edson   M.    ³23/03/99³XXXXXX³Correcao no calculo do IPI.              ³±±
±±³Fernando Joly ³20/04/99³XXXXXX³Consistir SC's Firmes e Previstas.       ³±±
±±³Percy A Horna ³15/08/01³xxxxxx³Inclusao da funcao xMoeda() p/impressao  ³±±
±±³              ³        ³      ³em multimoeda, dependendo do parametro   ³±±
±±³              ³        ³      ³escolhido no grupo de perguntas do SX1.  ³±±
±±³              ³        ³      ³Impressao valores de impostos Localizados³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CCOMR02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt, wnrel
Local cDesc1 := STR0001  //"Emissao da Relacao de  Pedidos de Compras."
Local cDesc2 := STR0002  //"Sera solicitado em qual Ordem, qual o Intervalo para"
Local cDesc3 := STR0003  //"a emissao dos pedidos de compras."
Local aOrd   := {STR0004, STR0005, STR0006}  //" Por Numero         "###" Por Produto        "###" Por Fornecedor   "
Local _aPerg
Static aTamSXG
Static nDifNome := 0
Static nTamNome := 35

Private titulo   := STR0007  //"Relacao de Pedidos de Compras"
Private cPerg
Private cString  := "SC7"
Private aReturn  := {STR0008, 1, STR0009, 1, 2, 1, "", 1}  //"Zebrado"###"Administracao"
Private nomeprog := "MATR120"
Private nLastKey := 0, aLinha := {}
Private LIMITE   := 220
Private cabec1, cabec2
Private tamanho  := "G"
// Parametros informados pelo usuario.
Private _mPrdDe, _mPrdAte, _mEmisDe, _mEmisAte, _mEntDe, _mEntAte
Private _mLstQuais, _mNumDe, _mNumAte, _mImpPed, _mFornDe, _mFornAte
// Parametros que nao serao utilizados no CIEE.
Private _mImpPC, _mTipoSC, _mMoeda, _mDescr

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Imprime := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verif. conteudo da variavel Static Grupo de Fornec. (001)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamSXG := IIf(aTamSXG == nil, TamSXG("001"), aTamSXG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg := "COMR02    "
_aPerg := {;
{cPerg,"01","Produto de         ?","¨De Producto       ?","From Product       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""},;
{cPerg,"02","Produto ate        ?","¨A  Producto       ?","To Product         ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""},;
{cPerg,"03","Data Emissao de    ?","¨De Fecha Emision  ?","From Issue Date    ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","''","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"04","Data Emissao at‚   ?","¨A  Fecha Emision  ?","To Issue Date      ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","''","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"05","Data Entrega de    ?","¨De Fecha Entrega  ?","From Delivery Date ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","''","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"06","Data Entrega at‚   ?","¨A  Fecha Entrega  ?","To Delivery Date   ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","''","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"07","Lista quais        ?","¨Cuales Lista      ?","List which         ?","mv_ch7","N",01,0,1,"C","","mv_par07","Todos","Todos","All","","","Em Aberto","En Abierto","Open","","","Residuos","Residuos","Residues","","","Atendidos","Atendidos","Serviced","","","","","","","","",""},;
{cPerg,"08","Numero Inicial     ?","¨De Numero         ?","Initial Number     ?","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SC7","",""},;
{cPerg,"09","Numero Final       ?","¨A  Numero         ?","Final Number       ?","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SC7","",""},;
{cPerg,"10","Imprime Pedidos    ?","¨Imprime Pedidos   ?","Print Orders       ?","mv_cha","N",01,0,2,"C","","mv_par10","Liberados","Aprobados","Approved","","","Bloqueados","Bloqueados","Blocked","","","Ambos","Ambos","Both","","","","","","","","","","","","","",""},;
{cPerg,"11","Fornecedor de      ?","De proveedor       ?","From supplier      ?","mv_chb","C",06,0,2,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""},;
{cPerg,"12","Fornecedor de      ?","De proveedor       ?","From supplier      ?","mv_chb","C",06,0,2,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""}}
// Retirados para assumir valores padroes.
//{_cPerg,"10","Listar quais tipo  ?","¨Cuales Lista      ?","List which Types   ?","mv_cha","N",01,0,3,"C","","mv_par10","Pedido Compra","Pedido Compra","Purchase Order","","","Aut. de Entrega","Aut. de Entrega","Deliv. Author.","","","Ambos","Ambos","Both","","","","","","","","","","","","","",""},;
//{_cPerg,"12","Considera SCs      ?","¨Considerar SCs    ?","Consider Purc.Req. ?","mv_chc","N",01,0,3,"C","","mv_par12","Firmes","Confirmadas","Confirmed","","","Previstas","Previstas","Expected","","","Ambas","Ambos","Both","","","","","","","","","","","","","",""},;
//{_cPerg,"13","Qual a Moeda       ?","¨Cual Moneda       ?","Which Currency     ?","mv_chd","N",02,0,1,"C","","mv_par13","Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Currency 2","","","Moeda 3","Moneda 3","Currency 3","","","Moeda 4","Moneda 4","Currency 4","","","Moeda 5","Moneda 5","Currency 5","","","",""},;
//{_cPerg,"14","Descricao Produto  ?","Descripcion Prodc. ?","Product Description?","mv_che","C",10,0,0,"G","","mv_par14","","","","B1_DESC","","","","","","","","","","","","","","","","","","","","","","",""}}
AjustaSX1(_aPerg)
Pergunte(cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ _mPrdDe        // do produto                                 ³
//³ _mPrdAte       // ate o produto                              ³
//³ _mEmisDe       // data de emissao de                         ³
//³ _mEmisAte      // data de emissao ate                        ³
//³ _mEntDe        // data de entrega inicial                    ³
//³ _mEntAte       // data de entrega final                      ³
//³ _mLstQuais     // todas ou em aberto ou residuos ou atendidos³
//³ _mNumDe        // pedido inicial                             ³
//³ _mNumAte       // pedido final                               ³
//³ _mImpPC        // Listar  PC    AE    Ambos                  ³
//³ _mImpPed       // Pedidos Liberados  Bloqueados Ambos        ³
//³ _mTipoSC       // Impr. SC's Firmes, Previstas ou Ambas      ³
//³ _mMoeda        // Qual Moeda                                 ³
//³ _mDescr        // Descricao do produto                       ³
//³ _mFornDe       // Fornecedor de                              ³
//³ _mFornAte      // Fornecedor ate                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aTamSXG[1] != aTamSXG[3]
	nDifNome := aTamSXG[4] - aTamSXG[3]
	nTamNome := IIf(aTamSXG[1] != aTamSXG[3], 35 - (aTamSXG[4] - aTamSXG[3]), 35)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "CCOMR02" //"MATR120"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,Tamanho)

// Parametros informados pelo usuario.
_mPrdDe  := mv_par01; _mPrdAte  := mv_par02
_mEmisDe := mv_par03; _mEmisAte := mv_par04
_mEntDe  := mv_par05; _mEntAte  := mv_par06
_mLstQuais := mv_par07
_mNumDe  := mv_par08; _mNumAte  := mv_par09
_mImpPed := mv_par10
_mFornDe := mv_par11; _mFornAte := mv_par12

// Parametros que nao serao utilizados no CIEE.
_mImpPC  := 3   // Ambos.
_mTipoSC := 3   // Ambos.
_mMoeda  := 1   // Moeda 1.
_mDescr  := "B1_DESC"   // Descr. do produto.

If nLastKey == 27
	Set Filter To
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif
// Processamento com regua de progressao.
RptStatus({|lEnd| R120Imp(@lEnd,tamanho,wnrel,cString)},Titulo)
Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R120IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 10.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R120Imp(lEnd, tamanho, wnrel, cString)

Local cbtxt := SPACE(10)
Local nQuebra,cCabQuebra,cQuebrant,cCOndBus
Local CbCont
Local nQuant_a_Rec := 0
Local nTotParc := 0

CbCont   := 00
nQuebra  := 00
li       := 80
m_pag    := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Totalizar os valores do relatorio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nT_qtd_ped  := 0		// qtde pedida
nT_vl_ipi   := 0		// valor do ipi
nT_vl_total := 0      // valor total do pedido
nT_qtd_entr := 0		// qtde entregue
nT_sd_receb := 0		// saldo a receber
nT_desc     := 0		// total de desconto
nTotIVA     := 0    // Total de IVA (impostos)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Totalizar os valores p/ item de acordo com a ordem ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPedida    := 0   // qtde pedida
nValIpi    := 0   // valor do ipi
nTotal     := 0   // valor total do pedido
nQuant     := 0   // qtde entregue
nSaldo     := 0   // saldo a receber
nFlag      := 0   // flag que indica se imprime totais por item ou nao
nITemIpi   := 0
nSalIpi    := 0
nFrete     := 0   // valor do frete
nDesc      := 0   // valor do desconto
nValIVA    := 0   // valor do IVA
nItemIVA   := 0   // valor do item do imposto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos de acordo com os parametros              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1     := STR0011   // "RELACAO DOS PEDIDOS DE COMPRAS"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o ponto inicial para a impressao                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]

dbSelectArea("SC7")
dbSetOrder(nOrdem)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica qual ordem foi selecionada                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica qual ordem foi selecionada                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1
	If ( cPaisLoc$"ARG|POR|EUA" )	//Ordena los pedidos de compra y luego la AE.
		DbSetOrder(10)
		cCondBus	:=	"0"+_mNumDe
	Else
		cCondBus	:=	_mNumDe
	Endif
	
	dbSeek(xFilial("SC7")+cCondBus,.T.)
	cCampo     := "SC7->C7_NUM"
	
	If _mImpPed == 2
		cTexQuebra := STR0012	//"AUTOR. N. : "
	Else
		cTexQuebra := STR0013	//"PEDIDO N. : "
	Endif
	titulo     += STR0014		//" - POR NUMERO"
	
	// Verifica se utilizara LayOut Maximo
	If aTamSXG[1] != aTamSXG[3]
		cabec1 := STR0046		//"IT CODIGO          DESCRICAO                      GRP  CODIGO               RAZAO SOCIAL         DATA DE  ENTREGA   QUANTIDADE  UM      VALOR        VALOR         VALOR TOTAL  QUANT.      QUANT. A          SALDO   RES."
		//				  	         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
		//                  	   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Else
		cabec1 := STR0015		//"IT CODIGO          DESCRICAO                      GRP  CODIGO RAZAO SOCIAL                        DATA DE  ENTREGA   QUANTIDADE  UM      VALOR        VALOR         VALOR TOTAL  QUANT.      QUANT. A          SALDO   RES."
		//                      1         2         3         4         5         6         7         8         9        10        11        12        13   X    14        X5        16   X    17        18        19        20        10
		//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Endif
	cabec2 := STR0016		//"   PRODUTO         DO PRODUTO                           FORN.                                     EMISSAO  PREVISTA      PEDIDA           UNIT.         IPI            (C/IPI)   ENTREGUE    RECEBER         RECEBER  ELIM."
	
ElseIf nOrdem == 2
	dbSeek(xFilial("SC7")+_mPrdDe,.T.)
	cCampo     := "SC7->C7_PRODUTO"
	cTexQuebra := STR0017	//"PRODUTO : "
	titulo     += STR0018	//" - POR PRODUTO"
	If ( cPaisLoc$"ARG|POR|EUA" )
		cabec1 :=	STR0043 //"PED/AE ITEM  DATA         CODIGO RAZAO SOCIAL                            FONE        ENTREGA      QUANTIDADE          VALOR         VALOR      PRECO TOTAL        QUANTIDADE      QUANT. A       SALDO     RESIDUOS"
	Endif
	// Verifica se utilizara LayOut Maximo
	If aTamSXG[1] != aTamSXG[3]
		cabec1 := STR0047 //"PEDIDO ITEM  DATA      CODIGO               RAZAO SOCIAL          FONE            ENTREGA         QUANTIDADE           VALOR    DESCONTO           VALOR     PRECO TOTAL      QUANTIDADE   QUANT. A          SALDO RESIDUOS"
		//							 123456  12  99/99/9999 12345678901234567890 123456789012345678901 12345789012345 12/34/5678 123456789012345 123456789012345 123456789012 1234567890123 123456789012345 123456789012345 1234567890 123456789012345   Sim
		//							 1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
		//							 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Else
		cabec1 := STR0019 //"PEDIDO ITEM  DATA      CODIGO RAZAO SOCIAL                        FONE            ENTREGA         QUANTIDADE           VALOR    DESCONTO           VALOR     PRECO TOTAL      QUANTIDADE   QUANT. A          SALDO RESIDUOS"
		//		  					 123456  12  99/99/9999 123456 12345678901234567890123456789012345 12345789012345 12/34/5678 123456789012345 123456789012345 123456789012 1234567890123 123456789012345 123456789012345 1234567890 123456789012345   Sim
		//							 1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
		//							 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Endif
	cabec2 := STR0020 //"             EMISSAO   FORN.                                      FORN.           PREVISTA            PEDIDA        UNITARIO                         IPI       (C/IPI)          ENTREGUE    RECEBER        RECEBER ELIMINADOS"
Else				// Ordem == 3
	dbSeek(xFilial("SC7"))
	cCampo     := "SC7->C7_FORNECE+SC7->C7_LOJA"
	cTexQuebra := STR0021	//"FORNECEDOR : "
	titulo     += STR0022	//" - POR FORNECEDOR"
	If ( cPaisLoc$"ARG|POR|EUA" )
		cabec1 := STR0042 //"PED/AE ITEM  DATA     CODIGO           DESCRICAO DO PRODUTO           GRUPO  ENTREGA        QUANTIDADE            PRECO            VALOR       PRECO TOTAL        QUANTIDADE      QUANT. A       SALDO     RESIDUOS"
	Else
		cabec1 := STR0023 //"PEDIDO ITEM  DATA     CODIGO           DESCRICAO DO PRODUTO           GRUPO  ENTREGA        QUANTIDADE            PRECO            VALOR       PRECO TOTAL        QUANTIDADE      QUANT. A       SALDO     RESIDUOS"
	Endif
	cabec2 := STR0024    //"NUMERO       EMISSAO  PRODUTO                                                PREVISTA           PEDIDA         UNITARIO              IPI         (C/IPI)            ENTREGUE    RECEBER        RECEBER   ELIMINADOS"
	//                         123456  12  12/45/78 123456789012345 123456789012345678901234567890 1234  12/34/56 123456789012345 123456789012345 123456789012 1234567890123 123456789012345 123456789012345 1234567890 123456789012345   Sim
	//                         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
	//                         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	
Endif

If _mLstQuais==1
	titulo+=STR0025	//", Todos"
ElseIf _mLstQuais==2
	titulo+=STR0026	//", Em Abertos"
ElseIf _mLstQuais==3
	titulo+=STR0027	//", Residuos"
ElseIf _mLstQuais==4
	titulo+=STR0028	//", Atendidos"
Endif

SetRegua(RecCount())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a leitura do arquivo SC7                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While !Eof() .and. C7_FILIAL = xFilial()
	
	IncRegua()
	If lEnd
		@PROW()+1,001 PSAY STR0029	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR PEDIDO                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_NUM < _mNumDe .or. C7_NUM > _mNumAte
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR PRODUTO                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_PRODUTO < _mPrdDe .or. C7_PRODUTO > _mPrdAte
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR EMISSAO                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_EMISSAO < _mEmisDe .or. C7_EMISSAO > _mEmisAte
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR DATA ENTREGA                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_DATPRF < _mEntDe .or. C7_DATPRF > _mEntAte
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste se o pedidos esta liberado.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  (C7_CONAPRO == "B" .and. _mImpPed == 1) .or.;
		(C7_CONAPRO != "B" .and. _mImpPed == 2)
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. EM ABERTO                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _mLstQuais == 2
		If C7_QUANT-C7_QUJE <= 0 .or. !EMPTY(C7_RESIDUO)
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. RESIDUOS                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _mLstQuais == 3
		If EMPTY(C7_RESIDUO)
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. ATENDIDOS                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _mLstQuais == 4
		If C7_QUANT > C7_QUJE
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Tipo de Pedido  1-PC    2-AE    3-Ambos             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _mImpPed == 1 .and. C7_TIPO != 1
		dbSkip()
		Loop
	ElseIf _mImpPed == 2 .and.	C7_TIPO !=2
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. por fornecedor                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_FORNECE < _mFornDe .or. C7_FORNECE > _mFornAte
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(_mTipoSC, 'SC7')
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se e nova pagina                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	
	If nQuebra == 0
		cQuebrant := &cCampo
		li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		If nOrdem = 1
			cCabQuebra := " "
		ElseIf nOrdem = 2
			dbSelectArea("SC7")
			cCabQuebra := Alltrim(SC7->C7_DESCRI)
			
			If Empty(_mDescr)
				_mDescr := "B1_DESC"
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da descricao generica do Produto.                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(_mDescr) == "B1_DESC"
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(cFilial+&cCampo)
				cCabQuebra := Alltrim(SB1->B1_DESC)
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da descricao cientifica do Produto.                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(_mDescr) == "B5_CEME"
				dbSelectArea("SB5")
				dbSetOrder(1)
				If dbSeek(cFilial+&cCampo)
					cCabQuebra := Alltrim(B5_CEME)
				Endif
			Endif
			
			dbSelectArea("SC7")
			If AllTrim(_mDescr) == "C7_DESCRI"
				cCabQuebra := Alltrim(SC7->C7_DESCRI)
			Endif
		ElseIf nOrdem = 3
			dbSelectArea("SA2")
			dbSeek(cFilial+&cCampo)
			cCabQuebra := A2_NOME
		Endif
		If ( cPaisLoc$"ARG|POR|EUA" ).and._mImpPed == 3 .and. nOrdem == 1
			If ( SC7->C7_TIPO==2 )
				@ li,000 PSAY STR0012 + &cCampo + " " + Substr(cCabQuebra,1,(nTamNome-5))
			Else
				If nOrdem == 1 .and. !Empty(SC7->C7_NUMSC)
					@ li,000 PSAY STR0013 + &cCampo + " " + STR0048 + SC7->C7_NUMSC + " " + Substr(cCabQuebra,1,(nTamNome-5))
				Else
					@ li,000 PSAY STR0013 + &cCampo + " " + Substr(cCabQuebra,1,(nTamNome-5))
				Endif
			Endif
		Else
			If nOrdem == 1 .and. !Empty(SC7->C7_NUMSC)
				@ li,000 PSAY cTexQuebra + &cCampo + " " + STR0048 + SC7->C7_NUMSC + " " + Substr(cCabQuebra,1,(nTamNome-5))
			Else
				@ li,000 PSAY cTexQuebra + &cCampo + " " + Substr(cCabQuebra,1,(nTamNome-5))
			Endif
		Endif
		
		If nOrdem = 1 .or. nOrdem = 3
			dbSelectArea("SA2")
			If dbSeek(cFilial+SC7->C7_FORNECE+SC7->C7_LOJA)
				If nOrdem = 1
					@ li,055 PSAY SC7->C7_FORNECE
					@ li,(062+nDifNome) PSAY Substr(SA2->A2_NOME,1,nTamNome)
					@ li,098 PSAY STR0041+Substr(SA2->A2_TEL,1,15) // Fone.:
				Else
					@ li,055 PSAY STR0041+Substr(SA2->A2_TEL,1,15) + STR0044 + SA2->A2_FAX + STR0045 + SA2->A2_CONTATO   // Fone.: Fax: Contato:
				Endif
			Endif
			dbSelectArea("SC7")
		Endif
		nQuebra := 1
		nFlag:=0
	Endif
	
	dbSelectArea("SC7")
	If cQuebrant != &cCampo
		nQuebra := 0
		li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		If nFlag > 1 .or. nOrdem != 2
			Impitem()
			nFlag:=0
		Endif
		nPedida:=nValIpi:=nTotal:=nQuant:=nSaldo:=nValIVA:=0
		@ li,000 PSAY __PrtThinLine()
		Loop
	Endif
	li++
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	nItemIpi := 0
	nSalIpi := 0
	nItemIVA  := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica ordem a ser impressa           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisIniPC(SC7->C7_NUM,SC7->C7_ITEM)
	If nOrdem = 1
		nTotParc := ImpOrd1()
	ElseIf nOrdem = 2
		nTotParc := ImpOrd2()
	Else
		nTotParc := ImpOrd3()
	Endif
	nTotal 	+= xMoeda(nTotParc,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma as variaveis dos totais p/item     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPedida = nPedida + C7_QUANT
	nValIpi = nValIpi + xMoeda(nItemIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	nQuant  = nQuant  + C7_QUJE
	nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
	nSaldo  = nSaldo  + (nQuant_a_Rec * IIf(Empty(C7_REAJUST),xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF),xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF))) + xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	nValIVA := nValIVA + xMoeda(nItemIVA,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor do Frete         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFrete := C7_FRETE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor do Desconto         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_DESC1 != 0 .or. C7_DESC2 != 0 .or. C7_DESC3 != 0
		nDesc += CalcDesc(C7_TOTAL,C7_DESC1,C7_DESC2,C7_DESC3)
	Else
		nDesc += C7_VLDESC
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma as variaveis dos totais gerais     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nT_vl_ipi   := nT_vl_ipi   + xMoeda(nItemIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	nT_vl_total := nT_vl_total + xMoeda(nTotParc,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	nT_sd_receb := nT_sd_receb + (nQuant_a_Rec * IIf(Empty(C7_REAJUST),xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF),xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF))) + xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	nTotIVA     := nTotIVA     + xMoeda(nItemIVA,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	dbSelectArea("SC7")
	dbSkip()
EndDo
If nOrdem <> 1
	nT_Desc += xMoeda(nDesc,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
	nDesc := 0
Endif

If nFlag > 1 .or. nOrdem != 2
	If li > 60 .and. li != 80
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	If li != 80
		li++
		Impitem()
	Endif
	nFlag:=0
Endif

If nT_qtd_ped > 0 .or. nT_vl_ipi > 0 .or.;
	nT_vl_total > 0 .or. nT_qtd_entr > 0 .or. nT_sd_receb > 0
	Imptot(limite)
Endif

If li != 80
	li++
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	@ li,000 PSAY __PrtThinLine()
	roda(CbCont,STR0030,"G")		//"PEDIDOS"
Endif

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD1  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio na 1a ordem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpOrd1()

Local nQuant_a_Rec:=0
Local aTam		:= TamSx3("C7_PRECO")
Local aTamVal	:= TamSx3("C7_VALICM")
Local nTotal	:= MaFisRet(,'NF_TOTAL')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nI
Local cDescri := Alltrim(SC7->C7_DESCRI)

If Empty(_mDescr)
	_mDescr := "B1_DESC"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(_mDescr) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(_mDescr) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	Endif
	dbSelectArea("SC7")
Endif

dbSelectArea("SC7")
If AllTrim(_mDescr) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
Endif

If cPaisLoc <> "BRA" .and. !Empty( aValIVA )
	For nI := 1 To Len( aValIVA )
		nItemIVA += aValIVA[nI]
	Next
Endif

dbSelectArea("SC7")
@ li,000 PSAY C7_ITEM
@ li,003 PSAY C7_PRODUTO
nFlag++
@ li,019 PSAY Subs(cDescri,1,30)
dbSelectArea("SB1")
dbSeek(cFilial+SC7->C7_PRODUTO)
//If Found()
//	@ li,050 PSAY B1_GRUPO
//Endif
// Felipe Raposo.  20/12/2002
@ li,050 PSAY SC7->C7_CC

dbSelectArea("SC7")
@ li,096 PSAY C7_EMISSAO
@ li,107 PSAY C7_DATPRF
@ li,118 PSAY C7_QUANT Picture Tm(C7_QUANT,10,2)
@ li,129 PSAY C7_UM
If !Empty(C7_REAJUST)
	@ li,132 PSAY xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF,aTam[2]) Picture tm(Formula(C7_REAJUST),10,aTam[2])
Else
	@ li,132 PSAY xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF,aTam[2]) Picture tm(C7_PRECO,13,aTam[2])
Endif
nItemIPI := CalcIPI()[1]
nSalIPI := CalcIPI()[2]
If cPaisLoc <> "BRA"
	@ li,146 PSAY xMoeda(nItemIVA,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)  Picture tm(nItemIVA,15,aTamVal[2])
Else
	@ li,146 PSAY xMoeda(nItemIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)  Picture tm(nItemIPI,15,aTamVal[2])
Endif
@ li,161 PSAY xMoeda(nTotal,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(nTotal,15,aTamVal[2])
@ li,177 PSAY C7_QUJE Picture tm(C7_QUJE,10,2)
nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
@ li,188 PSAY nQuant_a_Rec Picture tm(C7_QUANT-C7_QUJE,10,2)

If Empty(C7_REAJUST)
	@ li,199 PSAY (nQuant_a_Rec * xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)) +;
	xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(C7_TOTAL,15,aTamVal[2])
Else
	@ li,199 PSAY (nQuant_a_Rec * xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)) + ;
	xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(C7_TOTAL,15,aTamVal[2])
Endif
@ li,215 PSAY If(Empty(C7_RESIDUO),STR0031,STR0032)		//'Nao'###'Sim'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Descricao Adicional do Produto (se houver)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For j:=31 TO Len(Trim(cDescri)) Step 30
	If !empty(Subs(cDescri,j,30))
		Li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		@ li,19 PSAY SubStr(cDescri,j,30)
	Endif
Next j

Return nTotal

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD2  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio na 2a ordem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpOrd2()

Local nQuant_a_Rec
Local aTam		:= TamSx3("C7_PRECO")
Local aTamVal	:= TamSx3("C7_VALICM")
Local nTotal	:= MaFisRet(,'NF_TOTAL')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nI

If cPaisLoc <> "BRA" .and. !Empty( aValIVA )
	For nI := 1 To Len( aValIVA )
		nItemIVA += aValIVA[nI]
	Next
Endif

dbSelectArea("SC7")
If ( cPaisLoc$"ARG|POR|EUA" )
	@ li,000 PSAY If(C7_TIPO==1,"P"+C7_NUM,"A"+C7_NUM)
Else
	@ li,000 PSAY C7_NUM
Endif
@ li,008 PSAY C7_ITEM
nFlag++
@ li,012 PSAY C7_EMISSAO
@ li,023 PSAY C7_FORNECE
dbSelectArea("SA2")
If dbSeek(cFilial+SC7->C7_FORNECE+SC7->C7_LOJA)
	@li,(30+nDifNome) PSAY Subs(A2_NOME,1,nTamNome)
	@li,66 PSAY Substr(A2_TEL,1,15)
Endif

DbSelectArea("SC7")
@ li,82 PSAY C7_DATPRF
@ li,93 PSAY C7_QUANT Picture tm(C7_QUANT,15,2)
If !Empty(C7_REAJUST)
	@ li,109 PSAY xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF,aTam[2]) Picture tm(Formula(C7_REAJUST),15,aTam[2])
Else
	@ li,109 PSAY xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF,aTam[2]) Picture tm(C7_PRECO,15,aTam[2])
Endif
nItemIPI := CalcIPI()[1]
nSalIPI := CalcIPI()[2]
@ li,124 PSAY xMoeda(C7_VLDESC,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)  Picture tm(C7_VLDESC,12,aTamVal[2])
If cPaisLoc <> "BRA"
	@ li,137 PSAY xMoeda(nItemIVA,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)  Picture tm(nItemIVA,15,aTamVal[2])
Else
	@ li,137 PSAY xMoeda(nItemIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)  Picture tm(nItemIPI,15,aTamVal[2])
Endif
@ li,153 PSAY xMoeda(nTotal,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(nTotal,15,aTamVal[2])
@ li,169 PSAY C7_QUJE Picture tm(C7_QUJE,15,2)
nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
@ li,185 PSAY nQuant_a_Rec Picture tm(C7_QUANT-C7_QUJE,10,2)

If Empty(C7_REAJUST)
	@ li,195 PSAY (nQuant_a_Rec * xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)- ;
	xMoeda(C7_VLDESC,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF))+ ;
	xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(C7_TOTAL,15,aTamVal[2])
Else
	@ li,195 PSAY (nQuant_a_Rec * xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)) + ;
	xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(C7_TOTAL,15,aTamVal[2])
Endif
@ li,211 PSAY If(Empty(C7_RESIDUO),STR0031,STR0032)		//'Nao'###'Sim'

Return nTotal

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD3  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio na 3a ordem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpOrd3()
Local nQuant_a_Rec:=0
Local aTam		:= TamSx3("C7_PRECO")
Local aTamVal	:= TamSx3("C7_VALICM")
Local nTotal	:= MaFisRet(,"NF_TOTAL")
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nI
Local cDescri := Alltrim(SC7->C7_DESCRI)

If Empty(_mDescr)
	_mDescr := "B1_DESC"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(_mDescr) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(_mDescr) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	Endif
	dbSelectArea("SC7")
Endif

dbSelectArea("SC7")
If AllTrim(_mDescr) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
Endif

If cPaisLoc <> "BRA" .and. !Empty(aValIVA)
	For nI := 1 To Len( aValIVA )
		nItemIVA += aValIVA[nI]
	Next
Endif
dbSelectArea("SC7")
If ( cPaisLoc$"ARG|POR|EUA" )
	@li,000 PSAY If(C7_TIPO==1,"P"+C7_NUM,"A"+C7_NUM)
Else
	@li,000 PSAY C7_NUM
Endif
@ li,007 PSAY C7_ITEM
nFlag++
@ li,010 PSAY C7_EMISSAO
@ li,022 PSAY C7_PRODUTO
@ li,038 PSAY Subs(cDescri,1,28)
dbSelectArea("SB1")
//If dbSeek(xFilial()+SC7->C7_PRODUTO)
//	@ li,067 PSAY B1_GRUPO
//Endif
// Felipe Raposo.  20/12/2002
dbSeek(xFilial()+SC7->C7_PRODUTO)
@ li,050 PSAY SC7->C7_CC
dbSelectArea("SC7")
@ li,073 PSAY C7_DATPRF
@ li,085 PSAY C7_QUANT Picture tm(C7_QUANT, 13, 2)
If !Empty(C7_REAJUST)
	@li,99 PSAY xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF,aTam[2]) Picture tm(Formula(C7_REAJUST),15,aTam[2])
Else
	@li,99 PSAY xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF,aTam[2]) Picture tm(C7_PRECO,15,aTam[2])
Endif
nItemIPI := CalcIPI()[1]
nSalIPI := CalcIPI()[2]
@ li,115 PSAY xMoeda(C7_VLDESC,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(C7_VLDESC,12,2)
If cPaisLoc <> "BRA"
	@ li,128 PSAY xMoeda(nItemIVA,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)  Picture tm(nItemIVA,15,aTamVal[2])
Else
	@ li,128 PSAY xMoeda(nItemIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)  Picture tm(nItemIPI,15,aTamVal[2])
Endif
@ li,143 PSAY xMoeda(nTotal,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(nTotal,15,aTamVal[2])
@ li,158 PSAY C7_QUJE	Picture tm(C7_QUJE,15,2)
nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
@ li,174 PSAY nQuant_a_Rec Picture tm(C7_QUANT-C7_QUJE,10,2)

If Empty(C7_REAJUST)
	@ li,185 PSAY (nQuant_a_Rec * xMoeda(C7_PRECO,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)- ;
	xMoeda(C7_VLDESC,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF))+ ;
	xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(C7_TOTAL,15,aTamVal[2])
Else
	@ li,185 PSAY (nQuant_a_Rec * xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)) + ;
	xMoeda(nSalIPI,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF) Picture tm(C7_TOTAL,15,aTamVal[2])
Endif
@ li,203 PSAY If(Empty(C7_RESIDUO),STR0031,STR0032)		//'Nao'###'Sim'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Descricao Adicional do Produto (se houver)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For j:=29 TO Len(Trim(cDescri)) Step 28
	If !empty(Subs(cDescri,j,28))
		li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		@ li,38 PSAY SubStr(cDescri,j,28)
	Endif
Next j

Return nTotal

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPTOT   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 03.02.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao dos totais do relatorio                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpTot(limite)

Local nc1,nc2,nc3,nc4,nc5,nc6      // Numeros das colunas para aparecer os
// totais dependendo do tipo de rela-
// torio escolhido(1,2,3)
nc1:=nc2:=nc3:=nc4:=nc5:=nc6:=0
If nOrdem = 1
	nc3:= 146
	nc4:= 161; nc6:= 199
ElseIf nOrdem = 2
	nc3:= 137
	nc4:= 153;nc6:= 195
Else
	nc3:= 128
	nc4:= 143;nc6:= 185
Endif
li+=2
@ li,000 PSAY STR0033	//"Total Geral "
If cPaisLoc <> "BRA"
	@ li,nc3 PSAY nTotIVA   Picture tm(nTotIVA,15,2)
Else
	@ li,nc3 PSAY nT_vl_ipi Picture tm(nT_vl_ipi,15,2)
Endif
@ li,nc4 PSAY nT_vl_total           Picture tm(nT_vl_total,15,2)
@ li,nc6 PSAY nT_sd_receb - nT_desc Picture tm(nT_sd_receb,15,2)
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPITEM  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 08.05.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao dos totais p/ item de acordo com a ordem         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpItem()

Local nc1,nc2,nc3,nc4,nc5,nc6		// numeros das colunas para aparecer os
// totais dependendo do tipo de rela-
// torio escolhido(1,2,3)

nc1:=nc2:=nc3:=nc4:=nc5:=nc6:=0
If nOrdem = 1
	nc3:= 146
	nc4:= 161; nc6:= 199
	cTotal:=STR0034	//"Total dos Itens "
ElseIf nOrdem = 2
	nc3:= 137
	nc4:= 153; nc6:= 195
	cTotal:=STR0035	//"Total do Produto"
Else
	nc3:= 128
	nc4:= 143;nc6:= 185
	cTotal:=STR0036	//"Total do Fornecedor"
Endif

li ++
@ li,000 PSAY cTotal
If cPaisLoc <> "BRA"
	@ li,nc3 PSAY nValIVA  Picture tm(nValIVA,15,2)
Else
	@ li,nc3 PSAY nValIpi  Picture tm(nValIpi,15,2)
Endif
@ li,nc4 PSAY nTotal   Picture tm(nTotal,15,2)
@ li,nc6 PSAY (nSaldo-If(nOrdem<>1,nDesc,0)) Picture tm(nSaldo,15,2)
li++
If li > 60
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Endif

nT_desc += xMoeda(nDesc,SC7->C7_MOEDA,_mMoeda,SC7->C7_DATPRF)
nDesc:=0
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CALCIPI  ³ Autor ³ Marcos Bregantim      ³ Data ³ 30.08.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do IPI                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CalcIPI()
Local nToTIPI	:= 0,nTotal,nSalIPI:= 0
Local nValor 	:= (C7_QUANT) * IIf(Empty(C7_REAJUST),C7_PRECO,Formula(C7_REAJUST))
Local nSaldo 	:= (C7_QUANT-C7_QUJE) * IIf(Empty(C7_REAJUST),C7_PRECO,Formula(C7_REAJUST))
Local nTotDesc := C7_VLDESC

If cPaisLoc <> "BRA"
	nSalIPI := (C7_QUANT-C7_QUJE) * nItemIVA / C7_QUANT
Else
	If nTotDesc == 0
		nTotDesc := CalcDesc(nValor,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	Endif
	nTotal := nValor - nTotDesc
	nTotIPI := IIF(SC7->C7_IPIBRUT == "L",nTotal, nValor) * ( SC7->C7_IPI / 100 )
	If Empty(C7_RESIDUO)
		nTotal := nSaldo - nTotDesc
		nSalIPI := IIF(SC7->C7_IPIBRUT == "L",nTotal, nSaldo) * ( SC7->C7_IPI / 100 )
	Endif
Endif
Return {nTotIPI, nSalIPI}