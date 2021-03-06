#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNT100IN  �Autor  �Odinei Raimundo     � Data �   15/12/07  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gravar os grupos que terao acesso    ���
���          � a visualizacao do contrato.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/   

User Function CNT100IN()  

Local aArea  := GetArea()

//��������������������������������������������������������������������Ŀ
//� Gera permiss�o de visualizacao para o grupo que esta cadastrado    �
//� no parametro - ES_GRPVISU                                          �
//����������������������������������������������������������������������
dbSelectArea("CNN")
RecLock("CNN",.T.)
CNN->CNN_FILIAL := xFilial("CNN")
CNN->CNN_CONTRA := M->CN9_NUMERO
CNN->CNN_TRACOD := "037"
CNN->CNN_GRPCOD := Alltrim(GETMV("ES_GRPVISU"))
MsUnlock()

RestArea(aArea)

Return

