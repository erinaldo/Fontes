#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MA120BUT
O ponto entrada para adicionar botoes na tela do pedido de pedido de compra 
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MA120BUT()
Local _aRet 	:= {}
Local _cAlias 	:= GetArea("SC7")

aAdd (_aRet, {"ALTERA", {|| U_CCOME12(CA120Num)}, "Notas fiscais"})

IF !INCLUI .AND. !ALTERA .AND. ! "MATA097" $ FUNNAME()
	aadd(_aRet,{"S4WB007N", {|| U_CCOMR01()},OemToAnsi("Impressão AF")})
ENDIF

RestArea(_cAlias)
Return(_aRet)