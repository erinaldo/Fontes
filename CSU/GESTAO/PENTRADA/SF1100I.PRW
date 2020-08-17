#Include 'Protheus.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Paulo V. Beraldo    º Data ³  Jan/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada Executado Após a Inclçusao da Nota Fiscal  º±±
±±º          ³Para Gerar a Contabilizacao dos Itens Estiverem Marcados    º±±
±±º          ³como Provisorios, gerando Assim um Lancto. Contabil.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF1100I()
Local aArea 		:= GetArea()
Local aAreaSD1 		:= SD1->(GetArea())
Local nHdlPrv     	:= 0
Local cPadrao     	:= "201"
Local cRotina     	:= "MATA103"
Local lDigita     	:= .F. //.T.    Alt. por Carlos Tagliaferri Jr em 23/05/2007
Local nTotal      	:= 0
Local _cChave		:= ""
Local cSc7Ct		:= CriaVar("C7_CONTRA", .F.)
Local cSc7Ctb		:= CriaVar("C7_X_PROV", .F.)
Local cArquivo  	:= ""
Private cLote     	:= LoteCont("COM")

If !EMPTY(SD1->D1_X_RESG)  /// Nota de entrada vinculada a um pedido importado do Multi-catalogo, deve-se liberar o pedido de venda relacionado
	/// a essa nota de entrada
	aArea 		    := GetArea()
	aAreaSD1 		:= SD1->(GetArea())
	aAreaSC5 		:= SC5->(GetArea())
	aAreaSC6 		:= SC6->(GetArea())
	aAreaSC9 		:= SC9->(GetArea())
	lLiber          :=  1
	lTransf         :=  1
	
	_cChave	:= SF1->( F1_FILIAL + Dtos(F1_EMISSAO) + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )
	Dbselectarea("SD1")
	Dbsetorder(3)
	
	If SD1->( dbSeek( _cChave ) )
		
		While SD1->(!Eof()) .And. ;
			SD1->(D1_FILIAL+Dtos(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == _cChave
			
			Dbselectarea("SC5")
			Dbsetorder(08)
			IF Dbseek(xFilial("SC5")+SD1->D1_X_RESG)
				
				Dbselectarea("SC6")
				DbSetorder(1)
				Dbseek(xFilial("SC6")+SC5->C5_NUM,.F.)
				
				While !eof() .and. SC5->C5_NUM == SC6->C6_NUM
					
					nQtdLib := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
					
					Begin Transaction
					MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.T.,.T.,.F.,.F.)
					End Transaction
					
					SC6->(MsUnLock())
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza o Flag do Pedido de Venda                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Begin Transaction
					SC6->(MaLiberOk({SC5->C5_NUM},.F.))
					End Transaction
					
					
					Dbselectarea("SC6")
					Dbskip()
				Enddo
				
			ENDIF
			Dbselectarea("SD1")
			Dbskip()
		enddo
	ENDIF
endif

///////////////////   FIM DA LIBERACAO DO PEDIDO DE VENDAS PARA O PROCESSO DE MULTICATALOGO

_cChave	:= SF1->( F1_FILIAL + Dtos(F1_EMISSAO) + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )

dbSelectArea('SD1')
SD1->(dbSetOrder(3))
//If !SD1->( dbSeek( xFilial('SD1') + _cChave ) )  Alt. por Carlos Tagliaferri Jr em 23/05/2007
If !SD1->( dbSeek( _cChave ) )
	RestArea( aAreaSD1 )
	RestArea( aArea )
	Return
Else
	
	nHdlPrv := HeadProva(cLote,cRotina,Substr(cUsuario,7,6),@cArquivo)
	
	Begin Transaction
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(2))
	
	dbSelectArea("SD1")
	SD1->(dbSetOrder(3))
	//SD1->(dbSeek( xFilial("SD1") + _cChave ))   Alt. por Carlos Tagliaferri Jr em 23/05/2007
	SD1->(dbSeek( _cChave ))
	
	While SD1->(!Eof()) .And. ;
		SD1->(D1_FILIAL+Dtos(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == _cChave
		
		//If  SC7->( dbSeek(xFilial('SC7')+SD1->(D1_COD + D1_FORNECE + D1_LOJA + D1_PEDIDO) )) .And. ;
		//	SC7->CONTRA <> cSc7Ct .And. SC7->C7_X_PROV <> cSc7Ctb                                         Alt. por Carlos Tagliaferri Jr em 23/05/2007
		If  SC7->( dbSeek(xFilial('SC7')+SD1->(D1_COD + D1_FORNECE + D1_LOJA + D1_PEDIDO) )) .And. ;
			SC7->C7_CONTRA <> cSc7Ct .And. SC7->C7_X_PROV <> cSc7Ctb
			
			nTotal  += DetProva(nHdlPrv,cPadrao,cRotina,cLote)
			RodaProva(nHdlPrv,nTotal)
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
			
		EndIf
		SD1->(dbSkip())
	EndDo
	End Transaction
EndIf

RestArea( aAreaSD1 )
RestArea( aArea )
Return
