
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103LEG  �Autor  �TOTVS               � Data �  08/27/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada pra texto da Legenda na Pre-Nota Compras  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103LEG

Local aLegenda 	:= ParamIxb[1]
Local aNewLeg	:= {}
Local _nI
//acrescentar Legenda para Pre-Nota Bloqueada

//aAdd(aLegenda, {"BR_BRANCO","Pre-Nota Bloqueada"})
aAdd(aNewLeg, {"BR_BRANCO","Pre-Nota Bloqueada"})

For _nI := 1 to Len(aLegenda)
	aAdd(aNewLeg, {aLegenda[_nI,1],aLegenda[_nI,2]})
Next

Return(aNewLeg)