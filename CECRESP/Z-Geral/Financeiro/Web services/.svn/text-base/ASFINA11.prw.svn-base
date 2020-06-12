#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA11()

Consome WS para gerar a solicitação de aprovação de título a pagar no 
Fluig

Chamado da rotina ASFINA01

@param		cChaveSE2 = Chave do título a pagar 
@return		cNFluig = Número da solicitação Fluig
@author 	Fabio Cazarini
@since 		13/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA11(cChaveSE2)
	LOCAL aArea			:= GetArea()
	LOCAL aAreaSE2		:= SE2->( GetArea() )	
	LOCAL aAreaSZ5		:= SZ5->( GetArea() )
	LOCAL cFLUUSER		:= SuperGetMv("AS_FLUUSER",.T.,"IntegradorFluig")
	LOCAL cFLUPASS		:= SuperGetMv("AS_FLUPASS",.T.,"Integra1450")
	LOCAL aFilAtu		:= {}
	LOCAL cCNPJFil		:= ""
	LOCAL cNFluig		:= ""
	LOCAL nX			:= 0
	LOCAL nW			:= 0
	LOCAL oObj
	LOCAL oItens
	LOCAL cChaveSZ5		:= ""
	LOCAL cAprovador	:= ""
	LOCAL cNivel		:= ""
	LOCAL cUsrEmail		:= ""
	LOCAL cNmAprova		:= ""
	LOCAL aCardData		:= {}
	LOCAL cResult		:= ""
	LOCAL cSolic		:= UsrFullName()
	//-----------------------------------------------------------------------
	// Retorna um array com as informações da filial 
	//-----------------------------------------------------------------------
	aFilAtu 	:= FWArrFilAtu()
	cCNPJFil	:= aFilAtu[SM0_CGC]

	//-----------------------------------------------------------------------
	// Retorna o primeiro aprovador do PC 
	//-----------------------------------------------------------------------
	cChaveSZ5	:= xFilial("SZ5") + PADR("PG", TAMSX3("Z5_TIPO")[1]) + PADR(cChaveSE2, TAMSX3("Z5_NUM")[1]) 
	dbSelectArea("SZ5")
	SZ5->(dbSetOrder(1)) // Z5_FILIAL + Z5_TIPO + Z5_NUM + Z5_NIVEL
	IF DbSEEK(cChaveSZ5)
		DO WHILE !SZ5->( EOF() ) .AND. SZ5->(Z5_FILIAL + Z5_TIPO + Z5_NUM) == cChaveSZ5
			IF SZ5->Z5_STATUS == "02" // Aguardando Liberacao do usuario
				cAprovador 	:= UsrRetName(SZ5->Z5_USER)
				cNivel		:= SZ5->Z5_NIVEL
				cNmAprova	:= UsrFullName(SZ5->Z5_USER)
				cUsrEmail	:= UsrRetMail(SZ5->Z5_USER)
				Exit 
			ENDIF
			SZ5->(dbSkip())
		ENDDO
	ENDIF

	IF EMPTY(cAprovador)
		Help('',1,'Envio da aprovação para o Fluig - ' + PROCNAME(),,'Não existe nenhum aprovador para liberação deste título a pagar',4,1)
	ELSE
		DbSelectArea("SE2")
		DbSetOrder(1) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		IF MsSEEK(cChaveSE2)
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
			oObj:cprocessId 	:= "aprovacaoTituloPagar" 				// código do processo.
			oObj:nchoosedState	:= 23 									// número da atividade.
			oObj:ccomments 		:= "Solicitacao iniciada via Protheus" 	// comentários.
			oObj:cuserId 		:= "IntegradorFluig" 					// matrícula do usuário que vai iniciar a solicitação (do pedido).
			oObj:lcompleteTask 	:= .T. 									// indica se deve completar a tarefa (true) ou somente salvar (false).
			oObj:lmanagerMode 	:= .F. 									// indica se usuário esta iniciando a solicitação como gestor do processo.
	
			oObj:oWSstartProcesscolleagueIds:citem := {"IntegradorFluig"} 				// usuário que receberá a tarefa (aprovador).
	
			//-----------------------------------------------------------------------
			// Array com o carddata - Dados para o formulário: 
			// Dados para o formulário: CNPJ Empresa (A7), Grupo de Empresas (A25), 
			// Número Título (A12), Prefixo (A11), Parcela (A13), Tipo (A14), 
			// Código Fornecedor (A9), Loja (A24), Matrícula do aprovador (A29)
			//-----------------------------------------------------------------------
			AADD(aCardData, { "hPrefixo"			, SE2->E2_PREFIXO	} )
			AADD(aCardData, { "tNumeroTitulo"		, SE2->E2_NUM		} )
			AADD(aCardData, { "tParcela"			, SE2->E2_PARCELA	} )
			AADD(aCardData, { "hTipo"				, SE2->E2_TIPO		} )
			AADD(aCardData, { "hCodigoFornecedor"	, SE2->E2_FORNECE	} )
			AADD(aCardData, { "hLojaFornecedor"		, SE2->E2_LOJA		} )
			AADD(aCardData, { "hGrupoEmpresas"		, cEmpAnt			} )
			AADD(aCardData, { "hCNPJEmpresa"		, cCNPJFil			} )
			AADD(aCardData, { "hMatriculaAprovador"	, cAprovador		} )
			AADD(aCardData, { "hNivelAprovador"		, cNivel			} )
			AADD(aCardData, { "hEmailAprovador"		, cUsrEmail			} )
			AADD(aCardData, { "tNomeSolicitante"	, cSolic			} )


	
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
					// Se gerou a solicitação no Fluig, atualiza a SE2: Número e status
					//-----------------------------------------------------------------------
					IF !EMPTY(cNFluig) 
						RecLock("SE2", .F.)
						SE2->E2_XNFLUIG := cNFluig
						SE2->E2_XAPROVA := cAprovador
						SE2->E2_XAPRNIV := cNivel
						SE2->E2_XAPRNOM := cNmAprova
						SE2->E2_XSFLUIG := 'E' 
						SE2->( MsUnLock() )

						//MsgInfo("Aprovação enviada para o Fluig. Número: " + cNFluig)
	
					ENDIF
				ENDIF
			ELSE
				cResult := GetWSCError()
				Help('',1,'Envio da aprovação para o Fluig - ' + PROCNAME(),,"Não foi possível executar o envio - " + cResult,4,1)		
			ENDIF
		ENDIF
	ENDIF

	RestArea(aAreaSE2)
	RestArea(aAreaSZ5)
	RestArea(aArea)
	
RETURN cNFluig