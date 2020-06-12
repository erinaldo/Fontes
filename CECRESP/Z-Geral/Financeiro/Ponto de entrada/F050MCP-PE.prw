#INCLUDE 'Protheus.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F050MCP()
O ponto de entrada F050MCP permite incluir novos campos na op��o 
Alterar da rotina FINA050. Ser� executado ao exibir a tela ap�s clicar no 
bot�o Alterar da rotina FINA050. Desta forma, os campos que forem inclu�dos 
por este Ponto de Entrada tamb�m poder�o ser editados na op��o Alterar.

@param		Paramixb	= 	Array com os campos editaveis na SE2
@return		aCpoAlt		= 	Campos adicionados para edi��o
@author 	Fabiano Albuquerque
@since 		07/06/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

USER FUNCTION F050MCP()

LOCAL aCpoAlt := Paramixb

aCpoAlt := U_ASFINA61(aCpoAlt)

Return aCpoAlt