#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F040BLQ                     
Valida se pode dar manutenção no titulo
@param		Nenhum
@return		lRet		= 	.T. / .F.
@author 	Zema
@since 		08/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F040BLQ()
LOCAL lRet := .T. 

IF ISINCALLSTACK( 'U_ASTIN021' )
	lRet := U_ASTIN027()
ENDIF

IF ISINCALLSTACK( 'U_ASTIN031' )
	lRet := U_ASTIN032()
ENDIF

RETURN lRet