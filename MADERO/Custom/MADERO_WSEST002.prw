#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"

WSRESTFUL GetProdutosAInventariar DESCRIPTION "Madero - Produtos a Inventariar"

	WSMETHOD POST DESCRIPTION "Produtos a Inventariar" WSSYNTAX "/GetProdutosAInventariar/{id}"

End WSRESTFUL



/*/{Protheus.doc} GET
//TODO Declaração do Metodo GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
/*/
WSMETHOD POST WSSERVICE GetProdutosAInventariar
Local cBody := ::GetContent()
Local cXml	:= ""
	
	::SetContentType("application/xml")
	
	cXml := WSEST002(cBody)

	::SetResponse(cXML)	

Return .T.

/*/{Protheus.doc} ProtheusGetProdutosAInventariar
//TODO declaração das classe para gerar o XML
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Class ProtheusGetProdutosAInventariar From ProtheusMethodAbstract

	Method new(cMethod) constructor
	Method MakeXml(cUsr, cDtaInv, lInteg, cMsg, cArqCsv)
	Method AnaliseAce(oXmlAce) 
	Method AnaliseGrp(oXml)
	Method AnalisePrd(cGrp)
	Method VerInvAbe() 

EndClass

/*/{Protheus.doc} New
//TODO Metodo Inicializados da Classe ProtheusGetProdutosAInventariar
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
@param cMethod, characters, descricao
/*/
Method New(cMethod) Class ProtheusGetProdutosAInventariar
	::cMethod := cMethod
Return

/*/{Protheus.doc} makeXml
//TODO Metodo para gerar XML do WS GetGruposProdutos
@author Mario L. B. Faria
@since 17/07/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param cAlQry, caracter, Alias com os dados a enviar
/*/
Method MakeXml(cUsr, cDtaInv, lInteg, cMsg, cArqCsv) Class ProtheusGetProdutosAInventariar

	Local cXml := ''

	cXml += '<?xml version="1.0" encoding="ISO-8859-1"?>'
	
	cXml += '<Retorno>'
	
	cXml += '<id' 
	cXml += ::tag('cdempresa'		,cEmp)	
	cXml += ::tag('cdfilial'		,cFil)
	cXml += ::tag('filial'			,If(Empty(cFil),"",cFilAnt))		
	cXml += ::tag('idusuario'		,cUsr)		
	cXml += ::tag('datainventario'	,cDtaInv)
		
	cXml += ::tag('nomearquivo'		,cArqCsv)
	cXml += ::tag('idinventario'	,SubStr(cArqCsv,4,6))
		
	cXml += '/>'
	 
	cXml += '<confirmacao' 
	cXml += ::tag('integrado'		,If(lInteg,"true","false"))
	cXml += ::tag('mensagem'		,If(Empty(cMsg), "Integracao ok.", cMsg))
	cXml += ::tag('data'			,Date()	,"DATE") 
	cXml += ::tag('hora'			,Time())	

	cXml += '/>'
	
	cXml += '</Retorno>'

Return cXml

/*/{Protheus.doc} AnaliseAce
//TODO Metodo para validar os acessos
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return cRet, caracter. mensagem de retorno, se retornar vazio não houve erro
@param oXmlAce, object, contem o dados de acesso
/*/
Method AnaliseAce(oXmlAce) class ProtheusGetProdutosAInventariar
Local lErro		:= .F.
Local cRet		:= ""
Local cQuery	:= ""
Local cAlQry	:= ""
Local aArea		:= GetArea()
	
	cEmp		:= oXmlAce:_CDEMPRESA:TEXT
	cFil		:= oXmlAce:_CDFILIAL:TEXT	
	
	If !Empty(cEmp) .Or. !Empty(cFil)

		cQuery := "	SELECT R_E_C_N_O_ REGNO_ADK " + CRLF
		cQuery += "	FROM " + RetSqlName("ADK") + " ADK " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "			ADK_FILIAL = '" + xFilial("ADK") + "' " + CRLF
		cQuery += "		AND ADK_XEMP = '" + cEmp + "' " + CRLF
		cQuery += "		AND ADK_XFIL = '" + cFil + "' " + CRLF
		cQuery += "		AND ADK.D_E_L_E_T_ = ' ' " + CRLF

		cQuery := ChangeQuery(cQuery)
		cAlQry := MPSysOpenQuery(cQuery)

		If !(cAlQry)->(Eof())
			
			dbSelectArea("ADK")
			ADK->(dbGoTo((cAlQry)->REGNO_ADK))	
			
			If !Empty(ADK->ADK_XFILI)
			
				OpenSm0("02", .f.)
		
				SM0->(dbSetOrder(1))
				SM0->(dbSeek("02" + ADK->ADK_XFILI))
				
				cEmpAnt := "02"		//Será criado um campo na ADK com esta informação. Precisa substituir 
				cFilAnt	:= ADK->ADK_XFILI	

			Else 
				lErro	:= .T.	
			EndIf
			
		Else			
			lErro := .T.					
		EndIf
		
		If lErro
			cRet := "Unidade de negocio nao encontrada no Protheus. [ADK_XEMP+ADK_XFIL = " + cEmp + cFil + "]"
			cEmp	:= ""
			cFil	:= ""
		EndIf

		(cAlQry)->(dbCloseArea())
			
	EndIf

	RestArea(aArea)

Return cRet

/*/{Protheus.doc} AnaliseGrp
//TODO Valida os grupos que possuem produtos
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return aGrpOk, array, grupos validos
		aGrpNot, array, grupos  não válidos
@param oXml, object, Contem os dados dos grupos
/*/
Method AnaliseGrp(oXml) class ProtheusGetProdutosAInventariar

	Local nGrp		:= 0
	Local oXmlGrp	:= oXml
	Local aGrpNot	:= {}
	Local aGrpOk	:= {}

	Do Case

		Case ValType(oXmlGrp) == "O"
			lOk := ::AnalisePrd(oXmlGrp:_BMGRUPO:TEXT)
			VerGrp(lOk,oXmlGrp:_BMGRUPO:TEXT,@aGrpOk,@aGrpNot)
		Case ValType(oXmlGrp) == "A"
			For nGrp := 1 to len(oXmlGrp)
				lOk := ::AnalisePrd(oXmlGrp[nGrp]:_BMGRUPO:TEXT)
				VerGrp(lOk,oXmlGrp[nGrp]:_BMGRUPO:TEXT,@aGrpOk,@aGrpNot)
			Next nGrp	
		
	EndCase

Return {aGrpOk,aGrpNot}

/*/{Protheus.doc} AnalisePrd
//TODO Valida se o grupo psuui produtos
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return lRet, lógico, .T. Sucesso - .F. Erro
@param cGrp, characters, descricao
/*/
Method AnalisePrd(cGrp) class ProtheusGetProdutosAInventariar

	Local lRet := .T.
	Local cQuery	:= ""
	Local cAlQry	:= ""
	
	cQuery := "	SELECT B1_COD " + CRLF
	cQuery += "	FROM " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += "	        B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery += "	    AND B1_GRUPO = '" + cGrp + "' " + CRLF
	cQuery += "	    AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "	    AND ROWNUM = 1 " + CRLF	

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)

	If (cAlQry)->(Eof())
		lRet := .F.					
	EndIf

	(cAlQry)->(dbCloseArea())
	
Return lRet

/*/{Protheus.doc} VerInvAbe
//TODO Verifica se possui inventário em aberto
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return lRet, lógico, .T. Sucesso - .F. Erro
/*/
Method VerInvAbe() class ProtheusGetProdutosAInventariar

	Local lRet		:= .T.	
	Local cQuery	:= ""
	Local cAlQry	:= ""

	cQuery := "	SELECT Z23_ID " + CRLF
	cQuery += " FROM  " + RetSqlName("Z23") + " Z23 " + CRLF
	cQuery += " WHERE " + CRLF
	cQuery += "         Z23_FILIAL = '" + xFilial("Z23") + "' " + CRLF
	cQuery += "     AND Z23_DTINV != ' ' " + CRLF
	cQuery += "     AND Z23_DTCONF = ' ' " + CRLF
	cQuery += "     AND D_E_L_E_T_ = ' ' " + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)

	If (cAlQry)->(Eof())
		lRet := .F.					
	EndIf

	(cAlQry)->(dbCloseArea())
	
Return lRet

/*/{Protheus.doc} WSEST002
//TODO Função Princiapal do WS
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return cXml, carcater, XMl de RETORNO
@param cXml, characters, XML recebido
/*/
Static Function WSEST002(cXml)
Local lCont		:= .T.
Local cAux		:= ""
Local cMsg		:= ""
Local aRetArq	:= ""
Local cArqCsv	:= ""
Local aRetGrp	:= {}
Local aGrpNot	:= {}
Local aGrpOk	:= {}
Local oWs		:= Nil
Local oXml		:= Nil
Local oXmlAce	:= Nil
Local oXmlId	:= Nil
Local oXmlGrp	:= Nil 
//Local cMetEnv	:= "Post"
//Local cMethod	:= "GetProdutosAInventariar"
//Local oEventLog := oEventLog := EventLog():Start(cMethod + "-" + cMetEnv, Date(), "Iniciando processo de integracao: ", cMetEnv, "")
Private cEmp	:= ""
Private cFil	:= ""

	If Empty(cXml)
		cAux := "XML de Grupos invalido ou vazio!!!"
		lCont:= .F.
	EndIf
	
	If lCont
	
		oWs		:= ProtheusGetProdutosAInventariar():New("Tag")
		oXmlAce	:= oWs:xmlParser(cXml)
		cMsg	:= oWs:AnaliseAce(oXmlAce:_INVENTARIO:_ID)
		oXml	:= oWs:xmlParser(cXml)
		oXmlId	:= oXml:_INVENTARIO:_ID
		oXmlGrp := oXml:_INVENTARIO:_GRUPOS:_GRUPO		

		// -> Se nao ocorreu erro, continua o porcesso
		If Empty(cMsg)
		
			//Verifica data do inventario
			If !Empty(Stod(oXmlId:_DATAINVENTARIO:TEXT))
		
				aRetGrp  := oWs:AnaliseGrp(oXmlGrp)
				aGrpOk	 := aRetGrp[01]
				aGrpNot  := aRetGrp[02]
				dDataBase:= Stod(oXmlId:_DATAINVENTARIO:TEXT)
				
				If Len(aGrpOk) > 0
				
					If oWs:VerInvAbe()	//Se tem inventario em aberto encerra a rotina
						cAux := "Inventario pendente para a filial: " + xFilial("Z23") 
						lCont	:= .F.				
					EndIf
				
				Else

					cAux := "Nao existem produtos a inventariar para os grupos solicitados."
					lCont	:= .F.

				EndIf
				
			Else
			
				cAux := "Data do inventario invalida. [_DATAINVENTARIO=Vazio]"
				lCont	:= .F.		
			
			EndIf
			
		Else
			
			cAux	:= cMsg
			lCont	:= .F.
		
		EndIf
		
		// -> Se não ocorreu erro,continua o processo
		If lCont
		
			Begin Transaction

			//Inclui Inventario
			cMsg := U_EST550I("WSEST002", xFilial("Z23"), oXmlId:_IDUSUARIO:TEXT, oXmlId:_DATAINVENTARIO:TEXT, aGrpOk, 3)
			
			If Empty(cMsg)
				
				//Gera arquivo CSV
				aRetArq := U_EST550G("WSEST002", Z23->Z23_GRUPOS, Z23->Z23_FILIAL, Z23->Z23_ID, ADK->ADK_XEMP, ADK->ADK_XFIL, ADK->ADK_EMAIL)
				
				cMsg	:= aRetArq[01]
				cArqCsv	:= aRetArq[02]
				
				If !Empty(cMsg)
					cAux	:= cMsg
				EndIf
				
			Else	

				cAux	:= cMsg
				cAux	:= "Erro: Erro na geração dos itens a inventariar em " + DtoC(StoD(oXmlId:_DATAINVENTARIO:TEXT))
				lCont	:= .F.	
				DisarmTransaction()	

			EndIf
			
			End Transaction

		EndIf

		cXml := oWs:MakeXml(oXmlId:_IDUSUARIO:TEXT, oXmlId:_DATAINVENTARIO:TEXT, lCont, cAux, cArqCsv)	
	
	EndIf	
	
Return cXml

/*/{Protheus.doc} VerGrp
//TODO Gerar os arrayys de retorno
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@param lOk, logical, .T. - .F.
@param cGrp, characters, grupo
@param aGrpOk, array, Array com os grupos validos
@param aGrpNot, array, Array com os grupos invalidos
/*/
Static Function VerGrp(lOk,cGrp,aGrpOk,aGrpNot)
	If lOk
		aAdd(aGrpOk,cGrp)
	Else
		aAdd(aGrpNot,cGrp)
	EndIf
Return
