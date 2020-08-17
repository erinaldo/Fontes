#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA07()

Chamado pelo PE F040ADLE

Adiciona as legendas:
	Pagar:
	Título aguar. aprov. no Fluig
	Título reprovado no Fluig

	Receber:
	Título securitizado
	Título securitizado vencido
	
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
		aAdd(aRet,{"BPMSEDT2","Título aguar. aprov. no Fluig"})
		aAdd(aRet,{"BPMSEDT1","Título reprovado no Fluig"})
	ELSEIF FUNNAME() $ "FINA040|FINA740"
		aAdd(aRet,{"f14_azul","Título securitizado"})
		aAdd(aRet,{"f14_verm","Título securitizado vencido"})
	ENDIF
		
RETURN aRet