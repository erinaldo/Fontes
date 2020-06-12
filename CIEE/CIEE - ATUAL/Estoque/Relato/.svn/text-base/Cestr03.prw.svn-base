#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "DelAlias.ch"
//#INCLUDE "_FixSX.ch" // "AddSX1.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCestr03   บ Autor ณ Felipe Raposo      บ Data ณ  17/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emite o mapa de movimentacao dos produtos por grupo.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function Cestr03

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1     := OemToAnsi(" Este programa tem como objetivo imprimir relat๓rio ")
Local cDesc2     := OemToAnsi("de acordo com os parโmetros informados pelo usuแrio.")
Local cDesc3     := ""
Local cPict      := ""
Local titulo     := OemToAnsi("Demonstrativo Sint้tico de Movimento de Materiais")
Local nLin       := 80
Local Cabec1     := "Grupo                                             Saldo         Entradas          Saidas        Devolucoes            Saldo         Conta                  Conta                "
Local Cabec2     := "                                               Anterior                                                               Atual         Despesa                Estoque              "
************  := "9999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99         xxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxx "
************  := "T O T A L -------------------------->  9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99                                                     "
************  := "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345"
************  := "0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17     "
Local imprime    := .T.
Local aOrd       := {}
Local _aSX1
Local _aAreaB1, _aAreaB2, _aAreaBM
Private lAbortPrint := .F.
Private lEnd       := .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private NomeProg   := StrTran(FunName(), "#", "")
Private nTipo      := 18
Private aReturn    := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private cString    := ""
Private wnrel      := NomeProg
Private _cPicture  := "@E 9,999,999,999.99"
Private _aAliases  := {}  // Para a funcao FechaAlias()
Private cPerg
Private _mCodDe, _mCodAte, _mGrpDe, _mGrpAte, _mDataDe, _mDataAte, _mImpZer
Private lAbortPrint := .F., lEnd := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros informados pelo usuario.                                 ณ
//ณ---------------------------------------------------------------------ณ
//ณ _mCodDe   - Produto de                                              ณ
//ณ _mCodAte  - Produto ate                                             ณ
//ณ _mGrpDe   - Grupo de                                                ณ
//ณ _mGrpAte  - Grupo ate                                               ณ
//ณ _mDataDe  - Data de                                                 ณ
//ณ _mDataAte - Data ate                                                ณ
//ณ _mImpZer  - Grps s/ movtos  .T. Imprime   .F. Nao imprime           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cPerg      := "ESTR03    "

/*
_aSX1 := {;
{cPerg,"01","Produto de         ?","จDe Producto       ?","From Product       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""},;
{cPerg,"02","Produto Ate        ?","จA  Producto       ?","To Product         ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""},;
{cPerg,"03","Grupo de           ?","จFecha Limite      ?","From Group         ?","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""},;
{cPerg,"04","Grupo Ate          ?","จBloquea/Desbloquea?","To Group           ?","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""},;
{cPerg,"05","Emissao de         ?","จDe Emision        ?","From Issue         ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","''","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"06","Emissao ate        ?","จA  Emision        ?","To Issue           ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","''","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"07","Grupos sem movimento","Grupos sem movimento","Grupos sem movimento","mv_ch7","N",01,0,1,"C","","mv_par07","Imprime","Print","Imprime","","","Nao Imprime","Don't Print","Nao Imprime","","","","","","","","","","","","","","","","","","",""}}
AjustaSX1(_aSX1)
*/

If !Pergunte(cPerg, .T.)
   Return(Nil)
EndIf   


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

nTipo := IIf(aReturn[4] == 1, 15, 18)

// Configura os parametros informados pelo usuario.
_mCodDe   := mv_par01
_mCodAte  := mv_par02
_mGrpDe   := mv_par03
_mGrpAte  := mv_par04
_mDataDe  := mv_par05
_mDataAte := mv_par06
_mImpZer  := (mv_par07 == 1)

// Armazena as condicoes dos alias antes de processa-los.
_aAreaB1 := SB1->(GetArea())
_aAreaB2 := SB2->(GetArea())
_aAreaBM := SBM->(GetArea())

// Acerta os indices de pesquisa.
SB1->(dbSetOrder(1))  // B1_FILIAL+B1_COD.
SBM->(dbSetOrder(1))  // BM_FILIAL+BM_GRUPO.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//msAguarde({|lEnd| GeraArq()}, "Gerando o relat๓rio...", "Aguarde", .T.)

Processa({|lEnd|  GeraArq() },"Selecionando Registros...")

RptStatus({|| ImpRel(Cabec1, Cabec2, Titulo, nLin)}, Titulo)

// Restaura as condicoes dos alias.
SB1->(RestArea(_aAreaB1))
SB2->(RestArea(_aAreaB2))
SBM->(RestArea(_aAreaBM))
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณGeraArq   บ Autor ณ Felipe Raposo      บ Data ณ  17/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GeraArq()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aEstrut, _cArqTrab, _aAreaB1
Local _cAux1, _nAux1

// Exibe a tela de processamento.
//MsProcTxt("Abrindo Tabelas Temporarias..")

// Define a estrutura do arquivo de trabalho.
_aEstrut := {;
{"XX_GRUPO",   "C", 04, 0},;
{"XX_SALANT",  "N", 14, 2},;
{"XX_ENTRADA", "N", 14, 2},;
{"XX_SAIDAS",  "N", 14, 2},;
{"XX_DEVOL",   "N", 14, 2}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)

// Abre o arquivo de trabalho para uso.
// Parametros da funcao dbUseArea
// 1 - Logico - Abrir nova area.
// 2 - Char   - "DBFCDX", "TOPCONN"
// 3 - Char   - Arquivo
// 4 - Char   - Alias
// 5 - Logico - Compartilhado
// 6 - Logico - Apenas leitura.
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TMP", _cArqTrab, "XX_GRUPO",,, "Criando indice...", .T.)

// Matriz que armazena os alias temporarios aberto para futura exclusao.
// Estrutura da matriz.
// 1 - Char   - Alias.
// 2 - Char   - Arquivo de dados.
// 3 - Char   - Arquivo do indice.
// 1 - Logico - Alias aberto (.T.) ou nao (.F.).
aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

// Entrada de materiais.
_cQry1 :=;
"SELECT B1_GRUPO, SUM(D1_CUSTO) XX_TOTAL FROM " + _EOL + ;
RetSQLName('SD1') + " D1, " + RetSQLName('SB1') + " B1, " + _EOL + ;
RetSQLName('SBM') + " BM, " + RetSQLName('SF4') + " F4  " + _EOL + ;
"WHERE " + _EOL + ;
"B1_COD   = D1_COD   AND " + _EOL + ;
"BM_GRUPO = B1_GRUPO AND " + _EOL + ;
"B1_COD     BETWEEN '" + _mCodDe + "' AND '" + _mCodAte + "' AND " + _EOL + ;
"B1_GRUPO   BETWEEN '" + _mGrpDe + "' AND '" + _mGrpAte + "' AND " + _EOL + ;
"D1_TES = F4_CODIGO AND " + _EOL + ;
"F4_ESTOQUE = 'S' AND " + _EOL + ;
"D1_DTDIGIT BETWEEN '" + dtos(_mDataDe) + "' AND '" + dtos(_mDataAte) + "' AND " + _EOL + ;
"B1. D_E_L_E_T_ <> '*' AND " + _EOL + ;
"BM. D_E_L_E_T_ <> '*' AND " + _EOL + ;
"D1. D_E_L_E_T_ <> '*' AND " + _EOL + ;
"F4. D_E_L_E_T_ <> '*' " + _EOL + ;
"GROUP BY B1_GRUPO"

// Saida de materiais.
_cQry2 :=;
"SELECT B1_GRUPO, SUM(D2_CUSTO1) XX_TOTAL FROM " + _EOL + ;
RetSQLName('SD2') + " D2, " + RetSQLName('SB1') + " B1, " + _EOL + ;
RetSQLName('SBM') + " BM, " + RetSQLName('SF4') + " F4  " + _EOL + ;
"WHERE " + _EOL + ;
"B1_COD   = D2_COD   AND " + _EOL + ;
"BM_GRUPO = B1_GRUPO AND " + _EOL + ;
"B1_COD     BETWEEN '" + _mCodDe + "' AND '" + _mCodAte + "' AND " + _EOL + ;
"B1_GRUPO   BETWEEN '" + _mGrpDe + "' AND '" + _mGrpAte + "' AND " + _EOL + ;
"D2_TES = F4_CODIGO AND " + _EOL + ;
"F4_ESTOQUE = 'S' AND " + _EOL + ;
"D2_EMISSAO BETWEEN '" + dtos(_mDataDe) + "' AND '" + dtos(_mDataAte) + "' AND " + _EOL + ;
"B1. D_E_L_E_T_ <> '*' AND " + _EOL + ;
"BM. D_E_L_E_T_ <> '*' AND " + _EOL + ;
"D2. D_E_L_E_T_ <> '*' " + _EOL + ;
"GROUP BY B1_GRUPO " + _EOL + ;
"ORDER BY 1"

// Movimentos internos (consumo, devolucoes, transferencias, producao, etc).
_cQry3 :=;
"SELECT B1_GRUPO, " + _EOL + ;
"CASE " + _EOL + ;
"	WHEN SAIDAS IS NULL THEN 0 " + _EOL + ;
"	ELSE SAIDAS " + _EOL + ;
"END XX_TOTSAI, " + _EOL + ;
"CASE " + _EOL + ;
"	WHEN DEVOLUCOES IS NULL THEN 0 " + _EOL + ;
"	ELSE DEVOLUCOES " + _EOL + ;
"END XX_TOTDEV " + _EOL + ;
"FROM ( " + _EOL + ;
"	SELECT BM_GRUPO B1_GRUPO, " + _EOL + ;
"	( " + _EOL + ;
"		SELECT SUM(D3_CUSTO1) FROM " + RetSQLName("SD3") + " D3, " + RetSQLName("SB1") + " B1 " + _EOL + ;
"		WHERE " + _EOL + ;
"		B1_COD = D3_COD AND " + _EOL + ;
"		B1_GRUPO = BM_GRUPO AND " + _EOL + ;
"		B1_COD BETWEEN '" + _mCodDe + "' AND '" + _mCodAte + "' AND " + _EOL + ;
"		D3_EMISSAO BETWEEN '" + dtos(_mDataDe) + "' AND '" + dtos(_mDataAte) + "' AND " + _EOL + ;
"		D3_ESTORNO = ' ' AND " + _EOL + ;
"		(D3_OP = '' OR SUBSTRING(D3_OP, 7, 2) = 'OS') AND " + _EOL + ;
"		D3_TM <= '500' AND " + _EOL + ;
"		D3.D_E_L_E_T_ <> '*' AND " + _EOL + ;
"		B1.D_E_L_E_T_ <> '*' " + _EOL + ;
"	) DEVOLUCOES, " + _EOL + ;
"	( " + _EOL + ;
"		SELECT SUM(D3_CUSTO1) FROM " + RetSQLName("SD3") + " D3, " + RetSQLName("SB1") + " B1 " + _EOL + ;
"		WHERE " + _EOL + ;
"		B1_COD = D3_COD AND " + _EOL + ;
"		B1_GRUPO = BM_GRUPO AND " + _EOL + ;
"		B1_COD BETWEEN '" + _mCodDe + "' AND '" + _mCodAte + "' AND " + _EOL + ;
"		D3_EMISSAO BETWEEN '" + dtos(_mDataDe) + "' AND '" + dtos(_mDataAte) + "' AND " + _EOL + ;
"		D3_ESTORNO = ' ' AND " + _EOL + ;
"		(D3_OP = '' OR SUBSTRING(D3_OP, 7, 2) = 'OS') AND " + _EOL + ;
"		D3_TM > '500' AND " + _EOL + ;
"		D3.D_E_L_E_T_ <> '*' AND " + _EOL + ;
"		B1.D_E_L_E_T_ <> '*' " + _EOL + ;
"	) SAIDAS " + _EOL + ;
"	FROM " + RetSQLName("SBM") + " BM WHERE " + _EOL + ;
"	BM_GRUPO BETWEEN '" + _mGrpDe + "' AND '" + _mGrpAte + "' AND" + _EOL + ;
"	BM.D_E_L_E_T_ <> '*' " + _EOL + ;
") A"

// Calcula o saldo inicial.
// Aramzena as condicoes da tabela antes de processa-la.
_aArea := SB2->(GetArea())
_nAux1 := SB2->(RecCount())
ProcRegua(_nAux1)
_nAux2 := 1
SB2->(dbSetOrder(1))  // B2_FILIAL+B2_COD+B2_LOCAL.
SB2->(dbSeek(xFilial("SB2") + _mCodDe, .T.))
Do While SB2->(B2_FILIAL + B2_COD) <= xFilial("SB2") + _mCodAte .and. SB2->(!eof())
	
	// Exibe a tela de processamento.


	If lAbortPrint
		Exit  // Sai do looping se o usuario cancelar a operacao.
	Endif
	
	// Calcula o saldo em estoque na data e retorna em uma matriz onde o
	// segundo item eh o saldo financeiro na moeda 1.
//    MsProcTxt("Lendo Produto... " + SB2->B2_COD)
    IncProc("Lendo Produto "+SB2->B2_COD)

    If !SB2->B2_COD >= _mCodDe .or. !SB2->B2_COD <= _mCodAte 
       SB2->(DBSKIP())
	   LOOP
    Endif   
    SB1->(dbSeek(xFilial("SB1") + SB2->B2_COD, .F.))
    If !SB1->B1_GRUPO >= _mGrpDe .or. !SB1->B1_GRUPO <= _mGrpAte 
       SB2->(DBSKIP())
       LOOP
    Endif   
    SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO, .F.))
//    MsProcTxt("Calculando Saldo Produto... " + SB2->B2_COD)
//     IncProc("Calcunado Saldo Produto "+SB2->B2_COD)
		_aAux1 := CalcEst(SB2->B2_COD, SB2->B2_LOCAL, _mDataDe)
	
	/*
	If  Entre(_mCodDe, _mCodAte, SB2->B2_COD) .and.;
		SB1->(dbSeek(xFilial("SB1") + SB2->B2_COD, .F.)) .and.;
		Entre(_mGrpDe, _mGrpAte, SB1->B1_GRUPO) .and.;
		SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO, .F.))
		
		// Cria o registro caso ele nao exista.
		If TMP->(dbSeek(SB1->B1_GRUPO, .F.))
			RecLock("TMP", .F.)
		Else
			RecLock("TMP", .T.)
			TMP->XX_GRUPO   := SB1->B1_GRUPO
		Endif
	
	
		TMP->XX_SALANT += _aAux1[2]
	Endif
	*/

		// Cria o registro caso ele nao exista.
		If TMP->(dbSeek(SB1->B1_GRUPO, .F.))
			RecLock("TMP", .F.)
		Else
			RecLock("TMP", .T.)
			TMP->XX_GRUPO   := SB1->B1_GRUPO
		Endif
	
	
		TMP->XX_SALANT += _aAux1[2]
	//Endif

	SB2->(dbSkip())
EndDo
// Restaura as condicoes anteriores da tabela.
SB2->(RestArea(_aArea))

// Processa as queries (movimentacoes de estoque).
For _nAux1 := 1 to 3
	// Exibe a tela de processamento.
	Do Case
		Case _nAux1 == 1
//			MsProcTxt("Calculando as entradas...")
		IncProc("Calculando as entradas...")
		Case _nAux1 == 2
//			MsProcTxt("Calculando as saidas...")
			IncProc("Calculando as saidas...")
		Case _nAux1 == 3
//			MsProcTxt("Calculando a movimentacao interna...")
			IncProc("Calculando a movimentacao interna...")
	EndCase
	If lAbortPrint
		Exit  // Sai do looping se o usuario cancelar a operacao.
	Endif
	
	// Grava a query em disco e a executa.
	_cAux1 := &("_cQry" + Str(_nAux1, 1))
	MemoWrit(StrTran(FunName(), "#", "") + str(_nAux1, 1) + ".SQL", _cAux1)
	TcQuery _cAux1 NEW ALIAS "QRY"
	
	// Processa a query retornada.
	QRY->(dbGoTop())
	Do While QRY->(!eof())
		// Cria o registro caso ele nao exista.
		If TMP->(dbSeek(QRY->B1_GRUPO, .F.))
			RecLock("TMP", .F.)
		Else
			RecLock("TMP", .T.)
			TMP->XX_GRUPO   := QRY->B1_GRUPO
		Endif
		
		// Classifica a movimentacao (ent/sai/dev).
		Do Case
			Case _nAux1 == 1
				TMP->XX_ENTRADA += QRY->XX_TOTAL
			Case _nAux1 == 2
				TMP->XX_SAIDAS  += QRY->XX_TOTAL
			Case _nAux1 == 3
				TMP->XX_SAIDAS  += QRY->XX_TOTSAI
				TMP->XX_DEVOL   += QRY->XX_TOTDEV
		EndCase
		TMP->(msUnLock())
		QRY->(dbSkip())
	EndDo
	
	// Fecha a query.
	QRY->(dbCloseArea())
Next _nAux1
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณImpRel    บ Autor ณ Felipe Raposo      บ Data ณ  17/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpRel(Cabec1,Cabec2,Titulo,nLin)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nTotAnt, _nTotEnt, _nTotSai, _nTotDev

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SetRegua(TMP->(RecCount()))

_nTotAnt := _nTotEnt := _nTotSai := _nTotDev := 0
titulo += " - " + dtoc(_mDataDe) + " a " + dtoc(_mDataAte)

TMP->(dbGoTop())
Do While TMP->(!eof())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IncRegua()
	If lAbortPrint
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		VerCabec(@nLin, Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		@nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	// Imprime a linha.
	// Nao imprime os zerados se o usuario assim desejar.
	If  Entre(_mGrpDe, _mGrpAte, TMP->XX_GRUPO) .and.;
		(_mImpZer .or.;
		TMP->XX_SALANT != 0 .or. TMP->XX_ENTRADA != 0 .or.;
		TMP->XX_SAIDAS != 0 .or. TMP->XX_DEVOL   != 0)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		VerCabec(@nLin, Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		
		// Posiciona no grupo
		SBM->(dbSeek(xFilial("SBM") + TMP->XX_GRUPO, .F.))
		
		@nLin, 000 PSay SubStr(AllTrim(TMP->XX_GRUPO) + " - " + SBM->BM_DESC, 1, 38)
		@nLin, 039 PSay Transform(TMP->XX_SALANT,  _cPicture)  // Saldo anterior.
		@nLin, 056 PSay Transform(TMP->XX_ENTRADA, _cPicture)  // Entradas.
		@nLin, 073 PSay Transform(TMP->XX_SAIDAS,  _cPicture)  // Saidas.
		@nLin, 090 PSay Transform(TMP->XX_DEVOL,   _cPicture)  // Devolucoes.
		@nLin, 107 PSay Transform(TMP->(XX_SALANT + XX_ENTRADA - XX_SAIDAS + XX_DEVOL), _cPicture)  // Saldo final.
		@nLin, 132 PSay Transform(SBM->BM_CREDUZ2, PesqPict("SBM", "BM_CREDUZ2"))  // Conta de despesa.
		@nLin, 155 PSay Transform(SBM->BM_CREDUZ1, PesqPict("SBM", "BM_CREDUZ1"))  // Conta de estoque.
		nLin ++ // Avanca a linha de impressao.
		
		_nTotAnt += TMP->XX_SALANT
		_nTotEnt += TMP->XX_ENTRADA
		_nTotSai += TMP->XX_SAIDAS
		_nTotDev += TMP->XX_DEVOL
	Endif
	TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho do relatorio. . .                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
VerCabec(@nLin, Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

// Imprime o total.
If _nTotAnt != 0 .or. _nTotEnt != 0 .or. _nTotSai != 0 .or. _nTotDev != 0
	nLin ++ // Avanca uma linha de impressao.
	@nLin, 000 PSay "T O T A L --------->"
	@nLin, 039 PSay Transform(_nTotAnt, _cPicture)  // Saldo anterior.
	@nLin, 056 PSay Transform(_nTotEnt, _cPicture)  // Entradas.
	@nLin, 073 PSay Transform(_nTotSai, _cPicture)  // Saidas.
	@nLin, 090 PSay Transform(_nTotDev, _cPicture)  // Devolucoes.
	@nLin, 107 PSay Transform((_nTotAnt + _nTotEnt - _nTotSai + _nTotDev), _cPicture)  // Saldo final.
Endif

// Fecha os alias abertos e apaga os arquivos (DBFs e indices temporarios).
FechaAlias(_aAliases)  // DelAlias.ch

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerCabec  บAutor  ณ Felipe Raposo      บ Data ณ  24/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se ha a necessidade de imprimir o cabecalho. Caso บฑฑ
ฑฑบ          ณ haja a necessidade, ele eh impresso.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function VerCabec(nLin, Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho do relatorio. . .                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	nLin := 9
Endif
Return