#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//--------------------------------------------------------------------------------------------
/*{Protheus.doc} ASFINA77
Consulta informa��es complementares da venda para serem gravadas do Protheus

@param		cVenda
@return		cRet -> Dados Complementares
@author 	Fabiano Albuquerque
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//--------------------------------------------------------------------------------------------
USER FUNCTION ASFINA77(cVenda,cName)
LOCAL cParseURL	:= ALLTRIM(SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051")) + "/wsConsultaSQL/MEX?wsdl"
LOCAL cUser		:= SuperGetMv("AS_RMUWS",.T.,"mestre")
LOCAL cPass		:= SuperGetMv("AS_RMPWS",.T.,"totvs")
LOCAL oWsdl
LOCAL xRet		:= .F.
LOCAL lRet		:= .T.
LOCAL cRETSend	:= ""
LOCAL aSimple	:= {}
LOCAL nX		:= 0
LOCAL cErro		:= ""
LOCAL cAviso	:= ""
LOCAL aResult   := {}
LOCAL cResult   := ""

//-----------------------------------------------------------------------
// Cria o objeto da classe TWsdlManager
//-----------------------------------------------------------------------
oWsdl := TWsdlManager():New()

//-----------------------------------------------------------------------
// Faz o parse de uma URL
//-----------------------------------------------------------------------
xRet := oWsdl:ParseURL( cParseURL )
IF xRet == .F.
	cRETSend 	:=  "Erro ao executar o ParseURL no endere�o (" + cParseURL + "): " + oWsdl:cError
	lRet 		:= .F.
ENDIF

//-----------------------------------------------------------------------
// Autenticacao
//-----------------------------------------------------------------------
IF lRet
	xRet := oWsdl:SetAuthentication( cUser, cPass )
	IF !xRet
		cRETSend 	:= "N�o foi poss�vel autenticar o usu�rio (" + cUser + ") no servi�o RM: " + oWsdl:cError
		lRet 		:= .F.
	ENDIF
ENDIF
//-----------------------------------------------------------------------
// Define a opera��o
//-----------------------------------------------------------------------
IF lRet
	xRet := oWsdl:SetOperation( "RealizarConsultaSQL" )
	IF !xRet
		cRETSend 	:= "N�o foi poss�vel definir a opera��o: " + oWsdl:cError
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
			oWsdl:SetValue( nID, cName )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
			oWsdl:SetValue( nID, "0" )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
			oWsdl:SetValue( nID, "X"  ) // TOP = M, TIN = X
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
			oWsdl:SetValue( nID, "CVENDA=" + cVenda )
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
		cRETSend	:= "N�o foi poss�vel enviar a mensagem ao servi�o RM: " + oWsdl:cError
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
	
	
	IF "<CODEMPR>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_CODEMPR:TEXT
			aAdd(aResult, {"Z9_EMPR", cResult})
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Aten��o" )
		ENDIF
	ENDIF

	IF "<NUMVENDA>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_NUMVENDA:TEXT
			aAdd(aResult, {"Z9_NUNVEND" , cResult})
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Aten��o" )
		ENDIF
	ENDIF
	
	IF "<DTVENDA>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_DTVENDA:TEXT
			aAdd(aResult, {"Z9_DTVENDA" , cResult})
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Aten��o" )
		ENDIF
	ENDIF
	
	IF "<DATAENTREGACHAVE>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_DATAENTREGACHAVE:TEXT
			aAdd(aResult, {"Z9_DTCHAVE", cResult})
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Aten��o" )
		ENDIF
	ENDIF	

	IF "<XPARCFIN>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_XPARCFIN:TEXT
			aAdd(aResult,{"Z9_TIPOVEN",cResult})
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Aten��o" )
		ENDIF
	ENDIF

	IF "<TXFINANCIAMENTO>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_TXFINANCIAMENTO:TEXT
			aAdd(aResult,{"Z9_TXFIN",cResult})
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Aten��o" )
		ENDIF
	ENDIF
	
	IF "<DTREAJUSTE>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_DTREAJUSTE:TEXT
			aAdd(aResult,{"Z9_DTREAJU",cResult})
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Aten��o" )
		ENDIF
	ENDIF
	
ELSE
	IF !EMPTY(cRETSend)
		ApMsgAlert( cRETSend, "Aten��o" )
	ENDIF
ENDIF

RETURN aResult