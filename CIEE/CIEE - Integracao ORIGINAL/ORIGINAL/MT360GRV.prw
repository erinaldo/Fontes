#Include 'Protheus.ch'
//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT360GRV
Ponto de entrada após incluir,alterar e excluir condição de pagamento
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT360GRV()

IF INCLUI 
	CGXMLCPG(3,SE4->E4_CODIGO)
ELSEIF ALTERA 
	CGXMLCPG(4,SE4->E4_CODIGO)
ELSEIF !INCLUI .AND. !ALTERA 
	CGXMLCPG(5,SE4->E4_CODIGO)
ENDIF

Return
/*------------------------------------------------------------------------
*
* CGXMLCPG()
* Gera xml do cadastro de produto e integra com ambiente PRODUCAO
*
------------------------------------------------------------------------*/
static function CGXMLCPG(nOpcao,cCodPrd)
local aAreaSE4:= SE4->(GETAREA())
local cFunXml	:= "CEAIA31"
local cDescXml:= "Integração condição de pagamento"
local cData	:= Dtos(Date())
local cHora	:= Time()
local cUUID	:= FWUUID(cCodPrd)
Local oWsCiee	:= nil
local cXml		:= ""
local cRet		:= ""
local nItem	:= 0

// Montagem das tags do XML
cXML += '<TOTVSIntegrator>'
cXML += '<GlobalProduct>TOTVS|EAI</GlobalProduct>'
cXML += '<GlobalFunctionCode>EAI</GlobalFunctionCode>'
cXML += '<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'
cXML += '<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'
cXML += '<DocVersion>1.0</DocVersion>'
cXML += '<DocDateTime>'+cData+'</DocDateTime>'
cXML += '<DocIdentifier>'+cUUID+'</DocIdentifier>'
cXML += '<DocCompany>'+cEmpAnt+'</DocCompany>'
cXML += '<DocBranch>'+cFilAnt+'</DocBranch>'
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
cXML += '<SE4MASTER modeltype="FIELDS">'

dbSelectArea("SE4")
SE4->(dbsetOrder(1))
SE4->(dbseek(xFilial("SE4")+cCodPrd))

nItem := 1
While SE4->(!Eof()) .and. SE4->(E4_FILIAL+E4_CODIGO) == xFilial("SE4")+cCodPrd

	// Campos do SE4
	For i := 1 To FCount()
		U_CIXCONV("SE4",FieldName(i),@cXML)
	Next	
	nItem++
	
SE4->(dbSkip())
Enddo


cXML += '</SE4MASTER>'
cXML += '</'+cFunXml+'>'
cXML += '</Content>'
cXML += '</Layouts>'
cXML += '</Message>'
cXML += '</TOTVSIntegrator>'

U_CIWSINT(cXml)

RESTAREA(aAreaSE4)
return



