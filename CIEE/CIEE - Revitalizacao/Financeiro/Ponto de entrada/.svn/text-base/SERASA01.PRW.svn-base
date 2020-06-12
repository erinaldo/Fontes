#INCLUDE "TOTVS.CH"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} SERASA01
Ponto de entrada para filtro de titulos enviados ao SERASA
@author     Totvs
@since     	01/08/2014
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
USER FUNCTION SERASA01() 
LOCAL lRet		:= .F.
local cTabSE1	:= PARAMIXB[1]

IF (cTabSE1)->E1_XFLGSER == "S"
	lRet:= .T.
ENDIF

RETURN lRet