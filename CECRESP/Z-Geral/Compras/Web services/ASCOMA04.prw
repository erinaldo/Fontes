#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"         
#INCLUDE "TOTVS.CH"     
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA04
Webservice no Protheus para ser consumido pelo Fluig com o objetivo 
de realizar integração entre os dois sistemas - Aprovações de Compras

Métodos:
detalhesPedidoCompra
itensPedidoCompra
detalhesRateioItem
proximoAprovador
aprovarReprovarPedidoCompra

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		04/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSSERVICE IntegraFluig Description "Web Service integração entre o Protheus e o Fluig - Compras"

	//-----------------------------------------------------------------------
	// Dados
	//-----------------------------------------------------------------------
	WSDATA NomeUsuario				AS STRING
	WSDATA SenhaUsuario				AS STRING
	WSDATA CNPJEmpresa 				AS STRING
	WSDATA GrupoEmpresas			AS STRING
	WSDATA NumeroPedido				AS STRING
	WSDATA ListaDetalhesPedido 		AS ARRAY OF STRUCListaDetalhesPedido
	WSDATA ListaItensPedido 		AS ARRAY OF STRUCListaItensPedido
	WSDATA ListaRateioItensPed 		AS ARRAY OF STRUCListaRateioItensPed
	WSDATA Decisao					AS STRING
	WSDATA ListaproximoAprovador 	AS ARRAY OF STRUCListaproximoAprovador
	WSDATA ListaaprovarReprovarPed	AS ARRAY OF STRUCListaaprovarReprovarPed
	WSDATA SequenciaItemPed			AS STRING
	WSDATA MatriculaAprovador		AS STRING
	WSDATA NivelAprovador			AS STRING
	WSDATA TipoDocumento			AS STRING

	//-----------------------------------------------------------------------
	// Métodos
	//-----------------------------------------------------------------------
	WSMETHOD detalhesPedidoCompra 			DESCRIPTION "Método para consultar os dados de cabeçalho e rodapé do pedido de compra do Protheus"
	WSMETHOD itensPedidoCompra				DESCRIPTION "Método para consultar os itens do pedido de compra do Protheus"
	WSMETHOD detalhesRateioItem				DESCRIPTION "Método para consultar o rateio dos itens do pedido de compra do Protheus"
	WSMETHOD proximoAprovador				DESCRIPTION "Método para aprovar pelo aprovador atual e consultar o próximo aprovador de acordo com a alçada no Protheus"
	WSMETHOD aprovarReprovarPedidoCompra	DESCRIPTION "Método para aprovar ou reprovar o pedido de compras do Protheus"
ENDWSSERVICE


//-----------------------------------------------------------------------
// Estruturas de dados
//-----------------------------------------------------------------------
WSSTRUCT STRUCListaDetalhesPedido
	WSDATA TipoDocumento		AS STRING	OPTIONAL
	WSDATA CodigoFornecedor		AS STRING	OPTIONAL
	WSDATA LojaFornecedor 		AS STRING	OPTIONAL
	WSDATA NomeFornecedor 		AS STRING	OPTIONAL
	WSDATA RazaoSocial 			AS STRING	OPTIONAL
	WSDATA CodCondicaoPagto 	AS STRING	OPTIONAL
	WSDATA DescCondicaoPagto 	AS STRING	OPTIONAL
	WSDATA MatriculaAprovador 	AS STRING	OPTIONAL
	WSDATA NomeAprovador 		AS STRING	OPTIONAL
	WSDATA NivelAprovador 		AS STRING	OPTIONAL
	WSDATA Observacao 			AS STRING	OPTIONAL
	//WSDATA TotalMercadorias 	AS FLOAT	OPTIONAL
	//WSDATA Descontos  		AS FLOAT	OPTIONAL
	//WSDATA Despesas  			AS FLOAT	OPTIONAL
	//WSDATA Seguro  			AS FLOAT	OPTIONAL
	//WSDATA Frete  			AS FLOAT	OPTIONAL
	//WSDATA TotalPedido  		AS FLOAT	OPTIONAL
	WSDATA TotalMercadorias 	AS STRING	OPTIONAL
	WSDATA Descontos  			AS STRING	OPTIONAL
	WSDATA Despesas  			AS STRING	OPTIONAL
	WSDATA Seguro  				AS STRING	OPTIONAL
	WSDATA Frete  				AS STRING	OPTIONAL
	WSDATA TotalPedido  		AS STRING	OPTIONAL
	WSDATA CodigoMoeda  		AS INTEGER	OPTIONAL
	WSDATA SimboloMoeda  		AS STRING	OPTIONAL
	WSDATA NomeMoeda  			AS STRING	OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRUCListaItensPedido
	WSDATA SequenciaItemPed	AS STRING	OPTIONAL
	WSDATA CodigoProduto 	AS STRING	OPTIONAL
	WSDATA DescricaoProduto	AS STRING	OPTIONAL
	WSDATA Unidade 			AS STRING	OPTIONAL
	//WSDATA Quantidade 	AS FLOAT	OPTIONAL
	//WSDATA PrecoUnitario 	AS FLOAT	OPTIONAL
	//WSDATA PrecoTotal 	AS FLOAT	OPTIONAL
	WSDATA Quantidade 		AS STRING	OPTIONAL
	WSDATA PrecoUnitario 	AS STRING	OPTIONAL
	WSDATA PrecoTotal 		AS STRING	OPTIONAL
	WSDATA DataEntrega 		AS STRING	OPTIONAL
	WSDATA ObservacaoItem 	AS STRING	OPTIONAL
ENDWSSTRUCT


WSSTRUCT STRUCListaRateioItensPed
	WSDATA SequenciaItemPed	AS STRING	OPTIONAL
	WSDATA SequenciaRateio 	AS STRING	OPTIONAL
	//WSDATA Percentual 	AS FLOAT	OPTIONAL
	WSDATA Percentual 		AS STRING	OPTIONAL
	WSDATA CentroCusto 		AS STRING	OPTIONAL
	WSDATA PlanoConta 		AS STRING	OPTIONAL
	WSDATA ItemContabil 	AS STRING	OPTIONAL
	WSDATA ClasseValores 	AS STRING	OPTIONAL
	WSDATA ValorRateio		AS STRING	OPTIONAL
	WSDATA DescCentroCusto	AS STRING	OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRUCListaproximoAprovador
	WSDATA MatriculaAprovador 	AS STRING	OPTIONAL
	WSDATA NomeAprovador 		AS STRING	OPTIONAL
	WSDATA NivelAprovador 		AS STRING	OPTIONAL
	WSDATA EmailAprovador 		AS STRING	OPTIONAL
	WSDATA ValorAprov	 		AS STRING	OPTIONAL
ENDWSSTRUCT

WSSTRUCT STRUCListaaprovarReprovarPed
	WSDATA Transacao			AS STRING	OPTIONAL
	WSDATA Mensagem				AS STRING	OPTIONAL
ENDWSSTRUCT


//-----------------------------------------------------------------------
/*/{Protheus.doc} detalhesPedidoCompra

Método para consultar os dados de cabeçalho e rodapé do pedido de compra 
do Protheus

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que será consultado
			NumeroPedido = Número do pedido de compras

@return		Detalhes do pedido de compras
@author 	Fabio Cazarini
@since 		04/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD detalhesPedidoCompra WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroPedido WSSEND	ListaDetalhesPedido WSSERVICE IntegraFluig
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroPed	:= ALLTRIM(::NumeroPedido)
	LOCAL lRet			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL nRegSC7		:= 0
	LOCAL nTotalMer		:= 0
	LOCAL nDesconto		:= 0
	LOCAL nDespesa		:= 0
	LOCAL nSeguro		:= 0
	LOCAL nFrete		:= 0
	LOCAL nTotalPed		:= 0
	LOCAL nCnt			:= 0
	LOCAL nDecTOT		:= 0
	LOCAL cEmpCod		:= ""
	LOCAL cFilCod		:= "" 
	LOCAL cEmpRazao		:= ""
	LOCAL aFH_SM0		:= {}
	LOCAL nPos_SM0		:= 0
	LOCAL TpDoc			:= GetMV("MV_APRPCEC")
	
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
			nPos_SM0 	:= aSCAN( aFH_SM0, {|x| ALLTRIM(x[SM0_GRPEMP]) == cGrupoEmpr .AND. ALLTRIM(x[SM0_CGC]) == ALLTRIM(cCNPJEmpre)})

			IF nPos_SM0 > 0
				cEmpCod	:= aFH_SM0[nPos_SM0][1]
				cFilCod	:= aFH_SM0[nPos_SM0][2]
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
	nDecTOT := TamSx3("C7_TOTAL")[2] 
	DbSelectArea("SC7")
	DbSetOrder(1) // C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
	IF DbSEEK(xFILIAL("SC7") + cNumeroPed)
		nRegSC7 := SC7->( Recno() )
		
		DO WHILE !SC7->( EOF() ) .AND. SC7->(C7_FILIAL + C7_NUM) == (xFILIAL("SC7") + cNumeroPed) 
			IF SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_QUJE < SC7->C7_QUANT
				nTotalMer	+= NoRound(SC7->C7_PRECO * (SC7->C7_QUANT - SC7->C7_QUJE) ,nDecTOT)
				nDesconto	+= NoRound((SC7->C7_VLDESC / SC7->C7_QUANT) * (SC7->C7_QUANT - SC7->C7_QUJE) ,nDecTOT)
				nDespesa	+= NoRound((SC7->C7_DESPESA / SC7->C7_QUANT) * (SC7->C7_QUANT - SC7->C7_QUJE) ,nDecTOT)
				nSeguro		+= NoRound((SC7->C7_SEGURO / SC7->C7_QUANT) * (SC7->C7_QUANT - SC7->C7_QUJE) ,nDecTOT)
				nFrete		+= NoRound((SC7->C7_VALFRE / SC7->C7_QUANT) * (SC7->C7_QUANT - SC7->C7_QUJE) ,nDecTOT)
			ENDIF
			
			SC7->( DbSkip() )
		ENDDO
		nTotalPed := nTotalMer + nDespesa + nSeguro + nFrete - nDesconto

		SC7->( MsGoTo(nRegSC7) )
	ELSE
		cRetExec := "Pedido de compras " + cNumeroPed + " não encontrado"
	ENDIF
	
		
	//-----------------------------------------------------------------------
	//Retorno
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		nCnt++
		AADD(::ListaDetalhesPedido,WSClassNew("STRUCListaDetalhesPedido"))

		::ListaDetalhesPedido[nCnt]:TipoDocumento		:= IF(TpDoc==.T.,"IP","PC")
		::ListaDetalhesPedido[nCnt]:CodigoFornecedor	:= SC7->C7_FORNECE
		::ListaDetalhesPedido[nCnt]:LojaFornecedor		:= SC7->C7_LOJA
		::ListaDetalhesPedido[nCnt]:NomeFornecedor		:= GETADVFVAL("SA2","A2_NREDUZ",xFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,1,"")
		::ListaDetalhesPedido[nCnt]:RazaoSocial			:= cEmpRazao //GETADVFVAL("SA2","A2_NOME",xFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,1,"")
		::ListaDetalhesPedido[nCnt]:CodCondicaoPagto	:= SC7->C7_COND
		::ListaDetalhesPedido[nCnt]:DescCondicaoPagto	:= GETADVFVAL("SE4","E4_DESCRI",xFILIAL("SE4")+SC7->C7_COND,1,"")
		::ListaDetalhesPedido[nCnt]:MatriculaAprovador	:= SC7->C7_XAPROVA
		::ListaDetalhesPedido[nCnt]:NomeAprovador		:= SC7->C7_XAPRNOM
		::ListaDetalhesPedido[nCnt]:NivelAprovador		:= SC7->C7_XAPRNIV
		::ListaDetalhesPedido[nCnt]:Observacao			:= SC7->C7_OBS
		::ListaDetalhesPedido[nCnt]:TotalMercadorias	:= ALLTRIM(TRANSFORM(nTotalMer, "@E 9,999,999,999,999.99"))
		::ListaDetalhesPedido[nCnt]:Descontos			:= ALLTRIM(TRANSFORM(nDesconto, "@E 9,999,999,999,999.99"))
		::ListaDetalhesPedido[nCnt]:Despesas			:= ALLTRIM(TRANSFORM(nDespesa, "@E 9,999,999,999,999.99"))
		::ListaDetalhesPedido[nCnt]:Seguro				:= ALLTRIM(TRANSFORM(nSeguro, "@E 9,999,999,999,999.99"))
		::ListaDetalhesPedido[nCnt]:Frete				:= ALLTRIM(TRANSFORM(nFrete, "@E 9,999,999,999,999.99"))
		::ListaDetalhesPedido[nCnt]:TotalPedido			:= ALLTRIM(TRANSFORM(nTotalPed, "@E 9,999,999,999,999.99"))
		::ListaDetalhesPedido[nCnt]:CodigoMoeda			:= SC7->C7_MOEDA
		::ListaDetalhesPedido[nCnt]:SimboloMoeda		:= RetMoeda(SC7->C7_MOEDA)[1]
		::ListaDetalhesPedido[nCnt]:NomeMoeda			:= RetMoeda(SC7->C7_MOEDA)[2]
		
		lRet := .T.
	ELSE
		SetSoapFault("IntegraFluig:detalhesPedidoCompra",cRetExec)
		lRet := .F.
	ENDIF
//	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} itensPedidoCompra

Método para consultar os itens do pedido de compra do Protheus

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que será consultado
			NumeroPedido = Número do pedido de compras

@return		Itens do pedido de compras
@author 	Fabio Cazarini
@since 		04/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD itensPedidoCompra WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroPedido WSSEND ListaItensPedido WSSERVICE IntegraFluig
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroPed	:= ALLTRIM(::NumeroPedido)
	LOCAL lRet			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL nCnt			:= 0
	LOCAL nDecTOT		:= 0

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
	DbSelectArea("SC7")
	DbSetOrder(1) // C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
	IF !DbSEEK(xFILIAL("SC7") + cNumeroPed)
		cRetExec := "Pedido de compras " + cNumeroPed + " não encontrado"
	ENDIF

	//-----------------------------------------------------------------------
	//Retorno
	//-----------------------------------------------------------------------
	nDecTOT := TamSx3("C7_TOTAL")[2]
	IF EMPTY(cRetExec)
		DbSelectArea("SC7")
		DO WHILE !SC7->( EOF() ) .AND. SC7->(C7_FILIAL + C7_NUM) == (xFILIAL("SC7") + cNumeroPed) 
			IF SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_QUJE < SC7->C7_QUANT
				nCnt++
				AADD(::ListaItensPedido,WSClassNew("STRUCListaItensPedido"))
	
				::ListaItensPedido[nCnt]:SequenciaItemPed	:= SC7->C7_ITEM
				::ListaItensPedido[nCnt]:CodigoProduto		:= SC7->C7_PRODUTO
				::ListaItensPedido[nCnt]:DescricaoProduto	:= GETADVFVAL("SB1","B1_DESC",xFILIAL("SB1")+SC7->C7_PRODUTO,1,"")
				::ListaItensPedido[nCnt]:Unidade			:= SC7->C7_UM
				::ListaItensPedido[nCnt]:Quantidade			:= ALLTRIM(TRANSFORM(SC7->C7_QUANT - SC7->C7_QUJE, "@E 999999999.99"))
				::ListaItensPedido[nCnt]:PrecoUnitario		:= ALLTRIM(TRANSFORM(SC7->C7_PRECO, "@E 9,999,999,999,999.99"))
				::ListaItensPedido[nCnt]:PrecoTotal			:= ALLTRIM(TRANSFORM(NoRound(SC7->C7_PRECO * (SC7->C7_QUANT - SC7->C7_QUJE) ,nDecTOT), "@E 9,999,999,999,999.99"))
				::ListaItensPedido[nCnt]:DataEntrega		:= DTOC(SC7->C7_DATPRF)
				::ListaItensPedido[nCnt]:ObservacaoItem		:= SC7->C7_OBS
			ENDIF
			
			SC7->( DbSkip() )
		ENDDO
		lRet := .T.
	ELSE
		SetSoapFault("IntegraFluig:itensPedidoCompra",cRetExec)
		lRet := .F.
	ENDIF
//	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} detalhesRateioItem

Método para consultar o rateio dos itens do pedido de compra do Protheus

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que será consultado
			NumeroPedido = Número do pedido de compras
			SequenciaItemPed = Sequencia do item do pedido de compras
			
@return		Rateio do itens do pedido de compras
@author 	Fabio Cazarini
@since 		04/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD detalhesRateioItem WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroPedido, SequenciaItemPed WSSEND ListaRateioItensPed WSSERVICE IntegraFluig
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroPed	:= ALLTRIM(::NumeroPedido)
	LOCAL cSeqItem		:= ALLTRIM(::SequenciaItemPed)
	LOCAL lRet			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL nCnt			:= 0
	LOCAL nDecTOT		:= 0
	
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

	nDecTOT := TamSx3("C7_TOTAL")[2]

	//-----------------------------------------------------------------------
	// Valida os parametros informados
	//-----------------------------------------------------------------------
	DbSelectArea("SC7")
	DbSetOrder(1) // C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
	IF !DbSEEK(xFILIAL("SC7") + cNumeroPed + cSeqItem)
		cRetExec := "Pedido de compras " + cNumeroPed + ", item " + cSeqItem + ", não encontrado"
	ENDIF

	//-----------------------------------------------------------------------
	//Retorno
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)

		DbSelectArea("SCH")
		DbSetOrder(1) // CH_FILIAL + CH_PEDIDO + CH_FORNECE + CH_LOJA + CH_ITEMPD + CH_ITEM
		DbSEEK(xFILIAL("SCH")+SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_ITEM)
		
		DO WHILE 	!SCH->( EOF() ) .AND.;
		 			SCH->(CH_FILIAL+CH_PEDIDO+CH_FORNECE+CH_LOJA+CH_ITEMPD) == (xFILIAL("SCH")+SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_ITEM) 

		 		nCnt++
		 		AADD(::ListaRateioItensPed,WSClassNew("STRUCListaRateioItensPed"))

				::ListaRateioItensPed[nCnt]:SequenciaItemPed	:= SCH->CH_ITEMPD
				::ListaRateioItensPed[nCnt]:SequenciaRateio		:= SCH->CH_ITEM
				::ListaRateioItensPed[nCnt]:Percentual			:= ALLTRIM(TRANSFORM(SCH->CH_PERC, "@E 9999.99"))
				::ListaRateioItensPed[nCnt]:CentroCusto			:= SCH->CH_CC+ALLTRIM(POSICIONE("CTT",1,XFILIAL("CTT")+SCH->CH_CC,"CTT_DESC01"))
				::ListaRateioItensPed[nCnt]:PlanoConta			:= SCH->CH_CONTA
				::ListaRateioItensPed[nCnt]:ItemContabil		:= SCH->CH_ITEMCTA
				::ListaRateioItensPed[nCnt]:ClasseValores		:= SCH->CH_CLVL
				::ListaRateioItensPed[nCnt]:ValorRateio			:= ALLTRIM(TRANSFORM( NoRound(SCH->CH_PERC * (SC7->C7_PRECO * (SC7->C7_QUANT - SC7->C7_QUJE)),nDecTOT)  , "@E 9,999,999,999,999.99")) 
				::ListaRateioItensPed[nCnt]:DescCentroCusto		:= GETADVFVAL("CTT","CTT_DESC01",xFILIAL("CTT")+SCH->CH_CC,1,"")

			SCH->( DbSkip() )
		ENDDO
		
		lRet := .T.
	ELSE
		SetSoapFault("IntegraFluig:detalhesRateioItem",cRetExec)
		lRet := .F.
	ENDIF
//	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	
RETURN lRet

	
//-----------------------------------------------------------------------
/*/{Protheus.doc} proximoAprovador

Método para aprovar pelo aprovador atual e consultar o próximo aprovador 
de acordo com a alçada no Protheus

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que será consultado
			NumeroPedido = Número do pedido de compras
			MatriculaAprovador = Matrícula do aprovador que aprovou
			NivelAprovador = Nível do aprovador que aprovou
			TipoDocumento = PC para pedido de compras
			
@return		Matrícula e nível do próximo aprovador
@author 	Fabio Cazarini
@since 		04/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD proximoAprovador WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroPedido, MatriculaAprovador, NivelAprovador,  TipoDocumento WSSEND ListaproximoAprovador WSSERVICE IntegraFluig
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroPed	:= ALLTRIM(::NumeroPedido)
	LOCAL cMatrAprov	:= ALLTRIM(::MatriculaAprovador)
	LOCAL cNivelApro	:= ALLTRIM(::NivelAprovador)
	LOCAL cTipoDocum	:= ALLTRIM(::TipoDocumento)
	LOCAL cUsrEmail		:= ""
	LOCAL lRet			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL nCnt			:= 0
	LOCAL cChaveSCR		:= ""
	LOCAL lAchouApro 	:= .F.
	LOCAL cProxAprov 	:= ""
	LOCAL cProxNivel	:= ""
	LOCAL lLibOk		:= .T.
	LOCAL lLiberou		:= .T.
	LOCAL lIniciaFlu 	:= .F.
	LOCAL cCodLiber 	:= ""
	LOCAL cGrupo 		:= ""
	LOCAL aRetSaldo 	:= {}
	LOCAL nSaldo 	  	:= 0
	LOCAL nTotal    	:= 0
	LOCAL nValAprov		:= 0
	
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
	lAchouApro := .F.
	IF EMPTY(cRetExec)
		cChaveSCR	:= xFilial("SCR") + PADR(cTipoDocum, TAMSX3("CR_TIPO")[1]) + PADR(cNumeroPed, TAMSX3("CR_NUM")[1]) + PADR(cNivelApro, TAMSX3("CR_NIVEL")[1]) 
		dbSelectArea("SCR")
		SCR->(dbSetOrder(1)) // CR_FILIAL + CR_TIPO + CR_NUM + CR_NIVEL
		IF DbSEEK(cChaveSCR)
			DO WHILE !SCR->( EOF() ) .AND. SCR->(CR_FILIAL + CR_TIPO + CR_NUM + CR_NIVEL) == cChaveSCR
				IF cMatrAprov == ALLTRIM(UsrRetName(SCR->CR_USER)) .AND. SCR->CR_STATUS == "02" 
					lAchouApro := .T.
					Exit 
				ENDIF
				SCR->(dbSkip())
			ENDDO
		ENDIF
	ENDIF

	IF EMPTY(cRetExec)
		IF lAchouApro
			dbSelectArea("SC7")
			dbSetOrder(1)
			IF !MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
				cRetExec := "Pedido de compras " + ALLTRIM(SCR->CR_NUM) + " não encontrado"
			ENDIF
		ENDIF
	ENDIF
	
	IF EMPTY(cRetExec)
		IF lAchouApro
			IF !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
				lIniciaFlu := .T. // Iniciou o processo no Fluig, indicando o próximo a liberar	
			ELSEIF SCR->CR_STATUS$"01"
				cRetExec :=  "Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
			ELSEIF SCR->CR_STATUS$"02" // Aguardando Liberacao do usuario
				//-----------------------------------------------------------------------
				// Libera o pedido pelo usuário
				//-----------------------------------------------------------------------
				dbSelectArea("SAK")
				dbSetOrder(1)
				MsSeek(xFilial("SAK")+SCR->CR_APROV)

				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

				dbSelectArea("SAL")
				dbSetorder(3)
				MsSeek(xFilial("SAL")+SC7->C7_APROV+SAK->AK_APROSUP)
	
				lLibOk := SC7Lock(cNumeroPed)
				IF lLibOk
					cCodLiber 	:= SCR->CR_APROV
					cGrupo 		:= SCR->CR_GRUPO  //SC7->C7_APROV
					aRetSaldo 	:= MaSalAlc(cCodLiber,dDATABASE)
					nSaldo 	  	:= aRetSaldo[1]
					nTotal    	:= xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
					nRegSCR		:= SCR->(RECNO())
					
					Begin Transaction
						lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,"Aprovação via Fluig"},dDATABASE,4)
						
						SCR->(DBGOTO(nRegSCR))
						cTipoDoc := SCR->CR_TIPO
						cDocto	 := SCR->CR_NUM
							
						While SCR->(!Eof()) .And. xFilial("SCR") + cTipoDoc + cDocto == SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM
							If SCR->CR_STATUS != "03" .And. SCR->CR_STATUS != "05" .And. SCR->CR_STATUS != "04"
								lLiberou := .F.
								Exit
							EndIf
							SCR->(dbSkip())
						EndDo						
						
						SCR->(DBGOTO(nRegSCR))
						
						dbSelectArea("SC7")
						While !SC7->(Eof()) .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
							IF SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_QUJE < SC7->C7_QUANT
								Reclock("SC7",.F.)
								IF lLiberou
									SC7->C7_CONAPRO := "L"
								ENDIF	
								SC7->C7_XSFLUIG := 'I' // liberacao iniciada no Fluig
								
								MsUnlock()
							ENDIF
							
							SC7->(dbSkip())
						EndDo
					End Transaction
				ELSE
					cRetExec := "A operação não pode ser executada agora pois o mesmo registro está em uso por outro usuário"
				ENDIF
				SC7->(MsUnlockAll())
			ELSE // não achou processo aguardando liberação 
				lIniciaFlu := .T.
			ENDIF
		ELSE // não achou aprovador
			lIniciaFlu := .T.		
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Iniciou o processo no Fluig (nao achou processo aguardando liberação 
	// ou não achou aprovador)
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		IF lIniciaFlu
			lLibOk := SC7Lock(cNumeroPed)
			IF lLibOk
				Begin Transaction
					dbSelectArea("SC7")
					dbSetOrder(1)
					MsSeek(xFilial("SC7")+Substr(cNumeroPed,1,len(SC7->C7_NUM)))
					While !SC7->(Eof()) .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(cNumeroPed,1,len(SC7->C7_NUM))
						IF SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_QUJE < SC7->C7_QUANT
							Reclock("SC7",.F.)
							SC7->C7_XSFLUIG := 'I' // liberacao iniciada no Fluig
							MsUnlock()
						ENDIF
						
						SC7->(dbSkip())
					EndDo
				End Transaction
			ELSE
				cRetExec := "A operação não pode ser executada agora pois o mesmo registro está em uso por outro usuário"
			ENDIF
			SC7->(MsUnlockAll())
		ENDIF
	ENDIF
	
	//-----------------------------------------------------------------------
	// Retorno
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
		//-----------------------------------------------------------------------
		// Retorna o próximo aprovador do PC 
		//-----------------------------------------------------------------------
		cProxAprov 	:= ""
		cProxNivel	:= ""

		cChaveSCR	:= xFilial("SCR") + PADR(cTipoDocum, TAMSX3("CR_TIPO")[1]) + PADR(cNumeroPed, TAMSX3("CR_NUM")[1])
		dbSelectArea("SCR")
		SCR->(dbSetOrder(1)) // CR_FILIAL + CR_TIPO + CR_NUM + CR_NIVEL
		IF DbSEEK(cChaveSCR)
			DO WHILE !SCR->( EOF() ) .AND. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) == cChaveSCR
				IF SCR->CR_STATUS == "02" // Aguardando Liberacao do usuario
					cProxAprov 	:= UsrRetName(SCR->CR_USER)
					cProxNivel	:= SCR->CR_NIVEL
					cUsrEmail	:= UsrRetMail(SCR->CR_USER)
					nValAprov	:= SCR->CR_TOTAL  // Zema 25/08/2017  -- Valor a ser aprovado
					Exit 
				ENDIF
				SCR->(dbSkip())
			ENDDO
		ENDIF

 		nCnt++
 		AADD(::ListaproximoAprovador,WSClassNew("STRUCListaproximoAprovador"))

		::ListaproximoAprovador[nCnt]:MatriculaAprovador 	:= cProxAprov
		::ListaproximoAprovador[nCnt]:NivelAprovador		:= cProxNivel
		::ListaproximoAprovador[nCnt]:EmailAprovador		:= cUsrEmail
		::ListaproximoAprovador[nCnt]:ValorAprov    		:= ALLTRIM(TRANSFORM(nValAprov, "@E 9,999,999,999,999.99"))  // Zema 25/08 valor de aprovação

		lRet := .T.
	ELSE
		SetSoapFault("IntegraFluig:proximoAprovador",cRetExec)
		lRet := .F.
	ENDIF

//	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} aprovarReprovarPedidoCompra

Método para aprovar ou reprovar o pedido de compras do Protheus. O PC
deve estar apto à liberação (C7_CONAPRO = 'L')

@param		CNPJEmpresa	= CNPJ da empresa a ser consultada
			GrupoEmpresas = Grupo de empresas que será consultado
			NumeroPedido = Número do pedido de compras
			Decisao = Decisão tomada:
			'01' = Pedido de compra aprovado (C7_XSFLUIG = "A")
			'02' = Pedido de compra reprovado (C7_XSFLUIG = "R")
			
@return		Transação e mensagem da transação:
			'01' = Pedido de compra aprovado com sucesso
			'02' = Pedido de compra reprovado com sucesso
			'03' = Falha ao integrar decisão da aprovação no Protheus e adicionar mensagem de erro do Protheus

@author 	Fabio Cazarini
@since 		04/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
WSMETHOD aprovarReprovarPedidoCompra WSRECEIVE NomeUsuario, SenhaUsuario, CNPJEmpresa, GrupoEmpresas, NumeroPedido, Decisao WSSEND	ListaaprovarReprovarPed WSSERVICE IntegraFluig
	LOCAL cNomeUsuar	:= ALLTRIM(::NomeUsuario)
	LOCAL cSenhaUsua	:= ALLTRIM(::SenhaUsuario)
	LOCAL cCNPJEmpre	:= ALLTRIM(::CNPJEmpresa)
	LOCAL cGrupoEmpr	:= ALLTRIM(::GrupoEmpresas)
	LOCAL cNumeroPed	:= ALLTRIM(::NumeroPedido)
	LOCAL cDecisao		:= ALLTRIM(::Decisao)
	LOCAL lRet			:= .T.
	LOCAL cRetExec		:= ""
	LOCAL nCnt			:= 0
	LOCAL cTransacao	:= ""
	LOCAL cMensagem		:= ""
	LOCAL lLibOk		:= .T.

	LOCAL nPerc			:= 100
	LOCAL cTipo 		:= 1
	LOCAL dEmisDe 		:= CTOD("//")
	LOCAL dEmisAte 		:= CTOD("31/12/2049")
	LOCAL cCodigoDe 	:= cNumeroPed
	LOCAL cCodigoAte 	:= cNumeroPed 
	LOCAL cProdDe 		:= ""
	LOCAL cProdAte 		:= REPLICATE("Z", TAMSX3("C7_PRODUTO")[1])
	LOCAL cFornDe 		:= ""
	LOCAL cFornAte 		:= REPLICATE("Z", TAMSX3("C7_FORNECE")[1])
	LOCAL dDatprfde 	:= CTOD("//")
	LOCAL dDatPrfAte 	:= CTOD("31/12/2049")
	LOCAL cItemDe 		:= ""
	LOCAL cItemAte 		:= REPLICATE("Z", TAMSX3("C7_ITEM")[1])
	LOCAL lConsEIC 		:= .T.
	LOCAL aRecSC7		:= {}
	LOCAL lOrigSCTOP	:= .F.
	LOCAL aRet235		:= {}
	
	LOCAL aCab 			:= {}
	LOCAL aItens 		:= {}
	LOCAL nRegSC7		:= 0
	LOCAL cRetMsExec	:= ""
	
	LOCAL cNumCot 		:= "" 	
	LOCAL cFornec 		:= "" 
	LOCAL cLoja   		:= ""   
	LOCAL cCRLF			:= CHR(13) + CHR(10)
	LOCAL cRET			:= ""
	LOCAL aErro
	LOCAL nY
				
	PRIVATE lMsErroAuto
	PRIVATE lAutoErrNoFile

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
	DbSelectArea("SC7")
	DbSetOrder(1) // C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
	IF !DbSEEK(xFILIAL("SC7") + cNumeroPed)
		cRetExec := "Pedido de compras " + cNumeroPed + " não encontrado"
	ENDIF

	IF EMPTY(cRetExec)
		IF cDecisao == "01"
			//-----------------------------------------------------------------------
			// Pedido de compras APROVADO
			//-----------------------------------------------------------------------
			IF SC7->C7_CONAPRO == "L"
				lLibOk := SC7Lock(cNumeroPed)
				IF lLibOk
					Begin Transaction
						dbSelectArea("SC7")
						dbSetOrder(1)
						MsSeek(xFilial("SC7")+Substr(cNumeroPed,1,len(SC7->C7_NUM)))
						While !SC7->(Eof()) .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(cNumeroPed,1,len(SC7->C7_NUM))
							IF SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_QUJE < SC7->C7_QUANT
								Reclock("SC7",.F.)
								SC7->C7_XSFLUIG := 'A' // pedido de compras aprovado
								SC7->C7_XDTAPRO := dDataBase  // Zema 25/08/2017 - informa a data de aprovação do pedido
								MsUnlock()
							ENDIF
							
							SC7->(dbSkip())
						EndDo
					End Transaction

					cTransacao	:= "01"
					cMensagem	:= "Pedido de compra aprovado com sucesso"
				ELSE
					cRetExec := "A operação não pode ser executada agora pois o mesmo registro está em uso por outro usuário"
				ENDIF
				SC7->(MsUnlockAll())
			ELSE
				cTransacao	:= "03"
				cMensagem	:= "Aprovação não efetivada: Pedido de compra não está apto a ser aprovado"
			ENDIF
		ELSEIF cDecisao == "02"
			//-----------------------------------------------------------------------
			// Pedido de compras REPROVADO
			//-----------------------------------------------------------------------

			//-----------------------------------------------------------------------
			// Verifica se o pedido de compras foi originado por SC gerada pelo TOP
			//-----------------------------------------------------------------------				
			lOrigSCTOP := .F.
			IF !EMPTY(SC7->C7_NUMSC)
				DbSelectArea("SC1")
				DbSetOrder(1) //C1_FILIAL, C1_NUM, C1_ITEM
				IF DbSeek( xFILIAL("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC )
					IF ALLTRIM(UPPER(SC1->C1_ORIGEM)) == "SOLUM"
						lOrigSCTOP := .T.
					ENDIF
				ENDIF
			ENDIF
			
			//-----------------------------------------------------------------------
			// Pedido originado por uma solicitação de compras gerada pelo RM TOP
			// Pedido será excluído através da execução da rotina automática MATA120
			//-----------------------------------------------------------------------
			IF lOrigSCTOP
				aCab 	:= {}
				aItens	:= {}
	
				AADD(aCab, {"C7_FILIAL"		, SC7->C7_FILIAL	, NIL})
		    	aAdd(aCab, {'C7_NUM'		, SC7->C7_NUM		, NIL})	//--Numero do Pedido
				aAdd(aCab, {'C7_EMISSAO'	, SC7->C7_EMISSAO	, Nil})	//--Data de Emissao
				aAdd(aCab, {'C7_FORNECE'	, SC7->C7_FORNECE	, Nil})	//--Fornecedor
				aAdd(aCab, {'C7_LOJA'		, SC7->C7_LOJA		, Nil})	//--Loja do Fornecedor
				aAdd(aCab, {'C7_CONTATO'	, SC7->C7_CONTATO   , Nil})	//--Contato
				aAdd(aCab, {'C7_COND'		, SC7->C7_COND		, Nil})	//--Condicao de Pagamento
				aAdd(aCab, {'C7_FILENT'		, SC7->C7_FILENT	, Nil})	//--Filial de Entrega		
	
				DbSelectArea("SC7")
				nRegSC7 := SC7->( RecNo() )
				DO WHILE !SC7->( EOF() ) .AND. SC7->(C7_FILIAL + C7_NUM) == (xFILIAL("SC7") + cNumeroPed)
					IF SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_QUJE < SC7->C7_QUANT
						aAdd(aItens, {;
								{ 'C7_NUM'		, SC7->C7_NUM 	 	, NIL },;
								{ 'C7_ITEM'		, SC7->C7_ITEM 	 	, NIL },;
								{ 'C7_PRODUTO'	, SC7->C7_PRODUTO	, NIL },;
								{ 'C7_QUANT'	, SC7->C7_QUANT		, NIL },;
								{ 'C7_PRECO'	, SC7->C7_PRECO		, NIL },;
								{ 'C7_TES'	 	, SC7->C7_TES		, NIL },;
								{ 'C7_FILCEN'	, SC7->C7_FILCEN	, Nil },;
								{ 'C7_TPOP'		, SC7->C7_TPOP		, NIL } ;
								} )						
					ENDIF
					
					SC7->( DbSkip() ) 
				ENDDO
				SC7->( DbGoTo( nRegSC7 ) )
	
				//-----------------------------------------------------------------------
				//Exclusao do pedido de compras via ExecAuto
				//-----------------------------------------------------------------------
				cNumCot 	:= SC7->C7_NUMCOT 	
				cFornec 	:= SC7->C7_FORNECE 
				cLoja   	:= SC7->C7_LOJA   
				
				DbSelectArea("SC8")									
				SC8->( dbSetOrder(3) ) 
				SC8->( DbSeek( xFILIAL("SC8") + cNumCot  + cFornec + cLoja + cNumeroPed ) )  		
				
				DbSelectArea("SC7")
	   			BeginTran()
	     		lMSErroAuto 	:= .F.
	     		lAutoErrNoFile 	:= .T.
	     		MsExecAuto({|v,x,y,z| MATA120(v, x, y, z)}, 1, aCab, aItens, 5)
				IF !lMsErroAuto
					EndTran()

					cTransacao	:= "02"
					cMensagem	:= "Pedido de compra reprovado com sucesso"
				ELSE
					cRetMsExec	:= ""
					aErro 		:= GetAutoGRLog()
					For nY := 1 To Len(aErro)
						cRetMsExec += aErro[nY] +cCRLF
					Next nY
				
					DisarmTransaction()
					cTransacao	:= "03"
					cMensagem	:= "Reprovação não efetivada: " + cCRLF + cRetMsExec
				ENDIF
				MsUnlockAll()
			ELSE
				//-----------------------------------------------------------------------
				// Pedido originado no Protheus ou medição de contrato do RM TOP
				// A legenda do pedido de compras será alterada para Pedido Reprovado
				//-----------------------------------------------------------------------
				lLibOk := SC7Lock(cNumeroPed)
				IF lLibOk
					Begin Transaction
						dbSelectArea("SC7")
						dbSetOrder(1)
						MsSeek(xFilial("SC7")+Substr(cNumeroPed,1,len(SC7->C7_NUM)))
						While !SC7->(Eof()) .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(cNumeroPed,1,len(SC7->C7_NUM))
							IF SC7->C7_RESIDUO <> 'S' .AND. SC7->C7_QUJE < SC7->C7_QUANT
								Reclock("SC7",.F.)
								SC7->C7_XSFLUIG := 'R' // pedido de compras reprovado
								SC7->C7_XDTAPRO := dDataBase  // Zema 25/08/2017 - informa a data de aprovação do pedido								
								MsUnlock()
							ENDIF	
			
							SC7->(dbSkip())
						EndDo
					End Transaction

					cTransacao	:= "02"
					cMensagem	:= "Pedido de compra reprovado com sucesso"

					//-----------------------------------------------------------------------
					// Pedido originado no Protheus (Pedido originado no RM TOP não permite 
					// elimiar resíduo)
					// Eliminar resíduo através da rotina MA235PC
					//-----------------------------------------------------------------------
					aRet235	:= {}
					aRet235	:= A235ELIRM(cNumeroPed,cNumeroPed) //  Função para validar se o pedido de compra foi originado pelo RM SOLUM
					
					IF aRet235[1] //  Pedido originado no Protheus (não é do SOLUM)
						MA235PC(nPerc, cTipo, dEmisDe, dEmisAte, cCodigoDe, cCodigoAte, cProdDe, cProdAte, cFornDe, cFornAte, dDatprfde, dDatPrfAte, cItemDe, cItemAte, lConsEIC,aRecSC7)
					ENDIF	
				ELSE
					cRetExec := "A operação não pode ser executada agora pois o mesmo registro está em uso por outro usuário"
				ENDIF
				SC7->(MsUnlockAll())
			ENDIF
		ELSE
			cRetExec := "A decisão deve ser 01-Pedido de compras aprovado, ou 02-Pedido de compras reprovado"		
		ENDIF
	ENDIF	

	//-----------------------------------------------------------------------
	//Retorno
	//-----------------------------------------------------------------------
	IF EMPTY(cRetExec)
 		nCnt++
 		AADD(::ListaaprovarReprovarPed,WSClassNew("STRUCListaaprovarReprovarPed"))

		::ListaaprovarReprovarPed[nCnt]:Transacao 	:= cTransacao
		::ListaaprovarReprovarPed[nCnt]:Mensagem 	:= cMensagem

		lRet := .T.
	ELSE
 		nCnt++
 		AADD(::ListaaprovarReprovarPed,WSClassNew("STRUCListaaprovarReprovarPed"))

		::ListaaprovarReprovarPed[nCnt]:Transacao 	:= "03" // Falha ao integrar decisão da aprovação no Protheus
		::ListaaprovarReprovarPed[nCnt]:Mensagem 	:= cRetExec

		lRet := .T.
	ENDIF
	
//	RpcClearEnv()									// Limpa o ambiente, liberando a licença e fechando as conexões
	
RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} RetMoeda

Retorna o símbolo e o nome da moeda de acordo com os parâmetroe MV_MOEDAx
e MV_SIMBx

@param		nMoeda = Código da moeda
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


//-----------------------------------------------------------------------
/*/{Protheus.doc} SC7Lock

Verifica se o pedido de compra nao esta com lock

@param		cNumero = Número do pedido de compras
@return		Sucesso no lock do pedido
@author 	Fabio Cazarini
@since 		06/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION SC7Lock(cNumero)
LOCAL lRet 	:= .F.
LOCAL aArea	:= SC7->(GetArea())

dbSelectArea("SC7")
dbSetOrder(1)
If MsSeek(xFilial("SC7")+PADR(cNumero,LEN(SC7->C7_NUM)))
	While !SC7->( EOF() ) .And. (SC7->C7_FILIAL+SC7->C7_NUM) == (xFilial("SC7")+PADR(cNumero,LEN(SC7->C7_NUM)))
		If RecLock("SC7")
			lRet := .T.
		Else
			lRet := .F.
			Exit
		Endif
		dbSkip()
	EndDo
EndIf

RestArea(aArea)

RETURN lRet
