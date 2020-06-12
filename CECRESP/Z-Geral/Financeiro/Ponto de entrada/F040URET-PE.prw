#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F040URET()

Inclui condi��o para nova legenda

O ponto de entrada F040URET inclui a condi��o para nova legenda para as 
rotinas FINA040, FINA050.

@param		uRetorno	= 	Array com as condi��es antes da mudan�a
			aLegenda	= 	Array com as legendas
@return		aRet		= 	Vetor com os dados do novo Status
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F040URET()
	LOCAL uRetorno	:= PARAMIXB[1]
	LOCAL aLegenda	:= PARAMIXB[2]
	LOCAL aRet 		:= {}                      
	
	//-----------------------------------------------------------------------
	// Adiciona a condi��o nas legendas (t�tulo a pagar):
	//	T�tulo aguar. aprov. no Fluig
	//	T�tulo reprovado no Fluig
	//-----------------------------------------------------------------------
	aRet := U_ASFINA08(uRetorno, aLegenda)
	
RETURN aRet