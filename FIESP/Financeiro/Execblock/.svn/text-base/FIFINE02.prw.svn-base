#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINE02  ºAutor  ³Microsiga           º Data ³  07/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para analisar o Item Contabil (PROJETO) e           º±±
±±º          ³ emitir Mensagem de Aviso ao usuario                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINE02(_cCampo)

Local _lRet 	:= .T.
Local _aArea 	:= GetArea()
Local _cxObs	:= Alltrim(_cCampo)
Local _cBuffer	:= _cxObs
Local _nCont	:= 1
Local _cBanco	:= ""
Local _cAgencia	:= ""
Local _cCCorr	:= ""
Local _aArray	:= {}

If !Empty(_cxObs)

	For _nI := 1 to Len(_cBuffer)
		If At(";",_cBuffer) >= 1
			_nCont++
		Else
			Exit
		EndIf
		_cBuffer := Substr(_cBuffer,(At(";",_cBuffer)+1),500)
	Next _nI

	For _nY := 1 to _nCont
		_cITEM := Substr(_cxObs,1,(At(";",_cxObs)-1))
		_cxObs := Substr(_cxObs,(At(";",_cxObs)+1),500)
		iIf(_nY == _nCont,_cITEM:=_cxObs,_cITEM)
		SZC->(DbSetOrder(1))
		If SZC->(DbSeek(xFilial("SZC")+_cITEM))
			Do While !EOF() .and. alltrim(SZC->ZC_ITEM) == alltrim(_cITEM)
				_cBanco		:= alltrim(SZC->ZC_BANCO)
				_cAgencia	:= alltrim(SZC->ZC_AGENCIA)
				_cCCorr		:= alltrim(SZC->ZC_CCORR)
	
				_nPos	:= ascan(_aArray,{|x| x[1] == _cBanco .and. x[2] == _cAgencia .and. x[3] == _cCCorr})
				If _nPos == 0
					AADD(_aArray,{_cBanco, _cAgencia, _cCCorr})
				EndIf
				SZC->(DbSkip())
			EndDo
		EndIf
		
	Next _nY

	
EndIf

If !Empty(_aArray)
	_cMsg := "Este documento possui Itens Contabeis amarrados aos bancos abaixo: "+Chr(13)+Chr(10)
	For _nW := 1 to Len(_aArray)
		_cMsg += _aArray[_nW,1] +" / "+ _aArray[_nW,2] +" / "+ _aArray[_nW,3] + Chr(13)+Chr(10)
	Next _nW
	_cMsg += "O Banco/Agencia/Conta selecionados ("
	_cMsg += cBanco+"/"+cAgencia+"/"+cConta
	_cMsg += ")estao corretos em função do Item Contabil do documento?"
	If MsgYesNo(_cMsg, "Atenção")
		_lRet 	:= .T.
	Else
		_lRet 	:= .F.
	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)