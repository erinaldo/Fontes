#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA07()

Chamado pelo PE F040ADLE

Adiciona as legendas:
	Pagar:
	T�tulo aguar. aprov. no Fluig
	T�tulo reprovado no Fluig

	Receber:
	T�tulo securitizado
	T�tulo securitizado vencido
	
@param		aLegenda	= 	Array com as legendas
@return		aRet		= 	Vetor com a Legenda a ser adicionada
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA07(aLegenda)
	LOCAL aRet	:= {}
	
	IF FUNNAME() $ "FINA050|FINA750"
		aAdd(aRet,{"BPMSEDT2","T�tulo aguar. aprov. no Fluig"})
		aAdd(aRet,{"BPMSEDT1","T�tulo reprovado no Fluig"})
	ELSEIF FUNNAME() $ "FINA040|FINA740"
		aAdd(aRet,{"f14_azul","T�tulo securitizado"})
		aAdd(aRet,{"f14_verm","T�tulo securitizado vencido"})
	ENDIF
		
RETURN aRet