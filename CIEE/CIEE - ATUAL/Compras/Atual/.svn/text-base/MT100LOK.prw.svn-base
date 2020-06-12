#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  º Autor ³ Felipe Raposo      º Data ³  09/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para a validacao da linha na digitacao do º±±
±±º          ³ documento de entrada (MATA103).                            º±±
±±º          ³ Utilizado para nao permitir que o usuario entre com um     º±±
±±º          ³ produto sem centro de custo, a nao ser que seja um produto º±±
±±º          ³ de estoque.                                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Um array com um elemento contendo uma variavel logica      º±±
±±º          ³ verdadeira se passou por todas as validacoes.              º±±
±±º          ³ Ler o conteudo de paramixb[1] para obter esta variavel     º±±
±±º          ³ logica no RdMake.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Valor do tipo logico para validar (verdadeiro) ou nao      º±±
±±ºesperado  ³ (falso) a linha atual.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ Nenhuma                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT100LOK()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet, _cMsg
// Executa as validacoes somente se a linha nao estiver apagada.
If !(_lRet := aCols[n, len(aHeader) + 1])
	_lRet := paramixb[1] .and. VldCC()  // Valida o centro de custo x produto.
	//_lRet := paramixb[1] .and. VldTotal() .and. VldCC()  // Valida o centro de custo x produto.
Endif
If ValType(_lRet) != "L"
	_cMsg := "Erro na validação MT100LOK()" + CHR(13) + CHR(10) +;
	"Informe um administrador do sistema - " + ValType(_lRet)
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Atenção"), "INFO")
	_lRet := .F.
Endif
Return (_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldTotal   ºAutor ³ Felipe Raposo      º Data ³  08/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se os valores digitados na nota conferem com os     º±±
±±º          ³ dados do pedido de compra.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ A desenvolver...                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldTotal()
Local _lRet
Local _nPsPed, _nPsItemPC, _nPsQuant, _nPsVUnit, _nPsTotal

// Busca a posicao dos campos na aCols pela aHeader.
_nPsPed    := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_PEDIDO"})
_nPsItemPC := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_ITEMPC"})
_nPsQuant  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_QUANT"})
_nPsVUnit  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_VUNIT"})
_nPsTotal  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_TOTAL"})

SC6->(dbSetOrder(1))  // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO.
If !SC6->(dbSeek(xFilial("SC6") + aCols[n, _nPsPed] + aCols[n, _nPsItemPC], .F.))
	_cMsg := "Pedido de compra ou ítem do pedido não encontrado!!!"
//Else
	//If aCols[n, _nPsQuant] !=
	//Endif
	//If aCols[n, _nPsVUnit] !=
	//Endif
	//If aCols[n, _nPsTotal] !=
	//Endif
Endif
If !(_lRet := empty(_cMsg))
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Erro na linha " + AllTrim(str(n))))
Endif
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldCC      ºAutor ³ Felipe Raposo      º Data ³  08/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se o produto eh de estoque ou de consumo direto.    º±±
±±º          ³ Se for consumo direto, o centro de custo deve ser informa- º±±
±±º          ³ do.                                                        º±±
±±º          ³ Se for de estoque, o centro de custo nao deve ser infor-   º±±
±±º          ³ mado.                                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCC()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaB1, _cMsg, _cTipo, _nPsProd, _nPsCCusto
Local _nPosTES:=aScan(aHeader, {|x| AllTrim(x[2]) == "D1_TES"})
// Armazena a area antes do processamento.
_aAreaB1 := SB1->(GetArea())

// Busca no aCols o conteudo dos campos produto e centro de custo.
_nPsProd   := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_COD"})
_nPsCCusto := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_CC"})
_cProd  := aCols[n, _nPsProd]
_cCusto := aCols[n, _nPsCCusto]
_cTES:=aCols[n, _nPosTES]

// Busca o tipo do produto.
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1") + _cProd, .F.))
_cTipo := SB1->B1_TIPO

// Faz as comparacoes conforme solicitacoes do cliente.
_cMsg := ""
If _cTipo == "MC"  // Consumo direto.
	_cMsg := IIf(empty(_cCusto),;
	"O centro de custo deve ser informado para esse tipo de material.", "")
	If (_cTES $ u_LP650TES()) .Or. (Alltrim(cEspecie)=="SPED" .AND. Alltrim(cFormul)=="S")//LP650H.PRW
		_cMsg:=""//Nao contabiliza, entao nao faz a validação.
	EndIF
ElseIf _cTipo == "ME"  // Estoque.
	_cMsg := IIf(!empty(_cCusto),;
	"Não pode haver centro de custo para materiais que vão para o almoxarifado.", "")
Endif

// Se houve erro, exibe na tela e retorna false.
If !(_lRet := empty(_cMsg))
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Atenção"), "ALERT")
Endif

// Restaura a area apos do processamento.
SB1->(RestArea(_aAreaB1))
Return (_lRet)