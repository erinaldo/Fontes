#INCLUDE "TOTVS.CH"
static __cXmlExc:= ""
//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MA035INC
Ponto de entrada após incluir grupo de produtos
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION MA035INC()
	
U_CGXMLGRP(3,SBM->BM_GRUPO)

RETURN 

/*/{Protheus.doc} MA035ALT
Ponto de entrada após alterar grupo de produtos
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MA035ALT()

U_CGXMLGRP(4,SBM->BM_GRUPO)

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT035EXC
Ponto de entrada para validar a exclusão do grupo de produtos
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION MT035EXC()
	
U_CGXMLGRP(5,SBM->BM_GRUPO)

RETURN .T.

/*/{Protheus.doc} MA035DEL
Ponto de entrada apos a exclusão do grupo de produtos
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION MA035DEL()
	
	IF !EMPTY(__cXmlExc)
		U_CIWSINT(__cXmlExc)
	ENDIF	

RETURN 

/*------------------------------------------------------------------------
*
* CGXMLGRP()
* Gera xml do cadastro de grupo de produtos e integra com ambiente PRODUCAO
*
------------------------------------------------------------------------*/
user function CGXMLGRP(nOpcao,cCodGrp)
local aAreaSBM:= SBM->(GETAREA())
local cFunXml	:= "CEAIA33"
local cDescXml:= "Integração grupo de produtos"
local cData	:= Dtos(Date())
local cHora	:= Time()
local cUUID	:= FWUUID(cCodGrp)
Local oWsCiee	:= nil
local cXml		:= ""
local cRet		:= ""
local nItem	:= 0
local xEmpInt	:= "01"
local xFilInt	:= "0001"

// Montagem das tags do XML
cXML += '<TOTVSIntegrator>'
cXML += '<GlobalProduct>TOTVS|EAI</GlobalProduct>'
cXML += '<GlobalFunctionCode>EAI</GlobalFunctionCode>'
cXML += '<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'
cXML += '<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'
cXML += '<DocVersion>1.0</DocVersion>'
cXML += '<DocDateTime>'+cData+'</DocDateTime>'
cXML += '<DocIdentifier>'+cUUID+'</DocIdentifier>'
cXML += '<DocCompany>'+xEmpInt+'</DocCompany>'
cXML += '<DocBranch>'+xFilInt+'</DocBranch>'
cXML += '<DocName></DocName>'
cXML += '<DocFederalID></DocFederalID>'
cXML += '<DocType>2</DocType>'
cXML += '<Message>'
cXML += '<Layouts>'
cXML += '<Identifier>'+cFunXml+'</Identifier>'
cXML += '<Version>1.0</Version>'
cXML += '<FunctionCode>U_'+cFunXml+'</FunctionCode>'
cXML += '<Content>'
cXML += '<'+cFunXml+' Operation="'+ TRIM(CVALTOCHAR(nOpcao)) +'" version="1.01">'
cXML += '<SBMMASTER modeltype="FIELDS">'

dbSelectArea("SBM")
SBM->(dbsetOrder(1))
SBM->(dbseek(xFilial("SBM")+cCodGrp))

nItem := 1
While SBM->(!Eof()) .and. SBM->(BM_FILIAL+BM_GRUPO) == xFilial("SBM")+cCodGrp

	// Campos do SBM
	For i := 1 To FCount()
		U_CIXCONV("SBM",FieldName(i),@cXML)		
	Next	
	nItem++
	
SBM->(dbSkip())
Enddo


cXML += '</SBMMASTER>'
cXML += '</'+cFunXml+'>'
cXML += '</Content>'
cXML += '</Layouts>'
cXML += '</Message>'
cXML += '</TOTVSIntegrator>'

IF nOpcao == 5 
	__cXmlExc:= cXML
ELSE
	U_CIWSINT(cXml)
ENDIF

RESTAREA(aAreaSBM)
return

