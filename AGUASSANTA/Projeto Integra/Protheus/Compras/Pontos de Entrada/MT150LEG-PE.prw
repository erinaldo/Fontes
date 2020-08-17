#INCLUDE 'Rwmake.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT150LEG()

Adi��o de novas legendas na atualiza��o da Cota��o

DESCRI��O: O ponto de entrada MT150LEG, permite a adi��o de novas 
           legendas no programa de Atualiza��o da Cota��o.

@param		nOp = {1 ou 2} (1 = Condi��o e Cor da Legenda a ser adcionada 
                            e visualizada na mBrowse.
                            2 = Cor e T�tulo a ser visualizada no 
                            bot�o Legenda).
@return		aRet - Legendas adicionadas ou cor e titulos a ser visualizada
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function MT150LEG

	Local _aRet := {}     
	Local _nOpc := ParamIXB[1]
		
	//-----------------------------------------------------------------------
	// Adiciona cor no browse da rotina "Atualiza cotacao" de acordo com 
	// o campo C8_XWF
	//-----------------------------------------------------------------------
	U_ASCOMA30(_nOpc, _aRet)	


Return _aRet