#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F040ADLE()

Adicionar legenda em FINA040 - Manutenção Titulos a Receber (e FINA050 - Manutenção de Titulos a Pagar)

O ponto de Entrada F040ADLE adiciona Legendas na funçao FINA040 (e FINA050)

@param		aLegenda	= 	Array com as legendas
@return		aRet		= 	Vetor com a Legenda a ser adicionada
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F040ADLE()
	LOCAL aRet 		:= {}              
	LOCAL aLegenda	:= PARAMIXB

	//-----------------------------------------------------------------------
	// Adiciona as legendas (título a pagar):
	//	Título aguar. aprov. no Fluig
	//	Título reprovado no Fluig
	//-----------------------------------------------------------------------
	aRet := U_ASFINA07(aLegenda)
		
RETURN aRet