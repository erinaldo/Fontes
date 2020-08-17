#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Pto Entrada³CN120ESSLD³ Autor ³ Sergio Oliveira       ³ Data ³ Jul/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Ponto de Entrada executado no momento do estorno da medicao³±±
±±³           ³ Verificar se devera ser utilizado ***                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CN120ESSLD()

Local cQuery     := ""
Local cAliasQry  := GetNextAlias()
Private cAlias	 := Alias()
Private aAreaCND := CND->(GetArea()), aAreaCN1 := CN1->(GetArea()), aAreaCN9 := CN9->(GetArea())

CN9->( DbSetOrder(1), DbSeek( xFilial("CN9")+CND->( CND_CONTRA+CND_REVISA ) ) )

If CN1->( DbSetOrder(1), DbSeek( xFilial("CN1")+CN9->CN9_TPCTO ) ) .And. CN1->CN1_X_MDIN # 'S'
	
	cQuery := "SELECT SUM(CNE_VLTOT) AS CNE_VLTOT FROM " + RetSQLName("CNE") + " CNE WHERE "
	cQuery += "CNE.CNE_FILIAL = '"+xFilial("CNE")+"' AND "
	cQuery += "CNE.CNE_NUMMED = '"+CND->CND_NUMMED+"' AND "
	//cQuery += "CNE.CNE_XATUSL = 'S' AND "
	cQuery += "CNE.D_E_L_E_T_ = ' '"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
	
	TCSetField(cAliasQry,"CNE_VLTOT","N",TamSX3("CNE_VLTOT")[1],TamSX3("CNE_VLTOT")[2])
	
	If CNA->( DbSetOrder(1), DbSeek( xFilial('CNA')+CND->(CND_CONTRA+CND_REVISA+CND_NUMERO) ) )
		CNA->( RecLock("CNA",.f.) )
		CNA->CNA_SALDO += (cAliasQry)->CNE_VLTOT
		CNA->( MsUnlock() )
	EndIf
	
    CN9->( RecLock("CN9",.f.) )
	CN9->CN9_SALDO += (cAliasQry)->CNE_VLTOT
	CN9->( MsUnlock() )
	
	If CNF->CNF_CONTRA == CND->CND_CONTRA // Caso haja cronograma para o contrato
		CNF->( RecLock("CNF",.F.) )
		CNF->CNF_SALDO  += (cAliasQry)->CNE_VLTOT
		CNF->CNF_VLREAL -= (cAliasQry)->CNE_VLTOT
		If CNF->CNF_VLREAL == 0
			CNF->CNF_DTREAL := CTOD("")
		Endif	
		CNF->( MsUnlock() )
	EndIf
	
	If (GetNewPar( "MV_CNPROVI" , "S" ) == "S")
		CN100ETit(CND->CND_CONTRA,CND->CND_REVISA,CNF->CNF_NUMERO,CNF->CNF_PARCEL)
		If CNF->CNF_SALDO > 0
			CN100CTit(CND->CND_CONTRA,CND->CND_REVISA,CNF->CNF_NUMERO,CNF->CNF_PARCEL,CNF->CNF_SALDO)
		EndIf
	EndIf
	
	(cAliasQry)->(dbCloseArea())
	
	cQuery := "SELECT CNE.R_E_C_N_O_ AS RECNOCNE,CNB.R_E_C_N_O_ AS RECNOCNB FROM " + RetSQLName("CNE") + " CNE, "+ RetSQLName("CNB") +" CNB WHERE "
	cQuery += "CNE.CNE_FILIAL = '"+xFilial("CNE")+"' AND "
	cQuery += "CNB.CNB_FILIAL = '"+xFilial("CNB")+"' AND "
	cQuery += "CNE.CNE_NUMMED = '"+CND->CND_NUMMED+"' AND "
	cQuery += "CNE.CNE_CONTRA = CNB.CNB_CONTRA AND "
	cQuery += "CNE.CNE_REVISA = CNB.CNB_REVISA AND "
	cQuery += "CNE.CNE_NUMERO = CNB.CNB_NUMERO AND "
	cQuery += "CNE.CNE_ITEM   = CNB.CNB_ITEM AND "
	//cQuery += "CNE.CNE_XATUSL = 'S' AND "
	cQuery += "CNE.D_E_L_E_T_ = ' ' AND "
	cQuery += "CNB.D_E_L_E_T_ = ' '"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
	
	While !(cAliasQry)->(Eof())
		CNE->(dbGoTo((cAliasQry)->RECNOCNE))
		CNB->(dbGoTo((cAliasQry)->RECNOCNB))
		
		CNB->( RecLock("CNB",.F.) )
		CNB->CNB_QTDMED += CNE->CNE_QUANT
		CNB->CNB_SLDMED -= CNE->CNE_QUANT
		CNF->( MsUnlock() )
		
		(cAliasQry)->(dbSkip())
	EndDo
	
	(cAliasQry)->(dbCloseArea())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura Integridade ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	CND->( RestArea(aAreaCND) )
	
Else
	
	cQuery := "SELECT CNE.R_E_C_N_O_ AS RECNOCNE,CNB.R_E_C_N_O_ AS RECNOCNB FROM " + RetSQLName("CNE") + " CNE, "+ RetSQLName("CNB") +" CNB WHERE "
	cQuery += "CNE.CNE_FILIAL = '"+xFilial("CNE")+"' AND "
	cQuery += "CNB.CNB_FILIAL = '"+xFilial("CNB")+"' AND "
	cQuery += "CNE.CNE_NUMMED = '"+CND->CND_NUMMED+"' AND "
	cQuery += "CNE.CNE_CONTRA = CNB.CNB_CONTRA AND "
	cQuery += "CNE.CNE_REVISA = CNB.CNB_REVISA AND "
	cQuery += "CNE.CNE_NUMERO = CNB.CNB_NUMERO AND "
	cQuery += "CNE.CNE_ITEM   = CNB.CNB_ITEM AND "
	//cQuery += "CNE.CNE_XATUSL = 'S' AND "
	cQuery += "CNE.D_E_L_E_T_ = ' ' AND "
	cQuery += "CNB.D_E_L_E_T_ = ' '"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
	
	While !(cAliasQry)->(Eof())
		CNE->(dbGoTo((cAliasQry)->RECNOCNE))
		CNB->(dbGoTo((cAliasQry)->RECNOCNB))
		
		CNB->( RecLock("CNB",.f.) )
		CNB->CNB_QTDMED := 1
		CNB->CNB_SLDMED := 1
		CNB->( MsUnlock() )
		
		(cAliasQry)->(dbSkip())
	EndDo
	
	(cAliasQry)->(dbCloseArea())
	
EndIf

CN1->(RestArea( aAreaCN1 ) )
CN9->(RestArea( aAreaCN9 ) )

DbSelectArea(cAlias)

Return