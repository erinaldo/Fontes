/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³CGITMCTB  ºAutor  ³Adriano Sotello     º Data ³  09/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para carga do cadastro de Itens Contábeis           º±±
±±º          ³ no RM                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Carga Periódica de dados (Devido o processo de criação     º±±
               customizada dos Itens Contábeis a integração padrão não    º±±
               está sendo ativada     )                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function CGITMCTB()
Local nStatus   := 0
Local cQuery    := ""  
local cAliasCTD := GetNextAlias()
Local aAreaCTD := CTD->(GetArea())
Private Altera 	:= .T.
Private INCLUI  := .T.

cQuery := "SELECT * "
cQuery += "FROM "+RetSqlName("CTD")+" "
cQuery += "WHERE CTD_XINTRM='" + "0" + "' "
cQuery += "ORDER BY CTD_FILIAL"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCTD,.T.,.T.)

dbSelectArea(cAliasCTD)
(cAliasCTD)->(DbGoTop())

CTD->(DbSetOrder(1))

While (cAliasCTD)->(!EOF())

  cFilAnt := AllTrim((cAliasCTD)->CTD_FILIAL) + "0001" 
  
  If CTD->(MsSeek(xFilial("CTD")+(cAliasCTD)->CTD_ITEM))    
	  If FwHasEai("CTBA040A",.T.,,.T.)
	    SetRotInteg("CTBA040A")
		RegToMemory("CTD",.F.,.T.,.T.)
		FwIntegDef("CTBA040A",,,,"CTBA040A")
	  EndIf
	  RecLock("CTD",.F.)
	  CTD->CTD_XINTRM := "1"
	  MsUnlock()
   EndIf	  

/*		      
  nStatus := TCSqlExec("UPDATE " +RetSqlName("CTD")+ " SET CTD_XINTRM = '1' WHERE CTD_FILIAL = '" + CFILANT + "' AND CTD_ITEM = '" + (cAliasCTD)->CTD_ITEM + "'")
   
  if (nStatus < 0)
    conout("TCSQLError() " + TCSQLError())
  endif
*/    
  (cAliasCTD)->(DbSkip())

EndDo

dbCloseArea()   
RestArea(aAreaCTD)
Return
