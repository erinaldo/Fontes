#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F040FCR()

Ponto de entrada que permitie a manipula��o de dados gravados ap�s a inclus�o 
de um t�tulo a receber, inclusive se este t�tulo for um abatimento.

Ponto de Entrada no Final da Inclusao do Titulo a Receber

@param		Nenhum 
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		21/02/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F040FCR()

	//-----------------------------------------------------------------------
	// Limpar o flag de contabiliza��o dos t�tulos de alugueis 
	//-----------------------------------------------------------------------
	
	U_ASFINA74()
		
RETURN