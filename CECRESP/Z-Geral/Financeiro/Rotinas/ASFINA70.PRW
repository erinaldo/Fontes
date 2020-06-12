#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA70()
Executado via ponto de entrada F340FLCP na seleção de titulos para compensação, 
permite filtrar os titulos para compensar 
 
@param		Nenhum
@return		cRet - Complemento da query
@author 	Zema
@since 		05/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA70
LOCAL cCond := " AND E2_XSFLUIG IN('A', ' ') "
RETURN cCond