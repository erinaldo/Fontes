#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ScanSCPC ³ Autor ³    Eduardo Dias       ³ Data ³ 14/08/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa para incluir elemento no Array dos campos a serem  ³±±
±±³			 ³impresso no relatorio PMSTOTCSU - CSU	 OS 0699/16 e 1047/16 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ScanSCPC2(aArrayABC)

	Local cQuery	:= ""
	Local nX		:= 0
	Local aAreaSC1  := SC1->(GetArea())

	Default aArrayABC := {}

//ASORT(aArrayABC, , , { | x,y | x[2]+x[13] < y[2]+x[13]} )
	ASORT(aArrayABC, , , { | x,y | x[2] < y[2]} )


	For nX :=1 To Len(aArrayABC)
		cQuery := "SELECT DISTINCT C1.C1_NUM, C1.C1_PEDIDO, C1.C1_ITEM, C1.C1_X_PRJ, C1.C1_PRODUTO, AFG.AFG_TAREFA, C1.C1_QUANT FROM "+RETSQLNAME("SC1")+" C1"
		cQuery += " INNER JOIN "+RETSQLNAME("AFG")+" AFG ON AFG.AFG_NUMSC = C1.C1_NUM AND AFG.AFG_ITEMSC = C1.C1_ITEM AND AFG.AFG_PROJET = C1.C1_X_PRJ "
		cQuery += " AND AFG.AFG_COD = C1.C1_PRODUTO AND AFG.D_E_L_E_T_ = ''"
		cQuery += " WHERE C1.C1_PRODUTO =  '"+aArrayABC[nX][2]+"' AND  C1.C1_X_PRJ =  '"+aArrayABC[nX][11]+"' AND AFG_TAREFA = '"+aArrayABC[nX][13]+"' "
		cQuery += " AND  C1.C1_X_CAPEX = 'PROJETO' AND  C1.C1_CODORCA = 'PADRAOPR'  AND   C1.D_E_L_E_T_ = ' ' "
		TCQUERY cQuery NEW ALIAS 'TRBSC1'
	
		nTotReg := Contar("TRBSC1","!Eof()")
	
		("TRBSC1")->(dbGotop())
	
		cNumSC	:= TRBSC1->C1_NUM
		cItemSC := TRBSC1->C1_ITEM
		cTarefa := Alltrim(TRBSC1->AFG_TAREFA)
	
		If nTotReg > 1
		
			cQuery := "SELECT AFG_PROJET, AFG_TAREFA, AFG_REVISA, * FROM "+RETSQLNAME('AFG')
			cQuery += " WHERE  AFG_PROJET = '"+aArrayABC[nX][11]+"' "
			cQuery += " AND  AFG_TAREFA = '"+cTarefa+"' "
			cQuery += " AND AFG_COD = '"+aArrayABC[nX][2]+"' "
			cQuery += " AND  AFG_REVISA = '"+aArrayABC[nX][12]+"' "
			cQuery += " AND  AFG_NUMSC = '"+cNumSC+"' " //C1_NUM
			cQuery += " AND  AFG_ITEMSC = '"+cItemSC+"' " //C1_ITEM
			cQuery += " AND   D_E_L_E_T_ = ' '"
			TCQUERY cQuery NEW ALIAS 'TEMPAFG'
				
		Else
			cQuery := "SELECT AFG_PROJET, AFG_TAREFA, AFG_REVISA, * FROM "+RETSQLNAME('AFG')
			cQuery += " WHERE  AFG_PROJET = '"+aArrayABC[nX][11]+"' "
			cQuery += " AND  AFG_TAREFA = '"+aArrayABC[nX][13]+"' "
			cQuery += " AND  AFG_NUMSC = '"+cNumSC+"' " //C1_NUM
			cQuery += " AND  AFG_ITEMSC = '"+cItemSC+"' " //C1_ITEM
			cQuery += " AND   D_E_L_E_T_ = ' '"
			TCQUERY cQuery NEW ALIAS 'TEMPAFG'
		Endif
	
		If nTotReg <= 1
			If !Empty(TEMPAFG->AFG_NUMSC)
				aAdd(aArrayABC[nX],TRBSC1->C1_NUM)   //15
				aAdd(aArrayABC[nX],TRBSC1->C1_PEDIDO)  //16
				aAdd(aArrayABC[nX],TRBSC1->C1_ITEM)    //17
			Else
				aAdd(aArrayABC[nX]," ")   //15
				aAdd(aArrayABC[nX]," ")  //16
				aAdd(aArrayABC[nX]," ")    //17
			EndIf
		Endif
	
		While TRBSC1->(!Eof()) .And. nTotReg >= 2
		
			If !Empty(TEMPAFG->AFG_NUMSC)
				aAdd(aArrayABC[nX],TRBSC1->C1_NUM)   //15
				aAdd(aArrayABC[nX],"")  //16
				aAdd(aArrayABC[nX],TRBSC1->C1_ITEM)    //17
			Else
				aAdd(aArrayABC[nX]," ")   //15
				aAdd(aArrayABC[nX]," ")  //16
				aAdd(aArrayABC[nX]," ")    //17
			EndIf
		
			TRBSC1->(dbSkip())
		
			If TRBSC1->(!Eof()) .And. nTotReg > 1
				nX++
			Endif
		EndDo
	
		If Select("TRBSC1") > 0
			DBSelectArea("TRBSC1")
			DBCloseArea()
		EndIf
	
		If Select("TEMPAFG") > 0
			DBSelectArea("TEMPAFG")
			DBCloseArea()
		EndIf
	
	Next nX


	sCanAF9(aArrayABC)

	sCanSC7(aArrayABC)

//sCanAFA(aArrayABC)

Return(aArrayABC)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ sCanAF9	³ Autor ³    Eduardo Dias       ³ Data ³ 14/08/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preenchimento do array aArrayABC com dados da tabela AF9    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function sCanAF9(aArrayABC)

	Local cQuery	:= ""
	Local nX		:= 0
	Local aAreaAF9  := AF9->(GetArea())

	Default aArrayABC	:= {}

	For nX :=1 To Len(aArrayABC)
	
		cQuery := "SELECT AFG_PROJET, AFG_TAREFA, AFG_REVISA, * FROM "+RETSQLNAME('AFG')
		cQuery += " WHERE  AFG_PROJET = '"+aArrayABC[nX][11]+"' "
		cQuery += " AND  AFG_REVISA = '"+aArrayABC[nX][12]+"' "
		cQuery += " AND  AFG_NUMSC = '"+aArrayABC[nX][15]+"' " //C1_NUM
		cQuery += " AND  AFG_ITEMSC = '"+aArrayABC[nX][17]+"' " //C1_ITEM
		cQuery += " AND   D_E_L_E_T_ = ' '"
		TCQUERY cQuery NEW ALIAS 'TRBAFG'
	
		aAdd(aArrayABC[nX],TRBAFG->AFG_TAREFA)      //18
		aAdd(aArrayABC[nX],Posicione("AF9",1,xFilial("AF9")+TRBAFG->AFG_PROJET+TRBAFG->AFG_REVISA+TRBAFG->AFG_TAREFA,"AF9_DESCRI"))  // 19
		aAdd(aArrayABC[nX],"") //20
		aAdd(aArrayABC[nX],"") //21
		aAdd(aArrayABC[nX],"") //22
		aAdd(aArrayABC[nX],"") //23
	
		If Select("TRBAFG") > 0
			DBSelectArea("TRBAFG")
			DBCloseArea()
		EndIf
	
	Next nX

	RestArea(aAreaAF9)

Return(aArrayABC)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ sCanSC7	³ Autor ³    Eduardo Dias       ³ Data ³ 14/08/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preenchimento do array aArrayABC com dados da tabela SC7    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function sCanSC7(aArrayABC)

	Local cQuery	:= ""
	Local cQryD1	:= ""
	Local nPcVai	:= ""
	Local nQtdEmp   := ""
	Local nVlrEmp   := ""
	Local nQtdReal  := ""
	Local nVlrReal  := ""
	Local nX		:= 0
	Local nXAnt		:= 1
	Local aAreaSC7  := SC7->(GetArea())

	Default aArrayABC	:= {}

	For nX :=1 To Len(aArrayABC)
	
		cQuery := "SELECT C7_QUANT, C7_TOTAL, C7_QUJE, C7_PRECO, C7_RESIDUO, C7_PRODUTO, * FROM "+RETSQLNAME('SC7')
		cQuery += " WHERE  C7_X_PRJ = '"+aArrayABC[nX][11]+"' "
		cQuery += " AND  C7_NUMSC = '"+aArrayABC[nX][15]+"' "
		cQuery += " AND  C7_ITEMSC = '"+aArrayABC[nX][17]+"' "
		cQuery += " AND  C7_X_CAPEX = 'PROJETO' "
		cQuery += " AND   D_E_L_E_T_ = ' '"
		TCQUERY cQuery NEW ALIAS 'TRBSC7'
	
		nTotReg := Contar("TRBSC7","!Eof()")
	
		("TRBSC7")->(dbGotop())
	
		cQryD1 := "SELECT D1_COD, D1_QUANT, D1_TOTAL, D1_VUNIT,  * FROM "+RETSQLNAME('SD1')
		cQryD1 += " WHERE D1_PEDIDO = '"+TRBSC7->C7_NUM+"' "
		cQryD1 += " AND  D1_ITEMPC = '"+TRBSC7->C7_ITEM+"' "
		cQryD1 += " AND  D1_COD  = '"+TRBSC7->C7_PRODUTO+"' "
		cQryD1 += " AND   D_E_L_E_T_ = ' '"
		TCQUERY cQryD1 NEW ALIAS 'TRBSD1'
	
		("TRBSD1")->(dbGotop())       
				
		cD1Tot := "SELECT SUM (D1_TOTAL) AS TOTAL  FROM "+RETSQLNAME('SD1')
		cD1Tot += " WHERE D1_PEDIDO = '"+TRBSC7->C7_NUM+"' "
		cD1Tot += " AND  D1_ITEMPC = '"+TRBSC7->C7_ITEM+"' "
		cD1Tot += " AND  D1_COD  = '"+TRBSC7->C7_PRODUTO+"' "
		cD1Tot += " AND   D_E_L_E_T_ = ' '"
		TCQUERY cD1Tot NEW ALIAS 'TRBTOT'
			
		While TRBSC7->(!Eof()) .And. nTotReg > 1
		
			nPcVai := IIF(Empty(nPcVai),TRBSC7->C7_NUM,nPcVai+" / "+TRBSC7->C7_NUM)
			aArrayABC[nX][16] := nPcVai
		
			nQtdEmp := IIF(Empty(nQtdEmp),TRBSC7->C7_QUANT,(nQtdEmp+TRBSC7->C7_QUANT))
			aArrayABC[nX][20] := nQtdEmp // 20 -- Quantidade Empenho
		
			nVlrEmp := IIF(Empty(nVlrEmp),TRBSC7->C7_TOTAL,(nVlrEmp+TRBSC7->C7_TOTAL))
			aArrayABC[nX][21] := nVlrEmp // 21 -- Valor Empenho
		
		
			nQtdReal:= IIF(Empty(nQtdReal),TRBSC7->C7_QUJE,(nQtdReal+TRBSC7->C7_QUJE))
			aArrayABC[nX][22] := nQtdReal // 22 -- Quantidade Realizado
		
			nVlrReal:= IIF(Empty(nVlrReal),(TRBSC7->C7_QUJE*TRBSD1->D1_VUNIT),(nVlrReal+(TRBSC7->C7_QUJE*TRBSD1->D1_VUNIT)))
			aArrayABC[nX][23] := nVlrReal // 23 -- Valor Realizado
		
			TRBSC7->(dbSkip())
		
		EndDo
	
		If nTotReg <= 1
			aArrayABC[nX][16] := TRBSC7->C7_NUM
			aArrayABC[nX][20] := TRBSC7->C7_QUANT // 20 -- Quantidade Empenho
			aArrayABC[nX][21] := TRBSC7->C7_TOTAL // 21 -- Valor Empenho
			aArrayABC[nX][22] := TRBSC7->C7_QUJE  // 22 -- Quantidade Realizado
			aArrayABC[nX][23] := TRBTOT->TOTAL  // 23 -- Valor Realizado
		Endif
	
		nPcVai  := ""
		nQtdEmp := ""
		nVlrEmp := ""
		nQtdReal:= ""
		nVlrReal:= ""
	
		If Select("TRBSC7") > 0
			DBSelectArea("TRBSC7")
			DBCloseArea()
		EndIf
	
		If Select("TRBSD1") > 0
			DBSelectArea("TRBSD1")
			DBCloseArea()
		EndIf
		
		If Select("TRBTOT") > 0
			DBSelectArea("TRBTOT")
			DBCloseArea()
		EndIf	
	
	Next nX

	RestArea(aAreaSC7)

Return(aArrayABC)