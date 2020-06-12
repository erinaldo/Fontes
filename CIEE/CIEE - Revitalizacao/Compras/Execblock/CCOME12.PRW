#INCLUDE "rwmake.ch"    
#INCLUDE "topconn.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME12
Filtra as solicitacoes de compras para o comprador no momento da geracao da cotacao
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CCOME12(_cNumPed)
Local _cMsg := "", _cQry, _aCab, _aNotas := {}
Local _oDlg1, _oLbx1
Local _cAlias1 := GetArea()   
Local cTab:= GetNextAlias()

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

TCQuery _cQry NEW ALIAS cTab
(cTab)->(dbGoTop())
Do While (cTab)->(!eof())
	aAdd(_aNotas, {E2_NUM + IIF(!empty(E2_PREFIXO), "/" + E2_PREFIXO, ""),;
	E2_PARCELA, dtoc(stod(D1_EMISSAO)), dtoc(stod(D1_DTDIGIT)),;
	dtoc(stod(E2_VENCREA)), Transform(E2_VALOR, tm(E2_VALOR, 14)), D1_TES})
	(cTab)->(dbSkip())
EndDo
If Select(cTab) > 0
   (cTab)->(dbCloseArea())
EndIf

cTab:= GetNextAlias()

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

TCQuery _cQry NEW ALIAS cTab
(cTab)->(dbGoTop())
Do While (cTab)->(!eof())                     
	_nPsNota := aScan(_aNotas, {|x| LEFT(x[1],6) == F1_DOC})
	If _nPsNota == 0
		aAdd(_aNotas, {F1_DOC + IIF(!empty(F1_SERIE), "/" + F1_SERIE, ""),;
		" ", dtoc(stod(D1_EMISSAO)), dtoc(stod(D1_DTDIGIT)),;
		dtoc(stod(D1_DTDIGIT)), Transform(F1_VALMERC, tm(F1_VALMERC, 14)), D1_TES})
	EndIf
	(cTab)->(dbSkip())
EndDo

If Select(cTab) > 0
   (cTab)->(dbCloseArea())
EndIf

// Exibe a mensagem na tela.
If empty(_aNotas)
	_cMsg := "Não há nenhuma nota fiscal de entrada a partir desse pedido."
	MsgInfo(_cMsg, "Pedido " + _cNumPed)
Else
	// Monta o cabecalho.
	_aCab := {"Nota", "Parcela", "Emissão",;
	"Dt. Digit.", "Vencto.", "Valor", "TES"}
	// Tela com os objetos.
	@ 000, 000 TO 200, 700 DIALOG _oDlg1;
	TITLE "Relação de notas fiscais - Pedido " + _cNumPed
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