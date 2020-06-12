#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT100GE2
Ponto de entrada executado apos inclusao no SE2 (titulos a pagar).
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
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
User Function MT100GE2()
	
// Trabalha os titulos a pagar gerado pela emissao da NFE.
U_CESTE10()                                              

// Se houve adiantamento, ajusta o valor das parcelas.
U_CESTE11()                                          

// Pergunta a forma de pagamento para o comprador.
U_CESTE12()                                     
	
Return