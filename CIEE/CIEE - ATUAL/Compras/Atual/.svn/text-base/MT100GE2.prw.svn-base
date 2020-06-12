#INCLUDE "rwmake.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2  º Autor ³ Felipe Raposo      º Data ³  21/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada executado apos inclusao no SE2 (titulos a º±±
±±º          ³ pagar).                                                    º±±
±±º          ³ Sera executado uma vez para cada parcela.                  º±±
±±º          ³ Programa: MATA130                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nenhum.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nenhum.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ Nao eh necessario o controle de transacao (Begin/End       º±±
±±º          ³ Transaction) pois o programa principal (MATA103) ja faz o  º±±
±±º          ³ controle.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT100GE2()
//MT100GE2a()  // Dispara o gatilho do campo E2_FORNECE.
MT100GE2b()  // Trabalha os titulos a pagar gerado pela emissao da NFE.
MT100GE2c()  // Se houve adiantamento, ajusta o valor das parcelas.
MT100GE2d()  // Pergunta a forma de pagamento para o comprador.
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2a ºAutor  ³ Felipe Raposo      º Data ³  11/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dispara os gatilhos do campo E2_FORNECE no momento da ge-  º±±
±±º          ³ racao do titulo a pagar.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MT100GE2a()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cAlias  := Alias()
Local _aAreaX7 := SX7->(GetArea())
Local _cCampo := "E2_FORNECE" // Campo que ira disparar os gatilhos.
Private _cCond

// Procura na tabela SX7 (gatilhos), por gatilhos referentes
// ao campo da variavel _cCampo e os executa.
SX7->(dbSetOrder(1))
// Posiciona no primeiro registro com esse criterio.
SX7->(dbGoTop()); SX7->(dbSeek(_cCampo, .T.))
Do While SX7->X7_CAMPO == _cCampo
	_lCond := SX7->X7_CONDIC
	If (empty(_lCond) .or. &(_lCond)) .and. SX7->X7_TIPO == "P"  // Tipo -> P - Primario
		If SX7->X7_SEEK == "S"
			dbSelectArea(SX7->X7_ALIAS)
			dbSetOrder(SX7->X7_ORDEM)
			dbSeek(SX7->X7_CHAVE, .F.)
		Endif
		RecLock("SE2", .F.)
		FieldPut(FieldPos(SX7->X7_CDOMIN), &(SX7->X7_REGRA))
		SE2->(msUnLock())
	Endif
	SX7->(dbSkip())
EndDo

// Restaura as condicoes anteriores do ambiente.
SX7->(RestArea(_aAreaX7))
dbSelectArea(_cAlias)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2b ºAutor  ³ Felipe Raposo      º Data ³  11/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria os titulos a pagar que foram informados no momento da º±±
±±º          ³ cotacao de compra, caso a nota tenha sido entrada baixando º±±
±±º          ³ um pedido de compra e a condicao de pagamento seja "999".  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ Nao pode haver diferenca entre a quant. negociada e a en-  º±±
±±º          ³ tregue.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MT100GE2b()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aCondPag, _nAux1, _nAux2, _cCotAux
Local _aAreaC8, _aAreaD1, _aAreaE2, _aAreaZ3, _cAlsAnt

// Condicao especifica CIEE.
// Crias os titulos a pagar de acordo com os valores informados na cotacao.
If SF1->F1_COND == "999"
	
	// Armazena as condicoes dos alias antes do processamento.
	_aAreaC8 := SC8->(GetArea())
	_aAreaD1 := SD1->(GetArea())
	_aAreaE2 := SE2->(GetArea())
	_aAreaZ3 := SZ3->(GetArea())
	_cAlsAnt := Alias()
	
	// Apaga o titulo que eh gerado por padrao (Cond. Pagto 999).
	RecLock("SE2", .F.)
	SE2->(dbDelete())
	SE2->(msUnLock())
	
	// Cria os titulos especificos.
	SC8->(dbSetOrder(6))  // C8_FILIAL+C8_NUMPED+C8_ITEMPED+C8_COTSTS.
	SD1->(dbSetOrder(1))  // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM.
	SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
	
	// Processa todos os itens da nota.
	SD1->(dbGoTop())
	SD1->(dbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA), .F.))
	Do While SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
		// Fazer se a nota foi entrada a partir de um pedido de compra.
		If !empty(SD1->(D1_PEDIDO + D1_ITEMPC)) .and.;
			SC8->(dbSeek(xFilial("SC8") + SD1->(D1_PEDIDO + D1_ITEMPC + "1"), .F.))
			
			_aCondPag := U_GetCondPag(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 2)  // CCOMA02.PRW
			_nAux2    := len(_aCondPag)
			_nTotItem := SD1->(D1_TOTAL - D1_VALDESC + D1_DESPESA + D1_VALIPI + D1_ICMSRET)
			// Processa todas as parcelas informadas no cotacao para esse item.
			For _nAux1 := 1 to _nAux2
				_cCotAux := _aCondPag[_nAux1]
				SZ3->(dbSeek(xFilial("SZ3") + _cCotAux, .F.))
				_nTotItem -= SZ3->Z3_VALOR
				If SZ3->Z3_TIPO == "N"  // Pagto. a partir da entrada da NF.
					// Inclui a diferenca do valor da nota fiscal com o valor cotado
					// na ultima parcela.
					_nValor := SZ3->Z3_VALOR + IIf(_nAux1 != _nAux2, 0, _nTotItem)
					If _nValor > 0
						RecLock("SE2", .T.)
						SE2->E2_FILIAL  := xFilial("SE2")
						SE2->E2_TIPO    := "NF"
						SE2->E2_NUM     := SF1->F1_DOC    // SC8->C8_NUMPED
						SE2->E2_PREFIXO := SF1->F1_SERIE  // "PC"
						SE2->E2_PARCELA := IIf (_nAux2 > 1, char(64 + val(SZ3->Z3_PARCELA)), "")
						SE2->E2_FORNECE := SC8->C8_FORNECE
						SE2->E2_LOJA    := SC8->C8_LOJA
						SE2->E2_NOMFOR  := SA2->A2_NOME
						SE2->E2_EMISSAO := dDataBase
						SE2->E2_VENCTO  := (SZ3->Z3_DIAS + dDataBase)
						SE2->E2_VENCREA := DataValida(SZ3->Z3_DIAS + dDataBase)
						SE2->E2_VALOR   := _nValor
						SE2->E2_EMIS1   := dDataBase
						SE2->E2_SALDO   := _nValor
						SE2->E2_VENCORI := DataValida(SZ3->Z3_DATA + dDataBase)
						SE2->E2_MOEDA   := 1
						SE2->E2_RATEIO  := "N"
						SE2->E2_VLCRUZ  := _nValor
						SE2->E2_FLUXO   := "S"
						SE2->E2_ORIGEM  := "FINA050"  // "MT100GE2"
						SE2->E2_DESDOBR := "N"
//						SE2->E2_MULTNAT := "2"
						SE2->E2_MULNATU := "2"						
						SE2->E2_PROJPMS := "2"
						SE2->E2_DIRF    := "2"
						SE2->E2_PEDIDO  := SC8->C8_NUMPED
						SE2->(msUnLock())
					Else
						If SE2->(AllTrim(E2_PREFIXO)+ E2_NUM +	AllTrim(E2_TIPO) +	E2_FORNECE + E2_LOJA) ==;
							SC8->("PC" + C8_NUMPED + "NF"+ C8_FORNECE + C8_LOJA)
							RecLock("SE2", .F.)  // Abre para edicao.
							SE2->E2_VALOR  += _nValor
							SE2->E2_SALDO  += _nValor
							SE2->E2_VLCRUZ += _nValor
							SE2->(msUnLock())
						Else
							_cMsg := "Erro na geração dos títulos a pagar." + _EOL + ;
							"Favor entrar em contato com o administrador do sistema!!!"
							MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
							"Erro forcado: titulo a pagar " + 1  // Forca o erro para o sistema abortar.
						Endif
					Endif
				Endif
			Next _nAux1
		Endif
		SD1->(dbSkip())
	EndDo
	// Restaura as condicoes dos alias.
	SC8->(RestArea(_aAreaC8))
	SD1->(RestArea(_aAreaD1))
	SE2->(RestArea(_aAreaE2))
	SZ3->(RestArea(_aAreaZ3))
	dbSelectArea(_cAlsAnt)
Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2c ºAutor  ³ Felipe Raposo      º Data ³  11/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Se houver adiantamento (pagamento a partir da emissao do   º±±
±±º          ³ pedido de compra), o sistema exibe uma caixa de dialogo    º±±
±±º          ³ com os titulos gerados pela nota e os de adiantamento para º±±
±±º          ³ ajustes.                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MT100GE2c()

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
		_aCondPag := U_GetCondPag(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 2)  // CCOMA02.PRW
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
		ExibeTits()
		_lTudoOk := VldTudo()
	EndDo
	ProcSE2()
Endif

// Restaura as condicoes dos alias.
SC8->(RestArea(_aAreaC8))
SD1->(RestArea(_aAreaD1))
SZ3->(RestArea(_aAreaZ3))
dbSelectArea(_cAlsAnt)

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe tela com os titulos da NF e do pedido.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ExibeTits()

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
			PegaSE2()  // Adiciona o titulo na aCols.
			SE2->(dbSkip())
		EndDo
	Endif
Next _nAux1
// Pega os titulos gerados pela nota fiscal.
_nTotNF := 0
SE2->(dbSeek(xFilial("SE2") + SF1->(F1_SERIE + F1_DOC), .F.))
Do While SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM) == xFilial("SE2") + SF1->(F1_SERIE + F1_DOC)
	PegaSE2()  // Adiciona o titulo na aCols.
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
modify delete Valid VldLinha() Object oLbxPgtoN freeze 1
oLbxPgtoN:nMax := len(aCols)
// Totalizador.
@ 095, 005 Say Space(40) Object _oTotal  // Pula linha no 40o. caractere.
// Botoes OK e Cancela.
@ 095, 166 BmpButton Type 1 Action IIf(VldTudo(), oDlgPgto:end(), nil)
AtuTotal()  // Calcula o campo total.
// Calcula a diferenca e subtrai da ultima parcela da nota para bater o total.
_cMsg := "O valor da última parcela foi alterado para que o total do pagamento seja " +;
"igual ao total da nota fiscal." + _EOL +;
"De qualquer maneira você poderá alterar os valores na planilha a seguir." + _EOL +;
"Pressione OK para continuar"
MsgInfo(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
aCols[len(aCols), aScan(aHeader, {|x| AllTrim(x[2]) == "E2_VALOR"})] -= (_nTotal - _nTotNF)
AtuTotal()  // Atualiza o campo alterado acima.
Activate Dialog oDlgPgto Center

// Restaura as condicoes dos alias.
SE2->(RestArea(_aAreaE2))
SX3->(RestArea(_aAreaX3))
Return




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona uma linha na aCols.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function PegaSE2()
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





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida a tela.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function VldTudo()
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




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa os titulos alterados.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ProcSE2()
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



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida a linha.                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function VldLinha()
AtuTotal()
Return(.T.)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o total do dialogo de condicoes de pagamento.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AtuTotal()
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
				AtuTotal()
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2d ºAutor  ³ Felipe Raposo      º Data ³  09/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia a forma de pagamento do fornecedor para os titulos   º±±
±±º          ³ a pagar gerados pela emissao da nota fiscal de entrada, e  º±±
±±º          ³ abre uma tela para o usuario digitar a forma correta ou    º±±
±±º          ³ confirmar a sugerida.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MT100GE2d()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaE2, _nAux1
Local _aTits := {}

Local _cForPgto := IIf(SF1->F1_TIPO $ "DB",;
CriaVar("E2_FORPGTO"),;
U_GetCpoVal("A2_FORPGTO", 1, xFilial("SA2") + SF1->(F1_FORNECE + F1_LOJA), .F.))
Local _aRet   := {}
Local _cF3    := ""
Local _aDados := {{1, "Forma de pagamento", _cForPgto, "", "AllwaysTrue()", _cF3, "", 90, .F.}}

// Pega os titulos gerados pela nota fiscal.
SE2->(dbSeek(xFilial("SE2") + SF1->(F1_SERIE + F1_DOC), .F.))
Do While SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM) == xFilial("SE2") + SF1->(F1_SERIE + F1_DOC)
	aAdd(_aTits, SE2->(RecNo()))
	SE2->(dbSkip())  // Proximo registro.
EndDo

// Exibe a tela de entrada de dados para o usuario,
// caso haja algum titulo a ser alterado.
If !empty(_aTits) .and. ParamBox(_aDados, "Entre com o a forma de pagamento", @_aRet)  // Se o usuario confirmou.
	_cForPgto := _aRet[1]  // Pega o que o usuario digitou, se ele confirmar.
Endif

// Altera os titulos, de acordo com a digitacao do usuario.
For _nAux1 := 1 to len(_aTits)
	SE2->(dbGoTo(_aTits[_nAux1]))  // Proximo registro.
	RecLock("SE2", .F.)  // Abre o registro para edicao.
	SE2->E2_FORPGTO := _cForPgto  // Atualiza o campo.
	SE2->(msUnLock())  // Salva o registro e libera para uso.
Next _nAux1

// Armazena as condicoes dos alias antes do processamento.
_aAreaE2 := SE2->(GetArea())

// Acerta os indices das tabelas.
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.


// Restaura as condicoes dos alias.
SE2->(RestArea(_aAreaE2))

Return