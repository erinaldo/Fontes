#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120FIM º Autor ³ Carlos A. Queiroz  º Data ³  18/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Interface para inserir Observacoes no Pedido de Compras.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resorts                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120FIM()
Local nOpcao	:= 0//PARAMIXB[1]
Local cNumPC	:= ""//PARAMIXB[2]   // Numero do Pedido de Compras
Local nOpcA		:= -1//PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
Local oDlg      := nil
Local oFont     := nil
Local oMemo     := nil
Local cTexto    := ""
Local nOpcX     := 0
Local cQuery    := ""

If IsInCallStack("U_GJP130COT")
	nOpcao	:= 3
	cNumPC	:= SC7->C7_NUM   // Numero do Pedido de Compras
	nOpcA	:= 1             // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
Else
	nOpcao	:= PARAMIXB[1]
	cNumPC	:= PARAMIXB[2]   // Numero do Pedido de Compras
	nOpcA	:= PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
EndIf

If nOpcA == 1
	If nOpcao <> 5
		Define FONT oFont NAME "Courier New" SIZE 09,20
		
		Define MsDialog oDlg Title "Observação do Pedido de Compras" From 3, 0 to 340, 617 Pixel
		
		@ 5, 5 Get oMemo Var cTexto Memo Size 300, 145 Of oDlg Pixel
		oMemo:bRClicked := { || AllwaysTrue() }
		oMemo:oFont     := oFont
		
		Define SButton From 153, 145 Type  1 Action (oDlg:End(), nOpcX := 1)Enable Of oDlg Pixel // Ok
		Define SButton From 153, 175 Type  2 Action oDlg:End() Enable Of oDlg Pixel              // Cancela
		
		
		Activate MsDialog oDlg Center
		
		If nOpcX == 1
			
			begin transaction
			_aArea := SC7->(GetArea())
			dbSelectArea("SC7")
			dbSetOrder(1)
			If dbSeek(xFilial("SC7") + cNumPC)
				While SC7->(!EOF()) .And. (xFilial("SC7") + cNumPC == SC7->(C7_FILIAL + C7_NUM))
					RecLock("SC7",.F.)
					SC7->C7_XOBS := cTexto
					MsUnLock()
					SC7->(dbSkip())
				EndDo
			EndIf
			RestArea(_aArea)
			end transaction
			
		EndIf
		
	/*	
	ElseIf nOpcao == 5
		
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
	*/		
	EndIf
EndIf

Return