#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA33()

Filtro na geração do borderô, por contrato de - até

Premissa:
Receber a informação do contrato na integração com o TIN RM. Esta 
informação virá preenchida no campo Histórico (E1_HIST), identificado 
pelo conteúdo antes do pipe '|'

Chamado pelo PE FA60FIL

@param		cPort060 = Portador
			cAgen060 = Agencia
			cConta060 = Conta
			cSituacao = Situacao
			dVencIni = Vencimento de
			dVencFim = Vencimento até
			nLimite = Limite
			nMoeda = Moeda
			cContrato = Contrato
			dEmisDe = Emissão de 
			dEmisAte = Emissão até
			cCliDe = Cliente de
			cCliAte = Cliente até
@return		cRet = Filtro desejado
@author 	Fabio Cazarini
@since 		12/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA33(cPort060,cAgen060,cConta060,cSituacao,dVencIni,dVencFim,nLimite,nMoeda,cContrato,dEmisDe,dEmisAte,cCliDe,cCliAte)
	LOCAL cRet 			:= ""
	LOCAL cContraDe		:= SPACE( TAMSX3("E1_XCONTRA")[1] )
	LOCAL cContraAte	:= REPLICATE( "Z", TAMSX3("E1_XCONTRA")[1] )
	LOCAL aPar			:= {}
	LOCAL aRet			:= {}
	LOCAL lRet			:= .F.

	aAdd(aPar,{1	,"Contrato TIN - de"	,cContraDe 				, "", , 		, , 050, .F.})
	aAdd(aPar,{1	,"Contrato TIN - até"	,cContraAte				, "", , 		, , 050, .F.})
	
	lRet 	:= ParamBox(aPar,"Filtro por contrato TIN",@aRet,,,,,,,"ASFINA33",.F.,.F.)
	IF lRet
		IF LEN(aRet) >= 1
			cContraDe 	:= aRet[01]
		ENDIF
		IF LEN(aRet) >= 2
			cContraAte	:= aRet[02]
		ENDIF
	ENDIF

	cRet := "(SE1->E1_XCONTRA >= '" + cContraDe + "' .AND. SE1->E1_XCONTRA <= '" + cContraAte + "')"
	
RETURN cRet