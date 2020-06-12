#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT120QRY
Ponto de entrada de ambiente Top Connect com objetivo de filtrar os pedidos de compra a 
serem exibidos no Browse da rotina de pedidos de compra 
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT120QRY() 
local cFilQuery:= ""
	
	cFilQuery:= U_CCOME07()

// Retorna o filtro.
Return(cFilQuery)