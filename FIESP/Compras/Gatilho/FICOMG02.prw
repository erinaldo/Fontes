
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FICOMG02  �Autor  �Microsiga           � Data �  09/18/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para Gravar Percentual do Rateio na tela de DE     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FICOMG02()

_nPosTot	:= aScan(aOrigHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"} )
_nValTot 	:= aOrigAcols[nOrigN,_nPosTot]

_nValor := round(((M->DE_XVALOR*100))/_nValTot,2)

Return(_nValor)