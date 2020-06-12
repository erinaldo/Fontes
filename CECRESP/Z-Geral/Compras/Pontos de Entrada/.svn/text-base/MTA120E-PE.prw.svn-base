#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MTA120E()

Valida exclusão de PC ou AE

LOCALIZAÇÃO : Function A120PEDIDO - Função do Pedido de Compras e 
Autorização de Entrega responsável pela inclusão, alteração, exclusão e 
cópia dos PCs.

EM QUE PONTO : Após a montagem da dialog do pedido de compras. É acionado 
quando o usuário clicar nos botões OK (Ctrl O) ou CANCELAR (Ctrl X) na 
exclusão de um PC ou AE. Deve ser utilizado para validar se o PC ou AE 
será excluído ('retorno .T.') ou não ('retorno .F.') , após a confirmação 
do sistema

@param		ExpN1	= 	Contém a opção selecionada: 1 = OK ; 0 = CANCEL
 			ExpC1	= 	Caractere com o número do Pedido de Compras	
@return		lRet = Continua ou não a operação
@author 	Fabio Cazarini
@since 		26/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MTA120E()
	LOCAL nOpcA 	:= PARAMIXB[1]
	LOCAL cPedido 	:= PARAMIXB[2]
	LOCAL lRet		:= .T.

	IF lRet
		//-----------------------------------------------------------------------
		// Controles do processo do pedido de compras:
		// - Se exclusão, solicita digitação de observação da exclusão
		// - Não permite exclusão de pedido de compras reprovado
		// - Se pedido aprovado, solicita confirmação
		//-----------------------------------------------------------------------
		IF nOpcA == 1
			lRet := U_ASCOMA10(cPedido, .F., .F., .T.)
		ENDIF	
	ENDIF
		
RETURN lRet