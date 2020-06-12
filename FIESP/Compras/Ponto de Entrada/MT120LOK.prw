#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120LOK  บAutor  ณTOTVS               บ Data ณ  08/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do Pedido de Compras para obrigar os campos      บฑฑ
ฑฑบ          ณ Contabeis quando nao tem rateio                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ ฑฑ
ฑฑLigia      ณ Se for indicado item contแbil de rateio exigir que o rateio ฑฑ
ฑฑ26/12/2013 ณ seja indicado                                               ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function  MT120LOK()

Local _lRet := .T.
Local _nPosItem
Local _nPosConta
Local _nPosCC
Local _nPosRat
Local _cItem
Local _cConta
Local _cCC
Local _cRateio

If FunName() <> 'CNTA120'
	
	_nPosItem 	:= GDFieldPos("C7_ITEMCTA")
	_nPosConta 	:= GDFieldPos("C7_CONTA")
	_nPosCC 	:= GDFieldPos("C7_CC")
	_nPosRat	:= GDFieldPos("C7_RATEIO")
	_cItem	    := GDFieldGet("C7_ITEMCTA",n,,aHeader,aCols)
	_cConta 	:= GDFieldGet("C7_CONTA",n,,aHeader,aCols)
	_cCC    	:= GDFieldGet("C7_CC",n,,aHeader,aCols)
	_cRateio	:= GDFieldGet("C7_RATEIO",n,,aHeader,aCols)
	
	
	If _cRateio == "2" //Nใo tem Rateio
		If Empty(_cItem) .or. Empty(_cConta) .or. Empty(_cCC)
			msgbox("Preecher os campos Item Contabil, Conta Contabil e/ou Centro de Custo!!!")
			_lRet := .F.
		EndIf
	EndIf
	
	dbSelectArea('CTD')
	dbSetOrder(1)
	If MsSeek(xFilial('CTD')+aCols[n][_nPosItem])
		If CTD->CTD_XRATEI == "S"
			If aCols[n][_nPosRat]== "2"
				alert("Item contแbil indicado exige rateio. Utilizar a rotina 'Rateio' no botใo 'A็๕es Relacionadas' para fazer o apontamento de rateio referente a esse pedido!")
				_lRet := .F.
			Endif
		EndIf
	EndIf
EndIf

Return(_lRet)
