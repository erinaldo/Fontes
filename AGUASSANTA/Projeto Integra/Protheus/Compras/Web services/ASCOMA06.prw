#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA06()

Consome WS no Fluig para criar um substituto do aprovador.
O registro SAK - Cadastro de aprovadores - deve estar posicionado 

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		17/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA06()
	LOCAL nOpc     	:= 0
	LOCAL aSay   	:= {}
	LOCAL aButton 	:= {}    
	LOCAL cDesc1	:= OemToAnsi('Aprovação Fluig: O objetivo desta rotina é substituir um    ')
	LOCAL cDesc2	:= OemToAnsi('aprovador por outro aprovador, durante p período            ')
	LOCAL cDesc3	:= OemToAnsi('especificado.                                               ')
	LOCAL cDesc4	:= OemToAnsi('')
	LOCAL cDesc5	:= OemToAnsi('O aprovador a ser substituído deve estar posicionado no     ')
	LOCAL cDesc6	:= OemToAnsi('browse                                                      ')
	LOCAL cDesc7  	:= OemToAnsi('')
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}
	LOCAL lRet		:= .F.

	LOCAL cAprovador	:= UsrRetName(SAK->AK_USER)
	LOCAL cSubstApro	:= ""
	LOCAL dDtInic		:= dDATABASE
	LOCAL dDtFinal		:= CTOD("//")
	LOCAL aSubstApro	:= {}

	PRIVATE cCadastro 	:= OEMTOANSI("Substituição de aprovador no Fluig")

	// Mensagens de Tela Inicial
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

	If nOpc == 1
		//-----------------------------------------------------------------------
		// Popula a combo com os aprovadores que podem ser substitutos
		//-----------------------------------------------------------------------
		aSubstApro := RetSubst(SAK->AK_USER)

		IF LEN(aSubstApro) < 1
			MsgAlert("Não existe nenhum outro aprovador para substituir o " + ALLTRIM(cAprovador) + "!")		
		ELSE
			//-----------------------------------------------------------------------
			// Definição dos Parametros da Rotina
			//-----------------------------------------------------------------------
			// 2 - Combo
			//  [2] : Descrição
			//  [3] : Numérico contendo a opção inicial do combo
			//  [4] : Array contendo as opções do Combo
			//  [5] : Tamanho do Combo
			//  [6] : Validação
			//  [7] : Flag .T./.F. Parâmetro Obrigatório ?
			//
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
	
			aAdd(aPar,{2	,"Aprovador substituto"	, aSubstApro[1]	, aSubstApro	, 100, , .T.})
			aAdd(aPar,{1	,"Data inicial"			, dDtInic 	, "", , 		, , 050, .T.})
			aAdd(aPar,{1	,"Data final"			, dDtFinal	, "", , 		, , 050, .T.})
	
			//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet
	
			lRet 	:= ParamBox(aPar,"Substituição Aprovador",@aRet,,,,,,,"ASCOMA06",.T.,.T.)
			IF lRet
				IF !Len(aRet) == Len(aPar)
					MsgAlert("É necessário indicar todos os dados solicitados!")
					lRet := .F.
				ELSE
					cSubstApro	:= ALLTRIM( aRet[01] )
					dDtInic		:= aRet[02]
					dDtFinal	:= aRet[03]
				ENDIF
			ENDIF
		ENDIF
		
		IF lRet
			IF EMPTY(cSubstApro)
				MsgAlert("É necessário indicar o aprovador substituto!")
				lRet := .F.
			ENDIF
		ENDIF

		IF lRet
			IF EMPTY(dDtInic)
				MsgAlert("É necessário indicar a data inicial da substituição!")
				lRet := .F.
			ELSE
				IF dDtInic > dDtFinal
					MsgAlert("A data inicial da substituição deve ser menor ou igual que a data final!")
					lRet := .F.
				ENDIF
			ENDIF
		ENDIF

		IF lRet
			IF EMPTY(dDtFinal)
				MsgAlert("É necessário indicar a data final da substituição!")
				lRet := .F.
			ELSE
				IF dDtInic > dDtFinal
					MsgAlert("A data final da substituição deve ser maior ou igual que a data inicial!")
					lRet := .F.
				ENDIF
			ENDIF
		ENDIF

		//-----------------------------------------------------------------------
		// Consome WS no Fluig para criar um substituto do aprovador.
		//-----------------------------------------------------------------------
		IF lRet
			Processa({|| SubstApr(cAprovador, cSubstApro, dDtInic, dDtFinal)},"Substituindo aprovador no Fluig")
		ENDIF
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} RetSubst()

Retorna aprovadores que podem ser substitutos

@param		cUserAprov (exceto ele) 
@return		aRet = array com os possíveis aprovadores
@author 	Fabio Cazarini
@since 		17/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION RetSubst(cUserAprov)
	LOCAL aRet		:= {}
	LOCAL cQuery 	:= ""

	cQuery := "SELECT SAK.AK_USER "
	cQuery += "FROM " + RetSQLName("SAK") + " SAK "
	cQuery += "WHERE SAK.AK_FILIAL = '" + xFILIAL("SAK") + "' " 
	cQuery += "	  AND SAK.AK_USER <> '" + cUserAprov + "' "
	cQuery += "	  AND SAK.D_E_L_E_T_ = ' ' "    

	IF SELECT("TRBSAK") > 0
		TRBSAK->( DbCloseArea() )
	ENDIF

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TRBSAK",.t.,.t.)

	TRBSAK->( DbGoTop() )
	DO WHILE !TRBSAK->( EOF() )
		AADD( aRet, UsrRetName(TRBSAK->AK_USER) )
	
		TRBSAK->( DbSkip() )
	ENDDO
	TRBSAK->( DbCloseArea() )
		
RETURN aRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} SubstApr()

Consome WS no Fluig para criar um substituto do aprovador.

@param		cAprovador, cSubstApro, dDtInic, dDtFinal 
@return		Nenhum
@author 	Fabio Cazarini
@since 		17/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION SubstApr(cAprovador, cSubstApro, dDtInic, dDtFinal)
	LOCAL cFLUUSER		:= SuperGetMv("AS_FLUUSER",.T.,"IntegradorFluig")
	LOCAL cFLUPASS		:= SuperGetMv("AS_FLUPASS",.T.,"Integra1450")
	LOCAL cResult		:= ""
	LOCAL lRet			:= .T.
	LOCAL oOBJ 
	LOCAL nOpc			:= 1
	LOCAL cQuery		:= ""
	LOCAL cUserAprov	:= ""
	
	nOpc := Aviso("Atenção!","Confirma substituição do aprovador " + ALLTRIM(cAprovador) + " pelo aprovador " + ALLTRIM(cSubstApro) + " no período de " + DTOC(dDtInic) + " a " + DTOC(dDtFinal) + " ?",{"Ca&ncelar","&Confirma"})

	IF nOpc == 2

		//-----------------------------------------------------------------------
		// Inicializa objeto
		//-----------------------------------------------------------------------
		oObj	:= WSECMColleagueReplacementServiceService():New()

		oObj:cusername 				:= cFLUUSER
		oObj:cpassword 				:= cFLUPASS
		oObj:ncompanyId 			:= 1
		
		//-----------------------------------------------------------------------
		// Creates substitute users.
		//-----------------------------------------------------------------------
		ocrDto := ECMColleagueReplacementServiceService_colleagueReplacementDto():New()
				
		ocrDto:ccolleagueId 		:= ALLTRIM(cAprovador)
		ocrDto:ncompanyId 			:= 1
		ocrDto:creplacementId 		:= ALLTRIM(cSubstApro)
		ocrDto:cvalidationFinalDate := ALLTRIM(STR(YEAR(dDtFinal))) + '-' + ALLTRIM(STRZERO(MONTH(dDtFinal),2)) + '-' + ALLTRIM(STRZERO(DAY(dDtFinal),2)) + 'T00:00:00-03:00'
		ocrDto:cvalidationStartDate := ALLTRIM(STR(YEAR(dDtInic))) + '-' + ALLTRIM(STRZERO(MONTH(dDtInic),2)) + '-' + ALLTRIM(STRZERO(DAY(dDtInic),2)) + 'T00:00:00-03:00' 
		ocrDto:lviewGEDTasks 		:= .T.
		ocrDto:lviewWorkflowTasks 	:= .T.

		oObj:oWScreateColleagueReplacementcolleagueReplacement := ocrDto

		IF oObj:createColleagueReplacement()
			cResult := oObj:cresult
			IF UPPER(ALLTRIM(cResult)) == "OK"

				//-----------------------------------------------------------------------
				// Retorna o ID sequencial do aprovador
				//-----------------------------------------------------------------------
				PswOrder(2)						// busca por usuário
				IF PswSeek( cAprovador, .T. )  	
					cUserAprov := PswID() 		// Retorna o ID do ultimo usuário posicionado pela função PswSeek. 
				ENDIF	

				SAK->(DBCOMMIT())
				
				cQuery := "UPDATE " + RetSqlname("SAK") + " "
				cQuery += "SET 	AK_XSUBAPR = '" + ALLTRIM(cSubstApro) + "', "
				cQuery += "     AK_XSUBINI = '" + DTOS(dDtInic) + "', "
				cQuery += "     AK_XSUBFIM = '" + DTOS(dDtFinal) + "' "
				cQuery += "WHERE 	AK_FILIAL = '" + xFilial("SAK") + "' "
				cQuery += "		AND AK_USER = '" + ALLTRIM(cUserAprov) + "' "
				cQuery += "		AND D_E_L_E_T_ = ' ' "
			
				TcSqlExec(cQuery)
				SC7->(MsGoto(RecNo()))
					
				MsgInfo("Aprovador " + ALLTRIM(cAprovador) + " foi substituído por " + ALLTRIM(cSubstApro) + " no período de " + DTOC(dDtInic) + " a " + DTOC(dDtFinal) )
			ELSE
				MsgAlert("Não foi possível substituir o aprovador no Fluig - " + cResult)
			ENDIF
		ELSE
			cResult 	:= GetWSCError()

			MsgAlert("Não foi possível substituir o aprovador no Fluig - " + cResult)
		ENDIF
	ENDIF

RETURN