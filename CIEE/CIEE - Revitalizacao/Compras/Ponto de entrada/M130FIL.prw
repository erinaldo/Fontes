#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} M130FIL
Ponto de entrada de filtro das solicitações de compra na tela gera cotação
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function M130FIL() 
local cFilt:= ""
	
	cFilt:= U_CCOME11()

// Retorna o filtro.
Return(cFilt)