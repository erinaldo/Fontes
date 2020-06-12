#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA750BRW()

Adição de itens no menu da mBrowse

O ponto de entrada FA750BRW foi desenvolvido para adicionar itens no menu 
da mBrowse. Retorna array com as opções e manda como parâmetro o array 
com as opções padrão.


@param		aRotina = Botoes da rotina, antes da adição
@return		aRet(vetor) = Array contendo os novos botões.
@author 	Fabio Cazarini
@since 		22/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA750BRW()
	LOCAL aRotina	:= PARAMIXB[1]
	
	//-----------------------------------------------------------------------
	// Adiciona o item Visualiza Aprovadores
	// Adiciona o item Altera filial pagadora
	//-----------------------------------------------------------------------
	aRotina := U_ASFINA05({})
		
RETURN aRotina