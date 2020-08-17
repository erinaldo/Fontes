#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120GRV  บAutor  ณOdinei Raimundo     บ Data ณ   18/01/07  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada na exclusao do Pedido de Compra para gerarบฑฑ
ฑฑบ          ณ o lancamento contabil 303 a respeito do contrato           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕esณ Ajustes para corre็ใo referente a OS 0290/17.              บฑฑ
ฑฑบ          ณ Douglas David / Eduardo Dias - Totvs                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico CSU                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120GRV()
Local aArea      	:= GetArea()
Local cNum_Com 	   	:= Paramixb[1]
Local lInclusao		:= Paramixb[2] //OS 0553/16
Local lAltera		:= Paramixb[3] //OS 0553/16
Local lExclusao  	:= Paramixb[4]
Local nHdlPrv    	:= 0
Local cPadrao    	:= "203"
Local cRotina    	:= "MATA121"
Local lPadrao	    := .F.
Local lDigita   	:= .F.
Local nTotal      	:= 0
Local lContraProv 	:= .F.
Local cCodPrj		:= "" //OS 0553/16
Local nVlrPed		:= 0  //OS 0553/16
Local cAliasTRB		:= GetNextAlias() //OS 0553/16
Local cAliasSC7		:= GetNextAlias()
Local cSc7altera    := GetNextAlias()
Local nPosItem      := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEM"})    //OS 3055/16
Local nPosC7Ite     := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"})    //OS 3055/16
Local nPosC7Pro 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"}) //OS 0553/16
Local nPosC7Tot		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"}) //OS 0553/16
Local nPosC7Nsc		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"}) //OS 0043/17
Local nX			:= 0 //OS 0553/16
Local nSldDisp		:= 0
Local nTotal        := 0
Private cArquivo	:= ""
Private cLote   	:= LoteCont("COM")


lPadrao := VerPadrao(cPadrao)

If AllTrim(Upper(FunName())) <> "CNTA120"  // OS 2798/16 By Douglas David
	
	If  lAltera .Or. lInclusao // OS 0553/16
		
		For nX := 1 To Len(aCols)
			
			cOrigem :=Posicione("SC1",1,xFilial("SC1")+aCols[nX][nPosC7Nsc]+aCols[nX][nPosC7Ite],"C1_X_CAPEX")
			cProjeto:=Posicione("SC1",1,xFilial("SC1")+aCols[nX][nPosC7Nsc]+aCols[nX][nPosC7Ite],"C1_X_PRJ")
			
			cTotSc7:= POSICIONE("SC7",1,xFilial("SC7")+cNum_Com+aCols[nX][nPosItem],"C7_TOTAL")
			
			nVlrPed	:= Iif(lAltera,iif(aCols[nX][nPosC7Tot] == cTotSc7,cTotSc7,aCols[nX][nPosC7Tot]),aCols[nX][nPosC7Tot]) // Valor total do Item do Pedido
			cCodItem:= aCols[nX][nPosC7Ite] 	     // ItCSCSem do pedido
			cCodPrj := Alltrim(aCols[nX][nPosC7Pro]) // Codigo do produto do Pedido
			cNumSC  := aCols[nX][nPosC7Nsc]          // Numero SC
			
			DbSelectArea("AFA")
			DbSetOrder(1)
			
			// O.S - 2373/16 - Tratamento Para verificar a tarefa e Projeto pertencente ao Projeto
			
			_cSelect :="SELECT DISTINCT AFA.AFA_CUSTD, AFA.AFA_QUANT, AFA.AFA_PROJET, AFA.AFA_PRODUT, AFA.AFA_REVISA, AFA.AFA_TAREFA, "
			_cSelect +="AFG.AFG_PROJET, AFG.AFG_COD, AFG.AFG_NUMSC, AFG.AFG_ITEMSC, AFG.AFG_TAREFA "
			_cSelect +="FROM "+RetSqlName("AFA")+" AFA (NOLOCK)"
			_cSelect +="LEFT JOIN "+RetSqlName("AFG")+" AFG (NOLOCK) ON AFA.AFA_FILIAL = AFG.AFG_FILIAL AND AFA.AFA_PROJET = AFG.AFG_PROJET AND AFG.AFG_NUMSC = '"+cNumSC+"' AND AFA.D_E_L_E_T_ = '' "
			_cSelect +="WHERE AFA.AFA_PROJET = AFG.AFG_PROJET AND AFG.AFG_TAREFA = AFA_TAREFA AND AFG.AFG_NUMSC = '"+cNumSC+"' AND AFG.AFG_ITEMSC = '"+cCodItem+"' AND AFA.AFA_PRODUT =  '"+cCodPrj+"'  "
			_cSelect +="AND AFA.D_E_L_E_T_ = '' "
			_cSelect +="AND AFG.D_E_L_E_T_ = '' "
			_cSelect +="ORDER BY AFA_REVISA DESC "
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSelect),cAliasTRB,.T.,.F.)
			
			nSldPrj	:= (cAliasTRB)->AFA_CUSTD * (cAliasTRB)->AFA_QUANT  //Valor total do item do projeto - "Este ้ o saldo inicial"
			
			// Verifica o empenho do projeto (SC7)
			cQuery := " SELECT SUM(C7_TOTAL) TOTALPC "
			cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
			cQuery += " WHERE C7_PRODUTO = '"+cCodPrj+"' AND C7_X_PRJ = '"+cProjeto+"' AND C7_X_CAPEX = 'PROJETO' AND C7_RESIDUO = ' ' "
			cQuery += " AND C7_NUMSC = '"+cNumSC+"' AND C7_ITEMSC = '"+cCodItem+"' AND D_E_L_E_T_ = ' ' "  // OS 3055/16 - Douglas
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.F.)
			
			nTotal:= TOTALPC
			
			If lAltera
				cQuery := " SELECT SUM(C7_TOTAL) TOTALPCA "
				cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
				cQuery += " WHERE C7_PRODUTO = '"+cCodPrj+"' AND C7_X_PRJ = '"+cProjeto+"' AND C7_X_CAPEX = 'PROJETO' AND C7_RESIDUO = ' ' "
				cQuery += " AND C7_NUM = '"+cNum_Com+"' AND C7_ITEM = '"+aCols[nX][nPosItem]+"' AND D_E_L_E_T_ = ' ' "
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cSC7Altera,.T.,.F.)
				
				nTotal := nTotal - TOTALPCA
				(cSC7Altera)->( DbCloseArea() )
			Endif
			
			nSldDisp := nSldPrj - nTotal // OS 2373/16 - Verifica Saldo do Projeto disponivel ( Orcado AFA - Empenho SC7)
			
			If  Alltrim(cOrigem) == 'PROJETO'
				If nSldDisp < nVlrPed
					MSGSTOP("PEDIDO NรO INCLUSO!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Valor total ref. ao Produto "+RTRIM(cCodPrj)+" ้ maior do que o saldo disponivel para o item do Projeto "+RTRIM(cProjeto),"Saldo indisponํvel no PMS")
					RestArea(aArea)
					Return .F.
				EndIf
			Endif
			(cAliasTRB) ->( DbCloseArea() )
			(cAliasSC7) ->( DbCloseArea() )
			
		Next nX
		
	ElseIf lExclusao .AND. lPadrao
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Executa a Mov.Contabil apenas para pedido de compra de contrato      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea("SC7")
		DbSetOrder(1)
		If DbSeek( xFilial("SC7") + cNum_Com )
			If !Empty(SC7->C7_CONTRA) .AND. SC7->C7_X_PROV = "S" // E um pedido de compra de contrato e ja esta provisionado
				lContraProv:= .T.
			Else
				RestArea(aArea)
				Return
			Endif
		Else
			RestArea(aArea)
			Return
		Endif
		
		If !lContraProv
			RestArea(aArea)
			Return
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gera o lancamento contabil para delecao de titulos  ณ
		//ณ gerados via contrato.                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nHdlPrv := HeadProva(cLote,cRotina,Substr(cUsuario,7,6),@cArquivo)
		
		While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7") + cNum_Com
			
			nTotal+= DetProva(nHdlPrv,cPadrao,cRotina,cLote)
			
			DbSkip()
			
		EndDo
		
		If nTotal > 0
			RodaProva(nHdlPrv,nTotal)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Envia para Lancamento Contabil			   		    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
			
		Endif
	EndIf
Endif

RestArea(aArea)

Return Nil
