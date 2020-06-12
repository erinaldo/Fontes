#INCLUDE "rwmake.ch"
#DEFINE _PL CHR(13) + CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA120E   ºAutor  ³Felipe Raposo       º Data ³  11/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada.          Programa: MATA120/MATA121        º±±
±±º          ³DESCRICAO...: Executado antes da exclusao do Pedido de      º±±
±±º          ³Compra.                                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verifica se nao houve titulos baixados para esse pedido.   º±±
±±º          ³ Caso positivo, bloqueia a exclusao retornando .F.          º±±
±±º          ³ Caso negativo, exclui os titulos referentes ao pedido e    º±±
±±º          ³ permite a exclusao do pedido retornando .T.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nenhum                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .F. ou .T. (permite ou nao, respectivamente).              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ Nenhuma.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE - Programa MATA120                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA120E

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet := .T., _aAreaC7, _aAreaE2, _aE2Del, _cMsg, _cNumPed

// Armazena as condicoes da tabela antes de processa-la.
_aAreaC7 := SC7->(GetArea())  // Pedido de compra.
_aAreaE2 := SE2->(GetArea())  // Titulos a pagar.

SC7->(dbSetOrder(1))  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN.
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.

// Processa todos os itens do pedido.
_cNumPed := cA120Num // SC7->(C7_FILIAL + C7_NUM)
SC7->(dbGoTop()); SC7->(dbSeek(xFilial("SC7") + _cNumPed , .F.))
Do While xFilial("SC7") + _cNumPed == SC7->(C7_FILIAL + C7_NUM)
	// Processa todas as parcelas do item do pedido.
	_aE2Del := {}
	SE2->(dbGoTop()); SE2->(dbSeek(xFilial("SE2") + "PC " + SC7->C7_NUM, .F.))
	Do While SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM) == xFilial("SE2") + "PC " + SC7->C7_NUM
		If .T. // SE2->E2_ORIGEM == "MT100GE2"
			If SE2->E2_SALDO == SE2->E2_VALOR // .and. SE2->E2_ORIGEM == "MT100GE2"
				aAdd(_aE2Del, SE2->(RecNo()))
				SE2->(dbSkip())
			Else
				_aE2Del := {}
				_lRet := .F.  // Nao permite a exclusao.
				_cMsg := "Esse pedido possui títulos baixados."
				MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
				Return(.F.)
			Endif
		Endif
		SE2->(dbSkip())
	EndDo
	SC7->(dbSkip())
EndDo

// Apaga os titulos caso a variaval _lApaga passada
// por parametro seja .T.
ExcTit(_aE2Del)

// Restaura a area apos do processamento.
SC7->(RestArea(_aAreaC7))
SE2->(RestArea(_aAreaE2))
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ExcTit    ºAutor  ³Felipe Raposo       º Data ³  11/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui os titulos passados por parametro.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExcTit(_aE2Del)
Local _aAreaE2, _nAux1, _cMsg

// Armazena as condicoes da tabela antes de processa-la.
_aAreaE2 := SE2->(GetArea())  // Tits. a pagar.

// Excluir os titulos a pagar, caso nenhum tenha sido baixado.
For _nAux1 := 1 to len(_aE2Del)
	SE2->(dbGoTo(_aE2Del[_nAux1]))
	If SE2->(RecNo()) == _aE2Del[_nAux1]
		RecLock("SE2", .F.)
		SE2->(dbDelete())
		SE2->(msUnLock())
	Else
		_cMsg := "Erro de processamento na exclusão dos títulos a pagar." + _PL +;
		"Favor verificar os títulos referentes a essa nota/esse pedido." + _PL + _PL +;
		"Entre em contato com o administrador do sistema."
		MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
	Endif
Next _nAux1

// Retorna as condicoes originais da tabela.
SE2->(RestArea(_aAreaE2))
Return