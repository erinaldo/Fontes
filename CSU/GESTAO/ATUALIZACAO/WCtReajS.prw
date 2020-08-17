/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �WCtReajS    �Autor  �Aline Catarina      � Data �  09/04/07   ���
���������������������������������������������������������������������������͹��
���Desc.     �Retorna se o valor de reajuste sofrido do contrato podera     ���
���          �ser editado ou nao                                            ���
���������������������������������������������������������������������������͹��
���Uso       �Manutencao no Gestao de Contratos                             ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/            
User Function WCtReajS()
	Local lRet := .F.
	Local aArea := GetArea()

	If M->CN9_DTINIC < dDataBase
		DbSelectArea("CN1")
		DbSetOrder(1)       
		If DbSeek(xFilial("CN1")+M->CN9_TPCTO) .And.;
	   		( (CN1->CN1_MEDEVE == "1") .And. (M->CN9_CTRT == "2") ) //Medicao Eventual e Variavel
			lRet := .T.
		EndIf             
	EndIf
	RestArea(aArea)
Return lRet   