function createDataset(fields, constraints, sortFields) {
	var centroCusto = "";
	var plaqueta    = "";
	var setor    	= "";
	
	if(fields && fields.length > 0) centroCusto = fields[0];
	if(fields && fields.length > 1) plaqueta    = fields[1];
	if(fields && fields.length > 2) setor    	= fields[2];
	
	var dataset = DatasetFactory.newDataset();
	dataset.addColumn("CCusto");
	dataset.addColumn("Plaqueta");
	dataset.addColumn("DescricaoAtivo");
	dataset.addColumn("CodDoBem");
	dataset.addColumn("Item");
	dataset.addColumn("Qtdade");
	dataset.addColumn("DtAquisicao");
	
	try {
		var servico      = ServiceManager.getService("protheus_ciee_axis"); 
	    var bean         = servico.getBean();
        var locator      = bean.instantiate("_190._2._10._10.CIEELocator");
        var metodos      = locator.getCIEESOAP();   
        var resultado    = metodos.GETATIVOS(centroCusto, plaqueta, setor,'1');        
        var resultObj    = resultado.getATIVOS();
        
        if ( resultObj != null ) {
	        for (i=0; i < resultObj.length; i++) {
	        	var element =  resultObj[i];         
	        	dataset.addRow(new Array(element.getN3_CUSTBEM(),
						element.getN1_CHAPA(),  
						element.getN1_DESCRIC(),										
						element.getN1_CBASE(),									
						element.getN3_ITEM(),
						element.getN1_QUANTD(),
						element.getN1_AQUISIC() ));     			
	        }
        }else{
        	return gerarDatasetErro("N\u00e3o foram localizados ativos com os par\u00e2metros informados.");        
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
