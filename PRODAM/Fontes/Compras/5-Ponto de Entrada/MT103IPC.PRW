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
Local _nAux1, _dDota, _cDescProd

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ�ÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o campo de data de dota��o do Pedido de Compras            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ�ÄÄÄÄÄÄÄÄÄÄÙ

_dDota			:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDTDOT"})
_cDescProd		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDESCCO"})
_cDescCC		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDESCCC"})

//_nxTotal		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XTOTAL"})
//_nvUnit		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_VUNIT"})
//_nTotal		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_TOTAL"})

If _dDota  > 0 
	aCols[paramixb[1], _dDota] := SC7->C7_XDTDOT
Endif
If _cDescProd > 0
	aCols[paramixb[1], _cDescProd] := SC7->C7_XDESCCO
EndIf

If _cDescCC > 0
	aCols[paramixb[1], _cDescCC] := SC7->C7_XDESCCC
EndIf

//If _nxTotal > 0
//	aCols[paramixb[1], _nxTotal] := SC7->C7_XTOTAL
//	aCols[paramixb[1], _nvUnit] := SC7->C7_PRECO
//	aCols[paramixb[1], _nTotal] := SC7->C7_TOTAL
//EndIf

Return(nil)