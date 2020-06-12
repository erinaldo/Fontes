#include "rwmake.ch"
#include "protheus.ch"

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
���Funcao    �MT100LOK		 �Autor  �L�gia Sarnauskas	  � Data � 26/12/13    ���
������������������������������������������������������������������������������͹��
���Desc.     �Valida��o dos itens da NF na classifica��o de Pr� Nota    	   ���
������������������������������������������������������������������������������͹��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/

User Function MT100LOK

_lRet	:= .T.

If l103Class //Quando clicar em Classifica��o da Nota Fiscal
	
	_nPosItem 	:= GDFieldPos("D1_ITEMCTA")
	_nPosRat	:= GDFieldPos("D1_RATEIO")
	
	dbSelectArea('CTD')
	dbSetOrder(1)
	If MsSeek(xFilial('CTD')+aCols[n][_nPosItem])
		If CTD->CTD_XRATEI == "S"
			If aCols[n][_nPosRat]== "2"
				alert("Item cont�bil indicado exige rateio. Utilizar a rotina 'Rateio' no bot�o 'A��es Relacionadas' para fazer o apontamento de rateio referente a esse pedido!")
				_lRet := .F.
			Endif
		EndIf
	EndIf	

EndIf

Return(_lRet)
