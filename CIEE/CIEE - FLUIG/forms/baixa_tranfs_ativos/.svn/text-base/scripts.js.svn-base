$(document).ready(function() {
	$("#secaoBaixa").hide();
	$("#secaoTransf").hide();
		
	$("#zoom_CcustoTransf").click(function() {
		openZoomCcusto();		
	});		
	
	$("#zoom_LocalizacaoTransf").click(function() {
		openZoomLocalizacao();		
	});		
			
	$("#zoom_BuscaAtivo").click(function() {
		openZoomCustomAtivos();		
	});		
	mostraTipoSolic();
});

function openZoomCcusto(){
	window.open("/webdesk/zoom.jsp?datasetId=ds_centro_custo&dataFields=cdCcustoTransf, Centro de Custo, dsCcustoTransf, Descri\u00e7\u00e3o"+
	    "&resultFields=cdCcustoTransf,dsCcustoTransf&type=ccusto&title=Zoom Centros de Custo", "zoom", "status , scrollbars=no ,width=600, height=350 , top=0 , left=0");
}

function openZoomLocalizacao(){
	window.open("/webdesk/zoom.jsp?datasetId=ds_localizacao&dataFields=cdLocalizacaoTransf,C\u00f3d. Localiza\u00e7\u00e3o,dsLocalizacaoTransf,Desc Localiza\u00e7\u00e3o"+
		    "&resultFields=cdLocalizacaoTransf,dsLocalizacaoTransf&type=local&title=Zoom Localização", "zoom", "status , scrollbars=no ,width=600, height=350 , top=0 , left=0");
}

function openZoomCustomAtivos(){
	var lZoom	 = true;
	var nCnt	 = 0;
	
	if(document.getElementById('txtPesquisaPlqta').value==""){
		nCnt=nCnt+1;
	}
	if(document.getElementById('txtPesquisaCCusto').value==""){
		nCnt=nCnt+1;	
	}
	if(document.getElementById('txtPesquisaSetor').value==""){
		nCnt=nCnt+1;
	}	
	
	if(nCnt == 3){
		lZoom= false;		
		alert("Preencher um dos campos da pesquisa!");			
	}	
	
	if (lZoom == true){
		window.open("ZoomAtivos.htm", "zoom","status , scrollbars=no ,width=1000, height=600 , top=50% , left=50%");
	}
}

function setSelectedZoomItem(selectedObj) {              
	if(selectedObj.type == "ccusto") {
		$("#cdCcustoTransf").val(selectedObj.cdCcustoTransf);
		$("#dsCcustoTransf").val(selectedObj.dsCcustoTransf);
	}

	if(selectedObj.type == "local") {
		$("#cdLocalizacaoTransf").val(selectedObj.cdLocalizacaoTransf);
		$("#dsLocalizacaoTransf").val(selectedObj.dsLocalizacaoTransf);
	}
		
	if(selectedObj.type == "ativos") {
        for (var c in selectedObj.ativos) {
            var index = wdkAddChild("listaAtivos");
                        
    		$("#ativoCCusto___" + index).val(selectedObj.ativos[c].CCusto);
    		$("#ativoPlaqueta___" + index).val(selectedObj.ativos[c].Plaqueta);                        
    		$("#ativoDescricao___" + index).val(selectedObj.ativos[c].DescricaoAtivo);
            	
    		$("#ativoCodBem___" + index).val(selectedObj.ativos[c].CodDoBem);
    		$("#ativoItem___" + index).val(selectedObj.ativos[c].Item);        
    		$("#ativoQtdade___" + index).val(selectedObj.ativos[c].Qtdade); 	                        
    		$("#ativoDtAquisicao___" + index).val(selectedObj.ativos[c].DtAquisicao);                  
        }		
	}
}	

function mostraTipoSolic(){
	if($("#rdTpSolicitacaoBx").is(":checked")){
		$("#secaoBaixa" ).show();
		$("#secaoTransf" ).hide();
	}
	if($("#rdTpSolicitacaoTf").is(":checked")){
		$("#secaoBaixa" ).hide();
		$("#secaoTransf" ).show();
	}
}
