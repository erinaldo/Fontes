#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT110QRY
Ponto de entrada de ambiente Top Connect com objetivo de filtrar as solicitações de compras 
a serem exibidos no Browse da rotina.
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT110QRY() 
local cFilQuery:= ""
	
	cFilQuery:= U_CCOME08()

// Retorna o filtro.
Return(cFilQuery)