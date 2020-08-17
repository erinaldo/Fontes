#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA02()

Consome WS para gerar a solicitação de aprovação de compras no Fluig

@param		cA120Num = Número do pedido de compras 
@return		cNFluig = Número da solicitação Fluig
@author 	Fabio Cazarini
@since 		03/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA02(cA120Num)
	LOCAL aAreaSCR		:= SCR->( GetArea() )
	LOCAL cFLUUSER		:= SuperGetMv("AS_FLUUSER",.T.,"IntegradorFluig")
	LOCAL cFLUPASS		:= SuperGetMv("AS_FLUPASS",.T.,"Integra1450")
	LOCAL aFilAtu		:= {}
	LOCAL cCNPJFil		:= ""
	LOCAL cNFluig		:= ""
	LOCAL nX			:= 0
	LOCAL nW			:= 0
	LOCAL oObj
	LOCAL oItens
	LOCAL cChaveSCR		:= ""
	LOCAL cAprovador	:= ""
	LOCAL cNivel		:= ""
	LOCAL cNmAprova		:= ""
	LOCAL cQuery		:= ""
	LOCAL cUsrEmail		:= ""
	LOCAL aCardData		:= {}
	LOCAL cResult		:= ""
	   
	//Fabiano Albuquerque: Alteração feita em 24/03/2017
	
	LOCAL cSolicit		:= ""
	LOCAL aArrayUser    := {}
	LOCAL nValAprov		:= 0  
	
	//Fim
	
	//-----------------------------------------------------------------------
	// Retorna um array com as informações da filial 
	//-----------------------------------------------------------------------
	// IF !IsInCallStack("MATI120") // Se o pedido não for originado por medição de contrato TOP -  Alterado 17/07/2017 - Fabiano Albuquerque
		aFilAtu 	:= FWArrFilAtu()
		cCNPJFil	:= aFilAtu[SM0_CGC]
	
		//-----------------------------------------------------------------------
		// Retorna o primeiro aprovador do PC 
		//-----------------------------------------------------------------------
		cChaveSCR	:= xFilial("SCR") + PADR("PC", TAMSX3("CR_TIPO")[1]) + PADR(cA120Num, TAMSX3("CR_NUM")[1])
		dbSelectArea("SCR")
		SCR->(dbSetOrder(1)) // CR_FILIAL + CR_TIPO + CR_NUM + CR_NIVEL
		IF DbSEEK(cChaveSCR)
			DO WHILE !SCR->( EOF() ) .AND. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) == cChaveSCR
				IF SCR->CR_STATUS == "02" // Aguardando Liberacao do usuario
					cAprovador 	:= UsrRetName(SCR->CR_USER)
					cNivel		:= SCR->CR_NIVEL
					cNmAprova	:= UsrFullName(SCR->CR_USER)
					cUsrEmail	:= UsrRetMail(SCR->CR_USER)
					nValAprov   := SCR->CR_TOTAL
					Exit 
				ENDIF
				SCR->(dbSkip())
			ENDDO
		ENDIF
	
		IF EMPTY(cAprovador)
		
			cChaveSCR	:= xFilial("SCR") + PADR("IP", TAMSX3("CR_TIPO")[1]) + PADR(cA120Num, TAMSX3("CR_NUM")[1])
			dbSelectArea("SCR")
			SCR->(dbSetOrder(1)) // CR_FILIAL + CR_TIPO + CR_NUM + CR_NIVEL
			IF DbSEEK(cChaveSCR)
				DO WHILE !SCR->( EOF() ) .AND. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) == cChaveSCR
					IF SCR->CR_STATUS == "02" // Aguardando Liberacao do usuario
						cAprovador 	:= UsrRetName(SCR->CR_USER)
						cNivel		:= SCR->CR_NIVEL
						cNmAprova	:= UsrFullName(SCR->CR_USER)
						cUsrEmail	:= UsrRetMail(SCR->CR_USER)
						nValAprov   := SCR->CR_TOTAL
						Exit 
					ENDIF
					SCR->(dbSkip())
				ENDDO
			ENDIF
		ENDIF
	//EndIF
	
	
	IF EMPTY(cAprovador)
		//IF !IsInCallStack("MATI120") // Se o pedido não for originado por medição de contrato TOP -  Alterado 17/07/2017 - Fabiano Albuquerque
			Help('',1,'Envio da aprovação para o Fluig - ' + PROCNAME(),,'Não existe nenhum aprovador para liberação deste pedido',4,1)
		//ENDIF	
	ELSE
		//-----------------------------------------------------------------------
		// Inicializa objeto
		//-----------------------------------------------------------------------
		oObj	:= WSECMWorkflowEngineServiceService():New()

		//-----------------------------------------------------------------------
		// Cabecalho da solicitacao
		//-----------------------------------------------------------------------
		oObj:cusername		:= cFLUUSER 							// login do usuário.
		oObj:cpassword 		:= cFLUPASS 							// senha do usuário.
		oObj:ncompanyId 	:= 1 									// código da empresa.
		oObj:cprocessId 	:= "procSolicitacaoCompra" 				// código do processo.
		oObj:nchoosedState	:= 23 									// número da atividade.
		oObj:ccomments 		:= "Solicitacao iniciada via Protheus" 	// comentários.
		oObj:cuserId 		:= GetNewPar("AS_FLUUSID","IntegradorFluig") 					// matrícula do usuário que vai iniciar a solicitação (do pedido).
		oObj:lcompleteTask 	:= .T. 									// indica se deve completar a tarefa (true) ou somente salvar (false).
		oObj:lmanagerMode 	:= .F. 									// indica se usuário esta iniciando a solicitação como gestor do processo.

		//oObj:oWSstartProcesscolleagueIds:citem := {"IntegradorFluig"} 				// usuário que receberá a tarefa (aprovador).
		oObj:oWSstartProcesscolleagueIds:citem := {"System:Auto"} 				// usuário que receberá a tarefa (aprovador).		
		//oObj:oWSstartProcesscolleagueIds:citem := {ALLTRIM(cUSERNAME)} 				// usuário que receberá a tarefa (aprovador).

		
		//Fabiano Albuquerque: Alteração feita em 24/03/2017
				
		//-----------------------------------------------------------------------
		//Busca o nome do solicitante para ser enviado ao fluig
		//-----------------------------------------------------------------------
		
		cSolicit := POSICIONE("SC1",6,xFilial("SC1")+cA120Num,"C1_USER")
		PswOrder(1)
		IF PswSeek(cSolicit, .T.)
			aArrayUser := PswRet()
			cSolicit := aArrayUser[1][4]
		ENDIF
		
		//Fim
		
		
		//-----------------------------------------------------------------------
		// Array com o carddata - Dados para o formulário: 
		// 	Número ERP (A2)
		//	Grupo de Empresas (A32)
		//	CNPJ Empresa (A6)
		//----------------------------------------------------------------------- 		
		
		AADD(aCardData, { "tNumeroERP"			, cA120Num		} )
		AADD(aCardData, { "hGrupoEmpresas"		, cEmpAnt		} )
		AADD(aCardData, { "hCNPJEmpresa"		, cCNPJFil		} )
		AADD(aCardData, { "hMatriculaAprovador"	, cAprovador	} )
		AADD(aCardData, { "hNivelAprovador"		, cNivel		} )
		AADD(aCardData, { "hEmailAprovador"		, cUsrEmail		} )
		AADD(aCardData, { "tNomeSolicitante"	, cSolicit		} )
		AADD(aCardData, { "tValorAprovador"	    , ALLTRIM(TRANSFORM(nValAprov, "@E 9,999,999,999,999.99"))} )		
		
		//-----------------------------------------------------------------------
		// Inicializa o carddata
		//-----------------------------------------------------------------------
		FOR nX := 1 TO LEN(aCardData)
			oItens := ECMWorkflowEngineServiceService_stringArray():New() 
			oItens:citem	:= {aCardData[nX][1],aCardData[nX][2]}  

			Aadd(oObj:oWSstartProcesscardData:oWSitem,oItens)
		NEXT nX

		// startProcess(String user, String password, int companyId, String processId, int choosedState, String[] colleagueIds, String comments, String userId, boolean completeTask, ProcessAttachmentDto[] attachments, String[][] cardData, ProcessTaskAppointmentDto[] appointment, boolean managerMode)
		IF oObj:startProcess()        
			IF UPPER(ALLTRIM(oObj:oWSstartProcessresult:oWsItem[1]:cItem[1])) == "ERROR"
				Help('',1,'Envio da aprovação para o Fluig - ' + PROCNAME(),,oObj:oWSstartProcessresult:oWsItem[1]:cItem[2],4,1)
			ELSE
				FOR nW := 1 TO LEN(oObj:oWSstartProcessresult:oWsItem)
					IF UPPER(ALLTRIM(oObj:oWSstartProcessresult:oWsItem[nW]:cItem[1])) == "IPROCESS"
						cNFluig := UPPER(ALLTRIM(oObj:oWSstartProcessresult:oWsItem[nW]:cItem[2]))
						EXIT
					ENDIF
				NEXT nW				

				//-----------------------------------------------------------------------
				// Se gerou a solicitação no Fluig, atualiza a SC7: Número e status
				//-----------------------------------------------------------------------
				IF !EMPTY(cNFluig) 
					SC7->(DBCOMMIT())
					
					cQuery := "UPDATE " + RetSqlname("SC7") + " "
					cQuery += "SET 	C7_XNFLUIG = '" + ALLTRIM(cNFluig) + "', "
					cQuery += "     C7_XAPROVA = '" + ALLTRIM(cAprovador) + "', "
					cQuery += "     C7_XAPRNIV = '" + ALLTRIM(cNivel) + "', "
					cQuery += "     C7_XAPRNOM = '" + ALLTRIM(cNmAprova) + "', "
					cQuery += "		C7_XSFLUIG = 'E' "
					cQuery += "WHERE 	C7_FILIAL = '" + xFilial("SC7") + "' "
					cQuery += "		AND C7_QUJE < C7_QUANT "
					cQuery += "		AND C7_RESIDUO <> 'S' "
					cQuery += "		AND C7_NUM = '" + cA120Num + "' "
					cQuery += "		AND D_E_L_E_T_ = ' ' "
				
					TcSqlExec(cQuery)
					SC7->(MsGoto(RecNo()))
					
					//MsgInfo("Aprovação enviada para o Fluig. Número: " + cNFluig)

				ENDIF
			ENDIF
		ELSE
			cResult := GetWSCError()
			Help('',1,'Envio da aprovação para o Fluig - ' + PROCNAME(),,"Não foi possível executar o envio - " + cResult,4,1)		
		ENDIF
	ENDIF

	RestArea(aAreaSCR)

RETURN cNFluig