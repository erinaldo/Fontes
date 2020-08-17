#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA08()

Adiciona a condição das legendas:
	Pagar:
	Título aguar. aprov. no Fluig
	Título reprovado no Fluig

	Receber:
	Título securitizado
	Título securitizado vencido

Chamado pelo PE F040URET

@param		uRetorno	= 	Array com as condições antes da mudança
			aLegenda	= 	Array com as legendas
@return		aRet		= 	Vetor com os dados do novo Status
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA08(uRetorno, aLegenda)
	LOCAL aRet 		:= {}

	IF FUNNAME() $ "FINA050|FINA750"	
		//-----------------------------------------------------------------------
		// N=Não enviado Fluig;E=Enviado Fluig;I=Iniciada Aprov.Fluig;
		// A=Aprovado Fluig;R=Reprovado Fluig
		//-----------------------------------------------------------------------
		aAdd(aRet,{"E2_XSFLUIG $ 'EI'"	,"BPMSEDT2"}) 	// Título aguar. aprov. no Fluig
		aAdd(aRet,{"E2_XSFLUIG $ 'R'"	,"BPMSEDT1"})	// Título reprovado no Fluig
		
	ELSEIF FUNNAME() $ "FINA040|FINA740"
		aAdd(aRet,{"E1_SITUACA <> '0' .and. E1_SALDO>0 .and. E1_XSECUR == '1'"	,"f14_azul"}) 	// Título securitizado
		aAdd(aRet,{"E1_SITUACA <> '0' .and. E1_SALDO>0 .and. E1_XSECUR == '9'"	,"f14_verm"})	// Título securitizado vencido
	
	ENDIF 
	
RETURN aRet