#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F040FCR()

Ponto de entrada que permitie a manipulação de dados gravados após a inclusão 
de um título a receber, inclusive se este título for um abatimento.

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
	// Limpar o flag de contabilização dos títulos de alugueis 
	//-----------------------------------------------------------------------
	
	U_ASFINA74()
		
RETURN