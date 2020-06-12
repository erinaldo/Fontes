function integrarBaixa(dadosIntegracao) {
	try {
		var servico = ServiceManager.getService("protheus_ciee_axis"); 
        var bean    = servico.getBean();
        var locator = bean.instantiate("_190._2._10._10.CIEELocator");
        var metodos = locator.getCIEESOAP();
        var itens  	= dadosIntegracao["ITENS"];
        var retorno = {};
        
        for(var j in itens){
        	var item 		   = itens[j];
	        var xml		       = compilarXMLBaixa(dadosIntegracao, item);
	        var xmlRetornoItem = metodos.FSERVICE(xml);      
			var msgRetornoItem = extrairRetornoXML(xmlRetornoItem);
			
			log.info("=>>>>>>>>>>>>>> msgRetornoItem: " + msgRetornoItem);
			
			if(msgRetornoItem){				
				var nmCodBem   = item.ativoCodBem.name;
				var cdBem  	   = item.ativoCodBem.value;
				retorno[cdBem] = {name:nmCodBem, msg:msgRetornoItem};
			}
		}     
		
		return retorno;
	} catch (e) {
		var msgErro = "Ocorreu um erro ao integrar com protheus (Baixa)... " + e.message;
		log.info(msgErro);
		return {erro:msgErro};
	}
}

function compilarXMLBaixa(integracao, item){
	var ativoCodBem = item.ativoCodBem.value;
	var ativoItem   = item.ativoItem.value;
	var ativoQtdade = item.ativoQtdade.value;
	var ativoPlaqueta = item.ativoPlaqueta.value;
	
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
						"<CEAIA27 Operation='3' version='1.01'>" +
							"<SNMMASTER modeltype='FIELDS'>" +							
								"<NM_XCODFOR>" + integracao["NM_XCODFOR"] + "</NM_XCODFOR>" +
								"<NM_CBASE>"   + ativoCodBem 			  + "</NM_CBASE>" +
								"<NM_ITEM>"    + ativoItem   			  + "</NM_ITEM>" +	
								"<NM_QTDBX>"   + ativoQtdade 			  + "</NM_QTDBX>" +								
								"<NM_MOTBX>"   + integracao["NM_MOTBX"]   + "</NM_MOTBX>" +
								"<NM_LOCAL>"   + integracao["NM_LOCAL"]   + "</NM_LOCAL>" +						 
								"<NM_CDHSOL>"  + integracao["NM_CDHSOL"]  + "</NM_CDHSOL>" +
								"<NM_XMATRIC>" + integracao["NM_XMATRIC"] + "</NM_XMATRIC>" +		
								"<NM_XNOMENT>" + integracao["NM_XNOMENT"] + "</NM_XNOMENT>" +
								"<NM_XCGCENT>" + integracao["NM_XCGCENT"] + "</NM_XCGCENT>" +
							"</SNMMASTER>" +
						"</CEAIA27>" +					
					"</Content>" +
				"</Layouts>" +
			"</Message>" +
		"</TOTVSIntegrator>";
	return xml;	
}

function extrairRetornoXML(strXml){
	var xml = new XML(strXml);
	var msgRetorno = "";
	
	for each(item in xml.LOGMASTER){
		if(item.MOTIVO != "")
			msgRetorno = msgRetorno.concat(item.MOTIVO + "\n");
		
	}
	return msgRetorno;
}