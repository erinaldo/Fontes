#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} AVALCOPC()

Manipula Pedido de Compras

LOCALIZAÇÃO   :  Function MaAvalCot - Função responsável pelos eventos do 
processo das cotações de compras

EM QUE PONTO :  O ponto se encontra no final do evento 4 da MaAvalCot 
(Analise da Cotação) após a gravação de cada PC gerado a partir da cotação 
vencedora da analise da cotação. e pode ser utilizado para manipular o 
pedido de compras  tabela SC7.

@param		aPedidos	= {{cFilPed, cPedido, aRatFin, nValTotal}} 
@return		aPedidos
@author 	Fabio Cazarini
@since 		23/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION AVALCOPC()
	LOCAL aPedidos	:= PARAMIXB
	LOCAL cFilPed 	:= aPedidos[1][1]
	LOCAL cPedido	:= aPedidos[1][2]
	LOCAL aRatFin	:= aPedidos[1][3]
	LOCAL nValTotal := aPedidos[1][4]
	LOCAL nP		:= 0
	LOCAL lRet		:= .T.

	//-----------------------------------------------------------------------
	// Grava informações complementares do pedido de compras ao analisar a  
	// cotação: Contrato TOP 1=SIM ; 2=NÃO
	//-----------------------------------------------------------------------
	lRet := U_ASCOMA15(cFilPed, cPedido, aRatFin, nValTotal)

	//-----------------------------------------------------------------------
	// Gera a solicitação no Fluig
	//-----------------------------------------------------------------------
	// Zema 25/08/2017 - Gera para todos os pedidos
	FOR nP := 1 TO LEN(aPedidos)
		cFilPed 	:= aPedidos[nP][1]
		cPedido	:= aPedidos[nP][2]
		aRatFin	:= aPedidos[nP][3]
		nValTotal := aPedidos[nP][4]
		U_ASCOMA01(cPedido, .T., .F., .F.) // cA120Num, l120Inclui, l120Altera, l120Deleta
					
	NEXT
	//-----------------------------------------------------------------------
	// Dispara e-mail de agradecimento aos fornecedores que nao venceram
	// a cotacao.
	//-----------------------------------------------------------------------
	
	U_ASCOMA28(cPedido)
	
RETURN aPedidos