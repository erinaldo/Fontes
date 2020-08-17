#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO11    ºAutor  ³Microsiga           º Data ³  10/21/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120GRV()
Local cNumPC	  := PARAMIXB[1]   // Numero do Pedido de Compras
Local _lInclusao  := PARAMIXB[2]   // Inclusao de PC
Local _lAlteracao := PARAMIXB[3]   // Alteracao de PC
Local _lExclusao  := PARAMIXB[4]   // Exclusao de PC

Local cQuery    := ""

If _lExclusao
	
	If select("QRYSC8") > 0
		QRYSC8->(dbclosearea())
	EndIf
	
	cQuery := " Select SC8.C8_FILIAL, SC8.C8_NUM, SC8.* from "+RetSqlName("SC8")+" SC8 "
	cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+xFilial("SC8")+"' AND SC8.C8_NUMPED = '"+cNumPC+"'
	cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC8", .F., .T.)
	
	dbselectarea("QRYSC8")
	If QRYSC8->(!EOF())
		dbselectarea("SC8")
		SC8->(dbOrderNickName("COTACNEW"))
		if dbseek(QRYSC8->C8_FILIAL+QRYSC8->C8_NUM+QRYSC8->C8_ITEM)
			While SC8->(!EOF()) .and. QRYSC8->C8_FILIAL+QRYSC8->C8_NUM+QRYSC8->C8_ITEM == SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_ITEM
				Reclock("SC8",.F.)
				SC8->C8_NUMPED  := ""
				SC8->C8_ITEMPED := ""
				SC8->(msunlock())
				SC8->(dbskip())
			EndDo
		endif
	EndIf
	
EndIf

Return .T.