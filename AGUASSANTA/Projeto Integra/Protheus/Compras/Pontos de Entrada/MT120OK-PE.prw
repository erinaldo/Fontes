#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120OK()

Validações Específicas de Usuário

LOCALIZAÇÃO : Function A120TudOk() responsável pela validação de todos os 
itens da GetDados do Pedido de Compras / Autorização de Entrega.

EM QUE PONTO : O ponto se encontra no final da função e é disparado após a 
confirmação dos itens da getdados e antes do rodapé da dialog do PC, deve 
ser utilizado para validações especificas do usuario onde será controlada 
pelo retorno do ponto de entrada oqual se for .F. o processo será 
interrompido e se .T. será validado.

@param		Nenhum 
@return		lRet = Continua ou não a operação
@author 	Fabio Cazarini
@since 		26/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT120OK()
	LOCAL lRet			:= .T.

	IF lRet
		//-----------------------------------------------------------------------
		// Controles do processo do pedido de compras:
		// - Se inclusão ou alteração, ao gravar o pedido de compra que gera  
		// contrato no TOP, deve ser validado se foi informado o projeto e tarefa 
		//-----------------------------------------------------------------------
		lRet := U_ASCOMA10(cA120Num, INCLUI, ALTERA, .F.)
	ENDIF
	
RETURN lRet