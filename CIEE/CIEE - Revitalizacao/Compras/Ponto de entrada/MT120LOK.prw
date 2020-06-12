#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT120LOK
Ponto de entrada para validar o centro de custos, so para que não possuem controle de estoque, ou seja # 0 (Zero) 
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT120LOK() 
Local nPosCC    := aScan(aHeader, {|x| AllTrim(x[2]) == "C7_CC"})
Local nPosProd  := aScan(aHeader, {|x| AllTrim(x[2]) == "C7_PRODUTO"})
Local lRet		:= .T.
Local cMsg  	:= ""

If Empty(aCols[n, nPosCC]) .AND. SUBS(aCols[n, nPosProd],4,1) <> "0"
	cMsg := "Informe o Centro de Custo!!!"
EndIf

If !(lRet := empty(cMsg))
	MsgBox(OemToAnsi(cMsg), OemToAnsi("Erro na linha " + AllTrim(str(n))))
Endif

Return(lRet)