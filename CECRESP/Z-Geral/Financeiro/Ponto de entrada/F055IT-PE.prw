#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F055IT()

O ponto de entrada F055IT é executado após a inclusão de novos títulos 
(SE1 ou SE2) pela integração (FINI055)

@param		cValExt		InternalId valor externo
			cHist		Histórico
			cTitE1E2	Título novo incluído
@return		Nenhum
@author 	Fabio Cazarini
@since 		02/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F055IT()
	LOCAL cValExt 	:= PARAMIXB[1]
	LOCAL cHist		:= PARAMIXB[2]
	LOCAL cTitE1E2	:= PARAMIXB[3] // cTitE1E2 := "SE1|"+cPrefixo+"|"+cNum+"|"+cParcel+"|"+cTpParcel

	//-----------------------------------------------------------------------
	// Gera o título de abatimento AB- com o valor do parceiro
	//-----------------------------------------------------------------------
	U_ASFINA47(cValExt, cHist, cTitE1E2)
	
RETURN