
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F90SE5GRV �Autor  �Emerson Natali      � Data �  24/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Baixa Pagar Automatica. Informacoes Complementares a Bx.   ���
���          � Gravacao da competencia para FLUXO DE CAIXA                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F90SE5GRV()

RecLock("SE5",.F.)
SE5->E5_XCOMPET := SE2->E2_XCOMPET
MsUnLock()

Return