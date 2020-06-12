#INCLUDE 'Rwmake.ch'


//-----------------------------------------------------------------------
/*/{Protheus.doc} MT150END()

Complementa a atualização manual das cotações de compra

LOCALIZAÇÃO   : FUNCTION A150Digita - Rotina de atualização manual das 
                cotações de compra

FINALIDADE    : Permite complementar a atualização (inclusão, alteração 
                e exclusão) manual das cotações de compra 

@param		nOp = {2, 3 ou 5} (2-Incluir, 3-alterar, 5-Excluir )
@return		nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

USER FUNCTION MT150END()
	
	LOCAL nOp   	:= PARAMIXB[1]
	LOCAL lRet		:= .T.
	
If ParamIXB[1] == 3 // Atualizacao da cotacao

	//-----------------------------------------------------------------------
	// Atualização do campo C8_XWF
	//-----------------------------------------------------------------------
	U_ASCOMA29()

EndIF

Return lRet