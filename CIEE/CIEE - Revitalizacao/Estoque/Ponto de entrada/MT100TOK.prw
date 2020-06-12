#include "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT100TOK
Ponto de Entrada da NF para padronizar o numero com zeros a esquerda (tam 06 caracteres) 
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
User Function MT100TOK() 
Local lRet:= .T.

lRet:= U_CESTE16()

Return (lRet)