User Function CT5510CC(_cFlg)

// *** ExecBlock CT5510CC.
// *** Data: 19/06/2002
// *** Objetivo: Pesquisar no arquivo SZ6 (Rateios por CC X Titulos a Pagar) o
// Centro de Custo a ser debitado na provisao dos titulos a pagar. Isto quando
// existir rateio para o titulo a pagar em questao.
// *** Cliente: CSU Cardsystem.
// *** Ponto de disparo: LP 510 e LP 515

_cArea   := GetArea()
_cCCusto := ""
            
// Posiciona na tabela de Natureza Financeira.
DbSelectArea("SED")
DbSetOrder(1)
DbSeek( xFilial()+SE2->E2_NATUREZ )

// Verifica / posiciona no registro de rateio a tratar no SZ6.

_lAchou := .f.
		
DbSelectArea("SZ6")
DbSetOrder(1)
DbSeek( xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+;
SE2->E2_FORNECE+SE2->E2_LOJA )
		
While !Eof().and._lAchou==.f..and.(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO == SZ6->Z6_PREFIXO+SZ6->Z6_NUMERO+SZ6->Z6_PARCELA+SZ6->Z6_TIPO)
		
    If _cFlg == "I" .AND. Empty(Subs(SZ6->Z6_LA,3,1))
	//Trata contabilizacao da inclusao 
		_lAchou := .t.
		
		If SED->ED_RECDEP == "D" .and. SE2->E2_RATCSU == "S"
			_cCCusto := SZ6->Z6_CC
		EndIf
				
		Reclock("SZ6",.F.)
		SZ6->Z6_LA := Subs(SZ6->Z6_LA,1,2)+"S"
		MsUnlock()	
		
		
	ElseIf _cFlg == "E" .AND. Empty(Subs(SZ6->Z6_LAEXC,3,1))
	//Trata contabilizacao da exclusao 
		_lAchou := .t.
		
		If SED->ED_RECDEP == "D" .and. SE2->E2_RATCSU == "S"
			_cCCusto := SZ6->Z6_CC
		EndIf
				
		Reclock("SZ6",.F.)
		SZ6->Z6_LAEXC := Subs(SZ6->Z6_LAEXC,1,2)+"S"
		MsUnlock()	
	EndIf
	
	DbSkip()							
		
End

RestArea(_cArea)

Return _cCCusto