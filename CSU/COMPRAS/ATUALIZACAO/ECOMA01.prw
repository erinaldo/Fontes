/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ECOMA01 ºAutor ³ Marcos Rocha - Oficina1 º Data ³ 27/08/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna se existe aprovacao pendente.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//User Function ECOMA01(cNumPed,nTipo)
User Function ECOMA01(cNumPed)

Local aArea := GetArea()
Local lAprovPend := .F.
Local cAliasSCR2 := GetNextAlias()
Local cQuery

cQuery := " SELECT COUNT(*) APROVPEND "
cQuery += " FROM "+RetSqlName("SCR")+" SCR "
cQuery += " WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' "
cQuery += " AND SCR.CR_NUM = '"+Left(cNumPed,Len(SC7->C7_NUM))+"' "
cQuery += " AND SCR.CR_TIPO = 'PC'"
//If nTipo == 1
	//cQuery += " AND SUBSTRING(SCR.CR_APROV,1,3) = '800'"  // Melhorar isso - Verificar se existe um grupo u criar um parametro
	//cQuery += "AND SCR.CR_X_TPLIB = 'S'"  // Campo que identifica quem esta aprovando -> 'S' =  Compras
//EndIf
// CR_X_TPLIB == 'S' - Em Processo de cotacao (por Procurment)
cQuery += " AND SCR.CR_X_TPLIB = 'S'"  // Campo que identifica quem esta aprovando -> 'S' =  Compras
cQuery += " AND SCR.CR_STATUS <> '03'"
cQuery += " AND SCR.D_E_L_E_T_=' ' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR2)

dbGotop()
While !Eof()
	If (cAliasSCR2)->APROVPEND > 0
		lAprovPend := .T.
		Exit
	EndIf
	dbSkip()
EndDo
dbCloseArea()

RestArea(aArea)

Return(lAprovPend)