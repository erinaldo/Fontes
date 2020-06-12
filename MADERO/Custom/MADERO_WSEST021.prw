#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"

/*/{Protheus.doc} PutProdutosConferidos
//TODO Declaração do WebService PutProdutosConferidos
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
/*/
WSRESTFUL PutProdutosConferidos DESCRIPTION "Madero - Produtos Conferidos"
	
	WSDATA cdempresa AS STRING
	WSDATA cdfilial AS STRING
	WSDATA cdusuario AS STRING
	WSDATA cchavenfe AS STRING

	WSMETHOD PUT DESCRIPTION "Acesso de Usuários" WSSYNTAX "/PutProdutosConferidos || /PutProdutosConferidos/{id}"

End WSRESTFUL

/*/{Protheus.doc} PUT
//TODO Declaração do Metodo PutProdutosConferidos
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
/*/
WSMETHOD PUT WSRECEIVE cdempresa, cdfilial, cdusuario, cchavenfe  WSSERVICE PutProdutosConferidos
Local cXml	:= ""
Local cBody	:= ::GetContent()

	::SetContentType("application/xml")
	
	cXml := U_WSEST021( cBody )

	::SetResponse(cXml)

Return .T.
/*/{Protheus.doc} ProtheusPutProdutosConferidos
//TODO declaração das classe para gerar o XML
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Class ProtheusPutProdutosConferidos From ProtheusMethodAbstract

	Method new( cMethod ) constructor
	Method makeXml( lIntegrado, cMsg )
	Method getVars( oXml )
	Method procRegs( aProds )

EndClass
/*/{Protheus.doc} New
//TODO Metodo Inicializados da Classe ProtheusPutProdutosConferidos
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return ${return}, ${return_description}
@param cMethod, caracter, descricao
/*/
Method New(cMethod) Class ProtheusPutProdutosConferidos
	::cMethod := cMethod
Return
/*/{Protheus.doc} getRegs
//TODO Metodo busca dados que serão processados.
@author Vinicius Moreira
@since 07/08/2018
@version 1.0
@return lRet, logico, Indica se foi possivel extrair todas as variaveis necessarias.
@param oXml, objeto, XML com dados a serem extraidos.
/*/
Method getVars( oXml ) Class ProtheusPutProdutosConferidos
	
	Local lRet 	:= .T.
	Local nX	:= 0
	
	cCDEmpresa	:= oXml:_CONFERENCIA:_ID:_CDEMPRESA:TEXT
	cCDFilial	:= oXml:_CONFERENCIA:_ID:_CDFILIAL:TEXT
	cNumeroNF 	:= oXml:_CONFERENCIA:_ID:_NUMERONF:TEXT 
	cSerieNF 	:= oXml:_CONFERENCIA:_ID:_SERIENF:TEXT
	dEmissaoNF	:= SToD( oXml:_CONFERENCIA:_ID:_EMISSAONF:TEXT )
	cNomFornec	:= oXml:_CONFERENCIA:_ID:_NOMFORNEC:TEXT
	cCNPJ		:= oXml:_CONFERENCIA:_ID:_CNPJ:TEXT
	cIDUsuario	:= oXml:_CONFERENCIA:_ID:_IDUSUARIO:TEXT
	cUSRLogin	:= oXml:_CONFERENCIA:_ID:_USRLOGIN:TEXT
	
	If ValType( oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO ) != "A"
		XmlNode2Arr( oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO, "_PRODUTO" )
	EndIf
	
	For nX := 1 to Len( oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO )
		AAdd( aProds, {	PadR( oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO[nX]:_CDITEM:TEXT, Len( SD1->D1_ITEM ), " " ),;	    //01
						      oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO[nX]:_CDPRODUTO:TEXT,;								//02
						Val(  oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO[nX]:_QUANTIDADE:TEXT ),;								//03
						Val(  oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO[nX]:_VRUNITARIO:TEXT ),;								//04
						Val(  oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO[nX]:_VRTOTAL:TEXT ),;								//05
						Val(  oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO[nX]:_QTDECONFERIDA:TEXT ),;							//06
						      oXml:_CONFERENCIA:_PRODUTOS:_PRODUTO[nX]:_DSPRODUTO:TEXT } )								//07
	Next nX
	
Return lRet
/*/{Protheus.doc} getRegs
//TODO Metodo de processamento de registros
@author Vinicius Moreira
@since 07/08/2018
@version 1.0
@return cRet, caracter, Mensagem de erro durante o processamento
@param aProds, array, array com produtos que serão processados.
/*/
Method procRegs( aProds ) Class ProtheusPutProdutosConferidos
Local cRet 		:= ""
Local nX		:= 0
Local lAchou	:= .F.
Local cADKXEMP  := IIF(Empty(xFilial("Z13")),Space(TamSx3("ADK_XEMP")[1]),ADK->ADK_XEMP)
Local cADKXFIL  := IIF(Empty(xFilial("Z13")),Space(TamSx3("ADK_XFIL")[1]),ADK->ADK_XFIL)

	// -> Posiciona na tabela SA2
	DbSelectArea("SA2")
	SA2->(DbSetOrder(3))
	If SA2->(DbSeek(xFilial("SA2")+cCNPJ))

		// -> Posiciona na tabela SF1
		DbSelectArea("SF1")
		SF1->(DbSetOrder(1))
		If SF1->(DbSeek(xFilial("SF1")+cNumeroNF+cSerieNF+SA2->A2_COD+SA2->A2_LOJA))
	
			// -> Abre a tabela de itens da NF
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			
			// -> Abre a tabela de produtos do Teknisa x Protheus
			dbSelectArea("Z13")
			Z13->(dbSetOrder(2))
			
			
			For nX := 1 to Len( aProds )
				If !Z13->(dbSeek(xFilial("Z13")+cADKXEMP+cADKXFIL+aProds[nX,2]))
					cRet := "Produto " + AllTrim(aProds[nX,2]) + " nao encontrado na tabela Z13."
					Exit
				Else
					lAchou:=SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)+Z13->Z13_COD+aProds[nX,1]))					
					If !lAchou .Or. SD1->D1_QUANT != aProds[nX,6]
						If Empty( cRet )
							cRet := Chr(13)+Chr(10)+"Item Codigo           Descricao                                                      Qtde NF   Qtde Conf. " + CRLF 
							cRet += "---- ---------------- -------------------------------------------------------------- --------- ---------- " + CRLF
						EndIf
						cRet += PadR( aProds[nX,1], 04, " " )
						cRet += " "
						cRet += PadR( aProds[nX,2], 16, " " )
						cRet += " "
						cRet += PadR( aProds[nX,7], 60, " " )
						cRet += " "
						If lAchou
							cRet += Transform( SD1->D1_QUANT, "@E 999,999.99" )
						Else
							cRet += Transform( 0, "@E 999,999.99" )
						EndIf
						cRet += Transform( aProds[nX,6], "@E 9,999,999.99" )
						cRet += CRLF 
					EndIf
				EndIf			
			Next nX
		Else
			cRet += IIF(AllTrim(cRet)=="","",Chr(13)+Chr(10))+"Documento nao encontrado no Protheus. [F1_DOC="+cNumeroNF+", F1_SERIE="+cSerieNF+", F1_FORNECE="+SA2->A2_COD+" e F1_LOJA="+SA2->A2_LOJA+"]"
		EndIf
	Else	
		cRet += IIF(AllTrim(cRet)=="","",Chr(13)+Chr(10))+"Fornecedor nao encontrado no Protheus. [A2_CGC="+cCNPJ+"]"		
	EndIf
	If Empty(cRet)
		For nX := 1 to Len(aProds)
			If Z13->(dbSeek(xFilial("Z13")+cADKXEMP+cADKXEMP+Z13->Z13_XCODEX)) 
				If SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)+Z13->Z13_COD+aProds[nX,1]))
					RecLock( "SD1", .F. )
						SD1->D1_XCONF	:= "S"
						SD1->D1_XQTDCON	:= aProds[nX,06]
						SD1->D1_XUSCONF := cUSRLogin
						SD1->D1_XDTCONF := Date()
						SD1->D1_XHRCONF := Time()
					SD1->(MsUnlock())
				EndIf
			EndIf
		Next nX
	EndIf 
	
Return cRet
/*/{Protheus.doc} makeXml
//TODO Metodo para gerar XML do WS PutProdutosConferidos
@author Vinicius Moreira
@since 07/08/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param lOk, logico, Indica se os dados foram processados com sucesso
@param cMsg, caracter, Mensagem que sera retornada para o client web service
/*/
Method makeXml(lOk, cMsg) Class ProtheusPutProdutosConferidos

	Local cXml 		:= ''
	Local nX		:= 0
	Default lOk		:= .T.
	Default cMsg	:= ""

	cXml += '<?xml version="1.0" encoding="ISO-8859-1"?>'
	cXml += '<retorno>'
	cXml += '<id '
	cXml += ::tag('cdempresa'	, AllTrim( ADK->ADK_XEMP  ) )
	cXml += ::tag('cdfilial'	, AllTrim( ADK->ADK_XFIL  ) )
	cXml += ::tag('dsfilial'	, AllTrim( SM0->M0_FILIAL ) )
	cXml += ::tag('numeronf'	, cNumeroNF )
	cXml += ::tag('serienf'		, cSerieNF )
	cXml += ::tag('emissaonf'	, DToS( dEmissaoNF ) )
	cXml += ::tag('cnpj'		, cCNPJ )
	cXml += ::tag('nomfornec'	, cNomFornec )
	cXml += ::tag('idusuario'	, cIDUsuario )
	cXml += ::tag('usrlogin'	, cUSRLogin )
	cXml += '/>'		
	cXml += '<produtos>'
	cXml += '</produtos>'	
	cXml += '<confirmacao>'
	cXml += '<confirmacao'
	If lOk
		cXml += ::tag('integrado'		,"true")
		If Empty( cMsg )
			cMsg := "Conferencia atualizada no ERP com sucesso."
		EndIf
	Else
		cXml += ::tag('integrado'		,"false")
	EndIf
	cXml += ::tag('mensagem'		,cMsg)
	cXml += ::tag('data'			,DtoS(Date()))		
	cXml += ::tag('hora'			,Time())	
	cXml += '/>'
	cXml += '</confirmacao>'
	cXml += '</retorno>'

Return cXml
/*/{Protheus.doc} WSEST021
//TODO Função principal de processamento
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param cXml, caracter, XML com dados a serem processados.
/*/
User Function WSEST021( cXml )
Local oXml			:= Nil
Local cMsg			:= ""
Local oTag			:= Nil
Private aProds		:= { }
Private cCDEmpresa	:= ""
Private cCDFilial	:= ""
Private cNumeroNF 	:= ""
Private cSerieNF 	:= ""
Private dEmissaoNF	:= CToD( "" )
Private cNomFornec	:= ""
Private cCNPJ		:= ""
Private cIDUsuario	:= ""
Private cUSRLogin	:= ""

	If Empty( cXml )
		cMsg := "XML não informado."
	Else
		oTag := ProtheusPutProdutosConferidos():New( "Tag" )
		oXml := oTag:XmlParser( cXml )
		If oXml == Nil
			cMsg := "Xml invalido."
		Else
			If oTag:getVars( oXml)
				If !VerEmp(cCDEmpresa, cCDFilial)
					cMsg := "Empresa / Filial nao encontrados no ERP. [ADK_FILIAL + ADK_XEMP + ADK_XFIL = " + xFilial("ADK") + cCDEmpresa + cCDFilial + "]"
				ElseIf !VldUser( cIDUsuario )
					cMsg := "Usuario encontrado no ERP."
				Else
					nModulo 	:= 4
					__cUserId	:= cIDUsuario

					ConOut("--> Processando conferencia para filial " + cFilAnt + " e NF/Serie " + cNumeroNF + "/" + cSerieNF )
				
					// Pesquisar fornecedor
					SA2->(DbSetOrder(3))
					If !SA2->(DbSeek(xFilial("SA2")+cCNPJ))
						cMsg := "Fornecedor não encontrado no ERP Protheus.."
					Else
						// Pesquisar Pré-nota
						SF1->(DbSetOrder(1))
						If !SF1->( dbSeek( xFilial( "SF1" ) + cNumeroNF + cSerieNF + SA2->A2_COD + SA2->A2_LOJA ) )
							cMsg := "Nota fiscal não encontrado no ERP Protheus."
						Else
							If !Empty( SF1->F1_STATUS )
								cMsg := "Nota fiscal já confirmada ERP Protheus."
							Else
								cMsg := oTag:procRegs( aProds )
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	// -> Se Ok, retorna 
	If Empty(cMsg)
		ConOut("Ok.")
	Else
		ConOut("Erro.")		
	EndIf

	cXml := oTag:MakeXml( Empty( cMsg ), cMsg )

Return cXml
/*/{Protheus.doc} VerEmp
//TODO Função para validar e posicionar na Empresa/Filial informada
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return lRet. Lógico, .T. OU .F.
@param cCodEmp, caracter, Código da Empresa
@param cCodFil, caracter, Código da Filial
/*/
Static Function VerEmp(cCodEmp, cCodFil)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlEmp	:= ""

	cQuery := "	SELECT R_E_C_N_O_ REGNO_ADK " + CRLF
	cQuery += "	FROM " + RetSqlName("ADK") + " ADK " + CRLF
	cQuery += "	WHERE ADK_FILIAL = '" + xFilial("ADK") + "' " + CRLF
	cQuery += "	  AND ADK_XEMP = '" + cCodEmp + "' " + CRLF
	cQuery += "	  AND ADK_XFIL = '" + cCodFil + "' " + CRLF
	cQuery += "	  AND ADK_XFILI <> ' ' " + CRLF
	cQuery += "	  AND ADK_MSBLQL = '2' " + CRLF	
	cQuery += "	  AND ADK.D_E_L_E_T_ = ' ' " + CRLF

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
/*/{Protheus.doc} VldUser
//TODO Checa se usuario informado existe 
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return lRet. Lógico, .T. OU .F.
@param cIdUser, caracter, Codigo do usuario
/*/
Static Function VldUser( cIdUser )

PswOrder( 1 )

Return PswSeek( cIdUser, .T. ) 