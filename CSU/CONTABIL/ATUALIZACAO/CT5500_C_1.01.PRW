User Function CT5500_C()

// *** ExecBlock CT5500_C.
// *** Data: 24/06/2002
// *** Objetivo: Pesquisar no arquivo SZ1 (Conf. Natureza Financeira X C.Contabil) a
// Conta Contabil a ser creditada na provisao dos titulos a receber.
// *** Cliente: CSU Cardsystem.
// *** Ponto de disparo: LP 500 e LP 505.

_cArea  := GetArea()
_cConta := "INF. C. CONTABIL"

// Posiciona na tabela de Natureza.
DbSelectArea("SED")
DbSetOrder(1)
DbSeek( xFilial()+SE1->E1_NATUREZ )
	
// Posiciona o SZ1.
DbSelectArea("SZ1")
DbSetOrder(1)
DbSeek( xFilial()+SE1->E1_NATUREZ,.F. )
	
If Found().and. SZ1->Z1_NATUREZ==SE1->E1_NATUREZ
	_cConta := If(!Empty(SZ1->Z1_CCONTAB),SZ1->Z1_CCONTAB,_cConta)
EndIf

RestArea(_cArea)

Return _cConta