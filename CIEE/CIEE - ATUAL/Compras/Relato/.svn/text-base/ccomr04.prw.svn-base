#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#include "_FixSX.ch" // "AddSX1.ch"
#DEFINE _EOL chr(13) + chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCOMR04   º Autor ³ Felipe Raposo      º Data ³  23/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de descontos e despesas de pedidos e cotacoes de º±±
±±º          ³ compra.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CCOMR04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de desconto e despesa de Pedido/Cotação de Compra,"
Local cDesc3  := "de acordo com os parametros informados pelo usuario."
Local titulo  := "Desconto/Despesa"
Local nLin    := 80
Local imprime := .T.
Local aOrd    := {}
Local _aPerg
Local Cabec1 := "Num.      Fornecedor                                                                                           |               C O T A Ç Ã O                 |                P E D I D O                  |     T O T A L |"
Local Cabec2 := "Pedido                                                                                                         |         Valor       Desconto        Despesa |         Valor       Desconto        Despesa |               |"
****        := "xxxxxx    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |999,999,999.99 999,999,999.99 999,999,999.99 |999,999,999.99 999,999,999.99 999,999,999.99 |999,999,999.99 |"
****        := "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
****        := "0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21         "
Private cPict       := "@E 999,999,999.99"
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := StrTran(FunName(), "#", "")
Private wnrel       := nomeprog
Private nTipo       := 18
Private aReturn     := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private cPerg       := "COMR04    "
Private cString     := "SC7"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Pedido de                                   ³
//³ mv_par02 - Pedido ate                                  ³
//³ mv_par03 - Produto de                                  ³
//³ mv_par04 - Produto ate                                 ³
//³ mv_par05 - Fornecedor de                               ³
//³ mv_par06 - Fornecedor ate                              ³
//³ mv_par07 - Data de emissao de                          ³
//³ mv_par08 - Data de emissao ate                         ³
//³ mv_par09 - Comprador de                                ³
//³ mv_par10 - Comprador ate                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerg := {;
{cPerg,"01","Pedido de          ?","¨De Pedido         ?","From Order         ?","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"02","Pedido ate         ?","¨A  Pedido         ?","To Order           ?","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"03","Produto de         ?","¨De Producto       ?","From Product       ?","mv_ch3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""},;
{cPerg,"04","Produto ate        ?","¨A  Producto       ?","To Product         ?","mv_ch4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""},;
{cPerg,"05","Fornecedor de      ?","¨De Proveedor      ?","From Supplier      ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","001"},;
{cPerg,"06","Fornecedor ate     ?","¨A  Proveedor      ?","To Supplier        ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","001"},;
{cPerg,"07","Emissao de         ?","¨De Emision        ?","From Issue         ?","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"08","Emissao ate        ?","¨A  Emision        ?","To Issue           ?","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"09","Comprador de       ?","¨De Comprador      ?","From Buye          ?","mv_ch9","C",06,0,1,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","USR","",""},;
{cPerg,"10","Comprador ate      ?","¨A  Comprador      ?","To Buyer           ?","mv_cha","C",06,0,1,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","USR","",""}}
AjustaSX1(_aPerg)
Pergunte(cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
nTipo := IIf(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)}, Titulo)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOrdem
Local _cQry
Local _aTotal := {0, 0, 0, 0, 0, 0, 0}

_cQry :=;
"SELECT *, VALOR - DESCONTO + DESPESA TOTAL FROM " + _EOL +;
"( " + _EOL +;
"	SELECT C7_NUM, C7_FORNECE + '/' + C7_LOJA + ' - ' + A2_NOME FORNECEDOR, " + _EOL +;
"	( " + _EOL +;
"		SELECT SUM(C8_PRECO * C8_QUANT) FROM " + RetSQLName("SC8") + " C8 " + _EOL +;
"		WHERE C7_NUM = C8_NUMPED AND " + _EOL +;
"		C8.D_E_L_E_T_ = '' " + _EOL +;
"	) VLRCOT, " + _EOL +;
"	( " + _EOL +;
"		SELECT SUM(C8_VLDESC) FROM " + RetSQLName("SC8") + " C8 " + _EOL +;
"		WHERE C7_NUM = C8_NUMPED AND " + _EOL +;
"		C8.D_E_L_E_T_ = '' " + _EOL +;
"	) DESCCOT, " + _EOL +;
"	( " + _EOL +;
"		SELECT SUM(C8_DESPESA) FROM " + RetSQLName("SC8") + " C8 " + _EOL +;
"		WHERE C7_NUM = C8_NUMPED AND " + _EOL +;
"		C8.D_E_L_E_T_ = '' " + _EOL +;
"	) DESPCOT, " + _EOL +;
"	SUM(C7_TOTAL) VALOR, SUM(C7_VLDESC) DESCONTO, SUM(C7_DESPESA) DESPESA " + _EOL +;
"	FROM " + RetSQLName("SC7") + " C7, " + RetSQLName("SA2") + " A2 " + _EOL +;
"	WHERE " + _EOL +;
"	A2_COD  = C7_FORNECE AND " + _EOL +;
"	A2_LOJA = C7_LOJA AND " + _EOL +;
"	C7_NUM     BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND " + _EOL +;
"	C7_PRODUTO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND " + _EOL +;
"	C7_FORNECE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND " + _EOL +;
"	C7_EMISSAO BETWEEN '" + dtos(mv_par07) + "' AND '" + dtos(mv_par08) + "' AND " + _EOL +;
"	C7_USER    BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND " + _EOL +;
"	A2.D_E_L_E_T_ = '' AND " + _EOL +;
"	C7.D_E_L_E_T_ = '' " + _EOL +;
"	GROUP BY C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME " + _EOL +;
") A"

// Conta quantos registros serao processados.
_cQryAux := "SELECT COUNT(*) REGS FROM (" + _cQry + ") A"
TCQuery _cQryAux NEW ALIAS "TMP"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(TMP->REGS)
TMP->(dbCloseArea())

// Abre a tabela auxiliar com os decontos.
_cQry += " ORDER BY 1"
MemoWrit(StrTran(FunName(), "#", "") + ".SQL", _cQry)
TCQuery _cQry NEW ALIAS "TMP"

TMP->(dbGoTop())
Do While TMP->(!eof())
	
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
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Imprime a linha.
	@ nLin, 000 PSay TMP->C7_NUM
	@ nLin, 010 PSay SubStr(TMP->FORNECEDOR, 1, 100)
	@ nLin, 111 PSay "|"  // Separador - Valores da cotacao.
	@ nLin, 112 PSay TMP->VLRCOT   Picture cPict
	@ nLin, 127 PSay TMP->DESCCOT  Picture cPict
	@ nLin, 142 PSay TMP->DESPCOT  Picture cPict
	@ nLin, 157 PSay "|"  // Separador - Valores do pedido.
	@ nLin, 158 PSay TMP->VALOR    Picture cPict
	@ nLin, 173 PSay TMP->DESCONTO Picture cPict
	@ nLin, 188 PSay TMP->DESPESA  Picture cPict
	@ nLin, 203 PSay "|"  // Separador - Valor total.
	@ nLin, 204 PSay TMP->TOTAL    Picture cPict
	@ nLin, 219 PSay "|"  // Separador - Final da linha.
	
	// Atualiza os totalizadores.
	_aTotal[1] += TMP->VLRCOT
	_aTotal[2] += TMP->DESCCOT
	_aTotal[3] += TMP->DESPCOT
	_aTotal[4] += TMP->VALOR
	_aTotal[5] += TMP->DESCONTO
	_aTotal[6] += TMP->DESPESA
	_aTotal[7] += TMP->TOTAL
	
	nLin ++ // Avanca a linha de impressao
	TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
TMP->(dbCloseArea())

// Imprime os totais.
@ nLin, 000 PSay Replicate("-", limite); nLin++
@ nLin, 095 PSay "T O T A I S --> |"
@ nLin, 112 PSay _aTotal[1] Picture cPict
@ nLin, 127 PSay _aTotal[2] Picture cPict
@ nLin, 142 PSay _aTotal[3] Picture cPict
@ nLin, 157 PSay "|"  // Separador - Valores do pedido.
@ nLin, 158 PSay _aTotal[4] Picture cPict
@ nLin, 173 PSay _aTotal[5] Picture cPict
@ nLin, 188 PSay _aTotal[6] Picture cPict
@ nLin, 203 PSay "|"  // Separador - Valor total.
@ nLin, 204 PSay _aTotal[7] Picture cPict
@ nLin, 219 PSay "|"  // Separador - Final da linha.

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