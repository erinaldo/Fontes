#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA070CA3                     
Valida se a baixa do titulo a receber pode ser cancelada ou excluida
@param		Opção selecionada
@return		lRet		= 	.T. / .F.
@author 	Zema
@since 		08/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA070CA3()
LOCAL lRet := .T.
LOCAL nOpcx:= PARAMIXB
lRet := U_ASTIN022(nOpcx)    
lRet := U_ASTIN035(nOpcx)    
RETURN lRet