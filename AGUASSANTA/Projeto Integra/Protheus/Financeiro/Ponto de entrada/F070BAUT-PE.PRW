#Include "Protheus.ch"       
#INCLUDE "TOPCONN.CH"
//-----------------------------------------------------------------------
/*/{Protheus.doc} F070BAUT
Ponto de entrada no cancelamento da baixa a receber para selecionar qual baixa parcial será cancelada
@param		PARAMIXB[1][1] - Array com as baixas
			PARAMIXB[2][2] - Opcao de baixa
			nOpBaixa :=	ExecBlock("F070BAUT",.F.,.F.,{aBaixa,nOpBaixa})
@return		Nenhum
@author 	Zema
@since 		17/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F070BAUT 
LOCAL aBaixas := PARAMIXB[1]
LOCAL nOpBaixa:= PARAMIXB[2] 
LOCAL aArea		:= GetArea()
                                                                      
// Localiza qual baixa deve ser cancelada
nOpBaixa := U_ASFINA60(aBaixas,nOpBaixa) 

RestArea(aArea)
RETURN(nOpBaixa)