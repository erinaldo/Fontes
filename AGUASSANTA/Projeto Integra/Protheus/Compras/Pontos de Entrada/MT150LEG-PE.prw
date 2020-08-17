#INCLUDE 'Rwmake.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT150LEG()

Adição de novas legendas na atualização da Cotação

DESCRIÇÃO: O ponto de entrada MT150LEG, permite a adição de novas 
           legendas no programa de Atualização da Cotação.

@param		nOp = {1 ou 2} (1 = Condição e Cor da Legenda a ser adcionada 
                            e visualizada na mBrowse.
                            2 = Cor e Título a ser visualizada no 
                            botão Legenda).
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