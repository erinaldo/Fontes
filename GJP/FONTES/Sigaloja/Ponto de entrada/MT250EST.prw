#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT250EST
Ponto de entrada antes do estorno do apontamento de produ��o
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT250EST()
LOCAL lRet	:= .T.

IF !ISINCALLSTACK("U_GJ12E01MOP")
	DBSELECTAREA("SC2")
	SC2->(DbSetOrder(1)) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
	SC2->(DbSeek(xFilial("SC2")+SD3->D3_OP))
	IF !EMPTY(SC2->C2_XNFCE)
		MSGALERT("N�o � permitida o estorno de produ��o gerada via integra��o LJGrvBatch.")
		lRet	:= .F. 
	ENDIF
ENDIF

Return lRet