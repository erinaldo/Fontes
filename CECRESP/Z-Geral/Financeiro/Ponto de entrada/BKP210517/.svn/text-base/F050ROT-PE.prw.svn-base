#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F050ROT()

Inclui itens de menu

Ponto de Entrada que permite modificar os itens de menu do browse de 
seleção de títulos a pagar, por meio da edição da variável aRotina 
(passada como parâmetro no Ponto de Entrada). O retorno deve conter a 
variável aRotina customizada, com as opções que podem ser selecionadas.

@param		aRotina	=		Itens de menu do browse
@return		aRotina	=		Itens de menu do browse modificada
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F050ROT()
	LOCAL aRotina := PARAMIXB

	//-----------------------------------------------------------------------
	// Adiciona o item Visualiza Aprovadores
	// Adiciona o item Altera filial pagadora
	//-----------------------------------------------------------------------
	aRotina := U_ASFINA05(aRotina)

RETURN aRotina