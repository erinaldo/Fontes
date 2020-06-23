#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F580CAN ³Ordem ³ Autor ³ TOTVS      s    ³ Data ³ 06/01/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cancelamento da Liberacao de Pagamento                     ³±±
±±³±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³Sintaxe   ³							            					       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F580CAN()
Local lRet := .T.

RecLock("SE2",.F.)
SE2->E2_XORDLIB := ""
MsUnLock()

//Reordena items
ReordenaTitl(SE2->E2_VENCREA)

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F580CAN ³Ordem ³ Autor ³ TOTVS      s    ³ Data ³ 06/01/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cancelamento da Liberacao de Pagamento                     ³±±
±±³±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³Sintaxe   ³							            					       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReordenaTitl(cVencReal)
Local cQuery	:= ""
Local nNumOrd   := 0

cQuery:= " SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO "+CRLF
cQuery+= " FROM "+RetSqlName("SE2")+" SE2 "+CRLF
cQuery+= " WHERE SE2.E2_VENCREA = '"+DTOS(cVencReal)+"' "+CRLF
cQuery+= " AND SE2.E2_XORDLIB <> '' "+CRLF
cQuery+= " AND SE2.E2_BAIXA = '' "+CRLF
cQuery+= " AND SE2.D_E_L_E_T_ = '' "+CRLF
cQuery+= " AND SE2.E2_FILIAL = '"+xFilial("SE2")+"'"+CRLF
cQuery+= " ORDER BY E2_VALOR "+CRLF

cQuery := changequery(cQuery) 

dbUsearea(.T.,"TOPCONN",TCGenQry(,,cQuery), "TMPQ") 

While !Eof() 

    nNumOrd := nNumOrd + 1 
    cQueryTcSql := "UPDATE "+RetSqlName("SE2")+ " SET E2_XORDLIB = '"+ALLTRIM(STRZERO(nNumOrd,3,0))+"' WHERE E2_NUM='"+TMPQ->E2_NUM+"' AND E2_FILIAL='"+TMPQ->E2_FILIAL+"' AND E2_PREFIXO='"+TMPQ->E2_PREFIXO+"' AND E2_PARCELA='"+TMPQ->E2_PARCELA+"'"
	If TCSQLEXEC(cQueryTcSql) < 0
		MsgInfo("Erro ao atualizar o campo  E2_XORDLIB, verifique com o administrador do sistema")
	EndIf
	
	dbSkip()
Enddo 

TMPQ->(DbCloseArea()) 

Return                                   	
