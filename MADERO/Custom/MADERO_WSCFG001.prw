#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"

/*/{Protheus.doc} GetAcesso
//TODO Declaração do WebService GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
/*/
WSRESTFUL GetAcesso DESCRIPTION "Madero - Acesso de Usuários"
	
	WSDATA cdempresa AS STRING
	WSDATA cdfilial  AS STRING
	WSDATA cdmodulo  AS INTEGER
	WSDATA cdusuario AS STRING
	WSDATA rotina    AS STRING

	WSMETHOD GET DESCRIPTION "Acesso de Usuários" WSSYNTAX "/GetAcesso || /GetAcesso/{id}"

End WSRESTFUL

/*/{Protheus.doc} GET
//TODO Declaração do Metodo GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
/*/
WSMETHOD GET WSRECEIVE cdempresa, cdfilial, cdmodulo, cdusuario, rotina  WSSERVICE GetAcesso
Local cXml	:= ""
Local cAux	:= ""

	::SetContentType("application/xml")
	
	If !Empty(Self:cdempresa) .And. !Empty(Self:cdfilial) .And. Self:cdmodulo != 0 .And. !Empty(Self:cdusuario) .And. !Empty(Self:rotina) 
		// -> Posiciona na unidade de negócio
		DbSelectArea("ADK")
		ADK->(DbOrderNickname("ADKXFIL"))		
		If ADK->(DbSeek(xFilial("ADK")+Self:cdempresa+Self:cdfilial))
			// -> Posiciona na empresa
			SM0->(DbSetOrder(1))
			If SM0->(DbSeek("02"+ADK->ADK_XFILI))
				cEmpAnt  :=SM0->M0_CODIGO
				cFilAnt  :=SM0->M0_CODFIL
				dDataBase:=Date()
					cXml := WSCFG001(Self:cdempresa, Self:cdfilial, Self:cdmodulo, Self:cdusuario, Upper(Self:rotina))
			Else
				cAux:="Empresa nao cadastrada no ERP. [ADK_XFILI="+ADK->ADK_XFILI+"]"			
			EndIf
		Else
			cAux:="Empresa nao cadastrada no ERP. [ADK_XEMP="+Self:cdempresa+" e ADK_XFIL="+Self:cdfilial+"]"
		EndIf	
	Else
		If Empty(Self:cdempresa)
			cAux := "Parametros incorretos. 'cdempresa' é um parametro obrigatorio."
		ElseIf Empty(Self:cdfilial)
			cAux := "Parametros incorretos. 'cdfilial' é um parametro obrigatorio."
		ElseIf Empty(Self:cdmodulo)
			cAux := "Parametros incorretos. 'cdmodulo' é um parametro obrigatorio."
		ElseIf Self:cmodulo == 0
			cAux := "Parametros incorretos. 'cdmodulo' nao pode ser 0."
		ElseIf Empty(Self:cdusuario)
			cAux := "Parametros incorretos. 'cdusuario' é um parametro obrigatorio."
		ElseIf Empty(Self:rotina)
			cAux := "Parametros incorretos. 'rotina' é um parametro obrigatorio."
		EndIf
	Endif
	
	If !Empty(cAux)
		cXML := '<confirmacao integrado="false" mensagem="' + cAux + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
	EndIf

	::SetResponse(cXML)

Return .T.

/*/{Protheus.doc} ProtheusGetAcesso
//TODO declaração das classe para gerar o XML
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Class ProtheusGetAcesso From ProtheusMethodAbstract

	Method new(cMethod) constructor
	Method makeXml(aDadUsr)

EndClass

/*/{Protheus.doc} New
//TODO Metodo Inicializados da Classe ProtheusGetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
@param cMethod, characters, descricao
/*/
Method New(cMethod) Class ProtheusGetAcesso
	::cMethod := cMethod
Return

/*/{Protheus.doc} makeXml
//TODO Metodo para gerar XML do Ws GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param aDadUsr, array, Dados os usuário
/*/
Method makeXml(aDadUsr) Class ProtheusGetAcesso

	Local cXml		:= ""
	Local cAcesso	:= ""
	
	If ValType(aDadUsr[07]) == "A"
		cAcesso := If(aDadUsr[07,03],"S","N")
	Else
		cAcesso := aDadUsr[07]
	EndIf

	cXml := '<?xml version="1.0" encoding="ISO-8859-1"?>'
	
	cXml += '<retorno>'

	cXml += '<acesso>'
	
	cXml += '<empresa'
	cXml += ::tag('cdempresa'		,ADK->ADK_XEMP)		
	cXml += ::tag('cdfilial'		,ADK->ADK_XFIL)	
	cXml += ::tag('nmfilial'		,ADK->ADK_NOME)		
	cXml += '/>'
	
	cXml += '<operador'
	cXml += ::tag('cdvendedor'		,SA3->A3_COD)	
	cXml += ::tag('nmvendedor'		,SA3->A3_NOME)		
	cXml += '/>'

	cXml += '<usuario'	 
	cXml += ::tag('usrativo'		,If(aDadUsr[01],"S","N"))	
	cXml += ::tag('usrlogin'		,aDadUsr[02])		
	cXml += ::tag('idusuario'		,aDadUsr[03])
	cXml += ::tag('nmusuario'		,aDadUsr[04])		
	cXml += ::tag('emailusuario'	,aDadUsr[05])		
	cXml += ::tag('ndiasacesso'		,aDadUsr[06]	,"INTEGER")	
	cXml += ::tag('acessorotina'	,cAcesso)
	
	cXml += '/>'

	cXml += '</acesso>'	
	
	cXml += '<confirmacao>'
	
	cXml += '<confirmacao'
	cXml += ::tag('integrado'		,"true")			
	cXml += ::tag('mensagem'		,"Processamento ok.")
	cXml += ::tag('data'			,DtoS(Date()))		
	cXml += ::tag('hora'			,Time())	
	cXml += '/>'
	
	cXml += '</confirmacao>'

	cXml += '</retorno>'	

Return cXml

/*/{Protheus.doc} WSCFG001
//TODO Função para executar WS GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param cCodEmp, characters, Código da Empresa
@param cCodFil, characters, Código da Filial
@param nCodMod, Numerico, Modulo Protheus
@param cNomeUsr, characters, Usuário
@param cRotina, characters, Nome da Rotina
/*/
Static Function WSCFG001(cCodEmp, cCodFil, nCodMod, cNomeUsr, cRotina, oEventLog)
	
	Local cAux		:= ""
	Local cXml		:= ""
	Local lCont		:= .F.
	Local lEmp		:= .T.
	Local nRegZ15	:= 0
	Local nRegSA3	:= 0
	Local oTag		:= Nil
	Local aDadUsr	:={}
	
	Local cMetEnv	:= "Get"
	Local cMethod	:= "GetAcesso"
	Local oEventLog := Nil
	
	lEmp := VerEmp(cCodEmp, cCodFil)
	
	oEventLog := EventLog():start(cMethod + "-" + cMetEnv,Date(), "Iniciando processo de integracao: ", cMetEnv, "")
	
	If !lEmp
		cAux := "Empresa / Filial nao encontrados no ERP. [ADK_FILIAL + ADK_XEMP + ADK_XFIL = " + xFilial("ADK") + cCodEmp + cCodFil + "]"
		oEventLog:broken(cAux, "", .T.)
		oEventLog:setInfo(cError, cInfo)
	Else 
		lCont := .T.
	EndIf
	
	If lCont 
	
		lCont := .F.
		//Busca acessos
		aDadUsr := U_xGetAces(cCodEmp, cCodFil, nCodMod, cNomeUsr, cRotina, oEventLog)
		
		If Len(aDadUsr) > 1
		
			If Len(aDadUsr) == 0	
				cAux := "Usuario nao cadastrado no Protheus. [USR_NOME = "+ cNomeUsr + "]"	
				oEventLog:broken(cAux, "", .T.)			
				
			//Valida Cadastros
			ElseIf !VerResp(@nRegZ15)
				cAux := "Nao existe registro do responsável pela unidade de negocio integrado com o Teknisa. [Z15_COD=" +ADK->ADK_RESP+"]"
				oEventLog:broken(cAux, "", .T.)
			ElseIf !VerVend(@nRegSA3)
				cAux := "Responsavel pela unidade nao encontrado no Protheus. [A3_COD="+ADK_RESP+"]"
				oEventLog:broken(cAux, "", .T.)	
			Else
				lCont := .T.
			EndIf
			
		Else
			cAux := aDadUsr[01]
			oEventLog:broken(cAux, "", .T.)
		EndIf
		
	EndIf
				
	If lCont
		oTag := ProtheusGetAcesso():New("Tag")
		cXml := oTag:MakeXml(aDadUsr)
		cAux := aDadUsr[01]
		oEventLog:setInfo("Ok.", "")
	Else	
		cXml := '<confirmacao integrado="' + If(lCont,"true","false") + '" mensagem="' + cAux + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
		oEventLog:broken("--> Erro na consulta dos usuários.", "", .T.)
	EndIf
	
	oEventLog:Finish()

Return cXml

/*/{Protheus.doc} VerEmp
//TODO Função para validar e posicionar na Empresa/Filial informada
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return lRet. Lógico, .T. OU .F.
@param cCodEmp, characters, Código da Empresa
@param cCodFil, characters, Código da Filial
/*/
Static Function VerEmp(cCodEmp, cCodFil)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlEmp	:= ""

	cQuery := "	SELECT R_E_C_N_O_ REGNO_ADK 					" + CRLF
	cQuery += "	FROM " + RetSqlName("ADK") + " ADK 				" + CRLF
	cQuery += "	WHERE 											" + CRLF
	cQuery += "			ADK_FILIAL = '" + xFilial("ADK") + "' 	" + CRLF
	cQuery += "		AND ADK_XEMP = '" + cCodEmp + "' 			" + CRLF
	cQuery += "		AND ADK_XFIL = '" + cCodFil + "' 			" + CRLF
	cQuery += "		AND ADK_XFILI != ' ' 						" + CRLF
	cQuery += "		AND ADK_MSBLQL = '2' 						" + CRLF	
	cQuery += "		AND ADK.D_E_L_E_T_ = ' ' 					" + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlEmp := MPSysOpenQuery(cQuery)
	
	If (cAlEmp)->(Eof())
		lRet := .F.
	Else

		dbSelectArea("ADK")
		ADK->(dbGoTo((cAlEmp)->REGNO_ADK))
		
		OpenSm0("02", .f.)

		SM0->(dbSetOrder(1))
		SM0->(dbSeek("02" + ADK->ADK_XFILI))
		
		cEmpAnt := "02"		//Será criado um campo na ADK com esta informação. Precisa substituir 
		cFilAnt	:= ADK->ADK_XFILI

	EndIf
	
	(cAlEmp)->(dbCloseArea())

Return lRet

/*/{Protheus.doc} VerResp
//TODO Função para validar e posicionar responsavel da filial
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return lRet. Lógico, .T. OU .F.
@param nRegZ15, numeric, RECNO da tabela utilizada
/*/
Static Function VerResp(nRegZ15)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlEmp	:= ""

	cQuery := "	SELECT Z15.R_E_C_N_O_ REGNO_Z15 					" + CRLF
	cQuery += "	FROM " + RetSqlName("Z15") + " Z15 					" + CRLF 
	cQuery += "	WHERE 												" + CRLF 
	cQuery += "	        Z15_FILIAL = '" + xFilial("Z15") +  "' 		" + CRLF
	cQuery += "	    AND Z15_COD    = '" + ADK->ADK_RESP  + "' 		" + CRLF
	cQuery += "	    AND Z15_XEXC   = 'N' 							" + CRLF
	cQuery += "	    AND Z15.D_E_L_E_T_ = ' ' 						" + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlEmp := MPSysOpenQuery(cQuery)

	If (cAlEmp)->(Eof())
		lRet := .F.
	Else
		dbSelectArea("Z15")
		Z15->(dbGoTo((cAlEmp)->REGNO_Z15))
		nRegZ15 := (cAlEmp)->REGNO_Z15
	EndIf
	
	(cAlEmp)->(dbCloseArea())

Return lRet

/*/{Protheus.doc} VerVend
//TODO Função para validar e posicionar vendedor da filial
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return lRet. Lógico, .T. OU .F.
@param nRegZ15, numeric, RECNO da tabela utilizada
/*/
Static Function VerVend(nRegSA3)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlEmp	:= ""

	cQuery := "	SELECT SA3.R_E_C_N_O_ REGNO_SA3 				" + CRLF
	cQuery += "	FROM " + RetSqlName("SA3") + " SA3 				" + CRLF
	cQuery += "	WHERE 											" + CRLF 
	cQuery += "	        A3_FILIAL = '" + xFilial("SA3") + "' 	" + CRLF
	cQuery += "	    AND A3_COD = '" + Z15->Z15_COD + "' 		" + CRLF
	cQuery += "	    AND SA3.D_E_L_E_T_ = ' ' 					" + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlEmp := MPSysOpenQuery(cQuery)

	If (cAlEmp)->(Eof())
		lRet := .F.
	Else
		dbSelectArea("SA3")
		SA3->(dbGoTo((cAlEmp)->REGNO_SA3))
		nRegZ15 := (cAlEmp)->REGNO_SA3
	EndIf
	
	(cAlEmp)->(dbCloseArea())

Return lRet