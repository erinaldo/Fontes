#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA070TIT                     
Ponto de Entrada para Confirmacao da Baixa
@param		{nParciais} - Baixas Parciais
@return		lRet		= 	.T. / .F.
@author 	Zema
@since 		08/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA070TIT
LOCAL lRet := .T.     
LOCAL nParciais := PARAMIXB[1]
lRet := U_ASTIN024()
lRet := U_ASTIN036()
RETURN lRet