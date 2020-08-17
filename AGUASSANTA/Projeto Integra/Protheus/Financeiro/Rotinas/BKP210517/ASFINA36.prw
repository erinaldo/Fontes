#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA36()

Adiciona botão:
Mútuo de transferência bancária
Mútuo de títulos a receber

@param		aRotina := Array contendo os botões padrão da EnchoiceBar
@return		aRet = Array contendo a estrutura dos botões padrão mais o(s) 
			botão(ões) customizados pelo usuário
@author 	Fabio Cazarini
@since 		14/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA36( aRotina )
	LOCAL aRet := aClone(aRotina)
	
	aAdd( aRet, { 'Transferência de mútuo' 		,'U_ASFINA37', 0 , 3 })
//	aAdd( aRet, { 'Mútuo de títulos a receber' 	,'U_ASFINA44', 0 , 3 })
	
RETURN aRet