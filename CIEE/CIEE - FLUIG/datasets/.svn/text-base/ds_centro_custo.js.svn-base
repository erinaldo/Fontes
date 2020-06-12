function createDataset(fields, constraints, sortFields) {
	var dataset = DatasetBuilder.newDataset();
	dataset.addColumn("cdCcustoTransf");
	dataset.addColumn("dsCcustoTransf");
	
	try {
		var servico      = ServiceManager.getService("protheus_ciee_axis"); 
        var bean         = servico.getBean();
        var locator      = bean.instantiate("_190._2._10._10.CIEELocator");
        var metodos      = locator.getCIEESOAP();
        var result       = metodos.GETF3("CTTWEB","");
		var ciee_retorno = result.getARET();

		var xmlResult       = result.getARET();
		var resultCXML      = xmlResult[0].getCXML();
		
		var semResultado    = (resultCXML.length() < 41); 
		if(semResultado)
			return gerarDatasetErro("Não foram localizados centros de custos. Favor verifique a paramtrização no Protheus");
		
        var resultSubstring = resultCXML.substring(41);
		var xmlDoc          = new XML(resultSubstring);
		
		for each(item in xmlDoc.ACOLS.item) { 
			dataset.addRow(new Array(item.CAMP01.toString(), item.CAMP02.toString()));
		} 
	} catch (e) {
		var mensagemErro = "Problema na consulta: " + e.message;
		log.error(mensagemErro);
		return gerarDatasetErro(mensagemErro);
	}
	
	return dataset;
}

function gerarDatasetErro(mensagemErro) {
	var erro = DatasetFactory.newDataset();
	erro.addColumn("erro");
	erro.addRow([mensagemErro]);
	return erro;
}
