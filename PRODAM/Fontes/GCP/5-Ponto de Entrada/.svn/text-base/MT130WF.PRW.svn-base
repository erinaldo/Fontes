# include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT130WF   ºAutor  ³Jose Carlos         º Data ³  06/07/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ E acionado no final da geracao de cotacao, depois que gerouº±±
±±º          ³ o SC8 para todos os fornecedores.                          º±±
±±º          ³ Este ponto de entrada filtrara as cotacoes que ainda nao   º±±
±±º          ³ foram enviadas e enviara o link via e-mail somente se no   º±±
±±º          ³ cadastro de fornecedores o e-mail estiver informado.       º±±
±±º          ³ O Workflow  rodara via HTTPRET.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico ; Rotina de geracao de cotacoes (MATA130)      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
User Function MT130WF()
	Local aAreaAtu	:= GetArea()
	Local aAreaSC8 	:= SC8->( GetArea() )
	Local aAreaSA2	:= SA2->( GetArea() )
	Local aAreaSE4	:= SE4->( GetArea() )
	Local cIndex, cFiltro, nX
	Local numeroCotacao, codigoFornecedor, lojaFornecedor, emailFornecedor, razaoSocialFornecdor, dataEmissao, dataValidade
	Local aItens := {}
	Local aCondPag := {}
	Local aCotacoesEnviadas := {}
	
	Local cNumSolic := ParamIxb[1]
	
		//Alert( cNumSolic )      
		
		SE4->( dbSetOrder(1) )
		SE4->( dbGoTop() )
		While !SE4->( Eof() )
			AADD( aCondPag, SE4->E4_CODIGO + " - " + SE4->E4_DESCRI )
			SE4->( dbSkip() )
		EndDo
		
		cIndex	:= CriaTrab(Nil,.f.)
		ChkFile("SC8",.F.,"TMP")
		cFiltro := "C8_FILIAL=='"+xFilial("SC8")+"'.And. C8_NUM == '"+cNumSolic+"' "
		IndRegua("TMP", cIndex, "C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_PRODUTO", , cFiltro, "Filtrando Registros...")
	 	TMP->( dbGoTop() )   
		While !TMP->( Eof() )             
		    
			//campos cabecalho da cotacao
			numeroCotacao			:= TMP->C8_NUM
			codigoFornecedor 		:= TMP->C8_FORNECE
			lojaFornecedor			:= TMP->C8_LOJA
			emailFornecedor 		:= Alltrim( Posicione("SA2", 1, xFilial("SA2")+codigoFornecedor+lojaFornecedor, "A2_EMAIL") )
			razaoSocialFornecedor	:= SA2->A2_NOME
			dataEmissao				:= DtoC( TMP->C8_EMISSAO )
			dataValidade			:= DtoC( TMP->C8_VALIDA )
			aItens := {}     
			//Conout( 'Cotação: ' + numeroCotacao )
			//Conout( 'Fornecedor: ' + codigoFornecedor ) 
			//Conout( 'e-mail fornecedor: ' + emailFornecedor )
			//monta array para os itens da cotacao
			While !TMP->( Eof() ) .And. (TMP->(C8_FILIAL+C8_FORNECE+C8_LOJA) == xFilial("SC8")+codigoFornecedor+lojaFornecedor)
				AADD( aItens, { TMP->C8_ITEM, TMP->C8_PRODUTO, TMP->C8_UM, TMP->C8_QUANT, TMP->( Recno() ) } )
				TMP->( dbSkip() )
			EndDo
			
			If emailFornecedor != ""
				ConOut("Disparando cotacao para "+razaoSocialFornecedor)
				u_WfCot001( numeroCotacao, codigoFornecedor, lojaFornecedor, emailFornecedor, razaoSocialFornecedor, dataEmissao, dataValidade, aItens, aCondPag )
				
				For nX := 1 to Len ( aItens )
					AADD( aCotacoesEnviadas, aItens[nX][05] )
				Next nX
			EndIf
		EndDo
	
		dbClearFilter()	//dbClearFil()     
		dbSelectArea("TMP")
		dbClearFilter()
		dbCloseArea()
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		EndIf
	
		//atualiza campo c8_wf com 'e' (enviado)
		DbSelectArea("SC8")
	    For nX := 1 to Len ( aCotacoesEnviadas )
	    	SC8->( dbGoTo( aCotacoesEnviadas[nX] ) )
	    	RecLock("SC8", .F.)
	    	SC8->C8_WF := .T.
	    	SC8->( MsUnLock() )
	    Next nX

	RestArea(aAreaSC8)
	RestArea(aAreaSA2)
	RestArea(aAreaAtu)
		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WfCot001  ºAutor  ³Jose Carlos         º Data ³  06/07/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para enviar a cotacao via HTTPRET                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow Cotacao                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WfCot001( numeroCotacao, codigoFornecedor, lojaFornecedor, emailFornecedor, razaoSocialFornecedor, dataEmissao, dataValidade, aItens, aCondPag )
	Local oProcess
	Local cCodProcesso
	Local cHtmlModelo
	Local cMailID
	Local cTexto
	Local cAssunto    
	Local cUsuarioProtheus 
	Local aAreaSB1
	Local cUrlWF := ""
	Local cDirHTTP	:= Alltrim(GetMv('MV_WFDHTTP',.F.,'\workflow\'))
	Local nX
	
	cDirHTTP := Iif( Right( cDirHTTP, 1) != "\",cDirHTTP + "\",cDirHTTP )  
	
	cDirHTTP := cDirHTTP + "messenger\emp"+Alltrim(cEmpAnt)+"\WfCotacao\"   
	
	
	// Exemplo: --> \\Pta-erpdes02\Protheus10\Protheus_Data\WFBV\messenger\emp01\Wfcotacao
	
	MakeDir(cDirHTTP)
	
	//obtem o url que vai no link via e-mail
	cUrlWF := SuperGetMV("ES_WFURL",,"http://localhost:8081/") // [10.42.92.53:8089/wf0100]
	
	If Right( cUrlWF, 1) != "/"
		cUrlWF += "/"
	EndIF
	
	//codigo extraido do cadastro de processos wf (configurador)
	cCodProcesso := "WFCOTACAO"
	
	//template a partir do rootPath que contem o conteudo do workflow
	cHtmlModelo := "\workflow\modelos\WfCotacao.htm"
	
	//assunto da mensagem                                                            
	cAssunto := "[Workflow PRODAM] Você foi selecionado para participar de nossa cotação!"
	
	//usuario do protheus
	cUsuarioProtheus := SubStr(cUsuario, 07, 15)
	
	//inicia a classe TWFProcess e assinala a variável objeto oProcess
	oProcess := TWFProcess():New(cCodProcesso, cAssunto)

	//cria uma tarefa.
	oProcess:NewTask(cAssunto, cHtmlModelo)
	ConOut("(INICIO|WFCot001)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )
	
	oHtml := oProcess:oHTML

	// Propriedades campo Preco Produto	
	oHtml:oFieldDefs:Caption('a.vl_produto', 'Preço')
	oHtml:oFieldDefs:FieldLen('a.vl_produto',14)                
	oHtml:oFieldDefs:FieldDec('a.vl_produto',2)
	oHtml:oFieldDefs:FieldType('a.vl_produto','N')
	oHtml:oFieldDefs:FieldMinVal('a.vl_produto', 0,01 ) 
	oHtml:oFieldDefs:Required('a.vl_produto',.t. ) 
	                                   
	// Propriedades campo Data de Entrega
	oHtml:oFieldDefs:Caption('a.dt_entrega', 'Data de entrega')
	oHtml:oFieldDefs:FieldType('a.dt_entrega','D')      
	//oHtml:oFieldDefs:FieldMinVal('a.dt_entrega', Ctod(dataEmissao) )  
	//oHtml:oFieldDefs:FieldMaxVal('a.dt_entrega',Ctod(dataEmissao)+360 ) 	
	oHtml:oFieldDefs:Required('a.dt_entrega',.t. ) 				
	
	// Propriedade campo Prazo de Entrega                      
	oHtml:oFieldDefs:Caption('a.prz_entrega', 'Prazo de entrega')	
	oHtml:oFieldDefs:FieldLen('a.prz_entrega',3)                
	oHtml:oFieldDefs:FieldDec('a.prz_entrega',0)
	oHtml:oFieldDefs:FieldType('a.prz_entrega','N')
	oHtml:oFieldDefs:FieldMinVal('a.prz_entrega', 1 )  
	oHtml:oFieldDefs:FieldMaxVal('a.prz_entrega',360 ) 	    
	oHtml:oFieldDefs:Required('a.prz_entrega',.t. ) 			

	
	//assinalar valores às macros existentes no html
	oProcess:oHtml:ValByName("numeroCotacao", numeroCotacao)
	oProcess:oHtml:ValByName("codigoFornecedor", codigoFornecedor)
	oProcess:oHtml:ValByName("lojaFornecedor", lojaFornecedor)
	//oProcess:oHtml:ValByName("emailFornecedor", emailFornecedor)
	oProcess:oHtml:ValByName("razaoSocialFornecedor", razaoSocialFornecedor)
	oProcess:oHtml:ValByName("dataEmissao", dataEmissao)	
	oProcess:oHtml:ValByName("dataValidade", dataValidade)
	oProcess:oHtml:ValByName("condPagto", aCondPag )

	For nX := 1 to Len ( aItens )
		AADD( oProcess:oHtml:ValByName("a.it_produto") 	, aItens[nX][01] ) 
		AADD( oProcess:oHtml:ValByName("a.cod_produto")	, aItens[nX][02] )
		AADD( oProcess:oHtml:ValByName("a.ds_produto")	, Posicione("SB1",1,xFilial("SB1")+aItens[nX][02],"B1_DESC") )
		AADD( oProcess:oHtml:ValByName("a.um_produto")	, aItens[nX][03] )
		AADD( oProcess:oHtml:ValByName("a.qtd_produto")	, TransForm( aItens[nX][04],PesqPict("SC8","C8_QUANT") ) )
		AADD( oProcess:oHtml:ValByName("a.vl_produto")	, 0/*Transform(0.00, "@E 99,999,999,999.99")*/ )
		AADD( oProcess:oHtml:ValByName("a.prz_entrega")	, 0 )
		AADD( oProcess:oHtml:ValByName("a.obs_produto")	, "" )
		AADD( oProcess:oHtml:ValByName("a.dt_entrega")	, dataValidade )
		//AADD( oProcess:oHtml:ValByName("a.vl_desconto"), Transform(0.00, "@E 99,999.99") )
	Next nX
	
	//assunto do processo/e-mail
	oProcess:cSubject := cAssunto
	
	//informa a pasta que vai criar o htm para cada destinatario
	oProcess:cTo := "WFCOTACAO"
	
	//funcao de retorno do wf
	oProcess:bReturn := "U_WFCotR01"
	
	//inicia o processo
	cMailID := oProcess:Start(cDirHTTP) 
	oProcess:Free()
	
	//comeca agora a montar a mensagem que vai no e-mail dos destinatarios
	cHtmlModelo := "\workflow\modelos\WfLinkCot.htm"
	
	oProcess:NewTask(cAssunto, cHtmlModelo)  
	ConOut("(INICIO|WFCot001)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )
	
	oProcess:cSubject := cAssunto
	
	//agora sim informa o endereço eletrônico do destinatário
	oProcess:cTo := emailFornecedor
	
	//assinalar valores das macros do html
	oProcess:ohtml:ValByName("usuario", razaoSocialFornecedor)
//	oProcess:ohtml:ValByName("proc_link", cUrlWF+"messenger/emp"+Alltrim(cEmpAnt)+"/WfCotacao/" + cMailID + ".htm") 
	oProcess:ohtml:ValByName("proc_link", cUrlWF+"messenger/emp"+Alltrim(cEmpAnt)+"/WfCotacao/" + cMailID + ".htm")	
	oProcess:ohtml:ValByName("titulo","Solicitacao de Cotação")
	
	oProcess:Start()
	ConOut("(FINAL -> OK <- |WFCot001)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFCOTR01  ºAutor  ³Jose Carlos        º Data ³  06/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamento do retorno da cotacao                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow Cotacao                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WFCotR01(oProcess) 
    Local numeroCotacao, codigoFornecedor, lojaFornecedor, nX, aCabec, aItens, aTemp
    Local condPag	:= ""
	Local aAreaSC8 	:= SC8->( GetArea() )
	Local cLog		:= "" 
	Local nPreco	:= 0
	Local nTotal	:= 0
	Local nPrazo	:= 0
	Local cCodProd	:= ""
	
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T. 	
	
	DbSelectArea("SC8")
	SC8->( dbSetOrder(3) )
	
	ConOut("(WFCotR01|RETORNO)Inicio do Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID + " Empresa: "+ CEMPANT + " Filial: " + CFILANT ) 
	
	numeroCotacao 	:= oProcess:oHtml:RetByName("numeroCotacao")
	numeroCotacao 	:= PadR(numeroCotacao, TamSX3("C8_NUM")[1])
	
	codigoFornecedor:= oProcess:oHtml:RetByName("codigoFornecedor")
	codigoFornecedor:= PadR(codigoFornecedor, TamSX3("C8_FORNECE")[1])
	
	lojaFornecedor 	:= oProcess:oHtml:RetByName("lojaFornecedor")
	lojaFornecedor	:= PadR(lojaFornecedor, TamSX3("C8_LOJA")[1])
	
	condPag 		:= oProcess:oHtml:RetByName("condPagto")
	condPag			:= PadR(condPag, TamSX3("C8_COND")[1])    
                                              
	cLog += 'Empresa: ' + CEMPANT + CFILANT + CRLF + 'Cotação: ' + numeroCotacao + CRLF + 'Cod.Fornec.: ' + codigoFornecedor + '/' + lojaFornecedor + CRLF
	                                                                
	ConOut("(WFCotR01|RETORNO)Nr. Cotacao: " + numeroCotacao )	
	
	If SC8->( dbSeek( xFilial("SC8") + numeroCotacao ) )
	
		aCabec := {}
		aItens := {}
		
		aadd(aCabec,{"C8_FORNECE" ,SC8->C8_FORNECE})
		aadd(aCabec,{"C8_LOJA"    ,SC8->C8_LOJA})
		aadd(aCabec,{"C8_COND"    ,condPag})
		aadd(aCabec,{"C8_CONTATO" ,""})
		aadd(aCabec,{"C8_FILENT"  ,"01"})
		aadd(aCabec,{"C8_MOEDA"   ,1})
		aadd(aCabec,{"C8_EMISSAO" ,dDataBase})
		aadd(aCabec,{"C8_TOTFRE"  ,0})
		aadd(aCabec,{"C8_VALDESC" ,0})
		aadd(aCabec,{"C8_DESPESA" ,0})
		aadd(aCabec,{"C8_SEGURO"  ,0})
		aadd(aCabec,{"C8_DESC1"   ,0})
		aadd(aCabec,{"C8_DESC2"   ,0})
		aadd(aCabec,{"C8_DESC3"   ,0})
		
		For nX := 1 to Len (oProcess:oHtml:RetByName("a.it_produto"))
			
			aTemp := {}
			
			cCodProd:= oProcess:oHtml:RetByName("a.cod_produto")[nX]
			cCodProd:= PadR(cCodProd, TamSX3("C8_PRODUTO")[1])
			
			If SC8->( dbSeek( xFilial("SC8") + numeroCotacao + cCodProd + codigoFornecedor + lojaFornecedor ) )
			
				nPrazo	:= Val(oProcess:oHtml:RetByName("a.prz_entrega")[nX])
				nPreco	:= Val(oProcess:oHtml:RetByName("a.vl_produto")[nX])
				nTotal	:= NoRound(SC8->C8_QUANT * nPreco,2)
				
				AADD( aTemp, {"C8_NUMPRO"	, SC8->C8_NUMPRO	,Nil})
				AADD( aTemp, {"C8_PRODUTO"	, SC8->C8_PRODUTO	,Nil})
				AADD( aTemp, {"C8_UM"		, SC8->C8_UM		,Nil})
				AADD( aTemp, {"C8_ITEM"  	, SC8->C8_ITEM		,Nil})
				AADD( aTemp, {"C8_QUANT"	, SC8->C8_QUANT  	,Nil})
				AADD( aTemp, {"C8_PRECO"	, nPreco			,Nil})
				AADD( aTemp, {"C8_TOTAL"	, nTotal			,Nil})            
				AADD( aTemp, {"C8_PRAZO"	, nPrazo			,Nil})
				AADD( aTemp, {"C8_OBS"		, oProcess:oHtml:RetByName("a.obs_produto")[nX], Nil })
	
				AADD( aItens, aTemp )
			
			EndIf
	
		Next nX

		MSExecAuto({|x,y,z| Mata150(x,y,z)}, aCabec, aItens, 3)

		If lMsErroAuto                              
			conout("erro no execauto mata150")  
			conout(mostraerro())
		Else
			Conout('Cotação: ' + numeroCotacao + ' atualizada.')				
		EndIf

	Else
		conOut("ATENCAO: NAO CONSEGUIU POSICIONAR SC8, NAO RODOU EXECAUTO, WF CANCELADO")
	EndIf
	
	ConOut("(WFCotR01|RETORNO)Final do Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )	

	oProcess:Finish()

Return       