#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FILEIO.CH'

/*/{Protheus.doc} GPPA032
Rotina para distribuição dos XMLs exportados do sistema DataMaxi para dentro dos diretórios da aplicação Totvs Protheus
@author DS2U (SDA)
@since 06/03/2019
@version 1.0
@return uRet, Retorno da funcao a ser executada
@param nOpc, numeric, Numero da opção da rotina a ser executada
@param uParam, undefined, Parâmetro da rotina a ser executada
@type function
/*/
User Function GPPA032( cEmp, cFilAtu, nOpc, uParam )

Local uRet      := nil

Default cEmp    := "99"
Default cFilAtu := "01"
Default nOpc    := 2

do Case

	case nOpc == 0
		FwMsgRun(,{|oSay| uRet := execSteps( oSay, uParam ) },"Migrador TAF - Distribuição de XMLs...","Processando..." )
		msgInfo( "Processamento finalizado!" )
		
	case nOpc == 1
		uRet := procByJob( uParam )
		
	case nOpc == 2
		uRet := execJob( {cEmp, cFilAtu,"\ESOCIAL"} )

endCase

Return uRet

/*/{Protheus.doc} procByJob
Funcao para controle de start de threads de processamento
@author DS2U (SDA)
@since 09/03/2019
@version 1.0

@type function
/*/
Static Function procByJob()

Local cDirOri1 := "\ESOCIAL"
//Local cDirOri1  := allTrim( getMv( "ES_TAFDOR1",, "\Migrador-TAF\xmls_datamaxi\XMLeSocial" ) )
//Local cDirOri2  := allTrim( getMv( "ES_TAFDOR2",, "\Migrador-TAF\xmls_datamaxi_2" ) )

startJob(	"U_GPPA032(,,2)";
			, getEnvServer();
			, .F.; // Aguarda o job ser finalizado
			, {"99", "01", cDirOri1} )
			
//startJob(	"U_GPPA032(2)";
//			, getEnvServer();
//			, .F.; // Aguarda o job ser finalizado
//			, {"01", "01010001", cDirOri2} )
	

Return

/*/{Protheus.doc} execJob
Funcao executora das threads de processamento
@author DS2U (SDA)
@since 09/03/2019
@version 1.0
@param aParams, array, Array de parametros [1] = Empresa
                                           [2] = Filial
                                           [3] = Diretorio origem dos XMLs a serem distribuidos
@type function
/*/
Static Function execJob( aParams )

Local llParamOk := valType( aParams ) == "A" .and. len( aParams ) > 0
Local cCompany  := iif( llParamOk .and. valType( aParams[1] ) == "C", aParams[1], "99" )
Local cBranch   := iif( llParamOk .and. len( aParams ) > 1 .and. valType( aParams[2] ) == "C", aParams[2], "01" )
Local cDirOri   := iif( llParamOk .and. len( aParams ) > 2 .and. valType( aParams[3] ) == "C", aParams[3], "" )
Local cFiltroXml   := iif( llParamOk .and. len( aParams ) > 3 .and. valType( aParams[4] ) == "C", aParams[4], "" )

if ( Empty( cCompany ) .or. Empty( cBranch ) .or. Empty( cDirOri ) )
	GPlogMsg( "***FAIL*** Nao foi possivel iniciar o JOB. Parametros obrigatorios nao identificados", NIL )
else

	RpcSetType(3)
	RpcSetEnv( cCompany, cBranch )

	if ( empty( cDirOri ) )
		cDirOri := allTrim( getMv("ES_TAFDORI",,"\ESOCIAL" ) )
	endif
	
	if ( empty( cFiltroXml ) )
		cFiltroXml := allTrim( getMv( "ES_TAFXMLF",, "\*.XML" ) )
	endif

	PtInternal(1,"Processando XMLs de " + cDirOri )
	execSteps( nil, cDirOri, cFiltroXml )
	
	RpcClearEnv()
	
endif

Return

/*/{Protheus.doc} execSteps
Rotina de controle das etapas a serem processadas
@author DS2U (SDA)
@since 06/03/2019
@version 1.0
@param oSay, object, description
@type function
/*/
Static Function execSteps( oSay, cDirOri, cFiltroXml )

Local cDirRaiz   := "\" + separa(cDirOri, "\")[2]
Local aXMLs    := {}
Local nlx
Local oXml
Local cError   := ""
Local cWarning := ""
Local cNameArq
Local cArquivo
Local clDirTo
Local cXML
Local nQtdArqs := 0
Local cElapTime:= time()
Local nQtdRegs := 0
Local cEvento
Local cCNPJ
Local cXmlFit  := ""

Private aCNPJsVlds := {}

Default cDirOri  := allTrim( getMv( "ES_TAFDORI",, "\ESOCIAL" ) )
Default cFiltroXml := allTrim( getMv( "ES_TAFXMLF",, "\*.XML" ) )

GPlogMsg( "Inicio do processamento - Data: " + dToC( date() ) + " / Hora: " + cElapTime, oSay )
GPlogMsg( "Identificando origem dos XMLs", oSay )

//Carrega CNPJs validos conforme SIGAMAT
aCNPJsVlds := loadCNPJs()

if ( len( aCNPJsVlds ) > 0 )

	//-------------------------------------------------------------------------------------
	// Esta dentro de while porque a função directory se limita a 10 mil arquivos por vez -
	// Vide: http://tdn.totvs.com/display/tec/Directory
	//-------------------------------------------------------------------------------------
	while ( len( aXMLs := directory( cDirOri + cFiltroXml ) ) > 0 )
	
		GPlogMsg( "Identificando bloco a ser processado...", oSay )
		
		nQtdArqs := len( aXMLs )
		
		if ( nQtdArqs > 0 )
			
			for nlx := 1 to nQtdArqs
			
				cNameArq := allTrim( aXMLs[nlx][1] )
				cArquivo := cDirOri + "\" + cNameArq
				
				GPlogMsg( "Processando arquivo [" + cArquivo + "] - " + allTrim( str( nlx ) ) + " de " + allTrim( str( nQtdArqs ) ), oSay )
				
				// Identifica a Evento
				cEvento := getEvento( cArquivo, @cXmlFit )
				
				if ( !empty( cEvento ) )
					
					// Identifica o CNPJ
					cCNPJ := getCNPJ( cXmlFit )
					
					// Cria diretorio referente ao CNPJ
					if ( !empty( cCNPJ) .and. criaDir( cDirRaiz, cCNPJ ) )
					
						// Cria diretorio referente ao Evento
						clDirTo := cDirRaiz + "\" + cCNPJ + "\" + cEvento
						if ( criaDir( cDirRaiz+"\"+cCNPJ, cEvento ) )
							GPlogMsg( "Copiando para [" + clDirTo + "]", oSay )
							sendXML( cNameArq, cArquivo, clDirTo, oSay )
						else
							sendToFail( cNameArq, cArquivo, cDirRaiz, cCNPJ + "\" + cEvento )
						endif
						
					else
						sendToFail( cNameArq, cArquivo, cDirRaiz, cCNPJ )
					endif
					
				else
					sendToFail( cNameArq, cArquivo, cDirRaiz, "" )
				endif
					
			next nlx
			
		else
			GPlogMsg( "***FAIL*** Não foi identificado arquivos .XML no diretório [" + cDirOri + "]", oSay )
		endif
		
	endDo
	
else
	GPlogMsg( "***FAIL*** Não foi identificado CNPJs no SIGAMAT", oSay )
endif

GPlogMsg( "Fim do processamento - Data: " + dToC( date() ) + " / Hora: " + time(), oSay )
GPlogMsg( "Processamento durou: " + elapTime(cElapTime, time()), oSay )
GPlogMsg( "Foi processado: " + allTrim( str( nQtdRegs ) ) + " registros", oSay )

Return

/*/{Protheus.doc} loadCNPJs
Funcao auxiliar para carregar os CNPJs validos
@author DS2U (SDA)
@since 09/04/2019
@version 1.0
@return aCNPJs, Array de CNPJs da do sigamat

@type function
/*/
Static Function loadCNPJs()

Local aArea := getArea()
Local aAreaSM0
Local aCNPJs := {}

dbSelectArea( "SM0" )
aAreaSM0 := SM0->( getArea() )

SM0->( dbGoTop() )
while ( !SM0->( eof() ) )

	AADD( aCNPJs, { subs( SM0->M0_CGC, 1, 8 ), allTrim( SM0->M0_CGC ) } )

	SM0->( dbSkip() )
endDo

restArea( aAreaSM0 )
restArea( aArea )

Return aCNPJs

/*/{Protheus.doc} getEvento
Rotina de controle das etapas a serem processadas
@author DS2U (SDA)
@since 06/03/2019
@version 1.0
@return cEvento, Codigo do evento identificado
@param cArquivo, characters, Caminho inteiro + nome do arquivo
@param cXmlFit, characters, Bloco de XML do evento identificado
@type function
/*/
Static Function getEvento( cArquivo, cXmlFit )

Local cXML 
Local cEvento := ""

Default cXmlFit := ""

// Trata caracteres invalidos para XML identificados no debug após erros de execução
cXML := strtran(strtran(strtran( memoread( cArquivo ),"ï",""),"»",""),"¿","") 

if ( !empty( ( cXmlFit := chkTag( "evtTabEstab", cXML ) ) ) ) //Evento 1005
	
	cEvento := "1005"
	GPlogMsg( "***GETEVENTO*** Identificado o evento evtTabEstab.", nil )
	
elseif ( !empty( ( cXmlFit := chkTag( "evtTabRubrica", cXML ) ) ) ) //Evento 1010
	
	cEvento := "1010"
	GPlogMsg( "***GETEVENTO*** Identificado o evento evtTabRubrica.", nil )
	
elseif ( !empty( ( cXmlFit := chkTag( "evtTabLotacao", cXML ) ) ) ) //Evento 1020
	
	cEvento := "1020"
	GPlogMsg( "***GETEVENTO*** Identificado o evento evtTabLotacao.", nil )

elseif ( !empty( ( cXmlFit := chkTag( "evtTabCargo", cXML ) ) ) ) //Evento 1030
	
	cEvento := "1030"
	GPlogMsg( "***GETEVENTO*** Identificado o evento evtTabCargo.", nil )
		
elseif ( !empty( ( cXmlFit := chkTag( "evtTabHorTur", cXML ) ) ) ) //Evento 1050
	
	cEvento := "1050"
	GPlogMsg( "***GETEVENTO*** Identificado o evento evtTabHorTur.", nil )

elseif ( !empty( ( cXmlFit := chkTag( "evtAdmissao", cXML ) ) ) ) //Evento 2200
	
	cEvento := "2200"
	GPlogMsg( "***GETEVENTO*** Identificado o evento evtAdmissao.", nil )

elseif ( !empty( ( cXmlFit := chkTag( "evtTSVInicio", cXML ) ) ) ) //Evento 2300
	
	cEvento := "2300"
	GPlogMsg( "***GETEVENTO*** Identificado o evento evtTSVInicio.", nil )

elseif ( !empty( ( cXmlFit := chkTag( "retornoprocessamentoloteeventos", cXML ) ) ) ) //ANTES ESTAVA- retornoEnvioLoteEventos -//Evento retorno
	
	cEvento := "RETORNO"
	GPlogMsg( "***GETEVENTO*** Identificado o evento retornoEnvioLoteEventos.", nil )

else
	cXmlFit := ""
	cEvento := ""
	GPlogMsg( "***FAIL*** Nao foi possivel identificado nenhum evento esperado no XML [" + cArquivo + "].", nil )
endif

Return cEvento

/*/{Protheus.doc} getCNPJ
Identifica o CNPJ do evento
@author DS2U (SDA)
@since 09/04/2019
@version 1.0
@return cCNPJ, CNPJ
@param cXmlFit, characters, Bloco de XML referente ao evento
@type function
/*/
Static Function getCNPJ( cXmlFit )

Local cNrInsc := chkTag( "nrInsc", cXmlFit )
Local cCNPJ   := ""
Local nPos

if ( !empty( cNrInsc ) )
	
	// Identifica raiz CNPJ
	cCNPJ := strTran( strTran( strTran( strTran( strTran( upper( cNrInsc ), "<", "" ), "\", "" ), "/", "" ), ">", "" ), "NRINSC", "" )
	
	// Identifica se CNPJ existe no sigamat
	nPos := aScan( aCNPJsVlds, {|x| x[1] == subs( cCNPJ, 1, 8 ) } )
	
	if ( nPos > 0 )
		cCNPJ := aCNPJsVlds[nPos][2]
	else
		cCNPJ := ""
	endif
	
endif

if ( empty( cCNPJ ) )
	GPlogMsg( "***FAIL*** Não foi identificado CNPJ no xml [" + cXmlFit + "]", nil )
endif

Return cCNPJ

/*/{Protheus.doc} chkTag
Checa se a tag existe dentro do XML enviado por parametro
@author DS2U (SDA)
@since 09/04/2019
@version 1.0
@return cXmlFit, Trecho do XML conforme tag de busca
@param cTag, characters, Tag a ser consultada
@param cXML, characters, XML a ser procurado a tag
@type function
/*/
Static Function chkTag( cTag, cXML )

Local nTagDe  := 0
Local nTagAte := 0
Local cTagDe  := "<" + allTrim( upper( cTag ) )
Local cTagAte := "</" + allTrim( upper( cTag ) ) + ">"
Local cXmlFit := "" 

if ( ( nTagDe := at( cTagDe, upper( cXML ) ) ) > 0 .and. ( nTagAte := at( cTagAte, upper( cXML ) ) ) > 0 )
	cXmlFit := subs( cXML, nTagDe, ( nTagAte - nTagDe + len( cTagAte ) ) )
endif

Return cXmlFit 

/*/{Protheus.doc} sendToFail
Funcao criada para enviar o XML que houve algum tipo de falha para a pasta fails
@author sergi
@since 09/04/2019
@version 1.0
@param cNameArq, characters, Nome do arquivo
@param cArquivo, characters, Caminho inteiro + nome do arquivo
@param cDirRaiz, characters, Diretorio raiz
@param cDirDest, characters, Diretorio destino
@type function
/*/
Static Function sendToFail( cNameArq, cArquivo, cDirRaiz,  cDirDest )

	GPlogMsg( "***FAIL*** Nao foi possivel identificar o caminho destino do arquivo [" + cDirRaiz + "\"+ cArquivo + "].", nil )
	makeDir( cDirRaiz + "\fails" )
	sendXML( cNameArq, cArquivo, cDirRaiz + "\fails", nil )
	
Return

/*/{Protheus.doc} criaDir
Funcao de controle de criacao de diretorio
@author DS2U (SDA)
@since 09/04/2019
@version 1.0
@return lCreated, Retorna se .T. o diretorio foi criado
@param cDirRaiz, characters, Diretorio raiz
@param cDest, characters, Diretorio a ser criado
@type function
/*/
Static Function criaDir( cDirRaiz, cDest )

Local clDirTo  := cDirRaiz + "\" + cDest
Local lCreated := .T.

// Cria diretorio, caso nao exista
if !empty( clDirTo )

	makeDir( clDirTo )
	
	if !ExistDir( clDirTo )
		lCreated := .F.
		clDirTo := ""
	endif
	
endif

Return lCreated

/*/{Protheus.doc} getDest
Rotina para identificar para qual CNPJ do sigamat o XML esta se referenciando
@author DS2U (SDA)
@since 06/03/2019
@version 1.0
@return cDirDest, Nome do diretorio destino do XML
@param oXml, object, Objeto do XML origem parseado
@param cDirOri, characters, Diretorio origem
@type function
/*/
Static Function getDest( oXml, cDirOri )

Local cDirDest  := ""
//Local aArea
Local cRaizCNPJ  := getRaizCGC( oXml )
Local cDirRaiz   := "\" + separa(cDirOri, "\")[2]

if ( !Empty( cRaizCNPJ ) )

	//TODO 
	//@TEST
	cDirDest := cDirRaiz + "\" + allTrim( cRaizCNPJ )
	//@TEST

//	dbSelectArea( "SM0" )
//	aArea := getArea()
//	
//	SM0->( dbGoTop() )
//	
//	while ( !SM0->( eof() ) )
//	
//		if cRaizCNPJ == subs( SM0->M0_CGC, 1, len( cRaizCNPJ ) )
//		
//			cDirDest := cDirRaiz + "\" + allTrim( SM0->M0_CGC )
//			makeDir( cDirDest )
//		
//			if !ExistDir( cDirDest )
//				cDirDest := ""
//			endif
//
//			exit
//			
//		endif
//	
//		SM0->( dbSkip() )
//	endDo
//	
//	restArea( aArea )

endif

Return cDirDest

/*/{Protheus.doc} getRaizCGC
Funcao auxiliar para identificar o numero de incricao ou os 8 primeiros digitos do CNPJ, que é na mesma tag
@author DS2U (SDA)
@since 08/03/2019
@version 1.0
@return cRet, Tag de numero de inscricao vem com a raiz CNPJ - * Digitos
@param oXml, object, Objeto do XML parseado
@type function
/*/
Static Function getRaizCGC( oXml )

Local cRet      := ""
Local nlx
Local nly
Local aNodeRaiz := ClassDataArr(oXml:_ESOCIAL)
Local aNode     := {} 

for nlx := 1 to len( aNodeRaiz )

	if ( valType( aNodeRaiz[nlx][2] ) == "O" )

		aNode := ClassDataArr( aNodeRaiz[nlx][2]  )
	
		for nly := 1 to len( aNode )
		
			if ( aNode[nly][1] == "_IDEEMPREGADOR" )
				// Tag de numero de inscricao vem com a raiz CNPJ - * Digitos
				cRet := aNode[nly][2]:_NRINSC:TEXT
				exit
			endif
			
		next nly
		
		if !Empty( cRet )
			exit
		endif
		
	else
		exit
	endif

next nlx

Return cRet

/*/{Protheus.doc} sendXML
Rotina para realizar a copia da origem para o destino
@author DS2U (SDA)
@since 06/03/2019
@version 1.0
@param cNameArq, characters, Nome do arquivo origem a ser copiado
@param cArqFull, characters, Diretorio + Nome do arquivo origem a ser copiado
@param clDirTo, characters, Diretorio destino a ser copiado o arquivo origem
@param oSay, object, Objeto para interagir com a interface da aplicação mandando mensagem para o usuário 
@type function
/*/
Static Function sendXML( cNameArq, cArqFull, clDirTo, oSay )

if __CopyFile( cArqFull, clDirTo + "\" + cNameArq)
	fErase( cArqFull )
else
	GPlogMsg( "***FAIL*** Arquivo: " + cArqFull + " não pôde ser copiado para o diretório: " + clDirTo, oSay )
endif

Return

/*/{Protheus.doc} GPlogMsg
Controle de log de processamento
@author DS2U (SDA)
@since 06/03/2019
@version 1.0
@param cMsgLog, characters, Mensagem do log do processamento
@param oSay, object, Objeto para interagir com a interface da aplicação mandando mensagem para o usuário
@type function
/*/
Static Function GPlogMsg( cMsgLog, oSay )

	conOut( cMsgLog )
	
//	if ( valType( oSay ) == "O" )
//		oSay:setText( cMsgLog )
//	endif
	
Return