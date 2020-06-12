#include "rwmake.ch"
#include "protheus.ch"

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北篎uncao    矼T100LOK		 篈utor  矻韌ia Sarnauskas	  � Data � 26/12/13    罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯褪屯屯屯拖屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯凸北
北篋esc.     砎alida玢o dos itens da NF na classifica玢o de Pr� Nota    	   罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯凸北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/

User Function MT100LOK

_lRet	:= .T.

If l103Class //Quando clicar em Classifica玢o da Nota Fiscal
	
	_nPosItem 	:= GDFieldPos("D1_ITEMCTA")
	_nPosRat	:= GDFieldPos("D1_RATEIO")
	
	dbSelectArea('CTD')
	dbSetOrder(1)
	If MsSeek(xFilial('CTD')+aCols[n][_nPosItem])
		If CTD->CTD_XRATEI == "S"
			If aCols[n][_nPosRat]== "2"
				alert("Item cont醔il indicado exige rateio. Utilizar a rotina 'Rateio' no bot鉶 'A珲es Relacionadas' para fazer o apontamento de rateio referente a esse pedido!")
				_lRet := .F.
			Endif
		EndIf
	EndIf	

EndIf

Return(_lRet)
