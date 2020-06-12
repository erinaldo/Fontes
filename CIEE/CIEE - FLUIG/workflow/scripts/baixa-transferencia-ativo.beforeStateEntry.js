function beforeStateEntry(sequenceId) {
	var FIM = 4;
	
	if(sequenceId != FIM)
		return;

	var motivoRoubo = (hAPI.getCardValue("slMotivoBaixa") == "roubo");
	var msgValidacaoNegocio = new java.lang.StringBuilder();
	if(motivoRoubo)
		msgValidacaoNegocio.append(validarAoMenosUmAnexoSolicitacao());
		
	var existeValidacaoNegocio = !(msgValidacaoNegocio.toString().equals(""));
	if(existeValidacaoNegocio)
		throw  msgValidacaoNegocio;
	
	var integracaoBaixa  = (hAPI.getCardValue("rdTpSolicitacao") == "1");
	
	log.info("Integrando...");
	log.info("Tipo... " + (integracaoBaixa?"Baixa":"Transferencia"));
	
	var dadosIntegracao        = (integracaoBaixa? compilarDadosIntegracaoBaixa() : compilarDadosIntegracaoTransferencia());
	var retorno 		       = (integracaoBaixa? integrarBaixa(dadosIntegracao) : integrarTransferencia(dadosIntegracao));
	var MsgSubject			   = (integracaoBaixa? "Solicita\u00e7\u00e3o de baixa" : "Solicita\u00e7\u00e3o de Transfer\u00eancia" );
	var MsgHtml			   	   = (integracaoBaixa? "Solicita&ccedil;&atilde;o de baixa de bens" : "Solicita&ccedil;&atilde;o de transfer&ecirc;ncia de bens" );
	var existeErroDesconhecido = retorno["erro"];
	var msgNegocio             = "";
	
	if(existeErroDesconhecido) {
		throw retorno["erro"];
	}
	
	MovAnexoProtheus(sequenceId,"0001"+getValue("WKNumProces").toString());
	
	var tabela = '';
	tabela += '<table height="19" width="100%" cellspacing="0">';
	tabela += '<tbody>';
	tabela += '<tr><td class="TitleSmall" align="center" height="15" width="100%"></td>';
	tabela += '</tr>';
	tabela += '<tr><td class="TitleSmall" align="Left" height="15" width="100%" bgcolor="#000000"><b><i><font face="Arial" size="3" color="#FFFFFF">'+MsgHtml+'</font></i></b></td>';
	tabela += '</tr>';
	tabela += '</tbody>';
	tabela += '</table>';	
	tabela += '<table style="width: 100%;" border="0" cellspacing="1">';
	tabela += '<tr>';
	tabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">';
	tabela += '<font face="Arial" size="2" color="#000000">C. Custo</font></td>';
	tabela += '<td  class="TableRowBlueDarkMini" align="center" width="10%">';
	tabela += '<font face="Arial" size="2" color="#000000">Plaqueta</font></td>';
	tabela += '<td class="TableRowBlueDarkMini" align="center" width="15%">';
	tabela += '<font face="Arial" size="2" color="#000000">Descri&ccedil;&atilde;o (Ativo)</font></td>';
	tabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">';
	tabela += '<font face="Arial" size="2" color="#000000">Cod. Do Bem</font></td>';
	tabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">';
	tabela += '<font face="Arial" size="2" color="#000000">Item</font></td>';
	tabela += '<td  class="TableRowBlueDarkMini" align="center" width="10%">';
	tabela += '<font face="Arial" size="2" color="#000000">Qtdade.</font></td>';
	tabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">';
	tabela += '<font face="Arial" size="2" color="#000000">Dt. Aquisi&ccedil;&atilde;o</font></td>';
	tabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">';
	tabela += '<font face="Arial" size="2" color="#000000">Status</font></td>';
	tabela += '<td class="TableRowBlueDarkMini" align="center" width="15%">';
	tabela += '<font face="Arial" size="2" color="#000000">Mensagem</font></td>';
	tabela += '</tr>';
	tabela += '<tbody>';
	
	
	for(var i in dadosIntegracao["ITENS"]){
		var cdBem    = dadosIntegracao["ITENS"][i].ativoCodBem.value;
		var nmCodBem = dadosIntegracao["ITENS"][i].ativoCodBem.name;
		
		var existeErroNegocio = (retorno[cdBem]!=undefined);
		
		if(existeErroNegocio){
			var msgNegocioItem  = "\nBem: " + cdBem + ",  " + retorno[cdBem].msg; 
			msgValidacaoNegocio.append(msgNegocioItem);
		}
		hAPI.setCardValue(nmCodBem, (existeErroNegocio?"NOK":"OK"));
		
		tabela += '<tr>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">';
		tabela += '<font face="Arial" size="2">' + dadosIntegracao["ITENS"][i].ativoCCusto.value + '</font></p></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">';
		tabela += '<font face="Arial" size="2">' + dadosIntegracao["ITENS"][i].ativoPlaqueta.value + '</font></p></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px">';
		tabela += '<font face="Arial" size="2">' + dadosIntegracao["ITENS"][i].ativoDescricao.value + '</font></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">';
		tabela += '<font face="Arial" size="2">' + dadosIntegracao["ITENS"][i].ativoCodBem.value + '</font></p></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">';
		tabela += '<font face="Arial" size="2">' + dadosIntegracao["ITENS"][i].ativoItem.value + '</font></p></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">';
		tabela += '<font face="Arial" size="2">' + dadosIntegracao["ITENS"][i].ativoQtdade.value + '</font></p></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">';
		tabela += '<font face="Arial" size="2">' + dadosIntegracao["ITENS"][i].ativoDtAquisicao.value + '</font></p></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">';
		tabela += '<font face="Arial" size="2">' + (!existeErroNegocio ? 'Realizado' : 'N&atilde;o realizado') + '</font></p></td>';
		tabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px">';
		tabela += '<font face="Arial" size="2">' + (!existeErroNegocio ? '' : retorno[cdBem].msg) + '</font></td>';
		tabela += '</tr>';
	}
	
	existeValidacaoNegocio = !(msgValidacaoNegocio.toString().equals(""));
	//if(existeValidacaoNegocio)
	//	throw  msgValidacaoNegocio;
	
	tabela += '</tbody>';
	tabela += '</table>';
	
	
	var parametros = new java.util.HashMap();
	parametros.put("WDK_NumProcess", getValue("WKNumProces"));
	parametros.put("WDK_CompanyId", getValue("WKCompany"));
	parametros.put("WDK_Tabela_Ativos", tabela);
	
	parametros.put("subject", MsgSubject);	
	
	var destinatarios = new java.util.ArrayList();
	destinatarios.add(hAPI.getCardValue("txtMatSolicitante"));
	
	if (!existeErroNegocio) {
		if (hAPI.getCardValue("txtMatSuperior").isEmpty() == false){
			destinatarios.add(hAPI.getCardValue("txtMatSuperior"));	
		}	
		
		if (hAPI.getCardValue("txtMatAtf").isEmpty() == false){
			destinatarios.add(hAPI.getCardValue("txtMatAtf"));	
		}		
	}
    
	notifier.notify(getValue("WKUser"), "tpl-custom-baixa-transferencia", parametros, destinatarios, "text/html");
	
}

function validarAoMenosUmAnexoSolicitacao(){
	var atividadeInicio     = 1;
	var nrSolicitacao       = getValue("WKNumProces");
	var anexosSolicitacao   = consultarAnexosSolicitacaoPorAtividade(nrSolicitacao, atividadeInicio);
	var aoMenosUmAnexo      = (anexosSolicitacao.rowsCount > 1);
	var msgValidacaoNegocio = "";
	if(!aoMenosUmAnexo)
		msgValidacaoNegocio = "É preciso adicionar ao menos um arquivo anexo quando o motivo da solicitação for Roubo";
	
	return msgValidacaoNegocio;
}

function consultarAnexosSolicitacaoPorAtividade(nrSolicitacao, atividade){
	var empresa           = getValue("WKCompany");
	var processConstraint = DatasetFactory.createConstraint("processAttachmentPK.processInstanceId", nrSolicitacao, nrSolicitacao, ConstraintType.MUST);
	var companyConstraint = DatasetFactory.createConstraint("processAttachmentPK.companyId", empresa, empresa, ConstraintType.MUST);
	var movConstraint     = DatasetFactory.createConstraint("originalMovementSequence", atividade, atividade, ConstraintType.MUST);
	var attachFields      = new Array("documentId","processAttachmentPK.attachmentSequence");
	var attachConstList   = new Array(processConstraint, companyConstraint, movConstraint);
	var attachDataset     = DatasetFactory.getDataset("processAttachment", attachFields, attachConstList, new Array("processAttachmentPK.attachmentSequence"));
	return attachDataset;
}

function compilarDadosIntegracaoBaixa(){
	var UUID = java.util.UUID.randomUUID();
	var integracao  = [];	
	integracao["GlobalProduct"]                     = "TOTVS|EAI";    
	integracao["GlobalFunctionCode"]                = "EAI";               
	integracao["GlobalDocumentFunctionCode"]        = "CEAIA27";
	integracao["GlobalDocumentFunctionDescription"] = "Integracao Fluig x Protheus - Baixa";
	integracao["DocVersion"] 						= "1.0";
	integracao["DocDateTime"] 					    = consultarDataHoraAtual();
	integracao["DocIdentifier"] 					= UUID;
	integracao["DocCompany"] 						= hAPI.getCardValue("txtEmpresa");
	integracao["DocBranch"] 						= hAPI.getCardValue("txtFilial");
	integracao["DocName"] 						    = "";
	integracao["DocFederalID"] 					    = "";
	integracao["DocType"] 						    = "1";

	integracao["Identifier"]                        = "CEAIA27";
	integracao["Version"]                           = "1.0";
	integracao["FunctionCode"]                      = "U_CEAIA27";
	
	integracao["NM_XCODFOR"] 						= getValue("WKNumProces").toString();
	integracao["NM_LOCAL"] 						    = hAPI.getCardValue("dsLocalizacaoTransf");
	integracao["NM_XMATRIC"] 						= hAPI.getCardValue("txtMatSolicitante");
	integracao["NM_MOTBX"] 						    = "0" + hAPI.getCardValue("slMotivoBaixa");
	integracao["NM_CDHSOL"] 						= "<![CDATA[" + new java.lang.String(hAPI.getCardValue("dsHistSolic").getBytes("UTF-8"), "ISO-8859-1") + "]]>";
	
	/* CAMPOS DOACAO */
	integracao["NM_XNOMENT"]						= hAPI.getCardValue("nmEntidadeReceptora");
	integracao["NM_XCGCENT"]						= hAPI.getCardValue("numCnpjReceptora");
	
	var dadosPaiFilho = consultaDadosPaiFilho(["ativoCodBem", "ativoItem", "ativoQtdade", "ativoPlaqueta", "ativoDescricao", "ativoCCusto", "ativoDtAquisicao"]);
	integracao["ITENS"] = dadosPaiFilho; 			
	return integracao;
}

function compilarDadosIntegracaoTransferencia(){
	var UUID = java.util.UUID.randomUUID();
	var integracao  = [];	
	integracao["GlobalProduct"]                     = "TOTVS|EAI";      
	integracao["GlobalFunctionCode"]                = "EAI";               
	integracao["GlobalDocumentFunctionCode"]        = "CEAIA28";
	integracao["GlobalDocumentFunctionDescription"] = "Integracao Fluig x Protheus - Transferência";
	integracao["DocVersion"] 						= "1.0";
	integracao["DocDateTime"] 					    = consultarDataHoraAtual();
	integracao["DocIdentifier"] 					= UUID;
	integracao["DocCompany"] 						= hAPI.getCardValue("txtEmpresa");
	integracao["DocBranch"] 						= hAPI.getCardValue("txtFilial");
	integracao["DocName"] 						    = ""; 
	integracao["DocFederalID"] 					    = "";
	integracao["DocType"] 						    = "1";

	integracao["Identifier"]                        = "CEAIA28";
	integracao["Version"]                           = "1.0";
	integracao["FunctionCode"]                      = "U_CEAIA28";
	
	integracao["NM_XCODFOR"] 						= getValue("WKNumProces").toString();
	
	integracao["NM_CCUSTO"] 						= hAPI.getCardValue("cdCcustoTransf");
	integracao["NM_LOCAL"] 						    = hAPI.getCardValue("cdLocalizacaoTransf");
	integracao["NM_XMATRIC"] 						= hAPI.getCardValue("txtMatSolicitante");
	integracao["NM_MOTBX"] 						    = "0" + hAPI.getCardValue("slMotivoBaixa");
	integracao["NM_CDHSOL"] 						= "<![CDATA[" + new java.lang.String(hAPI.getCardValue("dsHistSolic").getBytes("UTF-8"), "ISO-8859-1") + "]]>";
	
	var dadosPaiFilho = consultaDadosPaiFilho(["ativoCodBem", "ativoItem", "ativoCCusto", "ativoPlaqueta", "ativoDescricao", "ativoQtdade", "ativoDtAquisicao"]);
	integracao["ITENS"] = dadosPaiFilho;  	
	return integracao;
}

function consultarDataHoraAtual(){
	var dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	return dateFormat.format(new java.util.Date());
}

function consultaDadosPaiFilho(fields){
	var nr_solicitacao = getValue("WKNumProces");
	var cardData   = hAPI.getCardData(nr_solicitacao);	
	var it         = cardData.keySet().iterator();
	var listaFilho = new Array();
	var fieldTemp  = fields[0];

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

function MovAnexoProtheus(sequenceId,CodDocProtheus){

log.info("Movendo anexo....");

if (sequenceId == 4) {
    var calendar = java.util.Calendar.getInstance().getTime();
    var docs = hAPI.listAttachments();
    for (var i = 0; i < docs.size(); i++) {
        var doc = docs.get(i);
         
        if (doc.getDocumentType() != "7") {
            continue;
        }
        
        log.info(doc);
        
        doc.setParentDocumentId(178);
        doc.setDocumentType("3"); // 
        doc.setVersionDescription("Processo: " + getValue("WKNumProces"));
        doc.setExpires(false);
        doc.setCreateDate(calendar);
        doc.setInheritSecurity(true);
        doc.setTopicId(1);
        doc.setUserNotify(false);
        doc.setValidationStartDate(calendar);
        doc.setVersionOption("0");
        doc.setUpdateIsoProperties(true);
        doc.setExternalDocumentId(CodDocProtheus);
        doc.setDocumentDescription("Processo: " + getValue("WKNumProces"));
         
        hAPI.publishWorkflowAttachment(doc);
    }
}
    
	
}