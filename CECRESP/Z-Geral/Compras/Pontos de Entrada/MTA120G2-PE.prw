#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MTA120G2()

Grava informa��es de Array no Pedido Selecionado

LOCALIZA��O : Function A120GRAVA - Fun��o respons�vel pela grava��o do 
Pedido de Compras e Autoriza��o de Entrega.

EM QUE PONTO : Na fun��o A120GRAVA executado ap�s a grava��o de cada item 
do pedido de compras recebe como parametro o Array manipulado pelo ponto 
de entrada 

@param		aArrayPC  = Parametro retornado pelo ponto de entrada MTA120G1 
						executado antes de comecar a gravar os itens do 
						Pedido de Compra.
@return		aArrayPC = aArrayPC ajustado
@author 	Fabio Cazarini
@since 		23/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MTA120G2()
	LOCAL aArrayPC := PARAMIXB

	//-----------------------------------------------------------------------
	// Grava informa��es complementares do pedido de compras:
	// Contrato TOP 1=SIM ; 2=N�O
	//-----------------------------------------------------------------------
	U_ASCOMA14(aArrayPC)

RETURN 