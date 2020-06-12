function beforeStateEntry(sequenceId) {
	var FIM = 10;
	
	if(sequenceId != FIM)
		return;
	
	
	var msgValidacaoNegocio 	= new java.lang.StringBuilder();
	var dadosIntegracao     	= compilarDadosSolicitacao() ;
	var retorno 		    	= integrarSolicitacao(dadosIntegracao) ;
	
    if( retorno["RETORNO"] == "0" ){
    	// Tguardando retorno do chamado
    	// MovAnexoProtheus(sequenceId,dadosIntegracao["DocBranch"]+retorno["ID"],retorno["ANEXOID"]);
    }else{
    	throw retorno["MOTIVO"];
    }	
  	
}

function compilarDadosSolicitacao(){
	var UUID = java.util.UUID.randomUUID();
	var integracao  = [];	
	
	integracao["GlobalProduct"]                     = "TOTVS|EAI";    
	integracao["GlobalFunctionCode"]                = "EAI";               
	integracao["GlobalDocumentFunctionCode"]        = "CEAIA04";
	integracao["GlobalDocumentFunctionDescription"] = "Integracao Fluig x Protheus - Solicit. de compras";
	integracao["DocVersion"] 						= "1.0";
	integracao["DocDateTime"] 					    = consultarDataHoraAtual();
	integracao["DocIdentifier"] 					= UUID;
	integracao["DocCompany"] 						= hAPI.getCardValue("txtEmpresa");
	integracao["DocBranch"] 						= hAPI.getCardValue("txtFilial");
	integracao["DocName"] 						    = "";
	integracao["DocFederalID"] 					    = "";
	integracao["DocType"] 						    = "1";
	integracao["Identifier"]                        = "CEAIA04";
	integracao["Version"]                           = "1.0";
	integracao["FunctionCode"]                      = "U_CEAIA04";
	integracao["ZA1_COD"] 							= getValue("WKNumProces").toString()
	integracao["ZA1_MATRIC"] 						= hAPI.getCardValue("txtMatSolicitante");
	integracao["ZA1_DATA"] 							= ""
	integracao["ZA1_DATA"] 							= hAPI.getCardValue("txtDataSolicitacao");
	integracao["ZA1_RAMAL"] 						= hAPI.getCardValue("txtRamal");
	integracao["ZA1_CR"] 							= hAPI.getCardValue("txtCodCR");
	integracao["ZA1_CRDESC"] 						= hAPI.getCardValue("txtDescricaoCR");
	integracao["ZA1_JUSTIF"] 						= hAPI.getCardValue("dsJustificativa");
	integracao["ZA1_APRO01"] 						= (hAPI.getCardValue("cbSupervisor")== "1"? "1" : "2");
	integracao["ZA1_APRO02"] 						= (hAPI.getCardValue("cbGerencia")== "2"? "1" : "2");
	integracao["ZA1_APRO03"] 						= (hAPI.getCardValue("cbSuperintendencia")== "3"? "1" : "2");
	integracao["ZA1_APRO04"] 						= (hAPI.getCardValue("cbPresidencia")== "4"? "1" : "2");
	integracao["ZA1_APRO05"] 						= (hAPI.getCardValue("cbAreaTecnica")== "5"? "1" : "2");
	integracao["ZA1_RESESP"] 						= hAPI.getCardValue("txtResultadosEsperados");
	integracao["ZA1_VLREST"] 						= hAPI.getCardValue("txtValEstimado");
	integracao["ZA1_PRAZO"] 						= hAPI.getCardValue("txtPrazoDesejado");
	integracao["ZA1_CONSEQ"] 						= hAPI.getCardValue("txtConsequencia");
	integracao["ZA1_AQUCON"] 						= hAPI.getCardValue("rdTpAquiCont");	
	integracao["ITENS"] 							= consultaDadosPaiFilho(["txtSeqItem", "txtDescItem", "txtQtdeItem", "txtUnidItem"]); 			
	return integracao;
}

function consultarDataHoraAtual(){
	var dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	return dateFormat.format(new java.util.Date());
}

function consultaDadosPaiFilho(fields){
	var nr_solicitacao 	= getValue("WKNumProces");
	var cardData   		= hAPI.getCardData(nr_solicitacao);	
	var it         		= cardData.keySet().iterator();
	var listaFilho 		= new Array();
	var fieldTemp  		= fields[0];

	while (it.hasNext()) {
		var key = it.next();
		var campo = key.split("___");		

		if (key.indexOf('___') >= 0 && campo[0] == fieldTemp) {
			var idx = campo[1];
			var row = new Object();
			
			for(var i=0; i<fields.length; i++){
				var name = fields[i] + "___" + idx;
				row[fields[i]] = {value:hAPI.getCardValue(name), idx:idx, name:name};
			}
			listaFilho.push(row);
		}		
	}
	return listaFilho;
}

function integrarSolicitacao(dadosIntegracao) {
	//try {
		var servico 		= ServiceManager.getService("protheus_ciee_axis"); 
        var bean    		= servico.getBean();
        var locator 		= bean.instantiate("_190._2._10._10.CIEELocator");
        var metodos 		= locator.getCIEESOAP();
        var xml		       	= compilarXMLSolicitacao(dadosIntegracao);
        var xmlRetornoItem 	= metodos.FSERVICE(xml);      
        var retorno 		= extrairRetornoXML(xmlRetornoItem);
      
        return retorno;
	/*	
	} catch (e) {
		var msgErro = "Ocorreu um erro ao integrar a solicitação de compras com protheus... " + e.message;
		log.info(msgErro);
		return {erro:msgErro};
	}
	*/
}

function compilarXMLSolicitacao(integracao){
	var itens  		= integracao["ITENS"];
	var xmlItens 	= "<ZA1DETAIL modeltype='FIELDS'>";
	
    for(var j in itens){
    	var item = itens[j];    	
    	xmlItens += '<ITEM id="'+j.toString()+'">';    	
    	xmlItens += "<ZA1_ITEM>" 	+ item.txtSeqItem.value 	+ "</ZA1_ITEM>";
    	xmlItens += "<ZA1_DESC>" 	+ item.txtDescItem.value 	+ "</ZA1_DESC>";
    	xmlItens += "<ZA1_QUANT>" 	+ item.txtQtdeItem.value 	+ "</ZA1_QUANT>";
    	xmlItens += "<ZA1_UM>" 	+ item.txtUnidItem.value 	+ "</ZA1_UM>";
    	xmlItens += "</ITEM>";
    }
    
    xmlItens += "</ZA1DETAIL>";
    
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
						"<CEAIA04 Operation='3' version='1.01'>" +
							"<ZA1MASTER modeltype='FIELDS'>" +							
								"<ZA1_COD>" 	+ integracao["ZA1_COD"] 	+ "</ZA1_COD>" +
								"<ZA1_MATRIC>" 	+ integracao["ZA1_MATRIC"] 	+ "</ZA1_MATRIC>" +
								"<ZA1_DATA>" 	+ integracao["ZA1_DATA"] 	+ "</ZA1_DATA>" +
								"<ZA1_RAMAL>" 	+ integracao["ZA1_RAMAL"] 	+ "</ZA1_RAMAL>" +
								"<ZA1_CR>" 		+ integracao["ZA1_CR"] 		+ "</ZA1_CR>" +
								"<ZA1_CRDESC>" 	+ integracao["ZA1_CRDESC"] 	+ "</ZA1_CRDESC>" +
								"<ZA1_JUSTIF>" 	+ integracao["ZA1_JUSTIF"] 	+ "</ZA1_JUSTIF>" +
								"<ZA1_APRO01>" 	+ integracao["ZA1_APRO01"] 	+ "</ZA1_APRO01>" +
								"<ZA1_APRO02>" 	+ integracao["ZA1_APRO02"] 	+ "</ZA1_APRO02>" +
								"<ZA1_APRO03>" 	+ integracao["ZA1_APRO03"] 	+ "</ZA1_APRO03>" +
								"<ZA1_APRO04>" 	+ integracao["ZA1_APRO04"] 	+ "</ZA1_APRO04>" +
								"<ZA1_APRO05>" 	+ integracao["ZA1_APRO05"] 	+ "</ZA1_APRO05>" +
								"<ZA1_RESESP>" 	+ integracao["ZA1_RESESP"] 	+ "</ZA1_RESESP>" +
								"<ZA1_VLREST>" 	+ integracao["ZA1_VLREST"] 	+ "</ZA1_VLREST>" +
								"<ZA1_PRAZO>" 	+ integracao["ZA1_PRAZO"] 	+ "</ZA1_PRAZO>" +
								"<ZA1_CONSEQ>" 	+ integracao["ZA1_CONSEQ"] 	+ "</ZA1_CONSEQ>" +
								"<ZA1_AQUCON>" 	+ integracao["ZA1_AQUCON"] 	+ "</ZA1_AQUCON>" +								
								 xmlItens +	
							"</ZA1MASTER>" +
						"</CEAIA04>" +					
					"</Content>" +
				"</Layouts>" +
			"</Message>" +
		"</TOTVSIntegrator>";
	
	return xml;	
}

function extrairRetornoXML(strXml){
	var xml = new XML(strXml);
	var retorno = [];
	
	retorno["RETORNO"]= "1";
	retorno["MOTIVO"]= "";
	
	for each(item in xml.LOGMASTER){
		retorno["ID"]		= item.ID;
		retorno["RETORNO"]	= item.RETORNO
		retorno["ANEXOID"]	= item.ANEXOID;
		if(item.RETORNO != "0"){
			retorno["MOTIVO"]=  item.MOTIVO
		}
	}
	
	return retorno;
}

function MovAnexoProtheus(sequenceId,CodDocProtheus,FolderProtheus){
	
if (sequenceId == 4) {
    var calendar = java.util.Calendar.getInstance().getTime();
    var docs = hAPI.listAttachments();
    for (var i = 0; i < docs.size(); i++) {
        var doc = docs.get(i);
         
        if (doc.getDocumentType() != "7") {
            continue;
        }     
        
        doc.setParentDocumentId(FolderProtheus.toint());
        //doc.setDocumentId(1000);
        doc.setDocumentType("3"); 
        doc.setExternalDocumentId(CodDocProtheus);
        //doc.setVersionDescription("Processo: " + getValue("WKNumProces"));
        doc.setExpires(false);
        doc.setCreateDate(calendar);
        doc.setInheritSecurity(true);
        doc.setTopicId(1);
        doc.setUserNotify(false);
        doc.setValidationStartDate(calendar);
        doc.setVersionOption("0");
        //doc.setDocumentDescription("Sol. Baixa e Transf. Processo: " + getValue("WKNumProces"));
        doc.setUpdateIsoProperties(true);
       
        hAPI.publishWorkflowAttachment(doc);
    }
}
	
}