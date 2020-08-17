#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA100ROT()

Inclusão de botões customizados na EnchoiceBar

Permite a inclusão de botões customizados na EnchoiceBar da rotina 
Movimento Bancário (FINA100).

@param		aRotina = Array contendo os botões padrão da EnchoiceBar
@return		aRet = Array contendo a estrutura dos botões padrão mais o(s) 
			botão(ões) customizados pelo usuário
@author 	Fabio Cazarini
@since 		15/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA100ROT()
	LOCAL aRet		:= aClone(PARAMIXB[1])
	
	//-----------------------------------------------------------------------
	// Mútuo de transferência bancária - adiciona botão
	//-----------------------------------------------------------------------
	aRet := U_ASFINA36(aRet)
	
RETURN aRet