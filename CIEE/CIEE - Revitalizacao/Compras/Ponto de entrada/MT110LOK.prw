#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT110LOK
Ponto de entrada executado ao confirmar a inclusao da solicitacao de compra.
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT110LOK()
Local aAreaSB1 	:= SB1->(GetArea())
Local nPsProd 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C1_PRODUTO"}) 
Local nPsCC   	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C1_CC"}) 
Local lRet 		:= .T.
Local cMsg     	:= "" 
Local nAux1    	:= 0
Local cProd    	:= ""
Local cCCusco  	:= ""


if nPsProd > 0 .and. nPsCC > 0 
	cProd   := aCols[n, nPsProd]
	cCCusco := aCols[n, nPsCC] 
	
	dbselectarea("SB1")
	SB1->(dbsetorder(1)) 	
	// Verifica a linha. Se o produto for material de consumo
	// e nao tiver centro de custo digitado, nao confirma.
	If  !(lRet := !(SB1->(dbSeek(xFilial("SB1") + cProd, .F.)) .and.;
		SB1->B1_TIPO == "MC" .and. empty(cCCusco)))
		cMsg := "Digite um centro de custo para o produto " + AllTrim(SB1->B1_DESC)
		MsgAlert(cMsg, OemToAnsi("Atenção"))
	Endif
	
endif  

RestArea(aAreaSB1)
Return(lRet)