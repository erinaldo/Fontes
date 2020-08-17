#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Mt100Ok  º Autor ³ Cristiano Figueiroaº Data ³ 07/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica o Fornecedor e a Natureza Informados no Documento º±±
±±º          ³ de Entrada estao na Amarracao Fornecedor x Natureza.       º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³  EM    ³                Motivo                ³Solicitante ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sergio    ³20/06/07³Atendimento ao chamado 002053 para que³Vicente(CTB)³±±
±±³          ³        ³o campo COMPETENCIA seja obrigatorio  ³            ³±±
±±³          ³        ³de acordo com as regras definidas no  ³            ³±±
±±³          ³        ³chamado.                              ³            ³±±
±±³          ³        ³PONTOS DE IMPACTO: Todos os usuarios  ³            ³±±
±±³          ³        ³que digitam nota fiscal de entrada e  ³            ³±±
±±³          ³        ³rotinas automaticas de geracao de no- ³            ³±±
±±³          ³        ³tas fiscais de entrada.               ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Daniel    ³09/04/09³Atendimento ao chamado 0935/09, p/eli-³Maria Elisa ³±±
±±³          ³        ³minar qq possibilidade de gravação de ³  CTB       ³±±
±±³          ³        ³Natureza indevida no D1_NATFULL       ³            ³±± 
±±³ÄÄÄÄÄÄÄÄÄÄ³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±± 
±±³Renato    ³03/08/10³Atendimento ao chamado 2042/10, p/alt-³Donizet Rib ³±±
±±³          ³        ³eração do email cadastros para o email³  CTB       ³±±
±±³          ³        ³donizet.ribeiro@csu.com.br            ³            ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º****** IMPORTANTE ******³ Este programa esta tambem esta sendo chamado º±±
±±º****** IMPORTANTE ******³ atraves do ponto de entrada Mt100Lok.prw.    º±±
±±º****** IMPORTANTE ******³ Qualquer alteracao neste ponto de entrada de-º±±
±±º****** IMPORTANTE ******³ ve-se fazer uma analise de impacto no ponto  º±±
±±º****** IMPORTANTE ******³ de entrada citado.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU CardSystem S.A                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100TOK(pcParam)

Local lRet1      := .T.
Local lRet2      := .T.
Local lRet3      := .T.
Local lRet       := .T.
Local cNaturez     //MaFisRet(,"NF_NATUREZA")
Local _aImpostos   //MaFisRet(,"NF_IMPOSTOS")	// Flavio Novaes em 03/04/07
Local _dFechCont := GETMV("MV_XMESNFE")		    // Flavio Novaes em 03/04/07
Local _aArea     := GETAREA()					// Flavio Novaes em 03/04/07
Local nPosNat    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NATFULL"})
Local nPosCOMP	 := aScan(aHeader,{|x| Upper(Trim(x[2])) == "D1_XDTAQUI" })
Local nOk
Local cTxtBlq
Local _nValTot   := 0         // Sergio em Jun/2007
Local _dDtAqui   := Ctod('')  // Sergio em Jun/2007
Local lJaAvisei := .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³              Chama a funcao que valida a Natureza x Fornecedor             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Sergio Oliveira em Jul/2007: Chamado 002053

If !IsInCallStack("A103Devol") .And. IsInCallStack("MATA103") 

	cNaturez   := MaFisRet(,"NF_NATUREZA")
	_aImpostos := MaFisRet(,"NF_IMPOSTOS")	// Flavio Novaes em 03/04/07
//	_dFechCont := GETMV("MV_XMESNFE")		    // Flavio Novaes em 03/04/07

	If Empty( pcParam )
		
		lRet1 := u_VldNatFor( cNaturez , GetMV("CS_FORNAT") , "01" )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³           Verifca Preenchimento da Natureza do Item (Obrigatorio)          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		For nx:=1 to len(aCols)
			
			If !aCols[nx][Len(aCols[nx])]
				If Empty(aCols[nx][nPosNat])
					Help(' ', 1, 'xNat',,"Informe o campo Natureza (Nos itens da Nota Fiscal).",1,0)
					lRet2 := .F.				
				Else
					// incluído por Daniel G.Jr. em 09/04/09 - Chamado nr. 0935/09
					lRet2 := u_VldNatFor ( aCols[nx][nPosNat] , CA100FOR , CLOJA )
				Endif
				If !lRet2
					Exit
				EndIf
			Endif
			
		Next
		// Incluido por Flavio Novaes em 03/04/07 - Chamado nr. 000000001128
		IF YEAR(M->dDEmissao) < YEAR(dDataBase) .OR.	MONTH(M->dDEmissao) < MONTH(dDataBase)
			FOR _nX := 1 TO LEN(_aImpostos)
				IF 	(ALLTRIM(_aImpostos[_nX][1]) == 'ISS' .AND. _aImpostos[_nX][5] > 0) .OR.;
					(ALLTRIM(_aImpostos[_nX][1]) == 'INS' .AND. _aImpostos[_nX][5] > 0)
					IF SELECT('SZU7') > 0
						dbSelectArea('SZU7')
						dbCloseArea()
					ENDIF
					_cQuery := " SELECT * FROM "+RETSQLNAME('ZU7')
					_cQuery += " WHERE D_E_L_E_T_ = ' ' "
					_cQuery += " AND   ZU7_FORNEC = '"+M->CA100FOR+"' "
					_cQuery += " AND ZU7_LOJA     = '"+M->CLOJA+"' "
					_cQuery += " AND ZU7_ATIVO    = 'T' "
					_cQuery += " AND ZU7_TIPOLI   = '1' "
					TCQUERY _cQuery NEW ALIAS 'SZU7'
					IF EOF()
						lRet3 := .F.
						Aviso("Atenção! Bloqueio ISS/INSS!","O Mês da Data de Emissão da Nota é Inferior ao Mês da Data Base! Com isso, os Impostos de ISS/INSS estarão vencidos! Solicite ao Fornecedor a Troca da NF ou entre em Contato com a Jane Bessa do Depto. Fiscal!",{"Ok"},1,"Solicite Troca NFE!")
					ENDIF
					dbSelectArea('SZU7')
					dbCloseArea()
					IF !lRet3
						EXIT
					ENDIF
				ENDIF
			NEXT
		ENDIF
		
	EndIf // Fim - Sergio Oliveira em Jul/2007: Chamado 002053 - Compatibilizacao da validacao com o
EndIf
	//                                    ponto de entrada por item Mt100Lok.prw

// Incluido por Flavio Novaes em 03/04/07 ate aqui.
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³               Concatena as Variaveis Logica para o Retorno                 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

If lRet1 .AND. lRet2 .AND. lRet3
	lRet := .T.
Else
	lRet := .F.
Endif

// Inicio Sergio em 20/Jun/2007: Validar o campo COMPETENCIA conforme solicitado no chamado 002053:

If Type( 'ParamIxb' ) == 'L'
	lRet := lRet .And. ParamIxb[1] // Sergio em Jun/2007 - Incluir a ParamIxb para considerar a validacao de sistema
EndIf

_nMesFex := StrZero(Year( _dFechCont ),4)+StrZero(Month( _dFechCont ),2) // Mes de Fechamento

If lRet
	For nOk := 1 To Len( aCols )
		If !aCols[nOk][Len(aCols[nOk])] // Se nao estiver deletado considerar
			
			_nMesEmi := StrZero(Year( M->dDEmissao ),4)+StrZero(Month( M->dDEmissao ),2)   // Mes de Emissao
			
			If !'M->D1_XDTAQUI' $ ReadVar()
				_nMesCmp := Right( aCols[nOk][GdFieldPos('D1_XDTAQUI')],4)+Left( aCols[nOk][GdFieldPos('D1_XDTAQUI')],2) // Mes de Competencia
				_dDtAqui := aCols[nOk][GdFieldPos('D1_XDTAQUI')]          // Data da Aquisicao para gravar no email
			Else
				If !Empty( M->D1_XDTAQUI )
					_nMesCmp := Right( M->D1_XDTAQUI,4)+Left( M->D1_XDTAQUI,2)
					_dDtAqui := M->D1_XDTAQUI          // Data da Aquisicao para gravar no email
				Else
					_nMesCmp := Right( aCols[nOk][GdFieldPos('D1_XDTAQUI')],4)+Left( aCols[nOk][GdFieldPos('D1_XDTAQUI')],2) // Mes de Competencia
					_dDtAqui := aCols[nOk][GdFieldPos('D1_XDTAQUI')]          // Data da Aquisicao para gravar no email
				EndIf
			EndIf
			
			If _nMesFex == _nMesEmi .And. _nMesCmp > _nMesEmi .And. _nMesCmp > _nMesFex .And. _nMesCmp > StrZero(Year( dDataBase ),4)+StrZero(Month( dDataBase ),2)
				
				If ! Trim( aCols[nOk][GdFieldPos('D1_NATFULL')] ) $ GetNewPar("MV_X_NATCP","2.1.19.33/2.1.19.34/2.1.19.35/2.1.19.36/2.1.19.37/2.1.11.01")
					cTxtBlq := " Favor incluir este documento no mes da competencia: "+Right(_nMesCmp,2)+'/'+Left(_nMesCmp,4)+". "
					Aviso("Competencia",cTxtBlq,;
					{"&Fechar"},3,"COMPETENCIA DO MES POSTERIOR",,;
					"PCOLOCK")
					lRet := .f.
					Exit
				EndIf
				
			ElseIf _nMesFex == _nMesEmi .And. _nMesCmp == _nMesEmi .And. _nMesCmp == _nMesFex .And. _nMesCmp < StrZero(Year( dDataBase ),4)+StrZero(Month( dDataBase ),2)
				
				// 12/2006     ( Mes/Ano Anterior )
				// 01/2007     ( Mes/Ano Atual )
				
				_nMesDia := Month( Date() )
				_nAno    := Year( Date() )
				
				If _nMesDia == 1
					_nMesDia := 12
					_nAno    -= 1
				Else
					_nMesDia -= 1
				EndIf
				
				_dDescDt := LastDay( Ctod( '01'+'/'+StrZero(_nMesDia,2)+'/'+StrZero( _nAno,4 ) ) )
				
				// Deve ser o ultimo dia util do mes anterior. Somente ajustar a data caso a data obtida
				// nao seja uma data valida:
				
				If DataValida( _dDescDt ) # _dDescDt
					
					_nLoop := 1
					
					For _xy := 6 To 1 Step -1
						If Month( DataValida( _dDescDt - _nLoop ) ) == Month( _dDescDt )
							_dDescDt -= _nLoop
							Exit
						EndIf
						_nLoop ++
					Next
					
				EndIf
				
				cTxtBlq := " Favor incluir este documento no ultimo dia util do mes anterior ("+Dtoc(_dDescDt)+"). "
				Aviso("Competencia",cTxtBlq,;
				{"&Fechar"},3,"COMPETENCIA DO MES ANTERIOR",,;
				"PCOLOCK")
				lRet := .f.
				Exit
				
			ElseIf _nMesCmp < _nMesEmi .And. _nMesFex == _nMesEmi .And. _nMesFex > StrZero(Year( dDataBase ),4)+StrZero(Month( dDataBase ),2)
				
				cTxtBlq := " Favor alterar a data base do sistema para o dia atual ("+Dtoc(Date())+"). "
				Aviso("Competencia",cTxtBlq,;
				{"&Fechar"},3,"PERIODO FECHADO",,;
				"PCOLOCK")
				lRet := .f.
				Exit
				
			ElseIf _nMesCmp == _nMesEmi .And. _nMesEmi < _nMesFex .And. _nMesFex > StrZero(Year( dDataBase ),4)+StrZero(Month( dDataBase ),2)
				
				cTxtBlq := " Favor alterar a data base do sistema para o dia atual ("+Dtoc(Date())+"). "
				Aviso("Competencia",cTxtBlq,;
				{"&Fechar"},3,"PERIODO FECHADO",,;
				"PCOLOCK")
				lRet := .f.
				Exit
				
				//    4            7              6         4                6          7
			ElseIf _nMesCmp <= _nMesFex .And. _nMesEmi > _nMesFex .And. _nMesFex < StrZero(Year( dDataBase ),4)+StrZero(Month( dDataBase ),2)
				
				// Neste caso notificar tanto o usuario logado quanto o pessoal da contabilidade
				
				_nValTot += aCols[nOk][GdFieldPos('D1_TOTAL')] -= aCols[nOk][GdFieldPos('D1_VALDESC')]
				
			Else
				
				// Verificar a competencia x parametro de fechamento:
				
				// 12/2006     ( Mes/Ano Anterior )
				// 01/2007     ( Mes/Ano Atual )
				
				_nMesDia := Month( Date() )
				_nAno    := Year( Date() )
				
				If _nMesDia == 1
					_nMesDia := 12
					_nAno    -= 1
				Else
					_nMesDia -= 1
				EndIf
				
				_dDescDt := LastDay( Ctod( '01'+'/'+StrZero(_nMesDia,2)+'/'+StrZero( _nAno,4 ) ) )
				
				// Deve ser o ultimo dia util do mes anterior. Somente ajustar a data caso a data obtida
				// nao seja uma data valida:
				
				If DataValida( _dDescDt ) # _dDescDt
					
					_nLoop := 1
					
					For _xy := 6 To 1 Step -1
						If Month( DataValida( _dDescDt - _nLoop ) ) == Month( _dDescDt )
							_dDescDt -= _nLoop
							Exit
						EndIf
						_nLoop ++
					Next
					
				EndIf
				
				If _nMesCmp <= _nMesFex .And. StrZero(Year( dDataBase ),4)+StrZero(Month( dDataBase ),2) > _nMesFex
					cTxtBlq := " Favor incluir este documento no ultimo dia util do mes anterior ("+Dtoc(_dDescDt)+"). "
					Aviso("Competencia",cTxtBlq,;
					{"&Fechar"},3,"COMPETENCIA DO MES ANTERIOR",,;
					"PCOLOCK")
					lRet := .f.
				EndIf
				
			EndIf
			
		EndIf
	Next
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 0176/09: Utilizar o TES cujo pedido tiver a condicao de pagamento relacionada na tabela  ³
³             ZA5. Se algum TES estiver diferente, nao permitir a inclusao da NFE:            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If lRet
	
	If AliasInDic("ZA5",.t.)
		
		If Select('ZA5') == 0
			ChkFile('ZA5')
		EndIf
		
		ZA5->( DbsetOrder(3) ) // ZA5_FILIAL+ZA5_COND
		SC7->( DbSetOrder(1) )
		
		For wXP := 1 To Len( aCols )
			If aCols[wXP][Len(aHeader)+1]
				Loop
			EndIf
			/*
			Alert(' SC7->( DbSeek( xFilial("SC7")+aCols[wXP][GdFieldPos("D1_PEDIDO")] ) ) => '+IIF(SC7->( DbSeek( xFilial("SC7")+aCols[wXP][GdFieldPos("D1_PEDIDO")] ) ),".t.",".f.")+Chr(13);
			+' ZA5->( DbSeek( xFilial("ZA5")+SC7->C7_COND ) ) => '+IIF(ZA5->( DbSeek( xFilial("ZA5")+SC7->C7_COND ) ),".t.",".f.")+Chr(13);
			+' aCols[wXP][GdFieldPos("D1_TES")] => '+aCols[wXP][GdFieldPos("D1_TES")]+Chr(13)+Chr(10);
			+' ZA5->ZA5_TES => '+ZA5->ZA5_TES+Chr(13)+Chr(10);
			+' aCols[wXP][GdFieldPos("D1_TES")] # ZA5->ZA5_TES => '+IIF(aCols[wXP][GdFieldPos("D1_TES")] # ZA5->ZA5_TES,".t.",".f.")+Chr(13)+Chr(10);
			+' aCols[wXP][GdFieldPos("D1_NATFULL")] => '+aCols[wXP][GdFieldPos("D1_NATFULL")]+Chr(13)+Chr(10);
			+' !Empty(aCols[wXP][GdFieldPos("D1_NATFULL")]) '+IIF( !Empty(aCols[wXP][GdFieldPos("D1_NATFULL")]),".t.",".f." )+Chr(13)+Chr(10);
			+' aCols[wXP][GdFieldPos("D1_XDTAQUI")] => '+aCols[wXP][GdFieldPos("D1_XDTAQUI")]+Chr(13)+Chr(10);
			+' !Empty(aCols[wXP][GdFieldPos("D1_XDTAQUI")]) => '+IIF( !Empty(aCols[wXP][GdFieldPos("D1_XDTAQUI")]),".t.",".f." )+Chr(13)+Chr(10);
			+' cNatureza => '+cNatureza+Chr(13)+Chr(10);
			+' ZA5->ZA5_NATURE '+ZA5->ZA5_NATURE+Chr(13)+Chr(10);
			+' !Empty(ZA5->ZA5_NATURE) => '+IIF( !Empty(ZA5->ZA5_NATURE),".t.",".f." )+Chr(13)+Chr(10);
			+' cNatureza # ZA5->ZA5_NATURE => '+IIF( cNatureza # ZA5->ZA5_NATURE,".t.",".f." ) )
			*/
			If SC7->( DbSeek( xFilial('SC7')+aCols[wXP][GdFieldPos("D1_PEDIDO")] ) ) .And.;
				ZA5->( DbSeek( xFilial('ZA5')+SC7->C7_COND ) ) .And. aCols[wXP][GdFieldPos("D1_TES")] # ZA5->ZA5_TES .And.;
				!Empty(aCols[wXP][GdFieldPos("D1_NATFULL")]) .And. !Empty(aCols[wXP][GdFieldPos("D1_XDTAQUI")])
				
				If ZA5->( DbSetOrder(4), DbSeek( xFilial('ZA5')+aCols[wXP][GdFieldPos("D1_NATFULL")] ) ) .And. aCols[wXP][GdFieldPos("D1_TES")] # ZA5->ZA5_TES
				
					cTxtBlq := "PROBLEMA: Para esta condição de pagamento ["+SC7->C7_COND+"] deve-se utilizar o TES "+ZA5->ZA5_TES+" que está relacionado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
					cTxtBlq += "SOLUÇÃO: Nos Itens, informe primeiro a Natureza!"
					Aviso("ATIVO",cTxtBlq,;
					{"&Fechar"},3,"TES de Ativo",,;
					"PCOLOCK")
					
					RestArea(_aArea)
					Return( .f. )
				EndIf	
			Else
				If !IsInCallStack("MATA140")
					If ZA5->( DbSetOrder(4), DbSeek( xFilial('ZA5')+aCols[wXP][GdFieldPos("D1_NATFULL")] ) ) .And. aCols[wXP][GdFieldPos("D1_TES")] # ZA5->ZA5_TES
					
						cTxtBlq := "PROBLEMA: Para esta Natureza ["+aCols[wXP][GdFieldPos("D1_NATFULL")]+"] deve-se utilizar o TES "+ZA5->ZA5_TES+" que está relacionado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
						cTxtBlq += "SOLUÇÃO: Nos Itens, informe primeiro a Natureza!"
						Aviso("ATIVO",cTxtBlq,;
						{"&Fechar"},3,"TES de Ativo",,;
						"PCOLOCK")
					
						RestArea(_aArea)
						Return( .f. )
					EndIf
				EndIf
			EndIf
		Next
		
	EndIf
EndIf

If _nValTot > 0 .And. Empty( pcParam )
	EnvMail(_nValTot, _dDtAqui)
EndIf

RestArea(_aArea) // Flavio Novaes em 03/04/07

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³EnvMail   ºAutor  ³ Sergio Oliveira    º Data ³  Jun/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Notificar a contabilidade e o usuario logado conforme a si-º±±
±±º          ³tuacao que solicita esta funcao.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mt100Tok.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnvMail(pnValTot, pdDtAki)

Local cIni := ''
Private _cHtmTxt := RetHtmTxt( pnValTot, pdDtAki )

If 'DESENVOLVIMENTO' $ Upper( GetEnvServer() )
	cTo	:= 'a@a.com'
Else // Tanto na homologacao quanto producao tem q ir ao usuario devido
	If 'HOMOLOGA' $ Upper( GetEnvServer() )
		cIni := "Teste de Homologação - "
	EndIf
	//cTo  := "maria.moreira@csu.com.br;wilcione.fernandes@csu.com.br"
   //	cTo  := "donizet.ribeiro@csu.com.br" // OS 2042/10
	cTo  := "gabriel.goes@csu.com.br;felipe@csu.com.br"// OS 2380/10
EndIf

oProcess          	:= TWFProcess():New( "000001", "Notificacao de NFE" )
oProcess          	:NewTask( "Envio NFE", "\workflow\html\NFENotif.htm" )
oProcess:cSubject 	:= cIni+'NFE | Competencia x Data Base '+xFilial('SF1')+' - '+cNFiscal+' / '+cSerie
oProcess:cTo      	:= cTo
oProcess:cCC      	:= UsrRetMail(__cUserId)
oProcess:UserSiga	:= __cUserId
oProcess:NewVersion(.T.)
oHtml     			:= oProcess:oHTML

oHtml:ValByName( "CORPO"	   , _cHtmTxt )

oProcess:Start()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³EnvMail   ºAutor  ³ Sergio Oliveira    º Data ³  Jun/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Notificar a contabilidade e o usuario logado conforme a si-º±±
±±º          ³tuacao que solicita esta funcao.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mt100Tok.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetHtmTxt( pnValTot, pdDtAki )

_cHtmTxt := ' <table width="96%" border="1" cellpadding="6" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" > '
_cHtmTxt += '   <tr> '
_cHtmTxt += '    <td width="100%" height="162" bordercolor="#FFFFFF" class="titulo"><table border="0" cellpadding="2" cellspacing="1" width="100%">'
_cHtmTxt += '      <tr bordercolor="#000000" bgcolor="#CCCCCC">'
_cHtmTxt += '        <td width="50%" colspan="3" bgcolor="#EBEBEB" class="TituloMenor"><div align="center" class="style14"><span class="FonteMenu">Aten&ccedil;&atilde;o !!!</span></div>          <div align="center"></div></td>'
_cHtmTxt += '        </tr>'
_cHtmTxt += '      <tr bordercolor="#000000">'
_cHtmTxt += '        <td colspan="3" class="TituloMenor"><span class="FonteMenu">O referido documento abaixo foi digitado com data diferente da sua compet&ecirc;ncia.   Favor provisiona-lo atrav&eacute;s da Rotina - (&nbsp;Compras / Atualiza&ccedil;&atilde;o / Provis&atilde;o ). </span></td>'
_cHtmTxt += '        </tr>'
_cHtmTxt += '      <tr bordercolor="#000000">'
_cHtmTxt += '        <td colspan="3" class="TituloMenor"><span class="FonteMenu">Para os   pr&oacute;ximos meses,&nbsp;voc&ecirc; dever&aacute; solicitar ao fornecedor que emita o documento fiscal&nbsp;&nbsp;dentro do m&ecirc;s de compet&ecirc;ncia.</span></td>'
_cHtmTxt += '        </tr>      '
_cHtmTxt += '        <tr>'
_cHtmTxt += '          <td class="TituloMenor"><div align="center"></div></td>'
_cHtmTxt += '        </tr>'
_cHtmTxt += '      </table>'
_cHtmTxt += '      <table border="0" cellspacing="1" width="100%">'
_cHtmTxt += '        <tr bgcolor="#E4E4E4" class="TituloMenor">'
_cHtmTxt += '          <td width="6%"  align="center"><STRONG>Documento</STRONG></td>'
_cHtmTxt += '          <td width="6%"  align="center"><STRONG>Emiss&atilde;o</STRONG></td>'
_cHtmTxt += '          <td width="10%" align="center"><STRONG>Competência </STRONG></td>'
_cHtmTxt += '          <td width="6%" align="center" bgcolor="#E4E4E4"><STRONG>Cod./Loja Fornec. </STRONG></td>'
_cHtmTxt += '          <td width="38%" align="center"><STRONG>Nome do Fornecedor </STRONG></td>'
_cHtmTxt += '          <td width="12%" align="center"><STRONG>Site</STRONG></td>'
_cHtmTxt += '          <td width="11%" align="center"><STRONG>Valor</STRONG></td>'
_cHtmTxt += '          <td width="17%" align="center"><STRONG>Solicitante</STRONG></td>'
_cHtmTxt += '        </tr>'
_cHtmTxt += '        <tbody>'
_cHtmTxt += '          <tr bgcolor="#FFFFFF" class="texto-layer">'
_cHtmTxt += '            <td height="1"><div align="center">'+cNFiscal+'</div></td>'
_cHtmTxt += '            <td height="1"><div align="center">'+Dtoc(M->dDemissao)+'</div></td>'
_cHtmTxt += '            <td height="1"><div align="center">'+pdDtAki+'</div></td>'
_cHtmTxt += '            <td height="1"><div align="center">'+cA100For+'/'+cLoja+'</div></td>'
_cHtmTxt += '            <td height="1"><div align="center">'+Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_NOME")+'</div></td>'
_cHtmTxt += '            <td height="1"><div align="center">'+Posicione("SM0",1,cEmpAnt+xFilial("SF1"),"M0_FILIAL")+'</div></td>'
_cHtmTxt += '            <td height="1"><div align="center">'+Transform( pnValTot, PesqPict("SD1","D1_TOTAL") )+'</div></td>'
_cHtmTxt += '            <td height="1"><div align="center">'+UsrFullName( __cUserId )+'</div></td>'
_cHtmTxt += '          </tr>'
_cHtmTxt += '          <tr>'
_cHtmTxt += '            <td colspan="7" class="texto-layer" background="http://200.246.142.245:80/workflow/FIGURAS/pontilhado.gif"><span class="TituloMenor"><img src="http://200.246.142.245:80/workflow/FIGURAS/transparente.gif" width="10" height="3"></span></td>'
_cHtmTxt += '          </tr>'
_cHtmTxt += '        </tbody>'
_cHtmTxt += '      </table>'
_cHtmTxt += '    </td>'
_cHtmTxt += '  </tr>'
_cHtmTxt += '</table>'
_cHtmTxt += '<table width="96%" border="1" align="LEFT" cellpadding="6" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" >'
_cHtmTxt += '  <tr>'
_cHtmTxt += '    <td width="100%" bordercolor="#FFFFFF" class="titulo"><p class="style20">Qualquer d&uacute;vida entre em contato   com:</p>'
_cHtmTxt += '      <p class="style20">Contabilidade</p>'
_cHtmTxt += '      <span class="style20">Gabriel Moreira - </span><A href="mailto:gabriel.goes@csu.com.br" class="style21"><U>gabriel.goes@csu.com.br</U></A><span class="style20">&nbsp;Tel.: (11) 2627-8750&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span> '// OS 2380/10 e OS 1081/13
_cHtmTxt += '      <span class="style20">Felipe Silva - </span><A href="mailto:felipe@csu.com.br" class="style21"><U>felipe@csu.com.br</U></A><span class="style20">&nbsp;Tel.: (11) 2627-8841&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span> '// OS 2380/10 e OS 1081/13
//_cHtmTxt += '      <span class="style20">Donizet Ribeiro - </span><A href="mailto:donizet.ribeiro@csu.com.br" class="style21"><U>maria.moreira@csu.com.br</U></A><span class="style20">&nbsp;Tel.: (11) 2106-3983&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span> '// OS 2042/10
//_cHtmTxt += '      <span class="style20">Maria Elisa - </span><A href="mailto:maria.moreira@csu.com.br" class="style21"><U>maria.moreira@csu.com.br</U></A><span class="style20">&nbsp;Tel.: (11) 2106-3983&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span> '
_cHtmTxt += '      <p class="style20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; ou</p> '
//_cHtmTxt += '      <p class="style20">Wilcione - <A href="mailto:wilcione.fernandes@csu.com.br" class="style21"><U>wilcione.fernandes@csu.com.br</U></A>&nbsp;Tel.:   (11) 2106-3996</p>      <p>&nbsp;</p> '
_cHtmTxt += '    </td> '
_cHtmTxt += '  </tr> '
_cHtmTxt += '</table> '

Return( _cHtmTxt )