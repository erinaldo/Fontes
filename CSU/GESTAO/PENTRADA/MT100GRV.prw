#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT100GRV  บAutor  ณOdinei Raimundo     บ Data ณ   17/01/07  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada na exclusao da NFE para gerar o lancamentoบฑฑ
ฑฑบ          ณ contabil 302 a respeito do contrato                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico CSU                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT100GRV()
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSC7 := SC7->(GetArea())
Local lExclusao   := Paramixb[1]
Local nHdlPrv     := 0
Local lHead       := .F.
Local cPadrao     := "202"
Local cRotina     := "MATA103"
Local lPadrao     := .F.
Local lDigita     := .F.
Local nTotal      := 0
Local lContraProv := .F.
Local cNum_nf  	  := SF1->F1_DOC 				//SD1->D1_DOC
Local cSerie   	  := SF1->F1_SERIE 				//SD1->D1_SERIE
Local cEmissao    := DTOS(SF1->F1_EMISSAO)  	//DTOS(SD1->D1_EMISSAO)            Alt. por Carlos Tagliaferri Jr em 23/05/2007
Local cFornece    := SF1->F1_FORNECE  			//SD1->D1_FORNECE
Local cLoja       := SF1->F1_LOJA  				//SD1->D1_LOJA

Private cArquivo  := ""
Private cLote     := LoteCont("COM")

lPadrao := VerPadrao(cPadrao)

If lExclusao .AND. lPadrao
	
	DbSelectArea("SD1")
	DbSetOrder(3) // D1_FILIAL, D1_EMISSAO, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, R_E_C_N_O_, D_E_L_E_T_
	DbSeek( xFilial("SD1") + cEmissao + cNum_nf + cSerie + cFornece + cLoja )
	While !Eof() .AND. SD1->D1_FILIAL+DTOS(SD1->D1_EMISSAO)+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == ;
						xFilial("SD1") + cEmissao + cNum_nf + cSerie + cFornece + cLoja
		
		lContraProv := .F. 
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Executa a Mov.Contabil apenas para pedido de compra de contrato      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea("SC7") 
		DbSetOrder(2) // C7_FILIAL, C7_PRODUTO, C7_FORNECE, C7_LOJA, C7_NUM, R_E_C_N_O_, D_E_L_E_T_
		IF DbSeek(xFilial("SC7")+SD1->D1_COD+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_PEDIDO)
			If !Empty(SC7->C7_CONTRA) .AND. SC7->C7_X_PROV == "S" // E um pedido de compra de contrato e ja esta provisionado
				lContraProv := .T.
			Endif 
		EndIf
		
		If lContraProv
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Gera o lancamento contabil para delecao de titulos  ณ
			//ณ gerados via contrato.                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !lHead
				nHdlPrv := HeadProva(cLote,cRotina,Substr(cUsuario,7,6),@cArquivo)
				lHead := .T.
			Endif
			
			nTotal+= DetProva(nHdlPrv,cPadrao,cRotina,cLote)
			
		EndIf

		DbSelectArea("SD1")
		
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

RestArea( aAreaSD1 )
RestArea( aAreaSC7 )

Return Nil
