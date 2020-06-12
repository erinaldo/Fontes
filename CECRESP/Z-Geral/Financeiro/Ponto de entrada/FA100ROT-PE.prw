#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA100ROT()

Inclus�o de bot�es customizados na EnchoiceBar

Permite a inclus�o de bot�es customizados na EnchoiceBar da rotina 
Movimento Banc�rio (FINA100).

@param		aRotina = Array contendo os bot�es padr�o da EnchoiceBar
@return		aRet = Array contendo a estrutura dos bot�es padr�o mais o(s) 
			bot�o(�es) customizados pelo usu�rio
@author 	Fabio Cazarini
@since 		15/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA100ROT()
	LOCAL aRet		:= aClone(PARAMIXB[1])
	
	//-----------------------------------------------------------------------
	// M�tuo de transfer�ncia banc�ria - adiciona bot�o
	//-----------------------------------------------------------------------
	aRet := U_ASFINA36(aRet)
	
RETURN aRet