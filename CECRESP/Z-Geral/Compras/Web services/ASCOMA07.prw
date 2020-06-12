#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA07()

Consome WS no Fluig para excluir uma substituição de aprovador.
O registro SAK - Cadastro de aprovadores - deve estar posicionado 

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		18/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA07()
	LOCAL nOpc     	:= 0
	LOCAL aSay   	:= {}
	LOCAL aButton 	:= {}    
	LOCAL cDesc1	:= OemToAnsi('Aprovação Fluig: O objetivo desta rotina é excluir a        ')
	LOCAL cDesc2	:= OemToAnsi('substituição do aprovador.                                  ')
	LOCAL cDesc3	:= OemToAnsi('')
	LOCAL cDesc4	:= OemToAnsi('')
	LOCAL cDesc5	:= OemToAnsi('O aprovador que terá a substituição excluída deve estar     ')
	LOCAL cDesc6	:= OemToAnsi('posicionado no browse                                       ')
	LOCAL cDesc7  	:= OemToAnsi('')
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}

	LOCAL cAprovador	:= UsrRetMail(SAK->AK_USER) //UsrRetName(SAK->AK_USER) alterado para o Email que é a matricula no Fluig

	PRIVATE cCadastro 	:= OEMTOANSI("Exclusão da substituição do aprovador no Fluig")

	// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
	aAdd( aSay, cDesc6 )
	aAdd( aSay, cDesc7 )

	IF EMPTY(SAK->AK_XSUBAPR)
		MsgAlert("Não é necessário executar a exclusão da substituição pois o aprovador " + ALLTRIM(cAprovador) + " não foi substituído!")		

		aAdd( aButton, { 2,.T.,{|| FechaBatch()}})
	ELSE
		aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
		aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	ENDIF
	
	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		//-----------------------------------------------------------------------
		// Consome WS no Fluig para excluir a substituição do aprovador
		//-----------------------------------------------------------------------
		Processa({|| ExcSubstAp(cAprovador, SAK->AK_XSUBAPR)},"Excluindo a substituição do aprovador no Fluig")
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExcSubstAp()

Consome WS no Fluig para excluir a substituição do aprovador

@param		cAprovador, cSubstApro 
@return		Nenhum
@author 	Fabio Cazarini
@since 		18/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExcSubstAp(cAprovador, cSubstApro)
	LOCAL cFLUUSER		:= SuperGetMv("AS_FLUUSER",.T.,"IntegradorFluig")
	LOCAL cFLUPASS		:= SuperGetMv("AS_FLUPASS",.T.,"Integra1450")
	LOCAL cResult		:= ""
	LOCAL oOBJ 
	LOCAL nOpc			:= 1
	LOCAL cQuery		:= ""
	LOCAL cUserAprov	:= ""
	
	nOpc := Aviso("Atenção!","Confirma exclusão da substituição do aprovador " + ALLTRIM(cAprovador) + ", substituído pelo aprovador " + ALLTRIM(cSubstApro) + " ?",{"Ca&ncelar","&Confirma"})

	IF nOpc == 2

		//-----------------------------------------------------------------------
		// Inicializa objeto
		//-----------------------------------------------------------------------
		oObj	:= WSECMColleagueReplacementServiceService():New()
		           
		oObj:cusername 				:= cFLUUSER
		oObj:cpassword 				:= cFLUPASS
		oObj:ncompanyId 			:= 1

		oObj:ccolleagueId 			:= ALLTRIM(cAprovador)
		oObj:creplacementId 		:= ALLTRIM(cSubstApro)

		IF oObj:deleteColleagueReplacement()
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
				cQuery += "SET 	AK_XSUBAPR = '', "
				cQuery += "     AK_XSUBINI = '', "
				cQuery += "     AK_XSUBFIM = '' "
				cQuery += "WHERE 	AK_FILIAL = '" + xFilial("SAK") + "' "
				cQuery += "		AND AK_USER = '" + ALLTRIM(cUserAprov) + "' "
				cQuery += "		AND AK_XSUBAPR = '" + ALLTRIM(cSubstApro) + "' "
				cQuery += "		AND D_E_L_E_T_ = ' ' "
			
				TcSqlExec(cQuery)
				SC7->(MsGoto(RecNo()))
					
				MsgInfo("Foi excluída a substituição do aprovador " + ALLTRIM(cAprovador))
			ELSE
				MsgAlert("Não foi possível excluir a substituição do aprovador no Fluig - " + cResult)
			ENDIF
		ELSE
			cResult 	:= cResult

			MsgAlert("Não foi possível excluir a substituição do aprovador no Fluig - " + cResult)
		ENDIF
	ENDIF

RETURN