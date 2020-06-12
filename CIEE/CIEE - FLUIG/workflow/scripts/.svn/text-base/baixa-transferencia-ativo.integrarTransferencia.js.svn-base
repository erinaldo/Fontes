function integrarTransferencia(dadosIntegracao) {
	try {
		var servico = ServiceManager.getService("protheus_ciee_axis"); 
        var bean    = servico.getBean();
        var locator = bean.instantiate("_190._2._10._10.CIEELocator");
        var metodos = locator.getCIEESOAP();
        var itens  	= dadosIntegracao["ITENS"];
        var retorno = {};

        for(var j in itens){
        	var item 		   = itens[j];
	        var xml		       = compilarXMLTransferencia(dadosIntegracao, item);
	        var xmlRetornoItem = metodos.FSERVICE(xml);      
			var msgRetornoItem = extrairRetornoXML(xmlRetornoItem);
			
			if(msgRetornoItem){	
				var nmCodBem   = item.ativoCodBem.name;
				var cdBem  	   = item.ativoCodBem.value;
				retorno[cdBem] = {name:nmCodBem, msg:msgRetornoItem};
			}
		}
		return retorno;
	} catch (e) {
		var msgErro = "Ocorreu um erro ao integrar com protheus (Transferencia)... " + e.message;
		log.info(msgErro);
		return {erro:msgErro};
	}	
}

function compilarXMLTransferencia(integracao, item){
	var ativoCodBem = item.ativoCodBem.value;
	var ativoItem   = item.ativoItem.value;
	//var ativoCCusto = item.ativoCCusto.value;
		
	var xml = 
		"<TOTVSIntegrator>" + 
			"<GlobalProduct>"                     + integracao["GlobalProduct"]                     + "</GlobalProduct>" +
			"<GlobalFunctionCode>"                + integracao["GlobalFunctionCode"]                + "</GlobalFunctionCode>" +
			"<GlobalDocumentFunctionCode>"        + integracao["GlobalDocumentFunctionCode"]        + "</GlobalDocumentFunctionCode>" +
			"<GlobalDocumentFunctionDescription>" + integracao["GlobalDocumentFunctionDescription"] + "</GlobalDocumentFunctionDescription>" +
			"<DocVersion>"                        + integracao["DocVersion"] 						+ "</DocVersion>" +
			"<DocDateTime>"                       + integracao["DocDateTime"] 					    + "</DocDateTime>" +   
			"<DocIdentifier>"                     + integracao["DocIdentifier"] 					+ "</DocIdentifier>" + 
			"<DocCompany>"                        + integracao["DocCompany"] 						+ "</DocCompany>" +    
			"<DocBranch>"                         + integracao["DocBranch"] 						+ "</DocBranch>" +     
			"<DocName>"                           + integracao["DocName"] 						    + "</DocName>" +	   
			"<DocFederalID>"                      + integracao["DocFederalID"] 					    + "</DocFederalID>" +
			"<DocType>"                           + integracao["DocType"] 						    + "</DocType>" +
			"<Message>" +
				"<Layouts>" +
					"<Identifier>"   + integracao["Identifier"]   + "</Identifier>" +
					"<Version>"      + integracao["Version"]      + "</Version>" +
					"<FunctionCode>" + integracao["FunctionCode"] + "</FunctionCode>" +					  
					"<Content>" +
						"<CEAIA28 Operation='5' version='1.01'>" +
							"<SNMMASTER modeltype='FIELDS'>" +
								"<NM_XCODFOR>" + integracao["NM_XCODFOR"] + "</NM_XCODFOR>" +
								"<NM_CBASE>"   + ativoCodBem   			  + "</NM_CBASE>" +
								"<NM_ITEM>"    + ativoItem   			  + "</NM_ITEM>" +								
								"<NM_CCUSTO>"  + integracao["NM_CCUSTO"]  + "</NM_CCUSTO>" +
								"<NM_LOCAL>"   + integracao["NM_LOCAL"]   + "</NM_LOCAL>" +
								"<NM_CDHSOL>"  + integracao["NM_CDHSOL"]  + "</NM_CDHSOL>" +			
								"<NM_XMATRIC>" + integracao["NM_XMATRIC"] + "</NM_XMATRIC>" +
							"</SNMMASTER>" +
						"</CEAIA28>" +						
					"</Content>" +
				"</Layouts>" +
			"</Message>" +
		"</TOTVSIntegrator>";
	return xml;
}