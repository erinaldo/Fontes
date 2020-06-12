#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'APWEBSRV.CH' 
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA26()

WS Client para inclusao de contrato no RM TOP 
Chamada pela rotina ASCOMA25

@param		cFILPROJ	= 	Coligada no RM TOP
			cOperacao	=	Qual opera��o ser� executada:
								PrjContratoData
			cIDPRJ		=	Identificador do contrato
			cXMLSend	=	XML com a mensagem de envio 
			cRETSend	=	Passada como refer�ncia, retorna mensagem 
							para a fun��o de chamada
@return		L�gico	.T. = Sucesso na execu��o do WS, .F. = Falha
@author 	Fabio Cazarini
@since 		28/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA26(cFILPROJ, cOperacao, cIDPRJ, cXMLSend, cRETSend)
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
	LOCAL cParseURL	:= SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051") + "/wsDataServer/MEX?wsdl" 
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
			cRETSend 	:=  "Erro ao executar o ParseURL no endere�o (" + cParseURL + "): " + oWsdl:cError 
			lRet 		:= .F.
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Autenticacao
	//-----------------------------------------------------------------------
	IF lRet
		xRet := oWsdl:SetAuthentication( cUserTOP, cPassTOP )
		IF !xRet
			cRETSend 	:= "N�o foi poss�vel autenticar o usu�rio (" + cUserTOP + ") no servi�o RM TOP: " + oWsdl:cError 
			lRet 		:= .F.
		ENDIF
	ENDIF
	//-----------------------------------------------------------------------
	// Define a opera��o
	//-----------------------------------------------------------------------
	IF lRet
		xRet := oWsdl:SetOperation( "SaveRecord" )

		//-----------------------------------------------------------------------
		// Define os parametros
		//-----------------------------------------------------------------------
		aSimple := oWsdl:SimpleInput()

		FOR nX := 1 TO LEN(aSimple)
			nID		:= aSimple[nX][1]
			cNome	:= aSimple[nX][2]

			IF UPPER(ALLTRIM(cNome)) == "DATASERVERNAME"
				oWsdl:SetValue( nID, cOperacao )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "XML"
				oWsdl:SetValue( nID, cXMLSend )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "CONTEXTO"
				oWsdl:SetValue( nID, "CODSISTEMA=M,CODUSUARIO=" + cUserTOP + ",CODCOLIGADA=" + cFILPROJ + ",IDPRJ=" + cIDPRJ  )
			ENDIF
		NEXT nX

		//-----------------------------------------------------------------------
		// Pega a mensagem SOAP que ser� enviada ao servidor
		//-----------------------------------------------------------------------
		cMsg := oWsdl:GetSoapMsg()

		//-----------------------------------------------------------------------
		// Envia uma mensagem SOAP personalizada ao servidor
		//-----------------------------------------------------------------------
		xRet := oWsdl:SendSoapMsg(cMsg)
		IF !xRet
			cRETSend	:= "N�o foi poss�vel enviar a mensagem ao servi�o RM TOP: " + oWsdl:cError
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
			cResult 	:= oResult:_S_ENVELOPE:_S_BODY:_SAVERECORDRESPONSE:_SAVERECORDRESULT:TEXT
			cRETSend	:= ALLTRIM(cResult)
			aRETSend 	:= StrTokArr2(cRETSend, ";", .T.)
			IF LEN(aRETSend) == 3 .AND. !EMPTY(aRETSend[3]) 
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