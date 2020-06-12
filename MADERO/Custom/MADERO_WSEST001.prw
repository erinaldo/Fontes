#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"

/*/{Protheus.doc} GetGruposProdutos
//TODO Declaração do WebService GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
/*/
WSRESTFUL GetGruposProdutos DESCRIPTION "Madero - Grupos de Produto"

	WSMETHOD GET DESCRIPTION "Grupos de Produto" WSSYNTAX "/GetGruposProdutos || /GetGruposProdutos/{id}"

End WSRESTFUL

/*/{Protheus.doc} GET
//TODO Declaração do Metodo GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
/*/
WSMETHOD GET WSRECEIVE NULLPARAM WSSERVICE GetGruposProdutos
Local cXml	:= ""

	::SetContentType("application/xml")
	
	cXml := WSEST001()

	::SetResponse(cXML)

Return .T.


/*/{Protheus.doc} ProtheusGetGruposProdutos
//TODO declaração das classe para gerar o XML
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Class ProtheusGetGruposProdutos From ProtheusMethodAbstract

	Method new(cMethod) constructor
	Method makeXml(aDadUsr)

EndClass

/*/{Protheus.doc} New
//TODO Metodo Inicializados da Classe ProtheusGetGruposProdutos
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
@param cMethod, characters, descricao
/*/
Method New(cMethod) Class ProtheusGetGruposProdutos
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
Method makeXml(cAlQry) Class ProtheusGetGruposProdutos

	Local cXml := ''

	cXml += '<?xml version="1.0" encoding="ISO-8859-1"?>'
	
	cXml += '<retorno>'	
	cXml += '<grupos>'	

	While !(cAlQry)->(Eof())
	
		cXml += '<grupo'			
		cXml += ::tag('bmdesc'		,(cAlQry)->BM_DESC)		
		cXml += ::tag('bmgrupo'		,(cAlQry)->BM_GRUPO)	
		cXml += '/>'
	
		(cAlQry)->(dbSkip())
	
	EndDo
	
	cXml += '</grupos>'	

	cXml += '<confirmacao>'
	
	cXml += '<confirmacao'
	cXml += ::tag('integrado'		,"true")			
	cXml += ::tag('mensagem'		,"Intagracao ok.")
	cXml += ::tag('data'			,DtoS(Date()))		
	cXml += ::tag('hora'			,Time())	
	cXml += '/>'
	
	cXml += '</confirmacao>'

	cXml += '</retorno>'

Return cXml

/*/{Protheus.doc} WSEST001
//TODO Função para executar WS GetAcesso
@author Mario L. B. Faria
@since 17/07/2018
@version 1.0
@return cXml, Caracter, XML de retorno
/*/
Static Function WSEST001()
Local cQuery	:= ""
Local cAlQry	:= ""
local cAux		:= ""
Local lCont		:= .T.
Local cXml		:= ""
Local oTag		:= Nil

	cQuery := "	SELECT BM_GRUPO, BM_DESC " + CRLF
	cQuery += "	FROM " + RetSqlName("SBM") + " SBM " + CRLF
	cQuery += "	WHERE " + CRLF  
	cQuery += "	        BM_FILIAL = '" + xFilial("SBM") + "' " + CRLF 
	cQuery += "	    AND BM_GRUPO >= '500' " + CRLF
	cQuery += "	    AND D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "	ORDER BY BM_GRUPO " + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)

	If (cAlQry)->(Eof())
		cAux := "Nao encontrado grupos de produtos. [BM_GRUPO > 500]"
		lCont := .F.
	EndIf

	If lCont
		oTag := ProtheusGetGruposProdutos():New("Tag")
		cXml := oTag:MakeXml(cAlQry)
	Else	
		cXml := '<confirmacao integrado="' + If(lCont,"true","false") + '" mensagem="' + cAux + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
	EndIf
	
	(cAlQry)->(dbCloseArea())
	
Return cXml






