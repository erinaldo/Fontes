#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FI040ROT()

Inclusão de novos itens no menu aRotina

@param		aRotOrig = Array contendo os botões
@return		aRotina = Array contendo os novos botões
@author 	Fabio Cazarini
@since 		22/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FI040ROT()
	LOCAL aRotOrig := PARAMIXB

	//-----------------------------------------------------------------------
	// Adiciona botão para :
	// Executar a transferência do portador e situação em lote
	// Executar a baixa a receber de parceiros 
	//-----------------------------------------------------------------------
	aRotina := U_ASFINA41(aRotOrig)
	
RETURN aRotina	