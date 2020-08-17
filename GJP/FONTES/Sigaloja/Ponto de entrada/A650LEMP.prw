#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} A650LEMP
Ponto de entrada para alterar o conteúdo do Armazém
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function A650LEMP()
LOCAL cRet	:= NIL

IF ISINCALLSTACK("U_GJ12E01GOP")
	cRet:= cLocSec
ENDIF

Return cRet

