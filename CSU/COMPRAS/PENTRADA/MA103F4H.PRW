#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA103F4H�Autor � Renato Carlos          � Data � 11/05/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para inclusao de colunas na selecao       ���
���		     � de pedidos no documento de entrada                         ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA103F4H


Local _aTitulo  := {}
Local aArea	:=  SC7->(GetArea())     
Local nX:=0   
local cVar:="NF GoPoints"
SC7->(dbsetorder(1))        

IF EMPTY(SC7->C7_XCONTRA)
	For nX := 1 to Len(aF4For)
		If Len(aF4For[nX]) >= 9   // OS 0700/14 By Douglas David
			aadd(_aTitulo,cVar)
			Exit
		EndIf 			
	Next
ENDIF          
RestArea(aArea)
Return(_aTitulo)