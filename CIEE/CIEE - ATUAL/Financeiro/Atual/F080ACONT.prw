
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F080ACONT �Autor  �Emerson Natali      � Data �  24/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Baixa Pagar Manual antes da Contabilizacao                 ���
���          � Gravacao da competencia para FLUXO DE CAIXA                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F080ACONT()

RecLock("SE5",.F.)
SE5->E5_XCOMPET := SE2->E2_XCOMPET
MsUnLock()

Return