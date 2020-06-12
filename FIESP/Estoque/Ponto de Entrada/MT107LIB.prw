#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT107LIB  �Autor  �TOTVS               � Data �  08/16/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para nao deixar fazer a Liberacao da SA   ���
���          � manualmente pela Rotina de Liberacao SA quando a mesma     ���
���          � possui criterio de Al�adas                                 ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT107LIB()

Local _lRet	:= .T.

If !Empty(SCP->CP_XAPROV)
	msgbox(OemToAnsi("Solici��o ao Armazem n�o pode ser Liberada Manualmente pois possue Controle de Al�adas!!!"))
	_lRet	:= .F.
	Return(_lRet)
EndIf

Return(_lRet)