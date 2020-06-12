#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'APWEBSRV.CH' 
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA35()

WS Client para retornar o ID do projeto no RM, via WS 
RealizarConsultaSQL

Chamada pela rotina ASCOMA35

Exemplo: U_ASCOMA35( '1', '0000' )

@param		cCODCOLIGADA = 	Coligada no RM TOP
			cCODPRJ = Projeto no RM
@return		cRET = ID do projeto no RM
@author 	Fabio Cazarini
@since 		30/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA35( cCODCOLIGADA, cCODPRJ )
	LOCAL cRET 		:= ""
	LOCAL oWsdl
	LOCAL oResult	
	LOCAL cResult	:= ""
	LOCAL xRet
	LOCAL lRet		:= .T.
	LOCAL cMsg		:= ""
	LOCAL cErro    	:= ""
	LOCAL cAviso   	:= ""
	LOCAL aSimple	:= {}
	LOCAL nX		:= 0
	LOCAL cParseURL	:= SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051") + "/wsConsultaSQL/MEX?wsdl" 
	LOCAL cUserTOP	:= SuperGetMv("AS_RMUWS",.T.,"mestre") 
	LOCAL cPassTOP	:= SuperGetMv("AS_RMPWS",.T.,"totvs")
	
	//-----------------------------------------------------------------------
	// Cria o objeto da classe TWsdlManager
	//-----------------------------------------------------------------------
	oWsdl := TWsdlManager():New()
	//oWsdl:lVerbose := .T.

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
		aSimple := oWsdl:SimpleInput()

		FOR nX := 1 TO LEN(aSimple)
			nID		:= aSimple[nX][1]
			cNome	:= aSimple[nX][2]
			IF UPPER(ALLTRIM(cNome)) == "CODSENTENCA"
				oWsdl:SetValue( nID, "AS002" )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
				oWsdl:SetValue( nID, "0" )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
				oWsdl:SetValue( nID, "M"  )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
				oWsdl:SetValue( nID, "CODCOLIGADA=" + cCODCOLIGADA + ";CODPRJ=" + cCODPRJ )
			ENDIF
		NEXT nX

		//-----------------------------------------------------------------------
		// Pega a mensagem SOAP que será enviada ao servidor
		//-----------------------------------------------------------------------
		cMsg := oWsdl:GetSoapMsg()

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
		
		IF "<IDPRJ>" $ cXML 
			oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
			IF EMPTY(cErro)
				cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_IDPRJ:TEXT
				cRET	:= ALLTRIM(cResult)
			ELSE
				cRETSend 	:= ALLTRIM(cErro)
				
				MSGALERT( cRETSend, "Atenção" )	
			ENDIF
		ENDIF
	ELSE
		IF !EMPTY(cRETSend)
			MSGALERT( cRETSend, "Atenção" )
		ENDIF
	ENDIF

RETURN cRET