#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA750BRW()

Adi��o de itens no menu da mBrowse

O ponto de entrada FA750BRW foi desenvolvido para adicionar itens no menu 
da mBrowse. Retorna array com as op��es e manda como par�metro o array 
com as op��es padr�o.


@param		aRotina = Botoes da rotina, antes da adi��o
@return		aRet(vetor) = Array contendo os novos bot�es.
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