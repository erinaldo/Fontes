#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DPCTB102GRºAutor  ³Microsiga           º Data ³  09/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DPCTB102GR() //{ nOpc,dDatalanc,cLote,cSubLote,cDoc }

_lRet 	:= .T.
_aArea 	:= GetArea()
_nValor := 0
_cLP	:= ""
_cKey	:= ""
_cOrig	:= ""

DbSelectArea("CT2")
DbSetOrder(1)
//If DbSeek(xFilial("CT2")+Dtos(dDataLanc)+cLote+cSubLote+cDoc+"001")
If DbSeek(xFilial("CT2")+Dtos(dDataLanc)+cLote+cSubLote+cDoc) //Alterado pelo analista Emerson 07/11. Se a linha 001 e deletada esta trazendo o valor igual a zero.
	_cLP	:= CT2->CT2_LP
	_cKey	:= CT2->CT2_KEY
	_cOrig	:= CT2->CT2_ORIGEM
	_nValor := CT2->CT2_VALOR
EndIf
/*
DbSelectArea("CT6")
DbSetOrder(1)
If DbSeek(xFilial("CT6")+Dtos(dDataLanc)+cLote+cSubLote+"01"+"9")
	RecLock("CT6",.F.)
	CT6->CT6_CREDIT	:= _nValor
	CT6->CT6_DEBITO	:= _nValor
	CT6->CT6_DIG	:= _nValor
	MsUnLock()
EndIf
*/
DbSelectArea("CT2")
DbSetOrder(1)
If DbSeek(xFilial("CT2")+Dtos(dDataLanc)+cLote+cSubLote+cDoc)
	Do While Dtos(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC == Dtos(dDataLanc)+cLote+cSubLote+cDoc
		RecLock("CT2",.F.)
		CT2->CT2_LP 	:= _cLP
		CT2->CT2_KEY	:= _cKey
		CT2->CT2_ORIGEM	:= _cOrig
		MsUnLock()
		CT2->(DbSkip())
	EndDo
EndIf

RestArea(_aArea)

Return