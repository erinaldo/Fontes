#include "protheus.ch"

User Function GECTB001(_nVar, _cTipo)

Default _nVar  := 0
Default _cTipo := ""

_aArea	:= GetArea()
_nValor := 0
_nValTx := 0
_cConta	:= ""
_cItemC	:= ""

DbSelectArea("SE1")
DbSetOrder(1)	
If DbSeek(xFilial("SE1")+SD2->(D2_SERIE+D2_DOC))
	_cChave := SD2->(D2_SERIE+D2_DOC)
	Do While !EOF() .and. _cChave == SE1->(E1_PREFIXO+E1_NUM)
		If _cTipo $ alltrim(SE1->E1_TIPO) .and. Empty(Alltrim(SE1->E1_LA))
			If _nVar == 1
				_cConta := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CONTA")
			ElseIf _nVar == 2
				_nValor := SE1->E1_VALOR
			ElseIf _nVar == 3
				_nValTx := SE1->E1_VLRREAL-SE1->E1_VLCRUZ
			ElseIf _nVar == 4
				_cItemC := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_XITEMCC")
				RecLock("SE1",.F.)
				SE1->E1_LA := "S"
				MsUnLock()
			EndIf
		EndIf
		SE1->(DbSkip())
	EndDo
EndIf

If _nVar == 1
	RestArea(_aArea)
	Return(_cConta)
ElseIf _nVar == 2
	RestArea(_aArea)
	Return(_nValor)
ElseIf _nVar == 3
	RestArea(_aArea)
	Return(_nValTx)
ElseIf _nVar == 4
	RestArea(_aArea)
	Return(_cItemC)
EndIf

RestArea(_aArea)

Return()