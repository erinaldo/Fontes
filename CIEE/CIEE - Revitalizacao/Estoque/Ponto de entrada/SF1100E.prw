#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} SF1100E
Ponto de Entrada executado antes de deletar o registro no SF1, na exclusao da Nota de Entrada
@author     Totvs
@since     	01/01/2015
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
User Function SF1100E()
Local _lRet := .T.

_lRet:= U_CESTE14()

Return (_lRet)