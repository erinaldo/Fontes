function validateForm(form){ 
	var CURRENT_STATE = getValue("WKNumState");
	var NEXT_STATE = getValue("WKNextState");
	var COMPLETED_TASK = (getValue("WKCompletTask")=="true");
	var INICIO = 0;
	var PRIMEIRA_ATIVIDADE = 4;
	var CONTAR_CB = 0;
	var errorMsg = ""; 
	var lineBreaker = "\n";
	
	if (COMPLETED_TASK) {
		
		if(CURRENT_STATE == INICIO || CURRENT_STATE == PRIMEIRA_ATIVIDADE){ 
			
			if(form.getValue("txtRamal") == null || form.getValue("txtRamal").isEmpty()){
				errorMsg += "Campo Ramal é obrigatório!"+lineBreaker;
			}	
			
			if(form.getValue("dsJustificativa") == null || form.getValue("dsJustificativa").isEmpty()){
				errorMsg += "Campo Justificativa é obrigatório!"+lineBreaker;
			}
			
			
			// Valida checkbox de aprovadores
			if(form.getValue("cbSupervisor") == null){
				CONTAR_CB++;
			}	
						
			if(form.getValue("cbGerencia") == null){
				CONTAR_CB++;
			}			
			
			if(form.getValue("cbSuperintendencia") == null){
				CONTAR_CB++;
			}			
			
			if(form.getValue("cbPresidencia") == null){
				CONTAR_CB++;
			}						

			if(form.getValue("cbAreaTecnica") == null){
				CONTAR_CB++;
			}	
			
			if (CONTAR_CB == 5 ){
				errorMsg += "É obrigatório escolher um aprovador!"+lineBreaker;
			}			
			
			if (form.getValue("txtPrazoDesejado") == ""){  
				
				errorMsg += "Preencha o campo Prazo Desejado!"+lineBreaker;
			}  
			
			var ValidaData = /^(((0[1-9]|[12][0-9]|3[01])([-.\/])(0[13578]|10|12)([-.\/])(\d{4}))|(([0][1-9]|[12][0-9]|30)([-.\/])(0[469]|11)([-.\/])(\d{4}))|((0[1-9]|1[0-9]|2[0-8])([-.\/])(02)([-.\/])(\d{4}))|((29)(\.|-|\/)(02)([-.\/])([02468][048]00))|((29)([-.\/])(02)([-.\/])([13579][26]00))|((29)([-.\/])(02)([-.\/])([0-9][0-9][0][48]))|((29)([-.\/])(02)([-.\/])([0-9][0-9][2468][048]))|((29)([-.\/])(02)([-.\/])([0-9][0-9][13579][26])))$/;  

			if(!ValidaData.test(form.getValue("txtPrazoDesejado"))){  
				errorMsg += "Data do Prazo Desejado invalida: "+form.getValue("txtPrazoDesejado")+lineBreaker;
			}  			
			
			// Valida itens da solicitação de compras
			errorMsg += validaQtdItens(form,lineBreaker);
						
		}   
		
		if(!errorMsg.isEmpty()){ 
			throw errorMsg; 
		}
	}
	
} 

function validaQtdItens(form,lineBreaker){
var indexes 	= form.getChildrenIndexes("tbScItens");
var ItensValue 	= "";
var ErrorMsgRet = "";
var LinhaItens	= "";

if (indexes.length == 0){
	ErrorMsgRet += "É obrigatório incluir ao menos um item na solicitação!" + lineBreaker;
}else{
	for (var i = 0; i < indexes.length; i++) {
		LinhaItens= form.getValue("txtSeqItem___" + indexes[i]);
		ItensValue = form.getValue("txtDescItem___" + indexes[i]);
	    
	    if(ItensValue.isEmpty()){
			ErrorMsgRet += "Campo Descrição do item "+LinhaItens+" não preenchido!"+lineBreaker;
		}	
	    
		ItensValue = form.getValue("txtQtdeItem___" + indexes[i]);
	    
	    if(ItensValue.isEmpty()){
			ErrorMsgRet += "Campo Quantidade do item "+LinhaItens+" não preenchido!"+lineBreaker;
		}
	    
		ItensValue = form.getValue("txtUnidItem___" + indexes[i]);
	    
	    if(ItensValue.isEmpty()){
			ErrorMsgRet += "Campo Unidade do item "+LinhaItens+" não preenchido!"+lineBreaker;
		}	 
	    
	    if(!ErrorMsgRet.isEmpty()){
	    	return ErrorMsgRet;
	    }
	}
	
}

return ErrorMsgRet;

};

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