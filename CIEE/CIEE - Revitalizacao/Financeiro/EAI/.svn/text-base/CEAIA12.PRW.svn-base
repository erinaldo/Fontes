#INCLUDE "TOTVS.CH"
/*---------------------------------------------------------------------------------------
{Protheus.doc} CEAIA12
Envia XML com resultado da conciliação dos créditos identificados e não identificados.

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     AF Custom
@version    P.11
@since      01/10/2014
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project    CIEE - Revitalização
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
user function CEAIA12(cKeyFol)
local oXml		:= nil
local cError   	:= ""
local cWarning 	:= ""
local cDelimit 	:= "_"
local cXml		:= ""               
local cFunXml	:= "CEAIA12"
local cDescXml 	:= "Movimentacao da Folha de Pagamento"  
local cData    	:= Dtos(Date())
local cHora    	:= Time()
local aNoCampCb := {}      
local aNoCampIt := {} 
local cCampo	:= ""
local nIdIt		:= 1
local xValor	:= nil
Local cDateTime := Transform(cData,"@R 9999-99-99")+"T"+cHora+"Z"

dbselectarea("ZA5")
dbsetorder(1)
if dbseek(cKeyFol)

	cXml += '<TOTVSIntegrator>'
	cXml += '<GlobalProduct>TOTVS</GlobalProduct>'
	cXml += '<GlobalFunctionCode>EAI</GlobalFunctionCode>'
	cXml += '<GlobalDocumentFunctionCode>CEAIA12</GlobalDocumentFunctionCode>'
	cXml += '<GlobalDocumentFunctionDescription>Folha de Pagamento</GlobalDocumentFunctionDescription>'
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
	cXml+= '<'+cFunXml+' Operation="4" version="1.01">'
	cXml+= '	<ZA5MASTER modeltype="FIELDS">'

	FOR nCnta := 1 TO ZA5->(FCOUNT())
		if ascan(aNoCampCb,{|x| trim(x[2])==cCampo }) == 0 	    		
			cCampo:= TRIM(ZA5->(FIELDNAME(nCnta)))
			xValor:= ZA5->&(cCampo) 
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

	cXml+= '		<ZA6DETAIL modeltype="GRID">'                                                                                      
	cXml+= '			<items>'

	dbselectarea("ZA6")
	dbsetorder(1)
	dbseek(cKeyFol)
	while ZA6->(!eof()) .and. ZA6->(ZA6_FILIAL+ZA6_COD)==cKeyFol
	                            
		cXml+= '			  <item id="'+strzero(nIdIt,3)+'">'
		
		FOR nCnta := 1 TO ZA6->(FCOUNT())
			if ascan(aNoCampCb,{|x| trim(x[2])==cCampo }) == 0 	    		
				cCampo:= TRIM(ZA6->(FIELDNAME(nCnta)))
				xValor:= ZA6->&(cCampo) 
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
		
		cXml+= '			  </item>'	
		
		nIdIt++
			
	ZA6->(dbskip())
	end	
					                                                                               			
	cXml+= '		  </items>'		                                                                                          
	cXml+= '		</ZA6DETAIL>'                                                                                                      
	cXml+= '	</ZA5MASTER>'                                                                                                          
	cXml+= '</'+cFunXml+'>' 
	cXml+= '</Content>'
	cXml+= '</Layouts>'
	cXml+= '</Message>'
	cXml+= '</TOTVSIntegrator>'   

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
		
endif

RETURN