#Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT140FSV  �Autor  � Douglas Coelho     � Data �  Jul/2017   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para acrescentar campos para filtrar o    ���
���		      � c�digo de servi�o recebido pelo XML na gera��o da NF de    ���
���		      � servi�o.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSU - Totvs Colabora��o                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT140FSV()

Local cCodServ := PARAMIXB[1]
Local cMunServ := PARAMIXB[2] 
Local cCGCTT   := PARAMIXB[3]
Local cCGCTP   := PARAMIXB[4]
Local cFiltro  := ""

cFiltro  := " OR A5_CODISS = '" + cCodServ + "'"

Return cFiltro

