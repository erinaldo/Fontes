
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP532ORI  �Autor  �Microsiga           � Data �  11/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP532ORI()
Local _aAreaSEA
Local _aArea := GetArea()

If cEmpant == '01' //SP
	DbSelectArea("SEA") 
	_aAreaSEA := GetArea()
	DbSetOrder(2)
	DbSeek(xFilial("SEA")+STRLCTPAD)

	_cRet := "120"+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA+STRLCTPAD+ "LP 532/002"
ElseIf cEmpant == '03' //RJ
	DbSelectArea("SEA")
	_aAreaSEA := GetArea()
	DbSetOrder(2)
	DbSeek(xFilial("SEA")+SE2->E2_NUMBOR)

	_cRet := "120"+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA+SE2->E2_NUMBOR+ "LP 532/002"
EndIf

RestArea(_aAreaSEA)
RestArea(_aArea)

Return(_cRet)