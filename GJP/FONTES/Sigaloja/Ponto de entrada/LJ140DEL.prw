#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} LJ140DEL
Ponto de entrada antes da exclusão da nota fiscal de saida 
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function LJ140DEL()

	//Rotina que exclui a ordem de produção
	U_GJLOJE01(5)

Return