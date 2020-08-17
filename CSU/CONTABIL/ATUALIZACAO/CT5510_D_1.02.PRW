User Function CT5510_D(_cFlg)

// *** ExecBlock CT5510_D.
// *** Data: 19/06/2002
// *** Objetivo: Pesquisar no arquivo SZ1 (Conf. Natureza Financeira X C.Contabil) a
// Conta Contabil a ser debitada na provisao dos titulos a pagar.
// Cliente: CSU Cardsystem.
// *** Ponto de disparo: LP 510 e LP 515.

_cArea  := GetArea()
_cConta := "INF. C.DESP./PATRIM."

// Posiciona na tabela de Natureza.
DbSelectArea("SED")
DbSetOrder(1)
DbSeek( xFilial()+SE2->E2_NATUREZ )

IF SED->ED_RECDEP == "D"
	// Se a natureza em questão for de DESPESA, considera o grupo do Centro de Custo
	// na pesquisa da respectiva conta contabil na tabela SZ1.
	
	IF SE2->E2_RATCSU <> "S"
		// Bloco de tratamento para titulos a pagar que NAO POSSUEM rateio por CC.
		
		// Posiciona o CTT.
		DbSelectArea("CTT")
		DbSetOrder(1)
		DbSeek( xFilial()+SE2->E2_CCUSTO,.F. )
		
		If Found()
			
			// Posiciona o SZ1.
			DbSelectArea("SZ1")
			DbSetOrder(1)
			DbSeek( xFilial()+SE2->E2_NATUREZ+CTT->CTT_GRUPO,.F. )
			
			If Found().and. SZ1->Z1_NATUREZ==SE2->E2_NATUREZ .and. SZ1->Z1_GRUPOCC==CTT->CTT_GRUPO
				_cConta := If(!Empty(SZ1->Z1_CCONTAB),SZ1->Z1_CCONTAB,_cConta)
			EndIf
			
		EndIf
		
	Else
		// Bloco de tratamento para titulos a pagar que POSSUEM rateio por CC.
		
		// Busca registro de rateio a tratar no SZ6.
		_lAchou := .f.
		
		DbSelectArea("SZ6")
		DbSetOrder(1)
		DbSeek( xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+;
		SE2->E2_FORNECE+SE2->E2_LOJA )
		
		While !Eof().and._lAchou==.f..and.(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO == SZ6->Z6_PREFIXO+SZ6->Z6_NUMERO+SZ6->Z6_PARCELA+SZ6->Z6_TIPO)
			
			If _cFlg == "I" .AND. Empty(Subs(SZ6->Z6_LA,1,1))
			//Trata contabilizacao da inclusao 				
				_lAchou  := .t.
				_cCCusto := SZ6->Z6_CC
				Reclock("SZ6",.F.)
				SZ6->Z6_LA := "S"+Subs(SZ6->Z6_LA,2,2)
				MsUnlock()
				
			ElseIf _cFlg == "E" .AND. Empty(Subs(SZ6->Z6_LAEXC,1,1))
			//Trata contabilizacao da exclusao
				_lAchou  := .t.
				_cCCusto := SZ6->Z6_CC
				Reclock("SZ6",.F.)
				SZ6->Z6_LAEXC := "S"+Subs(SZ6->Z6_LAEXC,2,2)
				MsUnlock()
				
			EndIf
			
			DbSkip()
			
		End
		
		If _lAchou == .t.
			
			// Posiciona o CTT.
			DbSelectArea("CTT")
			DbSetOrder(1)
			DbSeek( xFilial()+_cCCusto )
			
			If Found()
				
				// Posiciona o SZ1.
				DbSelectArea("SZ1")
				DbSetOrder(1)
				DbSeek( xFilial()+SE2->E2_NATUREZ+CTT->CTT_GRUPO,.F. )
				
				If Found().and. SZ1->Z1_NATUREZ==SE2->E2_NATUREZ .and. SZ1->Z1_GRUPOCC==CTT->CTT_GRUPO
					_cConta := If(!Empty(SZ1->Z1_CCONTAB),SZ1->Z1_CCONTAB,_cConta)
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
Else
	
	// Se a natureza em questão NAO for de DESPESA, ou seja, for de RECEITA ou
	// PATRIMONIAL, nao considera o grupo do Centro de Custo na pesquisa da
	// respectiva conta contabil na tabela SZ1. Pega diretamente a Conta Contabil.
	
	// Posiciona o SZ1.
	DbSelectArea("SZ1")
	DbSetOrder(1)
	DbSeek( xFilial()+SE2->E2_NATUREZ,.F. )
	
	If Found().and. SZ1->Z1_NATUREZ==SE2->E2_NATUREZ
		_cConta := If(!Empty(SZ1->Z1_CCONTAB),SZ1->Z1_CCONTAB,_cConta)
	EndIf
	
EndIf

RestArea(_cArea)

Return _cConta
