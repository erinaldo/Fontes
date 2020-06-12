
$(document).ready(function() {	
	var mySpanishCalendar = FLUIGC.calendar('#txtPrazoDesejado', {
		language: 'pt-br',
		sideBySide: true,
		useStrict: true
	});	
	/*
	$("#zoom_CcustoTransf").click(function() {
		openZoomCcusto();		
	});
	*/
});

/*function openZoomCcusto(){
	window.open("/webdesk/zoom.jsp?datasetId=ds_centro_custo&dataFields=cdCcustoTransf, Centro de Custo, dsCcustoTransf, Descri\u00e7\u00e3o"+
	    "&resultFields=cdCcustoTransf,dsCcustoTransf&type=ccusto&title=Zoom Centros de Custo", "zoom", "status , scrollbars=no ,width=600, height=350 , top=0 , left=0");
}*/


/*function setSelectedZoomItem(selectedObj) {              
	if(selectedObj.type == "ccusto") {
		$("#cdCcustoTransf").val(selectedObj.cdCcustoTransf);
		$("#dsCcustoTransf").val(selectedObj.dsCcustoTransf);
	}
}*/	

function mascaraData() {

	
}

function addItem(tablename) {
var row 	= wdkAddChild(tablename);

$("#txtSeqItem___"+row.toString()).val( strzero(row.toString(),4) );
//$("#txtQtdeItem___"+row.toString()).mask("#000,00");

$("#txtQtdeItem___"+row.toString()).maskMoney({showSymbol:true, symbol:"R$", decimal:",", thousands:"."});

initLogixHtml({ "tablename": tablename, "row": row });

}

function strzero(cStrAjusta,nCasas){

while (cStrAjusta.length <  nCasas) {
	cStrAjusta = "0" + cStrAjusta;
}

return cStrAjusta;	
}
