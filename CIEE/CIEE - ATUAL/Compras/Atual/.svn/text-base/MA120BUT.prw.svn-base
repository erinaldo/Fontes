#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120BUT  บ Autor ณ Felipe Raposo      บ Data ณ  24/03/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada: MA120BUT     Programa: MATA120/MATA121   บฑฑ
ฑฑบ          ณ INCLUSAO DE BOTOES                                         บฑฑ
ฑฑบ          ณ O ponto e chamado no momento da definicao dos botoes       บฑฑ
ฑฑบ          ณ padrao do pedido de compra (apos versao 508).              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Para adicionar mais de um botao adicionar mais matrizes a  บฑฑ
ฑฑบ          ณ matriz.                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Uma matriz onde cada elemento deve ser uma matriz com a se-บฑฑ
ฑฑบ          ณ guinte estrutura:                                          บฑฑ
ฑฑบ          ณ {"BITMAP", {|| Funcao()}, "ToolTip"}                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Onde:                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ "BITMAP" -> Nome do bitmap do botao. O mesmo deve estar    บฑฑ
ฑฑบ          ณ contido nas DLLs de recursos do siga.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ {|| Funcao()} -> CodeBlock contendo a funcao a ser chamada.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ "ToolTip" -> Descricao do Botao.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObs.      ณ Um documento com os bitmaps disponiveis no sistema se en-  บฑฑ
ฑฑบ          ณ contra no \\fenix\AP6\docs\Outros\BitMaps.zip              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MA120BUT

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aRet := {}
Local _cAlias := GetArea("SC7")


aAdd (_aRet, {"ALTERA", {|| ListNotas(CA120Num)}, "Notas fiscais"})

IF !INCLUI .AND. !ALTERA .AND. ! "MATA097" $ FUNNAME()
	aadd(_aRet,{"S4WB007N", {|| U_A120PC()},OemToAnsi("Impressใo AF")}) 
ENDIF

RestArea(_cAlias)

Return(_aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณListNotas บAutor  ณ Felipe Raposo      บ Data ณ  24/03/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a lista de notas fiscais referentes ao pedido.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ListNotas(_cNumPed)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cMsg := "", _cQry, _aCab, _aNotas := {}
Local _oDlg1, _oLbx1
Local _cAlias1 := GetArea()
// Monta a lista de notas fiscais referentes ao pedido.
_cQry :=;
"SELECT D1_DOC, E2_PREFIXO, E2_NUM, E2_TIPO, D1_EMISSAO, " + _EOL +;
"D1_DTDIGIT, E2_PARCELA, E2_VENCREA, E2_VALOR, D1_TES FROM " + _EOL +;
"( " + _EOL +;
"	SELECT D1_PEDIDO, D1_DOC, D1_SERIE, D1_FORNECE, " + _EOL +;
"	D1_LOJA, D1_EMISSAO, D1_DTDIGIT, D1_TES " + _EOL +;
"	FROM " + RetSQLName("SD1") + " SD1 WHERE " + _EOL +;
"	SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND " + _EOL +;
"	SD1.D1_PEDIDO = '" + _cNumPed + "' AND " + _EOL +;
"	SD1.D_E_L_E_T_ <> '*' " + _EOL +;
"	GROUP BY D1_PEDIDO, D1_DOC, D1_SERIE, " + _EOL +;
"	D1_FORNECE, D1_LOJA, D1_EMISSAO, D1_DTDIGIT, D1_TES " + _EOL +;
") SD1, " + _EOL +;
RetSQLName("SE2") + " SE2 WHERE " + _EOL +;
"SE2.E2_FILIAL = '" + xFilial("SE2") + "' AND " + _EOL +;
"SE2.E2_NUM     = SD1.D1_DOC   AND " + _EOL +;
"SE2.E2_PREFIXO = SD1.D1_SERIE AND " + _EOL +;
"SE2.E2_FORNECE = SD1.D1_FORNECE AND " + _EOL +;
"SE2.E2_LOJA    = SD1.D1_LOJA    AND " + _EOL +;
"SE2.D_E_L_E_T_ <> '*' " + _EOL +;
"ORDER BY 1, 2"
MemoWrit(StrTran(FunName(), "#", "") + ".SQL", _cQry)
TCQuery _cQry NEW ALIAS "TRB"
TRB->(dbGoTop())
Do While TRB->(!eof())
	aAdd(_aNotas, {E2_NUM + IIF(!empty(E2_PREFIXO), "/" + E2_PREFIXO, ""),;
	E2_PARCELA, dtoc(stod(D1_EMISSAO)), dtoc(stod(D1_DTDIGIT)),;
	dtoc(stod(E2_VENCREA)), Transform(E2_VALOR, tm(E2_VALOR, 14)), D1_TES})
	TRB->(dbSkip())
EndDo
If Select("TRB") > 0
   TRB->(dbCloseArea())
EndIf

_cQry :=;
"SELECT D1_DOC, D1_EMISSAO, " + _EOL +;
"D1_DTDIGIT, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_VALMERC, D1_TES FROM " + _EOL +;
"( " + _EOL +;
"	SELECT D1_PEDIDO, D1_DOC, D1_SERIE, D1_FORNECE, " + _EOL +;
"	D1_LOJA, D1_EMISSAO, D1_DTDIGIT, D1_TES " + _EOL +;
"	FROM " + RetSQLName("SD1") + " SD1 WHERE " + _EOL +;
"	SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND " + _EOL +;
"	SD1.D1_PEDIDO = '" + _cNumPed + "' AND " + _EOL +;
"	SD1.D_E_L_E_T_ <> '*' " + _EOL +;
"	GROUP BY D1_PEDIDO, D1_DOC, D1_SERIE, " + _EOL +;
"	D1_FORNECE, D1_LOJA, D1_EMISSAO, D1_DTDIGIT, D1_TES " + _EOL +;
") SD1, " + _EOL +;
RetSQLName("SF1") + " SF1 WHERE " + _EOL +;
"SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND " + _EOL +;
"SF1.F1_DOC     = SD1.D1_DOC   AND " + _EOL +;
"SF1.F1_SERIE   = SD1.D1_SERIE AND " + _EOL +;
"SF1.F1_FORNECE = SD1.D1_FORNECE AND " + _EOL +;
"SF1.F1_LOJA    = SD1.D1_LOJA    AND " + _EOL +;
"SF1.D_E_L_E_T_ <> '*' " + _EOL +;
"ORDER BY 1, 2"
MemoWrit(StrTran(FunName(), "#", "") + ".SQL", _cQry)
TCQuery _cQry NEW ALIAS "TRB"
TRB->(dbGoTop())
Do While TRB->(!eof())                     
	_nPsNota := aScan(_aNotas, {|x| LEFT(x[1],6) == F1_DOC})
	If _nPsNota == 0
		aAdd(_aNotas, {F1_DOC + IIF(!empty(F1_SERIE), "/" + F1_SERIE, ""),;
		" ", dtoc(stod(D1_EMISSAO)), dtoc(stod(D1_DTDIGIT)),;
		dtoc(stod(D1_DTDIGIT)), Transform(F1_VALMERC, tm(F1_VALMERC, 14)), D1_TES})
	EndIf
	TRB->(dbSkip())
EndDo

If Select("TRB") > 0
   TRB->(dbCloseArea())
EndIf



// Exibe a mensagem na tela.
If empty(_aNotas)
	_cMsg := "Nใo hแ nenhuma nota fiscal de entrada a partir desse pedido."
	MsgInfo(_cMsg, "Pedido " + _cNumPed)
Else
	// Monta o cabecalho.
	_aCab := {"Nota", "Parcela", "Emissใo",;
	"Dt. Digit.", "Vencto.", "Valor", "TES"}
	// Tela com os objetos.
	@ 000, 000 TO 200, 700 DIALOG _oDlg1;
	TITLE "Rela็ใo de notas fiscais - Pedido " + _cNumPed
	// Quadro de objetos.
	@ 001, 003 TO 086, 350 TITLE "Notas fiscais"
	// Lista das notas.
	_oLbx1 := RDListBox(0.5, 0.7, 341, 075, _aNotas, _aCab)
	// Botao.
	@ 087, 320 BMPBUTTON TYPE 1 ACTION (_oDlg1:end())
	// Ativa a tela.
	ACTIVATE DIALOG _oDlg1 CENTERED
Endif

RestArea(_cAlias1)

Return
