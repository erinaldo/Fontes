#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICTBE02  ºAutor  ³TOTVS               º Data ³  07/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para preenchimento automatico da Conta e Centro de º±±
±±º          ³ Custo em qualquer rotina                                   º±±
±±           Ø                                                            ¹±±
±±           Ø nTipo   1-Contabil;2-Centro de Custo;3-Classe de Valor     ¹±±
±±           Ø cCampo  Campo da Tabela para pegar o Item Ctb digitado     ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICTBE02(nTipo,cCampo, cDesc)

Local _aArea 		:= GetArea()
Local _cConteudo 	:= ""

Default nTipo  := Nil
Default cCampo := Nil

If nTipo == 1 //Conta Contabil
	SZC->(DbSetOrder(1))
	If SZC->(DbSeek(xFilial("SZC")+cCampo))
		_cConteudo := SZC->ZC_CONTA
	Else
		_cConteudo := GDFieldGet(cDesc,n,,aHeader,aCols)
	EndIf
ElseIf nTipo == 2 //Centro de Custo
	SZC->(DbSetOrder(1))
	If SZC->(DbSeek(xFilial("SZC")+cCampo))
		_cConteudo := SZC->ZC_CCUSTO
	Else
		_cConteudo := GDFieldGet(cDesc,n,,aHeader,aCols)
	EndIf
ElseIf nTipo == 3 //Classe de Valor
	SZC->(DbSetOrder(1))
	If SZC->(DbSeek(xFilial("SZC")+cCampo))
		_cConteudo := SZC->ZC_CLVALOR
	Else
		_cConteudo := GDFieldGet(cDesc,n,,aHeader,aCols)
	EndIf
EndIf

RestArea(_aArea)

Return(_cConteudo)