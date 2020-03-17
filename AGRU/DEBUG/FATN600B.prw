#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FATA600.CH"
#INCLUDE "DBTREE.CH" 

#DEFINE FIELD_VIRTUAL 14
#DEFINE FIELD_VIRTUAL 14
#DEFINE FIELD_IDFIELD  3

Static aConfigAlo 	:= {}			//Configuracao da alocacao de recurso.
Static aCamposAbo 	:= {}			//Campos da estrutura ABO.

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600SerRes
  Chama a rotina de reserva de equipamentos 
@sample 	A600SerRes() 
@since		11/03/2013       
@version	P12
/*/
//------------------------------------------------------------------------------
Function A600SerRes()
Local lVersion23	:= HasOrcSimp()
Private n  // variável utilizada dentro do mvc

If (SuperGetMV('MV_ORCSIMP',,'2') == '1') .AND. lVersion23
	MsgInfo('Não é possível incluir reserva para a proposta, pois o parâmetro de Orçamento Simplificado esta ativo (MV_ORCSIMP = 1). Acesse a rotina a partir do menu principal para realizar reservas ourindas de Orçamento simplificado', 'Atenção' )				 
Else
	//Captura proposta a ser filtrada
	At825AProp(ADY->ADY_PROPOS, ADY->ADY_PREVIS)
	//Exibe dlg para realização da reserva
	At825Res()
	//Restaura os dados capturados
	At825AProp( '', '' )
EndIf

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600VsVist
Visualiza Vistoria Tecnica.
@sample 	A600VsVist(oModel) 
@since		11/03/2013       
@version	P12
/*/
//------------------------------------------------------------------------------
Function A600VsVist(cCodVis,oModel)

Local lRetorno		:= .T.  // Retorno da validacao 
Local oMdlADY		:= Nil
Local oMdlOpor		:= Nil
Local oMdlAD1		:= Nil
Local lVersion23	:= HasOrcSimp()
Local lOrcSimp	 	:= SuperGetMV('MV_ORCSIMP',, '2') == '1' .AND. lVersion23

Default cCodVis 	:= ""
Default oModel 		:= Nil

If !lOrcSimp
	oMdlADY		:= oModel:GetModel("ADYMASTER")
	oMdlOpor	:= FT600MdlOport()
	oMdlAD1		:= oMdlOpor:GetModel("AD1MASTER")
EndIf


If Empty(cCodVis) .And. !lOrcSimp
	If ( ( oMdlAD1:GetValue("AD1_VISTEC") == "1" .AND. !Empty(oMdlAD1:GetValue("AD1_CODVIS")) .AND. oMdlAD1:GetValue("AD1_SITVIS") $ "1|2|3" ) .AND.;
		 ( oMdlADY:GetValue("ADY_VISTEC") == "2" .AND. Empty(oMdlADY:GetValue("ADY_CODVIS")) .AND. oMdlADY:GetValue("ADY_SITVIS") == "4" ) )
		cCodVis := oMdlAD1:GetValue("AD1_CODVIS")
	ElseIf ( oMdlADY:GetValue("ADY_VISTEC") == "1" .AND. !Empty(oMdlADY:GetValue("ADY_CODVIS")) .AND. oMdlADY:GetValue("ADY_SITVIS") $ "1|2|3" )
		cCodVis := oMdlADY:GetValue("ADY_CODVIS")
	EndIf 
EndIf

If !Empty(cCodVis)
	DbSelectArea("AAT")
	AAT->(DbSetOrder(1))
	
	If AAT->(DbSeek(xFilial("AAT")+cCodVis))
		FWExecView(Upper(STR0166),"VIEWDEF.TECA270",1,/*oDlg*/,/*bCloseOnOk*/,/*bOk*/,/*nPercReducao*/)    // Visualizar
	EndIf
Else
	lRetorno := .F.
	MsgAlert( STR0287 ) // "Vistoria Técnica não disponível para visualização!"
EndIf

Return(lRetorno)

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600ImpVis
Importa Vistoria Tecnica para proposta comercial.
@sample 	A600ImpVis() 
@since		11/03/2013       
@version	P12
/*/
//------------------------------------------------------------------------------
Function A600ImpVis(cCodVis,oModel,lOrcSimp,oDlgVis)

Local aAreaAAU	 	:= AAU->(GetArea())
Local cItemPai	 	:= ""					// Item Pai.
Local aProduto	 	:= {}  		   			// Array com produtos.
Local aAcessorio	:= {}					// Array com acessorio.
Local aPrdSel	 	:= {} 					// Array com produto x acessorio.
Local nLinha	 	:= 0  					// Linha atual.
Local nX		 	:= 0 					// Incremento utilizado no For.
Local nI		 	:= 0					// Incremento utilizado no For.
Local lRetorno 		:= .T. 					// Retorno da validacao.
Local oMdlGrid	 	:= Nil
Local lOrcSub  		:= .F.
Local oMdlADY		:= Nil
Local oMdlOpor		:= Nil
Local oMdlAD1		:= Nil
Local oMdlADZPrd	:= Nil
Local oMdlADZAce	:= Nil
Local cFilAAU		:= xFilial("AAU")
Local cFilSB1		:= xFilial("SB1")
Local cFilTFJ		:= xFilial('TFJ')
Local lDsgCn		:=	.F. 		

Default cCodVis		:= ""
Default lOrcSimp 	:= .F.
Default oDlgVis 	:= Nil

DbSelectArea("AAU")
AAU->(DbSetOrder(1))



If !lOrcSimp
	oMdlADY		:= oModel:GetModel("ADYMASTER")
	oMdlOpor	:= FT600MdlOport()
	oMdlAD1		:= oMdlOpor:GetModel("AD1MASTER")
	oMdlADZPrd	:= oModel:GetModel("ADZPRODUTO")
	oMdlADZAce	:= oModel:GetModel("ADZACESSOR")
	If Empty(cCodVis)
		If 	oMdlADY:GetValue("ADY_VISTEC") == "1" .AND. 	; 
			!Empty(oMdlADY:GetValue("ADY_CODVIS")) .AND.	;
			oMdlADY:GetValue("ADY_SITVIS") == "3"
			// Verifica o codigo da vistoria na tabela da proposta comercial				
			cCodVis := oMdlADY:GetValue("ADY_CODVIS")			
		ElseIf oMdlAD1:GetValue("AD1_VISTEC") == "1" .AND.	; 
	   			!Empty(oMdlAD1:GetValue("AD1_CODVIS")) .AND.	;
	   			oMdlAD1:GetValue("AD1_SITVIS") == "3" 
	   		// Verifica o codigo da vistoria na tabela de oportunidade
			cCodVis := oMdlAD1:GetValue("AD1_CODVIS")
		EndIf
	EndIf	
	
	If !Empty(cCodVis)
	
		If AAU->(DbSeek(cFilAAU+cCodVis))
			
			If Empty(oMdlADY:GetValue("ADY_TABELA"))
				//"Informe uma Tabela de Preço!"#Atencao
				lRetorno := .F.
				MsgAlert(STR0276,STR0149) // "Informe uma Tabela de Preço!"#Atencao
			ElseIf Empty(oMdlADY:GetValue("ADY_CONDPG"))
				lRetorno := .F.
				MsgAlert(STR0277,STR0149) //"Informe uma Condição de Pagamento Padrão!"#Atencao
			ElseIf Empty(oMdlADY:GetValue("ADY_TES"))
				lRetorno := .F.
				MsgAlert(STR0278,STR0149) //"Informe uma TES Padrão!"#Atencao
			EndIf
			
			If lRetorno
				DbSelectArea("TFJ")
				TFJ->( DbSetOrder( 2 ) ) // TFJ_FILIAL+TFJ_PROPOS+TFJ_PREVIS
				If TFJ->( DbSeek( cFilTFJ+oMdlADY:GetValue("ADY_PROPOS")+oMdlADY:GetValue("ADY_PREVIS") ) )
					lRetorno := .F.
					Help(,, "FT600BHASORCSER",,"Já existe orçamento de serviços para esta proposta.",1,0,,,,,,{"Exclua o existente ou faça uma nova proposta."})
				EndIf
			EndIf
	
			If lRetorno
				While(AAU->(!Eof()) .AND. AAU->AAU_FILIAL == cFilAAU .AND. AAU->AAU_CODVIS == cCodVis )
					
					If AAU->AAU_FOLDER == "1"
						
						aAdd(aProduto,{AAU->AAU_ITEM,;		// Item
						               AAU->AAU_PRODUT,;	// Cod. Produto
						               AAU->AAU_UM,;		// Unidade
						               AAU->AAU_MOEDA,;		// Moeda
						               AAU->AAU_QTDVEN,;	// Quantidade
						               AAU->AAU_PRCVEN,;	// Preco de Venda
						               AAU->AAU_PRCTAB,;	// Preco de Tabela
						               AAU->AAU_VLRTOT,;	// Valor Total
						               AAU->AAU_TPPROD,;	// Tipo de Produto
						               AAU->AAU_ITPAI,;		// Item Pai
						               AAU->AAU_FOLDER,;	// Pasta
						               AAU->AAU_LOCAL,;		// Local do item
						               AAU->AAU_CODVIS})	// Codigo da Vistoria
						
					Else
						
						aAdd(aAcessorio,{AAU->AAU_ITEM,; 	// Item
						                 AAU->AAU_PRODUT,; // Cod. Produto
						                 AAU->AAU_UM,;		// Unidade
						                 AAU->AAU_MOEDA	,; 	// Moeda
						                 AAU->AAU_QTDVEN,; // Quantidade
						                 AAU->AAU_PRCVEN,; // Preco de Venda
						                 AAU->AAU_PRCTAB,; // Preco de Tabela
						                 AAU->AAU_VLRTOT,; // Valor Total
						                 AAU->AAU_TPPROD,;	// Tipo de Produto
						                 AAU->AAU_ITPAI,;	// Item Pai
						                 AAU->AAU_FOLDER,;	// Pasta
						                 AAU->AAU_LOCAL,;	// Local do item
						                 AAU->AAU_CODVIS})	// Codigo da Vistoria
						
					EndIf
					AAU->(DbSkip())
				End
				
				If Len(aProduto) > 0
					
					For nX := 1 To Len(aProduto)
						
						aAdd(aPrdSel,{"P",;					// Produto
						              aProduto[nX][2],;		// Cod. Produto
						              aProduto[nX][3],;		// Unidade
						              aProduto[nX][4],;		// Moeda
						              aProduto[nX][5],;		// Quantidade
						              aProduto[nX][6],;		// Preco de Venda
						              aProduto[nX][7],;		// Preco de Tabela
						              aProduto[nX][8],;		// Valor Total
						              aProduto[nX][9],;		// Tipo de Produto
						              aProduto[nX][10],;	// Item Pai
						              aProduto[nX][11],;	// Pasta
						              aProduto[nX][12],;	// Local do item
						              aProduto[nX][13],;	// Codigo da Vistoria
						              aProduto[nX][1]})		// Codigo Item da vistoria
						
						nPos := aScan(aAcessorio,{|x| x[10] == aProduto[nX][1]})
						
						If nPos > 0
							
							For nI := Len(aAcessorio) To 1 Step -1
								
								If ( aAcessorio[nI][10] == aProduto[nX][1] )
									
									aAdd(aPrdSel,{"A",;					// Acessorio
									              aAcessorio[nI][2],;	// Cod. Produto
									              aAcessorio[nI][3],;	// Unidade
									              aAcessorio[nI][4],;	// Moeda
									              aAcessorio[nI][5],;	// Quantidade
									              aAcessorio[nI][6],;	// Preco de Venda
									              aAcessorio[nI][7],;	// Preco de Tabela
									              aAcessorio[nI][8],;	// Valor Total
									              aAcessorio[nI][9],;	// Tipo de Produto
									              aAcessorio[nI][10],;	// Item Pai
									              aAcessorio[nI][11],;	// Pasta
									              aAcessorio[nI][12],;	// Local do item
									              aAcessorio[nI][13],;	// Codigo da Vistoria
									              aAcessorio[nI][1]})  // Codigo Item da vistoria
									
									aDel(aAcessorio,nI)
									aSize(aAcessorio,(Len(aAcessorio)-1))
									
								EndIf
							Next nI
						EndIf
					Next nX
				EndIf
				
				If Len(aAcessorio) > 0
					
					For nX := 1 To Len(aAcessorio)
						
						aAdd(aPrdSel,{"A",;					// Acessorio
						              aAcessorio[nX][2],;	// Cod. Produto
						              aAcessorio[nX][3],;	// Unidade
						              aAcessorio[nX][4],;	// Moeda
						              aAcessorio[nX][5],;	// Quantidade
						              aAcessorio[nX][6],;	// Preco de Venda
						              aAcessorio[nX][7],;	// Preco de Tabela
						              aAcessorio[nX][8],;	// Valor Total
						              aAcessorio[nX][9],;	// Tipo de Produto
						              aAcessorio[nX][10],;	// Item Pai
						              aAcessorio[nX][11],;	// Pasta
						              aAcessorio[nX][12],;	// Local do item
						              aAcessorio[nX][13],;	// Codigo da Vistoria
						              aAcessorio[nX][1]})  // Codigo Item da vistoria
					Next nX
					
				EndIf
				
				If Len(aPrdSel) > 0
					
					lOrcSub := A600VOrc() // Valida se existe orçamento de serviços para substituição
					// Efetua a importação do orçamento de serviços
					A600CombOrc( lOrcSub, cCodVis, Nil, oModel )
								
					TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL + TFJ_CODVIS
		
					If TFJ->( DbSeek( xFilial('TFJ')+cCodVis ) )								
						lDsgCn := TFJ->TFJ_DSGCN == '1' 
					EndIf
					
					If !lDsgCn 
						For nX := 1 To Len(aPrdSel)
							
							If aPrdSel[nX][1] == "P"
								oMdlGrid := oMdlADZPrd
							Else
								oMdlGrid := oMdlADZAce 
							EndIf
							
							nLinha := oMdlGrid:Length()
							
							If A600VldPOrc( aPrdSel[nX][2] )
								// Verifica se o item pertence ao orçamento de serviços para atualizar as informações
								If oMdlGrid:SeekLine( { { "ADZ_PRODUT" , aPrdSel[nX][2] } } )
									nLinha := oMdlGrid:GetLine()
								Else
									nLinha := oMdlGrid:AddLine()
									oMdlGrid:GoLine(nLinha)
								EndIf
							ElseIf !Empty(oMdlGrid:GetValue("ADZ_PRODUT"))
								nLinha := oMdlGrid:AddLine()
								oMdlGrid:GoLine(nLinha)
							EndIf
							
							If aPrdSel[nX][1] == "P"
								cItemPai := oMdlGrid:GetValue("ADZ_ITEM")
							EndIf
							
							oMdlGrid:SetValue("ADZ_PRODUT" ,	aPrdSel[nX][2]  )                                              	// Produto
							oMdlGrid:SetValue("ADZ_DESCRI" , Posicione("SB1",1,cFilSB1+aPrdSel[nX][2],"B1_DESC"))		// Descricao
							oMdlGrid:SetValue("ADZ_UM" , aPrdSel[nX][3])    			// Unidade
							oMdlGrid:SetValue("ADZ_MOEDA" , aPrdSel[nX][4])			// Moeda
							oMdlGrid:SetValue("ADZ_QTDVEN" , aPrdSel[nX][5])			// Quantidade
							
							If lOrcSub
								oMdlGrid:SetValue("ADZ_PRCVEN" , aPrdSel[nX][6]	)	// Preco de Venda
								oMdlGrid:SetValue("ADZ_TOTAL" , aPrdSel[nX][8]	)		// Valor Total
							Else
								oMdlGrid:SetValue( "ADZ_PRCVEN", oMdlGrid:GetValue("ADZ_PRCVEN") + aPrdSel[nX][6])			// Preco de Venda
								oMdlGrid:SetValue( "ADZ_TOTAL" , oMdlGrid:GetValue("ADZ_TOTAL") + aPrdSel[nX][8])			// Valor Total
							EndIf
							
							oMdlGrid:SetValue("ADZ_PRCTAB" , aPrdSel[nX][7])		// Preco de Tabela
							oMdlGrid:SetValue("ADZ_TPPROD" , aPrdSel[nX][9])     // Tipo de Produto
							oMdlGrid:SetValue("ADZ_ITPAI" , cItemPai)	 		   // Item Pai
							oMdlGrid:SetValue("ADZ_FOLDER" , aPrdSel[nX][11] )   // Pasta
							
							oMdlGrid:SetValue("ADZ_LOCAL" , aPrdSel[nX][12]  )   // Local do item
							oMdlGrid:SetValue("ADZ_CODVIS" , aPrdSel[nX][13] )   // Codigo da Vistoria
							
							oMdlGrid:SetValue("ADZ_ITEMVI" , aPrdSel[nX][14] )   // Codigo Item da vistoria
							
							If aPrdSel[nX][1] == "P"
								If A600VldPOrc( aPrdSel[nX][2], aPrdSel[nX][13] )
									// Atualiza a condição de pagamento e TES do item da proposta
									TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL + TFJ_CODVIS
									If TFJ->( DbSeek( cFilTFJ + aPrdSel[nX][13] ) )
										oMdlGrid:SetValue("ADZ_CONDPG" , TFJ->TFJ_CONDPG )
										oMdlGrid:SetValue("ADZ_TES" , TFJ->TFJ_TES )
									EndIf
									A600AtuNItem( aPrdSel[nX][2], oMdlGrid:GetValue("ADZ_ITEM") )
								EndIf
							EndIf
							
						Next nX
					EndIf	
					
					//"Vistoria técnica importada com sucesso!"#Atencao
					MsgAlert(STR0148,STR0149)
					A600CroFinance( oModel, .T. ) //Atualiza cronograma financeiro
					
					oMdlADZPrd:GoLine(1)
					oMdlADZAce:GoLine(1)
					
				EndIf
			EndIf
		Else
			lRetorno := .F.
			MsgAlert( STR0288, STR0149 ) // "Problemas para localizar a Vistoria Técnica!"#"Atenção"
		EndIf
	
	Else
		lRetorno := .F.
		MsgAlert( STR0289, STR0149 ) // "Vistoria Técnica não disponível para importação!"#"Atenção"
	EndIf
Else
	lRetorno := At270Orc(.T.,cCodVis)
	If lRetorno 
		oDlgVis:End()	
	EndIf
EndIf
RestArea(aAreaAAU)

Return(lRetorno)

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600LtVist
Busca as vistorias tecnicas para oportunidade de venda.
@sample 	A600LtVist() 
@since		11/03/2013       
@version	P12
/*/
//------------------------------------------------------------------------------
Static Function A600LtVist()    

Local aArea      	:= AAT->(GetArea())        					// Area atual.
Local aAreaAAT   	:= AAT->(GetArea())                         	// Area da tabela AAT.
Local aRet	     	:= {}  										// Array com as vistorias.
Local aLegenda   	:= {}  										// Array com as legendas.  
Local cNome	     	:= ""   										// Nome do tecnico.
Local nPos 	   	 	:= 0											// Posicao do elemento a ser procurado.
Local oAberto    	:= LoadBitMap(GetResources(),"BR_VERDE")     	// Legenda verde.       
Local oAgendado  	:= LoadBitMap(GetResources(),"BR_AMARELO")  	// Legenda amarelo. 
Local oConcluido 	:= LoadBitMap(GetResources(),"BR_VERMELHO") 	// Legenda vermelho.
Local oCancelado 	:= LoadBitMap(GetResources(),"BR_PRETO")     	// Legenda preto.
Local oMdlOpor		:= Nil
Local oMdlAD1		:= Nil
Local cFilAAT		:= xFilial("AAT")
Local cFilAA1		:= xFilial("AA1")
Local lVersion23	:= HasOrcSimp()
Local lOrcSimp	 	:= SuperGetMV('MV_ORCSIMP',, '2') == '1' .AND. lVersion23
Local cAliasAAT		:= GetNextAlias()

aAdd(aLegenda,{"1",oAberto})
aAdd(aLegenda,{"2",oAgendado})
aAdd(aLegenda,{"3",oConcluido})
aAdd(aLegenda,{"4",oCancelado})

DbSelectArea("AAT")
DbSetOrder(2)

If !lOrcSimp 
	oMdlOpor	:= FT600MdlOport()  
	oMdlAD1		:= oMdlOpor:GetModel("AD1MASTER")
	If DbSeek(cFilAAT+oMdlAD1:GetValue("AD1_NROPOR"))  

		While( AAT->(!Eof()) .AND. AAT->AAT_FILIAL == cFilAAT;
		      .AND. AAT->AAT_OPORTU == oMdlAD1:GetValue("AD1_NROPOR") )   
			nPos := aScan(aLegenda,{|x| x[1]==AAT->AAT_STATUS})  
			cNome := Alltrim( Posicione("AA1",1,cFilAA1+AAT->AAT_VISTOR,"AA1_NOMTEC") )
			aAdd(aRet,{ aLegenda[nPos][2]	,;
		    			AAT->AAT_CODVIS		,;  
		    			AAT->AAT_VISTOR		,;
		    			cNome				,;
		    			AAT->AAT_PROPOS		,; 
		    			AAT->AAT_PREVIS		,;
		    			AAT->AAT_EMISSA		,;
		    			AAT->AAT_DTINI		,;
		    			AAT->AAT_HRINI		,;
		    			AAT->AAT_DTFIM		,;
		    			AAT->AAT_HRFIM		,;
		    			AAT->AAT_STATUS })
			
			AAT->(DbSkip())
		EndDo	
	EndIf	
Else
	BeginSQL Alias cAliasAAT
		SELECT AAT_CODVIS, AAT_VISTOR, AAT_EMISSA, AAT_DTINI, AAT_HRINI, AAT_DTFIM, AAT_HRFIM, AAT_STATUS
		FROM %Table:AAT%
		 WHERE AAT_FILIAL = %xFilial:AAT%
		   AND (AAT_CODORC = '' OR  AAT_CODORC = %Exp:Space(TamSx3("AAT_CODORC")[1])%)
		   AND (AAT_OPORTU = ''  OR  AAT_OPORTU = %Exp:Space(TamSx3("AAT_OPORTU")[1])%)
		   AND AAT_STATUS = '3'
		   AND %NotDel%
	EndSQL
	
		While (cAliasAAT)->(!Eof())   
			nPos := aScan(aLegenda,{|x| x[1]==(cAliasAAT)->(AAT_STATUS)})  
			cNome := Alltrim( Posicione("AA1",1,cFilAA1+(cAliasAAT)->(AAT_VISTOR),"AA1_NOMTEC") )
			aAdd(aRet,{ aLegenda[nPos][2]	,;
		    			(cAliasAAT)->(AAT_CODVIS),;  
		    			(cAliasAAT)->(AAT_VISTOR),;
		    			cNome				,;		    			
		    			(cAliasAAT)->(AAT_EMISSA),;
		    			(cAliasAAT)->(AAT_DTINI),;
		    			(cAliasAAT)->(AAT_HRINI),;
		    			(cAliasAAT)->(AAT_DTFIM),;
		    			(cAliasAAT)->(AAT_HRFIM),;
		    			(cAliasAAT)->(AAT_STATUS)})
			
			(cAliasAAT)->(DbSkip())
		EndDo	
	
EndIf

RestArea(aArea)
RestArea(aAreaAAT)
Return(aRet)        

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600ConVis
Consulta Vistoria Tecnica.
@sample 	A600ConVis(oModel) 
@since		11/03/2013       
@version	P12
/*/
//------------------------------------------------------------------------------
Function A600ConVis(oModel)

Local oBtnImv			:= Nil		// Botão Imprimir Modelo
Local oBtnFil		:= Nil		// Botão Imprimir Modelo
Local oBtnVis 		:= Nil		// Botao visuaizar.
Local oBtnImp 		:= Nil		// Botao importar.
Local oBtnVxp 		:= Nil		// Botao vistoria x proposta.
Local oBtnSai 		:= Nil 	// Botao sair.
Local oGroup1 		:= Nil		// Grupo vistoria tecnica.
Local oGroup2	 	:= Nil 	// Grupo status.
Local oListVist  	:= Nil     // Listbox vistoria tecnica.
Local oDlgVis    	:= Nil   	// Dialog consulta viatoria tecnica. 
Local oAberto    	:= Nil		// Legenda aberto. 
Local oAgendado  	:= Nil  	// Legenda agendado.
Local oConcluido 	:= Nil		// Legenda concluido.
Local oCancelado 	:= Nil		// Legenda cancelado.   
Local oBold 	 	:= Nil		// Formatacao.
Local aVistoria 	:= {}
Local lRetorno 	:= .T.
Local oMdlADY		:= Nil
Local nOperacao		:= 0
Local lVersion23	:= HasOrcSimp()
Local lOrcSimp	 	:= SuperGetMV('MV_ORCSIMP',, '2') == '1' .AND. lVersion23
Local nDiffBtn		:= 0
Local oFilGet		:= Nil
Local cFilGet		:= Space(6)

Default oModel := Nil

// Atribui o model da proposta para uso nas operações da vistoria
If !lOrcSimp
	oMdlProp := oModel

	oMdlADY		:= oModel:GetModel("ADYMASTER")
	nOperacao	:= oModel:GetOperation()
	If Empty(oMdlADY:GetValue("ADY_TABELA"))
		//"Informe uma Tabela de Preço!"#Atencao
		lRetorno := .F.
		MsgAlert(STR0276,STR0149)	//"Informe uma Tabela de Preço!"
	ElseIf Empty(oMdlADY:GetValue("ADY_CONDPG"))
		lRetorno := .F.
		MsgAlert(STR0277,STR0149)	//"Informe uma Condição de Pagamento Padrão!"
	ElseIf Empty(oMdlADY:GetValue("ADY_TES"))
		lRetorno := .F.
		MsgAlert(STR0278,STR0149)	//"Informe uma TES Padrão!"
	EndIf
EndIf

If lRetorno 
	MsgRun('Pesquisando vistorias','Aguarde...',{|| aVistoria 	:= A600LtVist() })	//"Realizando carga do Orçamento" ## "Aguarde"
	
	If Len(aVistoria) > 0
	
		If !lOrcSimp
			DEFINE MSDIALOG oDlgVis  TITLE STR0151 FROM 000, 000  TO 340, 680 COLORS 0, 16777215 PIXEL  // "Consulta Vistoria Técnica"
			
			@ 002, 004 GROUP oGroup1 TO 124, 339 PROMPT STR0152 OF oDlgVis  COLOR 0, 16777215 PIXEL  // "Vistoria(s) Técnica"
			@ 012, 009 LISTBOX oListVist FIELDS COLSIZES 10,30,30,110,25,40,35,40,35;
					HEADER  ""		   	,;
							STR0153		,; //"Vistoria"
				   			STR0154  	,; //"Vistoriador" 
				   			STR0155		,; //"Nome" 
				   			STR0170		,; //"Proposta"
				   			STR0171		,; //"Revisão"	
				   			STR0156		,; //"Emissao"
							STR0157		,; //"Data de Inicio"
							STR0158		,; //"Hora de Inicio"
							STR0159   	,; //"Data Final"
				   			STR0160   	,; //"Hora Final"
					SIZE 330, 108 OF oDlgVis  PIXEL;
					ON CHANGE (	( IIF(!Empty(oListVist:aArray[oListVist:nAt,5]) .AND. (oListVist:aArray[oListVist:nAt,5] == oMdlADY:GetValue("ADY_PROPOS")) .AND.;
								oListVist:aArray[oListVist:nAt,12] == "3" .And. ; 
								(nOperacao == MODEL_OPERATION_INSERT .OR. nOperacao == MODEL_OPERATION_UPDATE),oBtnVxp:bWhen := {||.T.},oBtnVxp:bWhen := {||.F.}) ),;
								( IIF(oListVist:aArray[oListVist:nAt,12] == "3" .AND. ( Empty(oListVist:aArray[oListVist:nAt,5]) .OR.;
								(oListVist:aArray[oListVist:nAt,5] == oMdlADY:GetValue("ADY_PROPOS") ) ) .AND.;
								(nOperacao == MODEL_OPERATION_INSERT .OR. nOperacao == MODEL_OPERATION_UPDATE),oBtnImp:bWhen := {||.T.},oBtnImp:bWhen := {||.F.}),;
								(oBtnVxp:SetFocus(),oBtnImp:SetFocus(),oListVist:SetFocus()) ) )
		
		Else
			nDiffBtn := 67
			DEFINE MSDIALOG oDlgVis  TITLE STR0151 FROM 000, 000  TO 340, 680 COLORS 0, 16777215 PIXEL  // "Consulta Vistoria Técnica"
		                                                         
			@ 002, 004 GROUP oGroup1 TO 124, 339 PROMPT STR0152 OF oDlgVis  COLOR 0, 16777215 PIXEL  // "Vistoria(s) Técnica"
			@ 012, 009 LISTBOX oListVist FIELDS COLSIZES 10,30,30,110,25,40,35,40,35;
					HEADER  ""		   	,;
							STR0153		,; //"Vistoria"
				   			STR0154  	,; //"Vistoriador" 
				   			STR0155		,; //"Nome" 				   			
				   			STR0156		,; //"Emissao"
							STR0157		,; //"Data de Inicio"
							STR0158		,; //"Hora de Inicio"
							STR0159   	,; //"Data Final"
				   			STR0160   	,; //"Hora Final"
					SIZE 330, 108 OF oDlgVis  PIXEL
		EndIf			                                                         
		oListVist:SetArray(aVistoria)
		
		If lVersion23
			oListVist:bLine := {|| {	aVistoria[oListVist:nAt,1]		,;
										aVistoria[oListVist:nAt,2]		,;
								   		aVistoria[oListVist:nAt,3]		,;
										aVistoria[oListVist:nAt,4]		,;
								   		aVistoria[oListVist:nAt,5]		,;
								   		aVistoria[oListVist:nAt,6]		,;
								   		aVistoria[oListVist:nAt,7]		,;
								   		aVistoria[oListVist:nAt,8]		,;
								   		aVistoria[oListVist:nAt,9]		}}
		Else
			oListVist:bLine := {|| {	aVistoria[oListVist:nAt,1]		,;
							aVistoria[oListVist:nAt,2]		,;
					   		aVistoria[oListVist:nAt,3]		,;
							aVistoria[oListVist:nAt,4]		,;
					   		aVistoria[oListVist:nAt,5]		,;
					   		aVistoria[oListVist:nAt,6]		,;
					   		aVistoria[oListVist:nAt,7]		,;
					   		aVistoria[oListVist:nAt,8]		,;
					   		aVistoria[oListVist:nAt,9]		,;
					   		aVistoria[oListVist:nAt,10] 		,;
					   		aVistoria[oListVist:nAt,11]		}}
		EndIf					
		DEFINE FONT oBold NAME "Arial" SIZE 0, -11 BOLD 
		
		@ 128, 004 GROUP oGroup2 TO 146, 339 PROMPT STR0161 OF oDlgVis COLOR 0, 16777215 PIXEL      // "Status"
		
		@ 136,010 BITMAP oAberto    RESNAME "BR_VERDE" 		OF oDlgVis  SIZE 20,10 PIXEL NOBORDER 
		@ 136,020 SAY STR0162 FONT oBold OF oDlgVis PIXEL SIZE 50,10	// "Aberto"
		@ 136,050 BITMAP oAgendado  RESNAME "BR_AMARELO" 	OF oDlgVis  SIZE 20,10 PIXEL NOBORDER   
		@ 136,060 SAY STR0163 FONT oBold OF oDlgVis PIXEL SIZE 50,10   	// "Agendado"
		@ 136,100 BITMAP oConcluido RESNAME "BR_VERMELHO"	OF oDlgVis SIZE 20,10 PIXEL NOBORDER 
		@ 136,110 SAY STR0164 FONT oBold OF oDlgVis PIXEL SIZE 50,10  	// "Concluido"
		@ 136,150 BITMAP oCancelado RESNAME "BR_PRETO" 		OF oDlgVis  SIZE 20,10 PIXEL NOBORDER 
		@ 136,160 SAY STR0165 FONT oBold OF oDlgVis PIXEL SIZE 50,10   // "Cancelado"
					
			
		If lOrcSimp 
			@ 147, 004 SAY 'Código Vistória' SIZE 50,10 PIXEL OF oDlgVis 
			@ 154, 004 MSGET oFilGet VAR cFilGet SIZE 60,6 OF oDlgVis PIXEL
			@ 152, 70 BUTTON oBtnFil PROMPT 'Pesquisar' SIZE 060, 012 OF oDlgVis Action A600FilVis(aVistoria,@oListVist,cFilGet) PIXEL    // "Imprimir Modelo"
		EndIf	
		
		@ 152, 075 + nDiffBtn BUTTON oBtnImv PROMPT STR0182 SIZE 060, 012 OF oDlgVis Action A600RelVis(oListVist:aArray[oListVist:nAt,2]) PIXEL    // "Imprimir Modelo"
		@ 152, 141 + nDiffBtn BUTTON oBtnVis PROMPT STR0166 SIZE 040, 012 OF oDlgVis  PIXEL ACTION A600VsVist(oListVist:aArray[oListVist:nAt,2],oModel)   // "Visualizar"
		@ 152, 187 + nDiffBtn BUTTON oBtnImp PROMPT STR0167 SIZE 040, 012 OF oDlgVis ACTION A600ImpVis(oListVist:aArray[oListVist:nAt,2],oModel,lOrcSimp,oDlgVis)  PIXEL 		// "Importar"
		If !lOrcSimp 
			@ 152, 233 BUTTON oBtnVxp PROMPT STR0168 SIZE 060, 012 OF oDlgVis ACTION TECA280(oListVist:aArray[oListVist:nAt,2],oModel)  PIXEL // "Vistoria x Proposta"		
		EndIf			
		@ 152, 299 BUTTON oBtnSai PROMPT STR0169 SIZE 040, 012 OF oDlgVis ACTION oDlgVis:End()  PIXEL    // "Sair"
		
		ACTIVATE MSDIALOG oDlgVis  CENTERED
	
	Else
		lRetorno := .F.
		If !lOrcSimp 
			MsgAlert(STR0279)	//"Não há Vistoria(s) Técnica elaborada para esta Proposta Comercial."
		Else
			MsgAlert(STR0411) //"Não há vistória técnica elaborada para importação."
		EndIf 	
	EndIf

EndIf
	
Return(lRetorno) 

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600RelVis
Faz a chamada da função que Imprime os documentos via integração com WORD.

@sample 	A600RelVis(cCodVis)  
@since		11/03/2013       
@version	P12
/*/
//------------------------------------------------------------------------------
Function A600RelVis(cCodVis)   

Local lRet	:= .T.
Local cTemplate	:= "VistoriaTec"

DbSelectArea("AAT")
DbSetOrder(1)

If DbSeek(xFilial("AAT")+cCodVis) 

	If A600OpcImp()
		If MsgYesNo(STR0183) //"Deseja imprimir a Vistoria?"
			FATR600(cTemplate)
		EndIf
	EndIf    

EndIf

Return (lRet)

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600OpcImp
Verifica se há necessidade de habilitar a opção de impressão da proposta comercial.

@sample 	A600OpcImp()
@since		11/03/2013
@version	P12
/*/
//------------------------------------------------------------------------------
Static Function A600OpcImp()

Local lRet 		:= .F.									// Retorno da Funcao
Local lDocument	:= .F.									// Define se o modelo de documento word ("DOT") foi encontrado no servidor
Local lFunction  	:= .F.									// Define se o RdMake para impressao de proposta foi compilada no RPO
Local cUsrFunc	:= ""									// Nome do RdMake
Local lFT600IMP	:= FindFunction("U_FT600IMP")		// Ponto de entrada para customizar a impressao da proposta
Local cPathServer	:= Alltrim(SuperGetMv("MV_DOCAR"))	// Diretorio que estao os DOTS originais ("\sigaadv\samples\documents\crm\portugues")
Local cExt	     	:= ".DOT"
Local cFilAG1		:= xFilial("AG1")
Local cFilAG2		:= xFilial("AG2")
Local cFilAG4		:= xFilial("AG4")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso ponto de entrada lFT600IMP for compilado ³
//³no RPO, habilitar a opcao de impressao.	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFT600IMP
	lRet := .T.
	Return( lRet )
EndIf

DbSelectArea("AG1")
DbSetOrder(1)
DbSelectArea("AG2")
DbSetOrder(1)
DbSelectArea("AG4")
DbSetOrder(1)
If AG1->(DbSeek(cFilAG1))
	While AG1->(!EOF())  .AND. AG1->AG1_FILIAL == cFilAG1
		
		If AG2->(DbSeek(cFilAG2+AG1->AG1_CODIGO))
			While AG2->(!EOF()) .AND. AG2->AG2_FILIAL == cFilAG2
				If AG4->(DbSeek(cFilAG4+AG2->AG2_COMPAS))
					
					If !Empty(AG4->AG4_FUNCAO)
						cUsrFunc  := "U_"+AllTrim(AG4->AG4_FUNCAO)
						lFunction := FindFunction(cUsrFunc)
					EndIf
					If !Empty(AG4->AG4_DOCWOR)
						cDocWord := AllTrim(AG4->AG4_DOCWOR)
						If File(cPathServer+cDocWord+cExt)
							lDocument := .T.
						EndIf
					EndIf
					If lFunction .AND. lDocument
						lRet := .T.
						Return( lRet )
					EndIf
					
				EndIf
				AG2->(DbSkip())
			EndDo
		EndIf
		
		AG1->(DbSkip())
	EndDo
EndIf
Return( lRet )

//-----------------------------------------------------------------------------------------
/*/{Protheus.doc} At600Cort
Verifica se a referencia é uma cortesia

@sample     At600Cort( cGrupo, oSrvOrc )

@param		cGrupo, Identificação do grupo a ser consistido
@param		oSrvOrc, Objeto do orçamento de serviços

@return     lRet, Verifica se for uma cortesia

@author     Serviços
@since      30/07/2014
@version    P12
/*/
//-----------------------------------------------------------------------------------------
Function At600Cort( cGrupo, oSrvOrc )

Local lRet 	:= .F.
Local cCmpCob := ""

Local oMdlOrc, nI 

If cGrupo <> "TFJ_GRPLE"

	If cGrupo == "TFJ_GRPRH"
		oMdlOrc := oSrvOrc:GetModel("TFF_RH")
		cCmpCob := "TFF_COBCTR"
 	ElseIf cGrupo == "TFJ_GRPMI"
		oMdlOrc := oSrvOrc:GetModel("TFG_MI")
		cCmpCob := "TFG_COBCTR" 	
 	ElseIf cGrupo == "TFJ_GRPMC"
		oMdlOrc := oSrvOrc:GetModel("TFH_MC")
		cCmpCob := "TFH_COBCTR" 	
 	EndIf	
	
	For nI:=1 To oMdlOrc:Length()	
		oMdlOrc:GoLine(nI)		
		If oMdlOrc:GetValue(cCmpCob) == "2"
			lRet := .T.
		EndIf		
	Next nI

EndIf

Return(lRet)

//-----------------------------------------------------------------------------------------
/*/{Protheus.doc} At600RAloc
Retorna a configuracao da alocacao de recurso para proposta

@sample     At600RAloc(oMdlGrid,oMdlFields,oGetPrd,oGetAce,oViewPrp)

@param		ExpO1 - Modelo de Dados Itens da Proposta.
@param		ExpO2 - Modelo de Dados Conf. de Alocacao de Recurso.

@return     ExpL - Verdadeiro		

@author     Serviços
@since      30/07/2014
@version    P12
/*/
//-----------------------------------------------------------------------------------------

Function At600RAloc(oMdlGrid,oMdlFields,oGetPrd,oGetAce,oViewPrp)

Local oStructAbo	:= oMdlFields:GetStruct()		  								   		// Retorna a estrutura atual.
Local nPItem		:= aScan(oGetPrd:aHeader,{|x|AllTrim(x[2]) == "ADZ_ITEM"})			// Item da proposta comercial.
Local nPQtdVen	:= aScan(oGetPrd:aHeader,{|x|AllTrim(x[2]) == "ADZ_QTDVEN"}) 			// Quantidade de venda.
Local nPPrVen		:= aScan(oGetPrd:aHeader,{|x|AllTrim(x[2]) == "ADZ_PRCVEN"})			// Preco de venda.
Local nPTotal		:= aScan(oGetPrd:aHeader,{|x|AllTrim(x[2]) == "ADZ_TOTAL" })			// Valor total. 
Local cFolder		:= ""																	// Folder da proposta.
Local cItem			:= ""																	// Item da proposta.  
Local cProdut		:= ""																	// Produto da proposta. 
Local nX		  	:= 0 																	// Incremento utilizado no laco For.
Local nI			:= 0													 				// Incremento utilizado no laco For.
Local nPos			:= 0
Local oMdlProp	:= oViewPrp:GetModel() 																	// Posicao do elemento.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa os array estatico. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aConfigAlo := Ft600GetAloc()
aConfigAlo := {}
aCamposAbo := {}

oGetDadP := oMdlProp:GetModel("ADZPRODUTO")
oGetDadA := oMdlProp:GetModel("ADZACESSOR")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna os campos da estrutura esta estrutura sera utilizada na gravacao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCamposAbo := aClone( oStructAbo:GetFields() )

For nX := 1 To oMdlGrid:Length()
	oMdlGrid:GoLine(nX)
	cFolder := oMdlGrid:GetValue("ADZ_FOLDER")
	cItem	:= oMdlGrid:GetValue("ADZ_ITEM") 
	cProdut	:= oMdlGrid:GetValue("ADZ_PRODUT")
	aAdd(aConfigAlo,{cFolder+cItem+cProdut,Array(Len(aCamposAbo))})
	For nI := 1 To Len(aCamposAbo)
		
		aConfigAlo[nX][2][nI] := oMdlFields:GetValue(Alltrim(aCamposAbo[nI][3]))
		
		If Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_TOTAL"
			If cFolder == "1"
				nPos := aScan(oGetPrd:aCols,{|x| x[nPItem] == cItem }) 
				If nPos > 0 
					oGetPrd:aCols[nPos][nPQtdVen]	:= aConfigAlo[nX][2][nI]  								   		// Quantidade
			  		oGetPrd:aCols[nPos][nPTotal]	:= (aConfigAlo[nX][2][nI] * oGetPrd:aCols[nPos][nPPrVen])	// Valor total		
				EndIf	
			ElseIf cFolder == "2"
				nPos := aScan(oGetAce:aCols,{|x| x[nPItem] == cItem }) 
				If nPos > 0 
					oGetAce:aCols[nPos][nPQtdVen]	:= aConfigAlo[nX][2][nI]   									// Quantidade
					oGetAce:aCols[nPos][nPTotal]	:= (aConfigAlo[nX][2][nI] * oGetAce:aCols[nPos][nPPrVen])	// Valor total
				EndIf
			EndIf
		EndIf
		
	Next nI
Next nX   

Ft600SetAloc(aConfigAlo)

A600CroFinance(oMdlProp,.T.) 
A600Total(,oMdlProp)

Return( .T. ) 

//-----------------------------------------------------------------------------------------
/*/{Protheus.doc} A600GrvAloc
Gravacao da configuracao de alocacao de recurso

@sample     A600GrvAloc(  )

@return     ExpL - Verdadeiro		

@author     Serviços
@since      26/08/2014
@version    P12
/*/
//-----------------------------------------------------------------------------------------
Function A600GrvAloc(cRevis, oGetDadP, oGetDadA )

Local nPProd	:= aScan(oGetDadP:aHeader,{|x|AllTrim(x[2]) == "ADZ_PRODUT"})
Local nX		  	:= 0																				// Incremento utilizado para gravar a configuracao da alocacao de recurso.
Local nI		  	:= 0																				// Incremento utilizado para gravar a configuracao da alocacao de recurso.
Local nPos		  	:= 0																				// Posicao atual do elemento.
Local nPProp		:= aScan(oGetDadP:aHeader,{|x|AllTrim(x[2]) == "ADZ_PROPOS"})						// Posicao do campo no aHeader.
Local nPRevProp		:= aScan(oGetDadP:aHeader,{|x|AllTrim(x[2]) == "ADZ_REVISA"}) 						// Posicao do campo no aHeader.
Local nPItem		:= aScan(oGetDadP:aHeader,{|x|AllTrim(x[2]) == "ADZ_ITEM"})   						// Posicao do campo no aHeader.
Local nPQtdVen		:= aScan(oGetDadP:aHeader,{|x|AllTrim(x[2]) == "ADZ_QTDVEN"}) 						// Posicao do campo no aHeader.
Local nPrdAloc		:= aScan(oGetDadP:aHeader,{|x|AllTrim(x[2]) == "ADZ_PRDALO"}) 						// Posicao do campo no aHeader.
Local nPTpProd		:= aScan(oGetDadP:aHeader,{|x|AllTrim(x[2]) == "ADZ_TPPROD"}) 						// Posicao do campo no aHeader.
Local nPosTotal     := 0																				// Total definido na configuracao da alocacao de recurso.
Local cFolder		:= "" 																				// Folder atual.
Local aABODuplic	:={}
Local aRet 		:= {}
Local lRetorno     := .T.

DbSelectArea("ABO")
DbSetOrder(1)
aConfigAlo := Ft600GetAloc() 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravação do configuracao da alocacao para folder produto.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFolder := "1"
For nX := 1 To Len(oGetDadP:aCols)
	
	nPos := aScan(aConfigAlo,{|x| x[1] == cFolder+oGetDadP:aCols[nX][nPItem]+oGetDadP:aCols[nX][nPProd]})
	
	If ( nPos > 0 .AND. !aTail(oGetDadP:aCols[nX]) .AND. oGetDadP:aCols[nX][nPrdAloc] == "1" )
		
		RecLock("ABO",.T.)
		For nI := 1 To Len(aCamposAbo)
			If !aCamposAbo[nI][FIELD_VIRTUAL]
				Do Case
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_PROPOS"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := M->ADY_PROPOS
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_REVPRO"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := cRevis
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_TPPROD"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := oGetDadP:aCols[nX][nPTpProd]
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_FATOR"
						nPosTotal := aScan(aCamposAbo,{|x| x[FIELD_IDFIELD] == "ABO_TOTAL"})
						If aConfigAlo[nPos][2][nPosTotal] <> oGetDadP:aCols[nX][nPQtdVen]
							&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := 0
						Else
							&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := aConfigAlo[nPos][2][nI]
						EndIf
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_TOTAL"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := oGetDadP:aCols[nX][nPQtdVen]
					OtherWise
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := aConfigAlo[nPos][2][nI]
				EndCase
			EndIf
		Next nI
		lRetorno	:=	.T.
		MsUnLock()
		
	ElseIf ( !aTail(oGetDadP:aCols[nX]) .AND. oGetDadP:aCols[nX][nPrdAloc] == "1" )
		
		If DbSeek(	xFilial("ABO")+oGetDadP:aCols[nX][nPProp]+oGetDadP:aCols[nX][nPRevProp]+;
			cFolder+oGetDadP:aCols[nX][nPItem]+oGetDadP:aCols[nX][nPProd] )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Limpa o array para duplicar o registro.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aABODuplic := {}
			
			For nI := 1 To ABO->(FCount())
				aAdd(aABODuplic,{FieldName(nI),&("ABO->"+FieldName(nI))})
			Next nI
			
			If Len(aABODuplic) > 0
				
				RecLock("ABO",.T.)
				For nI := 1 To Len(aABODuplic)
					Do Case
						Case AllTrim(aABODuplic[nI][1]) == "ABO_PROPOS"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := M->ADY_PROPOS
						Case AllTrim(aABODuplic[nI][1]) == "ABO_REVPRO"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := cRevis
						Case AllTrim(aABODuplic[nI][1]) == "ABO_TPPROD"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := oGetDadP:aCols[nX][nPTpProd]
						Case AllTrim(aABODuplic[nI][1]) == "ABO_FATOR"
							nPosTotal := aScan(aABODuplic,{|x| x[1] == "ABO_TOTAL"})
							If aABODuplic[nPosTotal][2] <> oGetDadP:aCols[nX][nPQtdVen]
								&("ABO->"+AllTrim(aABODuplic[nI][1])) := 0
							Else
								&("ABO->"+AllTrim(aABODuplic[nI][1])) := aABODuplic[nI][2]
							EndIf
						Case AllTrim(aABODuplic[nI][1]) == "ABO_TOTAL"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := oGetDadP:aCols[nX][nPQtdVen]
						OtherWise
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := aABODuplic[nI][2]
					EndCase
				Next nI
				lRetorno	:=	.T.
				MsUnLock()
				
			EndIf
			
		EndIf
		
	EndIf
	
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravação do configuracao da alocacao para folder acessorio.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFolder := "2"
For nX := 1 To Len(oGetDadA:aCols)
	
	nPos := aScan(aConfigAlo,{|x| x[1] == cFolder+oGetDadA:aCols[nX][nPItem]+oGetDadA:aCols[nX][nPProd]})
	
	If ( nPos > 0 .AND. !aTail(oGetDadA:aCols[nX]) .AND. oGetDadA:aCols[nX][nPrdAloc] == "1" )
		
		RecLock("ABO",.T.)
		For nI := 1 To Len(aCamposAbo)
			If !aCamposAbo[nI][FIELD_VIRTUAL]
				Do Case
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_PROPOS"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := M->ADY_PROPOS
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_REVPRO"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := cRevis
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_TPPROD"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := oGetDadA:aCols[nX][nPTpProd]
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_FATOR"
						nPosTotal := aScan(aCamposAbo,{|x| x[FIELD_IDFIELD] == "ABO_TOTAL"})
						If aConfigAlo[nPos][2][nPosTotal] <> oGetDadA:aCols[nX][nPQtdVen]
							&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := 0
						Else
							&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := aConfigAlo[nPos][2][nI]
						EndIf
					Case Alltrim(aCamposAbo[nI][FIELD_IDFIELD]) == "ABO_TOTAL"
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := oGetDadA:aCols[nX][nPQtdVen]
					OtherWise
						&(Alltrim(aCamposAbo[nI][FIELD_IDFIELD])) := aConfigAlo[nPos][2][nI]
				EndCase
			EndIf
		Next nI
		lRetorno	:=	.T.
		MsUnLock()
		
	ElseIf ( !aTail(oGetDadA:aCols[nX]) .AND. oGetDadA:aCols[nX][nPrdAloc] == "1" )
		
		If DbSeek(	xFilial("ABO")+oGetDadA:aCols[nX][nPProp]+oGetDadA:aCols[nX][nPRevProp]+;
			cFolder+oGetDadA:aCols[nX][nPItem]+oGetDadA:aCols[nX][nPProd] )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Limpa o array para duplicar o registro.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aABODuplic := {}
			
			For nI := 1 To ABO->(FCount())
				aAdd(aABODuplic,{FieldName(nI),&("ABO->"+FieldName(nI))})
			Next nI
			
			If Len(aABODuplic) > 0
				
				RecLock("ABO",.T.)
				For nI := 1 To Len(aABODuplic)
					Do Case
						Case AllTrim(aABODuplic[nI][1]) == "ABO_PROPOS"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := M->ADY_PROPOS
						Case AllTrim(aABODuplic[nI][1]) == "ABO_REVPRO"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := cRevis
						Case AllTrim(aABODuplic[nI][1]) == "ABO_TPPROD"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := oGetDadA:aCols[nX][nPTpProd]
						Case AllTrim(aABODuplic[nI][1]) == "ABO_FATOR"
							nPosTotal := aScan(aABODuplic,{|x| x[1] == "ABO_TOTAL"})
							If aABODuplic[nPosTotal][2] <> oGetDadA:aCols[nX][nPQtdVen]
								&("ABO->"+AllTrim(aABODuplic[nI][1])) := 0
							Else
								&("ABO->"+AllTrim(aABODuplic[nI][1])) := aABODuplic[nI][2]
							EndIf
						Case AllTrim(aABODuplic[nI][1]) == "ABO_TOTAL"
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := oGetDadA:aCols[nX][nPQtdVen]
						OtherWise
							&("ABO->"+AllTrim(aABODuplic[nI][1])) := aABODuplic[nI][2]
					EndCase
				Next nI
				lRetorno	:=	.T.
				MsUnLock()
				
			EndIf
			
		EndIf
		
	EndIf
	
Next nX

Return lRetorno

//-----------------------------------------------------------------------------------------
/*/{Protheus.doc} A600FilVis
Filtra 

@sample     A600GrvAloc(  )

@return     ExpL - Verdadeiro		

@author     Serviços
@since      26/08/2014
@version    P12
/*/
//-----------------------------------------------------------------------------------------
Function A600FilVis(aVistoria,oListVist,cFilGet)
Local nI := 0

If !Empty(cFilGet)
	For nI := 1 To Len(aVistoria)
		If aVistoria[nI,2] == cFilGet			
			oListVist:nAt := nI
			Exit
		EndIf 
	Next nI
EndIf	
Return