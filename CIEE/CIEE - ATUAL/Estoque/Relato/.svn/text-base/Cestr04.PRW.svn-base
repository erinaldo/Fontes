#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "_FixSX.ch" // "AddSX1.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CESTR04   º Autor ³ Felipe Raposo      º Data ³  24/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emite a relacao de consumo interno quebrando por centro de º±±
±±º          ³ custo e por grupo de materiais, podendo inclusive imprimir º±±
±±º          ³ os produtos (relatorio analitico).                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CESTR04()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1       := "Este programa tem como objetivo imprimir relatório "
Local cDesc2       := "de acordo com os parâmetros informados pelo usuário."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Demonstrativo analítico de consumo de material"
Local nLin         := 80
Local Cabec1, Cabec2

Local Cabec1SinC   := "Centro de                            Grupo                                           CUSTO              Conta                Conta  "
Local Cabec2SinC   := "Responsabilidade                                                                     TOTAL              Despesa              Estoque"
****              := "xxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxx xxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999,999.99 xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx"

Local Cabec1SinG   := "Grupo                                  Centro de                                     CUSTO              Conta                Conta  "
Local Cabec2SinG   := "                                       Responsabilidade                              TOTAL              Despesa              Estoque"
****              := "xxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxx 999,999,999.99 xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx"

Local Cabec1AnaC   := "Centro de                          Produto                                     UM     Quantidade            Custo          C U S T O"
Local Cabec2AnaC   := "Responsabilidade                                                                                         Unitário          T O T A L"
****              := "xxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxx xx 999,999,999.99 999,999,999.9999 999,999,999,999.99"

Local Cabec1AnaG   := "Grupo                                  Produto                                 UM     Quantidade            Custo          C U S T O"
Local Cabec2AnaG   := "                                                                                                         Unitário          T O T A L"
****              := "xxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxx xx 999,999,999.99 999,999,999.9999 999,999,999,999.99"

****              := "                                                                                TOTAL DO GRUPO xxxx ........: 999,999,999,999,999.99"
****              := "                                                                      TOTAL DO CR xxxxxxxxx ................: 999,999,999,999,999.99"
****              := "                                                                 T O T A L   G E R A L......................: 999,999,999,999,999.99"
****              := "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
****              := "0         1         2         3         4         5         6         7         8         9        10        11        12        13 "
Local imprime      := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 18
Private aOrd         := {"Grupo","Centro de Responsabilidade"}
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 00
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := nomeprog
Private cString := ""
Private cPerg   := "CESTR4    "
Private lAbortPrint := .F., lEnd := .F.
Private _nOrdem
Private _mCRde, _mCRAte, _mLocalDe, _mLocalAte, _mDataDe, _mDataAte
Private _mProdDe, _mProdAte, _mTipoDe, _mTipoAte, _mGrpDe, _mGrpAte, _mImp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os parametros de entrada do usuario...                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aSX1 := {}
aAdd(_aSX1, {cPerg,"01","C.R. Inicial       ?","¨De Centro de Costo?","Initial Cost Center?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","004"})
aAdd(_aSX1, {cPerg,"02","C.R. Final         ?","¨A  Centro de Costo?","Final Cost Center  ?","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","004"})
aAdd(_aSX1, {cPerg,"03","Do Armazem         ?","¨De Deposito       ?","From Warehouse     ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aSX1, {cPerg,"04","Ate Armazem        ?","¨A  Deposito       ?","To Warehouse       ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aSX1, {cPerg,"05","Da  Data           ?","¨De Fecha          ?","From Date          ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aSX1, {cPerg,"06","Ate Data           ?","¨A  Fecha          ?","To Date            ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aSX1, {cPerg,"07","Do  Produto        ?","¨De Producto       ?","From Product       ?","mv_ch7","C",15,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
aAdd(_aSX1, {cPerg,"08","Ate Produto        ?","¨A  Producto       ?","To Product         ?","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
aAdd(_aSX1, {cPerg,"09","Do  Tipo           ?","¨De Tipo           ?","From Type          ?","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","02","",""})
aAdd(_aSX1, {cPerg,"10","Ate Tipo           ?","¨A  Tipo           ?","To Type            ?","mv_cha","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","02","",""})
aAdd(_aSX1, {cPerg,"11","Do  Grupo          ?","¨De Grupo          ?","From Group         ?","mv_chb","C",04,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
aAdd(_aSX1, {cPerg,"12","Ate Grupo          ?","¨A  Grupo          ?","To Group           ?","mv_chc","C",04,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
aAdd(_aSX1, {cPerg,"13","Tipo               ?","¨Cual Clase        ?","Type               ?","mv_chd","N",01,0,1,"C","","mv_par13","Analitico","Analitica","Detailed","","","Sintetico","Sintetico","Summarized","","","","","","","","","","","","","","","","","","",""})
aAdd(_aSX1, {cPerg,"14","Tipo Ordem         ?","¨Tipo Ordem        ?","Tipo Ordem         ?","mv_che","N",01,0,1,"C","","mv_par14","CR","CR","CR","","","Grupo","Grupo","Grupo","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aSX1)  // _FixSX.ch
Pergunte (cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho,,.F.)
If nLastKey == 27
	Return
Endif             

_nOrdem := MV_PAR14

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

// Armazena os parametros digitados pelo usuario.
_mCRde    := mv_par01; _mCRAte    := mv_par02
_mLocalDe := mv_par03; _mLocalAte := mv_par04
_mDataDe  := mv_par05; _mDataAte  := mv_par06
_mProdDe  := mv_par07; _mProdAte  := mv_par08
_mTipoDe  := mv_par09; _mTipoAte  := mv_par10
_mGrpDe   := mv_par11; _mGrpAte   := mv_par12
_mImp     := mv_par13

// Variaveis auxiliares para a impressao do relatorio.
nTipo   := IIf(aReturn[4] == 1, 15, 18)


// Define o cabecalho a ser usado, de acordo com a ordem
// e o tipo do relatorio (analitico ou sintetico).
If _nOrdem == 1  // CR.
	Cabec1 := IIf(_mImp == 1, Cabec1AnaC, Cabec1SinC)
	Cabec2 := IIf(_mImp == 1, Cabec2AnaC, Cabec2SinC)
Else  // Grupo.
	Cabec1 := IIf(_mImp == 1, Cabec1AnaG, Cabec1SinG)
	Cabec2 := IIf(_mImp == 1, Cabec2AnaG, Cabec2SinG)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. MSAGUARDE monta janela de processamento.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
msAguarde({|lEnd| GeraRel(Cabec1,Cabec2,Titulo,nLin)}, "Gerando o relatório...", "Aguarde", .F.)
//RptStatus({|| GeraRel(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³GeraRel   º Autor ³ Felipe Raposo      º Data ³  24/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Executa as queries e chama a rotina de impressao do resul- º±±
±±º          ³ tado.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraRel(Cabec1,Cabec2,Titulo,nLin)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cQry, _cQry1, _cQry2
Local _nTotRegs

// _nOrdem == 1  // CR.
_cQry :=;
"SELECT D3_CC, CTT_DESC01, D3_COD, B1_DESC, B1_UM, B1_GRUPO, BM_DESC, BM_CREDUZ1, BM_CREDUZ2, TOTQUANT, TOTCUS " + _EOL +;
"FROM " + RetSQLName("CTT") + " CTT, " + RetSQLName("SB1") + " B1, " + RetSQLName("SBM") + " BM, " + _EOL +;
"( " + _EOL +;
"	SELECT D3_CC, D3_COD, " + _EOL +;
"	SUM( " + _EOL +;
"		CASE " + _EOL +;
"			WHEN D3_TM > '500' THEN D3_QUANT " + _EOL +;
"			ELSE -(D3_QUANT) " + _EOL +;
"		END " + _EOL +;
"	) TOTQUANT, " + _EOL +;
"	SUM( " + _EOL +;
"		CASE " + _EOL +;
"			WHEN D3_TM > '500' THEN D3_CUSTO1 " + _EOL +;
"			ELSE -(D3_CUSTO1) " + _EOL +;
"		END " + _EOL +;
"	) TOTCUS " + _EOL +;
"	FROM " + RetSQLName("SD3") + " D3 " + _EOL +;
"	WHERE " + _EOL +;
"	D3_CC      BETWEEN '" + _mCRDe    + "' AND '" + _mCRAte    + "' AND " + _EOL +;
"	D3_LOCAL   BETWEEN '" + _mLocalDe + "' AND '" + _mLocalAte + "' AND " + _EOL +;
"	D3_EMISSAO BETWEEN '" + dtos(_mDataDe) + "' AND '" + dtos(_mDataAte) + "' AND " + _EOL +;
"	D3_ESTORNO = ' ' AND " + _EOL +;
"	(D3_OP = '' OR SUBSTRING(D3_OP, 7, 2) = 'OS') AND " + _EOL + ;
"	D3.D_E_L_E_T_ <> '*' " + _EOL +;
"	GROUP BY D3_CC, D3_COD" + _EOL +;
") A " + _EOL +;
"WHERE " + _EOL +;
"B1_COD   = D3_COD   AND " + _EOL +;
"BM_GRUPO = B1_GRUPO AND " + _EOL +;
"CTT_CUSTO = D3_CC    AND " + _EOL +;
"B1_COD   BETWEEN '" + _mProdDe + "' AND '" + _mProdAte + "' AND " + _EOL +;
"B1_TIPO  BETWEEN '" + _mTipoDe + "' AND '" + _mTipoAte + "' AND " + _EOL +;
"B1_GRUPO BETWEEN '" + _mGrpDe  + "' AND '" + _mGrpAte  + "' AND " + _EOL +;
"B1.D_E_L_E_T_ <> '*' AND " + _EOL +;
"BM.D_E_L_E_T_ <> '*' AND " + _EOL +;
"CTT.D_E_L_E_T_ <> '*'"
If _mImp == 1  // Analitico.
	_cQry1 := _cQry + IIf(_nOrdem == 1, " ORDER BY D3_CC, D3_COD", " ORDER BY B1_GRUPO, D3_CC, D3_COD")
Else  // Sintetico.
	_cQry :=;
	"SELECT D3_CC, CTT_DESC01, B1_GRUPO, BM_DESC, BM_CREDUZ1, BM_CREDUZ2, " + _EOL +;
	"SUM(TOTCUS) TOTCUS " + _EOL +;
	"FROM ( " + _EOL +;
	_cQry +;
	") A " + _EOL +;
	"GROUP BY D3_CC, CTT_DESC01, B1_GRUPO, BM_DESC, BM_CREDUZ1, BM_CREDUZ2"
	_cQry1 := _cQry + IIf(_nOrdem == 1, " ORDER BY D3_CC, B1_GRUPO", " ORDER BY B1_GRUPO, D3_CC")
Endif

// Conta quantos registros serao listados.
_cQry2 := "SELECT COUNT(*) REGS FROM (" + _cQry + ") A"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Escreve as queries em disco e a executa.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MemoWrit(StrTran(FunName(), "#", "") + "1.SQL", _cQry1)
MemoWrit(StrTran(FunName(), "#", "") + "2.SQL", _cQry2)

// Testa se ha algum dado a ser impresso.
TCQuery _cQry2 NEW ALIAS "QRY2"
QRY2->(dbGoTop())
_nTotRegs := IIf(QRY2->(!eof()), QRY2->REGS, 0)
QRY2->(dbCloseArea())

// Se ha dados a serem impresso.
If _nTotRegs > 0
	TCQuery _cQry1 NEW ALIAS "QRY1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de progressao.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|| ImpRel(Cabec1,Cabec2,Titulo,nLin,_nTotRegs)}, Titulo)
	QRY1->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ImpRel    º Autor ³ Felipe Raposo      º Data ³  24/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de progressao.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRel(Cabec1,Cabec2,Titulo,nLin,_nTotRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _nTotGrp := 0, _nTotCR := 0, _nTotal := 0
Private _cCCAnt := "", _cGRAnt := ""
Private _lImpTotGR := .F., _lImpTotCC := .F.

// Variaveis auxiliares para a impressao do relatorio.
Titulo += "  de " + dtoc(_mDataDe) + " até " + dtoc(_mDataAte)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica para a regua quantos registros serao processados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(_nTotRegs)

QRY1->(dbGoTop())
Do While QRY1->(!eof())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55  // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	// Se os valores estao zerados, pula para o proximo registro.
	If QRY1->(TOTCUS == 0 .and. (_mImp == 2 .or. TOTQUANT == 0))
		QRY1->(dbSkip())  // Avanca o ponteiro do registro no arquivo
		Loop
	Endif
	
	// Imprime o registro.
	If _mImp == 1  // Analitico
		If _nOrdem == 1   // CR
			If _cCCAnt != QRY1->D3_CC
				nLin ++   // Avanca a linha de impressao.
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"GR")
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"CC")
				@nLin, 000 PSay SubStr(QRY1->(AllTrim(D3_CC) + " " + CTT_DESC01), 1, 33)
				_cGRAnt := QRY1->B1_GRUPO
				_cCCAnt := QRY1->D3_CC
			Endif
			If _cGRAnt != QRY1->B1_GRUPO
				nLin ++   // Avanca a linha de impressao.
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"GR")
				_cGRAnt := QRY1->B1_GRUPO
			Endif
			@nLin, 035 PSay SubStr(QRY1->(AllTrim(D3_COD) + " " + B1_DESC), 1, 41)
		Else   // Grupo.
			If _cGRAnt != QRY1->B1_GRUPO
				nLin ++   // Avanca a linha de impressao.
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"CC")
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"GR")
				@nLin, 000 PSay SubStr(QRY1->(AllTrim(B1_GRUPO) + " " + BM_DESC), 1, 37)
				_cCCAnt := QRY1->D3_CC
				_cGRAnt := QRY1->B1_GRUPO
			Endif
			If _cCCAnt != QRY1->D3_CC
				nLin ++   // Avanca a linha de impressao.
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"CC")
				_cCCAnt := QRY1->D3_CC
			Endif
			@nLin, 039 PSay SubStr(QRY1->(AllTrim(D3_COD) + " " + B1_DESC), 1, 37)
		Endif
		@nLin, 079 PSay Transform(QRY1->B1_UM, "@S02")
		@nLin, 082 PSay Transform(QRY1->TOTQUANT, "@E 999,999,999.99")  // Quantidade.
		@nLin, 097 PSay Transform(QRY1->(TOTCUS / TOTQUANT), "@E 999,999,999.9999")  // Custo unitario.
		@nLin, 114 PSay Transform(QRY1->TOTCUS, "@E 999,999,999,999.99")  // Custo total.
	Else   // Sintetico.
		If _nOrdem == 1   // CR
			If _cCCAnt != QRY1->D3_CC
				nLin ++   // Avanca a linha de impressao.
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"CC")
				@nLin, 000 PSay SubStr(QRY1->(D3_CC + " " + CTT_DESC01), 1, 35)
				_cCCAnt := QRY1->D3_CC
			Endif
			@nLin, 037 PSay SubStr(QRY1->(B1_GRUPO + " " + BM_DESC), 1, 36)
		Else   // Grupo.
			If _cGRAnt != QRY1->B1_GRUPO
				nLin ++   // Avanca a linha de impressao.
				ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"GR")
				@nLin, 000 PSay SubStr(QRY1->(B1_GRUPO + " " + BM_DESC), 1, 37)
				_cGRAnt := QRY1->B1_GRUPO
			Endif
			@nLin, 039 PSay SubStr(QRY1->(D3_CC + " " + CTT_DESC01), 1, 34)
		Endif
		@nLin, 076 PSay Transform(QRY1->TOTCUS, "@E 999,999,999.99")
		@nLin, 100 PSay PadL(RTrim(QRY1->BM_CREDUZ2), len(QRY1->BM_CREDUZ2))  // Cta. de Despesa
		@nLin, 124 PSay PadL(RTrim(QRY1->BM_CREDUZ1), len(QRY1->BM_CREDUZ1))  // Cta. de Estoque
	Endif
	nLin ++   // Avanca a linha de impressao.
	
	// Totalizadores.
	_nTotGrp += QRY1->TOTCUS
	_nTotCR  += QRY1->TOTCUS
	_nTotal  += QRY1->TOTCUS
	
	QRY1->(dbSkip())  // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o total geral do relatorio.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"TOTAL")
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerTotais ºAutor  ³ Felipe Raposo      º Data ³  24/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se houve a quebra do relatorio para a impressao   º±±
±±º          ³ dos totalizadores.                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpTotal(nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,_cTipQbr,_cVal)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nCol := IIf(_mImp == 1, 65, 23)

_cTipQbr := AllTrim(_cTipQbr)
_lImpTotCC := _lImpTotCC .or. (_cTipQbr == "CC")
_lImpTotGR := _lImpTotGR .or. (_cTipQbr == "GR")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 55 .and.; // Salto de Página. Neste caso o formulario tem 55 linhas...
	(QRY1->(!eof()) .or. _nTotal != 0)  // Evita imprimir o cabecalho caso nao seja impresso nenhum registro.
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

// Imprime o total do grupo.
If _cTipQbr == "GR" .and. _lImpTotGR .and. !empty(_cGRAnt)
	@nLin, _nCol + 15 PSay "TOTAL DO GRUPO " + _cGRAnt + " ........: " + Transform(_nTotGrp, "@E 999,999,999,999,999.99")
	_nTotGrp := 0
	nLin += 2  // Avanca duas linhas de impressao.
Endif

// Imprime o total do CR.
If _cTipQbr == "CC" .and. _lImpTotCC .and. !empty(_cCCAnt)
	@nLin, _nCol + 5 PSay "TOTAL DO CR " + _cCCAnt + " ................: " + Transform(_nTotCR, "@E 999,999,999,999,999.99")
	_nTotCR := 0
	nLin += 2  // Avanca duas linhas de impressao.
Endif

// Imprime o total geral.
If _cTipQbr == "TOTAL" .and. _nTotal != 0
	// Imprime os totais do grupo e do CR antes de imprimir o total geral do relatorio.
	nLin ++
	If _nOrdem == 1  // CR.
		ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"GR")
		ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"CC")
	Else
		ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"CC")
		ImpTotal(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,"GR")
	Endif
	nLin ++
	@nLin, _nCol PSay "T O T A L   G E R A L .....................: " + Transform(_nTotal, "@E 999,999,999,999,999.99")
Endif
Return