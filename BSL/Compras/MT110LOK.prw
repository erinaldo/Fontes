#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110LOK  ºAutor  ³ Fabiano Albuquerqueº Data ³  Jul/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar na linha os campo obrigatórioº±±
±±º          ³ no cadastro de Produto.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110LOK()

LOCAL aAreaAnt   := GETAREA()
Local lRet       := .F.
Local cCodPrd    := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})]
Local aCampObr   := Strtokarr(GetMV("ES_CAMPOBR"), ",")
Local cAux       := ""
Local cCampo     := ""
Local _nAux      := 1

IF cCodPrd == "" .And. Len(aCampObr) >= 1
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + cCodPrd))
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	
	For _nAux:=1 To Len(aCampObr)
		cAux:='SB1->' + aCampObr[_nAux]
		
		IF Empty(&cAux)
			SX3->(DbSeek(aCampObr[_nAux]))
			cCampo += X3Titulo(aCampObr[_nAux]) + ", "
		EndIF
	Next
	
	IF !Empty (cCampo)
		ALERT("Os seguintes campos não foram preenchido no cadastro de produto: " + SubStr(cCampo,1,Len(cCampo)-5) +".")
	Else
		lRet := .T.
	EndIF
	
Else
	lRet := .T.
EndIF

RESTAREA(aAreaAnt)

Return lRet