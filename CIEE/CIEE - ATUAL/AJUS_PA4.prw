#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AJUS_PA4  �Autor  �Cristiano Giardini  � Data �  06/05/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Replace no campo PA4_NUMDOC para gravacao dos numeros dos  ���
���          � documentos                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus8                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AJUS_PA4()

DbSelectArea("PA4")
DbSetOrder(4)
DbGotop()

Do While !EOF()
	DbSelectArea("PA1")
	DbSetOrder(1)
	If DbSeek(xFilial("PA1")+PA4->PA4_CODDOC)
		Do Case
			Case PA1->PA1_TPDOC == "01"
				Reclock("PA4",.F.)
				PA4->PA4_NUMDOC := PA1->PA1_CNPJ
				MsUnLock()
			Case PA1->PA1_TPDOC == "02"
				Reclock("PA4",.F.)
				PA4->PA4_NUMDOC := PA1->PA1_ALVA
				MsUnLock()
			Case PA1->PA1_TPDOC == "03"
				Reclock("PA4",.F.)
				PA4->PA4_NUMDOC := PA1->PA1_PROCES
				MsUnLock()
			Case PA1->PA1_TPDOC == "04"
				Reclock("PA4",.F.)
				PA4->PA4_NUMDOC := PA1->PA1_ATEST
				MsUnLock()
			Case PA1->PA1_TPDOC == "05"
				Reclock("PA4",.F.)
				PA4->PA4_NUMDOC := PA1->PA1_UTIL
				MsUnLock()
			Case PA1->PA1_TPDOC == "06"
				Reclock("PA4",.F.)
				PA4->PA4_NUMDOC := PA1->PA1_CMDCA
				MsUnLock()
		EndCase
	EndIf
	DbSelectArea("PA4")
	DbSkip()
EndDo

Return