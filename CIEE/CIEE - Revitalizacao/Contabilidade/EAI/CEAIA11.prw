#include "Protheus.ch"
#include "TopConn.ch"

/*---------------------------------------------------------------------------------------
{Protheus.doc} CEAIA11
Rotina de integração - Centro de custos

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib   	Nenhum
@protected	Nenhum
@author  	Totvs
@version  	P.11
@since   	01/10/2014
@return  	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project 	CIEE - Revitalização
@menu    	Nenhum
@history 	Nenhum
---------------------------------------------------------------------------------------*/
User Function CEAIA11(nTipo)
local aAreaCTT	:= CTT->(GETAREA())
local oXml			:= nil
local cError  	:= ""
local cWarning 	:= ""
local cDelimit 	:= "_"
local cXml			:= ""               
local cFunXml		:= "CEAIA11"
local cDescXml 	:= "Centro de custo"  
local cData    	:= Dtos(Date())
local cHora    	:= Time()
local aNoCampCb 	:= {}      
local aNoCampIt 	:= {} 
local cCampo		:= ""
local nIdIt		:= 1
local xValor		:= nil
Local cDateTime 	:= Transform(cData,"@R 9999-99-99")+"T"+cHora+"Z"


cXml += '<TOTVSIntegrator>'
cXml += '<GlobalProduct>TOTVS</GlobalProduct>'
cXml += '<GlobalFunctionCode>EAI</GlobalFunctionCode>'
cXml += '<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'
cXml += '<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'
cXml += '<DocVersion>1.0</DocVersion>'
cXML += '<DocDateTime>'+cDateTime+'</DocDateTime>'
cXML += '<DocIdentifier></DocIdentifier>'
cXML += '<DocCompany>'+cEmpAnt+'</DocCompany>'
cXML += '<DocBranch>'+cFilAnt+'</DocBranch>'
cXml += '<DocName></DocName>'
cXml += '<DocFederalID></DocFederalID>'
cXml += '<DocType>2</DocType>'
cXml += '<Message>'
cXml += '<Layouts>'
cXml += '<Identifier>'+cFunXml+'</Identifier>'
cXml += '<Version>1.0</Version>'
cXml += '<FunctionCode>U_'+cFunXml+'</FunctionCode>'
cXml += '<Content>'
cXml+= '<'+cFunXml+' Operation="'+cvaltochar(nTipo)+'" version="1.01">'
cXml+= '	<CTTMASTER modeltype="FIELDS">'

FOR nCnta := 1 TO CTT->(FCOUNT())
	if ascan(aNoCampCb,{|x| trim(x[2])==cCampo }) == 0 	    		
		cCampo:= TRIM(CTT->(FIELDNAME(nCnta)))
		xValor:= CTT->&(cCampo) 
		//varinfo("xValor=>",xValor)
		if valtype(xValor) == "C"
			xValor := TRIM(xValor)
		elseif valtype(xValor) == "N"
			xValor := TRIM(Transform(xValor,"@E 999,999,999.99"))
		elseif valtype(xValor) == "D"
			xValor := Dtoc(xValor)
		else
			xValor := ""				
		endif		    
		
		cXml+= '		<'+cCampo+'><value>'+xValor+'	</value></'+cCampo+'>'
	endif	
NEXT nCnta   

cXml+='	</CTTMASTER>'
cXml+='</'+cFunXml+'>' 
cXml+='<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'
cXml+='<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>	'
cXml+='</TOTVSIntegrator>'      

// Valida xml                  
oXml := XmlParser(cXML, cDelimit, @cError, @cWarning)

if (Empty(cError) .and. Empty(cWarning))  
	U_CESBENV(cFunXml,cDescXml,cXml)	    
else		
	if !Empty(cError) 
		conout(cFunXml+" - Erro na estrutura do xml")
    endif

	if !Empty(cWarning)                        
		conout(cFunXml+" - "+cWarning)
	endif    	
endif 

RESTAREA(aAreaCTT)
return