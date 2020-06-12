#INCLUDE "rwmake.ch"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE10 
Cria os titulos a pagar que foram informados no momento da cotacao de compra, caso a nota
tenha sido entrada baixando um pedido de compra e a condicao de pagamento seja "999". 
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
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
USER FUNCTION CESTE10()
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