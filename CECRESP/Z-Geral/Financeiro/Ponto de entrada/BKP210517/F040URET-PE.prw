#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F040URET()

Inclui condição para nova legenda

O ponto de entrada F040URET inclui a condição para nova legenda para as 
rotinas FINA040, FINA050.

@param		uRetorno	= 	Array com as condições antes da mudança
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
	// Adiciona a condição nas legendas (título a pagar):
	//	Título aguar. aprov. no Fluig
	//	Título reprovado no Fluig
	//-----------------------------------------------------------------------
	aRet := U_ASFINA08(uRetorno, aLegenda)
	
RETURN aRet