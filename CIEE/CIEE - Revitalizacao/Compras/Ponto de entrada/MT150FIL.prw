#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT150FIL
Ponto de entrada de filtro das cota��es na tela gera atualiza cota��o
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT150FIL()
local cFilAux:= ""
	
	cFilAux:= U_CCOME13()

Return(cFilAux)

