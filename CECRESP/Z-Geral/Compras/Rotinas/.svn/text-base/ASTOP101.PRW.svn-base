#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*{Protheus.doc} ASTOP101 
Grava os campos de Deducao da SC7
Chamado pelo PE - MT140TOK

@param		Nenhum
@return		Nenhum 
@author 	Zema
@since 		17/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASTOP101()
	Local lRet			:= .T.
	Local nX			:= 0
	Local nVlrRet		:= 0	
	Local nVlrDed		:= 0
	Local cQuery		:= ""
	Local cExtVal		:= ""
	Local cAliasXXF		:= GetNextAlias()
	Local cNumSC7		:= ""  
	Local cIntVal		:= ""    
	Local aArea			:= GetArea()
	Local nPosPed	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})

	// Pega o numero do pedido
	cNumSC7 := aCols[1][nPosPed]
	cIntVal	:= cEmpAnt + "|" + cFilAnt + "|" + cNumSC7 + "|" + "1"	

	// Localiza integração com o TOP	
	cQuery := " SELECT XXF_EXTVAL FROM XXF "
	cQuery += " WHERE "
	cQuery += " XXF_TABLE = '" + RetSqlName("SC7") + "' AND "
	cQuery += " XXF_ALIAS = 'SC7' AND "
	cQuery += " XXF_FIELD = 'C7_NUM' AND "
	cQuery += " XXF_INTVAL LIKE '%" + cIntVal + "%'
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasXXF, .F., .T.)
		
	If (cAliasXXF)->(!EOF())
		cExtVal := Alltrim((cAliasXXF)->XXF_EXTVAL)
	Endif
		
	(cAliasXXF)->(DbCloseArea())

    IF !EMPTY(cExtVal)        
    	
    	nVlrRet := ValDed(cExtVal,"ASTOP01R") // Obtem o valor da retenção
    	nVlrDed := ValDed(cExtVal,"ASTOP01") // Obtem o valor da dedução

    	SC7->(DBSETORDER(1))
    	IF SC7->(DBSEEK(XFILIAL("SC7")+cNumSC7))
    		WHILE SC7->C7_FILIAL == XFILIAL("SC7") .AND. SC7->C7_NUM == cNumSC7 .AND. SC7->(!EOF())
    			RECLOCK("SC7",.F.)
    			SC7->C7_XRETRM := nVlrRet 
    			SC7->C7_XDEDRM := nVlrDed
    			MsUnlock()
    			SC7->(DBSKIP()) 
    		END	
    		SC7->(DBGOTOP())
    		SC7->(DBSEEK(XFILIAL("SC7")+cNumSC7))
    	ENDIF
			
	EndIf
	
	RestArea(aArea)
Return
/*{Protheus.doc} ValDed 
Localiza a dedução no RM - TOP

@param		cExtVal - Chave que identifica o registro no RM
@return		Nenhum 
@author 	Zema
@since 		17/092/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
Static Function ValDed(cExtVal,cName)   
	LOCAL cParseURL	:= ALLTRIM(SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051")) + "/wsConsultaSQL/MEX?wsdl" 
	LOCAL cUserTOP	:= SuperGetMv("AS_RMUWS",.T.,"mestre") 
	LOCAL cPassTOP	:= SuperGetMv("AS_RMPWS",.T.,"totvs")
	LOCAL oWsdl
	LOCAL xRet		:= .F.
	LOCAL lRet		:= .T.
	LOCAL cRETSend	:= ""                   
	LOCAL aSimple	:= {}	
    LOCAL nX		:= 0
    LOCAL cErro		:= ""
    LOCAL cAviso	:= ""
    LOCAL nRet      := 0
	//-----------------------------------------------------------------------
	// Cria o objeto da classe TWsdlManager
	//-----------------------------------------------------------------------
	oWsdl := TWsdlManager():New()

	//-----------------------------------------------------------------------
	// Faz o parse de uma URL
	//-----------------------------------------------------------------------
	xRet := oWsdl:ParseURL( cParseURL )
	IF xRet == .F.
		cRETSend 	:=  "Erro ao executar o ParseURL no endereço (" + cParseURL + "): " + oWsdl:cError 
		lRet 		:= .F.
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
				oWsdl:SetValue( nID, cName )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
				oWsdl:SetValue( nID, "0" )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
				oWsdl:SetValue( nID, "M"  )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
				oWsdl:SetValue( nID, "CEXTVAL=" + cExtVal )
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

	
		IF "<DEDUCAO>" $ cXML 
			oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
			IF EMPTY(cErro)
				cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_DEDUCAO:TEXT
				nRET	:= VAL(cResult)
			ELSE
				cRETSend 	:= ALLTRIM(cErro)
				
				ApMsgAlert( cRETSend, "Atenção" )	
			ENDIF
		ENDIF
		
		IF "<RETENCAO>" $ cXML 
			oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
			IF EMPTY(cErro)
				cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_RETENCAO:TEXT
				nRET	:= VAL(cResult)
			ELSE
				cRETSend 	:= ALLTRIM(cErro)
				
				ApMsgAlert( cRETSend, "Atenção" )	
			ENDIF
		ENDIF		
		
	ELSE
		IF !EMPTY(cRETSend)
			ApMsgAlert( cRETSend, "Atenção" )
		ENDIF
	ENDIF

RETURN nRET
		