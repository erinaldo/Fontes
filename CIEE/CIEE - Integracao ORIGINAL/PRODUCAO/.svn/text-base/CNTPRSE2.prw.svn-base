#Include 'Protheus.ch'

User Function CNTPRSE2()

//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
CGXMLTIT(3,SE2->E2_PREFIXO,SE2->E2_NUM)

Return

user function CN100TIT()

//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
//TODO - adicionar no campo E2_PARCELA no X3_VALID--> IIF(ISINCALLstack("U_CORIGA01"),.t.,FA050Num())

//TODO - AQUI 
CGXMLTIT(5,SE2->E2_PREFIXO,SE2->E2_NUM)

return

/*------------------------------------------------------------------------
*
* CGXMLTIT()
* Gera xml do titulo a pagar e integra com ambiente ORIGINAL
*
------------------------------------------------------------------------*/
STATIC FUNCTION CGXMLTIT(nOpcao,cPrefix,cNumTit)
//local aAreaSE2:= SE2->(GETAREA())
local cFunXml	:= "CORIGA01"
local cDescXml:= "Integração de contratos - titulo a pagar"
local cData	:= Dtos(Date())
local cHora	:= Time()
local cUUID	:= FWUUID(cNumTit)
Local oWsCiee	:= nil
local cXml		:= ""
local cRet		:= ""
local nItem	:= 0
local xEmpInt	:= "01"
local xFilInt	:= "01"

//dbSelectArea("SE2")
//SE2->(dbsetOrder(1))
//IF SE2->(dbseek(xFilial("SE2")+cPrefix+cNumTit))
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
	cXML += '<SE2MASTER modeltype="FIELDS">'
	
//	nItem := 1
//	While SE2->(!Eof()) .and. SE2->(E2_FILIAL+E2_NUM) == xFilial("SE2")+cNumTit
	
	// Campos do SE2
	For i := 1 To FCount()
		U_CIXCONV("SE2",FieldName(i),@cXML)
	Next	
//		nItem++
//		
//	SE2->(dbSkip())
//	Enddo
	
	
	cXML += '</SE2MASTER>'
	cXML += '</'+cFunXml+'>'
	cXML += '</Content>'
	cXML += '</Layouts>'
	cXML += '</Message>'
	cXML += '</TOTVSIntegrator>'
//ENDIF

U_CIWSINT(cXml)

//RESTAREA(aAreaSE2)
return

