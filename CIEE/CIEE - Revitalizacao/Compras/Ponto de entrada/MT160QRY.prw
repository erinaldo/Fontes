#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT160QRY
Ponto de entrada de filtro das cota��es na tela analise de cota��o  
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT160QRY()
local cFilAux:= ""
	
	cFilAux:= U_CCOME14()

Return(cFilAux)



