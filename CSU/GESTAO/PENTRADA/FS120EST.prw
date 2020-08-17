#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � FS120EST � Autor � Carlos Tagliaferri Jr � Data � 26.06.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de Entrada no final da rotina de estorno de medicao   ���
���          �do contrato para atualizar o saldo estimado do contrato.    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico CSU                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function FS120EST()

Local aArea		:= GetArea()
Local cCont 	:= PARAMIXB[1]	//Contrato
Local cRev 		:= PARAMIXB[2]  //Revisao


dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9") + cCont + cRev)

RecLock("CN9",.F.)
	CN9->CN9_XSDEST += CND->CND_VLTOT
MsUnlock()

RestArea(aArea)

Return
