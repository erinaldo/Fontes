#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
// Array aProjeto
//-----------------------------------------------------------------------
#DEFINE PROJFILIAL	1	
#DEFINE PROJPROJET	2
#DEFINE PROJNUMCNT	3
#DEFINE PROJTOTCNT	4

#DEFINE TAREFILIAL	1	
#DEFINE TAREPROJET	2
#DEFINE TARENUMCNT	3
#DEFINE TARETAREFA	4
#DEFINE TARETOTCNT	5
#DEFINE TAREQTDCNT	6
#DEFINE TAREPRECNT	7

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA25()

Gera contrato no RM TOP
Elimina resíduo do pedido gerado no TOP - Rotina MA235PC
Chamado pela rotina ASCOMA24

@param		Nenhum 
@return		Nenhum 
@author 	Fabio Cazarini
@since 		27/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA25()
	LOCAL aArea		:= GetArea()
	LOCAL aAreaSC7	:= SC7->( GetArea() )
	LOCAL nOpc		:= 0
	LOCAL aSay   	:= {}
	LOCAL aButton	:= {}    
	LOCAL cDesc1	:= OemToAnsi("O objetivo desta rotina é gerar o contrato no RM TOP a      ")
	LOCAL cDesc2	:= OemToAnsi("partir do pedido posicionado no browse.                     ")
	LOCAL cDesc3	:= OemToAnsi("")
	LOCAL cDesc4	:= OemToAnsi("Pedido: " + SC7->C7_NUM)
	LOCAL cDesc5	:= OemToAnsi("Emissão: " + DTOC(SC7->C7_EMISSAO))
	LOCAL cDesc6	:= OemToAnsi("Fornecedor: " + GETADVFVAL("SA2","A2_NREDUZ",xFILIAL("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA ,1,"") )
	LOCAL cDesc7  	:= OemToAnsi("")
	LOCAL aSC7Recno	:= {}
	LOCAL cCntRM	:= 0

	PRIVATE cCRLF		:= CHR(13) + CHR(10)
	PRIVATE cCadastro 	:= OEMTOANSI("Gerar contrato no RM TOP")

	//-----------------------------------------------------------------------
	// Mensagens de Tela Inicial
	//-----------------------------------------------------------------------
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
	aAdd( aSay, cDesc6 )
	aAdd( aSay, cDesc7 )

	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSay, aButton )

	IF nOpc == 1	
		//-----------------------------------------------------------------------
		// Gera o contrato no RM TOP
		//-----------------------------------------------------------------------
		Processa({|| cCntRM := ProcCNTRM()},"Processando")

		IF !EMPTY(cCntRM)
			MsgInfo("Contrato(s) no RM TOP gerado(s):" + cCRLF + cCRLF + cCntRM, "Ok")
		ENDIF	
	ENDIF

	SC7->( RestArea( aAreaSC7 ) )
	RestArea( aArea )

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ProcCNTRM()

Gera o contrato no RM TOP

@param		Nenhum 
@return		cRet		= 	Número do contrato gerado no RM TOP
@author 	Fabio Cazarini
@since 		27/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ProcCNTRM()
	LOCAL cRet		:= ""
	LOCAL aProjeto	:= {}
	LOCAL nPosPROJET:= 0
	LOCAL cQuery	:= ""
	LOCAL cXMLSend	:= ""
	LOCAL cRETCont	:= ""
	LOCAL lRETSend	:= .T.
	LOCAL nRegSC7	:= SC7->( RECNO() )
	LOCAL nTOTMERC	:= 0
	LOCAL nTOTSEGU	:= 0
	LOCAL nTOTDESP	:= 0
	LOCAL cITEMPC	:= ""
	LOCAL nQUANT	:= 0
	LOCAL nTOTAL	:= 0
	LOCAL nVALIPI	:= 0
	LOCAL nVLDESC	:= 0
	LOCAL nSEGURO	:= 0
	LOCAL nDESPESA	:= 0
	LOCAL cNUMSC 	:= ""
	LOCAL cITEMSC	:= ""
	LOCAL lTemAFG	:= .F.
	LOCAL nTOTAJ7	:= 0
	LOCAL nQUANTTAR	:= 0
	LOCAL nX		:= 0
	LOCAL cIDPRJ	:= ""
	LOCAL cIDCNT	:= "" 
	LOCAL cFILPROJ	:= cEMPANT + cFILANT
	LOCAL aProjRec	:= {}
	LOCAL nPosProjRe:= 0
	LOCAL nY		:= 0
	LOCAL aRecElim	:= {}
	LOCAL nZ		:= 0
	LOCAL aTarefa	:= {}
	LOCAL nPosTarefa:= 0

	LOCAL nPerc			:= 100
	LOCAL cTipo 		:= 1
	LOCAL dEmisDe 		:= CTOD("//")
	LOCAL dEmisAte 		:= CTOD("31/12/2049")
	LOCAL cNumeroPed 	:= ""
	LOCAL cProdDe 		:= ""
	LOCAL cProdAte 		:= REPLICATE("Z", TAMSX3("C7_PRODUTO")[1])
	LOCAL cFornDe 		:= ""
	LOCAL cFornAte 		:= REPLICATE("Z", TAMSX3("C7_FORNECE")[1])
	LOCAL dDatprfde 	:= CTOD("//")
	LOCAL dDatPrfAte 	:= CTOD("31/12/2049")
	LOCAL cItemDe 		:= ""
	LOCAL cItemAte 		:= REPLICATE("Z", TAMSX3("C7_ITEM")[1])
	LOCAL lConsEIC 		:= .T.
	LOCAL aRecSC7		:= {}
	LOCAL aRet235		:= {}
	
	LOCAL nPeriodos 	:= 0 
	LOCAL dDATPRF 		:= dDATABASE
 	LOCAL nK 			:= 0
 	LOCAL cRETPer		:= ""
 	LOCAL cRETIte		:= ""
 	LOCAL nJ 			:= 0
 	LOCAL cCODEMPde		:= ""
	LOCAL cCODFILde		:= ""
	LOCAL lGerCtRM		:= .F.
	
	LOCAL cFORNRM		:= ""
	LOCAL aCODRM		:= {}
	LOCAL cCODFILIRM	:= ""
	LOCAL cCODCOLIRM	:= ""
	LOCAL cCONDRM		:= ""
	LOCAL cLOCARM		:= ""
	
	ProcRegua( 0 )
	IncProc( "Aguarde..." )

	//-----------------------------------------------------------------------
	// Monta arquivo TRBSC7 com os itens aptos
	//-----------------------------------------------------------------------
	cQuery := " SELECT SC7.R_E_C_N_O_  AS REGSC7 "
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
	cQuery += " WHERE	SC7.C7_FILIAL = '" + xFILIAL("SC7") + "' " 
	cQuery += " 	AND SC7.C7_NUM = '" + SC7->C7_NUM + "' "
	cQuery += " 	AND SC7.C7_XEHCT = '1' "
	cQuery += " 	AND SC7.C7_XSFLUIG = 'A' "
	cQuery += " 	AND SC7.C7_QUANT > C7_QUJE "
	cQuery += " 	AND SC7.C7_RESIDUO = ' ' "
	cQuery += " 	AND SC7.C7_CONAPRO = 'L' "
	cQuery += " 	AND SC7.C7_XCNTTOP = ' ' "
	cQuery += " 	AND SC7.D_E_L_E_T_ = ' '	"

	IF SELECT("TRBSC7") > 0
		TRBSC7->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSC7" ,.F.,.T.)

	//-----------------------------------------------------------------------
	// Calcula totais
	//-----------------------------------------------------------------------
	nTOTMERC	:= 0
	nTOTSEGU	:= 0
	nTOTDESP	:= 0
	TRBSC7->( DbGoTop() )
	DO WHILE !TRBSC7->( EOF() )
		IncProc( "Aguarde..." )
		
		SC7->( DbGoTo( TRBSC7->REGSC7 ) )

		nTOTMERC	+= SC7->C7_TOTAL
		nTOTSEGU	+= SC7->C7_SEGURO
		nTOTDESP	+= SC7->C7_DESPESA
	
		TRBSC7->( DbSkip() )
	ENDDO
	
	//-----------------------------------------------------------------------
	// Monta array com os itens aptos
	//-----------------------------------------------------------------------
	aProjeto 	:= {}
	aProjRec 	:= {}
	aTarefa		:= {}
	TRBSC7->( DbGoTop() )
	DO WHILE !TRBSC7->( EOF() )
		IncProc( "Aguarde..." )
		
		DbSelectArea("SC7")
		DbGoTo( TRBSC7->REGSC7 )

		cITEMPC		:= SC7->C7_ITEM
		nQUANT		:= SC7->C7_QUANT
		nTOTAL		:= SC7->C7_TOTAL
		nVALIPI		:= SC7->C7_VALIPI
		nVLDESC		:= SC7->C7_VLDESC
		nSEGURO		:= NOROUND(nTOTAL / nTOTMERC * nTOTSEGU, TAMSX3("C7_SEGURO")[2])
		nDESPESA	:= NOROUND(nTOTAL / nTOTMERC * nTOTDESP, TAMSX3("C7_DESPESA")[2])
		cNUMSC 		:= SC7->C7_NUMSC
		cITEMSC		:= SC7->C7_ITEMSC

		lTemAFG := .F.
		IF !EMPTY(cNUMSC) .AND. !EMPTY(cITEMSC)
			DbSelectArea("AFG")
			DbSetOrder(2) // AFG_FILIAL+AFG_NUMSC+AFG_ITEMSC+AFG_PROJET+AFG_REVISA+AFG_TAREFA
			IF MsSeek(xFilial("AFG")+cNUMSC+cITEMSC)
				lTemAFG := .T. // Projeto foi lançado na SC
				//-----------------------------------------------------------------------
				// AFG - Projetos e tarefas 
				//-----------------------------------------------------------------------
				DO WHILE !AFG->( EOF() ) .AND. AFG->(AFG_FILIAL+AFG_NUMSC+AFG_ITEMSC) == xFilial("AFG")+cNUMSC+cITEMSC
					nTOTAJ7 	:= (nTOTAL + nVALIPI - nVLDESC + nSEGURO + nDESPESA) / nQUANT * AFG->AFG_QUANT
					nQUANTTAR	:= AFG->AFG_QUANT

					IF !EMPTY(AFG->AFG_XCONTR) 
						//-----------------------------------------------------------------------
						// AFG - Adiciona na array de projetos - para gerar o projeto no RM TOP 
						//-----------------------------------------------------------------------
						nPosPROJET := aSCAN( aProjeto, {|x| x[PROJFILIAL]+x[PROJPROJET]+x[PROJNUMCNT] == cFILPROJ+AFG->AFG_PROJET+AFG->AFG_XCONTR })
						IF nPosPROJET == 0
							AADD( aProjeto, {cFILPROJ, AFG->AFG_PROJET, AFG->AFG_XCONTR, nTOTAJ7} )
						ELSE
							aProjeto[nPosPROJET][PROJTOTCNT] += nTOTAJ7
						ENDIF	

						//-----------------------------------------------------------------------
						// AFG - Adiciona na array de tarefas - para gerar o projeto no RM TOP 
						//-----------------------------------------------------------------------
						nPosTarefa := aSCAN( aTarefa, {|x| x[TAREFILIAL]+x[TAREPROJET]+x[TARENUMCNT]+x[TARETAREFA] == cFILPROJ+AFG->AFG_PROJET+AFG->AFG_XCONTR+AFG->AFG_TAREFA })
						IF nPosTarefa == 0
							AADD( aTarefa, {cFILPROJ, AFG->AFG_PROJET, AFG->AFG_XCONTR, AFG->AFG_TAREFA, nTOTAJ7, nQUANTTAR, nTOTAJ7/nQUANTTAR} )
						ELSE
							aTarefa[nPosTAREFA][TARETOTCNT] += nTOTAJ7
							aTarefa[nPosTAREFA][TAREQTDCNT] += nQUANTTAR
						ENDIF	
						
						//-----------------------------------------------------------------------
						// Array para controlar os recnos da SC7 x Projeto 
						//-----------------------------------------------------------------------
						nPosProjRe := aSCAN( aProjRec, {|x| x[1]+x[2]+x[3]+ALLTRIM(STR(x[4])) == cFILPROJ + AFG->AFG_PROJET + AFG->AFG_XCONTR + ALLTRIM(STR(TRBSC7->REGSC7)) })
						IF nPosProjRe == 0
							AADD( aProjRec, {cFILPROJ, AFG->AFG_PROJET, AFG->AFG_XCONTR, TRBSC7->REGSC7} )
						ENDIF
					ENDIF

					AFG->( DbSkip() )
				ENDDO
			ENDIF
		ENDIF
		
		IF !lTemAFG // Se o projeto não foi lançado na SC
			//-----------------------------------------------------------------------
			// AJ7 - Projetos e tarefas 
			//-----------------------------------------------------------------------
			dbSelectArea("AJ7")
			dbSetOrder(2)
			IF MsSeek(xFilial("AJ7")+SC7->C7_NUM+SC7->C7_ITEM)
				DO WHILE !AJ7->( EOF() ) .AND. xFilial("AJ7")+SC7->(C7_NUM+C7_ITEM) == AJ7->(AJ7_FILIAL+AJ7_NUMPC+AJ7_ITEMPC)
					nTOTAJ7 	:= (nTOTAL + nVALIPI - nVLDESC + nSEGURO + nDESPESA) / nQUANT * AJ7->AJ7_QUANT
					nQUANTTAR	:= AJ7->AJ7_QUANT
					
					IF !EMPTY(AJ7->AJ7_XCONTR)

						//-----------------------------------------------------------------------
						// AJ7 - Adiciona na array de projetos - para gerar o projeto no RM TOP 
						//-----------------------------------------------------------------------
						nPosPROJET := aSCAN( aProjeto, {|x| x[PROJFILIAL]+x[PROJPROJET]+x[PROJNUMCNT] == cFILPROJ+AJ7->AJ7_PROJET+AJ7->AJ7_XCONTR })
						IF nPosPROJET == 0
							AADD( aProjeto, {cFILPROJ, AJ7->AJ7_PROJET, AJ7->AJ7_XCONTR, nTOTAJ7} )
						ELSE
							aProjeto[nPosPROJET][PROJTOTCNT] += nTOTAJ7
						ENDIF	

						//-----------------------------------------------------------------------
						// AJ7 - Adiciona na array de tarefas - para gerar o projeto no RM TOP 
						//-----------------------------------------------------------------------
						nPosTarefa := aSCAN( aTarefa, {|x| x[TAREFILIAL]+x[TAREPROJET]+x[TARENUMCNT]+x[TARETAREFA] == cFILPROJ+AJ7->AJ7_PROJET+AJ7->AJ7_XCONTR+AJ7->AJ7_TAREFA })
						IF nPosTarefa == 0
							AADD( aTarefa, {cFILPROJ, AJ7->AJ7_PROJET, AJ7->AJ7_XCONTR, AJ7->AJ7_TAREFA, nTOTAJ7, nQUANTTAR, nTOTAJ7/nQUANTTAR} )
						ELSE
							aTarefa[nPosTAREFA][TARETOTCNT] += nTOTAJ7
							aTarefa[nPosTAREFA][TAREQTDCNT] += nQUANTTAR
						ENDIF	
						
						//-----------------------------------------------------------------------
						// Array para controlar os recnos da SC7 x Projeto 
						//-----------------------------------------------------------------------
						nPosProjRe := aSCAN( aProjRec, {|x| x[1]+x[2]+x[3]+ALLTRIM(STR(x[4])) == cFILPROJ + AJ7->AJ7_PROJET + AJ7->AJ7_XCONTR + ALLTRIM(STR(TRBSC7->REGSC7)) })
						IF nPosProjRe == 0
							AADD( aProjRec, {cFILPROJ, AJ7->AJ7_PROJET, AJ7->AJ7_XCONTR, TRBSC7->REGSC7} )
						ENDIF
					ENDIF
				
					AJ7->( DbSkip() )
				ENDDO	
				
			ENDIF
						
		ENDIF
		
		TRBSC7->( DbSkip() )
	ENDDO
	TRBSC7->( dbCloseArea() )

	//-----------------------------------------------------------------------
	// Gera o contrato no RM TOP
	//-----------------------------------------------------------------------
	aRecElim := {}
	IF LEN(aProjeto) > 0
		DbSelectArea("SC7")
		DbGoTo( nRegSC7 )

		//------------------------------------------------------------------------------
		// Retorna o código da filial (aRET[1]) e o código da coligada (aRET[2]) no RM
		//------------------------------------------------------------------------------
		cCODEMPde	:= LEFT(cFILPROJ, LEN(cEMPANT) ) 
		cCODFILde	:= RIGHT(cFILPROJ, LEN(cFILANT) )

		aCODRM		:= U_ASCOMA34( cCODEMPde, cCODFILde )
		cCODFILIRM	:= ALLTRIM(aCODRM[1]) // código da filial no RM
		cCODCOLIRM	:= ALLTRIM(aCODRM[2]) // código da coligada no RM

		//-----------------------------------------------------------------------
		// Monta XML para envio
		//-----------------------------------------------------------------------
		FOR nX := 1 TO LEN( aProjeto )
			//-----------------------------------------------------------------------
			// Buscar IDPRJ na MPRJ
			//-----------------------------------------------------------------------
			cIDPRJ	:= U_ASCOMA35( cCODCOLIRM, aProjeto[nX][PROJPROJET] )
			cIDPRJ	:= ALLTRIM(cIDPRJ)

			//-----------------------------------------------------------------------
			// Buscar External value do RM
			//-----------------------------------------------------------------------
			cFORNRM	:= CFGA070Ext("RM","SA2","A2_COD", ALLTRIM(cEMPANT) + "|" + ALLTRIM(XFILIAL("SA2")) + "|" + ALLTRIM(SC7->C7_FORNECE) + "|" + ALLTRIM(SC7->C7_LOJA) + "|F")
			cFORNRM	:= ALLTRIM(SUBSTR( cFORNRM, RAT("|", cFORNRM) + 1, LEN(cFORNRM) )) 
			
			cCONDRM	:= CFGA070Ext("RM","SE4","E4_CODIGO", ALLTRIM(cEMPANT) + "|" + ALLTRIM(XFILIAL("SE4")) + "|" + ALLTRIM(SC7->C7_COND) )
			cCONDRM	:= ALLTRIM(SUBSTR( cCONDRM, RAT("|", cCONDRM) + 1, LEN(cCONDRM) ))

			cLOCARM	:= CFGA070Ext("RM","NNR","NNR_CODIGO", ALLTRIM(cEMPANT) + "|" + ALLTRIM(XFILIAL("NNR")) + "|" + ALLTRIM(SC7->C7_LOCAL) )
			cLOCARM	:= ALLTRIM(SUBSTR( cLOCARM, RAT("|", cLOCARM) + 1, LEN(cLOCARM) ))
			
			//-----------------------------------------------------------------------
			// PrjContratoData
			//-----------------------------------------------------------------------
			dDATPRF := IIF(EMPTY(SC7->C7_DATPRF),SC7->C7_EMISSAO,SC7->C7_DATPRF)
			
			cXMLSend := '<![CDATA['
			cXMLSend += '<MCNT>'
			cXMLSend += '	<CODCOLIGADA>' + cCODCOLIRM + '</CODCOLIGADA>' // Código da empresa / grupo de empresas
			cXMLSend += '	<IDPRJ>' + cIDPRJ + '</IDPRJ>' // Buscar IDPRJ na MPRJ
			cXMLSend += '	<IDCNT>-1</IDCNT>' // Identificador do contrato – Acessar tabela ANE e buscar código do contrato, com este acessar a tabela MCNT do RM e buscar IDPRJ.
			cXMLSend += '	<NUMCNT>' + ALLTRIM(aProjeto[nX][PROJNUMCNT]) + '</NUMCNT>' // Acessar tabela ANE e buscar código do contrato,
			cXMLSend += '	<DATACONTRATO>' + ALLTRIM(STR(YEAR(SC7->C7_EMISSAO))) + '-' + ALLTRIM(STR(MONTH(SC7->C7_EMISSAO))) + '-' + ALLTRIM(STR(DAY(SC7->C7_EMISSAO))) + '</DATACONTRATO>' // Data geração pedido – C7_EMISSAO
			cXMLSend += '	<DATAINICIO>' + ALLTRIM(STR(YEAR(SC7->C7_EMISSAO))) + '-' + ALLTRIM(STR(MONTH(SC7->C7_EMISSAO))) + '-' + ALLTRIM(STR(DAY(SC7->C7_EMISSAO))) + '</DATAINICIO>' // Data geração pedido – C7_EMISSAO
			cXMLSend += '	<DATAFIM>' + ALLTRIM(STR(YEAR(dDATPRF))) + '-' + ALLTRIM(STR(MONTH(dDATPRF))) + '-' + ALLTRIM(STR(DAY(dDATPRF))) + '</DATAFIM>' // Data Entrega - C7_DATPRF
			cXMLSend += '	<VALORCONTRATO>' + ALLTRIM(TRANSFORM(aProjeto[nX][4], STRTRAN(PESQPICT("SC7", "C7_TOTAL"),',',''))) + '</VALORCONTRATO>' // Valor Pedido – C7_TOTAL
			cXMLSend += '	<VALORADITIVO>0.0000</VALORADITIVO>' // Se houver será utilizado no TOP
			cXMLSend += '	<PERIODICIDADEMED>30</PERIODICIDADEMED>' // Número de meses entre C7_DATPRF e C7_EMISSAO (30=MENSAL)
			cXMLSend += '	<NUMERODIAS></NUMERODIAS>' // Não obrigatório
			cXMLSend += '	<TIPO>P</TIPO>' // Tipo contrato = P - Pagar
			cXMLSend += '	<CODCOLCFO>' + cCODCOLIRM + '</CODCOLCFO>' // Código da empresa / grupo de empresas
			cXMLSend += '	<CODCFO>' + cFORNRM + '</CODCFO>' // Còdigo do Fornecedor – C7_FORNECE
			cXMLSend += '	<NOMEFANTASIA>' + GETADVFVAL("SA2","A2_NOME",xFILIAL("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA ,1,"") + '</NOMEFANTASIA>' // Razão Social buscar na SA2
			cXMLSend += '	<TOTALIZADOR>0</TOTALIZADOR>' // Não obrigatório
			cXMLSend += '	<IDCNTTOTALIZADOR></IDCNTTOTALIZADOR>' // Identificador do contrato – Acessar tabela ANE e buscar código do contrato, com este acessar a tabela MCNT do RM e buscar IDPRJ.
			cXMLSend += '	<ADITIVOPRAZO>0</ADITIVOPRAZO>' // Se houver será utilizado no TOP
			cXMLSend += '	<VLRRETENCAO>0.0000</VLRRETENCAO>' // Se houver será utilizado no TOP
			cXMLSend += '	<TIPORETMEDICAO>0</TIPORETMEDICAO>' // Se houver será utilizado no TOP
			cXMLSend += '	<PERCRETMED>0.0000</PERCRETMED>' // Se houver será utilizado no TOP
			cXMLSend += '	<IDMOVDEFAULT>1.1.04</IDMOVDEFAULT>' // Default 1.2.01 devido a integração
			cXMLSend += '	<TIPOMOVRETDEFAULT>1.2.01</TIPOMOVRETDEFAULT>' // Default 1.2.01 devido a integração
			cXMLSend += '	<CODCPG>' + cCONDRM + '</CODCPG>' // Condição de Pagamento - C7_COND
			cXMLSend += '	<STATUS>0</STATUS>' // Status – 0 - Ativo
			cXMLSend += '	<FORMULAVALORLIBERACAO>A</FORMULAVALORLIBERACAO>' // Formula – A – Valor com Reajuste – Retenções
			cXMLSend += '	<CODTMVESTORNODEFAULT>1.1.04</CODTMVESTORNODEFAULT>' // Default 1.1.04 integração
			cXMLSend += '	<CODFILIALDEFAULT>' + cCODFILIRM + '</CODFILIALDEFAULT>' // Filial Protheus
			cXMLSend += '	<CODLOCDEFAULT>' + cLOCARM + '</CODLOCDEFAULT>' // Local de Estoque default: 01
			cXMLSend += '	<TIPOSRVREV>S</TIPOSRVREV>' // Não obrigatório – “S”
			cXMLSend += '	<TOTALMEDICAO>0.0000</TOTALMEDICAO>' // Operação no TOP
			cXMLSend += '	<SALDOCONTRATUAL>' + ALLTRIM(TRANSFORM(aProjeto[nX][4], STRTRAN(PESQPICT("SC7", "C7_TOTAL"),',',''))) + '</SALDOCONTRATUAL>' // Valor Contrato C7_TOTAL
			cXMLSend += '	<TIPOITEMCONTRATO>T</TIPOITEMCONTRATO>' // Tipo de Planilha – “T”
			cXMLSend += '	<CNTMATERIAL>S</CNTMATERIAL>' // Tipo Contrato – “S” - Serviços
			cXMLSend += '	<QTDEPARCELAS>1</QTDEPARCELAS>' //- Quantidade de Parcelas - 1
			cXMLSend += '	<USATIMESHEET>0</USATIMESHEET>' //- Usado para TOP Mobile - 0
			cXMLSend += '	<MEDICAOACIMADECEM>4</MEDICAOACIMADECEM>' // Permite medição acima de 100% - “4”
			cXMLSend += '	<TIPOREAJUSTE>0</TIPOREAJUSTE>' // Tipo Reajuste – “0”
			cXMLSend += '	<Icone>2</Icone>'
			cXMLSend += '</MCNT>'
			cXMLSend += ']]>'
	
			//-----------------------------------------------------------------------
			// Envia XML para o RM TOP - PrjContratoData
			//-----------------------------------------------------------------------
			lGerCtRM	:= .F.
			lRETSend	:= U_ASCOMA26(cCODCOLIRM, "PrjContratoData", cIDPRJ, cXMLSend, @cRETCont)
			
			IF lRETSend
				lGerCtRM := .T. // Gerou contrato no TOP
				
				//-----------------------------------------------------------------------
				// Identificador do contrato –1 = Gerar a próxima sequência 
				//-----------------------------------------------------------------------
				cIDCNT	:= SUBSTR( cRETCont, RAT(";", cRETCont) + 1, LEN(cRETCont) )

				//-----------------------------------------------------------------------
				// PrjContratoAssociarItemProc
				//-----------------------------------------------------------------------
				IF LEN(aTarefa) > 0
					cXMLSend := '<![CDATA['
				
					cXMLSend += '<PrjContratoAssociarItemParams>'
					cXMLSend += '<CodColigada>' + cCODCOLIRM + '</CodColigada>' // Código da empresa / grupo de empresas
					cXMLSend += '<IdPrj>' + cIDPRJ + '</IdPrj>' // Projeto – AJ7_PROJET, buscar IDPRJ na MPRJ
					cXMLSend += '<IdCnt>' + cIDCNT + '</IdCnt>' // identificador do contrato – Acessar tabela ANE e buscar código do contrato, com este acessar a tabela MCNT do RM e buscar IDCNT.
					cXMLSend += '<NumeroAditivo></NumeroAditivo>'
					cXMLSend += '<RateioAutomatico>true</RateioAutomatico>'
					cXMLSend += '<TipoPlanilha></TipoPlanilha>'
					cXMLSend += '<Tarefas>'
					
					FOR nJ := 1 TO LEN(aTarefa)
						cXMLSend += '<PrjContratoItensItem>'
						cXMLSend += '<IdItmCnt>-1</IdItmCnt>'
						cXMLSend += '<IdTrf></IdTrf>'
						cXMLSend += '<CodTrf>' + ALLTRIM(aTarefa[nJ][TARETAREFA]) + '</CodTrf>'
						cXMLSend += '<QuantidadeAssociada>' + ALLTRIM(TRANSFORM(aTarefa[nJ][TAREQTDCNT], STRTRAN(PESQPICT("SC7", "C7_QUANT"),',','') )) + '</QuantidadeAssociada>'
						cXMLSend += '<ValorAssociado>' + ALLTRIM(TRANSFORM(aTarefa[nJ][TAREPRECNT], STRTRAN(PESQPICT("SC7", "C7_PRECO"),',','') )) + '</ValorAssociado>'
						cXMLSend += '<Status>'
						cXMLSend += '<enum>Incluir</enum>'
						cXMLSend += '</Status>'
						cXMLSend += '</PrjContratoItensItem>'
					NEXT nJ

					cXMLSend += '</Tarefas>'
					cXMLSend += '</PrjContratoAssociarItemParams>'
					
					cXMLSend += ']]>'
	
					//-----------------------------------------------------------------------
					// Envia XML para o RM TOP - PrjContratoAssociarItemProc
					//-----------------------------------------------------------------------
					lRETSend := U_ASCOMA36(cCODCOLIRM, "PrjContratoAssociarItemProc", cIDPRJ, cXMLSend, @cRETIte)
					
					IF !lRETSend
						cRETCont := cRETIte
					ENDIF
				ENDIF	 
			ENDIF
			
			//-----------------------------------------------------------------------
			// Atualiza a SC7, indicando que foi gerado o contrato no RM TOP
			//-----------------------------------------------------------------------
			IF lRETSend
				cRETCont := ALLTRIM(LEFT(cRETCont, LEN(SC7->C7_XCNTTOP)))
				FOR nY := 1 TO LEN(aProjRec)
					IF aProjRec[nY][01] + aProjRec[nY][02] + aProjRec[nY][03] == aProjeto[nX][PROJFILIAL] + aProjeto[nX][PROJPROJET] + aProjeto[nX][PROJNUMCNT]
						DbSelectArea("SC7")
						SC7->( DbGoTo(aProjRec[nY][04]) )
						IF EMPTY( SC7->C7_XCNTTOP )
							IF RecLock("SC7", .F.)
								SC7->C7_XCNTTOP := cRETCont
								SC7->( MsUnLock() )
						
								IF !(ALLTRIM(aProjeto[nX][PROJPROJET]) $ cRet)
									IF !EMPTY(cRet)
										cRet += ", "
									ENDIF
									cRet += ALLTRIM(aProjeto[nX][PROJPROJET])
								ENDIF
								
								//-----------------------------------------------------------------------
								// Adiciona o C7_NUM na array para eliminar residuo do PC
								//-----------------------------------------------------------------------
								IF aSCAN( aRecElim, SC7->C7_NUM ) == 0
									AADD( aRecElim, SC7->C7_NUM )
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				NEXT nY
			ELSE
				IF lGerCtRM	// Se Gerou contrato no TOP, mas não associou nenhum item
					cRETCont += cCRLF + cCRLF + "O contrato " + ALLTRIM(aProjeto[nX][PROJNUMCNT]) + " foi gerado, mas não foi possível associar itens a ele. É necessário excluir o contrato gerado no RM TOP para depois gerá-lo novamente."  
				ELSE
					cRETCont += cCRLF + cCRLF + "O contrato não foi gerado no RM TOP."				
				ENDIF
				
				MsgAlert( cRETCont, "Atenção" )			
			ENDIF
		NEXT nX

		//-----------------------------------------------------------------------
		// Elimna residuo do PC
		//-----------------------------------------------------------------------
		FOR nZ := 1 TO LEN(aRecElim)
			cNumeroPed := aRecElim[nZ]

			//-----------------------------------------------------------------------
			// Pedido originado no Protheus (Pedido originado no RM TOP não permite 
			// elimiar resíduo)
			// Eliminar resíduo através da rotina MA235PC
			//-----------------------------------------------------------------------
			aRet235	:= {}
			aRet235	:= A235ELIRM(cNumeroPed,cNumeroPed) //  Função para validar se o pedido de compra foi originado pelo RM SOLUM
			
			IF aRet235[1] //  Pedido originado no Protheus (não é do SOLUM)
				MA235PC(nPerc, cTipo, dEmisDe, dEmisAte, cNumeroPed, cNumeroPed, cProdDe, cProdAte, cFornDe, cFornAte, dDatprfde, dDatPrfAte, cItemDe, cItemAte, lConsEIC,aRecSC7)
			ENDIF	
		NEXT nZ
	ELSE
		MsgAlert("Não existem itens aptos a gerar contrato no TOP", "Atenção")
	ENDIF

	DbSelectArea("SC7")
	DbGoTo( nRegSC7 )

RETURN cRet