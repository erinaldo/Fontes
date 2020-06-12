#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA33()

Filtro na gera��o do border�, por contrato de - at�

Premissa:
Receber a informa��o do contrato na integra��o com o TIN RM. Esta 
informa��o vir� preenchida no campo Hist�rico (E1_HIST), identificado 
pelo conte�do antes do pipe '|'

Chamado pelo PE FA60FIL

@param		cPort060 = Portador
			cAgen060 = Agencia
			cConta060 = Conta
			cSituacao = Situacao
			dVencIni = Vencimento de
			dVencFim = Vencimento at�
			nLimite = Limite
			nMoeda = Moeda
			cContrato = Contrato
			dEmisDe = Emiss�o de 
			dEmisAte = Emiss�o at�
			cCliDe = Cliente de
			cCliAte = Cliente at�
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
	aAdd(aPar,{1	,"Contrato TIN - at�"	,cContraAte				, "", , 		, , 050, .F.})
	
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