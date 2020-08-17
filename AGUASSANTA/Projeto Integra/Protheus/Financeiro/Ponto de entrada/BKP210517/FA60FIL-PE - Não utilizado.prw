#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA60FIL()

Filtro de registros processados do borderô.

O ponto de entrada FA60FIL será executado no filtro de registros que serão 
processados para a elaboração do borderô(tipo Indregua).

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
USER FUNCTION FA60FIL()
	LOCAL cRet			:= ""
	LOCAL cPort060 		:= PARAMIXB[1]
	LOCAL cAgen060 		:= PARAMIXB[1]
	LOCAL cConta060 	:= PARAMIXB[2]
	LOCAL cSituacao 	:= PARAMIXB[3]
	LOCAL dVencIni 		:= PARAMIXB[4]
	LOCAL dVencFim 		:= PARAMIXB[5]
	LOCAL nLimite 		:= PARAMIXB[6]
	LOCAL nMoeda 		:= PARAMIXB[7]
	LOCAL cContrato 	:= PARAMIXB[8]
	LOCAL dEmisDe 		:= PARAMIXB[9]
	LOCAL dEmisAte 		:= PARAMIXB[10]
	LOCAL cCliDe 		:= PARAMIXB[11]
	LOCAL cCliAte 		:= PARAMIXB[12]
	
	//-----------------------------------------------------------------------
	// Filtro na geração do borderô, por contrato de - até
	//-----------------------------------------------------------------------
	cRet := U_ASFINA33(cPort060,cAgen060,cConta060,cSituacao,dVencIni,dVencFim,nLimite,nMoeda,cContrato,dEmisDe,dEmisAte,cCliDe,cCliAte)
	
RETURN cRet