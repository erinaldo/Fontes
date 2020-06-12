#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetSld    º Autor ³ Felipe Raposo      º Data ³  09/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula a quantidade em pendencia para entrega no almoxa-  º±±
±±º          ³ rifado pelos fornecedores de acordo com os parametros.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _cProduto - O produto que tera o saldo calculado.          º±±
±±º          ³ _lSolicit - Consideda o saldo em solicitacoes de compra.   º±±
±±º          ³ _lPedido  - Consideda o saldo em pedido de compra.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ O saldo calculado.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GetSld(_cProduto, _lSolicit, _lPedido)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaC1, _aAreaC7, _nRet := 0

// Armazena as condicoes das tabelas
// antes do processamento.
_aAreaC1 := SC1->(GetArea())
_aAreaC7 := SC7->(GetArea())

// Acrescenta as solicitacoes de compra ao saldo,
// caso tenha sido solicitado pelo usuario.
If _lSolicit
	SC1->(dbSetOrder(2))  // C1_FILIAL+C1_PRODUTO+C1_NUM+C1_ITEM+C1_FORNECE+C1_LOJA.
	SC1->(dbSeek(xFilial("SC1") + _cProduto, .F.))
	Do While SC1->(C1_FILIAL + C1_PRODUTO) == xFilial("SC1") + _cProduto
		_nRet += SC1->(C1_QUANT - C1_QUJE)
		SC1->(dbSkip())
	EndDo
Endif

// Acrescenta os pedidos de compra ao saldo,
// caso tenha sido solicitado pelo usuario.
If _lPedido
	SC7->(dbSetOrder(2))  // C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM.
	SC7->(dbSeek(xFilial("SC7") + _cProduto, .F.))
	Do While SC7->(C7_FILIAL + C7_PRODUTO) == xFilial("SC7") + _cProduto
		If SC7->C7_RESIDUO != "S"
			_nRet += SC7->(C7_QUANT - C7_QUJE)
		Endif
		SC7->(dbSkip())
	EndDo
Endif

// Restaura as condicoes das tabelas
// anterioes ao processamento.
SC1->(RestArea(_aAreaC1))
SC7->(RestArea(_aAreaC7))
Return (_nRet)