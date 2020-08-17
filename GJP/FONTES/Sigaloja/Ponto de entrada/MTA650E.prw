#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA650E
Ponto de entrada antes da exclusão da ordem de produção
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MTA650E()
LOCAL lRet	:= .T.

IF !EMPTY(M->C2_XNFCE) .and. !ISINCALLSTACK("U_GJ12E01GOP")
	MSGALERT("Não é permitida a exclusão de Ordem de produção gerada via integração LJGrvBatch.")
	lRet	:= .F. 
ENDIF

Return lRet