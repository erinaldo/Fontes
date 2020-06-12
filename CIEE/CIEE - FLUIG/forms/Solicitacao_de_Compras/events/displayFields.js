function displayFields(form,customHTML){ 
	var nrAitividadeAtual  = getValue('WKNumState');
	var INICIO_SOLICITACAO = 0;   
				
	if(nrAitividadeAtual != INICIO_SOLICITACAO)
		return;
	
	var nrSolicitacao 		     = getValue("WKNumProces");
	var matriculaUsuarioLogado   = getValue("WKUser");
	var colaborador  		     = consultarColaboradorPorMatricula(matriculaUsuarioLogado);
	var informacoesColaboradorRH = consultarInformacoesRHPorMatriculaUsuario(matriculaUsuarioLogado);
	
	if(!informacoesColaboradorRH["erro"]){
		form.setValue("txtCodCR", informacoesColaboradorRH["cod_cr"]);
		form.setValue("txtDescricaoCR", informacoesColaboradorRH["desc_cr"]);
		form.setValue("txtEmpresa", informacoesColaboradorRH["empresa"]);
		form.setValue("txtFilial", informacoesColaboradorRH["filial"]);
	}else customHTML.append(gerarAlertaUsuario(informacoesColaboradorRH["erro"]));
	
	if(colaborador && colaborador.rowsCount > 0){							
		form.setValue("txtSolicitante", colaborador.getValue(0, "colleagueName"));
		form.setValue("txtMatSolicitante", matriculaUsuarioLogado);
	}else customHTML.append(gerarAlertaUsuario("Não foi possível localizar os dados do colaborador: " + matriculaUsuarioLogado));
	
	
	var dataAtual = consultarDataAtual();
	form.setValue("txtDataSolicitacao", dataAtual);
	form.setValue("txtNumeroFluig", nrSolicitacao);
	
	form.setShowDisabledFields(true);
    form.setHidePrintLink(true);
}

function consultarInformacoesRHPorMatriculaUsuario(matricula){
	var informacoes = [];
	try {
		var servico      = ServiceManager.getService("protheus_ciee_axis"); 
        var bean         = servico.getBean();
        var locator      = bean.instantiate("_190._2._10._10.CIEELocator");
        var metodos      = locator.getCIEESOAP();
        var result       = metodos.GETF3("ZAAWEB", matricula);
		var xmlResult    = result.getARET();
		var resultCXML   = xmlResult[0].getCXML();
		var semResultado = (resultCXML.length() < 41);
		 
		if(semResultado){
			informacoes["erro"] = ("Não foram localizados do colaborador com a matricula: " + matricula + ". Favor verifique a paramtrização no Protheus");
			return informacoes; 
		}
		
        var resultSubstring    = resultCXML.substring(41);        
		var xmlDoc             = new XML(resultSubstring);
		informacoes["cod_cr"]  = xmlDoc.ACOLS.item.CAMP04;
		informacoes["desc_cr"] = xmlDoc.ACOLS.item.CAMP05;
		informacoes["empresa"] = xmlDoc.ACOLS.item.CAMP08;
		informacoes["filial"]  = xmlDoc.ACOLS.item.CAMP09;
	} catch (e) {
		var msgErro = "[ERRO] Problema na criação do serviço " + e.message;
		informacoes["erro"] = msgErro;
	}
	return informacoes;
}

function gerarAlertaUsuario(mensagem){
	return ("<script>alert('" + mensagem + "')</script>");
}

function consultarColaboradorPorMatricula(matricula) {
	var filtro = DatasetFactory.createConstraint("colleaguePK.colleagueId", matricula, matricula, ConstraintType.MUST);
	var dsColaborador = DatasetFactory.getDataset("colleague", null, [filtro], null);
	return dsColaborador;
}

function consultarDataAtual(){
	var dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
	return dateFormat.format(new java.util.Date());
}