#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºFuncao    ³MT100LOK		 ºAutor  ³Lígia Sarnauskas	  º Data ³ 26/12/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação dos itens da NF na classificação de Pré Nota    	   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100LOK

_lRet	:= .T.

If l103Class //Quando clicar em Classificação da Nota Fiscal
	
	_nPosItem 	:= GDFieldPos("D1_ITEMCTA")
	_nPosRat	:= GDFieldPos("D1_RATEIO")
	
	dbSelectArea('CTD')
	dbSetOrder(1)
	If MsSeek(xFilial('CTD')+aCols[n][_nPosItem])
		If CTD->CTD_XRATEI == "S"
			If aCols[n][_nPosRat]== "2"
				alert("Item contábil indicado exige rateio. Utilizar a rotina 'Rateio' no botão 'Ações Relacionadas' para fazer o apontamento de rateio referente a esse pedido!")
				_lRet := .F.
			Endif
		EndIf
	EndIf	

EndIf

Return(_lRet)
