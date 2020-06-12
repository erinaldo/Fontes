#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'APWEBSRV.CH' 
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA46()

WS Client para retornar o valor da participação do parceiro no 
empreendimento, via WS
 
RealizarConsultaSQL

Chamada pela rotina F055IT

Exemplo: U_ASFINA46( cEmpPar, cFilPar, cPrefixo, cNum, cParcel, cTpParcel, cCODCOLIGA, cIDLAN )

@param		cEmpPar = Grupo de empresa
			cFilPar = Filial
			cPrefixo = Prefixo do título
			cNum = Número do título
			Parcel = Parcela
			cTpParcel = Tipo
			cCODCOLIGA = Código da coligada no RM
			cIDLAN = ID do lançamento no RM
@return		nRET = Valor da participaçao do parceiro
@author 	Fabio Cazarini
@since 		02/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA46( cEmpPar, cFilPar, cPrefixo, cNum, cParcel, cTpParcel, cCODCOLIGA, cIDLAN )

	LOCAL nRET 			:= 0
	LOCAL oWsdl
	LOCAL oResult	
	LOCAL cResult		:= ""
	LOCAL xRet
	LOCAL lRet			:= .T.
	LOCAL cMsg			:= ""
	LOCAL cErro    		:= ""
	LOCAL cAviso   		:= ""
	LOCAL aSimple		:= {}
	LOCAL nX			:= 0
	LOCAL cParseURL		:= SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051") + "/wsConsultaSQL/MEX?wsdl" 
	LOCAL cUserTOP		:= SuperGetMv("AS_RMUWS",.T.,"mestre") 
	LOCAL cPassTOP		:= SuperGetMv("AS_RMPWS",.T.,"totvs")
	LOCAL cChvProthe	:= "" 
	
	cChvProthe	:= ALLTRIM(cEmpPar)	+ "|" 
	cChvProthe	+= ALLTRIM(cFilPar)	+ "|"
	cChvProthe	+= ALLTRIM(cPrefixo)+ "|"
	cChvProthe	+= ALLTRIM(cNum)	+ "|"
	cChvProthe	+= ALLTRIM(cParcel)	+ "|"
	cChvProthe	+= ALLTRIM(cTpParcel)
	
	//-----------------------------------------------------------------------
	// Cria o objeto da classe TWsdlManager
	//-----------------------------------------------------------------------
	oWsdl := TWsdlManager():New()

	//-----------------------------------------------------------------------
	// Faz o parse de uma URL
	//-----------------------------------------------------------------------
	IF lRet
		xRet := oWsdl:ParseURL( cParseURL )
		IF xRet == .F.
			cRETSend 	:=  "Erro ao executar o ParseURL no endereço (" + cParseURL + "): " + oWsdl:cError 
			lRet 		:= .F.
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Autenticacao
	//-----------------------------------------------------------------------
	IF lRet
		xRet := oWsdl:SetAuthentication( cUserTOP, cPassTOP )
		IF !xRet
			cRETSend 	:= "Não foi possível autenticar o usuário (" + cUserTOP + ") no serviço RM TOP: " + oWsdl:cError 
			lRet 		:= .F.
		ENDIF
	ENDIF
	//-----------------------------------------------------------------------
	// Define a operação
	//-----------------------------------------------------------------------
	IF lRet
		xRet := oWsdl:SetOperation( "RealizarConsultaSQL" )
		IF !xRet
			cRETSend 	:= "Não foi possível definir a operação: " + oWsdl:cError 
			lRet 		:= .F.
		ENDIF		
	ENDIF
	
	//-----------------------------------------------------------------------
	// Define os parametros
	//-----------------------------------------------------------------------
	IF lRet
		//-----------------------------------------------------------------------
		// Pega a mensagem SOAP que será enviada ao servidor
		//-----------------------------------------------------------------------
		cMsg := "<?xml version='1.0' encoding='UTF-8' standalone='no' ?>"
		cMsg += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://www.totvs.com/">'
		cMsg += '<SOAP-ENV:Body>'
		cMsg += 	'<RealizarConsultaSQL xmlns="http://www.totvs.com/">'
		IF EMPTY(cIDLAN)
			cMsg += 		'<codSentenca xmlns="http://www.totvs.com/">ASTIN002</codSentenca>'
			cMsg += 		'<codColigada xmlns="http://www.totvs.com/">0</codColigada>'
			cMsg += 		'<codSistema xmlns="http://www.totvs.com/">X</codSistema>'
			cMsg += 		'<parameters xmlns="http://www.totvs.com/">IDINTEGRACAO=' + ALLTRIM(cChvProthe) + '</parameters>'
		ELSE
			cMsg += 		'<codSentenca xmlns="http://www.totvs.com/">ASTIN003</codSentenca>'
			cMsg += 		'<codColigada xmlns="http://www.totvs.com/">0</codColigada>'
			cMsg += 		'<codSistema xmlns="http://www.totvs.com/">X</codSistema>'
			cMsg += 		'<parameters xmlns="http://www.totvs.com/">CODCOLIGADA=' + ALLTRIM(cCODCOLIGA) + ';IDLAN=' + ALLTRIM(cIDLAN) + '</parameters>'
		ENDIF
		cMsg += 	'</RealizarConsultaSQL>'
		cMsg += '</SOAP-ENV:Body>'
		cMsg += '</SOAP-ENV:Envelope>'
		
		//-----------------------------------------------------------------------
		// Envia uma mensagem SOAP personalizada ao servidor
		//-----------------------------------------------------------------------
		xRet := oWsdl:SendSoapMsg(cMsg)
		IF !xRet
			cRETSend	:= "Não foi possível enviar a mensagem ao serviço RM TOP: " + oWsdl:cError
			lRet 		:= .F.
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Pega a mensagem de resposta
	//-----------------------------------------------------------------------
	IF lRet
		cXML := oWsdl:GetSoapResponse()
		cXML := STRTRAN(cXML, "&lt;", "<")
		cXML := STRTRAN(cXML, "&gt;", ">")
		cXML := STRTRAN(cXML, "&#xD;", "")
		
		IF "<PERCENTUAL>" $ cXML 
			oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
			IF EMPTY(cErro)
				cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_PERCENTUAL:TEXT				
				nRET	:= VAL(ALLTRIM(cResult))
			ELSE
				CONOUT("Integracao com o TIN (ASFINA46): " + ALLTRIM(cErro))
			ENDIF
		ENDIF
	ELSE
		IF !EMPTY(cRETSend)
			CONOUT("Integracao com o TIN (ASFINA46): " + cRETSend)
		ENDIF
	ENDIF
	
RETURN nRET