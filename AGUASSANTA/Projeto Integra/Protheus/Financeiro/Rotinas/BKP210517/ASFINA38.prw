#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA38()

Altera filial pagadora de acordo com o critério selecionado pelo usuário

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA38()
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}
	LOCAL lRet		:= .F.

	PRIVATE cFilialDe	:= SPACE( LEN(cFilAnt) )
	PRIVATE cFilialAte	:= REPLICATE( "Z", LEN(cFilAnt) )	
	PRIVATE dVencReaDe	:= CTOD("//")
	PRIVATE dVencReaAt	:= dDATABASE
	PRIVATE dEmissaoDe	:= CTOD("//")
	PRIVATE dEmissaoAt	:= dDATABASE
	PRIVATE cForneceDe	:= SPACE(LEN(SE2->E2_FORNECE))
	PRIVATE cForneceAt	:= REPLICATE("Z", LEN(SE2->E2_FORNECE) )
	PRIVATE cPrefixoDe	:= SPACE(LEN(SE2->E2_PREFIXO))
	PRIVATE cPrefixoAt	:= REPLICATE("Z", LEN(SE2->E2_PREFIXO) )
	PRIVATE cNumDe		:= SPACE(LEN(SE2->E2_NUM))
	PRIVATE cNumAte		:= REPLICATE("Z", LEN(SE2->E2_NUM) )
	PRIVATE nTamFil		:= LEN(ALLTRIM(XFILIAL("SE2")))

	//-----------------------------------------------------------------------
	// Definição dos Parametros da Rotina
	//-----------------------------------------------------------------------
	// 1 - MsGet
	//  [2] : Descrição
	//  [3] : String contendo o inicializador do campo
	//  [4] : String contendo a Picture do campo
	//  [5] : String contendo a validação
	//  [6] : Consulta F3
	//  [7] : String contendo a validação When
	//  [8] : Tamanho do MsGet
	//  [9] : Flag .T./.F. Parâmetro Obrigatório ?
	//
	aAdd(aPar,{1	,"Filial - de"			, cFilialDe 	, "" 	, , "SM0_01"	, , 050, .F.})
	aAdd(aPar,{1	,"Filial - até"			, cFilialAte	, ""	, , "SM0_01"	, , 050, .F.})
	aAdd(aPar,{1	,"Vencimento - de"		, dVencReaDe 	, ""	, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Vencimento - até"		, dVencReaAt	, ""	, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Emissão - de"			, dEmissaoDe 	, ""	, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Emissão - até"		, dEmissaoAt	, ""	, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Fornecedor - de"		, cForneceDe 	, ""	, , "SA2"		, , 050, .F.})
	aAdd(aPar,{1	,"Fornecedor - até"		, cForneceAt	, ""	, , "SA2"		, , 050, .F.})
	aAdd(aPar,{1	,"Prefixo - de"			, cPrefixoDe 	, ""	, , 			, , 040, .F.})
	aAdd(aPar,{1	,"Prefixo - até"		, cPrefixoAt	, ""	, , 			, , 040, .F.})
	aAdd(aPar,{1	,"Título - de"			, cNumDe 		, ""	, , 			, , 060, .F.})
	aAdd(aPar,{1	,"Título - até"			, cNumAte		, ""	, , 			, , 060, .F.})

	//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

	lRet 	:= ParamBox(aPar,"Alteração da filial pagadora",@aRet,,,,,,,"ASFINA38",.F.,.F.)
	IF lRet
		IF !Len(aRet) == Len(aPar)
			MsgAlert("É necessário indicar todos os dados solicitados!", "Atenção")
			lRet := .F.
		ELSE
			cFilialDe	:= PADR(SUBSTR(ALLTRIM(aRet[1]),1,nTamFil),LEN(XFILIAL("SE2")))
			cFilialAte	:= PADR(SUBSTR(ALLTRIM(aRet[2]),1,nTamFil),LEN(XFILIAL("SE2")))
			dVencReaDe	:= aRet[3]
			dVencReaAt	:= aRet[4]
			dEmissaoDe	:= aRet[5]
			dEmissaoAt	:= aRet[6]
			cForneceDe	:= ALLTRIM(aRet[7])
			cForneceAt	:= ALLTRIM(aRet[8])
			cPrefixoDe	:= ALLTRIM(aRet[9])
			cPrefixoAt	:= ALLTRIM(aRet[10])
			cNumDe		:= ALLTRIM(aRet[11])
			cNumAte		:= ALLTRIM(aRet[12])
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Exibe markbrowse para seleção dos títulos que devem ter a filial 
	// pagadora substituída
	//-----------------------------------------------------------------------
	IF lRet
		Processa({|| TelaMark()},"Selecionando registros", "", .F.)
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} TelaMark()

Exibe markbrowse para seleção dos títulos que devem ter a filial
pagadora substituída

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TelaMark()
	
	LOCAL aCores    	:= {}
	
	PRIVATE arotina 	:= {}
	PRIVATE cCADASTRO	:= "Alteração da filial pagadora"
	PRIVATE cMark		:= GetMark()
	PRIVATE aFields		:= {}
	PRIVATE cArq		:= ""
	PRIVATE bOpc1 		:= {|| MarcaTud()}
	PRIVATE bOpc2 		:= {|| MarcaIte()}
	PRIVATE cErrLog		:= ""
	PRIVATE aFilAce		:= {}
	
	//-----------------------------------------------------------------------
	// Função para retornar as filiais que o usuário corrente tem acesso
	//-----------------------------------------------------------------------
	aFilAce := U_ASCADA02( RetCodUsr() ) 

	AADD( aRotina, { "Alterar a filial pagadora"	,"U_ASFIA38A" 	, 0, 4} )
	AADD( aRotina, { "Visualiza Título"				,"U_ASFIA38B" 	, 0, 4} )

	aCores := {;
					{'!EMPTY(TRB->E2_XBCOFIL)'	,'BR_AZUL'		},;
			 		{'EMPTY(TRB->E2_XBCOFIL)'	,'BR_VERDE'		};
			 	}

	//-----------------------------------------------------------------------
	// Gera arquivo temporario 
	//-----------------------------------------------------------------------
	Processa({|| MontaTrb()},"Processando...", "", .F.)

	DbSelectArea("TRB")
	DbGotop()
	MarkBrow( 'TRB', 'E2_OK',,aFields,, cMark ,"Eval(bOpc1)"   ,,,,"Eval(bOpc2)"   ,,,.T.,aCores)
	
	//-----------------------------------------------------------------------
	// Apaga a tabela temporária
	//-----------------------------------------------------------------------
	DbSelectArea("TRB")
	DbCloseArea() 
	MsErase(cArq+GetDBExtension(),,"DBFCDX")

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MontaTRB

Monta arquivo temporario de acordo com os parametros selecionados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MontaTRB()
	//-----------------------------------------------------------------------
	// Declaracao de Variaveis
	//-----------------------------------------------------------------------
	LOCAL aStru		:= {}
	LOCAL aCampos	:= {}
	LOCAL nX          
	LOCAL bCampo
	LOCAL cCampo	:= ""
	LOCAL cQuery	:= ""
	LOCAL nREGSE2	:= 0

	//-----------------------------------------------------------------------
	// Monta TRB 
	//-----------------------------------------------------------------------
	cQuery := " SELECT SE2.R_E_C_N_O_  AS REGSE2 "
	cQuery += " FROM " + RetSqlName("SE2") + " SE2 "
	cQuery += " WHERE	SE2.E2_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAte + "' " 
	cQuery += " 	AND SE2.E2_VENCREA BETWEEN '" + DTOS(dVencReaDe) + "' AND '" + DTOS(dVencReaAt) + "' " 
	cQuery += " 	AND SE2.E2_EMISSAO BETWEEN '" + DTOS(dEmissaoDe) + "' AND '" + DTOS(dEmissaoAt) + "' " 
	cQuery += " 	AND SE2.E2_FORNECE BETWEEN '" + cForneceDe + "' AND '" + cForneceAt + "' " 
	cQuery += " 	AND SE2.E2_PREFIXO BETWEEN '" + cPrefixoDe + "' AND '" + cPrefixoAt + "' " 
	cQuery += " 	AND SE2.E2_NUM BETWEEN '" + cNumDe + "' AND '" + cNumAte + "' " 

	cQuery += "		AND SE2.E2_ORIGEM <> 'SIGAEFF' "
	cQuery += "		AND SE2.E2_TIPO NOT IN "+FormatIn(MVPROVIS+"|"+MV_CPNEG+"|PRE","|") +" "
	cQuery += "		AND SE2.E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")+" "
	
	//-----------------------------------------------------------------------
	//Ignora os títulos de adiantamento
	//-----------------------------------------------------------------------
	cQuery += "		AND SE2.E2_TIPO <> '"+MVPAGANT+"' "
	
	//-----------------------------------------------------------------------
	//Ignora os títulos que possuem cheques emitidos
	//-----------------------------------------------------------------------
	cQuery += "		AND SE2.E2_IMPCHEQ <> 'S' "                 
	cQuery += "		AND (SE2.E2_SALDO>0 AND SE2.E2_NUMBOR = '" + space(TAMSX3("E2_NUMBOR")[1]) + "') "

	cQuery += " 	AND SE2.D_E_L_E_T_ = ' '	"
	cQuery += " ORDER BY SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA "

	IF SELECT("TRBSE2") > 0
		TRBSE2->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSE2" ,.F.,.T.)

	ProcRegua(0)

	//-----------------------------------------------------------------------
	// Cria arquivo temporario
	//-----------------------------------------------------------------------
	aStru	:= {}
	aFields	:= {}
	aCampos	:= {}

	//-----------------------------------------------------------------------
	// Para criar a estrutura temporaria
	//-----------------------------------------------------------------------
	AADD(aStru,	{"E2_OK"		, "C", TAMSX3("E2_OK")[01]		, 0	})
	AADD(aStru,	{"E2_FILIAL"	, "C", TAMSX3("E2_FILIAL")[01]	, 0	})
	AADD(aStru,	{"E2_XBCOFIL"	, "C", TAMSX3("E2_XBCOFIL")[01]	, 0	})
	AADD(aStru,	{"SE2REG"		, "N", 10						, 0	})
	
	//-----------------------------------------------------------------------
	// Lista das colunas do MarkBrowse
	//-----------------------------------------------------------------------
	AADD(aFields,	{"E2_OK"		, "C", ""					})
	AADD(aFields,	{"E2_FILIAL"	, "C", "Filial"				})
	AADD(aFields,	{"E2_XBCOFIL"	, "C", "Filial pagadora"	})

	dbSelectArea("SX3")
	DbSetOrder(1)
	DbGoTop()
	dbSeek("SE2")
	While !Eof().And.(SX3->x3_arquivo=="SE2")
		If Alltrim(SX3->x3_campo)=="E2_FILIAL" .OR. Alltrim(SX3->x3_campo)=="E2_OK" .OR. Alltrim(SX3->x3_visual)=="V" .OR. Alltrim(SX3->x3_campo)=="E2_XBCOFIL" 
			dbSelectArea("SX3")
			dbSkip()
			Loop
		Endif
		If (X3USO(SX3->x3_usado) .AND. ALLTRIM(UPPER(SX3->x3_browse)) == 'S')
			// para criar a estrutura temporaria
			AADD(aStru,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_tamanho, SX3->x3_decimal})
			
			// lista das colunas do MarkBrowse
			AADD(aFields,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_titulo, SX3->X3_picture, SX3->x3_tamanho, SX3->x3_decimal })
			
			// lista das campos para popular no MarkBrowse
			AADD( aCampos, "TRB->"+ALLTRIM(SX3->x3_campo) + " := " + "SE2->"+ALLTRIM(SX3->x3_campo) )
		Endif

		dbSelectArea("SX3")
		dbSkip()
	Enddo

	//-----------------------------------------------------------------------
	// Cria a tabela temporária
	//-----------------------------------------------------------------------
	IF SELECT("TRB") > 0
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
	ENDIF
	cArq	:=	"T_"+Criatrab(,.F.)
	MsCreate(cArq,aStru,"DBFCDX") // atribui a tabela temporária ao alias TRB
	dbUseArea(.T.,"DBFCDX",cArq,"TRB",.T.,.F.)// alimenta a tabela temporária

	//-----------------------------------------------------------------------
	// Popula a tabela temporária
	//-----------------------------------------------------------------------
	DbSelectArea("TRBSE2")
	DbGoTop()
	DO WHILE !EOF()
		nREGSE2 := TRBSE2->REGSE2
	
		DbSelectArea("SE2")
		DbGoTo( nREGSE2 )

		//-----------------------------------------------------------------------
		// Se o usuário tem acesso à filial
		//-----------------------------------------------------------------------
		IF aSCAN( aFilAce, SE2->E2_FILIAL ) > 0
			DBSELECTAREA("TRB")
			RECLOCK("TRB",.T.)
			FOR nX := 1 TO LEN( aCampos )
				bCampo := aCampos[nX]
				&bCampo
			NEXT
	
			TRB->E2_OK 		:= cMark
			TRB->E2_FILIAL	:= SE2->E2_FILIAL
			TRB->E2_XBCOFIL	:= SE2->E2_XBCOFIL
			TRB->SE2REG 	:= nREGSE2
			MSUNLOCK()
		ENDIF
		
		DbSelectArea("TRBSE2")
		DbSkip()
	ENDDO
	TRBSE2->( DbCloseArea() )

RETURN 


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaTud

Marca ou desmarca todos os itens do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaTud()

	DbSelectArea("TRB")
	DbGoTop()
	DO WHILE !EOF()
		MarcaIte()
	
		TRB->( DbSkip() )
	ENDDO

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaIte

Marca ou desmarca o item do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaIte()

	IF IsMark("E2_OK",cMark )
		RecLock("TRB",.F.)
		TRB->E2_OK := ""
		TRB->( MsUnLock() ) 
	ELSE
		RecLock("TRB",.F.)
		TRB->E2_OK := cMark
 		TRB->( MsUnLock() )
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFIA38A

Altera a filial pagadora dos títulos a pagar marcados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFIA38A()
	LOCAL aPar		:= {}
	LOCAL cBCOFIL	:= SPACE( LEN(cFILANT) )
	LOCAL lRet		:= .F.
	LOCAL aRet		:= {}
	
	//-----------------------------------------------------------------------
	// Definição dos Parametros da Rotina
	//-----------------------------------------------------------------------
	// 1 - MsGet
	//  [2] : Descrição
	//  [3] : String contendo o inicializador do campo
	//  [4] : String contendo a Picture do campo
	//  [5] : String contendo a validação
	//  [6] : Consulta F3
	//  [7] : String contendo a validação When
	//  [8] : Tamanho do MsGet
	//  [9] : Flag .T./.F. Parâmetro Obrigatório ?
	//
	aAdd(aPar,{1	,"Filial pagadora"			, cBCOFIL 	, "" 	, , "SM0_01"	, , 050, .F.})

	//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet
	lRet := ParamBox(aPar,"Alteração da filial pagadora",@aRet,,,,,,,"ASFINA38",.F.,.F.)
	IF lRet
		cBCOFIL	:= ALLTRIM(aRet[1])
		
		IF !EMPTY(cBCOFIL)
			IF aSCAN( aFilAce, cBCOFIL ) == 0
				MsgAlert("Usuário sem acesso à filial pagadora (" + cBCOFIL + ")", "Atenção")
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF
					
	IF lRet
		IF MsgNoYes("Deseja realmente alterar a filial pagadora dos títulos marcados?", "Confirme")
			Processa({|| AltBcoFil(cBCOFIL)},"Processando", "", .F.) 
		ENDIF	
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFIA38B

Visualiza o título a pagar

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFIA38B()
	
	DbSelectArea("SE2")
	DbGoTo( TRB->SE2REG )
	
	AxVisual("SE2")
	
	DbSelectArea("TRB")
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} AltBcoFil

Processa a alteração da filial pagadora para os registros marcados

@param		cBCOFIL = Filial pagadora
@return		Nenhum
@author 	Fabio Cazarini
@since 		20/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION AltBcoFil(cBCOFIL)
	LOCAL nReg		:= 0
	LOCAL nProcess	:= 0                                                       
	LOCAL nTamFil	:= LEN(ALLTRIM(XFILIAL("SE2")))	
	
	TRB->(dbEval({|| nReg++ },,{|| !Eof()}))
	TRB->(dbGoTop())  

	ProcRegua(nReg)

	DbSelectArea("TRB")
	DbGoTop()
	DO WHILE !EOF()
		IncProc("Atualizando...")
		
		IF IsMark("E2_OK",cMark )
			DbSelectArea("SE2")
			DbGoTo( TRB->SE2REG )
			RecLock("SE2", .F.)
			IF ALLTRIM(SE2->E2_FILIAL) <> ALLTRIM(PADR(SUBSTR(cBCOFIL,1,nTamFil),LEN(XFILIAL("SE2"))))
				SE2->E2_XBCOFIL := cBCOFIL
			ENDIF	
			SE2->( MsUnLock() )
			
			RecLock("TRB", .F.)
			TRB->E2_XBCOFIL := cBCOFIL
			TRB->( MsUnLock() )

			nProcess++
		ENDIF

		DbSelectArea("TRB")
		TRB->( DbSkip() )
	ENDDO

	MsgInfo("Processo concluído. Foi(ram) atualizado(s) " + ALLTRIM(STR(nProcess)) + " título(s)", "Ok")
	
RETURN