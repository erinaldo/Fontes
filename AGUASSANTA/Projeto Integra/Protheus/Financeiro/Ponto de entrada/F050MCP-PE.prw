#INCLUDE 'Protheus.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F050MCP()
O ponto de entrada F050MCP permite incluir novos campos na opção 
Alterar da rotina FINA050. Será executado ao exibir a tela após clicar no 
botão Alterar da rotina FINA050. Desta forma, os campos que forem incluídos 
por este Ponto de Entrada também poderão ser editados na opção Alterar.

@param		Paramixb	= 	Array com os campos editaveis na SE2
@return		aCpoAlt		= 	Campos adicionados para edição
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