#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �MT103IPC  � Autor � TOTVS              � Data �  20/01/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada do programa MATA103.                      ���
���          � Utilizacao: na nota de entrada, no momento de importacao   ���
���          � dos itens do pedido de compras (SC7).                      ���
���          � Faz o tratamento dos campos especificos                    ���
�������������������������������������������������������������������������͹��
���Uso       � BSL                                                        ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT103IPC

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nPsDescr, _nPsProduto, _cProduto, _cDescr, _nAux1

//���������������������������������������������������������������������Ŀ
//� Atualiza o campo de descricao do produto (especifico).              �
//�����������������������������������������������������������������������
_nPsProduto 	:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_COD"})
_nPsDescr 		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDESC"})

If _nPsProduto > 0 .and. _nPsDescr  > 0 // Processa todos os itens da aCols.
	For _nAux1 := 1 to len(aCols)
		_cProduto 	:= aCols[_nAux1, _nPsProduto]
		_cDescr 	:= Posicione("SB1",1,xFilial("SB1") + _cProduto,"B1_DESC")
		aCols[_nAux1, _nPsDescr] := _cDescr
	Next _nAux1
Endif

Return(nil)