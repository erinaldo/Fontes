#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110LOK  �Autor  � Fabiano Albuquerque� Data �  Jul/2015   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar na linha os campo obrigat�rio���
���          � no cadastro de Produto.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � BSL                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		ALERT("Os seguintes campos n�o foram preenchido no cadastro de produto: " + SubStr(cCampo,1,Len(cCampo)-5) +".")
	Else
		lRet := .T.
	EndIF
	
Else
	lRet := .T.
EndIF

RESTAREA(aAreaAnt)

Return lRet