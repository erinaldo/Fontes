#Include "Totvs.ch"

/*---------------------------------------------------------------
Função:		 	    Autor:  						  Data:
CEAII007			DDLR							  08/12/2014
----------------------------------------------------------------
Objetivo:
Função criada para a integração do Protheus x SOE, envio 
da baixa do titulo a receber incluído no Protheus através da rotina                                                   
padrão FINA070 via cadastro de Adapter EAI.

Parâmetros:
cKeyDul -> Chave da duplicata que deve ser enviada para o SOE.
--------------------------------------------------------------*/
User Function CEAII007( cKeyDul )    

Local cXml		:= ""
Local cError   	:= ""
Local cWarning 	:= "" 

Local cDelimit 	:= "_"

Local cAlias    := "SE1"      
Local cFunXml	:= "FINA070"
Local cMsgXml   := "CEAII007"
Local cDescXml 	:= "Baixas a receber"  

Local aInfo := {}

Local nCnta := 0

Local cData   	:= Dtos( Date() )
Local cHora    	:= Time()
Local cDateTime := Transform( cData, "@R 9999-99-99" ) + "T" + cHora + "Z"

Local oXml := Nil

Dbselectarea( cAlias )
(cAlias)->( Dbsetorder(1) )
If (cAlias)->( MsSeek( cKeyDul ) ) 
    
	//Cabecalho do XML
	cXml += '<TOTVSIntegrator>'
	cXml += 	'<GlobalProduct>TOTVS|EAI</GlobalProduct>'
	cXml += 	'<GlobalFunctionCode>EAI</GlobalFunctionCode>'
	cXml += 	'<GlobalDocumentFunctionCode>' + cFunXml + '</GlobalDocumentFunctionCode>'
	cXml += 	'<GlobalDocumentFunctionDescription>' + cDescXml + '</GlobalDocumentFunctionDescription>'
	cXml += 	'<DocVersion>1.0</DocVersion>'
	cXML += 	'<DocDateTime>' + cDateTime + '</DocDateTime>'
	cXML += 	'<DocIdentifier></DocIdentifier>'
	cXML += 	'<DocCompany>' + cEmpAnt + '</DocCompany>'
	cXML += 	'<DocBranch>' + cFilAnt + '</DocBranch>'
	cXml += 	'<DocName></DocName>'
	cXml += 	'<DocFederalID></DocFederalID>'     
	cXml += 	'<DocType>2</DocType>'
	cXml += 	'<Message>'
	cXml += 		'<Layouts>'
	cXml += 			'<Identifier>' + cFunXml + '</Identifier>'
	cXml += 			'<Version>1.0</Version>'
	cXml += 			'<FunctionCode>U_' + cMsgXml + '</FunctionCode>'
	cXml += 			'<Content>'
	cXml += 				'<' + cFunXml + ' Operation="3" version="1.01">'    
	cXml += 					'<' + cAlias + 'MASTER modeltype="FIELDS">'
	
	For nCnta := 1 To (cAlias)->( FCount() ) 
	    //Não deve ser gerado o campo de filial para o XML
		If (cAlias)->( FieldName( nCnta ) ) <> "E1_FILIAL"	
				     
			//Funcao que retorna os campos a serem gerados no XML
		    aInfo := U_FRetXmlCmp( cAlias, nCnta )  
			
			//Atribuindo TAG referente ao campo no XML
			cXml+= '<' + aInfo[1] + ' order="1"> '
			cXml+= 		'<value>' + aInfo[2] + '</value>'
			cXml+= '</' + aInfo[1] + '>'             
			
		EndIf					 		
	Next nCnta        
		                                                                                          
	cXml+= 						'</' + cAlias + 'MASTER>'                                                                                                          
	cXml+= 					'</' + cFunXml + '>' 
	cXml+= 				'</Content>'
	cXml+= 			'</Layouts>'
	cXml+= 		'</Message>'
	cXml+= '</TOTVSIntegrator>'   

    // Valida xml                  
	oXml := XmlParser( cXML, cDelimit, @cError, @cWarning )
	
	If ( Empty( cError ) .And. Empty( cWarning ) )  
	   	U_CEAIENV( cMsgXml, cDescXml, cXml )     
	
	Else		
		If !Empty( cError ) 
			Conout( cFunXml + " - Erro na estrutura do xml" )
	    EndIf
	
		If !Empty( cWarning )                        
			Conout( cFunXml + " - " + cWarning )
		EndIf    	
	EndIf 		
EndIf

Return ( Nil ) 
                      
/*---------------------------------------------------------------
Função:		 	    Autor:  						  Data:
CEAIE007			DDLR							  08/12/2014
----------------------------------------------------------------
Objetivo:
Função criada para a integração do Protheus x SOE, envio 
da baixa do titulo a receber excluido no Protheus através da rotina                                                   
padrão FINA070 via cadastro de Adapter EAI.

Parâmetros:
cKeyDul -> Chave da duplicata que deve ser enviada para o SOE.
--------------------------------------------------------------*/
User Function CEAIE007( cKeyDul )    

Local cXml		:= ""
Local cError   	:= ""
Local cWarning 	:= "" 

Local cDelimit 	:= "_"

Local cAlias    := "SE1"      
Local cFunXml	:= "FINA070"
Local cMsgXml   := "CEAIE007"
Local cDescXml 	:= "Baixas a receber"  

Local aInfo := {}

Local nCnta := 0

Local cData   	:= Dtos( Date() )
Local cHora    	:= Time()
Local cDateTime := Transform( cData, "@R 9999-99-99" ) + "T" + cHora + "Z"

Local oXml := Nil

Dbselectarea( cAlias )
(cAlias)->( Dbsetorder(1) )
If (cAlias)->( MsSeek( cKeyDul ) ) 
    
	//Cabecalho do XML
	cXml += '<TOTVSIntegrator>'
	cXml += 	'<GlobalProduct>TOTVS|EAI</GlobalProduct>'
	cXml += 	'<GlobalFunctionCode>EAI</GlobalFunctionCode>'
	cXml += 	'<GlobalDocumentFunctionCode>' + cFunXml + '</GlobalDocumentFunctionCode>'
	cXml += 	'<GlobalDocumentFunctionDescription>' + cDescXml + '</GlobalDocumentFunctionDescription>'
	cXml += 	'<DocVersion>1.0</DocVersion>'
	cXML += 	'<DocDateTime>' + cDateTime + '</DocDateTime>'
	cXML += 	'<DocIdentifier></DocIdentifier>'
	cXML += 	'<DocCompany>' + cEmpAnt + '</DocCompany>'
	cXML += 	'<DocBranch>' + cFilAnt + '</DocBranch>'
	cXml += 	'<DocName></DocName>'
	cXml += 	'<DocFederalID></DocFederalID>'     
	cXml += 	'<DocType>2</DocType>'
	cXml += 	'<Message>'
	cXml += 		'<Layouts>'
	cXml += 			'<Identifier>' + cFunXml + '</Identifier>'
	cXml += 			'<Version>1.0</Version>'
	cXml += 			'<FunctionCode>U_' + cMsgXml + '</FunctionCode>'
	cXml += 			'<Content>'
	cXml += 				'<' + cFunXml + ' Operation="5" version="1.01">'    
	cXml += 					'<' + cAlias + 'MASTER modeltype="FIELDS">'
	
	For nCnta := 1 To (cAlias)->( FCount() ) 

	    //Não deve ser gerado o campo de filial para o XML
		If (cAlias)->( FieldName( nCnta ) ) <> "E1_FILIAL"	
			     
			//Funcao que retorna os campos a serem gerados no XML
		    aInfo := U_FRetXmlCmp( cAlias, nCnta )  
			
			//Atribuindo TAG referente ao campo no XML
			cXml+= '<' + aInfo[1] + ' order="1"> '
			cXml+= 		'<value>' + aInfo[2] + '</value>'
			cXml+= '</' + aInfo[1] + '>'
		EndIf
					 		
	Next nCnta        
		                                                                                          
	cXml+= 						'</' + cAlias + 'MASTER>'                                                                                                          
	cXml+= 					'</' + cFunXml + '>' 
	cXml+= 				'</Content>'
	cXml+= 			'</Layouts>'
	cXml+= 		'</Message>'
	cXml+= '</TOTVSIntegrator>'   

    // Valida xml                  
	oXml := XmlParser( cXML, cDelimit, @cError, @cWarning )
	
	If ( Empty( cError ) .And. Empty( cWarning ) )  
	   	U_CEAIENV( cMsgXml, cDescXml, cXml )     
	
	Else		
		If !Empty( cError ) 
			Conout( cFunXml + " - Erro na estrutura do xml" )
	    EndIf
	
		If !Empty( cWarning )                        
			Conout( cFunXml + " - " + cWarning )
		EndIf    	
	EndIf 		
EndIf

Return ( Nil ) 






