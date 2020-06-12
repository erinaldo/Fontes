#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"         
#INCLUDE "TOTVS.CH"     
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASGPEA01
Webservice no Protheus para ser consumido pelo sistema SPA com o objetivo 
de realizar integração entre os dois sistemas.

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSSERVICE IntegraSPA Description "Web Service integração entre o Protheus e o Sistema SPA"

	//-----------------------------------------------------------------------
	// Dados
	//-----------------------------------------------------------------------
	WSDATA NomeUsuario			AS STRING
	WSDATA SenhaUsuario			AS STRING
	WSDATA CNPJEmpresa 			AS STRING
	WSDATA Competencia 			AS STRING // AAAAMM
	WSDATA Matricula 			AS STRING
	WSDATA DaMatricula 			AS STRING
	WSDATA AteMatricula			AS STRING
	WSDATA ListaFuncionarios	AS ARRAY OF STRUCListaFuncionarios
	WSDATA ListaDependentes		AS ARRAY OF STRUCListaDependentes
	WSDATA CodigoVerba			AS STRING
	WSDATA ValorDesconto		AS FLOAT
	WSDATA DataReferencia		AS STRING
	WSDATA RetornoDesSPA		AS STRING
	WSDATA Operacao 			AS STRING
	WSDATA SistemaOrigem 		AS STRING
	WSDATA ChaveSistemaOrigem 	AS STRING
	WSDATA Natureza 			AS STRING
	WSDATA CNPJCPFFornecedor 	AS STRING
	WSDATA DataEmissao 			AS STRING
	WSDATA DataVencimento 		AS STRING
	WSDATA DataRealVencimento 	AS STRING
	WSDATA ValorTitulo 			AS FLOAT
	WSDATA Historico 			AS STRING
	WSDATA TemRateio 			AS STRING
	WSDATA ListaRateio 			AS STRUCListaRateio
	WSDATA RetornoTitSPA 		AS STRING

	//-----------------------------------------------------------------------
	// Métodos
	//-----------------------------------------------------------------------
	WSMETHOD ConsultaFuncionarios 	DESCRIPTION "Método para consultar dados do cadastro de funcionários"
	WSMETHOD ConsultaDependentes	DESCRIPTION "Método para consultar dados dos dependentes dos funcionários"
	WSMETHOD IncluiDescontos 		DESCRIPTION "Método para inserir no Protheus o valor do desconto no recibo dos funcionários na competência informada"
	WSMETHOD TituloPagar			DESCRIPTION "Método para inserir no Protheus títulos a pagar no módulo financeiro referentes ao valor do aporte da empresa e taxas"
ENDWSSERVICE


//-----------------------------------------------------------------------
// Estruturas de dados
//-----------------------------------------------------------------------
WSSTRUCT STRUCListaFuncionarios
	WSDATA CNPJEmpresa 			AS STRING	OPTIONAL
	WSDATA Matricula 			AS STRING	OPTIONAL
	WSDATA Itemcontabil 		AS STRING	OPTIONAL
	WSDATA Nome 				AS STRING	OPTIONAL
	WSDATA DataNascimento	 	AS STRING	OPTIONAL
	WSDATA Sexo 				AS STRING	OPTIONAL
	WSDATA CPF 					AS STRING	OPTIONAL
	WSDATA RG 					AS STRING	OPTIONAL
	WSDATA OrgaoRG 				AS STRING	OPTIONAL
	WSDATA UFRG	 				AS STRING	OPTIONAL
	WSDATA DataRG 				AS STRING	OPTIONAL
	WSDATA GrauInstrucao 		AS STRING	OPTIONAL
	WSDATA EstadoCivil 			AS STRING	OPTIONAL
	WSDATA Nacionalidade 		AS STRING	OPTIONAL
	WSDATA CidadeNasceu 		AS STRING	OPTIONAL
	WSDATA UFNasceu 			AS STRING	OPTIONAL
	WSDATA Banco 				AS STRING	OPTIONAL
	WSDATA Agencia 				AS STRING	OPTIONAL
	WSDATA ContaCorrente 		AS STRING	OPTIONAL
	WSDATA NomeMae 				AS STRING	OPTIONAL
	WSDATA NomePai 				AS STRING	OPTIONAL
	WSDATA CTPS 				AS STRING	OPTIONAL
	WSDATA SerieCTPS 			AS STRING	OPTIONAL
	WSDATA UFCTPS 				AS STRING	OPTIONAL
	WSDATA DataAdmissao 		AS STRING	OPTIONAL
	WSDATA DataDemissao 		AS STRING	OPTIONAL
	WSDATA Endereco 			AS STRING	OPTIONAL
	WSDATA NumeroEndereco 		AS STRING	OPTIONAL
	WSDATA ComplementoEndereco 	AS STRING	OPTIONAL
	WSDATA Bairro 				AS STRING	OPTIONAL
	WSDATA Municipio 			AS STRING	OPTIONAL
	WSDATA UF 					AS STRING	OPTIONAL
	WSDATA CEP 					AS STRING	OPTIONAL
	WSDATA Fone 				AS STRING	OPTIONAL
	WSDATA Celular 				AS STRING	OPTIONAL
	WSDATA Email 				AS STRING	OPTIONAL
	WSDATA SalarioCompetencia 	AS FLOAT 	OPTIONAL
	WSDATA Condicao 			AS STRING	OPTIONAL
	WSDATA DataCondicao 		AS STRING	OPTIONAL
	WSDATA SalarioAfastados 	AS FLOAT 	OPTIONAL
	WSDATA ValorBonus 			AS FLOAT 	OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRUCListaDependentes
	WSDATA CNPJEmpresa 			AS STRING	OPTIONAL
	WSDATA Matricula 			AS STRING	OPTIONAL
	WSDATA CodigoDependente		AS STRING	OPTIONAL
	WSDATA Nome 				AS STRING	OPTIONAL
	WSDATA DataNascimento	 	AS STRING	OPTIONAL
	WSDATA Sexo 				AS STRING	OPTIONAL
	WSDATA Parentesco	 		AS STRING	OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRUCListaRateio
	WSDATA ItensListaRateio		AS ARRAY OF ItemListaRateio
ENDWSSTRUCT

WSSTRUCT ItemListaRateio
	WSDATA Sequencia 			AS STRING	OPTIONAL
	WSDATA Natureza 			AS STRING	OPTIONAL
	WSDATA Valor 				AS FLOAT	OPTIONAL
	WSDATA TemRateioCC 			AS STRING	OPTIONAL
	WSDATA ListaRateioCC		AS STRUCListaRateioCC
ENDWSSTRUCT

WSSTRUCT STRUCListaRateioCC
	WSDATA ItensListaRateioCC	AS ARRAY OF ItemListaRateioCC
ENDWSSTRUCT

WSSTRUCT ItemListaRateioCC
	WSDATA Sequencia 			AS STRING	OPTIONAL
	WSDATA CentroCusto 			AS STRING	OPTIONAL
	WSDATA Valor 				AS FLOAT	OPTIONAL
ENDWSSTRUCT


//-----------------------------------------------------------------------
/*/{Protheus.doc} ConsultaFuncionarios
O objetivo deste método é permitir ao Sistema SPA consultar cadastro de 
funcionários no Protheus

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			NomeUsuario = Nome do usuário para autenticação
			SenhaUsuario = Senha do usuário para autenticação
			Competencia = AAAAMM da competência para buscar o salário
			DaMatricula = Número da matrícula inicial que deve ser consultada
			AteMatricula = Número da matrícula final que deve ser consultada

@return		ListaFuncionarios = Array conforme estrutura STRUCListaFuncionarios
@author 	Fabio Cazarini
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD ConsultaFuncionarios WSRECEIVE CNPJEmpresa, NomeUsuario, SenhaUsuario, Competencia, DaMatricula, AteMatricula WSSEND ListaFuncionarios WSSERVICE IntegraSPA
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCompetenc	:= ALLTRIM(::Competencia)
	LOCAL cDaMatricu	:= ALLTRIM(::DaMatricula)
	LOCAL cAteMatric	:= ALLTRIM(::AteMatricula)
	LOCAL lRet 			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL cQuery		:= ""
	LOCAL nCnt			:= 0
	LOCAL aAfast		:= {}
	LOCAL cAS_GPEBON	:= ""
	LOCAL cCondicao		:= ""

	//-----------------------------------------------------------------------
	// Prepara o Ambiente na Filial Informada Para Efetuar o Processamento
	//-----------------------------------------------------------------------
	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	RPCSetType(3)									// Seta tipo de consumo de licença
	RpcSetEnv("01","0010001",,,,GetEnvServer())		// Seta o ambiente com a empresa/filial
	SetHideInd(.T.) 								// Evita problemas com indices temporarios

	cAS_GPEBON	:= GETNEWPAR("AS_GPEBON", "'095'") // parametro para indicar qual o código da verba para bônus

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Verifica se a Filial Informada Existe no Cadastro de Empresa
		//-----------------------------------------------------------------------
		IF !EMPTY(cCNPJEmpre)
			aFH_SM0 	:= FWLOADSM0()
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == "01" .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

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
			RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
			RPCSetType(3)									// Seta tipo de consumo de licença
			RpcSetEnv(cEmpCod,cFilCod,,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
			SetHideInd(.T.) 								// Evita problemas com indices temporarios
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Autentica usuário e senha
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		PswOrder(2) 						// 2 - Nome do usuário/grupo;
		IF (  PswSeek(cNomeUsuar, .T.) ) 	// Se for pesquisar usuário informar .T., caso contrário .F. para grupos           
			IF !PswName( cSenhaUsua )
				cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
			ENDIF
		ELSE	
			cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		IF EMPTY(cCompetenc)
			cCompetenc := LEFT(DTOS(dDATABASE),6) // AAAAMM
		ELSE
			IF LEN(cCompetenc) <> 6
				cRetExec := "Competência informada não é válida (AAAAMM): " + cCompetenc			
			ELSE
				IF VAL( LEFT(cCompetenc,4) ) < 2000 .OR. VAL( LEFT(cCompetenc,4) ) > 9999 
					cRetExec := "Competência informada não é válida (AAAAMM): " + cCompetenc
				ELSE
					IF VAL( RIGHT(cCompetenc,2) ) < 1 .OR. VAL( RIGHT(cCompetenc,2) ) > 12
						cRetExec := "Competência informada não é válida (AAAAMM): " + cCompetenc
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		//Monta arquivo TRBSRA com os dados dos funcionários
		//-----------------------------------------------------------------------
		cQuery := " SELECT SRA.R_E_C_N_O_  AS REGSRA "
		cQuery += " FROM " + RetSqlName("SRA") + " SRA "
		cQuery += " WHERE	SRA.RA_FILIAL = '" + xFILIAL("SRA") + "' " 
		cQuery += " 	AND SRA.RA_MAT BETWEEN '" + cDaMatricu + "' AND '" + cAteMatric + "' "
		cQuery += " 	AND SRA.D_E_L_E_T_ = ' '	"

		IF SELECT("TRBSRA") > 0
			TRBSRA->( dbCloseArea() )
		ENDIF    
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSRA" ,.F.,.T.)

		//-----------------------------------------------------------------------
		//Monta array de retorno do WSSEND
		//-----------------------------------------------------------------------
		nCnt := 0
		DbSelectArea("TRBSRA")
		DbGoTop()
		DO WHILE !TRBSRA->( EOF() )
			DbSelectArea("SRA")
			DbGoTo( TRBSRA->REGSRA )

			nCnt++
			AADD(::ListaFuncionarios,WSClassNew("STRUCListaFuncionarios"))

			::ListaFuncionarios[nCnt]:CNPJEmpresa 			:= cCNPJEmpre
			::ListaFuncionarios[nCnt]:Matricula 			:= ALLTRIM(SRA->RA_MAT)
			::ListaFuncionarios[nCnt]:Itemcontabil 			:= ALLTRIM(SRA->RA_CC)
			::ListaFuncionarios[nCnt]:Nome 					:= ALLTRIM( IIF(!EMPTY(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME) )
			IF EMPTY(SRA->RA_NASC)
				::ListaFuncionarios[nCnt]:DataNascimento	:= DTOC(SRA->RA_NASC)			
			ELSE
				::ListaFuncionarios[nCnt]:DataNascimento	:= STRZERO(DAY(SRA->RA_NASC),2) +"/"+ STRZERO(MONTH(SRA->RA_NASC),2) +"/"+ STRZERO(YEAR(SRA->RA_NASC),4)
			ENDIF	
			::ListaFuncionarios[nCnt]:Sexo 					:= ALLTRIM(SRA->RA_SEXO)
			::ListaFuncionarios[nCnt]:CPF 					:= ALLTRIM(SRA->RA_CIC)
			::ListaFuncionarios[nCnt]:RG 					:= ALLTRIM(SRA->RA_RG)
			::ListaFuncionarios[nCnt]:OrgaoRG 				:= ALLTRIM(SRA->RA_RGORG)
			::ListaFuncionarios[nCnt]:UFRG	 				:= ALLTRIM(SRA->RA_RGUF)
			IF EMPTY(SRA->RA_DTRGEXP)
				::ListaFuncionarios[nCnt]:DataRG	 		:= DTOC(SRA->RA_DTRGEXP)			
			ELSE
				::ListaFuncionarios[nCnt]:DataRG	 		:= STRZERO(DAY(SRA->RA_DTRGEXP),2) +"/"+ STRZERO(MONTH(SRA->RA_DTRGEXP),2) +"/"+ STRZERO(YEAR(SRA->RA_DTRGEXP),4)
			ENDIF	
			::ListaFuncionarios[nCnt]:GrauInstrucao 		:= SRA->RA_GRINRAI // ALLTRIM(fDesc("X26","26"+SRA->RA_GRINRAI,"X5_DESCRI"))
			::ListaFuncionarios[nCnt]:EstadoCivil 			:= ALLTRIM(SRA->RA_ESTCIVI)
			::ListaFuncionarios[nCnt]:Nacionalidade 		:= ALLTRIM(SRA->RA_NACIONA)
			::ListaFuncionarios[nCnt]:CidadeNasceu 			:= ALLTRIM(SRA->RA_MUNNASC)
			::ListaFuncionarios[nCnt]:UFNasceu 				:= ALLTRIM(SRA->RA_NATURAL)
			::ListaFuncionarios[nCnt]:Banco 				:= ALLTRIM(LEFT(SRA->RA_BCDEPSA,3))
			::ListaFuncionarios[nCnt]:Agencia 				:= ALLTRIM(SUBSTR(SRA->RA_BCDEPSA,5,5))
			::ListaFuncionarios[nCnt]:ContaCorrente 		:= ALLTRIM(SRA->RA_CTDEPSA)
			::ListaFuncionarios[nCnt]:NomeMae 				:= ALLTRIM(SRA->RA_MAE)
			::ListaFuncionarios[nCnt]:NomePai 				:= ALLTRIM(SRA->RA_PAI)
			::ListaFuncionarios[nCnt]:CTPS 					:= ALLTRIM(SRA->RA_NUMCP)
			::ListaFuncionarios[nCnt]:SerieCTPS 			:= ALLTRIM(SRA->RA_SERCP)
			::ListaFuncionarios[nCnt]:UFCTPS 				:= ALLTRIM(SRA->RA_UFCP)
			IF EMPTY(SRA->RA_ADMISSA)
				::ListaFuncionarios[nCnt]:DataAdmissao	 	:= DTOC(SRA->RA_ADMISSA)			
			ELSE
				::ListaFuncionarios[nCnt]:DataAdmissao	 	:= STRZERO(DAY(SRA->RA_ADMISSA),2) +"/"+ STRZERO(MONTH(SRA->RA_ADMISSA),2) +"/"+ STRZERO(YEAR(SRA->RA_ADMISSA),4)
			ENDIF	
			IF EMPTY(SRA->RA_DEMISSA)
				::ListaFuncionarios[nCnt]:DataDemissao	 	:= DTOC(SRA->RA_DEMISSA)			
			ELSE
				::ListaFuncionarios[nCnt]:DataDemissao	 	:= STRZERO(DAY(SRA->RA_DEMISSA),2) +"/"+ STRZERO(MONTH(SRA->RA_DEMISSA),2) +"/"+ STRZERO(YEAR(SRA->RA_DEMISSA),4)
			ENDIF	
			::ListaFuncionarios[nCnt]:Endereco 				:= ALLTRIM(SRA->RA_ENDEREC)
			::ListaFuncionarios[nCnt]:NumeroEndereco 		:= ALLTRIM(SRA->RA_NUMENDE)
			::ListaFuncionarios[nCnt]:ComplementoEndereco 	:= ALLTRIM(SRA->RA_COMPLEM)
			::ListaFuncionarios[nCnt]:Bairro 				:= ALLTRIM(SRA->RA_BAIRRO)
			::ListaFuncionarios[nCnt]:Municipio 			:= ALLTRIM(fDesc('CC2', SRA->RA_ESTADO + SRA->RA_CODMUN, 'CC2_MUN',, SRA->RA_FILIAL))
			::ListaFuncionarios[nCnt]:UF 					:= ALLTRIM(SRA->RA_ESTADO)
			::ListaFuncionarios[nCnt]:CEP 					:= ALLTRIM(SRA->RA_CEP)
			::ListaFuncionarios[nCnt]:Fone 					:= ALLTRIM(SRA->RA_DDDFONE) + ALLTRIM(SRA->RA_TELEFON)
			::ListaFuncionarios[nCnt]:Celular 				:= ALLTRIM(SRA->RA_DDDCELU) + ALLTRIM(SRA->RA_NUMCELU)
			::ListaFuncionarios[nCnt]:Email 				:= ALLTRIM(SRA->RA_EMAIL)
			::ListaFuncionarios[nCnt]:SalarioCompetencia 	:= BuscaSalar(SRA->RA_MAT, cCompetenc) // Retorna o salário na competência indicada

			aAfast := BuscaAfast(SRA->RA_MAT, cCompetenc)

			//-----------------------------------------------------------------------
			// Situacao do funcionário
			//-----------------------------------------------------------------------
			IF EMPTY(SRA->RA_SITFOLH) .OR. ALLTRIM(SRA->RA_SITFOLH) == "F"  // ativo ou de férias
				cCondicao := "1"
			ELSEIF ALLTRIM(SRA->RA_SITFOLH) $ "Q1|Q2|Q3|Q4|Q5|Q6" .AND. ALLTRIM(SRA->RA_SITFOLH) == "A" // afastado por maternidade
				cCondicao := "1"			
			ELSEIF ALLTRIM(SRA->RA_AFASFGT) == "S2" .AND. ALLTRIM(SRA->RA_SITFOLH) == "D" // desligado por morte
				cCondicao := "5"			
			ELSEIF ALLTRIM(SRA->RA_SITFOLH) $ "DT" // // desligado por outros motivos ou transferido
				cCondicao := "4"			
			ELSE // nenhuma das anteriores (afastado por algum outro motivo)
				cCondicao := "2"			
			ENDIF
	
			//::ListaFuncionarios[nCnt]:Condicao 				:= aAfast[1] // // 2-Doença, 3-Acidente, 4-Maternidade, 5-Outros
			::ListaFuncionarios[nCnt]:Condicao 				:= cCondicao
			
			IF EMPTY(aAfast[2])
				::ListaFuncionarios[nCnt]:DataCondicao	 	:= DTOC(aAfast[2])			
			ELSE
				::ListaFuncionarios[nCnt]:DataCondicao	 	:= STRZERO(DAY(aAfast[2]),2) +"/"+ STRZERO(MONTH(aAfast[2]),2) +"/"+ STRZERO(YEAR(aAfast[2]),4)
			ENDIF	
			
			::ListaFuncionarios[nCnt]:SalarioAfastados 		:= aAfast[3]

			::ListaFuncionarios[nCnt]:ValorBonus := BuscaMovim(SRA->RA_MAT, cCompetenc, cAS_GPEBON) // Retorna o valor do bônus na competência indicada

			DbSelectArea("TRBSRA")
			TRBSRA->( DbSkip() )
		ENDDO

		IF SELECT("TRBSRA") > 0
			TRBSRA->( dbCloseArea() )
		ENDIF 

		lRet := .T.
	ELSE
		SetSoapFault("IntegraSPA:ConsultaFuncionarios",cRetExec)
		lRet := .F.
	ENDIF

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} ConsultaDependentes
O objetivo deste método é permitir ao Sistema SPA consultar cadastro de 
dependentes de funcionários no Protheus

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			NomeUsuario = Nome do usuário para autenticação
			SenhaUsuario = Senha do usuário para autenticação
			Matricula = Número da matrícula do funcionario a ser consultado

@return		ListaDependentes = Array conforme estrutura STRUCListaDependentes
@author 	Fabio Cazarini
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD ConsultaDependentes WSRECEIVE CNPJEmpresa, NomeUsuario, SenhaUsuario, DaMatricula, AteMatricula WSSEND ListaDependentes WSSERVICE IntegraSPA
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cMatricula	:= ALLTRIM(::DaMatricula)
	LOCAL cAteMatric	:= ALLTRIM(::AteMatricula)
	LOCAL lRet 			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL cQuery		:= ""
	LOCAL nCnt			:= 0

	//-----------------------------------------------------------------------
	// Prepara o Ambiente na Filial Informada Para Efetuar o Processamento
	//-----------------------------------------------------------------------
	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	RPCSetType(3)									// Seta tipo de consumo de licença
	RpcSetEnv("01","0010001",,,,GetEnvServer())		// Seta o ambiente com a empresa/filial
	SetHideInd(.T.) 								// Evita problemas com indices temporarios

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Verifica se a Filial Informada Existe no Cadastro de Empresa
		//-----------------------------------------------------------------------
		IF !EMPTY(cCNPJEmpre)
			aFH_SM0 	:= FWLOADSM0()
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == "01" .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

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
			RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
			RPCSetType(3)									// Seta tipo de consumo de licença
			RpcSetEnv(cEmpCod,cFilCod,,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
			SetHideInd(.T.) 								// Evita problemas com indices temporarios
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Autentica usuário e senha
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		PswOrder(2) 						// 2 - Nome do usuário/grupo;
		IF (  PswSeek(cNomeUsuar, .T.) ) 	// Se for pesquisar usuário informar .T., caso contrário .F. para grupos           
			IF !PswName( cSenhaUsua )
				cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
			ENDIF
		ELSE	
			cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	//IF EMPTY(cRetExec)
	//	IF EMPTY(cMatricula)
	//		cRetExec := "Matrícula não encontrada na empresa pesquisada: " + cMatricula			
	//	ELSE
	//		DbSelectArea("SRA")
	//		DbSetOrder(1) // RA_FILIAL + RA_MAT
	//		IF !MsSEEK( xFILIAL("SRA") + cMatricula)
	//			cRetExec := "Matrícula não encontrada na empresa pesquisada: " + cMatricula		
	//		ENDIF
	//	ENDIF
	//ENDIF

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		//Monta arquivo TRBSRB com os dados dos funcionários
		//-----------------------------------------------------------------------
		cQuery := " SELECT SRB.R_E_C_N_O_  AS REGSRB "
		cQuery += " FROM " + RetSqlName("SRB") + " SRB "
		cQuery += " WHERE	SRB.RB_FILIAL = '" + xFILIAL("SRB") + "' " 
		cQuery += " 	AND SRB.RB_MAT >= '" + cMatricula + "' "
		cQuery += " 	AND SRB.RB_MAT <= '" + cAteMatric + "' "
		cQuery += " 	AND SRB.D_E_L_E_T_ = ' '	"
		cQuery += " ORDER BY SRB.RB_MAT "

		IF SELECT("TRBSRB") > 0
			TRBSRB->( dbCloseArea() )
		ENDIF    
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSRB" ,.F.,.T.)

		//-----------------------------------------------------------------------
		//Monta array de retorno do WSSEND
		//-----------------------------------------------------------------------
		nCnt := 0
		DbSelectArea("TRBSRB")
		DbGoTop()
		DO WHILE !TRBSRB->( EOF() )
			DbSelectArea("SRB")
			DbGoTo( TRBSRB->REGSRB )

			nCnt++
			AADD(::ListaDependentes,WSClassNew("STRUCListaDependentes"))

			::ListaDependentes[nCnt]:CNPJEmpresa 		:= cCNPJEmpre
			::ListaDependentes[nCnt]:Matricula 			:= ALLTRIM(SRB->RB_MAT)
			::ListaDependentes[nCnt]:CodigoDependente	:= ALLTRIM(SRB->RB_COD)
			::ListaDependentes[nCnt]:Nome 				:= ALLTRIM(SRB->RB_NOME)
			IF EMPTY(SRB->RB_DTNASC)
				::ListaDependentes[nCnt]:DataNascimento	:= DTOC(SRB->RB_DTNASC)			
			ELSE
				::ListaDependentes[nCnt]:DataNascimento	:= STRZERO(DAY(SRB->RB_DTNASC),2) +"/"+ STRZERO(MONTH(SRB->RB_DTNASC),2) +"/"+ STRZERO(YEAR(SRB->RB_DTNASC),4)
			ENDIF	
			::ListaDependentes[nCnt]:Sexo 				:= ALLTRIM(SRB->RB_SEXO)
			
			::ListaDependentes[nCnt]:Parentesco			:= ALLTRIM(SRB->RB_GRAUPAR) 
			//DO CASE
			//	CASE ALLTRIM(SRB->RB_GRAUPAR) == "C"
			//	::ListaDependentes[nCnt]:Parentesco	:= "CONJUGE OU COMPANHEIRO"
			//	CASE ALLTRIM(SRB->RB_GRAUPAR) == "F"
			//	::ListaDependentes[nCnt]:Parentesco	:= "FILHO"
			//	CASE ALLTRIM(SRB->RB_GRAUPAR) == "E"
			//	::ListaDependentes[nCnt]:Parentesco	:= "ENTEADO"
			//	CASE ALLTRIM(SRB->RB_GRAUPAR) == "P"
			//	::ListaDependentes[nCnt]:Parentesco	:= "PAI OU MÃE"
			//	OTHERWISE 
			//	::ListaDependentes[nCnt]:Parentesco	:= "OUTROS"			
			//ENDCASE		 

			DbSelectArea("TRBSRB")
			TRBSRB->( DbSkip() )
		ENDDO

		IF SELECT("TRBSRB") > 0
			TRBSRB->( dbCloseArea() )
		ENDIF 

		lRet := .T.
	ELSE
		SetSoapFault("IntegraSPA:ConsultaDependentes",cRetExec)
		lRet := .F.
	ENDIF

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} IncluiDescontos
O objetivo deste método é permitir ao Sistema SPA Método inserir no 
Protheus o valor do desconto no recibo dos funcionários na competência 
informada

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			NomeUsuario = Nome do usuário para autenticação
			SenhaUsuario = Senha do usuário para autenticação
			Matricula = Número da matrícula do funcionario a ser consultado
			CodigoVerba = 	1	Contribuição básica
							2	Contribuição voluntária
							3	Contribuição básica retroativa
							4	Contribuição voluntária retroativa
			ValorDesconto = Valor do desconto 
			DataReferencia = Data de referência do desconto

@return		RetornoDesSPA = 1 - Sucesso na inclusão
@author 	Fabio Cazarini
@since 		22/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD IncluiDescontos WSRECEIVE CNPJEmpresa, NomeUsuario, SenhaUsuario, Matricula, CodigoVerba, ValorDesconto, DataReferencia WSSEND RetornoDesSPA WSSERVICE IntegraSPA
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cMatricula	:= ALLTRIM(::Matricula)
	LOCAL cCodigoVer	:= ALLTRIM(::CodigoVerba)
	LOCAL nValorDesc	:= ::ValorDesconto
	LOCAL dDataRefer	:= CTOD(ALLTRIM(::DataReferencia))
	LOCAL lRet 			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL cGETMVAS		:= "AS_GPEDES"
	LOCAL cAS_GPEDES	:= ""
	LOCAL aCampos		:= {}
	LOCAL cCodLayout	:= ""
	LOCAL nTamRFJCPO 	:= 0
	LOCAL nX			:= 0
	LOCAL xConteudo	
	LOCAL cCC 			:= ""
	LOCAL cITEM 		:= ""
	LOCAL cCLVL 		:= ""
	LOCAL cProcesso		:= ""
	LOCAL cRoteiro		:= ""
	LOCAL cPeriodo		:= ""
	LOCAL cNroPago		:= ""
	LOCAL cSEQ			:= ""

	//-----------------------------------------------------------------------
	// Prepara o Ambiente na Filial Informada Para Efetuar o Processamento
	//-----------------------------------------------------------------------
	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	RPCSetType(3)									// Seta tipo de consumo de licença
	RpcSetEnv("01","0010001",,,,GetEnvServer())		// Seta o ambiente com a empresa/filial
	SetHideInd(.T.) 								// Evita problemas com indices temporarios

	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Verifica se a Filial Informada Existe no Cadastro de Empresa
		//-----------------------------------------------------------------------
		IF !EMPTY(cCNPJEmpre)
			aFH_SM0 	:= FWLOADSM0()
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == "01" .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

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
			RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
			RPCSetType(3)									// Seta tipo de consumo de licença
			RpcSetEnv(cEmpCod,cFilCod,,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
			SetHideInd(.T.) 								// Evita problemas com indices temporarios
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Autentica usuário e senha
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		PswOrder(2) 						// 2 - Nome do usuário/grupo;
		IF (  PswSeek(cNomeUsuar, .T.) ) 	// Se for pesquisar usuário informar .T., caso contrário .F. para grupos           
			IF !PswName( cSenhaUsua )
				cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
			ENDIF
		ELSE	
			cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		IF EMPTY(cMatricula)
			cRetExec := "Matrícula não encontrada na empresa pesquisada: " + cMatricula			
		ELSE
			DbSelectArea("SRA")
			DbSetOrder(1) // RA_FILIAL + RA_MAT
			IF !MsSEEK( xFILIAL("SRA") + cMatricula)
				cRetExec := "Matrícula não encontrada na empresa pesquisada: " + cMatricula		
			ENDIF
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF EMPTY(cCodigoVer)
			cRetExec := "Código da verba não encontrado: " + cCodigoVer		
		ELSE
			IF !(cCodigoVer $ "1|2|3|4|5|6|7|8|9")
				cRetExec := "Código da verba não encontrado: " + cCodigoVer		
			ELSE
				cGETMVAS	:= "AS_GPEDES" + cCodigoVer
				cAS_GPEDES	:= PADR( GETNEWPAR(cGETMVAS, SPACE(03)), TAMSX3("RV_COD")[1] ) // parametro para indicar qual o código da verba para descontos SPA
				IF EMPTY(cAS_GPEDES)
					cRetExec := "Código da verba não encontrado: " + cCodigoVer
				ELSE
					DbSelectArea("SRV")
					DbSetOrder(1) // RV_FILIAL + RV_COD
					IF !MsSEEK( xFILIAL("SRV") + cAS_GPEDES)
						cRetExec := "Código da verba não encontrado: " + cAS_GPEDES		
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF nValorDesc <= 0
			cRetExec := "Valor do desconto inválido"		
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF EMPTY(dDataRefer)
			cRetExec := "Data da referência inválida: " + DTOC(dDataRefer)		
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		cCodLayout	:= PADR( GETNEWPAR("AS_GPERFJ", SPACE(03)), TAMSX3("RFJ_CODIGO")[1]) // Parametro para indicar qual o código do layout de importação

		IF EMPTY( ALLTRIM(cCodLayout) )
			cCodLayout := ""
		ELSE
			DbSelectArea("RFJ")
			DbSetOrder(1) // RFJ_FILIAL + RFJ_CODIGO + RFJ_TBDEST + RFJ_CPO
			IF !MsSEEK( xFILIAL("RFJ") + cCodLayout)
				cRetExec := "Código do layout de importação (RFJ - parâmetro SX6 AS_GPERFJ) não encontrado: " + cCodLayout		
			ENDIF
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Inclui o desconto
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Campos da layout da tabela de importação
		//-----------------------------------------------------------------------
		IF !EMPTY(cCodLayout)
			dbSelectArea( "RFJ" ) 
			dbSetOrder(1) // RFJ_FILIAL + RFJ_CODIGO + RFJ_TBDEST + RFJ_CPO
			IF RFJ->(dbSeek( xFilial("RFJ") + cCodLayout ) )  
				DO WHILE RFJ->(!Eof()) .And. RFJ->RFJ_FILIAL == xFilial("RFJ") .And. RFJ->RFJ_CODIGO = cCodLayout  
					AADD(aCampos,{RFJ->RFJ_CPO,RFJ->RFJ_POSINI,RFJ->RFJ_POSFIN,RFJ->RFJ_FORM, RFJ_ORDEM })
					RFJ->(dbSkip())
				ENDDO  
			ENDIF   
		ENDIF

		cProcesso	:= SRA->RA_PROCES
		cRoteiro	:= "FOL"
		cPeriodo	:= PADR(LEFT( DTOS(dDataRefer), 4) + SUBSTR( DTOS(dDataRefer),5,2 ), TAMSX3("RGB_PERIOD")[1]) // Mês Ano, exemplo: 042016
		cNroPago	:= PADR("01", TAMSX3("RGB_SEMANA")[1])

		cCC			:= ""
		cITEM		:= ""
		cCLVL		:= ""

		nTamRFJCPO := TAMSX3("RFJ_CPO")[1]
		//-----------------------------------------------------------------------
		// Campos adicionais da tabela de layout de importacao RFJ
		//-----------------------------------------------------------------------
		IF !EMPTY(cCodLayout)
			FOR nX := 1 to Len(aCampos)			
				//-----------------------------------------------------------------------
				// Tabela de layout de importacao RFJ tem entidades contabeis
				//-----------------------------------------------------------------------
				IF ALLTRIM(aCampos[nX][1]) == "RGB_CC"
					xConteudo 	:= &(aCampos[nX][4])
					cCC			:= PADR(xConteudo, TAMSX3("RGB_CC")[1])
				ELSEIF ALLTRIM(aCampos[nX][1]) == "RGB_ITEM"
					xConteudo 	:= &(aCampos[nX][4])
					cITEM		:= PADR(xConteudo, TAMSX3("RGB_ITEM")[1])
				ELSEIF ALLTRIM(aCampos[nX][1]) == "RGB_CLVL"
					xConteudo 	:= &(aCampos[nX][4])
					cCLVL		:= PADR(xConteudo, TAMSX3("RGB_CLVL")[1])
				ENDIF
			NEXT nX
		ENDIF

		IF EMPTY(cCC)
			cCC			:= SRA->RA_CC
		ENDIF
		IF EMPTY(cITEM)	
			cITEM		:= SRA->RA_ITEM
		ENDIF
		IF EMPTY(cCLVL)	
			cCLVL		:= SRA->RA_CLVL
		ENDIF	

		//-----------------------------------------------------------------------
		// Busca a ultima sequencia cSEQ
		//-----------------------------------------------------------------------
		cSEQ := STRZERO( 1, TAMSX3("RGB_SEQ")[1] )
		DbSelectArea("RGB")
		DbSetOrder(1) // RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD+RGB_SEMANA+RGB_SEQ
		DO WHILE .T.
			IF MsSEEK(xFILIAL("RGB") + cMatricula + cAS_GPEDES + cPeriodo + cNroPago + cSEQ)
				cSEQ := SOMA1( cSEQ )
			ELSE
				EXIT
			ENDIF
		ENDDO
		
		IF RecLock( "RGB" ,.T. ) // Inclui
			//-----------------------------------------------------------------------
			// Campos adicionais da tabela de layout de importacao RFJ
			//-----------------------------------------------------------------------
			IF !EMPTY(cCodLayout)
				FOR nX := 1 to Len(aCampos)			
					//-----------------------------------------------------------------------
					// Desconsiderar do layout os campos abaixo
					//-----------------------------------------------------------------------
					IF !( aCampos[nX][1] $ 	PADR("RGB_FILIAL",nTamRFJCPO) 	+ "|" +;
					PADR("RGB_MAT",nTamRFJCPO) 		+ "|" +;
					PADR("RGB_PD",nTamRFJCPO) 		+ "|" +;
					PADR("RGB_DTREF",nTamRFJCPO) 	+ "|" +;
					PADR("RGB_VALOR",nTamRFJCPO) 	+ "|" +;
					PADR("RGB_POSTO",nTamRFJCPO) 	+ "|" +;
					PADR("RGB_DEPTO",nTamRFJCPO) 	+ "|" +;
					PADR("RGB_CODFUN",nTamRFJCPO) 	+ "|" +;
					PADR("RGB_CC",nTamRFJCPO) 		+ "|" +;
					PADR("RGB_ITEM",nTamRFJCPO) 	+ "|" +;
					PADR("RGB_CLVL",nTamRFJCPO) 	;																				
					)

						xConteudo := &(aCampos[nX][4])
						&("RGB->"+ALLTRIM(aCampos[nX][1])) :=  xConteudo
					ENDIF	   
				NEXT nX
			ENDIF

			RGB->RGB_FILIAL	:= xFILIAL("RGB")
			RGB->RGB_MAT 	:= cMatricula
			RGB->RGB_PD 	:= cAS_GPEDES
			RGB->RGB_DTREF 	:= dDataRefer
			RGB->RGB_VALOR	:= nValorDesc
			RGB->RGB_TIPO2	:= "G" 
			RGB->RGB_CC 	:= cCC
			RGB->RGB_ITEM	:= cITEM
			RGB->RGB_CLVL   := cCLVL
			RGB->RGB_PROCES	:= cProcesso
			RGB->RGB_ROTEIR	:= cRoteiro
			RGB->RGB_PERIOD	:= cPeriodo
			RGB->RGB_SEMANA	:= cNroPago   
			RGB->RGB_POSTO	:= SRA->RA_POSTO 
			RGB->RGB_DEPTO	:= SRA->RA_DEPTO
			RGB->RGB_CODFUN	:= SRA->RA_CODFUNC
			RGB->RGB_SEQ	:= cSEQ
			RGB->RGB_TIPO1	:= SRV->RV_TIPO

			RGB->( MsUnlock() )

			::RetornoDesSPA := "1" // Sucesso
			lRet := .T.
		ELSE
			SetSoapFault("IntegraSPA:IncluiDescontos","Não foi possível incluir o desconto na tabela RGB")
			lRet := .F.
		ENDIF
	ELSE
		SetSoapFault("IntegraSPA:IncluiDescontos",cRetExec)
		lRet := .F.
	ENDIF

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} TituloPagar
O objetivo deste método é inserir no Protheus títulos a pagar no módulo 
financeiro. Esse títulos são referentes a:
1 - Valor do aporte da empresa
2 - Valor das taxas

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			NomeUsuario = Nome do usuário para autenticação
			SenhaUsuario = Senha do usuário para autenticação
			Operacao = Enviar sempre 3 - Inclusão
			SistemaOrigem = Identifica o nome do sistema origem
			ChaveSistemaOrigem = Chave primária no sistema origem
			Natureza = Natureza financeira de cada tipo de título. Será feito de/para neste campo
			CNPJCPFFornecedor = CNPJ ou CPF do fornecedor
			DataEmissao = Data de emissão do título
			DataVencimento = Data de vencimento do título
			DataRealVencimento = Data de vencimento real do título
			ValorTitulo = Valor do título
			Historico = Histórico do título
			TemRateio = Tem rateio por múltiplas naturezas? 1 - Sim / 2 - Não
			ListaRateio = Array conforme estrutura STRUCListaRateio

@return		RetornoTituloSPA = Array conforme estrutura STRUCRetornoTituloSPA
@author 	Fabio Cazarini
@since 		26/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD TituloPagar WSRECEIVE 	CNPJEmpresa, NomeUsuario, SenhaUsuario, Operacao, SistemaOrigem, ChaveSistemaOrigem, Natureza, CNPJCPFFornecedor, DataEmissao, DataVencimento, DataRealVencimento, ValorTitulo, Historico, TemRateio, ListaRateio  WSSEND RetornoTitSPA WSSERVICE IntegraSPA
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cMatricula	:= ALLTRIM(::Matricula)
	LOCAL cOperacao		:= ALLTRIM(::Operacao) 
	LOCAL cSistemaOr	:= ALLTRIM(::SistemaOrigem)
	LOCAL cChaveSist	:= ALLTRIM(::ChaveSistemaOrigem)
	LOCAL cNatureza		:= ALLTRIM(::Natureza)
	LOCAL cCNPJCPFFo	:= ALLTRIM(::CNPJCPFFornecedor)
	LOCAL dDataEmiss	:= CTOD(::DataEmissao)
	LOCAL dDataVenci	:= CTOD(::DataVencimento)
	LOCAL dDataRealV	:= CTOD(::DataRealVencimento)
	LOCAL nValorTitu	:= ::ValorTitulo
	LOCAL cHistorico	:= ALLTRIM(::Historico)
	LOCAL cTemRateio	:= ALLTRIM(::TemRateio)
	LOCAL cNaturRat		:= ""

	LOCAL lRet 			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL nX			:= 0
	LOCAL nY			:= 0
	LOCAL nZ			:= 0
	LOCAL nK			:= 0

	LOCAL aRateio		:= {}
	LOCAL lMV_MULNATP 	:= .F.

	LOCAL cPREFIXO		:= ""
	LOCAL cNUM			:= ""
	LOCAL cPARCELA		:= ""
	LOCAL cTIPO			:= ""
	LOCAL cFORNECE		:= ""
	LOCAL cLOJA			:= ""

	LOCAL aDadosSE2		:= {}
	LOCAL aRatEvEz		:= {}
	LOCAL aAuxEv 		:= {}
	LOCAL cCC			:= ""
	LOCAL cITEM			:= "" 
	LOCAL cCLVL			:= ""
	LOCAL cCTACON		:= ""

	LOCAL nValorRat		:= 0
	LOCAL cTemRatCC		:= ""

	LOCAL cCentroCus 	:= ""
	LOCAL nValRatCC		:= 0  
	LOCAL nTotRatCC 	:= 0
	LOCAL nTotRateio 	:= 0
	LOCAL aRatCC		:= {}
	LOCAL nPercRatCC	:= 0
	LOCAL nPercRat		:= 0
	LOCAL nTPerRat		:= 0
	LOCAL nTtPerRatC	:= 0
	LOCAL aMartCC		:= {}
	LOCAL aMartNat		:= {}
	
	//-----------------------------------------------------------------------
	// Prepara o Ambiente na Filial Informada Para Efetuar o Processamento
	//-----------------------------------------------------------------------
	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	RPCSetType(3)									// Seta tipo de consumo de licença
	RpcSetEnv("01","0010001",,,,GetEnvServer())		// Seta o ambiente com a empresa/filial
	SetHideInd(.T.) 								// Evita problemas com indices temporarios
	
	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Verifica se a Filial Informada Existe no Cadastro de Empresa
		//-----------------------------------------------------------------------
		IF !EMPTY(cCNPJEmpre)
			aFH_SM0 	:= FWLOADSM0()
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == "01" .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

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
			RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
			RPCSetType(3)									// Seta tipo de consumo de licença
			RpcSetEnv(cEmpCod,cFilCod,,,,GetEnvServer())	// Seta o ambiente com a empresa/filial
			SetHideInd(.T.) 								// Evita problemas com indices temporarios
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Autentica usuário e senha
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		PswOrder(2) 						// 2 - Nome do usuário/grupo;
		IF (  PswSeek(cNomeUsuar, .T.) ) 	// Se for pesquisar usuário informar .T., caso contrário .F. para grupos           
			IF !PswName( cSenhaUsua )
				cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
			ENDIF
		ELSE	
			cRetExec := "Não foi possível efetuar a autenticação: Usuário ou senha inválidos"
		ENDIF	
	ENDIF

	//-----------------------------------------------------------------------
	// Parametros da rotina
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		lMV_MULNATP := GETNEWPAR("MV_MULNATP", .F. )
	ENDIF

	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		IF cOperacao <> "3"
			cRetExec := "Operação inválida. Informe: 3=Inclusão"	
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF !EMPTY(cNatureza)
			cNatureza := PADR(cNatureza, TAMSX3("ED_CODIGO")[1])
			DbSelectArea("SED")
			DbSetOrder(1) // ED_FILIAL+ED_CODIGO
			IF !MsSEEK(xFILIAL("SED") + cNatureza)
				cRetExec := "Natureza (" + cNatureza + ") não cadastrada"
			ENDIF
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF EMPTY(cCNPJCPFFo)
			cRetExec := "Fornecedor não encontrado: " + cCNPJCPFFo	
		ELSE
			DbSelectArea("SA2")
			DbSetOrder(3) // A2_FILIAL+A2_CGC
			IF !MsSEEK( xFILIAL("SA2") + cCNPJCPFFo)
				cRetExec := "Fornecedor não encontrado: " + cCNPJCPFFo		
			ENDIF
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF EMPTY(dDataEmiss)
			cRetExec := "Data de emissão inválida: " + DTOC(dDataEmiss)
		ELSEIF dDataEmiss > dDATABASE
			cRetExec := "Data de emissão inválida: " + DTOC(dDataEmiss)	
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF EMPTY(dDataVenci)
			cRetExec := "Data de vencimento inválida: " + DTOC(dDataVenci)	
		ELSEIF dDataVenci < dDataEmiss
			cRetExec := "Data de vencimento inválida: " + DTOC(dDataVenci)	
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF EMPTY(dDataRealV)
			dDataRealV := DataValida(dDataVenci,.T.)
		ELSEIF dDataRealV < dDataVenci
			cRetExec := "Data de vencimento real inválida: " + DTOC(dDataRealV)		
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF nValorTitu <= 0
			cRetExec := "Valor do título inválido"	
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF !(cTemRateio $ "1|2") // 1=Sim / 2=Não
			cRetExec := "Informe 1 = Tem rateio ou 2 = Não tem rateio"	
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF cTemRateio == "1" // se tem rateio
			IF !lMV_MULNATP
				cRetExec := "Lançamentos com múltiplas natureza não está habilitado no sistema: MV_MULNATP"
			ENDIF

			IF EMPTY(cRetExec)
				aRateio		:= {}
				nTotRateio	:= 0
				nTPerRat	:= 0
				FOR nX := 1 TO LEN(ListaRateio:ItensListaRateio)
					nValorRat	:= ListaRateio:ItensListaRateio[nX]:Valor
					nTotRateio	+= nValorRat
					cTemRatCC	:= ALLTRIM(ListaRateio:ItensListaRateio[nX]:TemRateioCC)
					cNaturRat	:= ALLTRIM(ListaRateio:ItensListaRateio[nX]:Natureza)

					IF nValorRat <= 0
						cRetExec := "Valor do rateio por natureza inválido"
						EXIT 	
					ENDIF

					IF !(cTemRatCC $ "1|2") // 1=Sim / 2=Não
						cRetExec := "Informe 1 = Tem rateio por centro de custo ou 2 = Não tem rateio por centro de custo"	
						EXIT
					ENDIF

					IF !EMPTY(cNaturRat)
						cNaturRat := PADR(cNaturRat, TAMSX3("ED_CODIGO")[1])
						
						DbSelectArea("SED")
						DbSetOrder(1) // ED_FILIAL+ED_CODIGO
						IF !MsSEEK(xFILIAL("SED") + cNaturRat)
							cRetExec := "Natureza do rateio (" + cNaturRat + ") não cadastrada"
							EXIT
						ELSE
							IF EMPTY(cNatureza)
								cNatureza := cNaturRat
							ENDIF
						ENDIF
					ELSE
						cRetExec := "Informe a natureza do(s) rateio(s)"	
						EXIT	
					ENDIF

					aRatCC		:= {}
					IF cTemRatCC == "1" // se tem rateio
						nTotRatCC 	:= 0
						nTtPerRatC	:= 0
						FOR nY := 1 TO LEN(ListaRateio:ItensListaRateio[nX]:ListaRateioCC:ItensListaRateioCC)
							cCentroCus 	:= ALLTRIM(ListaRateio:ItensListaRateio[nX]:ListaRateioCC:ItensListaRateioCC[nY]:CentroCusto)
							nValRatCC	:= ListaRateio:ItensListaRateio[nX]:ListaRateioCC:ItensListaRateioCC[nY]:Valor  
							nTotRatCC	+= nValRatCC
							
							IF EMPTY(cCentroCus)
								cRetExec := "Informe o centro de custo do rateio"
								EXIT 	
							ELSE
								cCentroCus := PADR(cCentroCus, TAMSX3("EZ_CCUSTO")[01])
								DbSelectArea("CTT")
								DbSetOrder(1) // CTT_FILIAL + CTT_CUSTO
								IF !MsSEEK(xFILIAL("CTT") + cCentroCus)
									cRetExec := "Centro de custo do rateio inválido" 
									EXIT
								ENDIF	 	
							ENDIF
							
							IF nValRatCC <= 0
								cRetExec := "Informe o valor do rateio por centro de custo"
								EXIT 	
							ENDIF

							nPercRatCC := ROUND(nValRatCC / nValorRat, TAMSX3("EZ_PERC")[2] )
							nTtPerRatC += nPercRatCC

							IF nY == LEN(ListaRateio:ItensListaRateio[nX]:ListaRateioCC:ItensListaRateioCC)
								nPercRatCC := nPercRatCC + (1-nTtPerRatC) // para arredondar 100% no último item
							ENDIF 							

							AADD( aRatCC, {nValRatCC, nPercRatCC, cCentroCus} )
						NEXT
						
						IF EMPTY(cRetExec)
							IF nTotRatCC <> nValorRat // validar o total do rateio por cc
								cRetExec := "O valor total do rateio por centro de custo (" + TRANSFORM(nTotRatCC, PESQPICT("SE2","E2_VALOR") ) + ") não confere com o valor do rateio da natureza (" + TRANSFORM(nValorRat, PESQPICT("SE2","E2_VALOR") ) + ")"
								EXIT
							ENDIF
						ENDIF
					ENDIF

					IF !EMPTY(cRetExec)
						EXIT
					ENDIF
					
					nPercRat := ROUND(nValorRat / nValorTitu, TAMSX3("EV_PERC")[2] )
					nTPerRat += nPercRat
					
					IF nX == LEN(ListaRateio:ItensListaRateio)
						nPercRat := nPercRat + (1-nTPerRat) // para arredondar 100% no último item
					ENDIF 
					 
					AADD( aRateio, {nValorRat, nPercRat, cNaturRat, cTemRatCC, aRatCC} )
				NEXT nX	
			
				IF EMPTY(cRetExec)
					IF nTotRateio <> nValorTitu // validar o total do rateio por natureza
						cRetExec := "O valor total do rateio por natureza (" + TRANSFORM(nTotRateio, PESQPICT("SE2","E2_VALOR") ) + ") não confere com o valor do título (" + TRANSFORM(nValorTitu, PESQPICT("SE2","E2_VALOR") ) + ")"
					ENDIF
				ENDIF	
			ENDIF
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF EMPTY(cNatureza)
			cRetExec := "Informe a natureza do título"
		ENDIF
	ENDIF
	
	IF EMPTY(cRetExec)
		cPREFIXO	:= PADR("GPE", TAMSX3("E2_PREFIXO")[1])
		cPARCELA	:= PADR("", TAMSX3("E2_PARCELA")[1])
		cTIPO		:= PADR("PP", TAMSX3("E2_TIPO")[1])
		cFORNECE	:= SA2->A2_COD
		cLOJA		:= SA2->A2_LOJA

		DbSelectArea("SE2")
		DbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		DO WHILE .T.
			cNUM := GetSXeNum("SE2","E2_NUM")
			IF !DbSEEK(xFILIAL("SE2") + cPREFIXO + cNUM + cPARCELA + cTIPO + cFORNECE + cLOJA)
				EXIT
			ELSE
				ConfirmSX8()
			ENDIF
		ENDDO
	ENDIF
	
	IF EMPTY(cRetExec)
		aAdd( aDadosSE2 ,{ "E2_PREFIXO" , cPREFIXO				, NIL } )            
		aAdd( aDadosSE2 ,{ "E2_NUM" 	, cNUM					, NIL } )
		aAdd( aDadosSE2 ,{ "E2_PARCELA"	, cPARCELA				, NIL } )
		aAdd( aDadosSE2 ,{ "E2_TIPO" 	, cTIPO					, NIL } )
		aAdd( aDadosSE2 ,{ "E2_NATUREZ" , cNatureza				, NIL } )
		aAdd( aDadosSE2 ,{ "E2_FORNECE" , cFORNECE				, NIL } )
		aAdd( aDadosSE2 ,{ "E2_LOJA" 	, cLOJA					, NIL } )
		aAdd( aDadosSE2 ,{ "E2_EMISSAO" , dDataEmiss			, NIL } )
		aAdd( aDadosSE2 ,{ "E2_VENCTO" 	, dDataVenci			, NIL } )
		aAdd( aDadosSE2 ,{ "E2_VENCREA" , dDataRealV			, NIL } )
		aAdd( aDadosSE2 ,{ "E2_VALOR" 	, nValorTitu			, NIL } )
		aAdd( aDadosSE2 ,{ "E2_HIST" 	, cHistorico			, NIL } )
		aAdd( aDadosSE2, { "E2_XSISINT" , ALLTRIM(cSistemaOr)	, NIL } )
		aAdd( aDadosSE2, { "E2_XCHVINT" , ALLTRIM(cChaveSist)	, NIL } )

		IF cTemRateio == "1" // se tem rateio
			aAdd( aDadosSE2 ,{"E2_MULTNAT" , '1', NIL })//rateio multinaturezs = sim

			aRatEvEz := {}
			FOR nZ := 1 TO LEN(aRateio)
				//Adicionando o vetor da natureza
				aAuxEv := {} 
				aAdd( aAuxEv ,{"EV_NATUREZ" 	, aRateio[nZ][03]	, NIL })//natureza a ser rateada
				aAdd( aAuxEv ,{"EV_VALOR" 		, aRateio[nZ][01]	, NIL })//valor do rateio na natureza
				aAdd( aAuxEv ,{"EV_PERC" 		, aRateio[nZ][02] 	, NIL })//percentual do rateio na natureza
				aAdd( aAuxEv ,{"EV_RATEICC" 	, aRateio[nZ][04]	, NIL })//indicando que há ou não rateio por centro de custo (2=não há)
				
				IF aRateio[nZ][04] == "1" // 1=há rateio por centro de custo na natureza
					aRatCC 	:= aRateio[nZ][05]
					aRatEz	:= {}
					aMartCC	:= {}
					FOR nK := 1 TO LEN(aRatCC)
						aAuxEz:={}

						aadd( aAuxEz ,{"EZ_NATUREZ"	, aRateio[nZ][03], NIL })//natureza
						aadd( aAuxEz ,{"EZ_CCUSTO"	, aRatCC[nK][3], NIL })//centro de custo da natureza
             			aadd( aAuxEz ,{"EZ_VALOR"	, aRatCC[nK][1], NIL })//valor do rateio neste centro de custo
             			aadd( aAuxEz ,{"EZ_PERC"	, aRatCC[nK][2], NIL })//percentual do rateio neste centro de custo
             			
             			aadd(aRatEz,aAuxEz)
             			
             			
             			aadd( aMartCC, {aRatCC[nK][3], aRatCC[nK][1], aRatCC[nK][2]} ) // martelar o rateio do CC depois do Execauto
             			
					NEXT nK
					aadd(aAuxEv,{"AUTRATEICC" , aRatEz, NIL })//recebendo dentro do array da natureza os multiplos centros de custo

					//-----------------------------------------------------------------------
					// Array para atualizar a SEZ
					//-----------------------------------------------------------------------
					aadd( aMartNat, {aRateio[nZ][03], aMartCC} )
				ENDIF
				
				aAdd(aRatEvEz,aAuxEv)//adicionando a natureza ao rateio de multiplas naturezas
			NEXT nZ

			aAdd(aDadosSE2,{"AUTRATEEV",ARatEvEz,Nil})//adicionando ao vetor aDadosSE2 o vetor do rateio

		ENDIF

		//-----------------------------------------------------------------------
		// Execauto do FINA050 para incluir titulos a pagar
		//-----------------------------------------------------------------------
		cRetExec := SE2ExecA(aDadosSE2, VAL(cOperacao), aMartNat)

		IF !EMPTY(cRetExec)
			RollBacKSX8()
			SetSoapFault("IntegraSPA:TituloPagar",cRetExec)
			lRet := .F.
		ELSE
			ConfirmSX8()
			::RetornoTitSPA := "1|" + SE2->E2_FILIAL + "|" + SE2->E2_PREFIXO + "|" + SE2->E2_NUM + "|" + SE2->E2_PARCELA + "|" + SE2->E2_TIPO + "|" + SE2->E2_FORNECE + "|" + SE2->E2_LOJA  
			lRet := .T.
		ENDIF	
	ELSE
		SetSoapFault("IntegraSPA:TituloPagar",cRetExec)
		lRet := .F.
	ENDIF

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} BuscaSalar

Retorna o salário na competência indicada

@param		cMAT = Matrícula do funcionário
			cCOMPETENC = Competência no formato AAAAMM

@return		nRET = Salário na competência indicada
@author 	Fabio Cazarini
@since 		22/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BuscaSalar(cMAT, cCOMPETENC)
	LOCAL aArea			:= GetArea()
	LOCAL aAreaSRA		:= SRA->( GetArea() )
	LOCAL nRET 			:= 0
	LOCAL cAS_GPESAL	:= GETNEWPAR("AS_GPESAL", "'000'") // parametro para indicar qual o código da verba para salários
	LOCAL cQuery		:= ""

	//-----------------------------------------------------------------------
	//Monta arquivo TRBSR3 com histórico do salário, selecionando a ult. 
	//alteracao salarial antes da competencia indicada
	//-----------------------------------------------------------------------
	cQuery := " SELECT 	TOP 1 "
	cQuery += "			SR3.R3_DATA, "
	cQuery += "			SR3.R3_VALOR "
	cQuery += " FROM " + RetSqlName("SR3") + " SR3 "
	cQuery += " WHERE	SR3.R3_FILIAL = '" + xFILIAL("SR3") + "' " 
	cQuery += " 	AND SR3.R3_MAT = '" + cMAT + "' "
	cQuery += " 	AND LEFT(SR3.R3_DATA,6) <= '" + cCOMPETENC + "' "
	cQuery += "		AND SR3.R3_PD IN (" + cAS_GPESAL + ") "
	cQuery += " 	AND SR3.D_E_L_E_T_ = ' '	"
	cQuery += " ORDER BY SR3.R3_DATA DESC "

	IF SELECT("TRBSR3") > 0
		TRBSR3->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSR3" ,.F.,.T.)

	IF !TRBSR3->( EOF() )
		nRET := TRBSR3->R3_VALOR
	ENDIF
	
	IF nRET == 0
		DbSelectArea("SRA")
		DbSetOrder(1) // RA_FILIAL + RA_MAT
		IF MsSEEK( xFILIAL("SRA") + cMAT)
			nRET := SRA->RA_SALARIO
		ENDIF			
	ENDIF
	TRBSR3->( dbCloseArea() )

	//-----------------------------------------------------------------------
	//Restaura ambiente
	//-----------------------------------------------------------------------
	SRA->( RestArea( aAreaSRA ) )
	RestArea( aArea )

RETURN nRET


//-----------------------------------------------------------------------
/*/{Protheus.doc} BuscaAfast

Retorna os dados do afastamento do funcionário

@param		cMAT = Matrícula do funcionário
			cCOMPETENC = Competência no formato AAAAMM

@return		aRET[1] = Condição do afastamento: 2-Doença, 3-Acidente, 4-Maternidade, 5-Outros
			aRET[2] = Data do início do afastamento 
			aRET[3] = Salário proporcional do afastamento

@author 	Fabio Cazarini
@since 		25/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BuscaAfast(cMAT, cCOMPETENC)
	LOCAL aArea			:= GetArea()
	LOCAL aRET 			:= {}
	LOCAL cQuery		:= ""
	LOCAL cAS_GPEAFA	:= GETNEWPAR("AS_GPEAFA", "'095'") // parametro para indicar qual o código da verba afastados
	
	//-----------------------------------------------------------------------
	// Array de retorno
	//-----------------------------------------------------------------------
	AADD( aRET, " ")			// Condição do afastamento: 2-Doença, 3-Acidente, 4-Maternidade, 5-Outros
	AADD( aRET, CTOD("//"))		// Data do início do afastamento
	AADD( aRET, 0)				// Salário proporcional do afastamento

	cQuery := " SELECT 	TOP 1 "
	cQuery += "			SR8.R8_DATAINI, "
	cQuery += "			SR8.R8_TIPOAFA "
	cQuery += " FROM " + RetSqlName("SR8") + " SR8 "
	cQuery += " WHERE	SR8.R8_FILIAL = '" + xFILIAL("SR8") + "' " 
	cQuery += " 	AND SR8.R8_MAT = '" + cMAT + "' "
	cQuery += " 	AND LEFT(SR8.R8_DATAINI,6) <= '" + cCOMPETENC + "' "
	cQuery += " 	AND (SR8.R8_DATAFIM = '' OR LEFT(SR8.R8_DATAFIM,6) >= '" + cCOMPETENC + "') "	
	cQuery += " AND SR8.R8_TIPOAFA IN ('003','004','005','006','007','008','013','014','015','016','017','018') "
	cQuery += " 	AND SR8.D_E_L_E_T_ = ' '	"
	cQuery += " ORDER BY SR8.R8_DATAINI DESC "

	IF SELECT("TRBSR8") > 0
		TRBSR8->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSR8" ,.F.,.T.)

	IF !TRBSR8->( EOF() )
		DO CASE
			CASE TRBSR8->R8_TIPOAFA == "003"
				aRET[1] := "2" // 2 - Afastamento por acidente
			CASE TRBSR8->R8_TIPOAFA == "004"
				aRET[1] := "3" // 3 - Afastamento por doença
			CASE TRBSR8->R8_TIPOAFA $ "006|007|008"
				aRET[1] := "4" // 4 - Afastamento por maternidade
			OTHERWISE // 005, 013, 014, 015, 016, 017, 018
				aRET[1] := "5" // 5 - Outros afastamentos
		ENDCASE	
		aRET[2] := SToD(TRBSR8->R8_DATAINI)
		aRET[3] := BuscaMovim(SRA->RA_MAT, cCompetenc, cAS_GPEAFA) // Retorna o salário proporcional do funcionário afastado
	ENDIF
	TRBSR8->( dbCloseArea() )

	//-----------------------------------------------------------------------
	//Restaura ambiente
	//-----------------------------------------------------------------------
	RestArea( aArea )

RETURN aRET


//-----------------------------------------------------------------------
/*/{Protheus.doc} BuscaMovim

Retorna o valor do movimento do período na competência indicada

Busca na tabela SRD. Se não encontrou registro, busca na tabela SRC

@param		cMAT = Matrícula do funcionário
			cCOMPETENC = Competência no formato AAAAMM
			cPDs = Verbas. Exemplo: "'001','002','003'"
@return		nRET = Valor na competência indicada
@author 	Fabio Cazarini
@since 		20/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BuscaMovim(cMAT, cCOMPETENC, cPDs)
	LOCAL aArea			:= GetArea()
	LOCAL nRET 			:= 0
	LOCAL cQuery		:= ""

	//-----------------------------------------------------------------------
	//Busca na tabela SRD - Histórico de movimentos  
	//-----------------------------------------------------------------------
	cQuery := " SELECT 	SUM(SRD.RD_VALOR) AS RD_VALOR "
	cQuery += " FROM " + RetSqlName("SRD") + " SRD "
	cQuery += " WHERE	SRD.RD_FILIAL = '" + xFILIAL("SRD") + "' " 
	cQuery += " 	AND SRD.RD_MAT = '" + cMAT + "' "
	cQuery += " 	AND SRD.RD_PERIODO = '" + cCOMPETENC + "' "
	cQuery += "		AND SRD.RD_PD IN (" + cPDs + ") "
	cQuery += " 	AND SRD.D_E_L_E_T_ = ' '	"

	IF SELECT("TRBSRD") > 0
		TRBSRD->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSRD" ,.F.,.T.)

	IF !TRBSRD->( EOF() )
		nRET 		:= TRBSRD->RD_VALOR
	ENDIF
	TRBSRD->( dbCloseArea() )

	//-----------------------------------------------------------------------
	// Não encontrou reg. na SRD: busca na tabela SRC - Movimentos do período
	//-----------------------------------------------------------------------
	IF nRET == 0
		cQuery := " SELECT 	SUM(SRC.RC_VALOR) AS RC_VALOR "
		cQuery += " FROM " + RetSqlName("SRC") + " SRC "
		cQuery += " WHERE	SRC.RC_FILIAL = '" + xFILIAL("SRC") + "' " 
		cQuery += " 	AND SRC.RC_MAT = '" + cMAT + "' "
		cQuery += " 	AND SRC.RC_PERIODO = '" + cCOMPETENC + "' "
		cQuery += "		AND SRC.RC_PD IN (" + cPDs + ") "
		cQuery += " 	AND SRC.D_E_L_E_T_ = ' '	"
	
		IF SELECT("TRBSRC") > 0
			TRBSRC->( dbCloseArea() )
		ENDIF    
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSRC" ,.F.,.T.)
	
		IF !TRBSRC->( EOF() )
			nRET 		:= TRBSRC->RC_VALOR
		ENDIF
		TRBSRC->( dbCloseArea() )
	ENDIF
	
	//-----------------------------------------------------------------------
	//Restaura ambiente
	//-----------------------------------------------------------------------
	RestArea( aArea )

RETURN nRET


//-----------------------------------------------------------------------
/*/{Protheus.doc} SE2ExecA

Execauto do FINA050 para incluir titulos a pagar

@param		aDadosSE2 = Array para o ExecAuto
			nOpcx = 3-Inclusão
			aMartNat = {Natureza, {CC, Valor, Percentual} } 
@return		cRet = Caso ocorra erro, retorna o MOSTRAERRO()
@author 	Fabio Cazarini
@since 		26/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION SE2ExecA(aDadosSE2, nOpcx, aMartNat)
	LOCAL cRet		:= ""
	LOCAL cCRLF		:= CHR(13) + CHR(10)
	LOCAL aErros	:= {}   
	LOCAL cLinErr	:= {}
	LOCAL nY 		:= 0
	LOCAL nX		:= 0
	LOCAL nZ		:= 0
	LOCAL cChaveSEZ	:= ""
	LOCAL cNaturez 	:= ""
	LOCAL cCentroCus:= ""
	LOCAL nValorCC	:= 0
	LOCAL nPercCC	:= 0
	LOCAL aMartCC	:= {}
	LOCAL nCntCC	:= 0
	
	PRIVATE lMsErroAuto 	:= .F.	// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
	PRIVATE lMsHelpAuto		:= .T.	// força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
	PRIVATE lAutoErrNoFile	:= .T.

	//-----------------------------------------------------------------------
	// Ordenar um vetor conforme o dicionário para uso em rotinas de MSExecAuto
	//-----------------------------------------------------------------------
	aDadosSE2	:= FWVetByDic( aDadosSE2, 'SE2' )

	DbSelectArea("SE2")
	lMsErroAuto := .F.
	BeginTran()

	MsExecAuto({|x,y,z,a,b,c,d,e,f| FINA050(x,y,z,a,b,c,d,e,f)}, aDadosSE2, nOpcx, nOpcx, /*bExecuta*/, /*aDadosBco*/, /*lExibeLanc*/, /*lOnline*/, /*aRateioSE2*/ , /*aTitPrv*/)
	
	If lMsErroAuto
		DisarmTransaction()

		//-----------------------------------------------------------------------
		// Atribui a cRet o MOSTRAERRO()
		//-----------------------------------------------------------------------
		cRet 	:= "Ocorreu um erro na atualizacao do registro: " + cCRLF
		cRet	+= "Filial: " + cfilant + cCRLF + cCRLF

		aErros	:= GetAutoGRLog()   
		FOR nY := 1 TO LEN(aErros)
			cLinErr	:= aErros[nY]
			cRet 	+= cLinErr + cCRLF
		NEXT nY                              
	Else
		EndTran()

		//-----------------------------------------------------------------------
		// Atualiza SEZ, martelando o centro de custo, valor e percentagem
		//-----------------------------------------------------------------------
		cRet := ""
		FOR nZ := 1 TO LEN(aMartNat)
			cNaturez 	:= aMartNat[nZ][1]
			aMartCC		:= aMartNat[nZ][2]
			nCntCC		:= 0
			
			DbSelectArea("SEZ")
			DbSetOrder(1) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
			IF MsSEEK(xFILIAL("SEZ") + SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) + cNaturez)
				DO WHILE !EOF() .AND. SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) == (xFILIAL("SEZ") + SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) + cNaturez)
					nCntCC++
					
					IF nCntCC > LEN(aMartCC)
						EXIT
					ENDIF
					cCentroCus	:= aMartCC[nCntCC][1]
					nValorCC	:= aMartCC[nCntCC][2]
					nPercCC		:= aMartCC[nCntCC][3]
					
					IF SEZ->EZ_CCUSTO <> cCentroCus .OR. SEZ->EZ_VALOR <> nValorCC .OR. SEZ->EZ_PERC <> nPercCC
						RecLock( "SEZ", .F. )
						SEZ->EZ_CCUSTO 	:= cCentroCus
						SEZ->EZ_VALOR	:= nValorCC
						SEZ->EZ_PERC	:= nPercCC
						SEZ->( MsUnLock() )
					ENDIF
					
					SEZ->( DbSkip() )
				ENDDO
			ENDIF
		NEXT nZ
	EndIf

RETURN cRet