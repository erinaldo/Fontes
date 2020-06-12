#Include "Protheus.ch"                                    
#Include "TopConn.CH"
#Include "TBICONN.CH"

/*-----------------+---------------------------------------------------------+
!Nome              ! COM105 - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Geracao de Pedidos de Compra nos Restaurantes           !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 23/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function COM105(paramixb)
Local cAliTmp0  := GetNextAlias()
Local aRecSC7   := {}
Local aCabecSC7 := {}
Local aItensSC7 := {}
Local cPathTmp  := "\temp\"
Local lErro     := .f.
Local cAuxLog   := ""
Local aAuxErro  := {}
Local nx		:= 0
Local nAux      := 0  
Local aRetSA5   := {}
Local dDtCalc   := paramixb[1]
Local cEmpresa  := paramixb[2]
Local cUndMad   := paramixb[3]
Local cForm  	:= ""
Local cLoj  	:= ""
Local cGrpCom   := ""
Local sDtEnt	:= ""
Local cProd     := ""
Local cCodtab   := ""
Local cCCusto   := ""
Local aRetAux   := {}
Local aCalendFor:= {}
Local aCalend   := {}
Local cxUser    := "MRP"
Local dDtCalc   
Local cChave 
Local cItem
Private lMsErroAuto := .F.	
Private cxUserSC7   := ""
Private cxNUserSC7  := "ressuprimento"

    PREPARE ENVIRONMENT Empresa cEmpresa filial cUndMad Tables "SA2","SE4","SB1","SB2","SC7","CTT","SX5","SBM","Z22" Modulo "COM"

	cAuxLog:=": Posiciona no usuario do processo..." 
	ConOut(cAuxLog)
	PswOrder(2)
	PswSeek(cxNUserSC7, .T. ) 
	cxUserSC7:=PswID()
	__cUserID:=cxUserSC7

	cAuxLog:=": Selecionando necessidades de compras..." 
	ConOut(cAuxLog)

	cQuery:="SELECT   Z25_FILIAL, Z25_DTENTR, Z25_DTNXEN, Z25_CODFOR, Z25_CODLOJ, Z25_GRPCOM, Z25_PRODUT, Z25_CODTAB, Z25_CC, Z25_TES, SUM(Z25_QUANT) Z25_QUANT, (SUM(Z25_VALOR)/COUNT(*)) Z25_VALOR "
	cQuery+="FROM " + RetSQLName("Z25") + " Z25 "
	cQuery+="WHERE Z25.Z25_FILIAL   = '" + cUndMad  + "' AND " 
	cQuery+="      Z25.Z25_PEDIDO   = ' '                AND " 
	cQuery+="      Z25.Z25_DTENTR  <> ' '                AND " 
	cQuery+="      Z25.D_E_L_E_T_  <> '*'                    "
	cQuery+="GROUP BY Z25_FILIAL, Z25_DTENTR, Z25_DTNXEN, Z25_CODFOR, Z25_CODLOJ, Z25_GRPCOM, Z25_PRODUT, Z25_CODTAB, Z25_CC, Z25_TES "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliTmp0,.T.,.T.)				
	(cAliTmp0)->(DbGoTop())

	dDataBase:=dDtCalc
	cAuxLog  :="Ok." 
	ConOut(cAuxLog)
		
	Begin Transaction
	
		aCalend := {}
		lErro   := .F.
		While !(cAliTmp0)->(eof())
			
			// -> Inicializa dados do pedido de compra
			cFilEnt  := (cAliTmp0)->Z25_FILIAL
			sDtEnt	 := (cAliTmp0)->Z25_DTENTR
			cForm  	 := (cAliTmp0)->Z25_CODFOR
			cLoj  	 := (cAliTmp0)->Z25_CODLOJ
			cGrpCom  := (cAliTmp0)->Z25_GRPCOM
			cProd    := (cAliTmp0)->Z25_PRODUT
			cCodtab  := (cAliTmp0)->Z25_CODTAB
			cCCusto  := (cAliTmp0)->Z25_CC
			cItem 	 := '0001'
			aCabecSC7:= {}
			aItensSC7:= {}
			lErro    := .F.
			cChave   := cFilEnt+cForm+cLoj+cGrpCom
			
			// -> Atualizar data de proxima entrega
			nAux:=aScan(aCalend,{|xpz| xpz[1] == xFilial("Z22")+cFilEnt+cForm+cLoj+cGrpCom})
			If nAux <=0 
				AADD(aCalend,{xFilial("Z22")+cFilEnt+cForm+cLoj+cGrpCom,StoD((cAliTmp0)->Z25_DTENTR),"",StoD((cAliTmp0)->Z25_DTNXEN)})
			EndIf
			
			// -> Atualiza calendário do fornecedor
			nAux:=aScan(aCalendFor,{|xpx| xpx[1] == xFilial("Z22")+cFilEnt+cForm+cLoj})
			If nAux <=0 
				AADD(aCalendFor,{xFilial("Z22")+cFilEnt+cForm+cLoj})
			EndIf
		
			DbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2")+cForm+cLoj))			

			aadd(aCabecSC7,{"C7_EMISSAO" , dDataBase   })
			aadd(aCabecSC7,{"C7_FORNECE" , SA2->A2_COD })
			aadd(aCabecSC7,{"C7_LOJA"    , SA2->A2_LOJA})
			aadd(aCabecSC7,{"C7_COND"    , SA2->A2_COND})
			aadd(aCabecSC7,{"C7_FILENT"  , cFilAnt     })

			cAuxLog:=":"+DtoC(StoD(sDtEnt))+":"+cForm+cLoj+":"+cGrpCom+": Gerando pedido..." 
			ConOut(cAuxLog)

			While !(cAliTmp0)->(eof()) .and. (cAliTmp0)->Z25_FILIAL == cFilEnt .and. (cAliTmp0)->Z25_DTENTR == sDtEnt .and. (cAliTmp0)->Z25_CODFOR == cForm .and. (cAliTmp0)->Z25_CODLOJ == cLoj .and. (cAliTmp0)->Z25_GRPCOM == cGrpCom

				aRecSC7:={} 

				// -> Posiciona no cadastro de produtos
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+(cAliTmp0)->Z25_PRODUT))  					
  					
				// -> Posiciona no cadastro de grupos de compras
				DbSelectArea("SAJ")
				SAJ->(DbSetOrder(1))
				SAJ->(DbSeek(xFilial("SAJ")+(cAliTmp0)->Z25_GRPCOM))
										
				// -> Calcula a quantidade a ser enviada para o fornecedor, conforme dados da tabela SA5
				aRetSA5:=u_C104PRF((cAliTmp0)->Z25_QUANT,(cAliTmp0)->Z25_CODFOR,(cAliTmp0)->Z25_CODLOJ,(cAliTmp0)->Z25_PRODUT,.F.)
										
				aadd(aRecSC7,{"C7_ITEM"			, cItem,	        		Nil})
				aadd(aRecSC7,{"C7_PRODUTO"		, (cAliTmp0)->Z25_PRODUT,	Nil})					
				If aRetSA5[2] > 0 
					aadd(aRecSC7,{"C7_XUNPRF"	, aRetSA5[3],				Nil})
					aadd(aRecSC7,{"C7_XQTDPRF"	, aRetSA5[1],				Nil})
					aadd(aRecSC7,{"C7_UM"		, SB1->B1_UM,				Nil})
					aadd(aRecSC7,{"C7_QUANT"	, aRetSA5[2],				Nil})													
				Else
					aadd(aRecSC7,{"C7_XUNPRF"	, SB1->B1_UM,				Nil})
					aadd(aRecSC7,{"C7_XQTDPRF"	, aRetSA5[1],				Nil})
					aadd(aRecSC7,{"C7_UM"		, SB1->B1_UM,				Nil})
					aadd(aRecSC7,{"C7_QUANT"	, aRetSA5[1],				Nil})													
				EndIf	
				aadd(aRecSC7,{"C7_PRECO"		, (cAliTmp0)->Z25_VALOR,	Nil})
				aadd(aRecSC7,{"C7_CC"		    , (cAliTmp0)->Z25_CC,		Nil})
				aadd(aRecSC7,{"C7_CODTAB"	    , (cAliTmp0)->Z25_CODTAB,	Nil})
				aadd(aRecSC7,{"C7_LOCAL"		, SB1->B1_LOCPAD,    		Nil})
				aadd(aRecSC7,{"C7_TES"			, (cAliTmp0)->Z25_TES,		Nil})
				aadd(aRecSC7,{"C7_XENVCR"   	, "P",              		Nil})
				aadd(aRecSC7,{"C7_XEMAIL"   	, " ",              		Nil})
				aadd(aRecSC7,{"C7_DATPRF"		, StoD(sDtEnt),	            Nil})
				aadd(aRecSC7,{"C7_XDTINC"   	, dDataBase, 				Nil})
				aadd(aRecSC7,{"C7_XGRMRP"   	, (cAliTmp0)->Z25_GRPCOM,   Nil})
				aadd(aRecSC7,{"C7_XUSERI"   	, cxUser, 	                Nil})
				aadd(aRecSC7,{"C7_XDTALT"   	, ctod(""), 				Nil})
				aadd(aRecSC7,{"cA120User"   	, cxUserSC7, 				Nil})
				aadd(aRecSC7,{"C7_XUSERI"   	, cxNUserSC7, 	    		Nil})
				aadd(aRecSC7,{"C7_XDTEXPV"  	, ctod(""), 				Nil})
				aadd(aRecSC7,{"C7_XUSEREX"  	, "", 						Nil})
				cItem := Soma1(cItem)
				aadd(aItensSC7, aRecSC7)

				(cAliTmp0)->(DbSkip())
				
			EndDo
			
			cFilEnt  := (cAliTmp0)->Z25_FILIAL		
			sDtEnt	 := (cAliTmp0)->Z25_DTENTR
			cForm  	 := (cAliTmp0)->Z25_CODFOR
			cLoj  	 := (cAliTmp0)->Z25_CODLOJ
			cGrpCom  := (cAliTmp0)->Z25_GRPCOM			
			
			// -> Grava pedido de compra
			If Len(aItensSC7) >0 .and. Len(aCabecSC7) > 0
				DbSelectArea("SC7")
				SC7->(DbSetOrder(1))
				lMsErroAuto := .F.
				MATA120(1,aCabecSC7,aItensSC7,3)
				If lMsErroAuto
					lErro   := .T.
					cAuxLog := "pc_"+cUndMad+"_"+AllTrim(cChave)+"_"+strtran(time(),":","")
					MostraErro(cPathTmp, cAuxLog)
					Aadd(aAuxErro,{"Execucao",memoread(cPathTmp+cAuxLog),"","","","",""})
					ConOut("Erro.")
					DisarmTransaction()
					Break
				Else
					nAux:=aScan(aCalend,{|xpz| xpz[1] == xFilial("Z22")+SC7->C7_FILENT+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_XGRMRP})
					If nAux > 0 
						aCalend[nAux,3]:=SC7->C7_NUM
					EndIf
					Aadd(aAuxErro,{"Execucao","Ok.","","","","",""})					
					ConOut("Ok.")
				Endif								 				
			EndIf
			
		EndDo

	End Transaction
	
	(cAliTmp0)->(DbCloseArea())
		
	// -> Aualiza calendário de entrega
	If !lErro
		Aadd(aAuxErro,{"Calendario de entrega:","Atualizando calendario de entrega...","","","","",""})					
		aRetAux:=atuZ22(aCalend,aCalendFor)
		lErro  :=aRetAux[2]
		aadd(aAuxErro,aRetAux[1])
	EndIf	
		
	RESET ENVIRONMENT
			
Return({aAuxErro,lErro})


/*-----------------+---------------------------------------------------------+
!Nome              ! atuZ22 - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Atualizacao da data e Compra do Fornecedor X Grupo Prod !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 28/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function atuZ22(aCalend,aCalendFor)
Local dDataNova := CtoD("  /  /  ") 
Local aAreaZ22  := GetArea()
Local nDia      := 0
Local lErro     := .F.
Local aErro     := {}
Local cAuxLog   := ""
Local dDtEnt    := CtoD("  /  /  ")
Local cPed      := ""
Local nAuxZ22   := 0
Local nk,nu     := 0
Local aAuxDias  := {}

	// -> Atualiza calendário
	For nk:=1 to Len(aCalendFor)
		// -> Posiciona no calendário
		DbSelectArea("Z22")
		Z22->(DbSetOrder(1))
		Z22->(DbSeek(aCalendFor[nk,1]))
		While !Z22->(Eof()) .and.  xFilial("Z22")+Z22->Z22_CODUN+Z22->Z22_FORN+Z22->Z22_LOJA == aCalendFor[nk,1] 

			cAuxLog:= ":"+Z22->Z22_CODUN+":"+Z22->Z22_FORN+":"+Z22->Z22_LOJA+": Atualizando calendario de entregas."
			Aadd(aErro,{"Calendario de entrega:",cAuxLog,"","","","",""})
			ConOut(cAuxLog)

			dDtEnt   :=Z22->Z22_DTNXEN
			cPed     :="SEMPEDIDO"
			dDataNova:=CtoD("  /  /  ")
			nAuxZ22:=aScan(aCalend,{|xp1| xp1[1] == xFilial("Z22")+Z22->Z22_CODUN+Z22->Z22_FORN+Z22->Z22_LOJA+Z22->Z22_GRUPO})
			If nAuxZ22 > 0 
				cPed:=aCalend[nAuxZ22,3]
			EndIf
			// -> Atualiza o calendário
			Z22->(RecLock("Z22",.F.))
			// -> Atualiza o calendário de entrega - Entrega semanal
			If Z22->Z22_TIPO == 'S'
				aAuxDias:=StrToKarr(Z22->Z22_DIA,",")
				// -> Se for apenas um dia, oma 7
				If Len(aAuxDias) <= 1
					dDataNova:=dDtEnt+7
				Else
					dDataNova:=dDtEnt
					dAux   :=dDataNova
					While StrZero(Dow(dAux),2) <> StrZero(Val(aAuxDias[Len(aAuxDias)]),2)
						dAux:=dAux+1
					EndDo
				`	dDataNova:=dAux
				EndIf						
			EndIf
			// -> Entrega quinzenal
			If Z22->Z22_TIPO == 'Q'
				// -> Calcula nova data
				If Day(dDtEnt) = 14
					dDataNova:=CtoD("28/"+StrZero(Month(dDtEnt),2)+"/"+StrZero(Year(dDtEnt),4))
				Else
					dDataNova:=CtoD("14/"+StrZero(IIF(Month(dDtEnt)=12,1,Month(dDtEnt)+1),2)+"/"+StrZero(IIF(Month(dDtEnt)=12,Year(dDtEnt)+1,Year(dDtEnt)),4))
				EndIf	 
			EndIf
			// -> Entrega mensal
			If Z22->Z22_TIPO == 'M'
				// -> Calcula nova data
				dDataNova:=CtoD("01/"+StrZero(IIF(Month(dDtEnt)=12,1,Month(dDtEnt)),2)+"/"+StrZero(IIF(Month(dDtEnt)=12,Year(dDtEnt)+1,Year(dDtEnt))),4)
				nDia     :=IIF(LastDay(dDataNova) < Val(aDiasSem[1]),LastDay(dDataNova),Val(aDiasSem[1]))
				dDataNova:=CtoD(StrZero(nDia,2)+"/"+StrZero(Month(dDataNova),2)+"/"+StrZero(Year(dDataNova),4))
			EndIf
			Z22->Z22_DTULEN:=dDtEnt
			Z22->Z22_NUMPC :=cPed
			Z22->Z22_DTNXEN:=dDataNova		
			Z22->(MsUnlock())
			// -> Verifica a data de Entrega
			lErro:=Empty(dDataNova)
			If lErro
				cAuxLog:= "Nova data de entrega invalida."
				lErro  :=.T.			
				Aadd(aErro,{"Calendario de entrega:",cAuxLog,"","","","",""})
				ConOut(cAuxLog)
			Else
				cAuxLog:= "Ok."
				Aadd(aErro,{"Calendario de entrega:",cAuxLog,"","","","",""})
				ConOut(cAuxLog)
			EndIf
			Z22->(DbSkip())
		EndDo
	Next nk
	
	RestArea(aAreaZ22)

return({aErro,lErro})