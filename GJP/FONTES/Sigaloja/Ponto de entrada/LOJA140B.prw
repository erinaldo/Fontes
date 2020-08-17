#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} LOJA140B
Ponto de entrada após a exclusão da nota fiscal de saida 
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function LOJA140B()

	//Rotina que exclui a ordem de produção
	U_GJLOJE01(5)

Return