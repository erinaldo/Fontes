#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun??o    �MT103IPC  � Autor � TOTVS                  � Data � 03/11/15���
�������������������������������������������������������������������������Ĵ��
��� Descricao�      Ponto de entrada do programa MATA103.                 ���
���          �      Utilizacao: na nota de entrada, no momento de import  ���
���          �      dos itens do pedido de compras (SC7).                 ���
���          �      Faz o tratamento dos campos especificos               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PRODAM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT103IPC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ�ÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ�ÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nVunit, _nQuant, _cDescProd

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ�ÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os campos do Pedido de Compras				             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ�ÄÄÄÄÄÄÄÄÄÄÙ

_cDescProd		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDESCRI"})
_nvUnit			:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XVUNIT"})
_nQuant			:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XQUANT"})
_nClasFis		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_CLASFIS"})
_xClassF		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XCLASSF"})
_nTotal			:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_TOTAL"})
_xTotal			:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XTOTAL"})

_cProduto		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_COD"})

If _cDescProd > 0
	aCols[paramixb[1], _cDescProd] := SC7->C7_DESCRI
EndIf

If _nVunit > 0
	aCols[paramixb[1], _nVunit] := SC7->C7_PRECO
EndIf

If _nQuant > 0
	aCols[paramixb[1], _nQuant] := SC7->C7_QUANT
EndIf

If _xClassF > 0
	_cOrigem := ""
	_cOrigem := POSICIONE("SBZ",1,xFilial("SBZ")+ALLTRIM(aCols[paramixb[1], _cProduto]),"BZ_ORIGEM")
	If Empty(_cOrigem)
		_cOrigem := POSICIONE("SB1",1,xFilial("SB1")+ALLTRIM(aCols[paramixb[1], _cProduto]),"B1_ORIGEM")
	EndIf
	
	aCols[paramixb[1], _xClassF] := _cOrigem + alltrim(aCols[paramixb[1], _nClasFis])
EndIf

If _nTotal > 0
	aCols[paramixb[1], _xTotal] := (aCols[paramixb[1], _nTotal])
EndIf

Return(nil)