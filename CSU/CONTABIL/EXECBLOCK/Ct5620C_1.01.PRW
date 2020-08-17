User Function CT5620C()

// ExecBlock CT5620B.
// Data: 21/05/2002
// Objetivo: Buscar a conta contabil referente ao cliente no arquivo SZ2.
// Ponto de Disparo: Lançamento Padrão 620 (Cabeçalho NF de Saída). 
// Cliente: CSU Cardsystem.
// MTdO - NOV./2004 - ADEQUADO PARA NOVA VISÃO (SZ2) POR AREA DE NEGOCIO

_cArea := Alias()
_cConta := "INFORMAR C.CLIENTE"

DbSelectArea("SZ2")
Dbsetorder(1)
DbSeek( xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_CODAREA,.f. ) 

If Found()
	_cConta := SZ2->Z2_CONTA
EndIf

DbSelectArea(_cArea)

Return _cConta