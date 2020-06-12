#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA14()

Grava informações complementares do pedido de compras
Chamado pelo PE MTA120G2
Complementando o PE MT120TEL e a rotina ASCOMA13

Contrato TOP 1=SIM, 2=NÃO

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
USER FUNCTION ASCOMA14(aArrayPC)
	
	IF !IsInCallStack("MATI120") // EAI ADAPTER
		//IF VALTYPE("_cEHCT") == "C"
		IF TYPE("_cEHCT") == "C"
			IF INCLUI .OR. ALTERA
				SC7->C7_XEHCT := _cEHCT // Contrato TOP 1=SIM, 2=NÃO
			ENDIF
		ENDIF
	ENDIF
	
RETURN