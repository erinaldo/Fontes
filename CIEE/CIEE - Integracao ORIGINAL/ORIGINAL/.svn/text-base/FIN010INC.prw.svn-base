#INCLUDE "TOTVS.CH"
//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FIN010INC
Ponto de entrada após incluir a natureza
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION FIN010INC()
	
U_CGXMLNAT(3,SED->ED_CODIGO)

RETURN 

/*------------------------------------------------------------------------
*
* CGXMLFOR()
* Gera xml do cadastro de fornecedor e integra com ambiente PRODUCAO
*
------------------------------------------------------------------------*/
user function CGXMLNAT(nOpcao,cCodNat)
local aAreaSED:= SED->(GETAREA())
local cFunXml	:= "CEAIA32"
local cDescXml:= "Integração cadastro de natureza"
local cData	:= Dtos(Date())
local cHora	:= Time()
local cUUID	:= FWUUID(cCodNat)
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
cXML += '<SEDMASTER modeltype="FIELDS">'

dbSelectArea("SED")
SED->(dbsetOrder(1))
SED->(dbseek(xFilial("SED")+cCodNat))

nItem := 1
While SED->(!Eof()) .and. SED->(ED_FILIAL+ED_CODIGO) == xFilial("SED")+cCodNat

	// Campos do SED
	For i := 1 To FCount()
		U_CIXCONV("SED",FieldName(i),@cXML)		
	Next	
	nItem++
	
SED->(dbSkip())
Enddo


cXML += '</SEDMASTER>'
cXML += '</'+cFunXml+'>'
cXML += '</Content>'
cXML += '</Layouts>'
cXML += '</Message>'
cXML += '</TOTVSIntegrator>'

U_CIWSINT(cXml)

RESTAREA(aAreaSED)
return

