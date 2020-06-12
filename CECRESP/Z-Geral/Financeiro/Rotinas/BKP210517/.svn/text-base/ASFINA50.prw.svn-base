#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA47()

Processa a fila da tabela SZB com os títulos integrados

Via schedule, ou demanda, serão gerados os títulos de abatimento AB- com 
o valor do parceiro

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA50()
	LOCAL aArea			:= GetArea()
	LOCAL aAreaSE1		:= SE1->( GetArea() )
	LOCAL nOpc     		:= 0
	LOCAL aSay   		:= {}
	LOCAL aButton 		:= {}    
	LOCAL cDesc1		:= OemToAnsi('O objetivo desta rotina é processar a fila de títulos       ')
	LOCAL cDesc2		:= OemToAnsi('a receber originados no TIN e gerar o título de abatimento  ')
	LOCAL cDesc3		:= OemToAnsi('referente à participação do parceiro                        ')
	LOCAL cDesc4		:= OemToAnsi('')
	LOCAL cDesc5		:= OemToAnsi('')
	LOCAL cDesc6		:= OemToAnsi('')
	LOCAL cDesc7  		:= OemToAnsi('')
	LOCAL cGrpCompany 	:= FWGrpCompany()
	LOCAL cFilPar		:= FWFilial()
	LOCAL aParam		:= {}
	
	PRIVATE cCadastro 	:= OEMTOANSI("Gerar abatimento referente à participação do parceiro")
	PRIVATE nProcess	:= 0
	PRIVATE nErroProc	:= 0

	//-----------------------------------------------------------------------
	// Adiciona a empresa e filial corrente
	//-----------------------------------------------------------------------
	AADD(aParam, cGrpCompany)
	AADD(aParam, cFilPar)
		
	// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
	aAdd( aSay, cDesc6 )
	aAdd( aSay, cDesc7 )

	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| nOpc := 2,FechaBatch() }} )

	FormBatch( cCadastro, aSay, aButton )

	IF nOpc == 1	
		Processa({|| U_ASFIA50A(aParam)},"Processando", "", .F.)
		IF nErroProc > 0
			MsgAlert( "Processo concluído. Foi(ram) processado(s) com sucesso " + ALLTRIM(STR(nProcess)) + " título(s). Ocorreu(ram) " + ALLTRIM(STR(nErroProc))  + " erro(s).", "Ok")
		ELSE
			MsgInfo( "Processo concluído com sucesso. Foi(ram) processado(s) " + ALLTRIM(STR(nProcess)) + " título(s).", "Ok")		
		ENDIF	
	ENDIF

	RestArea( aArea )
	SE1->( RestArea( aAreaSE1 ) )
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFIA50A()

Gera o abatimento referente à participação dos parceiros

@param		aParam = cGrpCompany, cFil
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFIA50A(aParam)
	LOCAL cQuery	:= ""
	LOCAL nReg		:= 0
	LOCAL lContinua	:= .T.

	PRIVATE lJob 	:= !(Type("oMainWnd")=="O")

	IF lJob
		//-----------------------------------------------------------------------
		// Seta o ambiente com a empresa/filial
		//-----------------------------------------------------------------------
		RpcClearEnv()										// Limpa o ambiente, liberando a licença e fechando as conexões
		RPCSetType(3)										// Seta tipo de consumo de licença
		RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
		SetHideInd(.T.) 									// Evita problemas com indices temporarios
	
		//-----------------------------------------------------------------------
		// Processamento via JOB
		//-----------------------------------------------------------------------
		Conout("ASFINA50 - JOB para gerar o abatimento referente à participação dos parceiros: Início em " + DTOC(dDATABASE) + " - " + TIME() )
	ELSE
		lContinua := MsgYesNo("Deseja realmente processar a geração do abatimento referente à participação dos parceiros?","Confirme") 
	ENDIF
	
	IF lContinua
		//-----------------------------------------------------------------------
		// Monta TRB com registros não processados
		//-----------------------------------------------------------------------
		cQuery := " SELECT SZB.R_E_C_N_O_  AS REGSZB "
		cQuery += " FROM " + RetSqlName("SZB") + " SZB "
		cQuery += " WHERE	SZB.ZB_PROCESS = 0 "
		cQuery += " 	AND SZB.D_E_L_E_T_ = ' '	"
		cQuery += " ORDER BY SZB.R_E_C_N_O_ "
	
		IF SELECT("TRBSZB") > 0
			TRBSZB->( dbCloseArea() )
		ENDIF    
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSZB" ,.F.,.T.)
	
		//-----------------------------------------------------------------------
		// Processa arquivo TRB
		//-----------------------------------------------------------------------
		IF !lJob
			TRBSZB->(dbEval({|| nReg++ },,{|| !Eof()}))
			TRBSZB->(dbGoTop())
		
			ProcRegua( nReg )
		ENDIF	
		
		nProcess 	:= 0
		nErroProc	:= 0
		
		DbSelectArea("TRBSZB")
		DbGoTop()
		DO WHILE ! TRBSZB->( EOF() )
			IF !lJob
				IncProc( "Aguarde..." )
			ENDIF	
	
			DbSelectArea("SZB")
			DbGoTo( TRBSZB->REGSZB )
	
			IF GerTitAB()
				nProcess++
				
				//-----------------------------------------------------------------------
				// Marca como ja processado
				//-----------------------------------------------------------------------
				DbSelectArea("SZB")
				RecLock("SZB", .F. )
				SZB->ZB_PROCESS	:= 1
				SZB->( MsUnLock() )
			ELSE
				nErroProc++
			ENDIF
	
			DbSelectArea("TRBSZB")
			DbSkip()
		ENDDO
		TRBSZB->( DbCloseArea() )
	ENDIF

	IF lJob
		Conout("ASFINA50 - JOB para gerar o abatimento referente à participação dos parceiros: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
	ENDIF
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} GerTitAB()

Gera o abatimento referente à participação dos parceiros no registro SZB
correspondente

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION GerTitAB()

	LOCAL lRet			:= .T.
	LOCAL cFilTit		:= PADR( SZB->ZB_FILTIT, LEN(SE1->E1_FILIAL) )
	LOCAL cPrefixo		:= PADR( SZB->ZB_PREFIXO, LEN(SE1->E1_PREFIXO) )
	LOCAL cNum			:= PADR( SZB->ZB_NUM, LEN(SE1->E1_NUM) )
	LOCAL cParcel		:= PADR( SZB->ZB_PARCELA, LEN(SE1->E1_PARCELA) )
	LOCAL cTpParcel		:= PADR( SZB->ZB_TIPO, LEN(SE1->E1_TIPO) )
	LOCAL cTpAB			:= PADR( "AB-", LEN(SE1->E1_TIPO) )
	LOCAL cOperaca		:= PADR( SZB->ZB_OPERACA, LEN(SZB->ZB_OPERACA) )
	
	LOCAL cCODCOLIGA	:= "" 
	LOCAL cIDLAN		:= ""
	
	LOCAL nPerParc		:= 0
	
	LOCAL aDadosSE1 	:= {}
	LOCAL cFilAux		:= cFilAnt
	
	PRIVATE lMsErroAuto := .F.
	
	IF UPPER(ALLTRIM(cOperaca)) <> "DELETE"
		nPerParc	:= U_ASFINA46( cEMPANT, cFilTit, cPrefixo, cNum, cParcel, cTpParcel, cCODCOLIGA, cIDLAN )
	ENDIF	

	//-----------------------------------------------------------------------
	// Atribui a filial corrente com a filial do título
	//-----------------------------------------------------------------------
	cFilAnt := cFilTit
	nPerParc	:= 30

	IF nPerParc > 0 
		//-----------------------------------------------------------------------
		// Inclui / Altera o título de abatimento
		//-----------------------------------------------------------------------

		DbSelectArea("SE1")
		DbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		IF DbSEEK( cFilTit + cPrefixo + cNum + cParcel + cTpParcel )
			nValAbat 	:= NOROUND( SE1->E1_VALOR * nPerParc / 100, TAMSX3("E1_VALOR")[2] )
			nRegSE1		:= SE1->( RecNo() )

			//-----------------------------------------------------------------------
			// Verifica se já existe AB-
			//-----------------------------------------------------------------------
			DbSelectArea("SE1")
			DbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			IF DbSEEK( cFilTit + cPrefixo + cNum + cParcel + cTpAB )
				lIncluiAB := .F.
				IF SE1->E1_VALOR <> nValAbat
					lAlteraAB := .T.
				ELSE
					lAlteraAB := .F.
				ENDIF
			ELSE
				lIncluiAB := .T.	
				lAlteraAB := .F.		
			ENDIF
			
			IF lIncluiAB
				//-----------------------------------------------------------------------
				// Inclui título AB- para o título posicionado
				//-----------------------------------------------------------------------
				nOpc := 3  
				
				DbSelectArea("SE1")
				SE1->( DbGoTo( nRegSE1 ) )
				
				aDadosSE1 := {}
				aadd(aDadosSE1, {"E1_FILIAL"	, cFilTit			, NIL })
				aadd(aDadosSE1, {"E1_PREFIXO"	, SE1->E1_PREFIXO	, NIL })
				aadd(aDadosSE1, {"E1_NUM"		, SE1->E1_NUM		, NIL })
				aadd(aDadosSE1, {"E1_PARCELA"	, SE1->E1_PARCELA	, NIL })
				aadd(aDadosSE1, {"E1_TIPO"		, "AB-"				, NIL })
				aadd(aDadosSE1, {"E1_CLIENTE"	, SE1->E1_CLIENTE	, NIL })
				aadd(aDadosSE1, {"E1_LOJA"		, SE1->E1_LOJA		, NIL })
				aadd(aDadosSE1, {"E1_EMISSAO"	, SE1->E1_EMISSAO	, NIL })
				aadd(aDadosSE1, {"E1_VENCTO"	, SE1->E1_VENCTO	, NIL })
				aadd(aDadosSE1, {"E1_VENCREA"	, SE1->E1_VENCREA	, NIL })
				aadd(aDadosSE1, {"E1_VALOR"		, nValAbat			, NIL })

				lMsErroAuto := .F.
				MsExecAuto({|x,y| FINA040(x,y)}, aDadosSE1, nOpc)
				IF lMsErroAuto
					IF !lJob
						mostraerro()
					ENDIF	
					lRet := .F.
				ENDIF
			ELSE
				IF lAlteraAB
					//-----------------------------------------------------------------------
					// Altera título AB-
					//-----------------------------------------------------------------------
					nOpc := 4
					
					aDadosSE1 := {}
					aadd(aDadosSE1, {"E1_FILIAL"	, cFilTit			, NIL })
					aadd(aDadosSE1, {"E1_PREFIXO"	, SE1->E1_PREFIXO	, NIL })
					aadd(aDadosSE1, {"E1_NUM"		, SE1->E1_NUM		, NIL })
					aadd(aDadosSE1, {"E1_PARCELA"	, SE1->E1_PARCELA	, NIL })
					aadd(aDadosSE1, {"E1_TIPO"		, SE1->E1_TIPO		, NIL })
					aadd(aDadosSE1, {"E1_CLIENTE"	, SE1->E1_CLIENTE	, NIL })
					aadd(aDadosSE1, {"E1_LOJA"		, SE1->E1_LOJA		, NIL })
					aadd(aDadosSE1, {"E1_EMISSAO"	, SE1->E1_EMISSAO	, NIL })
					aadd(aDadosSE1, {"E1_VENCTO"	, SE1->E1_VENCTO	, NIL })
					aadd(aDadosSE1, {"E1_VENCREA"	, SE1->E1_VENCREA	, NIL })
					aadd(aDadosSE1, {"E1_VALOR"		, nValAbat			, NIL })
	
					lMsErroAuto := .F.
					MsExecAuto({|x,y| FINA040(x,y)}, aDadosSE1, nOpc)
					IF lMsErroAuto
						IF !lJob
							mostraerro()
						ENDIF	
						lRet := .F.
					ENDIF
				ENDIF
			ENDIF
		ELSE
			IF !lJob
				MsgAlert("Título (" + cFilTit + cPrefixo + cNum + cParcel + cTpParcel + ") não localizado!", "Atenção")
			ENDIF	
			lRet := .F.
		ENDIF	
	ELSE
		//-----------------------------------------------------------------------
		// Exclui o título de abatimento
		//-----------------------------------------------------------------------
		DbSelectArea("SE1")
		DbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		IF DbSEEK( cFilTit + cPrefixo + cNum + cParcel + cTpAB )
			nOpc := 5 // exclui título AB-

			aDadosSE1 := {}
			aadd(aDadosSE1, {"E1_FILIAL"	, cFilTit			, NIL })
			aadd(aDadosSE1, {"E1_PREFIXO"	, SE1->E1_PREFIXO	, NIL })
			aadd(aDadosSE1, {"E1_NUM"		, SE1->E1_NUM		, NIL })
			aadd(aDadosSE1, {"E1_PARCELA"	, SE1->E1_PARCELA	, NIL })
			aadd(aDadosSE1, {"E1_TIPO"		, SE1->E1_TIPO		, NIL })
			//aadd(aDadosSE1, {"E1_CLIENTE"	, SE1->E1_CLIENTE	, NIL })
			//aadd(aDadosSE1, {"E1_LOJA"		, SE1->E1_LOJA		, NIL })
			//aadd(aDadosSE1, {"E1_EMISSAO"	, SE1->E1_EMISSAO	, NIL })
			//aadd(aDadosSE1, {"E1_VENCTO"	, SE1->E1_VENCTO	, NIL })
			//aadd(aDadosSE1, {"E1_VENCREA"	, SE1->E1_VENCREA	, NIL })
			//aadd(aDadosSE1, {"E1_VALOR"		, SE1->E1_VALOR		, NIL })

			lMsErroAuto := .F.
			MsExecAuto({|x,y| FINA040(x,y)}, aDadosSE1, nOpc)
			IF lMsErroAuto
				IF !lJob
					mostraerro()
				ENDIF	
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Restaura a filial corrente
	//-----------------------------------------------------------------------
	cFilAnt := cFilAux

RETURN lRet