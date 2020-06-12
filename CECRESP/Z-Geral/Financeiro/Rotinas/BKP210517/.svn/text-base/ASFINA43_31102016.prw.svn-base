#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA43()

Inclusão de título de mútuo no borderô de pagamentos

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		22/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA43()
	LOCAL aArea			:= GetArea()
	LOCAL nOpca			:= 0
	LOCAL oDlg
	LOCAL oPanel

	PRIVATE cNumBor 	:= ""
	PRIVATE dVenIni240	:= dDataBase
	PRIVATE dVenFim240	:= dDataBase
	PRIVATE cPort240	:= Criavar("A6_COD")
	PRIVATE cAgen240	:= CriaVar("A6_AGENCIA")
	PRIVATE cConta240	:= CriaVar("A6_NUMCON")
	PRIVATE cModPgto	:= CriaVar("EA_MODELO")
	PRIVATE cTipoPag	:= CriaVar("EA_TIPOPAG")
	PRIVATE lIncluir	:= .F.

	//-----------------------------------------------------------------------
	// Verifica numero do ultimo Bordero Gerado
	//-----------------------------------------------------------------------
	cNumBor := Pad(GetMV("MV_NUMBORP"),Len(SE2->E2_NUMBOR))

	DEFINE MSDIALOG oDlg FROM  15,6 TO 219,404 TITLE "Borderô de Pagamentos - Mútuo" PIXEL

	@ 06, 009 SAY "Número"		SIZE 23, 7 OF oPanel PIXEL
	@ 06, 045 SAY "Vencto de"	SIZE 32, 7 OF oPanel PIXEL
	@ 06, 090 SAY "Até"			SIZE 32, 7 OF oPanel PIXEL
	@ 40, 009 SAY "Banco"		SIZE 23, 7 OF oPanel PIXEL
	@ 40, 045 SAY "Agência"		SIZE 32, 7 OF oPanel PIXEL
	@ 40, 085 SAY "Conta"		SIZE 32, 7 OF oPanel PIXEL
	@ 73, 009 SAY "Modelo"		SIZE 22, 7 OF oPanel PIXEL
	@ 73, 045 SAY "Tipo Pagto"	SIZE 32, 7 OF oPanel PIXEL

	//-----------------------------------------------------------------------
	// Linha 1
	//-----------------------------------------------------------------------
	@ 15, 009 MSGET cNumBor		SIZE 32, 10 OF oPanel PIXEL HASBUTTON ;
				Picture "@!" Valid !Empty(cNumBor) .AND. VldNumBor(cNumBor)
	@ 15, 045 MSGET dVenIni240	SIZE 45, 10 OF oPanel PIXEL HASBUTTON
	@ 15, 090 MSGET dVenFim240	SIZE 45, 10 OF oPanel PIXEL HASBUTTON Valid !EMPTY(dVenFim240) .AND. dVenFim240 >= dVenIni240

	//----------------------------------------------------------------------- 
	// Linha 2
	//-----------------------------------------------------------------------
	@ 49, 009 MSGET cPort240	SIZE 10, 10 OF oPanel PIXEL HASBUTTON ;
				Picture "@!" F3 "SA6"  When lIncluir Valid CarregaSa6(@cPort240,@cAgen240,@cConta240,.F.)
	@ 49, 045 MSGET cAgen240	SIZE 26, 10 OF oPanel PIXEL ;
				Picture "@!" HASBUTTON When lIncluir Valid CarregaSa6(@cPort240,@cAgen240,@cConta240,.F.)
	@ 49, 085 MSGET cConta240	SIZE 62, 10 OF oPanel PIXEL ;
				Picture "@!" HASBUTTON When lIncluir Valid CarregaSa6(@cPort240,@cAgen240,@cConta240,.F.)

	//-----------------------------------------------------------------------
	// Linha 3
	//-----------------------------------------------------------------------
	@ 82, 009 MSGET cModPgto	SIZE 25, 10 OF oPanel PIXEL HASBUTTON ; 
				Picture "@!" F3 "58"  When lIncluir Valid ExistCpo("SX5", + "58" + cModPgto)
	@ 82, 045 MSGET cTipoPag	SIZE 25, 10 OF oPanel PIXEL HASBUTTON ;
				Picture "@!" F3 "59"  When lIncluir Valid ExistCpo("SX5", + "59" + cTipoPag)

	DEFINE SBUTTON FROM 83, 140 TYPE 1 ENABLE OF oPanel ACTION (nOpca:=1, If(DadosOK(), oDlg:End(), nOpca := 0 ))
	DEFINE SBUTTON FROM 83, 170 TYPE 2 ENABLE OF oPanel ACTION (nOpca:=0,oDlg:End()) 

	ACTIVATE MSDIALOG oDlg CENTERED		

	IF nOpca == 1
		PROCESSA({|lEnd| TelaMark()},"Processando")
	ENDIF

	RestArea( aArea )
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} VldNumBor()

Valida o número do borderô e busca os dados

@param		cNumBor = Número do borderô
@return		lRet = Dados ok ou não
@author 	Fabio Cazarini
@since 		25/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION VldNumBor(cNumBor)
	LOCAL lRet 			:= .T.

	DbSelectArea("SEA")
	DbSetOrder(2) //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
	IF DbSEEK( xFILIAL("SEA") + cNumBor + "P" )
		cPort240	:= SEA->EA_PORTADO
		cAgen240	:= SEA->EA_AGEDEP
		cConta240	:= SEA->EA_NUMCON
		cModPgto	:= SEA->EA_MODELO
		cTipoPag	:= SEA->EA_TIPOPAG
		
		lIncluir := .F.
	ELSE
		lIncluir := .T.
	ENDIF
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} DadosOK()

Valida dados da tela

@param		Nenhum
@return		lRet = Dados ok ou não
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION DadosOK()
	LOCAL lRet 			:= .T.

	//-----------------------------------------------------------------------
	// Valida o portador digitado
	//-----------------------------------------------------------------------
	IF lRet
		dbSelectArea("SA6")
		If !(dbSeek(xFILIAL("SA6")+cPort240+cAgen240+cConta240))
			MsgAlert("Conta não cadastrada","Atenção")
			lRet := .F.
		ElseIf SA6->A6_BLOCKED == "1"
			MsgAlert("Conta bloqueada para uso","Atenção")
			lRet := .F.
		EndIf
	ENDIF

	//-----------------------------------------------------------------------
	// Valida o modelo digitado
	//-----------------------------------------------------------------------
	IF lRet
		IF EMPTY(cModPgto)
			MsgAlert("Digite o modelo de pagamento!","Atenção")
			lRet := .F.
		ELSE
			DbSelectArea("SX5")
			DbSetOrder(1) // X5_FILIAL+X5_TABELA+X5_CHAVE
			IF !DbSEEK(xFILIAL("SX5") + "58" + cModPgto)
				MsgAlert("O modelo " + cModPgto + " não é válido!","Atenção")
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Valida o tipo de pagamento digitado
	//-----------------------------------------------------------------------
	IF lRet
		IF EMPTY(cTipoPag)
			MsgAlert("Digite o tipo de pagamento!","Atenção")
			lRet := .F.
		ELSE
			DbSelectArea("SX5")
			DbSetOrder(1) // X5_FILIAL+X5_TABELA+X5_CHAVE
			IF !DbSEEK(xFILIAL("SX5") + "59" + cTipoPag)
				MsgAlert("O tipo de pagamento " + cTipoPag + " não é válido!","Atenção")
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} TelaMark()

Tela estilo MarkBrowse para seleção dos registros

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		25/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TelaMark()
	
	PRIVATE arotina 	:= {}
	PRIVATE cCADASTRO	:= "Borderô de Pagamentos - Mútuo"
	PRIVATE cMark		:= GetMark()
	PRIVATE aFields		:= {}
	PRIVATE cArq		:= ""
	PRIVATE bOpc1 		:= {|| MarcaTud()}
	PRIVATE bOpc2 		:= {|| MarcaIte()}
	PRIVATE bOpc3 		:= {|| Processa({|| IncluiBor()},"Processando")}
	
	AADD( aRotina, { "Incluir títulos no borderô"	,"Eval(bOpc3)" 	, 0, 4} )

	//-----------------------------------------------------------------------
	// Gera arquivo temporario 
	//-----------------------------------------------------------------------
	Processa({|| MontaTrb()},"Processando...", "", .F.)

	DbSelectArea("TRB")
	DbGotop()
	MarkBrow( 'TRB', 'E2_OK',,aFields,, cMark ,"Eval(bOpc1)"   ,,,,"Eval(bOpc2)"   ,,,.T.,)
	
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
@since 		25/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MontaTRB()
	LOCAL aStru		:= {}
	LOCAL aCampos	:= {}
	LOCAL nX          
	LOCAL bCampo
	LOCAL cCampo	:= ""
	LOCAL cQuery	:= ""
	LOCAL nREGSE2	:= 0
	LOCAL cFil240	:= ""
	
	//-----------------------------------------------------------------------
	// Monta TRB com registros 
	//-----------------------------------------------------------------------
	cQuery := " SELECT SE2.R_E_C_N_O_  AS REGSE2 "
	cQuery += " FROM " + RetSqlName("SE2") + " SE2 "
	cQuery += " WHERE	SE2.E2_XBCOFIL = '" + xFILIAL("SE2") + "' " 
	cQuery += "		AND SE2.E2_VENCREA BETWEEN '" + DtoS(dVenIni240) + "' AND '" + DtoS(dVenFim240) + "' "
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
	
	//-----------------------------------------------------------------------
	// Verifica se pode baixar sem aprovação
	//-----------------------------------------------------------------------
	If GetMv("MV_CTLIPAG")
		cQuery += " AND (SE2.E2_DATALIB <> ' '"
		cQuery += " OR (SE2.E2_SALDO+SE2.E2_SDACRES-SE2.E2_SDDECRE<="+ALLTRIM(STR(GetMv('MV_VLMINPG'),17,2))+"))"
	Endif
	
	IF (ExistBlock("F240FIL"))
		cFil240 := ExecBlock("F240FIL",.f.,.f.)
		IF !EMPTY(cFil240)
			cQuery 	+= " 	AND " + cFil240
		ENDIF	
	ENDIF
	
	cQuery += " 	AND SE2.D_E_L_E_T_ = ' '	"

	IF SELECT("TRBE2") > 0
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
	AADD(aStru,	{"E2_OK"	, "C", TAMSX3("E2_OK")[01]	, 0	})
	AADD(aStru,	{"SE2REG"	, "N", 10					, 0	})
	
	//-----------------------------------------------------------------------
	// Lista das colunas do MarkBrowse
	//-----------------------------------------------------------------------
	AADD(aFields,	{"E2_OK", "", ""})

	dbSelectArea("SX3")
	DbSetOrder(1)
	DbGoTop()
	dbSeek("SE2")
	While !Eof().And.(SX3->x3_arquivo=="SE2")
		If Alltrim(SX3->x3_campo)=="E2_FILIAL" .OR. Alltrim(SX3->x3_campo)=="E2_OK" .OR. Alltrim(SX3->x3_visual)=="V" 
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

		DBSELECTAREA("TRB")
		RECLOCK("TRB",.T.)
		FOR nX := 1 TO LEN( aCampos )
			bCampo := aCampos[nX]
			&bCampo
		NEXT
		TRB->E2_OK 	:= cMark
		TRB->SE2REG := nREGSE2
		MSUNLOCK()
		
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
@since 		25/07/2016
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
@since 		25/07/2016
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
/*/{Protheus.doc} IncluiBor()

Inclui os títulos de mútuo no borderô indicado

@param		Nenhum
@return		nRet = Quantidade de títulos de mútuo incluídos no borderô
@author 	Fabio Cazarini
@since 		25/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION IncluiBor()
	LOCAL nProcess		:= 0
	LOCAL nCntProc		:= 0
	LOCAL lEA_ORIGEM	:= Iif (SEA->(FieldPos( "EA_ORIGEM" )) > 0, .T., .F.)
	LOCAL lIncluiBor	:= .F.
	
	IF !MsgNoYes("Deseja realmente incluir o(s) título(s) marcado(s) no borderô?","Confirme")
		RETURN
	ENDIF
	
	TRB->(dbEval({|| nCntProc++ },,{|| !Eof() .AND. TRB->E2_OK == cMark}))
	ProcRegua( nCntProc )

	DbSelectArea("TRB")
	DbGoTop()
	DO WHILE !EOF()
		
		IF IsMark("E2_OK",cMark )
			IncProc( "Aguarde..." )
					
			DbSelectArea("SE2")
			DbGoTo( TRB->SE2REG )
		
			dbSelectArea("SEA")
			DbSetOrder(2) // EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
			IF !MsSEEK( xFilial("SEA") + cNumBor + "P" + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA )
				nProcess++
				
				IF lIncluir
					lIncluiBor := .T.
				ENDIF	
			
				RecLock("SEA",.T. )
				Replace	EA_FILIAL  With xFilial("SEA") ,;
						EA_PORTADO With cPort240 ,;
						EA_AGEDEP  With cAgen240 ,;
						EA_NUMCON  With cConta240 ,;
						EA_NUMBOR  With cNumBor ,;
						EA_DATABOR With dDataBase ,;
						EA_PREFIXO With SE2->E2_PREFIXO ,;
						EA_NUM     With SE2->E2_NUM ,;
						EA_PARCELA With SE2->E2_PARCELA ,;
						EA_TIPO    With SE2->E2_TIPO ,;
						EA_FORNECE With SE2->E2_FORNECE ,;
						EA_LOJA	   With SE2->E2_LOJA ,;
						EA_CART    With "P" ,;
						EA_MODELO  With cModPgto ,;
						EA_TIPOPAG With cTipoPag ,;
						EA_FILORIG With SE2->E2_FILIAL
						
				IF lEA_ORIGEM											
					SEA->EA_ORIGEM := FUNNAME()
				ENDIF	
				SEA->( MsUnlock() )
				FKCOMMIT()
	
				dbSelectArea("SE2")
				RecLock("SE2",.F.)
				Replace E2_NUMBOR  With cNumBor
				Replace E2_PORTADO With cPort240
				SE2->( MsUnlock( ) )
				FKCOMMIT()
			ENDIF
		ENDIF
		
		DbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->E2_OK := ""
		TRB->( MsUnlock() )
		
		TRB->( DbSkip() )
	ENDDO

	IF lIncluiBor
		//-----------------------------------------------------------------------
		// Grava o numero do bordero atualizado
		// Utilize sempre GetMv para posicionar o SX6. N„o use SEEK !!!
		//-----------------------------------------------------------------------
		dbSelectArea("SX6")
		GetMv("MV_NUMBORP")
		//-----------------------------------------------------------------------
		// Garante que o numero do bordero seja sempre superior ao numero anterior
		//-----------------------------------------------------------------------
	  	If ALLTRIM(SX6->X6_CONTEUD) < cNumbor
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNumbor
			msUnlock()
		Endif
	ENDIF
	
	MSGALERT("Processo concluído. Foi(ram) incluido(s) " + ALLTRIM(STR(nProcess)) + " título(s) no borderô " + cNumBor, "Ok")
	
RETURN 