#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120FIM  �Autor  �TOTVS               � Data �  07/23/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada no final do Pedido de Compras para envio  ���
���          � do WORKFLOW de Pedido de Compras                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120FIM

Local _aArea	:= GetArea()
Local _lRet		:= .T.
Local _lMedicao := IsInCallStack("CNTA120")
Local _nNumPed	:= ParamIxb[2]

If _lMedicao
	DbSelectArea("SCH")
	DbSetOrder(1)
	If DbSeek(xFilial("SCH")+_nNumPed)
		Do While !EOF() .and. SCH->CH_PEDIDO == _nNumPed
			DbSelectArea("SC7")
			DbSetOrder(1)
			If DbSeek(xFilial("SC7")+_nNumPed)
				Do While !EOF() .and. SC7->C7_NUM == _nNumPed
					If SC7->C7_ITEM == SCH->CH_ITEMPD
						RecLock("SC7",.F.)
						SC7->C7_RATEIO := "1" //SIM
						MsUnLock()
						Exit
					EndIf
					SC7->(DbSkip())
				EndDo
			EndIf
			SCH->(DbSkip())
		EndDo
	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)