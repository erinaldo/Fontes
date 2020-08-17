#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA44()

M�tuo de t�tulos a receber

@param		Nenhum
@return		Nenhum 
@author 	Fabio Cazarini
@since 		29/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA44()
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}
	LOCAL lRet		:= .F.

	PRIVATE dMovimenDe	:= CTOD("//")
	PRIVATE dMovimenAt	:= dDATABASE
	PRIVATE cNaturez	:= SPACE(LEN(SE5->E5_NATUREZ))

	//-----------------------------------------------------------------------
	// Defini��o dos Parametros da Rotina
	//-----------------------------------------------------------------------
	// 1 - MsGet
	//  [2] : Descri��o
	//  [3] : String contendo o inicializador do campo
	//  [4] : String contendo a Picture do campo
	//  [5] : String contendo a valida��o
	//  [6] : Consulta F3
	//  [7] : String contendo a valida��o When
	//  [8] : Tamanho do MsGet
	//  [9] : Flag .T./.F. Par�metro Obrigat�rio ?
	//
	aAdd(aPar,{1	,"Dt movimenta��o - de"		, dMovimenDe 	, ""	, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Dt movimenta��o - at�"	, dMovimenAt	, ""	, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Natureza"					, cNaturez 		, ""	, , "SED"		, , 050, .F.})

	//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

	lRet 	:= ParamBox(aPar,"Altera��o da filial pagadora",@aRet,,,,,,,"ASFINA44A",.F.,.F.)
	IF lRet
		IF !Len(aRet) == Len(aPar)
			MsgAlert("� necess�rio indicar todos os dados solicitados!", "Aten��o")
			lRet := .F.
		ELSE
			dMovimenDe	:= aRet[1]
			dMovimenAt	:= aRet[2]
			cNaturez	:= aRet[3]
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Exibe markbrowse para sele��o dos t�tulos que devem ter a filial 
	// pagadora substitu�da
	//-----------------------------------------------------------------------
	IF lRet
		Processa({|| TelaBrow()},"Selecionando registros", "", .F.)
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} TelaBrow()

Exibe browse para sele��o da movimenta��o banc�ria

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		29/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TelaBrow()
	
	PRIVATE oBrowse		
	PRIVATE aRotina 	:= {}
	PRIVATE cCADASTRO	:= "Selecione a movimenta��o banc�ria"
	PRIVATE aFields		:= {}
	PRIVATE cArq		:= ""
	PRIVATE bOpc1 		:= {|| MarcaBxSE1(TRB->SE5REG)}

	//-----------------------------------------------------------------------
	// Defini��o do menu da rotina
	//-----------------------------------------------------------------------
	AADD( aRotina, { "Selecionar t�tulos para a baixa"	,"Eval(bOpc1)" 	, 0, 4} )

	//-----------------------------------------------------------------------
	// Instancia a classe
	//-----------------------------------------------------------------------
	oBrowse:=FWMBrowse():New()

	//-----------------------------------------------------------------------
	// Descri��o do browse
	//-----------------------------------------------------------------------
	oBrowse:SetDescription(cCADASTRO)
	
	//-----------------------------------------------------------------------
	// Acao ao duplo clique em uma linha
	//-----------------------------------------------------------------------
	oBrowse:bldblclick := bOpc1

	//-----------------------------------------------------------------------
	// Define as legendas
	//-----------------------------------------------------------------------
	oBrowse:AddLegend('TRB->E5_XVALMUT<TRB->E5_VALOR'	,"BR_VERDE" 	,"V�nculo com m�tuo pendente")
	oBrowse:AddLegend('TRB->E5_XVALMUT>=TRB->E5_VALOR'	,"BR_VERMELHO"	,"V�nculo com m�tuo efetuado")

	//-----------------------------------------------------------------------
	// Gera arquivo temporario 
	//-----------------------------------------------------------------------
	Processa({|| MontaTrb()},"Processando...", "", .F.)

	DbSelectArea("TRB")
	DbGotop()

	//-----------------------------------------------------------------------
	// Abre o browse
	//-----------------------------------------------------------------------
	oBrowse:Activate()
	
	//-----------------------------------------------------------------------
	// Apaga a tabela tempor�ria
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
@since 		29/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MontaTrb()

	LOCAL aStru		:= {}
	LOCAL aCampos	:= {}
	LOCAL nX          
	LOCAL bCampo
	LOCAL cCampo	:= ""
	LOCAL cQuery	:= ""
	LOCAL nREGSE5	:= 0

	//-----------------------------------------------------------------------
	// Monta TRB com registros
	//-----------------------------------------------------------------------
	cQuery := " SELECT SE5.R_E_C_N_O_  AS REGSE5 "
	cQuery += " FROM " + RetSqlName("SE5") + " SE5 "
	cQuery += " WHERE	SE5.E5_FILIAL = '" + xFILIAL("SE5") + "' " 
	cQuery += " 	AND SE5.E5_NATUREZ = '" + cNaturez + "' " 
	cQuery += " 	AND SE5.E5_DATA BETWEEN '" + DTOS(dMovimenDe) + "' AND '" + DTOS(dMovimenAt) + "' " 
	cQuery += " 	AND SE5.E5_RECONC <> ' ' "
	cQuery += " 	AND SE5.E5_NUMERO = '" + SPACE(LEN(SE5->E5_NUMERO)) + "' " // t�tulos sem baixa receber vinculada
	cQuery += " 	AND SE5.E5_RECPAG = 'R' "
	//cQuery += " 	AND SE5.E5_VALOR > SE5.E5_XVALMUT "
	cQuery += " 	AND SE5.D_E_L_E_T_ = ' ' "

	IF SELECT("TRBSE5") > 0
		TRBSE5->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSE5" ,.F.,.T.)
	
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
	AADD(aStru,	{"SE5REG"	, "N", 10					, 0	})
	
	dbSelectArea("SX3")
	DbSetOrder(1)
	DbGoTop()
	dbSeek("SE5")
	While !Eof().And.(SX3->x3_arquivo=="SE5")
		If Alltrim(SX3->x3_campo)=="E5_FILIAL" .OR. Alltrim(SX3->x3_campo)== "E5_XVALMUT" .OR. Alltrim(SX3->x3_visual)=="V" 
			dbSelectArea("SX3")
			dbSkip()
			Loop
		Endif
		If (X3USO(SX3->x3_usado) .AND. ALLTRIM(UPPER(SX3->x3_browse)) == 'S')
			// para criar a estrutura temporaria
			AADD(aStru,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_tamanho, SX3->x3_decimal})
			
			// lista das colunas do Browse
			AADD(aFields,	{SX3->x3_titulo, SX3->x3_campo, SX3->x3_tipo, SX3->x3_tamanho, SX3->x3_decimal, SX3->X3_picture })
			
			// lista das campos para popular no Browse
			AADD( aCampos, "TRB->"+ALLTRIM(SX3->x3_campo) + " := " + "SE5->"+ALLTRIM(SX3->x3_campo) )
		Endif

		dbSelectArea("SX3")
		dbSkip()
	Enddo
	
	AADD(aStru,	{"E5_XVALMUT"	, "N", TAMSX3("E5_VALOR")[1], TAMSX3("E5_VALOR")[2]	})
	IF SE5->( FIELDPOS("E5_XVALMUT") ) > 0
		AADD( aCampos, "TRB->E5_XVALMUT := SE5->E5_XVALMUT" )
	ENDIF	

	//-----------------------------------------------------------------------
	// Cria a tabela tempor�ria
	//-----------------------------------------------------------------------
	IF SELECT("TRB") > 0
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
	ENDIF
	cArq	:=	"T_"+Criatrab(,.F.)
	MsCreate(cArq,aStru,"DBFCDX") // atribui a tabela tempor�ria ao alias TRB
	dbUseArea(.T.,"DBFCDX",cArq,"TRB",.T.,.F.)// alimenta a tabela tempor�ria

	//-----------------------------------------------------------------------
	// Popula a tabela tempor�ria
	//-----------------------------------------------------------------------
	DbSelectArea("TRBSE5")
	DbGoTop()
	DO WHILE !EOF()
		nREGSE5 := TRBSE5->REGSE5
	
		DbSelectArea("SE5")
		DbGoTo( nREGSE5 )

		DBSELECTAREA("TRB")
		RECLOCK("TRB",.T.)
		FOR nX := 1 TO LEN( aCampos )
			bCampo := aCampos[nX]
			&bCampo
		NEXT
		TRB->SE5REG := nREGSE5
		MSUNLOCK()
		
		DbSelectArea("TRBSE5")
		DbSkip()
	ENDDO
	TRBSE5->( DbCloseArea() )

	//-----------------------------------------------------------------------
	// Tabela temporaria
	//-----------------------------------------------------------------------
	oBrowse:SetAlias('TRB')
	
	//-----------------------------------------------------------------------
	// Seta as colunas para o browse
	//-----------------------------------------------------------------------
	oBrowse:SetFields(aFields)
	
	//-----------------------------------------------------------------------
	// Desabilita o detalhe do registro
	//-----------------------------------------------------------------------
	oBrowse:DisableDetails()

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaBxSE1

Monta tela estilo markbrowse com os t�tulos da sele��o

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		29/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaBxSE1()
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}
	LOCAL lRet		:= .F.
	LOCAL cPICTVAL	:= PESQPICT("SE1", "E1_VALOR")

	PRIVATE cFilialDe	:= SPACE( LEN(cFilAnt) )
	PRIVATE cFilialAte	:= REPLICATE( "Z", LEN(cFilAnt) )	
	PRIVATE dVencReaDe	:= CTOD("//")
	PRIVATE dVencReaAt	:= dDATABASE
	PRIVATE cClienteDe	:= SPACE(LEN(SE1->E1_CLIENTE))
	PRIVATE cClienteAt	:= REPLICATE("Z", LEN(SE1->E1_CLIENTE) )
	PRIVATE cTipoDe		:= SPACE(LEN(SE1->E1_TIPO))
	PRIVATE cTipoAte	:= REPLICATE("Z", LEN(SE1->E1_TIPO) )
	PRIVATE nValorDe	:= 0.00
	PRIVATE nValorAte	:= 9999999999999.99
	
	PRIVATE nXVALMUT	:= 0
	PRIVATE nE5_VALOR	:= TRB->E5_VALOR-TRB->E5_XVALMUT

	//-----------------------------------------------------------------------
	// Defini��o dos Parametros da Rotina
	//-----------------------------------------------------------------------
	// 1 - MsGet
	//  [2] : Descri��o
	//  [3] : String contendo o inicializador do campo
	//  [4] : String contendo a Picture do campo
	//  [5] : String contendo a valida��o
	//  [6] : Consulta F3
	//  [7] : String contendo a valida��o When
	//  [8] : Tamanho do MsGet
	//  [9] : Flag .T./.F. Par�metro Obrigat�rio ?
	//
	aAdd(aPar,{1	,"Filial - de"			, cFilialDe 	, "" 		, , "SM0_01"	, , 050, .F.})
	aAdd(aPar,{1	,"Filial - at�"			, cFilialAte	, ""		, , "SM0_01"	, , 050, .F.})
	aAdd(aPar,{1	,"Vencimento - de"		, dVencReaDe 	, ""		, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Vencimento - at�"		, dVencReaAt	, ""		, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Cliente - de"			, cClienteDe 	, ""		, , "SA1"		, , 050, .F.})
	aAdd(aPar,{1	,"Cliente - at�"		, cClienteAt	, ""		, , "SA1"		, , 050, .F.})
	aAdd(aPar,{1	,"Tipo - de"			, cTipoDe 		, ""		, , 			, , 040, .F.})
	aAdd(aPar,{1	,"Tipo - at�"			, cTipoAte		, ""		, , 			, , 040, .F.})
	aAdd(aPar,{1	,"Valor - de"			, nValorDe 		, cPICTVAL	, , 			, , 080, .F.})
	aAdd(aPar,{1	,"Valor - at�"			, nValorAte		, cPICTVAL	, , 			, , 080, .F.})

	//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

	lRet 	:= ParamBox(aPar,"Selecionar t�tulos para a baixa",@aRet,,,,,,,"ASFINA44B",.F.,.F.)
	IF lRet
		cFilialDe	:= ALLTRIM(aRet[1])			
		cFilialAte	:= ALLTRIM(aRet[2])
		dVencReaDe	:= aRet[3]
		dVencReaAt	:= aRet[4]
		cClienteDe	:= ALLTRIM(aRet[5])
		cClienteAt	:= ALLTRIM(aRet[6])
		cTipoDe		:= ALLTRIM(aRet[7])
		cTipoAte	:= ALLTRIM(aRet[8])
		nValorDe	:= aRet[9]
		nValorAte	:= aRet[10]
	ENDIF

	//-----------------------------------------------------------------------
	// Exibe markbrowse para sele��o dos t�tulos que devem ter a filial 
	// pagadora substitu�da
	//-----------------------------------------------------------------------
	IF lRet
		Processa({|| TelaMark()},"Selecionando registros", "", .F.)
	ENDIF
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} TelaMark()

Exibe markbrowse para sele��o dos t�tulos que devem ser baixados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TelaMark()
	
	PRIVATE arotina 	:= {}
	PRIVATE cCADASTRO	:= "Selecionar t�tulos para a baixa"
	PRIVATE cMark		:= GetMark()
	PRIVATE aFieSE1		:= {}
	PRIVATE cArqSE1		:= ""
	PRIVATE bOpcMar0 	:= {|| BaixarTit()}
	PRIVATE bOpcMar1 	:= {|| MarcaTud()}
	PRIVATE bOpcMar2 	:= {|| MarcaIte()}
	
	AADD( aRotina, { "Baixar t�tulos selecionados"	,"Eval(bOpcMar0)" 	, 0, 4} )

	//-----------------------------------------------------------------------
	// Gera arquivo temporario 
	//-----------------------------------------------------------------------
	Processa({|| MontaSE1()},"Processando...", "", .F.)

	DbSelectArea("TRBMKB")
	DbGotop()
	MarkBrow( 'TRBMKB', 'E1_OK',,aFieSE1,, cMark ,"Eval(bOpcMar1)"   ,,,,"Eval(bOpcMar2)"   ,,,.T.,)
	
	//-----------------------------------------------------------------------
	// Apaga a tabela tempor�ria
	//-----------------------------------------------------------------------
	DbSelectArea("TRBMKB")
	DbCloseArea() 
	MsErase(cArqSE1+GetDBExtension(),,"DBFCDX")

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MontaSE1

Monta arquivo temporario de acordo com os parametros selecionados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MontaSE1()
	//-----------------------------------------------------------------------
	// Declaracao de Variaveis
	//-----------------------------------------------------------------------
	LOCAL aStru		:= {}
	LOCAL aCampos	:= {}
	LOCAL nX          
	LOCAL bCampo
	LOCAL cCampo	:= ""
	LOCAL cQuery	:= ""
	LOCAL nREGSE1	:= 0
	LOCAL aFilAce	:= {}

	//-----------------------------------------------------------------------
	// Fun��o para retornar as filiais que o usu�rio corrente tem acesso
	//-----------------------------------------------------------------------
	aFilAce := U_ASCADA02( RetCodUsr() ) 

	//-----------------------------------------------------------------------
	// Monta TRB 
	//-----------------------------------------------------------------------
	cQuery := " SELECT SE1.R_E_C_N_O_  AS REGSE1 "
	cQuery += " FROM " + RetSqlName("SE1") + " SE1 "
	cQuery += " WHERE	SE1.E1_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAte + "' " 
	cQuery += " 	AND SE1.E1_VENCREA BETWEEN '" + DTOS(dVencReaDe) + "' AND '" + DTOS(dVencReaAt) + "' " 
	cQuery += " 	AND SE1.E1_CLIENTE BETWEEN '" + cClienteDe + "' AND '" + cClienteAt + "' " 
	cQuery += " 	AND SE1.E1_TIPO BETWEEN '" + cTipoDe + "' AND '" + cTipoAte + "' " 
	cQuery += " 	AND SE1.E1_VALOR BETWEEN " + ALLTRIM(STR(nValorDe)) + " AND " + ALLTRIM(STR(nValorAte)) + " " 
	cQuery += "		AND SE1.E1_SALDO > 0 "
	cQuery += " 	AND SE1.D_E_L_E_T_ = ' '	"
	cQuery += " ORDER BY SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA "

	IF SELECT("TRBSE1") > 0
		TRBSE1->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSE1" ,.F.,.T.)

	ProcRegua(0)

	//-----------------------------------------------------------------------
	// Cria arquivo temporario
	//-----------------------------------------------------------------------
	aStru	:= {}
	aFieSE1	:= {}
	aCampos	:= {}

	//-----------------------------------------------------------------------
	// Para criar a estrutura temporaria
	//-----------------------------------------------------------------------
	AADD(aStru,	{"E1_OK"		, "C", TAMSX3("E2_OK")[01]		, 0	})
	AADD(aStru,	{"E1_FILIAL"	, "C", TAMSX3("E1_FILIAL")[01]	, 0	})
	AADD(aStru,	{"SE1REG"		, "N", 10						, 0	})
	
	//-----------------------------------------------------------------------
	// Lista das colunas do MarkBrowse
	//-----------------------------------------------------------------------
	AADD(aFieSE1,	{"E1_OK"		, "C", ""					})
	AADD(aFieSE1,	{"E1_FILIAL"	, "C", "Filial"				})

	//-----------------------------------------------------------------------
	// para criar a estrutura temporaria - E1_SALDO
	//-----------------------------------------------------------------------
	AADD(aStru,	{"E1_SALDO", "N", TAMSX3("E1_SALDO")[1], TAMSX3("E1_SALDO")[2]})
	AADD(aFieSE1,	{"E1_SALDO", "N", "Saldo em aberto", PESQPICT("SE1", "E1_SALDO"), TAMSX3("E1_SALDO")[1], TAMSX3("E1_SALDO")[2] })

	dbSelectArea("SX3")
	DbSetOrder(1)
	DbGoTop()
	dbSeek("SE1")
	While !Eof().And.(SX3->x3_arquivo=="SE1")
		If Alltrim(SX3->x3_campo)=="E1_FILIAL" .OR. Alltrim(SX3->x3_campo)=="E1_OK" .OR. Alltrim(SX3->x3_campo)=="E1_SALDO" .OR. Alltrim(SX3->x3_visual)=="V" 
			dbSelectArea("SX3")
			dbSkip()
			Loop
		Endif
		If (X3USO(SX3->x3_usado) .AND. ALLTRIM(UPPER(SX3->x3_browse)) == 'S')
			// para criar a estrutura temporaria
			AADD(aStru,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_tamanho, SX3->x3_decimal})
			
			// lista das colunas do MarkBrowse
			AADD(aFieSE1,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_titulo, SX3->X3_picture, SX3->x3_tamanho, SX3->x3_decimal })
			
			// lista das campos para popular no MarkBrowse
			AADD( aCampos, "TRBMKB->"+ALLTRIM(SX3->x3_campo) + " := " + "SE1->"+ALLTRIM(SX3->x3_campo) )
		Endif

		dbSelectArea("SX3")
		dbSkip()
	Enddo

	//-----------------------------------------------------------------------
	// Cria a tabela tempor�ria
	//-----------------------------------------------------------------------
	IF SELECT("TRBMKB") > 0
		DBSELECTAREA("TRBMKB")
		DBCLOSEAREA()
	ENDIF
	cArqSE1	:=	"T_"+Criatrab(,.F.)
	MsCreate(cArqSE1,aStru,"DBFCDX") // atribui a tabela tempor�ria ao alias TRB
	dbUseArea(.T.,"DBFCDX",cArqSE1,"TRBMKB",.T.,.F.)// alimenta a tabela tempor�ria

	//-----------------------------------------------------------------------
	// Popula a tabela tempor�ria
	//-----------------------------------------------------------------------
	DbSelectArea("TRBSE1")
	DbGoTop()
	DO WHILE !EOF()
		nREGSE1 := TRBSE1->REGSE1
	
		DbSelectArea("SE1")
		DbGoTo( nREGSE1 )

		//-----------------------------------------------------------------------
		// Se o usu�rio tem acesso � filial
		//-----------------------------------------------------------------------
		IF aSCAN( aFilAce, cEmpAnt+SE1->E1_FILIAL ) > 0
			DBSELECTAREA("TRBMKB")
			RECLOCK("TRBMKB",.T.)
			FOR nX := 1 TO LEN( aCampos )
				bCampo := aCampos[nX]
				&bCampo
			NEXT
	
			TRBMKB->E1_OK 		:= ""
			TRBMKB->E1_FILIAL	:= SE1->E1_FILIAL
			TRBMKB->E1_SALDO	:= SE1->E1_SALDO
			TRBMKB->SE1REG 		:= nREGSE1
			MSUNLOCK()
		ENDIF
		
		DbSelectArea("TRBSE1")
		DbSkip()
	ENDDO
	TRBSE1->( DbCloseArea() )

RETURN 


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaTud

Marca ou desmarca todos os itens do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaTud()

	DbSelectArea("TRBMKB")
	DbGoTop()
	DO WHILE !EOF()
		MarcaIte()
	
		TRBMKB->( DbSkip() )
	ENDDO

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaIte

Marca ou desmarca o item do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaIte()

	IF IsMark("E1_OK",cMark )
		nXVALMUT -= TRBMKB->E1_SALDO
		
		RecLock("TRBMKB",.F.)
		TRBMKB->E1_OK 		:= ""
		TRBMKB->( MsUnLock() )
	ELSE
 		nXVALMUT += TRBMKB->E1_SALDO

		RecLock("TRBMKB",.F.)
		TRBMKB->E1_OK 		:= cMark
 		TRBMKB->( MsUnLock() )
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixarTit

Baixa os t�tulos a receber marcados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BaixarTit()
	LOCAL lRet		:= .T.
	LOCAL cCRLF		:= CHR(13) + CHR(10)	

	IF lRet
		IF nE5_VALOR == 0
			MsgAlert("N�o existe valor para baixar", "Aten��o")
		 	lRet := .F.
		ENDIF
	ENDIF
	
	IF lRet
		IF nXVALMUT == 0
			MsgAlert("� necess�rio selecionar os t�tulos a receber para baixar", "Aten��o")
		 	lRet := .F.
		ENDIF
	ENDIF
	
	IF lRet
		IF nE5_VALOR <> nXVALMUT
			MsgAlert("Valor da movimenta��o diverge do valor selecionado para baixa: " + cCRLF + cCRLF +;
		 			 "Valor da movimenta��o: " + TRANSFORM(nE5_VALOR, PESQPICT("SE5", "E5_VALOR")) + cCRLF +;
		 			 "Valor selecionado: " + TRANSFORM(nXVALMUT, PESQPICT("SE5", "E5_VALOR")), "Aten��o")
		 	lRet := .F.
		ENDIF
	ENDIF
				
	IF lRet
		IF MsgNoYes("Deseja realmente baixar os t�tulos a receber marcados?" + cCRLF + cCRLF +;
		 			 "Valor da movimenta��o: " + TRANSFORM(nE5_VALOR, PESQPICT("SE5", "E5_VALOR")) + cCRLF +;
		 			 "Valor selecionado: " + TRANSFORM(nXVALMUT, PESQPICT("SE5", "E5_VALOR")), "Confirme")
		 			 
			Processa({|| BaixarPro()},"Processando", "", .F.)
		ENDIF	
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixarPro

Processa a baixa dos t�tulos a rebecer marcados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BaixarPro()
	LOCAL nReg		:= 0
	LOCAL nProcess	:= 0
	LOCAL lRetExec	:= .F.
	LOCAL nE1_SALDO	:= 0
	
	TRBMKB->(dbEval({|| nReg++ },,{|| !Eof()}))
	TRBMKB->(dbGoTop())  

	ProcRegua(nReg)

	DbSelectArea("TRBMKB")
	DbGoTop()
	DO WHILE !EOF()
		IncProc("Efetuando a baixa...")
		
		IF IsMark("E1_OK",cMark )
			DbSelectArea("SE1")
			DbGoTo( TRBMKB->SE1REG )
			nE1_SALDO := SE1->E1_SALDO
			
			//-----------------------------------------------------------------------
			// Baixa o t�tulo a pagar via ExecAuto
			//-----------------------------------------------------------------------
			lRetExec := ExeBaixa(cEMPANT, SE1->E1_FILIAL)
				
			IF lRetExec 
				//-----------------------------------------------------------------------
				// baixou o t�tulo
				//-----------------------------------------------------------------------
				IF SE5->( FIELDPOS("E5_XVALMUT") ) > 0
					DbSelectArea("SE5")
					DbGoTo( TRB->SE5REG )
					RecLock("SE5", .F.)
					SE5->E5_XVALMUT := SE5->E5_XVALMUT + nE1_SALDO
					SE5->( MsUnLock() )
				ENDIF

				DbSelectArea("TRB")
				RecLock("TRB", .F.)
				TRB->E5_XVALMUT := TRB->E5_XVALMUT + nE1_SALDO
				//TRB->( DbDelete() )
				TRB->( MsUnLock() )
				
				DbSelectArea("TRBMKB")
				RecLock("TRBMKB", .F.)
				TRBMKB->( DbDelete() )
				TRBMKB->( MsUnLock() )

				nE5_VALOR 	-= nE1_SALDO
		 		nXVALMUT	-= nE1_SALDO
					
				nProcess++
			ENDIF
		ENDIF

		DbSelectArea("TRBMKB")
		TRBMKB->( DbSkip() )
	ENDDO

	MsgInfo("Processo conclu�do. Foi(ram) baixado(s) " + ALLTRIM(STR(nProcess)) + " t�tulo(s) a receber", "Ok")
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExeBaixa

Baixa o t�tulo a receber via ExecAuto

@param		cEMPANT = Grupo de empresa da baixa
			cFILANT = Filial da baixa
@return		lRet = Se ocorreu erro
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExeBaixa(cEMPPAR, cFILPAR)
	LOCAL aAreaSE5		:= {}
	LOCAL lRet			:= .T.
	LOCAL nOPC			:= 3 // Baixa t�tulo (nOpc = 3)
	LOCAL aDadosSE1		:= {}
	LOCAL cAUTBANCO 	:= PADR( "", TAMSX3("E5_BANCO")[1])
	LOCAL cAUTAGENCI	:= PADR( "", TAMSX3("E5_AGENCIA")[1])
	LOCAL cAUTCONTA		:= PADR( "", TAMSX3("E5_CONTA")[1])
	LOCAL cAUTMOTBX 	:= GETNEWPAR( "AS_MOTMUT", "MUT", SE1->E1_FILIAL )
	LOCAL cEMPAUX		:= cEMPANT
	LOCAL cFILAUX		:= cFILANT
	LOCAL cPREFIXO		:= SE1->E1_PREFIXO
	LOCAL cNUM			:= SE1->E1_NUM
	LOCAL cPARCELA		:= SE1->E1_PARCELA
	LOCAL cTIPO			:= SE1->E1_TIPO
	LOCAL cCLIENTE		:= SE1->E1_CLIENTE
	LOCAL cLOJA			:= SE1->E1_LOJA
	LOCAL cNATUREZ		:= SE1->E1_NATUREZ
	
	PRIVATE lMsErroAuto := .F.	// vari�vel que define que o help deve ser gravado no arquivo de log e que as informa��es est�o vindo � partir da rotina autom�tica.


	//-----------------------------------------------------------------------
	// Array para o ExecAuto
	//-----------------------------------------------------------------------
	aDadosSE1 := {;
		{"E1_FILIAL"	, cFILPAR				, NIL		},;
		{"E1_PREFIXO"	, cPREFIXO				, NIL		},;
		{"E1_NUM"		, cNUM					, NIL		},;
		{"E1_PARCELA"	, cPARCELA				, NIL		},;
		{"E1_TIPO"		, cTIPO					, NIL		},;
		{"E1_CLIENTE"	, cCLIENTE				, NIL		},;
		{"E1_LOJA"		, cLOJA					, NIL		},;
		{"E1_NATUREZ"	, cNATUREZ				, NIL		},;
		{"AUTMOTBX"		, cAUTMOTBX				, NIL		},;
		{"AUTBANCO"		, cAUTBANCO				, NIL		},;
		{"AUTAGENCIA"	, cAUTAGENCI			, NIL		},;
		{"AUTCONTA"		, cAUTCONTA				, NIL		},;
		{"AUTDTBAIXA"	, dDATABASE				, NIL		},;
		{"AUTDTCREDITO"	, DataValida(dDATABASE)	, NIL		},;
		{"AUTHIST"		, ""					, NIL    	},;
		{"AUTDESCONT"	, 0						, NIL, .T.	},;
		{"AUTJUROS"		, 0						, NIL, .T.	},;
		{"AUTMULTA"		, 0						, NIL, .T.	},;
		{"AUTVALREC"	, SE1->E1_SALDO			, NIL		};
		}
	
	//-----------------------------------------------------------------------
	// Indica o grupo de empresas e filial da baixa
	//-----------------------------------------------------------------------
	cEMPANT := cEMPPAR
	cFILANT	:= cFILPAR

	//-----------------------------------------------------------------------
	// Ordenar um vetor conforme o dic. para uso em rotinas de MSExecAuto
	//-----------------------------------------------------------------------
	aDadosSE1	:= FWVetByDic( aDadosSE1, 'SE1' )

	DbSelectArea("SE1")
	lMsErroAuto := .F.
	BeginTran()
	MSExecAuto({|x,y| Fina070(x,y)}, aDadosSE1, nOPC)//  3=Baixa de T�tulo; 5=Cancelamento de baixa; 6=Exclus�o de Baixa
		
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
			
		lRet := .F.
	Else
		EndTran()

		//-----------------------------------------------------------------------
		// Seta a filial origem da movimentacao bancaria
		//-----------------------------------------------------------------------
		aAreaSE5 := SE5->( GetArea() )
		DbSelectArea("SE5")
		DbSetOrder(7) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		IF DbSEEK(cFILPAR + cPREFIXO + cNUM + cPARCELA + cTIPO + cCLIENTE + cLOJA)
			DO WHILE !SE5->( EOF() ) .AND. ;
				SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
				cFILPAR + cPREFIXO + cNUM + cPARCELA + cTIPO + cCLIENTE + cLOJA
	
				RecLock("SE5", .F.)
				SE5->E5_XBCOFIL := cFILAUX
				SE5->( MsUnLock() )
				
				SE5->( DbSkip() )
			ENDDO
		ENDIF
		SE5->( RestArea(aAreaSE5) )
			
		lRet := .T.
	EndIf
		
	MsUnlockAll()

	//-----------------------------------------------------------------------
	// Restaura o grupo de empresas e filial
	//-----------------------------------------------------------------------
	cEMPANT := cEMPAUX
	cFILANT	:= cFILAUX

RETURN lRet