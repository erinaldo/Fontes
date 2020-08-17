#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA42()

Mútuo de pagamentos:
- Baixa o título origem por dação na filial origem
- Movimento bancário na filial pagadora

Chamado pelo PE F430BXA, SE5FI080 e FINA090

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		25/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra 
@releases   16/05/17 - Zema: 	- Ajustar o banco de movimento bancário pagador de acordo com o borderô de pagamento
                                - Gerar Movimento no banco mutuo
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA42()
	LOCAL aArea			:= GetArea()
	LOCAL aAreaSE5		:= SE5->( GetArea() )
	LOCAL aAreaFK7		:= FK7->( GetArea() )
	LOCAL aAreaFK2		:= FK2->( GetArea() )
	LOCAL aAreaFKA		:= FKA->( GetArea() )
	LOCAL aAreaFK5		:= FK5->( GetArea() )
	
	LOCAL cChaveSE2 	:= SE2->E2_FILIAL + "|" + SE2->E2_PREFIXO + "|" + SE2->E2_NUM + "|" + SE2->E2_PARCELA + "|" + SE2->E2_TIPO + "|" + SE2->E2_FORNECE + "|" + SE2->E2_LOJA
	LOCAL cQuery		:= ""
	LOCAL cFK7_IDDOC	:= ""
	LOCAL cFK2_IDFK2	:= ""
	LOCAL cFKA_IDPROC	:= ""
	LOCAL cFKA_IDORIG	:= ""
	LOCAL cMOTBAI		:= ""
	LOCAL cE2_FILIAL	:= SE2->E2_FILORIG
	LOCAL cFILAUX		:= cFilAnt

	PRIVATE cE5_FILIAL	:= ""
	PRIVATE dE5_DATA	:= CTOD("//")
	PRIVATE	cE5_DOCUMEN	:= ""
	PRIVATE	cE5_TIPO	:= ""
	PRIVATE	cE5_MOTBX	:= ""
	PRIVATE	cE5_TIPODOC	:= ""
	PRIVATE	cE5_MOEDA	:= ""
	PRIVATE	nE5_VALOR	:= ""
	PRIVATE	cE5_NATUREZ	:= GETNEWPAR( "AS_NATMUT", "0000000004", SE2->E2_FILIAL )
	PRIVATE	cE5_BANCO	:= ""
	PRIVATE	cE5_AGENCIA	:= ""
	PRIVATE	cE5_CONTA	:= ""
	PRIVATE	cE5_BENEF	:= ""
	PRIVATE	cE5_HISTOR	:= ""
	PRIVATE cE5_ORIGEM	:= PADR("ASFINA42", TAMSX3("E5_ORIGEM")[1])
	PRIVATE	cE5_XBCOFIL	:= ""         
	PRIVATE cFilPag		:= ""                 
	PRIVATE cLoteMut	:= U_ASFINA56()

	cFUN := ""
	IF ISINCALLSTACK("U_SE5FI080")
		cFUN := "U_SE5FI080"
	ELSEIF ISINCALLSTACK("U_FINA090")
		cFUN := "U_FINA090"
	ELSEIF ISINCALLSTACK("U_F430BXA")
		cFUN := "U_F430BXA"
	ENDIF
	
//	ALERT( "CAL:" + cFUN + " FUN: " + FUNNAME() + " NUM: " + SE2->E2_NUM + " PRE: " + SE2->E2_PREFIXO + " E5_NUM: " + SE5->E5_NUMERO + " E5_PRE: " + SE5->E5_PREFIXO )
	
	IF SE2->E2_XBCOFIL <> cFilAnt .AND. !EMPTY(SE2->E2_XBCOFIL) // se for pagamento de mutuo
		
		//-----------------------------------------------------------------------
		// Alterar E5_FILIAL
		// Alterar E5_TIPODOC para BA
		// Alterar E5_MOTBX para MUT
		// Limpar E5_BANCO, E5_AGENCIA, E5_CONTA
		//-----------------------------------------------------------------------
		IF SE5->E5_TIPODOC = "VL"
			cMOTBAI 	:= GETNEWPAR( "AS_MOTMUT", "MUT", SE2->E2_FILIAL )
			cFilPag		:= SE2->E2_XBCOFIL
			cE5_FILIAL	:= SUBSTR(SE2->E2_XBCOFIL,1,LEN(ALLTRIM(XFILIAL("SE5"))))
			dE5_DATA	:= SE5->E5_DATA
			cE5_TIPO	:= SE5->E5_TIPO
			cE5_DOCUMEN	:= SE5->E5_DOCUMEN
			cE5_MOTBX	:= SE5->E5_MOTBX
			cE5_TIPODOC	:= SE5->E5_TIPODOC
			cE5_MOEDA	:= "M1"
			nE5_VALOR	:= SE5->E5_VALOR
			cE5_HISTOR	:= "PGTO MUTUO: " + cE2_FILIAL
			cE5_XBCOFIL	:= cE2_FILIAL

            aSM0 := SM0->(GETAREA())
            SM0->(DBSETORDER(1)) 
            SM0->(DBSEEK(cEmpAnt+cE2_FILIAL))

			cE5_BENEF	:= ALLTRIM(SM0->M0_NOMECOM) 
			
			SM0->(RestArea(aSM0))
	
			DbSelectArea("SE5")
			RecLock("SE5", .F.)
			SE5->E5_TIPODOC	:= "BA"
			SE5->E5_MOTBX	:= cMOTBAI
			SE5->E5_BANCO	:= ""
			SE5->E5_AGENCIA	:= ""
			SE5->E5_CONTA	:= ""
			SE5->E5_XLOTMUT	:= cLoteMut
			SE5->( MsUnLock() )
            
			cFilAnt := cFilPag

			// Banco agencia e conta pagadora
			SEA->(DBSETORDER(1))
			IF SEA->(!DBSEEK(XFILIAL("SEA")+SE2->E2_NUMBOR))
				ApMsgAlert("Não localizado o borderô do titulo, processo de mutuo não será realizado.")
				RETURN
			ENDIF	
			
			cE5_BANCO	:= SEA->EA_PORTADO
			cE5_AGENCIA	:= SEA->EA_AGEDEP
			cE5_CONTA	:= SEA->EA_NUMCON

			cFilAnt := cFILAUX

			//-----------------------------------------------------------------------
			// Gerar movimento bancário na filial pagadora
			//-----------------------------------------------------------------------

			ExecSE5()
			
			SE5->( RestArea( aAreaSE5 ) )
		ENDIF
		
		//-----------------------------------------------------------------------
		// Localizar FK7 - Auxiliar 
		//-----------------------------------------------------------------------
		cChaveSE2 := SE2->E2_FILIAL + "|" + SE2->E2_PREFIXO + "|" + SE2->E2_NUM + "|" + SE2->E2_PARCELA + "|" + SE2->E2_TIPO + "|" + SE2->E2_FORNECE + "|" + SE2->E2_LOJA
	
		cQuery := " SELECT FK7.R_E_C_N_O_  AS REGFK7 "
		cQuery += " FROM " + RetSqlName("FK7") + " FK7 "
		cQuery += " WHERE	FK7.FK7_FILIAL = '" + SE2->E2_FILIAL + "' " 
		cQuery += " 	AND FK7.FK7_ALIAS = 'SE2' "
		cQuery += " 	AND FK7.FK7_CHAVE = '" + cChaveSE2 + "' "
		cQuery += " 	AND FK7.D_E_L_E_T_ = ' ' "
	
		IF SELECT("TRBFK7") > 0
			TRBFK7->( dbCloseArea() )
		ENDIF    
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBFK7" ,.F.,.T.)
		
		DbSelectArea("TRBFK7")
		DbGoTop()
		IF !EOF()
			DbSelectArea("FK7")
			DbGoTo( TRBFK7->REGFK7 )
			
			cFK7_IDDOC := FK7->FK7_IDDOC
		ENDIF
		TRBFK7->( DbCloseArea() )
		FK7->( RestArea( aAreaFK7 ) )
		
		IF !EMPTY(cFK7_IDDOC)
			//-----------------------------------------------------------------------
			// Localizar FK2 - Baixas a pagar 
			//-----------------------------------------------------------------------
			cQuery := " SELECT FK2.R_E_C_N_O_  AS REGFK2 "
			cQuery += " FROM " + RetSqlName("FK2") + " FK2 "
			cQuery += " WHERE	FK2.FK2_FILIAL = '" + SE2->E2_FILIAL + "' " 
			cQuery += " 	AND FK2.FK2_IDDOC = '" + cFK7_IDDOC + "' "
			cQuery += " 	AND FK2.D_E_L_E_T_ = ' ' "
		
			IF SELECT("TRBFKA") > 0
				TRBFK2->( dbCloseArea() )
			ENDIF    
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBFK2" ,.F.,.T.)

			DbSelectArea("TRBFK2")
			DbGoTop()
			IF !EOF()
				cMOTBAI 	:= GETNEWPAR( "AS_MOTMUT", "MUT", SE2->E2_FILIAL )
			
				DbSelectArea("FK2")
				DbGoTo( TRBFK2->REGFK2 )

				//-----------------------------------------------------------------------
				// Alterar FK2_TPDOC para BA
				// Alterar FK2_MOTBX para MUT
				//-----------------------------------------------------------------------
				RecLock("FK2", .F. )
				FK2->FK2_TPDOC := "BA"
				FK2->FK2_MOTBX := cMOTBAI
				FK2->( MsUnLock() )
				
				cFK2_IDFK2 := FK2->FK2_IDFK2
			ENDIF
			TRBFK2->( DbCloseArea() )
			FK2->( RestArea( aAreaFK2 ) )
			
			IF !EMPTY(cFK2_IDFK2)
				//-----------------------------------------------------------------------
				// Localizar FKA - Rastreio FK2
				//-----------------------------------------------------------------------
				cQuery := " SELECT FKA.R_E_C_N_O_  AS REGFKA "
				cQuery += " FROM " + RetSqlName("FKA") + " FKA "
				cQuery += " WHERE	FKA.FKA_FILIAL = '" + SE2->E2_FILIAL + "' " 
				cQuery += " 	AND FKA.FKA_TABORI = 'FK2' "
				cQuery += " 	AND FKA.FKA_IDORIG = '" + cFK2_IDFK2 + "' "
				cQuery += " 	AND FKA.D_E_L_E_T_ = ' ' "
			
				IF SELECT("TRBFKA") > 0
					TRBFKA->( dbCloseArea() )
				ENDIF    
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBFKA" ,.F.,.T.)

				DbSelectArea("TRBFKA")
				DbGoTop()
				IF !EOF()
					DbSelectArea("FKA")
					DbGoTo( TRBFKA->REGFKA )
					
					cFKA_IDPROC := FKA->FKA_IDPROC
				ENDIF
				TRBFKA->( DbCloseArea() )
				FKA->( RestArea( aAreaFKA ) )
				
				IF !EMPTY(cFKA_IDPROC)
					//-----------------------------------------------------------------------
					// Localizar FKA - Rastreio FK5
					//-----------------------------------------------------------------------
					cQuery := " SELECT FKA.R_E_C_N_O_  AS REGFKA "
					cQuery += " FROM " + RetSqlName("FKA") + " FKA "
					cQuery += " WHERE	FKA.FKA_FILIAL = '" + SE2->E2_FILIAL + "' " 
					cQuery += " 	AND FKA.FKA_TABORI = 'FK5' "
					cQuery += " 	AND FKA.FKA_IDPROC = '" + cFKA_IDPROC + "' "
					cQuery += " 	AND FKA.D_E_L_E_T_ = ' ' "
				
					IF SELECT("TRBFKA") > 0
						TRBFKA->( dbCloseArea() )
					ENDIF    
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBFKA" ,.F.,.T.)
	
					DbSelectArea("TRBFKA")
					DbGoTop()
					DO WHILE !EOF()
						DbSelectArea("FKA")
						DbGoTo( TRBFKA->REGFKA )
						
						cFKA_IDORIG := FKA->FKA_IDORIG
						
						//-----------------------------------------------------------------------
						// Excluir FKA para FKA_TABORI = FK5
						//-----------------------------------------------------------------------
						RecLock("FKA", .F. )
						FKA->( DbDelete() )
						FKA->( MsUnLock() )
						
						DbSelectArea("TRBFKA")
						DbSkip()
					ENDDO
					TRBFKA->( DbCloseArea() )
					FKA->( RestArea( aAreaFKA ) )
					
					IF !EMPTY(cFKA_IDORIG)
						//-----------------------------------------------------------------------
						// Localizar FK5 - Movimento bancário 
						//-----------------------------------------------------------------------
						cQuery := " SELECT FK5.R_E_C_N_O_  AS REGFK5 "
						cQuery += " FROM " + RetSqlName("FK5") + " FK5 "
						cQuery += " WHERE	FK5.FK5_FILIAL = '" + SE2->E2_FILIAL + "' " 
						cQuery += " 	AND FK5.FK5_IDMOV = '" + cFKA_IDORIG + "' "
						cQuery += " 	AND FK5.D_E_L_E_T_ = ' ' "
					
						IF SELECT("TRBFK5") > 0
							TRBFK5->( dbCloseArea() )
						ENDIF    
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBFK5" ,.F.,.T.)
						
						DbSelectArea("TRBFK5")
						DbGoTop()
						DO WHILE !EOF()
							DbSelectArea("FK5")
							DbGoTo( TRBFK5->REGFK5 )
						
							//-----------------------------------------------------------------------
							// Excluir FK5
							//-----------------------------------------------------------------------
							RecLock("FK5", .F. )
							FK5->( DbDelete() )
							FK5->( MsUnLock() )
						
							DbSelectArea("TRBFK5")
							DbSkip()
						ENDDO
						TRBFK5->( DbCloseArea() )
						FK5->( RestArea( aAreaFK5 ) )
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	
		RestArea( aArea )
	ENDIF
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExecSE5()

Realiza a movimento bancário na filial pagadora via ExecAuto FINA100

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		28/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExecSE5()
	LOCAL lRet 			:= .F.
	LOCAL aFINP100		:= {}
	LOCAL nOpcPag		:= 3
	LOCAL cFILAUX		:= cFILANT
	LOCAL aPagar		:= {}
	LOCAL aReceber		:= {}
	
	PRIVATE lMsErroAuto := .F.
	PRIVATE F100AUTO	:= .T.        
	PRIVATE cHist100	:= cE5_HISTOR
	
	
	cFILANT := cFilPag
	//-----------------------------------------------------------------------
	// Movimento bancário na filial pagadora
	//-----------------------------------------------------------------------
	aFINP100 := {;
					{"E5_DATA" 		, dE5_DATA		, NIL},;
					{"E5_NATUREZ" 	, cE5_NATUREZ	, NIL},;					
					{"E5_VALOR"		, nE5_VALOR		, NIL},;
					{"E5_MOEDA"		, cE5_MOEDA		, NIL},;
					{"E5_BANCO"		, cE5_BANCO		, NIL},;
					{"E5_AGENCIA"	, cE5_AGENCIA	, NIL},;
					{"E5_CONTA"		, cE5_CONTA		, NIL},;
					{"E5_BENEF"		, cE5_BENEF		, NIL},;
					{"E5_HISTOR"	, cE5_HISTOR	, NIL},;
					{"E5_XBCOFIL"	, cE5_XBCOFIL	, NIL},;  
					{"E5_ORIGEM"	, cE5_ORIGEM	, NIL},;	
					{"E5_XLOTMUT" 	, cLoteMut		, NIL};					
					}                                          

//					{"E5_TIPODOC" 	, cE5_TIPODOC	, NIL},;
//					{"E5_MOTBX" 	, cE5_MOTBX		, NIL},;
//					{"E5_DOCUMEN" 	, cE5_DOCUMEN	, NIL},;

	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,nOpcPag)

	IF lMsErroAuto
		MostraErro()
		lRet 	:= .F.
	ELSE
		lRet 	:= .T.
	ENDIF     

	cFILANT := cFILAUX                                          
	
	// Atualiza movimentação do mutuo
	IF lRet
		U_ASFINA58(cFilPag,cFILAUX,cLoteMut, "P#R" ) 
	ENDIF	
	
	
RETURN lRet