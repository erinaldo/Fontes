#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA03()

Consome WS para excluir a solicita��o do pedido de compras no Fluig 

@param		cNFluig = N�mero da solicita��o Fluig 
			cAprovador = Matricula do aprovador no Fluig
			cObs = Observa��o da exclus�o
@return		lRet = Sucesso no cancelamento da solicita��o
@author 	Fabio Cazarini
@since 		04/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA03(cNFluig, cAprovador, cObs)
	LOCAL cFLUUSER		:= SuperGetMv("AS_FLUUSER",.T.,"IntegradorFluig")
	LOCAL cFLUPASS		:= SuperGetMv("AS_FLUPASS",.T.,"Integra1450")
	LOCAL cResult		:= ""
	LOCAL lRet			:= .T.
	LOCAL oOBJ 

	//-----------------------------------------------------------------------
	// Inicializa objeto
	//-----------------------------------------------------------------------
	oOBJ	:= WSECMWorkflowEngineServiceService():New()

	oObj:cusername 				:= cFLUUSER
	oObj:cpassword 				:= cFLUPASS
	oObj:ncompanyId 			:= 1
	oObj:nprocessInstanceId		:= VAL(ALLTRIM(cNFLUIG))
	oObj:cuserId				:= GetNewPar("AS_FLUUSID","IntegradorFluig")   ///
	oObj:ccancelText			:= "Cancelamento via Protheus - " + cUSERNAME + " - " + cObs

	IF oObj:cancelInstance()
		cResult := oObj:cresult
		IF UPPER(ALLTRIM(cResult)) == "OK"
			MsgInfo("Solicita��o Fluig n�mero " + ALLTRIM(cNFLUIG) + " cancelada")
		ELSE
			Help('',1,'Cancelamento da solicita��o no Fluig - ' + PROCNAME(),,"N�o foi poss�vel cancelar a solicita��o Fluig n�mero " + ALLTRIM(cNFLUIG) + " - " + cResult,4,1)
		ENDIF
	ELSE
		lRet		:= .F.
		cResult 	:= GetWSCError()

		Help('',1,'Cancelamento da solicita��o no Fluig - ' + PROCNAME(),,"N�o foi poss�vel cancelar a solicita��o Fluig n�mero " + ALLTRIM(cNFLUIG) + " - " + cResult,4,1)
	ENDIF

RETURN lRet