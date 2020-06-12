#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"

#DEFINE ID "Admin"

#DEFINE SENHA "123"



/*/{Protheus.doc} MDRAlcDoc
Chamada WEB na URL de liberação, conforme abaixo

http://IP:PORTA/u_MDRAlcDoc.apw?cCompany=cEmpAnt&cID=CR_CHVWF&cAction=ACAO[aprovar, rejeitar, bloquear]

@author Rafael Ricardo Vieceli
@since 23/08/2018
@version 1.0
@return character, Pagina HTML

@type function
/*/
user function MDRAlcDoc()

	//conecta no ambiente
	Local lConectou := StartEnv()

	Local cHtml := ''

	IF lConectou

		//função para liberação
		Libera()

		//desconecta do ambiente
		RPCClearEnv()

	EndIF

return l_MDRAlcDoc()



static function Libera()

	Local cID
	Local cAction

	Local aMTAlcDoc

	//verifica se os parametro obrigatórios foram informados
	IF ! existParams({'cID', 'cAction'})
		setSession('ERRO', 'Parâmetro inválidos para Liberação de Documentos.', "Impossível identificar")
		return .F.
	EndIF

	cID     := HttpGet->cID
	cAction := upper(HttpGet->cAction)

	//verifica se a ação esta entre as ações esperadas
	IF aScan({"APROVAR","REJEITAR","BLOQUEAR"}, {|action| action == cAction}) == 0
		setSession('ERRO', 'A ação ' + Capital(cAction) + ' não está prevista, apenas "Aprovar", "Rejeitar" e "Bloquear".', "Ação não esperada")
		return .F.
	EndIF

	ConOut('MDRAlcDOC -> ' + upper(cAction) + " " + cID)

	dbSelectArea("SCR")

	//busca o registro de alçada
	SCR->( dbOrderNickName("SCRCHVWF") )
	//sem filial
	SCR->( dbSeek( cID ) )

	//se não encontrar o registro
	IF ! SCR->( Found() )
		setSession('ALERTA', 'Liberação não foi encontrada com a chave <b> '+ cID + '</b>.', "Não encontrado")
		return .F.
	EndIF

	//se não estiver pendente
	IF SCR->CR_STATUS != "02"
		setSession('AJUDA', 'Liberação foi encontrada, porém não é possivel liberar pois está com status <b>' + upper(getStatus(SCR->CR_STATUS)) + '</b>.', tipoDoc())
		return .F.
	EndIF

	do case
		case SCR->CR_TIPO == 'SC'
			SC1->( dbSetOrder(1) )
			SC1->( msSeek( xFilial("SC1") + PadR(SCR->CR_NUM, tamSX3('C1_NUM')[1]) ) )
		case SCR->CR_TIPO == 'PC' .Or. SCR->CR_TIPO == 'IP'
			SC7->( dbSetOrder(1) )
			SC7->( msSeek( xFilial("SC7") + PadR(SCR->CR_NUM, tamSX3('C7_NUM')[1]) ) )
		case SCR->CR_TIPO == 'NF'
			SF1->( dbSetOrder(1) )
			SF1->( msSeek( xFilial("SF1") + PadR(SCR->CR_NUM, tamSX3('F1_DOC')[1] + tamSX3('F1_SERIE')[1] + tamSX3('F1_FORNECE')[1] + tamSX3('F1_LOJA')[1] ) ) )
	endcase

	//altera a filial para a mesma filial da alçada
	cFilAnt := SCR->CR_FILIAL
	//volta pro indice original
	SCR->( dbSetOrder(1) )

	do case
		case cAction == 'APROVAR'
			IF temSaldo()
				setMessage(cAction, _libera())
			EndIF
		case cAction == 'REJEITAR'
			setMessage(cAction, _rejeita())
		case cAction == 'BLOQUEAR'
			setMessage(cAction, _bloqueia())
	endcase


return .T.


static function setMessage(cAction, lOk)

	Local cPassado := lower(subStr(cAction,1,len(cAction)-1)+'da')

	IF lOk
		If(TipoDoc() == "Documento de entrada")
			setSession(cPassado, 'Sua alçada referente ' + tipoDoc() + ' número ' + alltrim(SF1->F1_DOC) + ' série ' + ALLTRIM(SF1->F1_SERIE) + ' fornecedor ' + ALLTRIM(SF1->F1_FORNECE) + ' loja ' + ALLTRIM(SF1->F1_LOJA) +' foi ' + cPassado + ' com sucesso.', tipoDoc(,cAction) )
		Else
			setSession(cPassado, 'Sua alçada referente ' + tipoDoc() + ' número ' + alltrim(SCR->CR_NUM) + ' foi ' + cPassado + ' com sucesso.', tipoDoc(,cAction) )
		Endif
	Else
		setSession('ERRO', 'Não foi possível ' + lower(cAction) + ' sua alçada referente ' + tipoDoc() + ' número ' + alltrim(SCR->CR_NUM) + '. </br> ' + getErroAuto(), 'Erro - ' + tipoDoc())
	EndIF

return


static function _libera()

	//controle de erro
	Private lMsErroAuto := .F.
	//erro em array
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto := .T.

	DBSelectArea("SF1")

	SF1->(DBSetOrder(1))

	SF1->(DBSeek(ALLTRIM(SCR->(CR_FILIAL)+SCR->(CR_NUM))))

	MSExecAuto( { |a, b, c| A097ProcLib(a,b,,,,,c) }, SCR->(Recno()), 2, dDataBase)

return ! lMsErroAuto


static function _rejeita()
return MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SCR->CR_APROV,,SCR->CR_GRUPO,,,,dDataBase,"Rejeitado via Wrokflow"}, dDataBase ,7,,,,,,,alltrim(SCR->CR_NUM))


static function _bloqueia()

	//controle de erro
	Private lMsErroAuto := .F.
	//erro em array
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto := .T.

	MSExecAuto( { |a, b, c, d| A097ProcLib(a,b,,,c,d)  }, SCR->(Recno()), 6, dDataBase,"Bloqueado via Workflow")

return ! lMsErroAuto


static function temSaldo()

	Local aSaldo := {}

	SAK->( dbSetOrder(1) )
	SAK->( msSeek( xFilial("SAK") + SCR->CR_APROV ) )

	dbSelectArea("SCS")
	SCS->( dbSetOrder(2) )

	aSaldo := MaSalAlc(SCR->CR_APROV,dDataBase,.T.)

	IF aSaldo[1] < SCR->CR_TOTAL
		setSession('semsaldo', 'Não foi possível aprovar alçada referente ' + tipoDoc() + ' número ' + SCR->CR_NUM + ', pois seu saldo é insuficiente para aprovar.', 'Saldo insuficiente')
		return .F.
	EndIF

return .T.


//facilitar para transformar o ErroAuto (array) numa string
static function getErroAuto()
	Local cErro := ''
	aEval( GetAutoGRLog(), {|line| cErro += (line + CRLF) })
return cErro


static function getStatus(cStatus)

	default cStatus := SCR->CR_STATUS

	do case
		case cStatus == "01"
			return 'Aguardando nível anterior'
		case cStatus == "03"
			return 'Liberado'
		case cStatus == "04"
			return 'Bloqueado'
		case cStatus == "05"
			return 'Avaliado por outro usuário'
		case cStatus == "06"
			return 'Rejeitado'
	endcase

return ''


static function tipoDoc(cTipo,cAction)

	default cTipo := SCR->CR_TIPO

	do case
		case cTipo == "IP"
			return 'Item do Pedido de Compras' + IIF( empty(cAction), '', ' ' + capital(subStr(cAction,1,len(cAction)-1)+'do'))
		case cTipo == "PC"
			return 'Pedido de Compras' + IIF( empty(cAction), '', ' ' + capital(subStr(cAction,1,len(cAction)-1)+'do'))
		case cTipo == "SC"
			return 'Solicitação de Compras' + IIF( empty(cAction), '', ' ' + capital(subStr(cAction,1,len(cAction)-1)+'da'))
		case cTipo == "NF"
			return 'Documento de entrada' + IIF( empty(cAction), '', ' ' + capital(subStr(cAction,1,len(cAction)-1)+'do'))
	endcase

return ''


/*/{Protheus.doc} StartEnv
Função para iniciar o ambiente

@author Rafael Ricardo Vieceli
@since 23/08/2018
@version 1.0
@return logical, se conectou

@type function
/*/
static function StartEnv()

	Local cCompany
	Local cBranch

	//se a empresa for enviada como parametro
 	IF existParams({"cCompany"})
 		//pega a empresa
 		cCompany := HttpGet->cCompany
 	EndIF

	//se a empresa for enviada como parametro
 	IF existParams({"cBranch"})
 		//pega a empresa
 		cBranch := HttpGet->cBranch
 	EndIF

 	//se não foi passado na URL
 	IF empty(cCompany)
 		getCompanyByIni(@cCompany, @cBranch)
 	EndIF

 	//se mesmo assim não tiver uma empresa, não poderá conectar
 	IF empty(cCompany)
 		setSession('ERRO', 'Não é possével conectar no ambiente, pois falta parâmentos na URL ou chave PrepareIn.',"Impossível conectar")
 		return .F.
 	EndIF

 	//não consome licença
	RPCSetType( 3 )

	//conecta
return	RPCSetEnv( cCompany , cBranch,,,,,,,,.T.)



/*/{Protheus.doc} getCompanyByIni
Função para pegar Empresa e Filial no INI

@author Rafael Ricardo Vieceli
@since 23/08/2018
@version 1.0
@return ${return}, ${return_description}
@param cCompany, characters, @Codigo da Empresa
@param cBranch, characters, @Codigo da Filial
@type function
/*/
static function getCompanyByIni(cCompany, cBranch)

	Local aPrepareIn := separa(GetPvProfString( getWebJob(), "PrepareIn", "", GetADV97() ),',')

	IF ! empty(aPrepareIn[1])
		cCompany := aPrepareIn[1]
	EndIF

	IF ! empty(aPrepareIn[2])
		cBranch  := aPrepareIn[2]
	EndIF

return


/*/{Protheus.doc} existParams
Função para verificar se existe os parametros HTML

@author Rafael Ricardo Vieceli
@since 23/08/2018
@version 1.0
@return logical, se encontrou todos
@param aParams, array, Lista de parametro a verificar
@type function
/*/
static function existParams(aParams)

	Local nParam

	For nParam := 1 to len(aParams)
		IF aScan( httpGet->AGETS, { |x| upper(x) == upper(aParams[nParam]) }) == 0
			return .F.
		EndIF
	Next nParam

return .T.


static function setSession(cTipoMensagem, cMensagem, cTipoLiberacao)

	HTTPSession->cTipoMensagem  := cTipoMensagem
	HTTPSession->cMensagem      := cMensagem
	HTTPSession->cTipoLiberacao := cTipoLiberacao

return