
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA60CAN2  �Autor  �Microsiga           � Data �  12/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Contas a Receber                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//ExecBlock("FA60CAN2",.F.,.F.)

User Function FA60CAN2()

_xArea		:= GetArea()

RecLock("SE1",.F.)
SE1->E1_IDCNAB := ""
MsUnLock()

RestArea(_xArea)

Return()