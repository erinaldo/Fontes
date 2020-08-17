#Include "rwmake.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rcomw07  ºAutor  ³ Sergio Oliveira    º Data ³  Out/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebimento da cotacao do Fornecedor.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Rcomw07(aParams, oProcess)

WfPrepEnv( aParams[1], aParams[2] )

Private _lForaData := .f.
Private _cNumero, _cFORNECE, _cLOJA, _cTpFrete, _nTotFrete ,;
_nDesc1, _nDesc2, _nDesc3, _nTotDesc, _nTotalCot ,;
_cItem, _nPreco, _nValor, _nIPI, _nPrazo, _dDatprf, _cPgto, _cContato, _lProcesso := .f.
Private _nQuant := 0, _nDescApl := 0
Private cVerifica := "", cEol := Chr(13)+Chr(10)

ChkFile("SC1")
ChkFile("SC8")
ChkFile("SA2")

//cFilAnt      := oProcess:oHtml:RetByName("C8_FILIAL"  )
_cNumero     := oProcess:oHtml:RetByName("C8_NUM"     )
_cFornece    := oProcess:oHtml:RetByName("C8_ForNECE" )
_cLoja       := oProcess:oHtml:RetByName("C8_LOJA"    )
_cContato    := oProcess:oHtml:RetByName("CONTATO"    )
_cTpFrete    := oProcess:oHtml:RetByName("FRETE")
_nTotFrete   := Val(alltrim(oProcess:oHtml:RetByName("ValFRE" )))
/*
_nDesc1      := Val(alltrim(oProcess:oHtml:RetByName("PDESC1")))
_nDesc2      := Val(alltrim(oProcess:oHtml:RetByName("PDESC2")))
_nDesc3      := Val(alltrim(oProcess:oHtml:RetByName("PDESC3")))
_nTotDesc    := Round(Val(alltrim(oProcess:oHtml:RetByName("VLDESC"))),2)
*/
_nTotDesc    := 0
_cCond       := alltrim(oProcess:oHtml:RetByName("condpgto"))
_cC8_x_OBS   := alltrim(oProcess:oHtml:RetByName("obs"))
_nDescIt     := 0

ConOut("----------- Valores recebidos no retorno ")
ConOut(" Filial     " + cFilAnt      )
ConOut(" Numero     " + _cNumero     )
ConOut(" Fornecedor " + _cFornece    )
ConOut(" Loja       " + _cLoja       )
ConOut(" Tipo Frete " + _cTpFrete    )
ConOut(" Vlr. Frete " + Str( _nTotFrete ))
/*
ConOut(" Desconto 1 " + Str( _nDesc1    ))
ConOut(" Desconto 2 " + Str( _nDesc2    ))
ConOut(" Desconto 3 " + Str( _nDesc3    ))
ConOut(" Vlr. Desc. " + Str( _nTotDesc  ))
*/
ConOut(" OBS:       " + _cC8_x_OBS)
cVerifica += "Cotacao: "+PADR(_cNumero,6)+cEol

DbSelectArea('SA2')
DbSetOrder(1)
DbSeek( xFilial("SC8") + PADR(_cFornece,6) + _cLoja )

DbSelectArea("SC8")
DbSetOrder(1)
If DbSeek( xFilial("SC8") +  PADR(_cNumero,6) + PADR(_cFornece,6) + _cLoja )
	
	ConOut('antes de checar a atualizacao do C8_TOTAL')
	cVerifica += "Entrei na cotacao"+cEol
	_lProcesso := .t.
	
	// Verificar se o fornecedor esta respondendo fora do prazo estabelecido:
	
	/*  Tratamento do Frete
	1 - O Valor do frete e calculado por item, assim quando For alterado o campo
	Valor do frete no rodape, devera ser rateado o Valor do frete nos itens.
	2 - Caso o rodape nao For alterado não devera ser efetuado o rateio.
	*/
	If _cTpFrete == "FOB"
		_cC8_RATFRE := 0
	Else
		// (Qtd * Unitario)\Total * Vlr. Frete
		_cC8_RATFRE := _nTotFrete / Len(oProcess:oHtml:RetByName("it.preco"))
	EndIf
	_nTotVal := 0
	_nTLiqIt := 0
	_nDscApl := 0
	_nNroIt := Len(oProcess:oHtml:RetByName("it.dscto"))
	/*
	_nPdsc1 := Val(oProcess:oHtml:RetByName("pdesc1")) / 100
	_nPdsc2 := Val(oProcess:oHtml:RetByName("pdesc2")) / 100
	_nPdsc3 := Val(oProcess:oHtml:RetByName("pdesc3")) / 100
	*/
	For _nind := 1 To Len(oProcess:oHtml:RetByName("it.preco"))
		_nQuant := Val(oProcess:oHtml:RetByName("it.quant")[_nind])
		_nPreco := Val(oProcess:oHtml:RetByName("it.preco")[_nind])
		
		//Tratamento especifico para desconto:
		//------------------------------------------------
		//(_nTotIt) (_nDscIt)     (_nTLiqIt)
		//Item Prc Unit   Total    Desconto   Total Liquido
		//0001   0,85    170,00        5,00       165,00
		//0002   0,77    154,00        4,50       149,50
		//
		//SubTotal: 314,50
		//
		//Desconto no Total:   0,00 ==> 314,50( 0,00)
		//Desconto1........:    10% ==> 283,05(31,45)
		//Desconto2........:    10% ==> 254,75(28,31)
		//Desconto3........:    10% ==> 229,27(25,48)
		//Total Geral......: 229,28
		//Total de Desco'ntos Aplicados no Total:  85,24
		//Desconto a Ratear dentre os Itens....:  85,24 / 2 = 42,62
		//------------------------------------------------
		//
		
		// 1a Etapa(Ate o SubTotal):
		_nTotIt  := Round(_nQuant * _nPreco,2)
		_nDscIt  := Val(oProcess:oHtml:RetByName("it.dscto")[_nind])
		_nTLiqIt += _nTotIt - _nDscIt
		
	Next
	
	// 2a Etapa(Obter o desconto do total e ratear pelos itens):
	_nDscApl += _nTotDesc
	
	_nTLiqIt -= _nTotDesc
	//_nDscApl += (_nTLiqIt * _nPdsc1)
	
	//	_nTLiqIt := _nTLiqIt - (_nTLiqIt * _nPdsc1)
	
	//	_nDscApl += (_nTLiqIt * _nPdsc2)
	
	//	_nTLiqIt := _nTLiqIt - (_nTLiqIt * _nPdsc2)
	
	//	_nDscApl += (_nTLiqIt * _nPdsc3)
	
	//	_nTLiqIt := _nTLiqIt - (_nTLiqIt * _nPdsc3)
	
	For _nind := 1 To Len(oProcess:oHtml:RetByName("it.preco"))
		_cItem  := oProcess:oHtml:RetByName("it.item")[_nind]
		_nQuant := Val(oProcess:oHtml:RetByName("it.quant")[_nind])
		_nPreco := Val(oProcess:oHtml:RetByName("it.preco")[_nind])
		_nALIIPI:= Val(oProcess:oHtml:RetByName("it.ipi"  )[_nind])
		//_nPrazo := Val(oProcess:oHtml:RetByName("it.prazo")[_nind])
		_dDatprf:= CTOD(oProcess:oHtml:RetByName("it.datprf")[_nind])
		_nIcms  := Val(oProcess:oHtml:RetByName("it.icms")[_nind])
		//	_cObs   := oProcess:oHtml:RetByName("it.obs")[_nind]
		
		ConOut('Chave do seek ITEM :: '+ xFilial("SC8") +  PADR(_cNumero,6) + PADR(_cFornece,6)+ PADR(_cLoja,2) + _cItem)
		DbSelectArea("SC8")
		DbSetOrder(1)
		If DbSeek( xFilial("SC8") +  PADR(_cNumero,6) + PADR(_cFornece,6) + PADR(_cLoja,2) + _cItem ) .And. Empty(SC8->C8_NUMPED)
			
			If SC8->C8_VALIDA >= Date()
				
				cVerifica += "A data da validade da cotacao PERMITIU resposta;"+cEol
				RecLock("SC8",.f.)
				SC8->C8_PRECO  := _nPreco
				SC8->C8_TOTAL  := Round(_nQuant * _nPreco,2)
				SC8->C8_ALIIPI := Round(_nALIIPI,2)
				SC8->C8_PRAZO  := 0
				SC8->C8_DATPRF := _dDatprf
				SC8->C8_COND   := _cCond
				//SC8->C8_OBS    := _cObs -> Retirado por solicitacao do Moizes(Compras)
				SC8->C8_CONTATO:= _cContato
				SC8->C8_TPFRETE:= SubStr(_cTpFrete,1,1)
				/*
				SC8->C8_DESC1  := Val(oProcess:oHtml:RetByName("pdesc1"))
				SC8->C8_DESC2  := Val(oProcess:oHtml:RetByName("pdesc2"))
				SC8->C8_DESC3  := Val(oProcess:oHtml:RetByName("pdesc3"))
				*/
				SC8->C8_PICM   := Round(_nIcms,2)
				SC8->C8_VALICM := Round(_nQuant * _nPreco,2) * (Round(_nIcms,2) / 100 )
				SC8->C8_VALIPI := Round(_nQuant * _nPreco,2) * (Round(_nALIIPI,2) / 100 )
				SC8->C8_X_ENVFR  := 'R'
				/*
				SC8->C8_DTATU  := dDataBase
				*/
				
				// Se existir o campo de Observacao do Fornecedor, gravar o comentario:
				If SC8->(FieldPos("C8_X_OBS")) > 0
					SC8->C8_X_OBS := _cC8_x_OBS
				EndIf
				
				If _cTpFrete == "FOB"
					SC8->C8_ValFRE := 0
				Else
					SC8->C8_ValFRE := Round(_nTotFrete / Len(oProcess:oHtml:RetByName("it.preco")),2 )
				EndIf
				
				SC8->C8_VLDESC := Val(oProcess:oHtml:RetByName("it.dscto")[_nind]) + Round(_nDscApl / _nNroIt,2)
				
				If ( Empty(SC8->C8_TAXAFIN) )
					SC8->C8_TAXAFIN := GetMV("MV_JUROS")
				EndIf
				MsUnlock()
				
			Else
				cVerifica += "A data da validade da cotacao NAO permitiu resposta;"+cEol
				_lForaData := .t.
			EndIf
			
		EndIf
	Next
	
EndIf

oProcess:Finish()

If _lProcesso
	cVerifica += "Houve processamento e ira notificar;"+cEol
	// Notificar ao Comprador Referente a Cotacao da Solicitacao de Compras
	
	DbSelectArea('SC1')
	DbSetOrder(1)
	DbSeek(xFilial('SC1')+SC8->C8_NUMSC)
	
	DbSelectArea('SA2')
	DbSetOrder(1)
	DbSeek( xFilial("SA2")+SC8->(C8_FORNECE+C8_LOJA) )
	
	If _lForaData
		cVerifica += "Notificando o A2_EMAIL por estar fora da data: "+SA2->A2_EMAIL+" ;"+cEol
		_cComplm := " - Fora da Validade"
		cAssunto := "Cotacao respondida fora da Validade"
		cTitulo  := 'Cotacao respondida fora da Validade - Nro. '+SC8->C8_NUM
		cDetalhe := 'Senhor Fornecedor, voce tentou responder a cotacao '+SC8->C8_NUM+' fora do periodo estabelecido.'
		_cUsuario := SA2->A2_EMAIL
		U_Rcomw06(cAssunto, cTitulo, cDetalhe, _cUsuario)
	Else
		_cComplm := ""
	EndIf
	
	cVerifica += "Notificando o C8_USER: "+UsrRetMail(SC8->C8_USER)+"."+cEol
	cAssunto := "Cotacao Respondida pelo Fornecedor"+_cComplm
	cTitulo  := 'Cotacao Respondida Nro. '+SC8->C8_NUM+_cComplm
	cDetalhe := 'A cotacao '+SC8->C8_NUM+' acaba de ser Respondida pelo Fornecedor '
	cDetalhe += Trim(SA2->A2_NOME)+' / Loja '+SA2->A2_LOJA
	cDetalhe += 'Observacoes: '+_cC8_x_OBS
	_cUsuario := SC8->C8_USER
	U_Rcomw06(cAssunto, cTitulo, cDetalhe, _cUsuario)
	
	ConOut('Termino de Processamento')
Else
	cVerifica += "Nao Houve processamento."+cEol
	ConOut('Nao Houve Processamento')
EndIf

MemoWrite( '\sigaadv\Verifica'+PADR(_cNumero,6)+'.log',cVerifica )

Return