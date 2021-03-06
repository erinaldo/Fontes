User Function CT5620B()

// ExecBlock CT5620B.
// Data: 21/05/2002
// Objetivo: Buscar a conta contabil referente ao cliente no arquivo SZ2.
// Ponto de Disparo: Lan�amento Padr�o 620 (Cabe�alho NF de Sa�da). 
// Cliente: CSU Cardsystem.

_cArea := Alias()
_cConta := "INFORMAR C.CLIENTE"

DbSelectArea("SZ2")
Dbsetorder(1)
DbSeek( xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA,.f. ) 

If Found()
	_cConta := SZ2->Z2_CONTA
EndIf

DbSelectArea(_cArea)

Return _cConta