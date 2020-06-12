#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"         
#INCLUDE "TOTVS.CH"     
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA10()

Webservice no Protheus para ser consumido pelo Fluig com o objetivo 
de realizar integra��o entre os dois sistemas - Aprova��es do Financeiro

M�todos:
detalhesTituloPagar
proximoAprovador
aprovarReprovarTituloPagar

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		09/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSSERVICE IntegraFluigFin Description "Web Service integra��o entre o Protheus e o Fluig - Financeiro"

	//-----------------------------------------------------------------------
	// Dados
	//-----------------------------------------------------------------------
	WSDATA NomeUsuario				AS STRING
	WSDATA SenhaUsuario				AS STRING
	WSDATA CNPJEmpresa 				AS STRING
	WSDATA GrupoEmpresas			AS STRING
	WSDATA NumeroTitulo				AS STRING
	WSDATA PrefixoTitulo			AS STRING
	WSDATA ParcelaTitulo			AS STRING
	WSDATA TipoTitulo				AS STRING
	WSDATA CodigoFornecedor			AS STRING
	WSDATA LojaFornecedor			AS STRING
	WSDATA ListaDetalhesTitulo 		AS ARRAY OF STRUCListaDetalhesTitulo
	WSDATA ListaproximoAprovadorTit	AS ARRAY OF STRUCListaproximoAprovadorTit
	WSDATA ListaaprovarReprovarTit	AS ARRAY OF STRUCListaaprovarReprovarTit
	WSDATA MatriculaAprovador		AS STRING
	WSDATA NivelAprovador			AS STRING
	WSDATA TipoDocumento			AS STRING
	WSDATA Decisao					AS STRING
		
	//-----------------------------------------------------------------------
	// M�todos
	//-----------------------------------------------------------------------
	WSMETHOD detalhesTituloPagar 			DESCRIPTION "M�todo para consultar os dados do t�tulo a pagar do Protheus"
	WSMETHOD proximoAprovador				DESCRIPTION "M�todo para aprovar pelo aprovador atual e consultar o pr�ximo aprovador de acordo com a al�ada no Protheus"
	WSMETHOD aprovarReprovarTituloPagar		DESCRIPTION "M�todo para aprovar ou reprovar o t�tulo a pagar do Protheus"
ENDWSSERVICE

//-----------------------------------------------------------------------
// Estruturas de dados
//-----------------------------------------------------------------------
WSSTRUCT STRUCListaDetalhesTitulo
	WSDATA MatriculaAprovador 	AS STRING	OPTIONAL
	WSDATA NomeAprovador 		AS STRING	OPTIONAL
	WSDATA RazaoSocial 			AS STRING	OPTIONAL
	WSDATA NomeFornecedor 		AS STRING	OPTIONAL
	WSDATA NaturezaFinanceira	AS STRING	OPTIONAL
	WSDATA DescricaoNatureza	AS STRING	OPTIONAL
	WSDATA DataEmissao			AS STRING	OPTIONAL
	WSDATA DataVencimento		AS STRING	OPTIONAL
	WSDATA DataVencimentoReal	AS STRING	OPTIONAL
	//WSDATA ValorTitulo  		AS FLOAT	OPTIONAL
	WSDATA ValorTitulo  		AS STRING	OPTIONAL
	WSDATA Historico 			AS STRING	OPTIONAL
	WSDATA TipoDocumento		AS STRING	OPTIONAL
	WSDATA NivelAprovador 		AS STRING	OPTIONAL
	WSDATA CodigoMoeda  		AS INTEGER	OPTIONAL
	WSDATA SimboloMoeda  		AS STRING	OPTIONAL
	WSDATA NomeMoeda  			AS STRING	OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRUCListaproximoAprovadorTit
	WSDATA MatriculaAprovador 	AS STRING	OPTIONAL
	WSDATA NomeAprovador 		AS STRING	OPTIONAL
	WSDATA NivelAprovador 		AS STRING	OPTIONAL
	WSDATA EmailAprovador 		AS STRING	OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRUCListaaprovarReprovarTit
	WSDATA Transacao			AS STRING	OPTIONAL
	WSDATA Mensagem				AS STRING	OPTIONAL
ENDWSSTRUCT


//-----------------------------------------------------------------------
/*/{Protheus.doc} detalhesTituloPagar

M�todo para consultar os dados do t�tulo a pagar do Protheus

@param		NomeUsuario = Nome do usu�rio integrador
			SenhaUsuario = Senha do usu�rio integrador
			CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que ser� consultado
			NumeroTitulo = N�mero do t�tulo
			PrefixoTitulo = Prefixo do t�tulo
			ParcelaTitulo = Parcela do t�tulo
			TipoTitulo = Tipo do t�tulo
			CodigoFornecedor = C�digo do fornecedor
			LojaFornecedor = Loja do fornecedor

@return		Detalhes do t�tulo a pagar
@author 	Fabio Cazarini
@since 		09/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD detalhesTituloPagar WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroTitulo, PrefixoTitulo, ParcelaTitulo, TipoTitulo, CodigoFornecedor, LojaFornecedor WSSEND ListaDetalhesTitulo WSSERVICE IntegraFluigFin
	LOCAL lRet			:= .T.
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroTit	:= ALLTRIM(::NumeroTitulo)
	LOCAL cPrefixoTi	:= ALLTRIM(::PrefixoTitulo)
	LOCAL cParcelaTi	:= ALLTRIM(::ParcelaTitulo)
	LOCAL cTipoTitul	:= ALLTRIM(::TipoTitulo)
	LOCAL cCodigoFor	:= ALLTRIM(::CodigoFornecedor)
	LOCAL cLojaForne	:= ALLTRIM(::LojaFornecedor)

	LOCAL cRetExec		:= ""
	LOCAL cEmpCod		:= ""
	LOCAL cFilCod		:= ""
	LOCAL cEmpRazao		:= ""
	LOCAL aFH_SM0		:= {}
	LOCAL nPos_SM0		:= 0
	LOCAL nCnt			:= 0

	LOCAL nValImpost	:= 0
	LOCAL cQuery		:= ""
	LOCAL cTITPAI		:= ""
	
	RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
	RPCSetType(3)									// Seta tipo de consumo de licen�a
	RpcSetEnv("01","0010001",,,,GetEnvServer())		// Seta o ambiente com a empresa/filial
	SetHideInd(.T.) 								// Evita problemas com indices temporarios

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Verifica se a Filial Informada Existe no Cadastro de Empresa
		//-----------------------------------------------------------------------
		IF !EMPTY(cCNPJEmpre)
			aFH_SM0 	:= FWLOADSM0()
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == cGrupoEmpr .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

			IF nPos_SM0 > 0
				cEmpCod	  := aFH_SM0[nPos_SM0][1]
				cFilCod	  := aFH_SM0[nPos_SM0][2]
				cEmpRazao := aFH_SM0[nPos_SM0][7]
			ENDIF
		ELSE
			cEmpCod	:= cEmpAnt
			cFilCod	:= cFilAnt
			cEmpRazao := FWFilialName()
		ENDIF

		IF EMPTY(cEmpCod) .OR. EMPTY(cFilCod)
			cRetExec	:= "Filial "+AllTrim(cCNPJEmpre)+" nao existe no Protheus!" 
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Prepara o Ambiente na Filial Informada Para Efetuar o Processamento
		//-----------------------------------------------------------------------
		IF (cEmpCod + cFilCod) <> (cFilAnt + cEmpAnt) 
			RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
			RPCSetType(3)									// Seta tipo de consumo de licen�a
			RpcSetEnv(cEmpCod,cFilCod,,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
			SetHideInd(.T.) 								// Evita problemas com indices temporarios
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Autentica usu�rio e senha
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		PswOrder(2) 						// 2 - Nome do usu�rio/grupo;
		IF (  PswSeek(cNomeUsuar, .T.) ) 	// Se for pesquisar usu�rio informar .T., caso contr�rio .F. para grupos           
			IF !PswName( cSenhaUsua )
				cRetExec := "N�o foi poss�vel efetuar a autentica��o: Usu�rio ou senha inv�lidos"
			ENDIF
		ELSE	
			cRetExec := "N�o foi poss�vel efetuar a autentica��o: Usu�rio ou senha inv�lidos"
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		cPrefixoTi	:= PADR(cPrefixoTi, TAMSX3("E2_PREFIXO")[1])
		cNumeroTit	:= PADR(cNumeroTit, TAMSX3("E2_NUM")[1])
		cParcelaTi	:= PADR(cParcelaTi, TAMSX3("E2_PARCELA")[1])
		cTipoTitul	:= PADR(cTipoTitul, TAMSX3("E2_TIPO")[1])
		cCodigoFor	:= PADR(cCodigoFor, TAMSX3("E2_FORNECE")[1])
		cLojaForne	:= PADR(cLojaForne, TAMSX3("E2_LOJA")[1])

		DbSelectArea("SE2")
		DbSetOrder(1) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		IF !MsSeek(xFILIAL("SE2") + cPrefixoTi + cNumeroTit + cParcelaTi + cTipoTitul + cCodigoFor + cLojaForne)
			cRetExec := "T�tulo n�o encontrado"
		ELSE
			//-----------------------------------------------------------------------
			// Monta arquivo com os t�tulos gerados a partir do t�tulo pai
			//-----------------------------------------------------------------------
			cTITPAI := RTRIM(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
		
			cQuery := " SELECT SE2.E2_VALOR AS VALIMPOST "
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
				nValImpost += TRBSE2->VALIMPOST
				
				TRBSE2->( DbSkip() )
			ENDDO
			TRBSE2->( dbCloseArea() )
			
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	//Retorno
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		nCnt++
		AADD(::ListaDetalhesTitulo,WSClassNew("STRUCListaDetalhesTitulo"))

		::ListaDetalhesTitulo[nCnt]:MatriculaAprovador 	:= SE2->E2_XAPROVA
		::ListaDetalhesTitulo[nCnt]:NomeAprovador 		:= SE2->E2_XAPRNOM
		::ListaDetalhesTitulo[nCnt]:NivelAprovador 		:= SE2->E2_XAPRNIV
		::ListaDetalhesTitulo[nCnt]:RazaoSocial 		:= cEmpRazao //GETADVFVAL("SA2","A2_NOME",xFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,1,"")
		::ListaDetalhesTitulo[nCnt]:NomeFornecedor 		:= GETADVFVAL("SA2","A2_NREDUZ",xFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,1,"")
		::ListaDetalhesTitulo[nCnt]:NaturezaFinanceira	:= SE2->E2_NATUREZ
		::ListaDetalhesTitulo[nCnt]:DescricaoNatureza	:= GETADVFVAL("SED","ED_DESCRIC",xFILIAL("SED")+SE2->E2_NATUREZ,1,"")
		::ListaDetalhesTitulo[nCnt]:DataEmissao			:= DTOC(SE2->E2_EMISSAO)
		::ListaDetalhesTitulo[nCnt]:DataVencimento		:= DTOC(SE2->E2_VENCTO)
		::ListaDetalhesTitulo[nCnt]:DataVencimentoReal	:= DTOC(SE2->E2_VENCREA)
		::ListaDetalhesTitulo[nCnt]:ValorTitulo  		:= ALLTRIM(TRANSFORM(SE2->E2_VALOR+nValImpost, "@E 9,999,999,999,999.99"))
		::ListaDetalhesTitulo[nCnt]:Historico 			:= SE2->E2_HIST
		::ListaDetalhesTitulo[nCnt]:TipoDocumento		:= "PG"
		::ListaDetalhesTitulo[nCnt]:CodigoMoeda  		:= SE2->E2_MOEDA
		::ListaDetalhesTitulo[nCnt]:SimboloMoeda  		:= RetMoeda(SE2->E2_MOEDA)[1]
		::ListaDetalhesTitulo[nCnt]:NomeMoeda  			:= RetMoeda(SE2->E2_MOEDA)[2]

		lRet := .T.
	ELSE
		SetSoapFault("IntegraFluigFin:ListaDetalhesTitulo",cRetExec)
		lRet := .F.
	ENDIF
	//RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} proximoAprovador

M�todo para aprovar pelo aprovador atual e consultar o pr�ximo aprovador 
de acordo com a al�ada no Protheus

@param		NomeUsuario = Nome do usu�rio integrador
			SenhaUsuario = Senha do usu�rio integrador
			CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que ser� consultado
			NumeroTitulo = N�mero do t�tulo
			PrefixoTitulo = Prefixo do t�tulo
			ParcelaTitulo = Parcela do t�tulo
			TipoTitulo = Tipo do t�tulo
			CodigoFornecedor = C�digo do fornecedor
			LojaFornecedor = Loja do fornecedor

@return		Pr�ximo aprovador: Matr�cula, nome e n�vel
@author 	Fabio Cazarini
@since 		09/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD proximoAprovador WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroTitulo, PrefixoTitulo, ParcelaTitulo, TipoTitulo, CodigoFornecedor, LojaFornecedor, MatriculaAprovador, NivelAprovador, TipoDocumento WSSEND ListaproximoAprovadorTit WSSERVICE IntegraFluigFin
	LOCAL lRet			:= .T.
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroTit	:= ALLTRIM(::NumeroTitulo)
	LOCAL cPrefixoTi	:= ALLTRIM(::PrefixoTitulo)
	LOCAL cParcelaTi	:= ALLTRIM(::ParcelaTitulo)
	LOCAL cTipoTitul	:= ALLTRIM(::TipoTitulo)
	LOCAL cCodigoFor	:= ALLTRIM(::CodigoFornecedor)
	LOCAL cLojaForne	:= ALLTRIM(::LojaFornecedor)
	LOCAL cMatrAprov	:= ALLTRIM(::MatriculaAprovador)
	LOCAL cNivelApro	:= ALLTRIM(::NivelAprovador)
	LOCAL cTipoDocum	:= ALLTRIM(::TipoDocumento)

	LOCAL cRetExec		:= ""
	LOCAL cEmpCod		:= ""
	LOCAL cFilCod		:= ""
	LOCAL aFH_SM0		:= {}
	LOCAL nPos_SM0		:= 0

	LOCAL nCnt			:= 0
	LOCAL lAchouApro 	:= .F.
	LOCAL cChaveSE2		:= ""
	LOCAL cChaveSZ5		:= ""
	LOCAL lIniciaFlu	:= .F.
	LOCAL cUserAprov	:= ""
	LOCAL lLibOk		:= .T.
	LOCAL cProxAprov 	:= ""
	LOCAL cProxNivel	:= ""
	LOCAL cUsrEmail		:= ""

	RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
	RPCSetType(3)									// Seta tipo de consumo de licen�a
	RpcSetEnv("01","0010001",,,,GetEnvServer())		// Seta o ambiente com a empresa/filial
	SetHideInd(.T.) 								// Evita problemas com indices temporarios

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Verifica se a Filial Informada Existe no Cadastro de Empresa
		//-----------------------------------------------------------------------
		IF !EMPTY(cCNPJEmpre)
			aFH_SM0 	:= FWLOADSM0()
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == cGrupoEmpr .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

			IF nPos_SM0 > 0
				cEmpCod	:= aFH_SM0[nPos_SM0][1]
				cFilCod	:= aFH_SM0[nPos_SM0][2]
			ENDIF
		ELSE
			cEmpCod	:= cEmpAnt
			cFilCod	:= cFilAnt
		ENDIF

		IF EMPTY(cEmpCod) .OR. EMPTY(cFilCod)
			cRetExec	:= "Filial "+AllTrim(cCNPJEmpre)+" nao existe no Protheus!" 
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Prepara o Ambiente na Filial Informada Para Efetuar o Processamento
		//-----------------------------------------------------------------------
		IF (cEmpCod + cFilCod) <> (cFilAnt + cEmpAnt) 
			RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
			RPCSetType(3)									// Seta tipo de consumo de licen�a
			RpcSetEnv(cEmpCod,cFilCod,,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
			SetHideInd(.T.) 								// Evita problemas com indices temporarios
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Autentica usu�rio e senha
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		PswOrder(2) 						// 2 - Nome do usu�rio/grupo;
		IF (  PswSeek(cNomeUsuar, .T.) ) 	// Se for pesquisar usu�rio informar .T., caso contr�rio .F. para grupos           
			IF !PswName( cSenhaUsua )
				cRetExec := "N�o foi poss�vel efetuar a autentica��o: Usu�rio ou senha inv�lidos"
			ENDIF
		ELSE	
			cRetExec := "N�o foi poss�vel efetuar a autentica��o: Usu�rio ou senha inv�lidos"
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		cPrefixoTi	:= PADR(cPrefixoTi, TAMSX3("E2_PREFIXO")[1])
		cNumeroTit	:= PADR(cNumeroTit, TAMSX3("E2_NUM")[1])
		cParcelaTi	:= PADR(cParcelaTi, TAMSX3("E2_PARCELA")[1])
		cTipoTitul	:= PADR(cTipoTitul, TAMSX3("E2_TIPO")[1])
		cCodigoFor	:= PADR(cCodigoFor, TAMSX3("E2_FORNECE")[1])
		cLojaForne	:= PADR(cLojaForne, TAMSX3("E2_LOJA")[1])

		DbSelectArea("SE2")
		DbSetOrder(1) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		IF !MsSeek(xFILIAL("SE2") + cPrefixoTi + cNumeroTit + cParcelaTi + cTipoTitul + cCodigoFor + cLojaForne)
			cRetExec := "T�tulo a pagar n�o encontrado"
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF SE2->E2_XSFLUIG == 'R'
			cRetExec := "T�tulo a pagar reprovado"
		ENDIF
	ENDIF	
	
	IF EMPTY(cRetExec)
		lAchouApro 	:= .F.
		
		cChaveSE2	:= xFILIAL("SE2") + cPrefixoTi + cNumeroTit + cParcelaTi + cTipoTitul + cCodigoFor + cLojaForne 
		cChaveSZ5	:= xFilial("SZ5") + PADR(cTipoDocum, TAMSX3("Z5_TIPO")[1]) + PADR(cChaveSE2, TAMSX3("Z5_NUM")[1]) + PADR(cNivelApro, TAMSX3("Z5_NIVEL")[1]) 
		dbSelectArea("SZ5")
		SZ5->(dbSetOrder(1)) // Z5_FILIAL + Z5_TIPO + Z5_NUM + Z5_NIVEL
		IF DbSEEK(cChaveSZ5)
			DO WHILE !SZ5->( EOF() ) .AND. SZ5->(Z5_FILIAL + Z5_TIPO + Z5_NUM + Z5_NIVEL) == cChaveSZ5
				IF cMatrAprov == ALLTRIM(UsrRetName(SZ5->Z5_USER))
					lAchouApro := .T.
					Exit 
				ENDIF
				SZ5->(dbSkip())
			ENDDO
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Z5_STATUS = 	01=Aguardando nivel anterior;02=Pendente;03=Liberado;
		//				04=Bloqueado;05=Liberado outro usuario
		//-----------------------------------------------------------------------
		IF lAchouApro
			IF !Empty(SZ5->Z5_DATALIB) .And. SZ5->Z5_STATUS$"03#05"
				lIniciaFlu := .T. // Iniciou o processo no Fluig, indicando o pr�ximo a liberar	
			ELSEIF SZ5->Z5_STATUS$"01"
				cRetExec :=  "Esta opera��o n�o poder� ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
			ELSEIF SZ5->Z5_STATUS$"02" // Aguardando Liberacao do usuario
				//-----------------------------------------------------------------------
				// Libera o t�tulo pelo usu�rio
				//-----------------------------------------------------------------------
				
				//-----------------------------------------------------------------------
				// Retorna o ID sequencial do aprovador
				//-----------------------------------------------------------------------
				cUserAprov := SPACE( TAMSX3("Z5_USERLIB")[1] )
				PswOrder(2)						// busca por usu�rio
				IF PswSeek( cMatrAprov, .T. )  	
					cUserAprov := PswID() 		// Retorna o ID do ultimo usu�rio posicionado pela fun��o PswSeek. 
				ENDIF	

				dbSelectArea("SAK")
				dbSetorder(2) // AK_FILIAL + AK_USER
				//MsSeek(xFilial("SAK")+SC7->C7_APROV+cUserAprov)
				MsSeek(xFilial("SAK")+cUserAprov)
				
				DbselectArea("SE2")
				lLibOk := RecLock("SE2", .F. )
				IF lLibOk
					DbSelectArea("SZ5")
					IF RecLock("SZ5", .F.)
						SZ5->Z5_STATUS	:= "03"
						SZ5->Z5_DATALIB	:= dDATABASE
						SZ5->Z5_USERLIB	:= ALLTRIM(cUserAprov) 
						SZ5->Z5_LIBAPRO	:= SAK->AK_COD
						SZ5->Z5_OBS		:= "Liberado via Fluig. N�mero Fluig: " + ALLTRIM(SE2->E2_XNFLUIG)
						SZ5->Z5_VALLIB 	:= SZ5->Z5_TOTAL
												
						//-----------------------------------------------------------------------
						// E2_XSFLUIG =	N=Nao enviado Fluig;E=Enviado Fluig; 
						// 				I=Iniciada Aprov.Fluig;A=AprovadoFluig;R=Reprovado Fluig
						//-----------------------------------------------------------------------
						DbSelectArea("SE2")
						SE2->E2_XSFLUIG := 'I' // liberacao iniciada no Fluig
					ENDIF
					SE2->(MsUnlock())
				ELSE
					cRetExec := "A opera��o n�o pode ser executada agora pois o mesmo registro est� em uso por outro usu�rio"
				ENDIF
			ELSE // n�o achou processo aguardando libera��o 
				lIniciaFlu := .T.
			ENDIF
		ELSE // n�o achou aprovador
			lIniciaFlu := .T.		
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Iniciou o processo no Fluig (nao achou processo aguardando libera��o 
	// ou n�o achou aprovador)
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		IF lIniciaFlu
			DbselectArea("SE2")
			lLibOk := RecLock("SE2", .F. )
			IF lLibOk
				DbSelectArea("SE2")
				SE2->E2_XSFLUIG := 'I' // liberacao iniciada no Fluig
				SE2->(MsUnlock())
			ELSE
				cRetExec := "A opera��o n�o pode ser executada agora pois o mesmo registro est� em uso por outro usu�rio"
			ENDIF
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Retorno
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Retorna o pr�ximo aprovador do t�tulo a pagar
		//-----------------------------------------------------------------------
		cProxAprov 	:= ""
		cProxNivel	:= ""
		cUsrEmail 	:= ""

		cChaveSE2	:= xFILIAL("SE2") + cPrefixoTi + cNumeroTit + cParcelaTi + cTipoTitul + cCodigoFor + cLojaForne
		cChaveSZ5	:= xFilial("SZ5") + PADR( cTipoDocum, TAMSX3("Z5_TIPO")[1]) + PADR(cChaveSE2, TAMSX3("Z5_NUM")[1]) 
		dbSelectArea("SZ5")
		SZ5->(dbSetOrder(1)) // Z5_FILIAL + Z5_TIPO + Z5_NUM + Z5_NIVEL
		IF DbSEEK(cChaveSZ5)
			DO WHILE !SZ5->( EOF() ) .AND. SZ5->(Z5_FILIAL + Z5_TIPO + Z5_NUM) == cChaveSZ5
				IF SZ5->Z5_STATUS == "02" // Aguardando Liberacao do usuario
					cProxAprov 	:= UsrRetName(SZ5->Z5_USER)
					cProxNivel	:= SZ5->Z5_NIVEL
					cUsrEmail	:= UsrRetMail(SZ5->Z5_USER)
					Exit 
				ENDIF
				SZ5->(dbSkip())
			ENDDO
		ENDIF

 		nCnt++
 		AADD(::ListaproximoAprovadorTit,WSClassNew("STRUCListaproximoAprovadorTit"))

		::ListaproximoAprovadorTit[nCnt]:MatriculaAprovador 	:= cProxAprov
		::ListaproximoAprovadorTit[nCnt]:NivelAprovador			:= cProxNivel
		::ListaproximoAprovadorTit[nCnt]:EmailAprovador			:= cUsrEmail

		lRet := .T.
	ELSE
		SetSoapFault("IntegraFluigFin:proximoAprovador",cRetExec)
		lRet := .F.
	ENDIF
//	RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} aprovarReprovarTituloPagar

M�todo para aprovar ou reprovar o t�tulo a pagar do Protheus

@param		NomeUsuario = Nome do usu�rio integrador
			SenhaUsuario = Senha do usu�rio integrador
			CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que ser� consultado
			NumeroTitulo = N�mero do t�tulo
			PrefixoTitulo = Prefixo do t�tulo
			ParcelaTitulo = Parcela do t�tulo
			TipoTitulo = Tipo do t�tulo
			CodigoFornecedor = C�digo do fornecedor
			LojaFornecedor = Loja do fornecedor
			Decisao = Decis�o tomada:
			'01' = T�tulo a pagar aprovado (E2_XSFLUIG = "A")
			'02' = T�tulo a pagar reprovado (E2_XSFLUIG = "R")
			
@return		Transa��o e mensagem da transa��o:
			'01' = T�tulo a pagar aprovado com sucesso
			'02' =  a pagar reprovado com sucesso
			'03' = Falha ao integrar decis�o da aprova��o no Protheus e adicionar mensagem de erro do Protheus
			
@return		Transa��o e mensagem
@author 	Fabio Cazarini
@since 		13/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD aprovarReprovarTituloPagar WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroTitulo, PrefixoTitulo, ParcelaTitulo, TipoTitulo, CodigoFornecedor, LojaFornecedor, Decisao WSSEND ListaaprovarReprovarTit WSSERVICE IntegraFluigFin
	LOCAL lRet			:= .T.
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroTit	:= ALLTRIM(::NumeroTitulo)
	LOCAL cPrefixoTi	:= ALLTRIM(::PrefixoTitulo)
	LOCAL cParcelaTi	:= ALLTRIM(::ParcelaTitulo)
	LOCAL cTipoTitul	:= ALLTRIM(::TipoTitulo)
	LOCAL cCodigoFor	:= ALLTRIM(::CodigoFornecedor)
	LOCAL cLojaForne	:= ALLTRIM(::LojaFornecedor)
	LOCAL cDecisao		:= ALLTRIM(::Decisao)

	LOCAL cRetExec		:= ""
	LOCAL cEmpCod		:= ""
	LOCAL cFilCod		:= ""
	LOCAL aFH_SM0		:= {}
	LOCAL nPos_SM0		:= 0
	LOCAL nCnt			:= 0

	LOCAL chaveSE2		:= ""
	LOCAL cChaveSZ5		:= ""
	LOCAL cTransacao	:= ""
	LOCAL cMensagem		:= ""
	LOCAL lTitApto		:= .T.

	LOCAL cTITPAI		:= ""
	LOCAL cQuery		:= ""

	RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
	RPCSetType(3)									// Seta tipo de consumo de licen�a
	RpcSetEnv("01","0010001",,,,GetEnvServer())		// Seta o ambiente com a empresa/filial
	SetHideInd(.T.) 								// Evita problemas com indices temporarios

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Verifica se a Filial Informada Existe no Cadastro de Empresa
		//-----------------------------------------------------------------------
		IF !EMPTY(cCNPJEmpre)
			aFH_SM0 	:= FWLOADSM0()
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == cGrupoEmpr .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

			IF nPos_SM0 > 0
				cEmpCod	:= aFH_SM0[nPos_SM0][1]
				cFilCod	:= aFH_SM0[nPos_SM0][2]
			ENDIF
		ELSE
			cEmpCod	:= cEmpAnt
			cFilCod	:= cFilAnt
		ENDIF

		IF EMPTY(cEmpCod) .OR. EMPTY(cFilCod)
			cRetExec	:= "Filial "+AllTrim(cCNPJEmpre)+" nao existe no Protheus!" 
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Prepara o Ambiente na Filial Informada Para Efetuar o Processamento
		//-----------------------------------------------------------------------
		IF (cEmpCod + cFilCod) <> (cFilAnt + cEmpAnt) 
			RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
			RPCSetType(3)									// Seta tipo de consumo de licen�a
			RpcSetEnv(cEmpCod,cFilCod,,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
			SetHideInd(.T.) 								// Evita problemas com indices temporarios
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Autentica usu�rio e senha
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		PswOrder(2) 						// 2 - Nome do usu�rio/grupo;
		IF (  PswSeek(cNomeUsuar, .T.) ) 	// Se for pesquisar usu�rio informar .T., caso contr�rio .F. para grupos           
			IF !PswName( cSenhaUsua )
				cRetExec := "N�o foi poss�vel efetuar a autentica��o: Usu�rio ou senha inv�lidos"
			ENDIF
		ELSE	
			cRetExec := "N�o foi poss�vel efetuar a autentica��o: Usu�rio ou senha inv�lidos"
		ENDIF	
	ENDIF
	
	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		cPrefixoTi	:= PADR(cPrefixoTi, TAMSX3("E2_PREFIXO")[1])
		cNumeroTit	:= PADR(cNumeroTit, TAMSX3("E2_NUM")[1])
		cParcelaTi	:= PADR(cParcelaTi, TAMSX3("E2_PARCELA")[1])
		cTipoTitul	:= PADR(cTipoTitul, TAMSX3("E2_TIPO")[1])
		cCodigoFor	:= PADR(cCodigoFor, TAMSX3("E2_FORNECE")[1])
		cLojaForne	:= PADR(cLojaForne, TAMSX3("E2_LOJA")[1])

		DbSelectArea("SE2")
		DbSetOrder(1) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		IF !MsSeek(xFILIAL("SE2") + cPrefixoTi + cNumeroTit + cParcelaTi + cTipoTitul + cCodigoFor + cLojaForne)
			cRetExec := "T�tulo n�o encontrado"
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF SE2->E2_XSFLUIG == 'R'
			cRetExec := "T�tulo a pagar j� est� reprovado"
		ENDIF
	ENDIF	

	IF EMPTY(cRetExec)
		IF cDecisao == "01"
			//-----------------------------------------------------------------------
			// T�tulo a pagar APROVADO
			//-----------------------------------------------------------------------
			IF SE2->E2_XSFLUIG <> 'R'
				//-----------------------------------------------------------------------
				// T�tulo a pagar apto a ser aprovado?
				//-----------------------------------------------------------------------
				lTitApto	:= .T.

				cChaveSE2	:= xFILIAL("SE2") + cPrefixoTi + cNumeroTit + cParcelaTi + cTipoTitul + cCodigoFor + cLojaForne
				cChaveSZ5	:= xFilial("SZ5") + PADR("PG", TAMSX3("Z5_TIPO")[1]) + PADR(cChaveSE2, TAMSX3("Z5_NUM")[1])
				dbSelectArea("SZ5")
				SZ5->(dbSetOrder(1)) // Z5_FILIAL + Z5_TIPO + Z5_NUM + Z5_NIVEL
				IF DbSEEK(cChaveSZ5)
					DO WHILE !SZ5->( EOF() ) .AND. SZ5->(Z5_FILIAL + Z5_TIPO + Z5_NUM ) == cChaveSZ5
						//-----------------------------------------------------------------------
						// Z5_STATUS = 	01=Aguardando nivel anterior;02=Pendente;03=Liberado;
						//				04=Bloqueado;05=Liberado outro usuario
						//-----------------------------------------------------------------------
						IF SZ5->Z5_STATUS $ "01|02|04" 
							lTitApto := .F.
							Exit 
						ENDIF
						SZ5->(dbSkip())
					ENDDO
				ENDIF

				IF lTitApto
					DbselectArea("SE2")
					RecLock("SE2", .F. )
					DbSelectArea("SE2")
					SE2->E2_XSFLUIG := 'A' // t�tulo a pagar aprovado
					SE2->(MsUnlock())
	
					//-----------------------------------------------------------------------
					// Monta arquivo com os t�tulos gerados a partir do t�tulo pai
					//-----------------------------------------------------------------------
					cTITPAI := RTRIM(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
				
					cQuery := " SELECT SE2.R_E_C_N_O_  AS REGSE2 "
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
					DO WHILE !TRBSE2->( EOF() )
						DbSelectArea("SE2")
						DbGoTo( TRBSE2->REGSE2 )
						RecLock("SE2", .F. )
						DbSelectArea("SE2")
						SE2->E2_XSFLUIG := 'A' // t�tulo a pagar aprovado
						SE2->(MsUnlock())
						
						DbSelectArea("TRBSE2")
						TRBSE2->( DbSkip() )
					ENDDO
					TRBSE2->( dbCloseArea() )
	
					cTransacao	:= "01"
					cMensagem	:= "T�tulo a pagar aprovado com sucesso"
				ELSE
					cMensagem	:= "Aprova��o n�o efetivada: T�tulo a pagar n�o est� apto a ser aprovado"
				ENDIF
			ELSE
				cTransacao	:= "03"
				cMensagem	:= "Aprova��o n�o efetivada: T�tulo a pagar foi reprovado anteriormente e n�o pode ser mais aprovado"
			ENDIF
		ELSEIF cDecisao == "02"
			//-----------------------------------------------------------------------
			// T�tulo a pagar REPROVADO
			//-----------------------------------------------------------------------
			DbselectArea("SE2")
			RecLock("SE2", .F. )
			DbSelectArea("SE2")
			SE2->E2_XSFLUIG := 'R' // t�tulo a pagar reprovado
			SE2->(MsUnlock())

			//-----------------------------------------------------------------------
			// Monta arquivo com os t�tulos gerados a partir do t�tulo pai
			//-----------------------------------------------------------------------
			cTITPAI := RTRIM(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
		
			cQuery := " SELECT SE2.R_E_C_N_O_  AS REGSE2 "
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
			DO WHILE !TRBSE2->( EOF() )
				DbSelectArea("SE2")
				DbGoTo( TRBSE2->REGSE2 )
				RecLock("SE2", .F. )
				DbSelectArea("SE2")
				SE2->E2_XSFLUIG := 'R' // t�tulo a pagar reprovado
				SE2->(MsUnlock())
				
				DbSelectArea("TRBSE2")
				TRBSE2->( DbSkip() )
			ENDDO
			TRBSE2->( dbCloseArea() )

			cTransacao	:= "02"
			cMensagem	:= "T�tulo a pagar reprovado com sucesso"
		ELSE
			cRetExec := "A decis�o deve ser 01-T�tulo a pagar aprovado, ou 02-T�tulo a pagar reprovado"		
		ENDIF
	ENDIF	

	//-----------------------------------------------------------------------
	//Retorno
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
 		nCnt++
 		AADD(::ListaaprovarReprovarTit,WSClassNew("STRUCListaaprovarReprovarTit"))

		::ListaaprovarReprovarTit[nCnt]:Transacao 	:= cTransacao
		::ListaaprovarReprovarTit[nCnt]:Mensagem 	:= cMensagem

		lRet := .T.
	ELSE
 		nCnt++
 		AADD(::ListaaprovarReprovarTit,WSClassNew("STRUCListaaprovarReprovarTit"))

		::ListaaprovarReprovarTit[nCnt]:Transacao 	:= "03" // Falha ao integrar decis�o da aprova��o no Protheus
		::ListaaprovarReprovarTit[nCnt]:Mensagem 	:= cRetExec
		
		lRet := .T.
	ENDIF
//	RpcClearEnv()									// Limpa o ambiente, liberando a licen�a e fechando as conex�es
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} RetMoeda

Retorna o s�mbolo e o nome da moeda de acordo com os par�metroe MV_MOEDAx
e MV_SIMBx

@param		nMoeda = C�digo da moeda
@return		Array[1] = Simbolo da moera
			Array[2] = Nome da moeda

@author 	Fabio Cazarini
@since 		05/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION RetMoeda(nMoeda)
	LOCAL aRet 		:= {}
	LOCAL cSIMBx	:= ""
	LOCAL cMOEDAx	:= ""
	
	AADD( aRet, "")
	AADD( aRet, "")
	
	IF nMoeda > 0
		cSIMBx	:= "MV_SIMB" + ALLTRIM(STR(nMoeda,2))
		cMOEDAx	:= "MV_MOEDA" + ALLTRIM(STR(nMoeda,2))
		
		aRet[1] := SuperGetMV(cSIMBx, .T., "")
		aRet[2] := SuperGetMV(cMOEDAx, .T., "")
	ENDIF

RETURN aRet