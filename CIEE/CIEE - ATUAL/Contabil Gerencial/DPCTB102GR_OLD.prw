#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DPCTB102GR�Autor  �Microsiga           � Data �  09/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DPCTB102GR()

_lRet 	:= .T.
_aArea 	:= GetArea()
_nValor := 0

DbSelectArea("CT2")
DbSetOrder(1)
//If DbSeek(xFilial("CT2")+Dtos(dDataLanc)+cLote+cSubLote+cDoc+"001")
If DbSeek(xFilial("CT2")+Dtos(dDataLanc)+cLote+cSubLote+cDoc) //Alterado pelo analista Emerson 07/11. Se a linha 001 e deletada esta trazendo o valor igual a zero.
	_nValor := CT2->CT2_VALOR
EndIf

DbSelectArea("CT6")
DbSetOrder(1)
If DbSeek(xFilial("CT6")+Dtos(dDataLanc)+cLote+cSubLote+"01"+"9")
	RecLock("CT6",.F.)
	CT6->CT6_CREDIT	:= _nValor
	CT6->CT6_DEBITO	:= _nValor
	CT6->CT6_DIG	:= _nValor
	MsUnLock()
EndIf

RestArea(_aArea)

Return