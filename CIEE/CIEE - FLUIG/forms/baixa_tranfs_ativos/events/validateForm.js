function validateForm(form){ 
	var CURRENT_STATE = getValue("WKNumState");
	var NEXT_STATE = getValue("WKNextState");
	var COMPLETED_TASK = (getValue("WKCompletTask")=="true");
	
	var INICIO = 0;
	var PRIMEIRA_ATIVIDADE = 3;
		

	var errorMsg = ""; 
	var lineBreaker = "\n";

	/*
	if(!COMPLETED_TASK || CURRENT_STATE == NEXT_STATE || transfereAtividade()){
		return;
	}
	*/
	
	if (COMPLETED_TASK) {
		if(CURRENT_STATE == INICIO || CURRENT_STATE == PRIMEIRA_ATIVIDADE){ 
			if(form.getValue("rdTpSolicitacao") == null || form.getValue("rdTpSolicitacao").isEmpty()){
				errorMsg += "Campo Tipo de Solicitação é obrigatório!"+lineBreaker;
			}
			
			if (form.getValue("rdTpSolicitacao") != null && form.getValue("rdTpSolicitacao") == "1") {
				if(form.getValue("slMotivoBaixa") == null || form.getValue("slMotivoBaixa").isEmpty()){
					errorMsg += "É preciso selecionar ao menos um Motivo!"+lineBreaker;
				}
				if(form.getValue("slMotivoBaixa") == "4"){
					if(form.getValue("nmEntidadeReceptora") == "" || form.getValue("nmEntidadeReceptora").isEmpty()){
						errorMsg += "É preciso preencher o campo Nome Entidade Receptora"+lineBreaker;
					}
					if(form.getValue("numCnpjReceptora") == "" || form.getValue("numCnpjReceptora").isEmpty()){
						errorMsg += "É preciso preencher o campo CPF/CNPJ Entidade Receptora"+lineBreaker;
					}
				}
			}
		}   
		if(!errorMsg.isEmpty()){ 
			throw errorMsg; 
		}
	}
} 

String.prototype.equals = function(str){ 
	return !(str!=this); 
};
String.prototype.contains = function(str){ 
	return this.indexOf(str)>-1; 
};
String.prototype.replaceAll = function(from, to){ 
	var str = this.split(from).join(to); 
	return (str); 
};
String.prototype.isEmpty = function(){ 
	return (!this || 0 === this.length); 
};

function transfereAtividade(){
	var CURRENT_STATE = getValue("WKNumState");
	var NEXT_STATE = getValue("WKNextState");	

	return (CURRENT_STATE == NEXT_STATE) ? true : false;
}