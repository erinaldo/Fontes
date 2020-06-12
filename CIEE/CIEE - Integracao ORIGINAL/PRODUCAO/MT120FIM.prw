#Include 'Protheus.ch'
static __cXmlExc:= ""
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT120FIM
Ponto de entrada após a gravação do pedido de compras
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT120FIM()
Local nOpcao 	:= PARAMIXB[1]   
Local cNumPC 	:= PARAMIXB[2]   
Local nConfirm:= PARAMIXB[3]

IF nConfirm > 0

	//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
	if nOpcao == 5 .AND. !EMPTY(__cXmlExc)
		U_CIWSINT(__cXmlExc)	
	else
		CGXMLPED(nOpcao,cNumPC)
	endif	
		
Endif   

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT120GRV
Ponto de entrada antes da gravação do pedido de compras
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT120GRV()   
Local cNumPC 	:= PARAMIXB[1]   

IF PARAMIXB[4]
	CGXMLPED(5,cNumPC)
ENDIF
	
return
/*------------------------------------------------------------------------
*
* CGXMLPED()
* Gera xml do pedido de compras e integra com ambiente ORIGINAL
*
------------------------------------------------------------------------*/
STATIC FUNCTION CGXMLPED(nOpcao,cNumPC)
local aAreaSC7:= SC7->(GETAREA())
local cFunXml	:= "CORIGA02"
local cDescXml:= "Integração de contratos - pedido de compras"
local cData	:= Dtos(Date())
local cHora	:= Time()
local cUUID	:= FWUUID(cNumPC)
Local oWsCiee	:= nil
local cXml		:= ""
local cRet		:= ""
local nItem	:= 0
local cCampo	:= ""
local cCampCab:= "C7_FORNECE,C7_LOJA,C7_CONTATO,C7_COND,C7_XNPCORI,C7_CONTRA"
local xEmpInt	:= "01"
local xFilInt	:= "01"
local cPedOri	:= ""

dbSelectArea("SC7")
SC7->(dbsetOrder(1))
IF SC7->(dbseek(xFilial("SC7")+cNumPC))
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
	cXML += '<SC7MASTER modeltype="FIELDS">'
		
	// Montagem das TAGs do cabeçalho
	For i := 1 To FCount()
		cCampo:= FieldName(i)
		IF cCampo$cCampCab 
			U_CIXCONV("SC7",cCampo,@cXML)
		Endif	
	Next
	
	// Montagem das TAGs dos itens
	cXML += '<SC7DETAIL modeltype="GRID">'
	cXML += '<items>'
		
	nItem := 1
	While SC7->(!Eof()) .and. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cNumPC
		cXML += '<item id="'+Alltrim(Str(nItem))+'">'
		// Campos do SC7
		For i := 1 To FCount()
			cCampo:= FieldName(i)
			
			IF !cCampo$cCampCab	
				U_CIXCONV("SC7",cCampo,@cXML)
			ENDIF	
		Next
		
		cXML += '</item>'
		
		nItem++
	SC7->(dbSkip())
	Enddo
	
	cXML += '</items>'
	cXML += '</SC7DETAIL>'
	
	cXML += '</SC7MASTER>'
	cXML += '</'+cFunXml+'>'
	cXML += '</Content>'
	cXML += '</Layouts>'
	cXML += '</Message>'
	cXML += '</TOTVSIntegrator>'
ENDIF

IF nOpcao == 5 
	__cXmlExc:= cXML
ELSE
	cPedOri:= U_CIWSINT(cXml)
	
	if !EMPTY(cPedOri)
		dbSelectArea("SC7")
		SC7->(dbgotop())
		IF SC7->(dbseek(xFilial("SC7")+cNumPC))
			While SC7->(!Eof()) .and. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cNumPC
				RECLOCK("SC7",.F.)
					SC7->C7_XNPCORI:= cPedOri 
				MSUNLOCK()
			SC7->(dbSkip())
			Enddo	
		Endif
	Endif
ENDIF	


RESTAREA(aAreaSC7)
return
