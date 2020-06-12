#INCLUDE "rwmake.ch"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE11 
Se houver adiantamento (pagamento a partir da emissao do pedido de compra), o sistema exibe
uma caixa de dialogo com os titulos gerados pela nota e os de adiantamento para ajustes. 
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
USER FUNCTION CESTE11()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaC8, _aAreaD1, _aAreaZ3, _cAlsAnt
Local _aCondPag, _aAux1, _nAux1, _nAux2
Private _aPagAdi := {}, aCols, aHeader, n
Private _nOpc := 2, oDlgPgto, oLbxPgtoN, _oTotal, _nTotal, _cTotNF, _nTotNF
Private _cPict := "@E 999,999,999.99"

// Armazena as condicoes dos alias antes do processamento.
_aAreaC8 := SC8->(GetArea())
_aAreaD1 := SD1->(GetArea())
_aAreaZ3 := SZ3->(GetArea())
_cAlsAnt := Alias()

// Acerta os indices das tabelas.
SC8->(dbSetOrder(6))  // C8_FILIAL+C8_NUMPED+C8_ITEMPED+C8_COTSTS.
SD1->(dbSetOrder(1))  // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM.
SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.

// Processa todos os itens da nota.
// Busca se houve algum adiantamento no momento do fechamento da
// cotacao de compra (emissao do pedido de compra).
SD1->(dbGoTop())
SD1->(dbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA), .F.))
Do While SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
	// Fazer se a nota foi entrada a partir de um pedido de compra.
	If SC8->(dbSeek(xFilial("SC8") + SD1->(D1_PEDIDO + D1_ITEMPC + "1"), .F.))
		_aCondPag := U_GetCondPag(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 2)  // CESTA04.PRW
		_nAux2  := len(_aCondPag)
		// Verifica todas as parcelas informadas na cotacao desse item.
		For _nAux1 := 1 to _nAux2
			_cCotAux := _aCondPag[_nAux1]
			// Se houver pagto. a partir da emissao do Ped. de Compra (adiantamento).
			If SZ3->(dbSeek(xFilial("SZ3") + _cCotAux, .F.)) .and. SZ3->Z3_TIPO $ "D/P"
				aAdd(_aPagAdi, {SD1->D1_PEDIDO, SD1->D1_ITEMPC, SD1->D1_ITEM, SZ3->Z3_NUMCOT, SZ3->Z3_PARCELA, SZ3->Z3_VALOR})
				Exit
			Endif
		Next _nAux1
	Endif
	SD1->(dbSkip())
EndDo

// Se for constatada a existencia de algum adiantamento, abater o valor
// da parcela criada pelo sistema.
If !empty(_aPagAdi)
	
	// Exibe uma tela com os pagamentos adiantados.
	_cMsg := "Houve adiantamento de pagamento para essa nota, nos seguintes pedidos:" + _EOL + _EOL
	For _nAux1 := 1 to len(_aPagAdi)
		_cMsg += _aPagAdi[_nAux1, 1] + IIF(!empty(_aPagAdi[_nAux1, 2]), "/" + _aPagAdi[_nAux1, 2], "  ") +;
		" - " + Transform(SZ3->Z3_VALOR, PesqPict("SZ3", "Z3_VALOR")) + _EOL
	Next _nAux1
	MsgInfo(OemToAnsi(_cMsg))
	
	// Quando estiver tudo validado, sair da tela e processar o SE2.
	_lTudoOk := .F.
	Do While !_lTudoOk
		C4E11TIT()
		_lTudoOk := C4E11VAL()
	EndDo
	C4E11PRO()
Endif

// Restaura as condicoes dos alias.
SC8->(RestArea(_aAreaC8))
SD1->(RestArea(_aAreaD1))
SZ3->(RestArea(_aAreaZ3))
dbSelectArea(_cAlsAnt)

Return                      
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C4E11TIT   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Exibe tela com os titulos da NF e do pedido				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/  
Static Function C4E11TIT()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nAux1, _aItens
Local _aAreaE2, _aAreaX3

// Armazena as condicoes dos alias antes do processamento.
_aAreaE2 := SE2->(GetArea())
_aAreaX3 := SX3->(GetArea())

// Acerta os indices das tabelas.
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
SX3->(dbSetOrder(1))  // X3_CAMPO.

// Monta a matriz aHeader.
_aItens := {"E2_NUM", "E2_PREFIXO", "E2_PARCELA", "E2_VENCTO", "E2_VALOR"}
aHeader := {}
SX3->(dbSetOrder(2))  // X3_CAMPO.
For _nAux1 := 1 to len(_aItens)
	SX3->(dbSeek(_aItens[_nAux1]))
	aAdd(aHeader, {SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
	SX3->("U_VerCpoE2('" + X3_CAMPO + "')" + IIf(!empty(X3_VLDUSER), " .and. (" + X3_VLDUSER + ")", "")),;
	SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT})
Next _nAux1

// Monta a matriz aCols.
// Pega os adiantamentos.
_aAux1 := {}
aCols  := {}
For _nAux1 := 1 to len(_aPagAdi)
	// Processa o pedido apenas uma vez e nao a cada item.
	If aScan(_aAux1, _aPagAdi[_nAux1, 1]) == 0
		aAdd(_aAux1, _aPagAdi[_nAux1, 1])
		SE2->(dbSeek(xFilial("SE2") + "PC " + _aPagAdi[_nAux1, 1], .F.))
		Do While SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM) == xFilial("SE2") + "PC " + _aPagAdi[_nAux1, 1]
			C4E11SE2()  // Adiciona o titulo na aCols.
			SE2->(dbSkip())
		EndDo
	Endif
Next _nAux1
// Pega os titulos gerados pela nota fiscal.
_nTotNF := 0
SE2->(dbSeek(xFilial("SE2") + SF1->(F1_SERIE + F1_DOC), .F.))
Do While SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM) == xFilial("SE2") + SF1->(F1_SERIE + F1_DOC)
	C4E11SE2()  // Adiciona o titulo na aCols.
	_nTotNF += SE2->E2_VALOR
	SE2->(dbSkip())
EndDo
n := 1
_cTotNF := Transform(_nTotNF, _cPict)

// Mostra a tela com as parcelas.
_lOpc := .F.
@ 000, 000 to 220, 390 Dialog oDlgPgto title "Duplicatas"
@ 001, 003 to 085, 194 title "Condição de pagamento"
// Multiline
@ 007, 006 to 080, 190 MultiLine;
modify delete Valid C4E11VLI() Object oLbxPgtoN freeze 1
oLbxPgtoN:nMax := len(aCols)
// Totalizador.
@ 095, 005 Say Space(40) Object _oTotal  // Pula linha no 40o. caractere.
// Botoes OK e Cancela.
@ 095, 166 BmpButton Type 1 Action IIf(C4E11VAL(), oDlgPgto:end(), nil)
C4E11TOT()  // Calcula o campo total.
// Calcula a diferenca e subtrai da ultima parcela da nota para bater o total.
_cMsg := "O valor da última parcela foi alterado para que o total do pagamento seja " +;
"igual ao total da nota fiscal." + _EOL +;
"De qualquer maneira você poderá alterar os valores na planilha a seguir." + _EOL +;
"Pressione OK para continuar"
MsgInfo(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
aCols[len(aCols), aScan(aHeader, {|x| AllTrim(x[2]) == "E2_VALOR"})] -= (_nTotal - _nTotNF)
C4E11TOT()  // Atualiza o campo alterado acima.
Activate Dialog oDlgPgto Center

// Restaura as condicoes dos alias.
SE2->(RestArea(_aAreaE2))
SX3->(RestArea(_aAreaX3))
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C4E11TIT   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Adiciona uma linha na aCols			    				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
Static Function C4E11SE2()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nAux1
// Adiciona uma linha em branco na aCols.
aAdd(aCols, Array(len(aHeader) + 1))
// Posiciona no ultimo item (em branco).
n := len(aCols)
// Adiciona os valores da tabela a aCols.
For _nAux1 := 1 to len(aHeader)
	aCols[n, _nAux1] := FieldGet(FieldPos(aHeader[_nAux1, 2]))
Next _nAux1
// Marca o campo DELET como falso.
aCols[n, len(aHeader) + 1] := .F.
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C4E11TIT   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Valida a tela		    			    				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
Static Function C4E11VAL()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nAux1, lRet := .T., _aAreaE2
// Armazena as condicoes do alias.
_aAreaE2 := SE2->(GetArea())
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
// Verifica se o valor digitado confere com o valor da nota.
// O algoritimo abaixo deixa passar se a diferenca for menor que 1 centavo.
If int((_nTotNF - _nTotal) * 100) != 0
	_cMsg := "A somatória dos títulos (" + AllTrim(Transform(_nTotal, _cPict)) + ") não confere " + _EOL +;
	"com o valor da nota (" + AllTrim(Transform(_nTotNF, _cPict)) + ")."
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
	lRet := .F.
Endif

// Verifica os valores digitados.
For _nAux1 := 1 to len(aCols)
	// Consiste somente se a linha nao estiver apagada.
	If !aCols[_nAux1, len(aHeader) + 1] .and.;
		aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "E2_VALOR"})] <= 0
		
		_cMsg := "O título  da linha " + AllTrim(str(_nAux1)) + " não é válido." + _EOL +;
		"Favor conferir os valores."
		MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
		lRet := .F.
	Endif
Next _nAux1
Return (lRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C4E11PRO   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Processa os titulos alterados		    				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C4E11PRO()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaE2, _nPsPref, _nPsNum, _nPsParc, _nPsValor, _nPsVencto, _cTitulo
// Armazena as condicoes do alias.
_aAreaE2 := SE2->(GetArea())
// Acerta o indice da tabela.
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
_nPsPref   := aScan(aHeader, {|x| AllTrim(x[2]) == "E2_PREFIXO"})
_nPsNum    := aScan(aHeader, {|x| AllTrim(x[2]) == "E2_NUM"})
_nPsParc   := aScan(aHeader, {|x| AllTrim(x[2]) == "E2_PARCELA"})
_nPsValor  := aScan(aHeader, {|x| AllTrim(x[2]) == "E2_VALOR"})
_nPsVencto := aScan(aHeader, {|x| AllTrim(x[2]) == "E2_VENCTO"})
// Grava na tabela de contas a pagar as alteracoes feitas pelo usuario.
For _nAux1 := 1 to len(aCols)
	_cTitulo := aCols[_nAux1, _nPsPref] + aCols[_nAux1, _nPsNum] + aCols[_nAux1, _nPsParc]
	If SE2->(dbSeek(xFilial("SE2") + _cTitulo, .F.))
		RecLock("SE2", .F.)
		// Se a linha estiver apagada.
		If aCols[_nAux1, len(aHeader) + 1]
			SE2->(dbDelete())
		Else
			SE2->E2_VALOR   := aCols[_nAux1, _nPsValor]
			SE2->E2_VLCRUZ  := aCols[_nAux1, _nPsValor]
			SE2->E2_SALDO   := aCols[_nAux1, _nPsValor]
			SE2->E2_VENCTO  := aCols[_nAux1, _nPsVencto]
			SE2->E2_VENCREA := DataValida(aCols[_nAux1, _nPsVencto])
		Endif
		SE2->(msUnLock())
	Else
		_cMsg := "O título " + _cTitulo + " não foi encontrado na tabela SE2." + _EOL +;
		"Favor verificar ou informar ao administrador do sistema." + _EOL + _EOL +;
		"O sistema ira abortar para evitar que os títulos sejam gravados com valores errados."
		MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
		/* Forca o erro em tempo de execucao para evitar o termino do processamento */
		/* da nota e executar o RollBack.                                           */
		Abort
	Endif
Next _nAux1
// Retorna as condicoes anteriores do alias.
SE2->(RestArea(_aAreaE2))
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C4E11VLI   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Valida a linha						    				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C4E11VLI()
	C4E11TOT()
Return(.T.)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C4E11TOT   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Atualiza o total do dialogo de condicoes de pagamento	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C4E11TOT()
Local _nAux1, _nPsValor, _nValor
_nTotal := 0
_nPsValor := aScan(aHeader, {|x| AllTrim(x[2]) == "E2_VALOR"})
For _nAux1 := 1 to len(aCols)
	// Se a linha nao estiver apagada.
	If !aCols[_nAux1, len(aHeader) + 1]
		_nTotal += IIf(_nAux1 == n .and. Type("M->E2_VALOR") == "N", M->E2_VALOR, aCols[_nAux1, _nPsValor])
	Endif
NExt _nAux1
_oTotal:cCaption := "Total: " + Transform(_nTotal, _cPict) + "    de " + _cTotNF
_oTotal:Refresh()
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C4E11CPO   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Valida a digitacao dos campos antes da validacao padrao 	  º±±
±±º          ³ do sistema	  											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
// U_GetCondPag

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida a digitacao dos campos antes da validacao padrao do sistema. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function VerCpoE2(_cCampo)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet, _cMsg := "", _aAreaE2, _cTitulo
_cCampo := AllTrim(_cCampo)
// Armazena as condicoes do alias.
_aAreaE2 := SE2->(GetArea())
_cTitulo := aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "E2_PREFIXO"})]
_cTitulo += aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "E2_NUM"})]
_cTitulo += aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "E2_PARCELA"})]
// Verificar se o titulo nao foi baixado.
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
If SE2->(!dbSeek(xFilial("SE2") + _cTitulo, .F.)) .or. SE2->(E2_SALDO != E2_VALOR)
	_cMsg := "Esse titulo ja foi baixado e nao pode ser alterado!!!"
Else
	Do Case
		Case _cCampo == "E2_VENCTO"
			If M->E2_VENCTO < DataValida(dDataBase)
				_cMsg := "Digite uma data menor que a data base ou que o próximo dia útil!!!"
			Endif
			
		Case _cCampo == "E2_VALOR"
			If M->E2_VALOR > 0
				C4E11TOT()
			Else
				_cMsg := "Digite um valor maior que zero!!!"
			Endif
		OtherWise
			_cMsg := "Esse campo não pode ser modificado!!!"
	EndCase
Endif
// Verifica se houve erro no processamento.
If !(_lRet := empty(_cMsg))
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
Endif
// Retorna as condicoes anteriores do alias.
SE2->(RestArea(_aAreaE2))
Return(_lRet)