#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MTA120G2()

Grava informações de Array no Pedido Selecionado

LOCALIZAÇÃO : Function A120GRAVA - Função responsável pela gravação do 
Pedido de Compras e Autorização de Entrega.

EM QUE PONTO : Na função A120GRAVA executado após a gravação de cada item 
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
	// Grava informações complementares do pedido de compras:
	// Contrato TOP 1=SIM ; 2=NÃO
	//-----------------------------------------------------------------------
	U_ASCOMA14(aArrayPC)

RETURN 