#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA22()
Consulta a tabela SZ9 para verificar qual o tipo da venda

@param		
@return		cTipVen -> Tipo da Venda
@author 	Fabiano Albuquerque
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra

/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCTBA22()

LOCAL aAreaAnt	:= GetArea()
LOCAL aAreaSE1  := SE1->(GetArea())
LOCAL cVenda	:= SUBSTR(__cTINHCTB,At("VENDA:",__cTINHCTB)+6,4)
LOCAL cTipVen	:= ""

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1))
IF MsSeek(xFilial("SZ9")+cVenda)
	cTipVen := SZ9->Z9_TIPOVEND
ENDIF

RestArea(aAreaSE1)
RestArea(aAreaAnt)

RETURN cTipVen