#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} SF1100I
Ponto de entrada apos a gravacao do SF1 no MATA103 (Documento de Entrada)
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Ele atualiza alguns campos da aba Compras e Ultima Compra do cadastro de fornecedores
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function SF1100I()
    
	// Atualiza campos especificos
	U_CESTE02()
	  
Return