#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} AVALCOT
Ponto de entrada executado ap�s a gravacao das cotacoes vencedoras (MATA160)
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function AVALCOT()
    
	// Incrementa campo de cota��o vencedora no cadastro de fornecedores
	U_CCOME06()

Return