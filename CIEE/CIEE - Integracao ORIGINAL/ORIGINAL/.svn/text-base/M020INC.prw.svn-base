#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} M020INC
Ponto de entrada após incluir o registro do Fornecedor
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION M020INC()
Local cCodFor:= SA2->A2_COD

U_ProcCli()

//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL	
//TODO - Importar tabela CCH na PRODUCAO
U_CGXMLFOR(3,cCodFor)

RETURN 

/*------------------------------------------------------------------------
*
* CGXMLFOR()
* Gera xml do cadastro de fornecedor e integra com ambiente PRODUCAO
*
------------------------------------------------------------------------*/
user function CGXMLFOR(nOpcao,cCodFor)
local aAreaSA2:= SA2->(GETAREA())
local cFunXml	:= "CEAIA02"
local cDescXml:= "Integração cadastro de fornecedor"
local cData	:= Dtos(Date())
local cHora	:= Time()
local cUUID	:= FWUUID(cCodFor)
Local oWsCiee	:= nil
local cXml		:= ""
local cRet		:= ""
local nItem	:= 0
local xEmpInt	:= "01"
local xFilInt	:= "0001"

dbSelectArea("SA2")
SA2->(dbsetOrder(1))
IF SA2->(dbseek(xFilial("SA2")+cCodFor))
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
	cXML += '<SA2MASTER modeltype="FIELDS">'
	
	nItem := 1
	While SA2->(!Eof()) .and. SA2->(A2_FILIAL+A2_COD) == xFilial("SA2")+cCodFor
	
		// Campos do SA2
		For i := 1 To FCount()
			U_CIXCONV("SA2",FieldName(i),@cXML)
		Next	
		nItem++
		
	SA2->(dbSkip())
	Enddo
	
	
	cXML += '</SA2MASTER>'
	cXML += '</'+cFunXml+'>'
	cXML += '</Content>'
	cXML += '</Layouts>'
	cXML += '</Message>'
	cXML += '</TOTVSIntegrator>'
ENDIF

U_CIWSINT(cXml)

RESTAREA(aAreaSA2)
return