#Include 'Protheus.ch'

/*-----------------+---------------------------------------------------------+
!Nome              ! MT120ALT - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE se permite alterar/excluir o Pedido de compra        !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 01/06/2018                                              !
+------------------+--------------------------------------------------------*/
user function MT120ALT()
	Local lRet := .t.
	// Se for alteracao ou exclusao e ja enviado por e-mail o pedido para a fabrica bloqueia a operação
	if (ALTERA .or. Paramixb[1] == 5 ).and. (SC7->C7_XEMAIL = "E")
		lRet := .f.
		Alert("O pedido já foi enviado ao fornecedor [C7_XEMAIL = 'E']")
	Endif
return lRet



/*-----------------+---------------------------------------------------------+
!Nome              ! MT120F - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! PE durante a gravacao de Pedido de compra               !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 01/06/2018                                              !
+------------------+--------------------------------------------------------*/
User Function MT120F(IXBPAD)
Local cFil		:= SubStr(PARAMIXB,1,10)
Local cPed		:= SubStr(PARAMIXB,11,6)
Local aSC7      := SC7->(GetArea())
Local aSC1      := SC1->(GetArea())
Local cCodUsr   := IIF(Type("cxUserSC7")  == "C",cxUserSC7,"")
Local cNomeUsr  := IIF(Type("cxNUserSC7") == "C",cxNUserSC7,UsrRetName(RetCodUsr()))
	
	If Inclui
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(cFil+cPed))
		while !SC7->(eof()) .and. SC7->C7_FILIAL+SC7->C7_NUM = cFil+cPed
			SC1->(dbSetOrder(1))
			RecLock("SC7", .f.)
			If SC1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC+SC7->C7_ITEMSC))
				SC7->C7_XOBS   := SC1->C1_OBS
			EndIf
			SC7->C7_XDTINC := dDataBase
			SC7->C7_XUSERI := cNomeUsr
			SC7->(MsUnlock())
			SC7->(dbSkip())
		enddo
 	ElseIf Altera
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(cFil+cPed))
		while !SC7->(eof()) .and. SC7->C7_FILIAL+SC7->C7_NUM = cFil+cPed
			RecLock("SC7", .f.)
			SC7->C7_XDTALT := dDataBase
			SC7->C7_XUSERA := cNomeUsr
			SC7->(MsUnlock())
			SC7->(dbSkip())
		enddo
	EndIf
	SC1->(RestArea(aSC1))
	SC7->(RestArea(aSC7))
return



/*-----------------+---------------------------------------------------------+
!Nome              ! MT121BRW - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE para incluir em outras acoes opcao para imprimir e   !
!                  !  enviar e-mail do pedido de compra                      !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 28/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function MT121BRW()         
	aAdd(aRotina,{"e&Nviar Pedido","u_ACOM101M", 0, 2, 0, Nil })
	aAdd(aRotina,{"i&Mprimir Pedido","u_ACOM101P", 0, 2, 0, Nil })
Return 


/*-----------------+---------------------------------------------------------+
!Nome              ! A120PIDF - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE Aplicar filtro nas solicitação de Compras que serão  !
!                  ! apresentadas durante a criacao de pedido de compra (F4) !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 11/06/2018                                              !
+------------------+--------------------------------------------------------*/
user function A120PIDF()   
    Local ExpA1 := {"", ""}
    Local cFilSC1
    Local cFiSQLSC1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estrutura do array de retorno                                ³
	//³ 1 - String - Filtro para ISAM ( Sintaxe xBase )       ³
	//³ 2 - String - Filtro para SQL  ( Sintaxe SQL   )       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    cFilSC1 := " C1_FILIAL == '"+xFilial('SC1')+"'.And. C1_QUJE < C1_QUANT .And. C1_TPOP<>'P' "
    cFilSC1 += " .And. C1_APROV$' ,L' .And."
    cFilSC1 += "( C1_COTACAO == '"+Space(Len(SC1->C1_COTACAO))+"' .Or. C1_COTACAO == '"+Replicate("X",Len(SC1->C1_COTACAO))+"') "
    cFilSC1 += ".And. C1_FLAGGCT <> '1'"
    cFilSC1 += ".And.C1_ACCPROC<>'1'"
    cFilSC1 += " .And. C1_TPSC <> '2'"
    if empty(cA120Forn)
    	cFilSC1 += " .And. C1_FORNECE == '"+space(len(cA120Forn))+"' .And. C1_LOJA == '"+space(len(cA120Loj))+"' "
    Else
    	cFilSC1 += " .And. C1_FORNECE == '" + cA120Forn + "' .And. C1_LOJA == '" + cA120Loj + "' "
    EndIf   
    
    cFiSQLSC1:= " C1_FILIAL = '"+xFilial('SC1')+"' AND C1_QUJE < C1_QUANT AND C1_TPOP <> 'P' "
    cFiSQLSC1 += " AND C1_APROV IN (' ','L') AND "
    cFiSQLSC1 += "( C1_COTACAO = '"+Space(Len(SC1->C1_COTACAO))+"' OR C1_COTACAO = '"+Replicate("X",Len(SC1->C1_COTACAO))+"') "
    cFiSQLSC1 += " AND C1_FLAGGCT <> '1'"
    cFiSQLSC1 += " AND C1_ACCPROC <> '1'"
    cFiSQLSC1 += " AND C1_TPSC <> '2'"
    if empty(cA120Forn)
    	cFiSQLSC1 += " AND C1_FORNECE = '"+space(len(cA120Forn))+"' AND C1_LOJA = '"+space(len(cA120Loj))+"' "
    Else
    	cFiSQLSC1 += " AND C1_FORNECE = '" + cA120Forn + "' AND C1_LOJA = '" + cA120Loj + "' "
    EndIf
   	cFiSQLSC1 += " AND D_E_L_E_T_ = ' ' "
    
    ExpA1[1] := cFilSC1     
    ExpA1[2] := cFiSQLSC1     
Return ExpA1     





/*-----------------+---------------------------------------------------------+
!Nome              ! A120F4FI - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE Aplicar filtro nas solicitação de Compras que serão  !
!                  ! apresentadas durante a criacao de pedido de compra (F5) !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              !s 11/06/2018                                              !
+------------------+--------------------------------------------------------*/
user function A120F4FI()   
    Local ExpA1 := {"", "", "", ""}
    Local cFilSC1
    Local cFiSQLSC1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estrutura do array de retorno                                ³
	//³ 1 - String - Filtro no SC1 para ISAM ( Sintaxe xBase )       ³
	//³ 2 - String - Filtro no SC1 para SQL  ( Sintaxe SQL   )       ³
	//³ 3 - String - Filtro no SC3 para ISAM ( Sintaxe xBase )       ³
	//³ 4 - String - Filtro no SC3 para SQL  ( Sintaxe SQL   )       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    if empty(cA120Forn)
    	cFilSC1 := " C1_FORNECE == '"+space(len(cA120Forn))+"' .And. C1_LOJA == '"+space(len(cA120Loj))+"' "
    Else
    	cFilSC1 := " C1_FORNECE == '" + cA120Forn + "' .And. C1_LOJA == '" + cA120Loj + "' "
    EndIf   
    
    if empty(cA120Forn)
    	cFiSQLSC1 := " C1_FORNECE = '"+space(len(cA120Forn))+"' AND C1_LOJA = '"+space(len(cA120Loj))+"' "
    Else
    	cFiSQLSC1 := " C1_FORNECE = '" + cA120Forn + "' AND C1_LOJA = '" + cA120Loj + "' "
    EndIf
    
    ExpA1[1] := cFilSC1     
    ExpA1[2] := cFiSQLSC1     
Return ExpA1     