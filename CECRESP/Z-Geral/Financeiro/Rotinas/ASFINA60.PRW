#Include "Protheus.ch"       
#INCLUDE "TOPCONN.CH"
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA60
Chamado via Ponto de entrada no cancelamento da baixa a receber para selecionar qual baixa parcial será cancelada
@param		Array com as baixas
			Opcao de baixa

@return		Nenhum
@author 	Zema
@since 		17/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA60(aBaixas, nOpc)
Local nX 		:= 1              
Local nBaixas	:= LEN(aBaixas)

IF IsInCallStack("FA100CAN")   

	FOR nX := 1 TO nBaixas
		IF RIGHT(ALLTRIM(aBaixas[nX]),2) == cSEQSE5
			nOpc := nX
			EXIT
		ENDIF  

	NEXT

ENDIF

IF nOPC == 0 

	nOPC := 1
	
ENDIF

RETURN(nOpc)