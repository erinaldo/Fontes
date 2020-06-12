#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT160QRY
Ponto de entrada de filtro das cotações na tela analise de cotação  
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



