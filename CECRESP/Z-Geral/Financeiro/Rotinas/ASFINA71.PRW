#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA71()
Executado no ponto de entrada F340VLD, valida��o da compensa��o 
 
@param		Nenhum
@return		lRet - .T. / .F.
@author 	Zema
@since 		05/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA71
Local lRet := .T.
Local aArea := GETAREA()
SE2->(DBSETORDER(1))
IF SE2->(DBSEEK(XFILIAL("SE2")+cPrefixo+cNum+cParcela+cTipoTit+cFornece+cLoja))
	IF SE2->E2_XSFLUIG <> "A" .OR. SE2->E2_XSFLUIG <> " "
		ApMsgAlert("Titulo em processo de libera��o, n�o ser� poss�vel realizar as compensa��es!")
		lRet := .F.
	ENDIF
ENDIF
RestArea(aArea)
RETURN lRet