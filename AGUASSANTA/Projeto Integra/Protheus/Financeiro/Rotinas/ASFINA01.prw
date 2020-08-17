#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA01()

Gera alçada de aprovação do título a pagar na tabela SZ5 e envia ao 
Fluig para aprovação

Chamado pelo PE FA050FIN, F050ALT e FA050DEL

@param		Nenhum
@return		lRet	=	.T. = Continua a operação, .F. = Cancela
			(Valido para a operação de Alteração ou Exclusão)
@author 	Fabio Cazarini
@since 		03/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA01(nOpca)
	LOCAL aArea			:= GetArea()
	LOCAL aAreaSE2		:= SE2->( GetArea() )
	LOCAL lRet			:= .T.
	LOCAL aRegSE2		:= {}
	LOCAL nX			:= 0
	LOCAL cTITPAI		:= ""
	LOCAL cQuery		:= ""
	LOCAL lEXCLUI		:= .F.
	
	LOCAL nValImpost	:= 0 
	LOCAL aRegIMP		:= {}
	LOCAL cNFluig		:= ""
	LOCAL nY			:= 0
	
	IF nOpca <> 1 .AND. nOpca <> 55 
		RETURN .T.
	ENDIF

	//-----------------------------------------------------------------------
	// Somente gera alcada para inclusão manual de título a pagar
	//-----------------------------------------------------------------------	
	IF !(FUNNAME() == 'FINA050' .OR. FUNNAME() == 'FINA750' .OR. SE2->E2_ORIGEM == "FINI050 " )
		RETURN .T.
	ENDIF     
	
	//----------------------------------------------------------------------------------
	// Zema 16/11/17 - Não envia para aprovação titulos de NDF com processo referenciado
	//----------------------------------------------------------------------------------	
	IF SE2->E2_TIPO == "NDF" .AND. !EMPTY(SE2->E2_NUMPRO)
		RECLOCK("SE2",.F.)
		SE2->E2_XSFLUIG := "A"
		MsUnlock()
		RETURN .T.
	ENDIF     

	//----------------------------------------------------------------------------------
	// Zema 14/12/17 - Não envia para aprovação titulos de PR
	//----------------------------------------------------------------------------------	
	IF ALLTRIM(SE2->E2_TIPO) == "PR" .AND. ALLTRIM(SE2->E2_ORIGEM)$"FINI055#FINI050"
		RETURN .T.
	ENDIF     

	
	IF nOpca == 55
		lEXCLUI := .T.
	ENDIF

	IF lRet
		IF SE2->E2_XSFLUIG <> 'R' // solicitação reprovada no Fluig	
			AADD( aRegSE2, SE2->( RECNO() ) ) // adiciona o título principal
		ENDIF	

		//-----------------------------------------------------------------------
		// Monta arquivo com os títulos gerados a partir do título pai
		//-----------------------------------------------------------------------
		cTITPAI := RTRIM(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
	
		cQuery := " SELECT SE2.E2_VALOR AS VALIMPOST, SE2.R_E_C_N_O_  AS REGSE2 "
		cQuery += " FROM " + RetSqlName("SE2") + " SE2 "
		cQuery += " WHERE	SE2.E2_FILIAL = '" + xFILIAL("SE2") + "' " 
		cQuery += " 	AND SE2.E2_TITPAI = '" + cTITPAI + "' "
		cQuery += " 	AND SE2.E2_XSFLUIG <> 'R' "
		cQuery += " 	AND SE2.D_E_L_E_T_ = ' '	"
	
		IF SELECT("TRBSE2") > 0
			TRBSE2->( dbCloseArea() )
		ENDIF    
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSE2" ,.F.,.T.)

		DbSelectArea("TRBSE2")
		DbGoTop()
		nValImpost := 0
		DO WHILE !TRBSE2->( EOF() )
			AADD( aRegIMP, TRBSE2->REGSE2 ) // adiciona os títulso gerados pelo principal (pai)
		
			nValImpost += TRBSE2->VALIMPOST
			
			TRBSE2->( DbSkip() )
		ENDDO
		TRBSE2->( dbCloseArea() )
	
		//-----------------------------------------------------------------------
		// Processa
		//-----------------------------------------------------------------------
		IF ALTERA .OR. lEXCLUI
			FOR nX := 1 TO LEN(aRegSE2)
				DbSelectArea("SE2")
				DbGoTo( aRegSE2[nX] )
				
				IF SE2->E2_XSFLUIG <> "A"  // Zema 01/09/17 - Não localiza o processo no Fluig depois de aprovado
					//-----------------------------------------------------------------------
					// Cancela a solicitação no Fluig
					//-----------------------------------------------------------------------	
					IF !EMPTY(SE2->E2_XNFLUIG) // se o título foi enviado ao Fluig
						U_ASFINA12( ALLTRIM(SE2->E2_XNFLUIG), ALLTRIM(SE2->E2_XAPROVA), "" )
					ENDIF
				ENDIF
				//-----------------------------------------------------------------------
				// Exclui a alcada de aprovação
				//-----------------------------------------------------------------------	
				IF !EMPTY(SE2->E2_XAPRGRU) // se o grupo de aprovação está preenchido
					U_ASFINA40( "PG", SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA), lEXCLUI )
				ENDIF
		
			NEXT nX
		ENDIF
	
		IF INCLUI .OR. ALTERA
			FOR nX := 1 TO LEN(aRegSE2)
				DbSelectArea("SE2")
				DbGoTo( aRegSE2[nX] )
	
				IF ( ALLTRIM(UPPER(SE2->E2_ORIGEM)) == "FINA050" .Or. ALLTRIM(UPPER(SE2->E2_ORIGEM)) == "FINI050" ) .AND. EMPTY(SE2->E2_TITPAI)
					//-----------------------------------------------------------------------
					// Gera a alcada de aprovação do título posicionado
					//-----------------------------------------------------------------------	
					FIGerAlca(nValImpost)
			
					//-----------------------------------------------------------------------
					// Envia a solicitação ao Fluig
					//-----------------------------------------------------------------------	
					IF EMPTY(SE2->E2_XNFLUIG) .AND. !EMPTY(SE2->E2_XAPROVA) // se o título não foi enviado ao Fluig e tem aprovador informado
						cNFluig := U_ASFINA11( SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) )

						//-----------------------------------------------------------------------
						// Atualiza os títulos de impostos a partir do título pai
						//-----------------------------------------------------------------------
						IF !EMPTY( cNFluig )
							FOR nY := 1 TO LEN(aRegIMP)
								DbSelectArea("SE2")
								DbGoTo( aRegIMP[nY] )

								RecLock("SE2", .F.)
								SE2->E2_XSFLUIG := 'E' 
								SE2->( MsUnLock() )
							NEXT nY
						ENDIF
					ENDIF
				ENDIF
			NEXT nX
		ENDIF
	ENDIF
	
	SE2->( RestArea( aAreaSE2 ) )
	RestArea( aArea )
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} FIGerAlca()

Gera a alcada de aprovação do título posicionado

@param		nValImpost = Valor dos impostos retidos
@return		Nenhum
@author 	Fabio Cazarini
@since 		03/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION FIGerAlca(nValImpost)
	LOCAL aAreaSZ5	:= SZ5->( GetArea() )
	LOCAL cPGAPROV	:= ALLTRIM(SuperGetMv("AS_PGAPROV",.T.,"")) 
	LOCAL cQuery	:= ""
	LOCAL lPriNivel	:= .T.

	//-----------------------------------------------------------------------
	// Se o grupo de aprovação do financeiro foi indicado
	//-----------------------------------------------------------------------
	IF !EMPTY(cPGAPROV)
		
		/*
		cQuery 	:= "SELECT DISTINCT "
		cQuery	+= "		SAL.AL_USER, "
		cQuery	+= "		SAL.AL_APROV, " 
		cQuery	+= "		SAL.AL_ITEM, "
		cQuery	+= "		SAL.AL_NIVEL, "
		cQuery	+= "		SAK.AK_TIPO "
		cQuery	+= "FROM " + RetSQLName("SAL") + " SAL "
		cQuery	+= "INNER JOIN " + RetSQLName("SAK") + " SAK ON "
		cQuery	+= "			(		SAK.AK_FILIAL = '" + xFILIAL("SAK") + "' "
		cQuery	+= "				AND SAK.AK_COD = SAL.AL_APROV "
		cQuery	+= "				AND SAK.AK_LIMMIN <= " + STRTRAN(STRTRAN(TRANSFORM(SE2->E2_VALOR+nValImpost, PESQPICT("SE2","E2_VALOR") ),".",""),",",".")
		cQuery	+= "				AND SAK.AK_LIMMAX >= " + STRTRAN(STRTRAN(TRANSFORM(SE2->E2_VALOR+nValImpost, PESQPICT("SE2","E2_VALOR") ),".",""),",",".")
		cQuery	+= "				AND SAK.D_E_L_E_T_ = ' ' "
		cQuery	+= "			) " 
		cQuery	+= "WHERE SAL.AL_FILIAL = '" + xFILIAL("SAL") + "' "	
		cQuery	+= "	AND SAL.AL_COD = '" + cPGAPROV + "' "
		cQuery	+= "	AND SAL.AL_LIBAPR = 'A' "
		cQuery	+= "	AND SAL.D_E_L_E_T_ = ' ' "
		cQuery	+= "ORDER BY AL_NIVEL "
		*/
		
		cQuery 	:= "SELECT DISTINCT "
		cQuery	+= "		SAL.AL_USER, "
		cQuery	+= "		SAL.AL_APROV, " 
		cQuery	+= "		SAL.AL_ITEM, "
		cQuery	+= "		SAL.AL_NIVEL, "
		cQuery	+= "		DHL.DHL_TIPO "
		cQuery	+= "FROM " + RetSQLName("SAL") + " SAL "
		cQuery	+= "INNER JOIN " + RetSQLName("DHL") + " DHL ON "
		cQuery	+= "			(		DHL.DHL_FILIAL = '" + xFILIAL("DHL") + "' "
		cQuery	+= "				AND DHL.DHL_COD = SAL.AL_PERFIL "
		cQuery	+= "				AND DHL.DHL_LIMMIN <= " + STRTRAN(STRTRAN(TRANSFORM(SE2->E2_VALOR+nValImpost, PESQPICT("SE2","E2_VALOR") ),".",""),",",".")
		cQuery	+= "				AND DHL.DHL_LIMMAX >= " + STRTRAN(STRTRAN(TRANSFORM(SE2->E2_VALOR+nValImpost, PESQPICT("SE2","E2_VALOR") ),".",""),",",".")
		cQuery	+= "				AND DHL.D_E_L_E_T_ = ' ' "
		cQuery	+= "			) " 
		cQuery	+= "WHERE SAL.AL_FILIAL = '" + xFILIAL("SAL") + "' "	
		cQuery	+= "	AND SAL.AL_COD = '" + cPGAPROV + "' "
		cQuery	+= "	AND SAL.AL_LIBAPR = 'A' "
		cQuery	+= "	AND SAL.D_E_L_E_T_ = ' ' "
		cQuery	+= "ORDER BY AL_NIVEL "		
		

		IF SELECT("TRBSAL") > 0
			TRBSAL->( dbCloseArea() )
		ENDIF    
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSAL" ,.F.,.T.)

		lPriNivel := .T.
		DbSelectArea("TRBSAL")
		TRBSAL->( DbGoTop() )
		DO WHILE !EOF()
			IF lPriNivel
				RecLock("SE2", .F.)
				//SE2->E2_DATALIB	:= CTOD("//")
				//SE2->E2_USUALIB	:= ""
				//SE2->E2_STATLIB	:= "01"			// 01=Esperando aprovação do usuário, 02=Bloqueado (esperando outros níveis), 03=Movimento liberado pelo usuário, 04=Movimento bloqueado pelo usuário 
				//SE2->E2_CODAPRO	:= ""

				SE2->E2_XAPRGRU	:= cPGAPROV
				SE2->E2_XAPROVA	:= UsrRetName(TRBSAL->AL_USER)
				SE2->E2_XAPRNOM	:= UsrFullName(TRBSAL->AL_USER)
				SE2->E2_XAPRNIV	:= TRBSAL->AL_NIVEL
				SE2->( MsUnLock() )

				lPriNivel := .F.
			ENDIF

			DbSelectArea("SZ5")
			RecLock("SZ5", .T.)
			SZ5->Z5_FILIAL	:= xFILIAL("SZ5") // Filial
			SZ5->Z5_NUM		:= SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) // Documento
			SZ5->Z5_TIPO	:= "PG" // Tipo
			SZ5->Z5_USER	:= TRBSAL->AL_USER // Usuário
			SZ5->Z5_APROV	:= TRBSAL->AL_APROV // Cód.Aprovado
			SZ5->Z5_GRUPO	:= cPGAPROV // Grp.Aprovado
			SZ5->Z5_ITGRP	:= TRBSAL->AL_ITEM // Item Grp.Apr
			SZ5->Z5_NIVEL	:= TRBSAL->AL_NIVEL // Nível
			SZ5->Z5_STATUS	:= "02"// 01=Aguardando nivel anterior;02=Pendente;03=Liberado;04=Bloqueado;05=Liberado outro usuario
			SZ5->Z5_EMISSAO	:= dDATABASE // Dt Emissão
			SZ5->Z5_TOTAL	:= SE2->E2_VALOR+nValImpost // Valor Total
			SZ5->Z5_TIPOLIM	:= TRBSAL->DHL_TIPO // Tipo de Lim.
			SZ5->Z5_MOEDA	:= SE2->E2_MOEDA // Moeda
			SZ5->Z5_TXMOEDA	:= SE2->E2_TXMOEDA // Taxa Moeda
			SZ5->( MsUnLock() )

			DbSelectArea("TRBSAL")
			TRBSAL->( DbSkip() )
		ENDDO
		TRBSAL->( dbCloseArea() )
	ENDIF

	SZ5->( RestArea( aAreaSZ5 ) )

RETURN