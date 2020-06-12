#include "rwmake.ch"
#include "protheus.ch"
#include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120ISC  �Autor  �Emerson Natali      � Data �  15/03/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada no Pedido de Compras <F4> para trazer as  ���
���          � Solicitacoes de Compras em aberto                          ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120ISC()

_lRet		:= .T.

_nPosaCols 		:= ASCAN(ACOLS,{|X| X[2]+X[3]+X[4] == SC1->C1_NUM+ SC1->C1_ITEM+SC1->C1_PRODUTO })
_nPosaHeader 	:= ASCAN(AHEADER,{|X| alltrim(X[2]) == "C7_ESPEC" })

If _nPosaCols > 0
	aCols[_nPosaCols, _nPosaHeader] := SC1->C1_ESPEC
EndIf

Return(_lRet)