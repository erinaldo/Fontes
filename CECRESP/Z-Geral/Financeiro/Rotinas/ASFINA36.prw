#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA36()

Adiciona bot�o:
M�tuo de transfer�ncia banc�ria
M�tuo de t�tulos a receber

@param		aRotina := Array contendo os bot�es padr�o da EnchoiceBar
@return		aRet = Array contendo a estrutura dos bot�es padr�o mais o(s) 
			bot�o(�es) customizados pelo usu�rio
@author 	Fabio Cazarini
@since 		14/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA36( aRotina )
	LOCAL aRet := aClone(aRotina)
	
	aAdd( aRet, { 'Transfer�ncia de m�tuo' 		,'U_ASFINA37', 0 , 3 })
//	aAdd( aRet, { 'M�tuo de t�tulos a receber' 	,'U_ASFINA44', 0 , 3 })
	
RETURN aRet