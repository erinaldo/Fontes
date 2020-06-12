#Include 'Protheus.ch'
static __cXmlExc:= ""
//TODO - Realizar carga no ambiente de produção: Grupos de produto, Armazem 
//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT010CAN
Ponto de entrada após incluir,alterar e excluir cadastro de produto
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT010CAN()
Local nOpc := ParamIxb[1]

IF INCLUI .AND. nOpc == 1 
	CGXMLPRD(3,SB1->B1_COD)
ELSEIF ALTERA .AND. nOpc == 1
	CGXMLPRD(4,SB1->B1_COD)
ELSEIF !INCLUI .AND. !ALTERA .AND. nOpc == 2
	IF !EMPTY(__cXmlExc)
		U_CIWSINT(__cXmlExc)
	ENDIF	
ENDIF

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA010OK
Ponto de entrada antes de excluir cadastro de produto
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MTA010OK()

	CGXMLPRD(5,SB1->B1_COD)

Return
/*------------------------------------------------------------------------
*
* CGXMLPRD()
* Gera xml do cadastro de produto e integra com ambiente PRODUCAO
*
------------------------------------------------------------------------*/
static function CGXMLPRD(nOpcao,cCodPrd)
local aAreaSB1:= SB1->(GETAREA())
local cFunXml	:= "CEAIA03"
local cDescXml:= "Integração cadastro de produtos"
local cData	:= Dtos(Date())
local cHora	:= Time()
local cUUID	:= FWUUID(cCodPrd)
Local oWsCiee	:= nil
local cXml		:= ""
local cRet		:= ""
local nItem	:= 0
local xEmpInt	:= "01"
local xFilInt	:= "0001"

dbSelectArea("SB1")
SB1->(dbsetOrder(1))
IF SB1->(dbseek(xFilial("SB1")+cCodPrd))
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
	cXML += '<SB1MASTER modeltype="FIELDS">'
	
	nItem := 1
	While SB1->(!Eof()) .and. SB1->(B1_FILIAL+B1_COD) == xFilial("SB1")+cCodPrd
	
		// Campos do SB1
		For i := 1 To FCount()
			U_CIXCONV("SB1",FieldName(i),@cXML)		
		Next	
		nItem++
		
	SB1->(dbSkip())
	Enddo
	
	
	cXML += '</SB1MASTER>'
	cXML += '</'+cFunXml+'>'
	cXML += '</Content>'
	cXML += '</Layouts>'
	cXML += '</Message>'
	cXML += '</TOTVSIntegrator>'
ENDIF

IF nOpcao == 5 
	__cXmlExc:= cXML
ELSE
	U_CIWSINT(cXml)
ENDIF	

RESTAREA(aAreaSB1)
return

