#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120OK()

Valida��es Espec�ficas de Usu�rio

LOCALIZA��O : Function A120TudOk() respons�vel pela valida��o de todos os 
itens da GetDados do Pedido de Compras / Autoriza��o de Entrega.

EM QUE PONTO : O ponto se encontra no final da fun��o e � disparado ap�s a 
confirma��o dos itens da getdados e antes do rodap� da dialog do PC, deve 
ser utilizado para valida��es especificas do usuario onde ser� controlada 
pelo retorno do ponto de entrada oqual se for .F. o processo ser� 
interrompido e se .T. ser� validado.

@param		Nenhum 
@return		lRet = Continua ou n�o a opera��o
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
		// - Se inclus�o ou altera��o, ao gravar o pedido de compra que gera  
		// contrato no TOP, deve ser validado se foi informado o projeto e tarefa 
		//-----------------------------------------------------------------------
		lRet := U_ASCOMA10(cA120Num, INCLUI, ALTERA, .F.)
	ENDIF
	
RETURN lRet