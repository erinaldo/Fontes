#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100LOK  � Autor � Felipe Raposo      � Data �  09/08/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para a validacao da linha na digitacao do ���
���          � documento de entrada (MATA103).                            ���
���          � Utilizado para nao permitir que o usuario entre com um     ���
���          � produto sem centro de custo, a nao ser que seja um produto ���
���          � de estoque.                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� Um array com um elemento contendo uma variavel logica      ���
���          � verdadeira se passou por todas as validacoes.              ���
���          � Ler o conteudo de paramixb[1] para obter esta variavel     ���
���          � logica no RdMake.                                          ���
�������������������������������������������������������������������������͹��
���Retorno   � Valor do tipo logico para validar (verdadeiro) ou nao      ���
���esperado  � (falso) a linha atual.                                     ���
�������������������������������������������������������������������������͹��
���Obs.      � Nenhuma                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT100LOK()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _lRet, _cMsg
// Executa as validacoes somente se a linha nao estiver apagada.
If !(_lRet := aCols[n, len(aHeader) + 1])
	_lRet := paramixb[1] .and. VldCC()  // Valida o centro de custo x produto.
	//_lRet := paramixb[1] .and. VldTotal() .and. VldCC()  // Valida o centro de custo x produto.
Endif
If ValType(_lRet) != "L"
	_cMsg := "Erro na valida��o MT100LOK()" + CHR(13) + CHR(10) +;
	"Informe um administrador do sistema - " + ValType(_lRet)
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Aten��o"), "INFO")
	_lRet := .F.
Endif
Return (_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldTotal   �Autor � Felipe Raposo      � Data �  08/09/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se os valores digitados na nota conferem com os     ���
���          � dados do pedido de compra.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Obs.      � A desenvolver...                                           ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	_cMsg := "Pedido de compra ou �tem do pedido n�o encontrado!!!"
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldCC      �Autor � Felipe Raposo      � Data �  08/09/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se o produto eh de estoque ou de consumo direto.    ���
���          � Se for consumo direto, o centro de custo deve ser informa- ���
���          � do.                                                        ���
���          � Se for de estoque, o centro de custo nao deve ser infor-   ���
���          � mado.                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldCC()
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
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
		_cMsg:=""//Nao contabiliza, entao nao faz a valida��o.
	EndIF
ElseIf _cTipo == "ME"  // Estoque.
	_cMsg := IIf(!empty(_cCusto),;
	"N�o pode haver centro de custo para materiais que v�o para o almoxarifado.", "")
Endif

// Se houve erro, exibe na tela e retorna false.
If !(_lRet := empty(_cMsg))
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Aten��o"), "ALERT")
Endif

// Restaura a area apos do processamento.
SB1->(RestArea(_aAreaB1))
Return (_lRet)