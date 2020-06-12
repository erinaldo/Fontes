#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F100TOK()

 O ponto de entrada F100TOK sera executado para validar os dados da movimentacao bancaria
 
@param		Nenhum
@return		Nenhum
@author 	Tatiana A. Barbosa
@since 		20/10/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F100TOK()
Local lRet := .F.                 
Local aArea := GETAREA()
	//-----------------------------------------------------------------------
	// Mútuo a receber:
	// - Validação do campo E5_XMUTREC 
	//-----------------------------------------------------------------------
	If M->E5_XMUTREC == "S" .AND. IsInCallStack("fA100Rec")
		lRet := U_ASFINA52()
	Else
		lRet := .T.
	EndIf

RESTAREA(aArea)
		
RETURN lRet