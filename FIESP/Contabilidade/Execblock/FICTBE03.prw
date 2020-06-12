#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FICTBE03  �Autor  �TOTVS               � Data �  07/19/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Campo WHEN da Conta Conbil para inibir a Alteracao deste   ���
���          � Campo quando o Item possue Amarracao de Conta              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FICTBE03(cCampo)

Local _aArea 	:= GetArea()
Local _lRet		:= .T.

Default cCampo := Nil

_nPosITEM := GDFieldPos(cCampo)

SZC->(DbSetOrder(1))
If SZC->(DbSeek(xFilial("SZC")+aCols[n,_nPosITEM]))
	_lRet := .F.
EndIf

RestArea(_aArea)

Return(_lRet)