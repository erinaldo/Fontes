#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TOPCONN.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA56()

Retorna a sequencia do controle de lotes de mutuo

@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		15/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA56
LOCAL XLote := "0000000000"
LOCAL cQ 	:= ""

cQ := "SELECT MAX(E5_XLOTMUT) LOTE FROM "+RetSqlName("SE5")
TcQuery ChangeQuery(cQ) ALIAS "XLOT" NEW

IF !EMPTY(XLOT->LOTE)
	XLote := XLOT->LOTE
ENDIF
XLOT->(DBCLOSEAREA())

XLote := SOMA1(XLote)

RETURN(XLote)
