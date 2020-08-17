#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA740BRW()

Adi��o de itens no menu da mBrowse

O ponto de entrada FA740BRW foi desenvolvido para adicionar itens no menu 
da mBrowse. Retorna array com os novas op��es e manda como par�metro o 
array com as op��es padr�o.

@param		aRotOrig = Array contendo os bot�es
@return		aRotina = Array contendo os novos bot�es
@author 	Fabio Cazarini
@since 		22/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA740BRW()
	LOCAL aRotOrig := PARAMIXB

//User Function FA740BRW()Local aBotao := {}Return(aBotao
	
	//-----------------------------------------------------------------------
	// Adiciona bot�o para executar a transfer�ncia do portador e situa��o em 
	// lote
	//-----------------------------------------------------------------------
	aRotina := U_ASFINA41({})
	
RETURN aRotina