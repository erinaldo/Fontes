User Function CT5_CLI(_cFlag)

// *** ExecBlock CT5_CLI.
// *** Data: 24/06/2002
// *** Objetivo: Buscar a conta contabil referente ao cliente no arquivo SZ2.
// *** Ponto de Disparo: Lancamentos Padroes 500, 505, 520, 527, 620 e 635. 
// *** Cliente: CSU Cardsystem.

_cArea  := GetArea()
_cConta := "INFORMAR C.CLIENTE"
                
If _cFlag == "FT"
	_cChave := xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA
ElseIf _cFlag == "CR"
	_cChave := xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA
EndIf

DbSelectArea("SZ2")
Dbsetorder(1)
DbSeek( _cChave,.f. )

If Found()
	_cConta := SZ2->Z2_CONTA
EndIf

RestArea(_cArea)

Return _cConta