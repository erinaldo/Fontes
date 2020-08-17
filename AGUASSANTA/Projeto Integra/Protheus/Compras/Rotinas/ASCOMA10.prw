#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA10()

Controles do processo do pedido de compras
Se exclusão, solicita digitação de observação da exclusão

Se inclusão ou alteração, ao gravar o pedido de compra que gera contrato 
no TOP, deve ser validado se foi informado o projeto e tarefa 

Chamado pelo PE MT120OK e MTA120E

@param		cNum  		= Número do pedido de compras 
			lInclui		= É inclusão?
			lAltera		= É alteração?
			lExclui		= É exclusão?

@return		lRet = Continua ou não a operação
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA10(cNum, lInclui, lAltera, lExclui)
	LOCAL aArea			:= GetArea()
	LOCAL lRet 			:= .T.
	LOCAL cQuery		:= ""
	LOCAL aRetGetTex	:= {}
	LOCAL aProjeto 		:= {}
	LOCAL aTarefa		:= {}
	LOCAL cGrupo		:= ""
	LOCAL nX			:= 0
	
	IF IsInCallStack("ASCOMA04") // Exclusão de pedido originado via SC do TOP
		RETURN .T.
	ENDIF
	IF IsInCallStack("MATI120") // EAI ADAPTER 
		RETURN .T.
	ENDIF

	IF lExclui
		//-----------------------------------------------------------------------
		// Não será permitido efetuar nenhuma operação com este pedido, já que 
		// o pedido foi enviado ao TOP e está com resíduo eliminado no Protheus
		//-----------------------------------------------------------------------
		IF !EMPTY(SC7->C7_XCNTTOP)
			lRet := .F.
			Help('',1,'Inconsistência - ' + PROCNAME(),,'Este pedido não pode ser excluído pois tem contrato no TOP gerado a partir dele',4,1)
		ELSE
			//-----------------------------------------------------------------------
			// Não será permitido efetuar nenhuma operação com este pedido, já que 
			// ele está reprovado e com resíduo eliminado no Protheus
			//-----------------------------------------------------------------------
			IF SC7->C7_XSFLUIG == 'R' // pedido de compras reprovado
				lRet := .F.
				Help('',1,'Inconsistência - ' + PROCNAME(),,'Este pedido não pode ser excluído pois foi reprovado no Fluig',4,1)
			ELSEIF SC7->C7_XSFLUIG == 'A' // pedido de compras aprovado
				IF !IsBlind() // a conexão efetuada com o Protheus não possui interface com o usuário
					IF !MsgNoYes("Este pedido já está aprovado. Deseja realmente excluí-lo?","Confirme")
						lRet := .F.
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
		IF lRet
			IF !IsBlind() // a conexão efetuada com o Protheus não possui interface com o usuário
				//-----------------------------------------------------------------------
				// Solicita observação para gravar no campo C7_OBS 
				//-----------------------------------------------------------------------
				//Aviso ( cTitulocMsgaBotoes [ nSize ] [ cText ] [ nRotAutDefault ] [ cBitmap ] [ lEdit ] [ nTimer ] [ nOpcPadrao ] ) --> nOpcAviso
				aRetGetTex := GetTexto("Observação da exclusão", LEN(SC7->C7_OBS), "")

				IF aRetGetTex[1] <> 1 // se cancelou
					lRet := .F.
				ELSE
					IF !EMPTY(aRetGetTex[2]) // se digitou observações
						SC7->(DBCOMMIT())

						cQuery := "UPDATE " + RetSqlname("SC7") + " "
						cQuery += "SET 	C7_OBS = '" + PADR(aRetGetTex[2], LEN(SC7->C7_OBS)) + "' "
						cQuery += "WHERE 	C7_FILIAL = '" + xFilial("SC7") + "' "
						cQuery += "		AND C7_NUM = '" + cNum + "' "
						cQuery += "		AND D_E_L_E_T_ = ' ' "

						TcSqlExec(cQuery)
						SC7->(MsGoto(RecNo()))
					ENDIF
				ENDIF
			ENDIF
		ENDIF

	ELSEIF lInclui .OR. lAltera
		//-----------------------------------------------------------------------
		// Se contrato TOP, Deve ser informado o projeto e tarefa
		//-----------------------------------------------------------------------
		//IF VALTYPE("_cEHCT") <> "C"
		//	RETURN .T.
		//ENDIF

		//-----------------------------------------------------------------------
		// CONTRATO TOP - Se contrato TOP, deve ser informado o projeto e tarefa
		// Retorna array com os projetos do PC:
		// - {FILIAL, PROJET, CONTR, QUANTAJ7, nQUANTITC7, nTOTALITC7, nTOTAJ7}
		//-----------------------------------------------------------------------
		//IF _cEHCT == "1" // Contrato TOP 1=SIM, 2=NÃO
			aProjeto 	:= {}
			aTarefa		:= {}
			lRet 		:= U_ASCOMA22(lInclui, lAltera, .F., xFilial("SC7"), cNum, @aProjeto, @aTarefa)
		//ENDIF
		
		//-----------------------------------------------------------------------
		// CONTRATO TOP - Vl max. liberado p/contrato TOP tem saldo disponivel?
		//-----------------------------------------------------------------------
		IF lRet
			//-----------------------------------------------------------------------
			// Grupo de Aprovacao default que sera utilizado na aprovacao dos PC
			//-----------------------------------------------------------------------
			cGrupo := ALLTRIM(SuperGetMv("MV_PCAPROV",.T.,"")) 
	
			//IF _cEHCT == "1" // Contrato TOP 1=SIM, 2=NÃO
				IF LEN(aTarefa) > 0
					//IF LEN(aProjeto) > 1
					//	Help('',1,'Contrato TOP - ' + PROCNAME(),,'Não é permitido lançar mais de um projeto/contrato por pedido de compras!',4,1)	
					//	lRet := .F.
					//ELSE
						IF !U_ASCOMA23(cNum, lAltera, aTarefa)
							//-----------------------------------------------------------------------
							// Projeto sem saldo no RM, Grp Aprov (C7_APROV) = AS_APRSSD
							//-----------------------------------------------------------------------
							cGrupo := ALLTRIM(SuperGetMv("AS_APRSSD",.T.,""))
						ENDIF
					//ENDIF
				ENDIF
			//ENDIF
			
			//-----------------------------------------------------------------------
			// Atribui grupo de aprovação
			//-----------------------------------------------------------------------
			FOR nX := 1 TO LEN(aCols)
				IF !GDDELETED(nX, aHeader, aCols) // se o item não está deletado
					GDFIELDPUT ( "C7_APROV", cGrupo, nX, aHeader, aCols, .F. )
				ENDIF
			NEXT nX
		ENDIF
	ENDIF

	RestArea(aArea)

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} GetTexto()

Caixa de texto 

@param		cTitulo  	= Título da janela 
			nTam		= Tamanho do texto
			cTexto		= Texto inicial

@return		Array = nOpc e Texto digitado
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION GetTexto(cTitulo, nTam, cTexto)
LOCAL oFont1 	:= TFont():New("MS Sans Serif",,018,,.F.,,,,,.F.,.F.)
LOCAL oButton1
LOCAL oButton2
LOCAL oDlg
LOCAL nOpc		:= 0

cTexto := PADR(cTexto, nTam)

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 150, 375 COLORS 0, 16777215 PIXEL

@ 015, 008 MSGET oGet1 VAR cTexto 		SIZE 176, 015 OF oDlg COLORS 0, 16777215 WHEN .T. FONT oFont1 PIXEL
@ 050, 093 BUTTON oButton2 PROMPT "Cancela" 	SIZE 037, 012 OF oDlg ACTION {||nOpc := 2, oDlg:End()} PIXEL
@ 050, 052 BUTTON oButton1 PROMPT "Confirma" 	SIZE 037, 012 OF oDlg ACTION {||nOpc := 1, oDlg:End()} PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

RETURN {nOpc, cTexto}