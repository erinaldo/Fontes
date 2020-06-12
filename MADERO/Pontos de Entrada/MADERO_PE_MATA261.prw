#include 'protheus.ch'


/*/{Protheus.doc} MA261D3
Ponto de entrada na gravação da transferencia (uma das pernas)

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0

@type function
/*/
User Function MA261D3()

	//pre inspeção ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()
		//grava o documento da transferencia na baixa, pois no execauto não traz posicionado.
		IF IsInCallStack('u_MDRTransf2Lote')
			Reclock("SD7",.F.)
			SD7->D7_DOCTRF := SD3->D3_NUMSEQ
			SD7->( MsUnlock() )
		EndIF
	EndIF

return