
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � U_M410DVCSU  �  Revisor �   Eduardo Dias �Data  �28/08/2014���
�������������������������������������������������������������������������Ĵ��
���Descri��o � No momento em que for realizar uma devolu��o de compra 	  ���
���			 � Fazer com que carregue dados quando informado a NF Origem  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Dicionario de Dados - Valida��o Usu�rio do Campo:C6_NFORI   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M410DVCSU()

Local cCC		:= SD1->D1_CC
Local cUniNego	:= SD1->D1_ITEMCTA
Local cOperacao	:= SD1->D1_CLVL   
Local nPosCCUST	:= AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_CCUSTO'})
Local nPosItemN	:= AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_ITEMD'})
Local nPosClasV	:= AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_CLVLDB'})     
Local nX		:= 0 
               
If Len(aCols) > 0 .And. M->C5_TIPO == "D"
	For nX := 1 To Len(aCols)
		aCols[nX][nPosCCUST]	:= cCC
		aCols[nX][nPosItemN]	:= cUniNego
		aCols[nX][nPosClasV]	:= cOperacao
	Next nX
EndIf
                            
oGetDad:OBrowse:Refresh() // Refresh para mostrar os dados na tela

Return(.T.)