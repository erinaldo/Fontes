User Function CT5510VL(_cFlg)

// *** ExecBlock CT5510VL.
// *** Data: 19/06/2002
// *** Objetivo: Pesquisar no arquivo SZ6 (Rateios por CC X Titulos a Pagar) o
// valor a ser lancado a debitado na provisao dos titulos a pagar. Isto quando
// existir rateio para o titulo a pagar em questao.
// *** Cliente: CSU Cardsystem.
// *** Ponto de disparo: LP 510 e LP 515

_cArea  := GetArea()
_nValor := 0.0
_lAchou := .f.

// Verifica / posiciona no registro de rateio a tratar no SZ6.

DbSelectArea("SZ6")
DbSetOrder(1)
DbSeek( xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO;
+SE2->E2_FORNECE+SE2->E2_LOJA )

While !Eof().and._lAchou==.f..and.(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO == SZ6->Z6_PREFIXO+SZ6->Z6_NUMERO+SZ6->Z6_PARCELA+SZ6->Z6_TIPO)
	
	If _cFlg == "I" .AND. Empty(Subs(SZ6->Z6_LA,2,1))
	//Trata contabilizacao da inclusao 
		_nValor := SZ6->Z6_VALOR
		_lAchou := .t.
		
		Reclock("SZ6",.F.)
		SZ6->Z6_LA := Subs(SZ6->Z6_LA,1,1)+"S"+Subs(SZ6->Z6_LA,3,1)
		MsUnlock()
		
	ElseIf _cFlg == "E" .AND. Empty(Subs(SZ6->Z6_LAEXC,2,1))
	//Trata contabilizacao da exclusao		
		_nValor := SZ6->Z6_VALOR
		_lAchou := .t.
		
		Reclock("SZ6",.F.)
		SZ6->Z6_LAEXC := Subs(SZ6->Z6_LAEXC,1,1)+"S"+Subs(SZ6->Z6_LAEXC,3,1)
		MsUnlock()
	EndIf
	DbSkip()
EndDo

RestArea(_cArea)

Return _nValor
