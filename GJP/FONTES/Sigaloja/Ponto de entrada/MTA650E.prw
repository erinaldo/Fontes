#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA650E
Ponto de entrada antes da exclus�o da ordem de produ��o
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MTA650E()
LOCAL lRet	:= .T.

IF !EMPTY(M->C2_XNFCE) .and. !ISINCALLSTACK("U_GJ12E01GOP")
	MSGALERT("N�o � permitida a exclus�o de Ordem de produ��o gerada via integra��o LJGrvBatch.")
	lRet	:= .F. 
ENDIF

Return lRet