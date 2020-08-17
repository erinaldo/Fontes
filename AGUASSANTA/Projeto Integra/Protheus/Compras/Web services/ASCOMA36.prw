#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'APWEBSRV.CH' 
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA36()

WS Client para inclusao dos itens no contrato no RM TOP 
Chamada pela rotina ASCOMA25

@param		cFILPROJ	= 	Coligada no RM TOP
			cOperacao	=	Qual operação será executada:
								PrjContratoAssociarItemProc
			cIDPRJ		=	Identificador do contrato
			cXMLSend	=	XML com a mensagem de envio 
			cRETSend	=	Passada como referência, retorna mensagem 
							para a função de chamada
@return		Lógico	.T. = Sucesso na execução do WS, .F. = Falha
@author 	Fabio Cazarini
@since 		30/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA36(cFILPROJ, cOperacao, cIDPRJ, cXMLSend, cRETSend)
	LOCAL lRet		:= .T.
	LOCAL oWsdl
	LOCAL oResult	
	LOCAL cResult	:= ""
	LOCAL xRet
	LOCAL cMsg		:= ""
	LOCAL cErro    	:= ""
	LOCAL cAviso   	:= ""
	LOCAL aSimple	:= {}
	LOCAL nX		:= 0
	LOCAL cParseURL	:= SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051") + "/wsProcess/MEX?wsdl" 
	LOCAL cUserTOP	:= SuperGetMv("AS_RMUWS",.T.,"mestre") 
	LOCAL cPassTOP	:= SuperGetMv("AS_RMPWS",.T.,"totvs")

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
		xRet := oWsdl:SetOperation( "ExecuteWithParams" )

		//-----------------------------------------------------------------------
		// Define os parametros
		//-----------------------------------------------------------------------
		aSimple := oWsdl:SimpleInput()

		FOR nX := 1 TO LEN(aSimple)
			nID		:= aSimple[nX][1]
			cNome	:= aSimple[nX][2]

			IF UPPER(ALLTRIM(cNome)) == "PROCESSSERVERNAME"
				oWsdl:SetValue( nID, cOperacao )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "STRXMLPARAMS"
				oWsdl:SetValue( nID, cXMLSend )
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

		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult 	:= oResult:_S_ENVELOPE:_S_BODY:_EXECUTEWITHPARAMSRESPONSE:_EXECUTEWITHPARAMSRESULT:TEXT
			cRETSend	:= ALLTRIM(cResult)
			IF cRETSend == "1" 
				lRet 		:=  .T.
			ELSE
				lRet 		:=  .F.			
			ENDIF	
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			lRet 		:=  .F.	
		ENDIF
	ENDIF

RETURN lRet